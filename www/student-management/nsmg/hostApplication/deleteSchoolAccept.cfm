<cfquery name="deleteSchoolAccept" datasource="#application.dsn#">
update document
set isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
and hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.key#">
</cfquery>

<h2 align="Center">Document Deleted</h2>
<cflocation url="?curdoc=hostApplication/toDoList&hostID=#url.hostid#">