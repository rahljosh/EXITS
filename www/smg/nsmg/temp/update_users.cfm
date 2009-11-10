<cfquery name="get_users" datasource="mysql">
select distinct userid from user_access_rights where `usertype` < 5
</cfquery>
<cfloop query="get_users">
	<cfquery name="update_pass" datasource="mysql">
	update smg_users set changepass = 1
	where userid = #userid#
	</cfquery>
</cfloop>

