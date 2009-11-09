<CFQUERY name="selectdb" datasource="MySQL">
USE smg
</CFQUERY>
<cfquery name="all_rep_info" datasource="MySQL">
select *
from smg_users
where userid = #url.userid#
</cfquery>