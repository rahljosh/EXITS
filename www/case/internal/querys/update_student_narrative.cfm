<cfquery name="update_placement_notes" datasource="caseusa">
update smg_Students
set interests_other='#form.interests_other#'
where studentid=#client.studentid#
</cfquery>
<cflocation url="../student_narrative.cfm" addtoken="no">