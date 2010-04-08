
<cfquery name="all_rep_info" datasource="caseusa">
select *
from smg_users
where userid = #url.rep_id#
</cfquery>