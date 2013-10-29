<cfquery name="current_status" datasource="#APPLICATION.DSN#">
	SELECT app_current_status 
	FROM smg_students 
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
</cfquery>

<cfquery name="update_status" datasource="#APPLICATION.DSN#">
	INSERT INTO smg_student_app_status(
    	studentid, 
        status, 
        date, 
        approvedby)
	VALUES(
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">,
		<cfif current_status.app_current_status eq 2>25<cfelse>2</cfif>,
        #now()#,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">)
</cfquery>

<cfquery name="update_student" datasource="#APPLICATION.DSN#">
	UPDATE smg_students
	SET app_current_status = <cfif current_status.app_current_status eq 2>25<cfelse>2</cfif>
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.studentid#">
</cfquery>

<cflocation url="../index.cfm?curdoc=student_app/student_app_list&status=#url.status#">