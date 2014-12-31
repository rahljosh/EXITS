<cfquery name="update_placement_notes" datasource="MySQL">
update smg_students
set interests_other='#form.interests_other#'
where studentid=#client.studentid#
</cfquery>
<cflocation url="../student_narrative.cfm" addtoken="no">