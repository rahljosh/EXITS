<cfif NOT VAL(CLIENT.userID) OR NOT VAL(CLIENT.userType)>
	<cflocation url="#CLIENT.exits_url#/nsmg/loginform.cfm" addtoken="no">
</cfif>

<cfif client.usertype NEQ 8>
	<table width="90%" align="center">
		<th>You do not have rights to view this page.</th>
	</table>
	<cfabort>
</cfif>