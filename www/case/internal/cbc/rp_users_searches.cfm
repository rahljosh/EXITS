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

<cfquery name="get_cbc_users" datasource="caseusa">
	SELECT DISTINCT cbc.cbcid, cbc.userid, cbc.familyid, cbc.date_authorized, cbc.date_sent, cbc.date_received, cbc.requestid,
		u.firstname, u.lastname, u.middlename, u.dob, u.ssn,
		fam.firstname as famfirst, fam.lastname as famlast
	FROM smg_users_cbc cbc
	LEFT JOIN smg_users u ON u.userid = cbc.userid
	LEFT JOIN smg_user_family fam ON fam.id = cbc.familyid
	LEFT JOIN user_access_rights uar ON uar.userid = u.userid
	WHERE cbc.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
		<cfif form.usertype EQ '1'>
			AND uar.usertype <= '4' AND cbc.familyid = '0'
		<cfelseif form.usertype EQ '2'>
			AND (uar.usertype >='5' AND uar.usertype <= '7' OR uar.usertype = '9') AND cbc.familyid = '0'
		<cfelseif form.usertype EQ '3'>
			AND cbc.familyid != '0'		
		</cfif>
		<cfif form.status EQ '1'>
			AND cbc.date_sent IS NOT NULL 
		<cfelseif form.status EQ '2'>
			AND cbc.date_sent IS NULL
		</cfif>
	ORDER BY uar.usertype, u.lastname, u.firstname
</cfquery>

<cfoutput>

<table align="center" width="680" frame="box">
	<tr><th colspan="4">#companyshort.companyshort# &nbsp; - &nbsp; CBC Searches</th></tr>
	<tr><th colspan="4">Total of searches: #get_cbc_users.recordcount#<br><br></th></tr>	
	<tr bgcolor="ededed"><th>USER</th><th>Authorization Date</th><th>Submitted Date</th><th>Request ID</th></tr>
	<cfif get_cbc_users.recordcount EQ '0'>
		<tr bgcolor="#iif(get_cbc_users.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="70%">No users were found matching your criteria.</td><td width="30%"></td>
		</tr>
	<cfelse>
		<cfloop query="get_cbc_users">
		<tr bgcolor="#iif(get_cbc_users.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="55%">
				<cfif familyid EQ '0'>
					#firstname# #lastname# (###userid#) 
				<cfelse>
					#famfirst# #famlast# - member of #firstname# #lastname# (###userid#)
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
