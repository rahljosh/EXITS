<cftransaction action="begin" isolation="serializable">
	<cfquery name="add_program" datasource="#APPLICATION.DSN#">
		INSERT INTO smg_programs (
        	programname, 
            type, 
            startdate, 
            enddate, 
            companyid, 
            insurance_startdate, 
            insurance_enddate, 
            seasonid, 
            smgseasonid, 
            tripid, 
            hold, 
            fk_smg_student_app_programID)
		VALUES (
        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.programName#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.type#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.startdate)#">, 
            <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.enddate)#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">, 
			<cfif LEN(FORM.insurance_startdate)>
            	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.insurance_startdate)#">
          	<cfelse>
            	NULL
          	</cfif>,
			<cfif LEN(FORM.insurance_enddate)>
            	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.insurance_enddate)#">
          	<cfelse>
            	NULL
           	</cfif>,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.smgseasonID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.smg_trip#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentAppType#">)
	</cfquery>
	<cfquery name="prog_id" datasource="#APPLICATION.DSN#">
		SELECT MAX(programid) as newid
		FROM smg_programs
	</cfquery>
</cftransaction>
<cfoutput>
	<cflocation url="index.cfm?curdoc=tools/change_programs&progid=#prog_id.newid#" addtoken="no">
</cfoutput>