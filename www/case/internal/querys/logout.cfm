<cflock timeout="30" name="#client.sessionid#" type="exclusive">
	<cfset structclear(Session)>
</cflock>

<meta http-equiv="Refresh" content="7;url=loginform.cfm">