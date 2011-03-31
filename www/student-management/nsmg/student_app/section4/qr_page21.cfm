<cfif not IsDefined('FORM.studentID')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="check_state" datasource="MySql">
	SELECT statechoiceid, studentID, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
</cfquery>

<cftransaction action="begin" isolation="serializable">
<cftry>
	
	<cfif CLIENT.companyID EQ 14>

        <cfquery name="qCheckCanadaChoice" datasource="MySql">
            SELECT 
                ID
            FROM 
                smg_student_app_options
            WHERE 
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
            AND
                fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIAreaChoice">
        </cfquery>
     	
		<!--- Exchange Service International Application --->
		<cfif qCheckCanadaChoice.recordcount>
            <cfquery datasource="MySql">
                UPDATE 
                    smg_student_app_options
                SET	    
                    option1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.option1#">,
                    option2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.option2#">,
                    option3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.option3#">
                WHERE 
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckCanadaChoice.ID#">
                LIMIT 1
            </cfquery>
		 <cfelse>
            <cfquery datasource="MySql">
                INSERT INTO 
                	smg_student_app_options
                    (
                        studentID,
                        fieldKey, 
                        option1, 
                        option2, 
                        option3,
                        dateCreated
                    )
                VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIAreaChoice">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.option1#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.option2#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.option3#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
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
                        (studentID, state1, state2, state3)
                    VALUES ('#FORM.studentID#', '#FORM.state1#', '#FORM.state2#', '#FORM.state3#')
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