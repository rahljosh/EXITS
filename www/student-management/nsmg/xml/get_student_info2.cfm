<cfquery name="get_student_info" datasource="mysql">
	select *
	from smg_students
	where studentid = #smg_students.studentid#
</cfquery>