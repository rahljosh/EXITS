<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>CBC Report - Authorization Received</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_cbc_hosts" datasource="caseusa">
	SELECT DISTINCT cbc.cbcfamid, cbc.hostid, cbc.familyid, cbc.cbc_type, cbc.date_authorized, cbc.date_sent, cbc.date_received, cbc.requestid,
		h.familylastname, h.fatherfirstname, h.fatherlastname, h.motherfirstname, h.motherlastname,
		kids.name, kids.lastname
	FROM smg_hosts_cbc cbc
	LEFT JOIN smg_hosts h ON h.hostid = cbc.hostid
	LEFT JOIN smg_host_children kids ON kids.childid = cbc.familyid	
	WHERE cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
		<cfif form.usertype EQ '1'>
			AND cbc.familyid = '0'
		<cfelseif form.usertype EQ '2'>
			AND cbc.cbc_type = 'member'
		</cfif>
		<cfif form.status EQ '1'>
			AND cbc.date_sent IS NOT NULL 
		<cfelseif form.status EQ '2'>
			AND cbc.date_sent IS NULL
		</cfif>
	ORDER BY h.familylastname, h.hostid
</cfquery>

<cfoutput>

<table align="center" width="680" frame="box">
	<tr><th colspan="4">#companyshort.companyshort# &nbsp; - &nbsp; CBC Searches</th></tr>
	<tr><th colspan="4">Total of searches: #get_cbc_hosts.recordcount#<br><br></th></tr>	
	<tr bgcolor="ededed"><th>Host</th><th>Authorization Date</th><th>Submitted Date</th><th>Request ID</th></tr>
	<cfif get_cbc_hosts.recordcount EQ '0'>
		<tr bgcolor="ededed">
			<td colspan="3">No hosts were found matching your criteria.</td><td></td>
		</tr>
	<cfelse>
		<cfloop query="get_cbc_hosts">
		<tr bgcolor="#iif(get_cbc_hosts.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="55%">
				<cfif familyid EQ '0'>
					<cfif cbc_type EQ 'father'>
						#fatherfirstname# #fatherlastname# (###hostid#) 
					<cfelse>
						#motherfirstname# #motherlastname# (###hostid#) 
					</cfif>
				<cfelse>
					#name# #famlast# - member of #familylastname# (###hostid#)
				</cfif>
			</td>
			<td width="15%" align="center">#DateFormat(date_authorized, 'mm/dd/yyyy')#</td>
			<td width="15%" align="center">#DateFormat(date_sent, 'mm/dd/yyyy')#</td>
			<td width="15%" >#requestid#</td>
		</tr>
		</cfloop>
	</cfif>
</table>

</cfoutput>

</body>
</html>