<CFIF not isdefined("form.school")>
	<CFSET form.school = "0">
</cfif>

<!--- IF THERE'S NO INFORMATION, NOTHING IS INSERTED --->
<cfif FORM.name IS '' AND FORM.address IS '' AND FORM.city IS ''>
	
    <cflocation url="?curdoc=forms/host_fam_pis_6" addtoken="no">

<cfelse>
	<!--- ADD NEW SCHOOL --->
	<cfif form.school EQ 0>  
		<cfquery name="check_new_school" datasource="#APPLICATION.DSN#">
			SELECT 
            	schoolid,
                schoolname
			FROM 
            	smg_schools 
			WHERE 
            	schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">
			AND	
            	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">
			AND 
            	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">
		</cfquery>
		
		<cfif check_new_school.recordcount is not 0><br>
			<table width="540" align="center">
			<tr><td align="center"><h3>Sorry, but this school has been entered in the database as follow:</h3></td></tr>
			<tr><td align="center"><cfoutput query="check_new_school">
				<a href="?curdoc=forms/school_app_1&schoolid=#schoolid#">School: &nbsp; #schoolname# (ID: #schoolid#) - #city#/#state#</cfoutput></a><br><br></td></tr>
			<tr><td align="center"><input type="image" value="back" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
			</table>
			<cfabort> 
		</cfif>
			
		<cftransaction action="begin" isolation="SERIALIZABLE">
			<cfquery name="insert_school" datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                    	smg_schools 
                    (	
                    	companyID,
                        schoolname, 
                        address, 
                        address2, 
                        city, 
                        state, 
                        zip, 
                        principal, 
                        email, 
                        phone, 
                        fax, 
                        url
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#" null="#yesNoFormat(TRIM(FORM.address2) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.principal#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#" null="#yesNoFormat(TRIM(FORM.email) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#" null="#yesNoFormat(TRIM(FORM.fax) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.url#" null="#yesNoFormat(TRIM(FORM.url) EQ '')#">
                    )  
			</cfquery>
		
			<cfquery name="schoolid" datasource="#APPLICATION.DSN#"> <!--- get the newest school --->
				SELECT MAX(schoolid) as newschoolid
				FROM smg_schools
			</cfquery>
		</cftransaction>
		<cfset client.schoolid = #schoolid.newschoolid#>

	<!--- UPDATE SCHOOL INFORMATION --->	
	<cfelse>  
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="update_school" datasource="#APPLICATION.DSN#">
				UPDATE
                	smg_schools
				SET
                	schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
					address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
					address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#">,
					city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
					state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
					zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
					phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
					fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
					email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
					url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.url#">,
					principal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.principal#">
				WHERE
                	schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.school)#">
				LIMIT 1					
			</cfquery>
		</cftransaction>
		<cfset client.schoolid = #form.school#>
	</cfif>
	
	<!--- SCHOOL DATES --->
	<cfif form.count EQ '0' OR form.seasonid NEQ '0'>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="insert_dates" datasource="#APPLICATION.DSN#">
				INSERT INTO smg_school_dates
							(schoolid, seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends)
				VALUES ('#client.schoolid#', '#form.seasonid#',
					<cfif form.enrollment EQ ''>NULL<cfelse>#CreateODBCDate(enrollment)#</cfif>,
					<cfif form.year_begins EQ ''>NULL<cfelse>#CreateODBCDate(year_begins)#</cfif>,
					<cfif form.semester_ends EQ ''>NULL<cfelse>#CreateODBCDate(semester_ends)#</cfif>,
					<cfif form.semester_begins EQ ''>NULL<cfelse>#CreateODBCDate(semester_begins)#</cfif>,
					<cfif form.year_ends EQ ''>NULL<cfelse>#CreateODBCDate(year_ends)#</cfif>)
			</cfquery>	
		</cftransaction>
	<!--- UPDATE SCHOOL DATES --->	
	<cfelse>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfloop From = "1" To = "#form.count#" Index = "x">
				<cfquery name="update_school" datasource="#APPLICATION.DSN#">
					UPDATE smg_school_dates 
					SET 	enrollment = <cfif form["enrollment" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["enrollment" & x])#</cfif>,
							year_begins = <cfif form["year_begins" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["year_begins" & x])#</cfif>,
							semester_ends = <cfif form["semester_ends" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["semester_ends" & x])#</cfif>,
							semester_begins = <cfif form["semester_begins" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["semester_begins" & x])#</cfif>,
							year_ends = <cfif form["year_ends" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["year_ends" & x])#</cfif>
					WHERE schooldateid = '#form["schooldateid" & x]#'
					LIMIT 1	
				</cfquery>  
			</cfloop>
		</cftransaction>
	</cfif>

	<cfquery name="add_School" datasource="#APPLICATION.DSN#">
		UPDATE
        	smg_hosts
       	SET
        	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.schoolID)#">,
            dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        	updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
      	WHERE
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
       	LIMIT 1
	</cfquery>		
	
</cfif>

<cflocation url="index.cfm?curdoc=forms/host_fam_pis_6" addtoken="no">