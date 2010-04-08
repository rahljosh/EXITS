<cfquery name="get_user_info" datasource="caseusa">
select *
from smg_users
where userid = #client.userid#
</cfquery>