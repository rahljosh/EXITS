<cfquery name="get_user_info" datasource="mysql">
select username, email, password, firstname, lastname, datelastlogin 
from smg_users
where active = 1

</cfquery>

<cfloop query="get_user_info">
	<cfquery name="update_cer" datasource="cerberus">
		insert into user (user_name, user_email, user_login, user_password,  user_superuser, user_display_name)
					values ('#firstname# #lastname#', '#email#', '#username#','#password#',0,'#firstname# #lastname#') 
	       
	</cfquery>
</cfloop>