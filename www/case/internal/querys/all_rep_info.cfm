<CFQUERY name="selectdb" datasource="caseusa">
USE smg
</CFQUERY>
<cfquery name="all_rep_info" datasource="caseusa">
select *
from smg_users
where userid = #url.userid#
</cfquery>