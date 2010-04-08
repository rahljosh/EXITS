<cfquery name="get_host_info" datasource="caseusa">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>
