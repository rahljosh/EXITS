<cfif not IsDefined('FORM.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="check_state" datasource="MySql">
	SELECT statechoiceid, studentid, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
</cfquery>

<cfquery name="qCheckCityChoice" datasource="MySql">
	SELECT 
    	citychoiceid
	FROM 
    	smg_student_app_city_requested
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
</cfquery>

<cftransaction action="begin" isolation="serializable">
<cftry>
	
	<cfif CLIENT.companyID EQ 14>
     	
		<!--- Exchange Service International Application --->
		<cfif qCheckCityChoice.recordcount>
            <cfquery name="update_city" datasource="MySql">
                UPDATE 
                    smg_student_app_city_requested
                SET	    
                    city1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city1#">,
                    city2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city2#">,
                    city3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city3#">
                WHERE 
                    citychoiceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckCityChoice.citychoiceid#">
                LIMIT 1
            </cfquery>
		 <cfelse>
            <cfquery name="insert_city" datasource="MySql">
                INSERT INTO 
                	smg_student_app_city_requested
                    (
                        studentid, 
                        city1, 
                        city2, 
                        city3
                    )
                VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city1#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city2#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city3#">
                     )
            </cfquery>
    	</cfif>
        
    <cfelse>
    	<!--- REGULAR APPLICATION --->
    
		<cfif IsDefined('FORM.state_select')>
            <cfif check_state.recordcount EQ '0'>
                <!--- INSERT CHOICES ---->
                <cfquery name="insert_state" datasource="MySql">
                    INSERT INTO smg_student_app_state_requested
                        (studentid, state1, state2, state3)
                    VALUES ('#FORM.studentid#', '#FORM.state1#', '#FORM.state2#', '#FORM.state3#')
                </cfquery>
            <cfelse>
                <!--- UPDATE CHOICES --->
                <cfquery name="update_state" datasource="MySql">
                    UPDATE smg_student_app_state_requested
                    SET	<cfif FORM.state_select EQ 'NO'>
                            state1 = '0',
                            state2 = '0',
                            state3 = '0'
                        <cfelse>
                            state1 = '#FORM.state1#',
                            state2 = '#FORM.state2#',
                            state3 = '#FORM.state3#'
                        </cfif>
                    WHERE statechoiceid = '#check_state.statechoiceid#'
                    LIMIT 1
                </cfquery>
            </cfif>
        <!--- <cfif IsDefined('FORM.region_choice')>app_region_guarantee = '#FORM.region_choice#'<cfelse>app_region_guarantee = 0</cfif> --->	
        </cfif>
    </Cfif>
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section4/page21&id=4&p=21");
	<cfelse>
		location.replace("?curdoc=section4/page22&id=4&p=22");
	</cfif>
	//-->
	</script>
	</head>
	</html>	

	<cfcatch type="any">
		<cfinclude template="../email_error.cfm">
	</cfcatch>
</cftry>
	
</cftransaction>