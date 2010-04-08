<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Hosts Authorization Form Not Received</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfinclude template="../querys/get_company_short.cfm">

<cfif form.seasonid EQ '0'>
	You must select a season to run this report. Please go back and try again.
	<cfabort>
</cfif>

<cfif NOT IsDefined('form.regionid')>
	You must select a region in order to run this report. Please try again.
	<cfabort>
</cfif>

<!--- get company region --->
<cfquery name="get_regions" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid NEQ '0'>
			AND (<cfloop list="#form.regionid#" index='regid'>
			regionid = #regid# 
			<cfif regid is #ListLast(form.regionid)#><Cfelse>or</cfif>
			</cfloop> )
		<cfelse>
			AND active = '1'			
		</cfif>
	ORDER BY regionname
</cfquery>

<cfoutput>

<table align="center" width="90%" frame="below">
	<tr><th bgcolor="ededed">#companyshort.companyshort# &nbsp; - &nbsp; CBC Authorization Form Not Received</th></tr>
	<tr><th>
		<font color="FF0000">Please use proper given name on BOTH User and Host Family Accounts and also
			verify that the spelling is consistent.  Variations will cause inconsistencies in this report.<br>
			Nicknames or abbreviations should NOT be used.
		</font>
		</th>
	</tr>
	<tr><td>* Better if printed in landscape format.</td></tr>
</table>

<table align="center" width="90%" frame="below">
	<tr bgcolor="ededed">
		<td width="20%"><b>Student</b></td>
		<td width="15%"><b>Host Family</b></td>
		<td width="15%"><b>Placement Date</b></td>
		<td width="15%"><b>Host Father CBC</b></td>
		<td width="15%"><b>Host Mother CBC</b></td>
		<td width="20%"><b>Placing Rep.</b></td>
	</tr>
	<tr bgcolor="ededed"><th colspan="6">Region</th></tr>
</table>


<cfloop query="get_regions">
	<cfset countregion = 0>
	<cfquery name="get_hosts" datasource="caseusa">
		SELECT DISTINCT h.hostid, h.familylastname, h.fatherfirstname, h.fatherssn, h.motherfirstname, h.motherssn,
			u.firstname as placefirstname, u.lastname as placelastname, u.userid,
			s.firstname as stufirstname, s.familylastname as stulastname, s.studentid, s.dateplaced
		FROM smg_hosts h
		INNER JOIN smg_students s ON s.hostid = h.hostid
		INNER JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_users u ON u.userid = s.placerepid
		WHERE h.active = '1'
			AND s.active = '1'
			AND p.seasonid = <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
			AND s.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			AND s.regionassigned = <cfqueryparam value="#get_regions.regionid#" cfsqltype="cf_sql_integer">
			AND p.enddate > now()
			<!--- AND (h.hostid NOT IN (SELECT hostid FROM smg_hosts_cbc WHERE cbc_type = 'father')
			OR h.hostid NOT IN (SELECT hostid FROM smg_hosts_cbc WHERE cbc_type = 'mother')) --->
			ORDER BY u.lastname, h.familylastname
	</cfquery>
	<table align="center" width="90%" frame="below">
	<tr><th bgcolor="DFE9EE">#get_regions.regionname#</th></tr>
	<tr>
		<td colspan="2">
			<table align="center" width="100%">
			<cfloop query="get_hosts">
			
				<!--- host father --->
				<cfquery name="host_father" datasource="caseusa">
					SELECT cbcfamid, hostid
					FROM smg_hosts_cbc
					WHERE hostid = <cfqueryparam value="#get_hosts.hostid#" cfsqltype="cf_sql_integer">
						AND cbc_type = 'father'
				</cfquery>
				<!--- host mother --->
				<cfquery name="host_mother" datasource="caseusa">
					SELECT cbcfamid, hostid
					FROM smg_hosts_cbc
					WHERE hostid = <cfqueryparam value="#get_hosts.hostid#" cfsqltype="cf_sql_integer">
						AND cbc_type = 'mother'
				</cfquery>
						
				<!--- CROSS DATA --->
				<!--- check if was submitted under a user --->
				<cfquery name="check_father" datasource="caseusa">
					SELECT DISTINCT u.userid, u.ssn, u.firstname, u.lastname, cbc.cbcid, cbc.date_authorized, cbc.date_received
					FROM smg_users u
					INNER JOIN smg_users_cbc cbc ON cbc.userid = u.userid
					WHERE u.ssn != ''
						AND cbc.familyid = '0'
						AND (u.ssn = '#get_hosts.fatherssn#' OR (u.firstname = '#get_hosts.fatherfirstname#' AND u.lastname = '#get_hosts.familylastname#'))
				</cfquery>
				<cfquery name="check_mother" datasource="caseusa">
					SELECT DISTINCT u.userid, u.ssn, firstname, lastname, cbc.cbcid, cbc.date_authorized, cbc.date_received
					FROM smg_users u
					INNER JOIN smg_users_cbc cbc ON cbc.userid = u.userid
					WHERE u.ssn != ''
						AND cbc.familyid = '0'
						AND (u.ssn = '#get_hosts.motherssn#' OR (u.firstname = '#get_hosts.motherfirstname#' AND u.lastname = '#get_hosts.familylastname#'))
				</cfquery>
							
				<cfif (get_hosts.motherfirstname NEQ '' AND host_mother.recordcount EQ '0' AND check_mother.recordcount EQ '0') OR (get_hosts.fatherfirstname NEQ '' AND host_father.recordcount EQ '0' AND check_father.recordcount EQ '0')>
				<tr bgcolor="#iif(get_hosts.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td width="20%">#stufirstname# #stulastname# (###studentid#)</td>
					<td width="15%">#familylastname# (###hostid#)</td>
					<td width="15%">#DateFormat(dateplaced, 'mm/dd/yy')#</td>
					<td width="15%"><cfif get_hosts.fatherfirstname NEQ '' AND host_father.recordcount EQ '0' AND check_father.recordcount EQ '0'>HF Missing</cfif></td>
					<td width="15%"><cfif get_hosts.motherfirstname NEQ '' AND host_mother.recordcount EQ '0' AND check_mother.recordcount EQ '0'>HM Missing</cfif></td>
					<td width="20%">#placefirstname# #placelastname# (###userid#)</td>
				</tr>
				<cfset countregion = countregion + 1>
				</cfif>
			</cfloop>
			<cfif countregion EQ 0>
			<tr><td colspan="4">&nbsp;</td></tr>
			</cfif>			
			</table>
		</td>
	</tr>
</cfloop>
</table>

</cfoutput>

</body>
</html>