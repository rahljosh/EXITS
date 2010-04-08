<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Host Families</title>
<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>
</head>

<body>

<cfsetting requesttimeout="300">

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

<cfif not isDefined("url.orderby")>
	<cfset url.orderby = "familylastname">
</cfif>
<cfif not isDefined("url.hosting")>
	<cfset url.hosting = "all">
</cfif>
<cfif not IsDefined('url.inactive')>
	<cfset url.inactive = "no">
</cfif>

<cfset hostlist = ''>

<!--- OFFICE PEOPLE AND ABOVE --->
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> <!--- GET ALL REGIONS --->
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = "All"></cfif>
	<cfquery name="host_families" datasource="caseusa">
		SELECT h.familylastname, h.fatherlastname, h.fatherfirstname, h.motherlastname, 
			   h.motherfirstname, h.hostid, h.city, h.state, h.phone, h.fax, h.email
		FROM smg_hosts h
		<cfif url.hosting EQ 'yes'>INNER JOIN smg_students s ON h.hostid = s.hostid</cfif>
		<cfif url.hosting EQ 'no'>LEFT JOIN smg_students s ON h.hostid = s.hostid</cfif>
		WHERE h.companyid = '#client.companyid#'
		<cfif url.inactive EQ 'yes'>
			AND h.active = '0'
		<cfelse>
			AND h.active = '1'
		</cfif>
		<cfif url.regionid NEQ "All">
			AND h.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
		</cfif>
		<cfif url.hosting EQ 'yes'>
			AND s.active = '1'
		</cfif>
		<cfif url.hosting is 'no'>
			AND s.hostid is null
		</cfif>
		ORDER BY #url.orderby#
	</cfquery>	

<!--- FIELD --->
<cfelse>
	<!--- GET USERS REGION --->
	<cfquery name="list_regions" datasource="caseusa">
		SELECT user_access_rights.regionid, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
	
	<cfif not IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
	
	<!--- GET USERTYPE --->
	<cfquery name="get_user_region" datasource="caseusa"> 
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  and userid = '#client.userid#'
		ORDER BY regionname
	</cfquery>
	<!---- REGIONAL ADVISOR ----->
	<Cfif get_user_region.usertype EQ 6>
		<cfset hostlist = ''>
		<cfquery name="areareps" datasource="caseusa">
			SELECT userid FROM user_access_rights
			WHERE regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer"> AND (advisorid = '#client.userid#' OR userid = '#client.userid#') 
			GROUP BY userid
			ORDER BY userid
		</cfquery>
		<cfloop query="areareps">
			<cfquery name="hosts_under_reps" datasource="caseusa">
				SELECT DISTINCT hostid FROM smg_students 
				WHERE arearepid = '#areareps.userid#' OR placerepid = '#client.userid#'
				UNION
				SELECT DISTINCT hostid FROM smg_hosts 
				WHERE arearepid = '#areareps.userid#' 
				ORDER BY hostid
			</cfquery>
			<cfif hosts_under_reps.recordcount NEQ '0'>	
				<cfloop query="hosts_under_reps"> <!--- Getting hosts under reps --->		
					<Cfset hostlist = listAppend(hostlist, '#hosts_under_reps.hostid#')>
				</cfloop>
			<cfelse>
				<Cfset hostlist = '0'>
			</cfif>
		</cfloop>
	</Cfif>
	<!--- AREA REP - STUDENTS VIEW --->
	<cfif get_user_region.usertype EQ '7' OR get_user_region.usertype EQ '9'>
		<cfset hostlist = ''>
		<cfquery name="host_under_area" datasource="caseusa">
			SELECT DISTINCT hostid FROM smg_students 
			WHERE arearepid = '#client.userid#' OR placerepid = '#client.userid#'
			UNION
			SELECT DISTINCT hostid FROM smg_hosts 
			WHERE arearepid = '#client.userid#' 
			ORDER BY hostid
		</cfquery>
		<cfif host_under_area.recordcount NEQ '0'>
			<cfloop query="host_under_area"> <!--- Getting hosts under reps --->		
				<Cfset hostlist = listAppend(hostlist, '#host_under_area.hostid#')>
			</cfloop>		
		<cfelse>	
			<Cfset hostlist = '0'>
		</cfif>
	</cfif>

	<cfquery name="host_families" datasource="caseusa">
		SELECT DISTINCT h.familylastname, h.fatherlastname, h.fatherfirstname, h.motherlastname, 
			h.motherfirstname, h.hostid, h.city, h.state, h.phone, h.fax, h.email
		FROM smg_hosts h
		WHERE h.active = '1' 
			<!--- REGIONAL MANAGER SEES ALL FAMILIES ON THE REGION --->
			AND h.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			<!--- REGIONAL ADVISOR --->
			<cfif get_user_region.usertype EQ 6>
				<cfset lindex = 0>
				AND ( <cfloop list= "#hostlist#" index="i">
						<cfset lindex = lindex + 1>
						h.hostid = '#i#' <cfif lindex is #ListLen(hostlist)#><cfelse>or </cfif>
					</cfloop> )
			<!--- AREA REPRESENTATIVE / STUDENTS VIEW --->
			<cfelseif (get_user_region.usertype EQ '7' OR get_user_region.usertype EQ '9')>
				<cfset lindex = 0>
				AND ( <cfloop list= "#hostlist#" index="i">
						<cfset lindex = lindex + 1>
						h.hostid = '#i#' <cfif lindex is #ListLen(hostlist)#><cfelse>or </cfif>
					</cfloop> )
			</cfif>		
		ORDER BY #url.orderby#
	</cfquery>	
</cfif>

<cfoutput>
<!----Region's Drop Down---->
<cfif list_regions.recordcount GT 1>
	<form name="form">
		You have access to multiple regions filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '4'>
		<option value="?curdoc=host_fam&hosting=#url.hosting#&orderby=#url.orderby#regionid=all" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=host_fam&hosting=#url.hosting#&orderby=#url.orderby#&regionid=#list_regions.regionid#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
		</cfloop>
		</select>
		<cfif client.usertype GT '4' AND client.usertype LTE '7'>
		&nbsp; &middot; &nbsp; Access Level : &nbsp; #get_user_region.user_access#
		</cfif>
	</form>
</cfif><br>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24 bgcolor=##ffffff>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=30 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Host Families </td>
		<td background="pics/header_background.gif" align="right">
			[<cfif  client.usertype GT '4'><cfelse>
				<cfif url.hosting is "yes"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif> 
						<a href="?curdoc=host_fam&hosting=yes&regionid=#url.regionid#">hosting</a></span>&middot;
					<cfif url.hosting is "no"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif> 
						<a href="?curdoc=host_fam&hosting=no&regionid=#url.regionid#">not hosting</a></span> &middot;	
					<cfif url.inactive is "yes"><span class="edit_link_selected"><cfelse><span class="edit_link"></cfif> 
						<a href="?curdoc=host_fam&hosting=all&regionid=#url.regionid#&inactive=yes">Inactive</a></span> &middot;	
			 </cfif> 
				<cfif url.hosting is "all"><span class="edit_link_Selected"><cfelse><span class="edit_link"></cfif> 
				<a href="?curdoc=host_fam&hosting=all&regionid=#url.regionid#">all</a></span> ] #host_families.recordcount# families shown</center>
		</td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 class="section" width=100%>
	<tr>
		<td width=30><a href="?curdoc=host_fam&orderby=hostid&hosting=#url.hosting#&regionid=#url.regionid#"> ID</a></td>
		<td width=100><a href="?curdoc=host_fam&orderby=familylastname&hosting=#url.hosting#&regionid=#url.regionid#"> Last Name</a></td>
		<td width=90><a href="?curdoc=host_fam&orderby=fatherfirstname&hosting=#url.hosting#&regionid=#url.regionid#"> Father</a></td>
		<td width=90><a href="?curdoc=host_fam&orderby=motherfirstname&hosting=#url.hosting#&regionid=#url.regionid#"> Mother</a></td>
		<td width=70><a href="?curdoc=host_fam&orderby=city&hosting=#url.hosting#&regionid=#url.regionid#"> City</a></td>
		<td width=30><a href="?curdoc=host_fam&orderby=state&hosting=#url.hosting#&regionid=#url.regionid#"> State</a></td>
        <td width=30>Phone</td>
        <td width=30>Fax</td>
        <td width=30>Email</td>
	</tr>
</table>

<div class="scroll">
<table width=100%>
	<cfloop query="host_families">
	<tr bgcolor="#iif(host_families.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<td width=30> #hostid#</td>
		<td width=100> #familylastname#</td>
		<td width=90> #fatherfirstname#</td>
		<td width=90> #motherfirstname#</td>
		<td width=60> #city#</td>
        <td width=30> #state#</td>
        <td width=30> #phone#</td>
        <td width=30> #fax#</td>
        <td width=30> #email#</td>
	</tr>
	</cfloop>
</table>
</div>

<table width=100% bgcolor="ffffe6" class="section">
	<tr><td align="center"><form action="index.cfm?curdoc=forms/host_fam_pis" method="post"><input type="submit" value="   Add Host Family - PIS  "></form></td></tr>
</table>
</cfoutput>

<cfinclude template="table_footer.cfm">

</body>
</html>