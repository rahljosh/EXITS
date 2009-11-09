<cfquery name="login" datasource="mysql">
		SELECT firstname, username, password
		FROM smg_users 
		WHERE username = '#form.username#'
		AND password = '#form.password#'
		AND active = '1'
</cfquery>
<cfset session.auth.firstname = '#login.firstname#'>
<loginsuccess><cfif login.recordcount EQ '0'>no<cfelse>yes</cfif></loginsuccess>