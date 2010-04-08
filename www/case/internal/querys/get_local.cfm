<cfquery name="local" datasource="caseusa">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>