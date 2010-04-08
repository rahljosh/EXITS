<cfquery name="users" datasource="caseusa">
select userid from smg_users
</cfquery>

<cfloop query="users">
<cfset uniqueid = '#createuuid()#'>

<cfquery name="update" datasource="caseusa">
update smg_users
	set uniqueid = '#uniqueid#'
where userid = #userid#
</cfquery>
</cfloop>