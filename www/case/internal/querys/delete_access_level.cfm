<cfquery name="check_access" datasource="caseusa">
	SELECT userid
	FROM user_access_rights
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfif check_access.recordcount LTE 1>
	<html>
	<head>
	<cfoutput>
	<script language="JavaScript">
	<!-- 
	alert("Error - Region access could not be deleted. \n User must have access to at least 1 region. If you wish to remove access please make this user inactive.");
		location.replace("../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#");
	-->
	</script>
	</cfoutput>
	</head>
	</html> 
<cfelse>
	<Cfquery name="delete_access" datasource="caseusa">
		DELETE from user_access_rights
		WHERE regionid = #url.regionid# 
			AND userid = #url.userid# 
	</Cfquery>

	<cflocation url= "../index.cfm?curdoc=forms/region_access_rights&userid=#url.userid#" addtoken="no">
</cfif>