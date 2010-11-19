<cfquery name="insert_student_letter" datasource="MySQL">
update smg_students
set letter = "#form.letter#"
where studentid = #client.studentid#
</cfquery>
<cflocation url="../forms/add_student_complete" addtoken="no">