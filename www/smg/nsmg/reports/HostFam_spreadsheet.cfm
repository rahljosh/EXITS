<!--- OFFICE AND MANAGERS --->
<cfif client.usertype GT 5>
	You do not have rights to run this report.
	<cfabort>
</cfif>

<cfif NOT isDefined("url.host_fam_hosting")>
	<cfset url.host_fam_hosting = "all">
</cfif>

<cfquery name="user_region_list" datasource="MySQL">
	select regions
	from smg_users
	where userid = '#client.userid#'
</cfquery>

<cfif url.host_fam_hosting is "all">

	<cfquery name="host_families" datasource="MySQL">
		SELECT hostid , familylastname , fatherlastname , fatherfirstname , motherlastname , motherfirstname , address , city , state , zip , phone , email 
		FROM smg_hosts 
		WHERE smg_hosts.active = '#form.status#' 
			AND companyid = '#client.companyid#'
			<cfif form.regionid NEQ 0>AND regionid = '#form.regionid#'</cfif>
			<cfif form.state NEQ 0>AND state = '#form.state#'</cfif>
		ORDER BY #form.orderby#
	</cfquery>

<cfelseif url.host_fam_hosting is "no">
	<!----Host Families that are not hosting a student---->
	<cfquery name="host_families" datasource="MySQL">
		select  smg_hosts.familylastname, smg_hosts.fatherlastname,smg_hosts.fatherfirstname,smg_hosts.motherlastname,
			smg_hosts.motherfirstname,smg_hosts.hostid,smg_hosts.city,smg_hosts.state, smg_students.hostid
		from smg_hosts 
		left join smg_students on smg_hosts.hostid = smg_students.hostid
		where smg_hosts.active = '#form.status#' 			
			AND companyid = '#client.companyid#'
			AND smg_students.hostid = 0
			<cfif form.regionid NEQ 0>AND regionid = '#form.regionid#'</cfif>
			<cfif form.state NEQ 0>AND state = '#form.state#'</cfif>
		ORDER BY #form.orderby#
	</cfquery>

<cfelseif url.host_fam_hosting is "yes">
	<!----Host Families that are hosting a student---->
	<cfquery name="host_families" datasource="MySQL">
		select distinct smg_hosts.familylastname, smg_hosts.fatherlastname,smg_hosts.fatherfirstname,smg_hosts.motherlastname,
		smg_hosts.motherfirstname,smg_hosts.hostid,smg _host.address, smg_hosts.city,smg_hosts.state,smg_host.zip, smg_host.email,smg_students.hostid
		from smg_hosts
		inner join smg_students on smg_students.hostid = smg_hosts.hostid
		WHERE smg_hosts.active = '#form.status#' 			
			AND companyid = '#client.companyid#'
			<cfif form.regionid NEQ 0>AND regionid = '#form.regionid#'</cfif>
			<cfif form.state NEQ 0>AND state = '#form.state#'</cfif>
		order by #form.orderby#
	</cfquery>
</cfif>

<Cfoutput>

<br><br>
<table border=0 cellpadding=3 cellspacing=0 class=small width="90%" align="center">
	<tr><th colspan="5">Host Family Spreadsheet</th></tr>
	<tr><td colspan="5">The total number of host families found in your region is #host_families.recordcount#.</td></tr>
  	<tr>
		<td width="5%"><b>ID</b></td>
		<td><b>Host Family</b></td>
		<td valign="top"><b>Address</b></td>
		<td valign="top"><b>E-mail</b></td>
		<td valign="top"><b>Phone</b></td>
	</tr>
	<cfloop query="host_families">
	<tr bgcolor="#iif(host_families.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">			   
		<td width=5 valign="top">###hostid#</td>
		<td valign="top">#familylastname# - #fatherfirstname#
			 <Cfif #motherfirstname# is '' or #fatherfirstname# is ''><cfelse>&</Cfif> #motherfirstname#
		</td>
		<td valign="top">#address# #city# #state# #zip#</td>
		<td valign="top">#email#</td>
		<td valign="top">#phone#</td>
	</tr>
	</cfloop>
</table><br />
</Cfoutput>