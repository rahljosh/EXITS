<cfquery name="hosts" datasource="mysql">
select hostid, regionid, companyid
from smg_hosts
where regionid = 26
</cfquery>
<cfoutput>
<cfloop query="hosts">
<cfquery name="update_hosts" datasource="mysql">
update smg_hosts
set companyid = 3
where hostid = #hosts.hostid#
</cfquery>
updated #hostid# <br>
</cfloop>
</cfoutput>