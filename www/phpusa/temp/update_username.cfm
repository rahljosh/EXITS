<cfquery name="get_emails" datasource="mysql">
select userid, email
from users
</cfquery>

<cfloop query="get_emails">
	<cfquery name="update_username" datasource="mysql">
	update users
		set username = '#email#'
	where userid = #userid#
	</cfquery>
</cfloop>