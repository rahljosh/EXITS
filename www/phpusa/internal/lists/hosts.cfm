<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>PHP - Host Families</title>
</head>
<body>

<cfif not isDefined("url.orderby")><cfset url.orderby = "familylastname"></cfif>
<cfif not isDefined("url.hosting")><cfset url.hosting = "all"></cfif>
<cfif not IsDefined('url.inactive')><cfset url.inactive = "no"></cfif>
<!----Schools to user---->




<cfif client.usertype eq 12>
	<cfquery name ="hosts" datasource="MySQL">
			select distinct h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
			psip.hostid,
			php_schools.schoolname
			from smg_hosts h 
			LEFT JOIN php_students_in_program psip on h.hostid = psip.hostid
			LEFT JOIN php_schools ON php_schools.schoolid = #client.userid#
			where psip.schoolid = #client.userid#
			ORDER BY #url.orderby#
	</cfquery>
<cfelse>
<!----
	<cfquery name="hosts" datasource="mysql">
		SELECT sc.schoolid, sc.schoolname, sc.address, sc.city, sc.zip, sc.email, sc.phone, sc.fax,
			sc.website, sc.contact, sc.boarding_school,
			smg_states.state as us_state
		FROM php_schools sc
		LEFT JOIN smg_states ON smg_states.id = sc.state
		<cfif client.usertype eq 7>
		LEFT JOIN php_school_contacts psc ON psc.schoolid = sc.schoolid
		LEFT JOIN smg_hosts on smg_hosts.schooldid = sc.schoolid
		</cfif>
		WHERE 1=1 
		<cfif boarding NEQ 2>
			and sc.boarding_school = '#boarding#'
		</cfif>
		<cfif client.usertype eq 7>
			and psc.userid = #client.userid#
		</cfif>
		ORDER BY #url.order#
	</cfquery>
---->
	<cfquery name="hosts" datasource="mysql">
		SELECT distinct h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
			php_schools.schoolname
		FROM smg_hosts h
		
		LEFT JOIN php_schools ON php_schools.schoolid = h.schoolid
		LEFT JOIN php_school_contacts psc ON psc.schoolid = php_schools.schoolid
		
		<!----
		<cfif client.usertype eq 7>
		LEFT JOIN smg_students on smg_students.hostid = h.hostid
		</cfif>
		---->
		WHERE h.companyid = 6 
		<cfif client.usertype gte 5>
		AND psc.userid = #client.userid#
		</cfif>
	
		<!----
		<cfif client.usertype eq 7>
			and smg_students.arearepid = #client.userid#
		</cfif>
		---->
		ORDER BY #url.orderby#
	</cfquery>
	
</cfif>
<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign=middle height=24>
		<td bgcolor="#e9ecf1">&nbsp;&nbsp;		  <h2>H o s t &nbsp; F a m i l i e s   </td>
		<td bgcolor="#e9ecf1" align="right"></td></td>
	</tr>
</table>
<br>
<cfoutput>
<table width = 90% align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width=30 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=hostid&hosting=#url.hosting#">ID</a></td>
		<td width=100 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=familylastname&hosting=#url.hosting#">Last Name</a></td>
		<td width=90 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=fatherfirstname&hosting=#url.hosting#">Father</a></td>
		<td width=90 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=motherfirstname&hosting=#url.hosting#">Mother</a></td>
		<td width=70 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=city&hosting=#url.hosting#">City</a></td>
		<td width=30 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=state&hosting=#url.hosting#">State</a></td>
		<td width=30 background="images/back_menu2.gif">Phone</td>
	
		<td width=80 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=state&schoolname=#url.hosting#">School</a></td>
	</tr>
</table>
<br>
<table width = 90% align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<cfif hosts.recordcount eq 0>
		<td colspan=6 align = "center">There are no hosts that match your criteria.</td>
		<cfelse>
	<cfloop query="hosts">
	<tr bgcolor="#iif(hosts.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
		<td width=30><a href="?curdoc=host_fam_info&hostid=#hostid#">#hostid#</a></td>
		<td width=100><a href="?curdoc=host_fam_info&hostid=#hostid#">#familylastname#</a></td>
		<td width=90><a href="?curdoc=host_fam_info&hostid=#hostid#">#fatherfirstname#</a></td>
		<td width=90><a href="?curdoc=host_fam_info&hostid=#hostid#">#motherfirstname#</a></td>
		<td width=70>#city#</td>
		<td width=30>#state#</td>
		<th width=30>#phone#</td>
		<td width=80>#schoolname#</td>
	</tr>
	</cfloop>
	</cfif>
		<td></td>
	</tr>
</table>
<table width=90% align="center" class="section">
	<tr><td align="center"><br>
<a href="index.cfm?curdoc=forms/host_fam_pis"><img src="pics/add-host.gif" border="0"></a></td></tr>
</table>
</cfoutput>
<br>
<br>
