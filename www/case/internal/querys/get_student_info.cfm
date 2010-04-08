<cfquery name="get_student_info" datasource="caseusa">
	select *
	from smg_students
	where studentid = #client.studentid#
</cfquery>