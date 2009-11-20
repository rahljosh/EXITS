<cfquery name="check_username" datasource="mysql">
select username
from smg_users
where username = #url.username#
</cfquery>