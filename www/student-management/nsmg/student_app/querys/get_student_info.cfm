<cfquery name="get_student_info" datasource="#APPLICATION.DSN#">
	SELECT 
    	*
	FROM 
    	smg_students
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentid)#">
</cfquery>