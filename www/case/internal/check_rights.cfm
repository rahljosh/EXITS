<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>User Check Rights</title>
</head>

<body>

<!--- CHECK RIGHTS --->

<!--- GET REGIONS FOR CURRENT USER  --->
<cfquery name="get_client_regions" datasource="caseusa">
	SELECT regionid
	FROM user_access_rights 
	WHERE usertype = '#client.usertype#'
		AND userid = '#client.userid#' 
		AND companyid = '#client.companyid#'
	GROUP BY regionid
</cfquery>

<cfset manager_list = ValueList(get_client_regions.regionid)>

<!--- CHECK IF CURRENT USER IS A MANAGER OR ADVISOR OF URL.USER --->
<cfquery name="get_user_regions" datasource="caseusa">
	SELECT regionid
	FROM user_access_rights 
	WHERE usertype > '#client.usertype#'
		AND userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6"> 
		<cfif client.usertype EQ 6>
			AND advisorid = '#client.userid#'
		</cfif>
		<cfif get_client_regions.recordcount>
			AND ( <cfloop list="#manager_list#" index="mregion">
				 regionid = '#mregion#'
				 <cfif mregion NEQ #ListLast(manager_list)#>OR</cfif>
			  </cfloop> )
		 </cfif>
</cfquery>

<cfset grant_access = 0>

<cfif client.userid EQ url.userid>
	<cfset grant_access = 1>
<cfelseif client.usertype EQ 5 AND get_user_regions.recordcount>	
	<cfset grant_access = 1>
<cfelseif client.usertype EQ 6 AND get_user_regions.recordcount>	
	<cfset grant_access = 1>	
<cfelseif client.usertype LTE 4>
	<cfset grant_access = 1>
</cfif>

<cfif grant_access EQ 0>	
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>CASE - Error</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<cfoutput>
	<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
		<tr><td align="center" valign="top">
				<img src="pics/error_exclamation.gif" width="37" height="44"> I am sorry but you do not have the rights to see this page.
			</td>
		</tr>
		<tr>
		  <td align="center">If you think this is a mistake please contact support@case-usa.org</td>
		</tr>
		<tr><td align="center">You can view your account by clicking <a href="?curdoc=user_info&userid=#client.userid#">here<a/>.<br /><br /></td></tr>			
	</table>
	<cfinclude template="table_footer.cfm">
	<cfabort>
	</cfoutput>
</cfif>

</body>
</html>