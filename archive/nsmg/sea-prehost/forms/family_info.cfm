<cfquery name="family_info" datasource="MySQL">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>