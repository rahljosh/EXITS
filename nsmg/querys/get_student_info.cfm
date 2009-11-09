<cfquery name="get_student_info" datasource="mysql">
	select *
	from smg_Students
	where studentid = #client.studentid#
</cfquery>