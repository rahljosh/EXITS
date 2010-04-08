<cfquery name="family_info" datasource="caseusa">
select *
from smg_hosts
where hostid = #client.hostid#
</cfquery>