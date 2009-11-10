<cfif NOT IsDefined('client.userid') OR NOT IsDefined('client.usertype')>
	<cflocation url="http://www.student-management.com/nsmg/loginform.cfm" addtoken="no">
</cfif>

<cfif client.usertype NEQ 8>
	<table width="90%" align="center">
		<th>You do not have rights to view this page.</th>
	</table>
	<cfabort>
</cfif>