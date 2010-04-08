<cfquery name="update_notes" datasource="caseusa">
update smg_Students
set notes="#form.notes# - #DateFormat(now(), 'yyyy/mm/dd')# by #client.name#"
where studentid=#client.studentid#
</cfquery>
<cflocation url="../forms/notes.cfm" addtoken="no">
</body>
</html>
