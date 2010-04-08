<cfquery name="update_placement_notes" datasource="caseusa">
update smg_Students
set placement_notes="#form.placement_notes#"
where studentid=#client.studentid#
</cfquery>
<cflocation url="../forms/placement_notes.cfm" addtoken="no">