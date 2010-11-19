<cfquery name="get_latest_status" datasource="MySQL">
	SELECT id, studentid, status, reason, date 
	FROM smg_student_app_status
	WHERE studentid = #smg_students.studentid#
	ORDER BY id DESC
</cfquery>