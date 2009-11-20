<cfquery name="get_student_info" datasource="mysql">
	SELECT 
    	*
	FROM 
    	smg_students
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
</cfquery>