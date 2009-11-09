<cfquery name="local" datasource="MySQL">
	select city,state,zip
	from smg_hosts
	where hostid = #client.hostid#
</cfquery>