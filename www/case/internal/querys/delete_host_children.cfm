<!--- revised by Marcus Melo on 08/12/2005 --->

<cfif not IsDefined('url.childid')><br>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfquery name="get_cbc" datasource="caseusa">
	SELECT cbcfamid, hostid, familyid
	FROM smg_hosts_cbc
	WHERE familyid = <cfqueryparam value="#url.childid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif get_cbc.recordcount>
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("This member has a CBC record. You can not delete it.");
		location.replace("?curdoc=forms/host_fam_pis_2");
	-->
	</script>
	</head>
	</html> 		
<cfelse>
	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		<cfquery name="delete_childid" datasource="caseusa">
			DELETE 
			FROM smg_host_children
			WHERE childid = <cfqueryparam value="#url.childid#" cfsqltype="cf_sql_integer">
			LIMIT 1
		</cfquery>
	</cftransaction>
	
	<cflocation url="?curdoc=forms/host_fam_pis_2" addtoken="no">
</cfif>