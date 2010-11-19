<cftransaction action="BEGIN" isolation="SERIALIZABLE"><CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<Cfquery name="user_status.cfm" datasource="MySQL">
select regionname, regionid
from smg_regions
where regionid = #all_user_info.regions#
</cfquery>
</cftransaction>
