<!--- revised by Marcus Melo on 09/27/2005 --->

<link rel="stylesheet" href="../smg.css" type="text/css">

<cfif not IsDefined('url.paymentid') or not IsDefined('url.userid')>
	<cfinclude template="../forms/error_message.cfm">
<cfelse>
	<cfquery name="delete_paymentid" datasource="caseusa">
	DELETE 
	FROM smg_rep_payments
	WHERE id = <cfqueryparam value="#url.paymentid#" cfsqltype="cf_sql_integer">
	LIMIT 1
	</cfquery>
	<cflocation url="../forms/supervising_history.cfm?userid=#url.userid#" addtoken="no">
</cfif>