<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Authorization Form Not Received</title>
</head>

<body>

<cfsetting requestTimeOut = "500">

<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_regions" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid NEQ '0'>AND regionid = '#form.regionid#'</cfif>
	ORDER BY regionname
</cfquery>

<cfoutput>

<table align="center" width="680" frame="box">
	<tr><th bgcolor="ededed">#companyshort.companyshort# &nbsp; - &nbsp; CBC Authorization Form Not Received</th></tr>
	<tr><th>
		<font color="FF0000">Please use proper given name on BOTH User and Host Family Accounts and also
			verify that the spelling is consistent.  Variations will cause inconsistencies in this report.<br>
			Nicknames or abbreviations should NOT be used.
		</font>
		</th>
	</tr>	
	<tr bgcolor="ededed"><th>Region</th></tr>
	<cfloop query="get_regions">

		<cfquery name="get_cbc_users" datasource="caseusa">
			SELECT DISTINCT u.userid, u.firstname, u.lastname, u.middlename, u.dob, u.ssn, u.sex
			FROM smg_users u 
			INNER JOIN user_access_rights uar ON uar.userid = u.userid
			WHERE u.active = '1'
				AND uar.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
				AND uar.regionid = <cfqueryparam value="#get_regions.regionid#" cfsqltype="cf_sql_integer">
				<cfif form.usertype EQ '1'>
					AND uar.usertype <= '4' 
				<cfelseif form.usertype EQ '2'>
					AND (uar.usertype >='5' AND uar.usertype <= '7' OR uar.usertype = '9')
				</cfif>
			<!--- AND u.userid NOT IN (SELECT userid FROM smg_users_cbc) --->
			ORDER BY u.lastname, u.firstname
		</cfquery>
		<tr><th>#get_regions.regionname#</th></tr>
		<cfif get_cbc_users.recordcount EQ '0'>
			<tr bgcolor="#iif(get_cbc_users.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>No users were found matching your criteria.</td>
			</tr>
		<cfelse>
			<cfloop query="get_cbc_users">
			
				<cfquery name="check_cbc" datasource="caseusa">
					SELECT userid 
					FROM smg_users_cbc
					WHERE userid = '#userid#'
				</cfquery>
			
				<cfif check_cbc.recordcount EQ 0>
					<cfif form.usertype EQ '2'>
						<cfquery name="check_hosts" datasource="caseusa">
							SELECT DISTINCT h.hostid, h.fatherssn, h.motherssn
							FROM smg_hosts h
							INNER JOIN smg_hosts_cbc cbc ON h.hostid = cbc.hostid
							WHERE cbc.cbc_type = 'father' AND (h.fatherssn = '#get_cbc_users.ssn#' OR (h.fatherfirstname = '#get_cbc_users.firstname#' AND h.familylastname = '#get_cbc_users.lastname#'))
								  OR 
								  cbc.cbc_type = 'mother' AND (h.motherssn = '#get_cbc_users.ssn#' OR (h.motherfirstname = '#get_cbc_users.firstname#' AND h.familylastname = '#get_cbc_users.lastname#'))
						</cfquery>
						<cfif check_hosts.recordcount EQ 0>
							<tr bgcolor="#iif(get_cbc_users.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
								<td>#firstname# #lastname# (###userid#)</td>
							</tr>		
						</cfif>
					<cfelse>
						<tr bgcolor="#iif(get_cbc_users.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
							<td>#firstname# #lastname# (###userid#)</td>
						</tr>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
</table>

</cfoutput>

</body>
</html>