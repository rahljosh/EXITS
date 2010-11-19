
<cfquery name="all_rep_info" datasource="MySQL">
select *
from smg_users
where userid = #url.rep_id#
</cfquery>