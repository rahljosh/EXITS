<cfquery name="get_student_info" datasource="caseusa">
	SELECT *
	FROM smg_Students
	WHERE studentid = '#client.studentid#'
</cfquery>