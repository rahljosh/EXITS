<cfquery name="get_host_info" datasource="MySQL">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>
