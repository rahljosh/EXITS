<cfif NOT isdefined("form.interest")>
	<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
		<tr><td>You must select at least one Activitie our Interest. Please go back and try again.</td></tr>
		<tr><td align="center">	<a href="javascript:history.back()"><img src="../pics/back.gif" border="0"></a></td>
	</table>	
	<cfabort>
</cfif>

<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_interests" datasource="#APPLICATION.DSN#">
	UPDATE smg_hosts
	SET	interests = '#form.interest#',
		interests_other = '#form.specific_interests#',
    	dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
		updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
	WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">

</cfquery>
</cftransaction>
 <cflocation url="../index.cfm?curdoc=forms/host_fam_pis_5" addtoken="No">