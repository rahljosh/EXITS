<cfquery name="get_student_info" datasource="mysql">
	select 
    	*
	from 
    	smg_students
	where 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
</cfquery>