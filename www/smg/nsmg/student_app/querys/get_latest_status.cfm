<cfquery name="get_latest_status" datasource="MySQL">
	SELECT id, studentid, status, reason, date 
	FROM smg_student_app_status
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY id DESC
</cfquery>