<cfquery name="get_student_info" datasource="mysql">
	SELECT *
	FROM smg_Students
	WHERE studentid = '#client.studentid#'
</cfquery>