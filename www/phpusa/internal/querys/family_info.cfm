<cfquery name="family_info" datasource="mysql">
	SELECT *
	FROM smg_hosts
	WHERE hostid = <cfif IsDefined('form.hostid')>'#form.hostid#'<cfelse>'#client.hostid#'</cfif>
</cfquery>