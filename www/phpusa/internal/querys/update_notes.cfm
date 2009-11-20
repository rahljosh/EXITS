
<cfquery name="update_notes" datasource="mysql">
update smg_students
set notes="#form.notes# - #DateFormat(now(), 'yyyy/mm/dd')# by #client.firstname# #client.lastname#"
where uniqueid = '#url.unqid#'
</cfquery>

<cflocation url="../forms/notes.cfm?unqid=#url.unqid#" addtoken="no">
</body>
</html>
