<cfquery name="current_status" datasource="mysql">
select *
from user_status_0424
</cfquery>

<cfloop query="current_status">
<cfquery name="update_status" datasource="mysql">
update smg_users
set active = #active#
where userid = #userid#
</cfquery>
#userid#<br>
</cfloop>