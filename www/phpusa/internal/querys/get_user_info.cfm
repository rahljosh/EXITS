<cfquery name="get_user_info" datasource="MySQL">
select *
from smg_users
where userid = #client.userid#
</cfquery>