<cfquery name="local" datasource="mysql">
	select hosts.city, hosts.state,hosts.zip, smg_states.id
	from smg_hosts hosts
	LEFT JOIN smg_states on smg_states.state = hosts.state
	where hostid = <cfif isdefined('get_student_info.hostid')>
	#get_student_info.hostid#
	<cfelse>
	#client.hostid#
	</cfif>
</cfquery>
