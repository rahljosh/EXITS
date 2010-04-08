<cfif not isDefined("url.user_order")><cfset url.user_order = "lastname"></cfif>
<cfif not isDefined("url.user_type")><cfset url.user_type = "all"></cfif>
<cfif not isDefined('url.suborder')><cfset url.suborder = 0></cfif>
<cfif not isDefined('url.active')><cfset url.active = 1></cfif>

<!--- OFFICE PEOPLE AND ABOVE --->
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET ALL REGIONS --->
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = "All"></cfif>
	<cfquery name="reps" datasource="caseusa">
		SELECT DISTINCT u.userid,firstname,lastname,firstname,city,state,email,phone,country,businessname,datecreated, 
				smg_countrylist.countryname
		FROM smg_users u
		LEFT OUTER JOIN user_access_rights ON u.userid = user_access_rights.userid
		LEFT OUTER JOIN smg_countrylist ON u.country = countryid
		WHERE <cfif url.active is '1'>u.active = '1'<cfelse>u.active = '0'</cfif>
		<cfif client.companyid is 5><cfelse>
			AND u.companyid LIKE '%#client.companyid#%'
		</cfif>
		<cfif url.suborder is 0><cfelse>
			AND u.usertype = #url.suborder#
		</cfif>
		<cfif #url.user_type# is 'all'>
			AND u.usertype between '5' AND '7'
		<cfelseif #url.user_type# is '8'>
			AND U.usertype = 8
		<cfelseif #url.user_type# is 'office'>
			AND u.usertype < 5 AND u.companyid like '%#client.companyid#%'
		</cfif>
		ORDER BY #url.user_order#
	</cfquery>
<!--- FIELD --->
<cfelse>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET USERS REGION --->
		SELECT user_access_rights.regionid, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
	<cfif not IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
	<cfquery name="get_user_region" datasource="caseusa"> <!--- GET USERTYPE --->
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  AND userid = '#client.userid#'
		ORDER BY regionname
	</cfquery>
	
	<cfquery name="reps" datasource="caseusa">
		SELECT DISTINCT u.userid,firstname,lastname,firstname,city,state,email,phone,country,businessname,datecreated
		FROM user_access_rights uar
		INNER JOIN smg_users u ON u.userid = uar.userid
		WHERE u.active = 1 AND uar.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			<cfif get_user_region.usertype is 7>
			AND u.userid = #client.userid# 
			</cfif>
			<cfif get_user_region.usertype is 6>
			AND uar.advisorid = '#client.userid#'
			OR u.userid = '#client.userid#'
			</cfif>
		ORDER BY #url.user_order#
	</cfquery>
</cfif>

<style type="text/css">
<!--
div.scroll {
	height: 325px;
	width: 100%;
	overflow: auto;
		border-left: 2px solid #c6c6c6;
	border-right: 2px solid #c6c6c6;
	background: #Ffffe6;
}
-->
</style>

<Cfoutput>

<!----Region's Drop Down---->
<cfif list_regions.recordcount lte 1 or #url.user_type# is '8'><Cfelse>
	<form name="form">
		You have access to multiple regions filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '4'>
		<option value="?curdoc=user2&orderby=#url.user_order#&regionid=all" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=user2&orderby=#url.user_order#&regionid=#list_regions.regionid# <cfif url.regionid is #regionid#>selected</cfif>>#regionname#"</option>
		</cfloop>
		</select>
		<cfif client.usertype GT '4' AND client.usertype LTE '7'>
		&nbsp; &middot; &nbsp; Access Level : &nbsp; #get_user_region.user_access#
		</cfif>
	</form>
</cfif><br>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Users </td>
		<td background="pics/header_background.gif" align="right"><font size=-1>[ <cfif url.user_type is "all"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif><a href="?curdoc=users&user_type=all">Reps</a></span> <Cfif client.usertype gt 4><cfelse><cfif url.user_type is 8>&middot;<span class="edit_link_selected"><cfelse>&middot; <span class="edit_link"></cfif><a href="?curdoc=users&user_type=8">Intl. Reps</a></span><cfif client.usertype lte 4> &middot;</cfif> <span class="edit_link"><cfif url.user_type is 'office'><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>  <a href="?curdoc=users&user_type=office">Office</a></span>   &middot; <span class="edit_link"><cfif url.active is 0><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif>  <a href="?curdoc=users&active=0">Inactive</a></span> </cfif>]<Cfoutput>#reps.recordcount#</Cfoutput>  users shown <br></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<cfif url.user_type is 8>
			<td width=20><a href="">ID</a></td><td width=80><a href="?curdoc=users&user_order=lastname&user_type=#url.user_type#">Last Name</a></td><td width=80><a href="?curdoc=users&user_order=firstname&user_type=#url.user_type#">First Name</a></td><td width=110><a href="?curdoc=users&user_order=businessname&user_type=#url.user_type#">Company</a></td><td width=50><a href="?curdoc=users&user_order=country&user_type=#url.user_type#">Country</a></td>
		<cfelse>
			<td width=20><a href="">ID</a></td><td width=80><a href="?curdoc=users&user_order=lastname&user_type=#url.user_type#">Last Name</a></td><td width=80><a href="?curdoc=users&user_order=firstname&user_type=#url.user_type#">First Name</a></td><td width=80><a href="?curdoc=users&user_order=city&user_type=#url.user_type#">City</a></td><td width=25><a href="?curdoc=users&user_order=state&user_type=#url.user_type#">State</a></td><td width=80><a href="?curdoc=users&user_order=regionname&user_type=#url.user_type#">Region</a></td><td width=80><a href="?curdoc=users&user_order=phone&user_type=#url.user_type#">Phone</a></td>
		</cfif>
	</tr>
</table>
</cfoutput>
<div class="scroll">
<table border=0 cellpadding=4 cellspacing=0 width=100%>
	
<cfoutput query="reps">
<!----
<cfquery name="regionname" datasource="caseusa">
select regionname 
from smg_regions
where regionid = #
</cfquery>
---->
<Cfif #datecreated# gt #client.lastlogin#>
<tr bgcolor="##e2efc7">
<cfelse>
<tr bgcolor="#iif(reps.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
 </cfif>         
		<cfif url.user_type is 8>
			<td width=20><a href="index.cfm?curdoc=user_info&userid=#userid#">#userid#</a></td><td width=80><a href="index.cfm?curdoc=user_info&userid=#userid#">#lastname#</a></td><td width=80><a href="index.cfm?curdoc=user_info&userid=#userid#">#firstname#</a></td><td width=110><a href="index.cfm?curdoc=user_info&userid=#userid#">#businessname#</a></td><td width=50>#countryname#</td>
		<cfelse>
			<td width=20><a href="index.cfm?curdoc=user_info&userid=#userid#">#userid#</a></td><td width=80><a href="index.cfm?curdoc=user_info&userid=#userid#">#lastname#</a></td><td width=80><a href="index.cfm?curdoc=user_info&userid=#userid#">#firstname#</a></td><td width=80>#city#</td><td width=25>#state#</td><td width=80><!--- #regionname# ---></td><td width=80>#phone#</td>
		</cfif>			
</tr>
</cfoutput>
</table>
</div>

<table width=100% class="section">
<tr>
<td>Users in Green have been added since your last vist.</td><td align="right">CTRL-F to search</td>
</tr>
<tr>
	<td colspan=2 align="center"><form action="index.cfm?curdoc=forms/new_user" method="post"><input type="submit" value="  Add a New User   "></form></td>
</tr>
</table>
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>	

