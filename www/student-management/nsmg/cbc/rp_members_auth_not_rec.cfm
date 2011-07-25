<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Host Members Authorization Form Not Received</title>
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
<cfquery name="get_regions" datasource="MySQL">
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
	<tr><th bgcolor="ededed">#companyshort.companyshort# &nbsp; - &nbsp; CBC Authorization Host Members 18+ Form Not Received</th></tr>
	<tr><td>* Better if printed in landscape format.</td></tr>
</table>

<table align="center" width="90%" frame="below">
	<tr bgcolor="ededed">
		<td width="20%"><b>Student</b></td>
		<td width="15%"><b>Placement Date</b></td>
		<td width="20%"><b>Host Member</b></td>
		<td width="20%"><b>Member of</b></td>
		<td width="25%"><b>Placing Rep.</b></td>
	</tr>
	<tr bgcolor="ededed"><th colspan="6">Region</th></tr>
</table>

	<!--- <cfset startdate = '#DateFormat(now(), 'yyyy')#-09-01'> --->
		
	<cfloop query="get_regions">

		<!--- GET HOST FAMILIES WITH KIDS 18+ --->
		<cfquery name="get_hosts" datasource="MySQL">
			SELECT DISTINCT h.hostid
			FROM smg_host_children kids  
			INNER JOIN smg_hosts h ON kids.hostid = h.hostid
			INNER JOIN smg_students s ON s.hostid = h.hostid
			INNER JOIN smg_programs p ON p.programid = s.programid
			INNER JOIN smg_users u ON u.userid = s.placerepid
			WHERE h.active = '1'
				AND s.active = '1'
				AND kids.liveathome = 'yes'
                AND kids.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				AND (DATEDIFF(now(), kids.birthdate)/365) > 18
				AND p.enddate > now()
				AND p.seasonid = <cfqueryparam value="#form.seasonid#" cfsqltype="cf_sql_integer">
				AND s.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
				AND s.regionassigned = <cfqueryparam value="#get_regions.regionid#" cfsqltype="cf_sql_integer">
			ORDER BY u.lastname, h.familylastname
		</cfquery>
		<table align="center" width="90%" frame="below">
		<tr><th bgcolor="DFE9EE">#get_regions.regionname#</th></tr>
		<tr>
			<td colspan="2">
				<table align="center" width="100%">
				<cfset count = '0'>
				<cfloop query="get_hosts">
					<cfquery name="get_kids" datasource="MySql">
						SELECT DISTINCT kids.childid, kids.membertype, kids.name, kids.middlename, kids.lastname, kids.birthdate,
								h.hostid, h.familylastname,
								u.firstname as placefirstname, u.lastname as placelastname, u.userid,
								s.firstname as stufirstname, s.familylastname as stulastname, s.studentid, s.dateplaced,
								p.startdate
						FROM smg_host_children kids 
						INNER JOIN smg_hosts h ON kids.hostid = h.hostid
						INNER JOIN smg_students s ON s.hostid = h.hostid
						INNER JOIN smg_users u ON u.userid = s.placerepid
						INNER JOIN smg_programs p ON p.programid = s.programid
						WHERE kids.hostid = '#get_hosts.hostid#'
							AND s.active = '1'
							AND (DATEDIFF(now(), kids.birthdate)/365) > 18
							AND kids.liveathome = 'yes'
                            AND kids.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
							AND kids.childid NOT IN (SELECT familyid FROM smg_hosts_cbc WHERE cbc_type = 'member')
					</cfquery>
					<cfloop query="get_kids">
						<cfif #DateDiff('yyyy', birthdate, startdate)# GTE 18>
							<cfset count = count + 1>
							<tr bgcolor="#iif(get_kids.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
								<td width="20%">#stufirstname# #stulastname# (###studentid#)</td>
								<td width="15%">#DateFormat(dateplaced, 'mm/dd/yy')#</td>
								<td width="20%">#name# #middlename# #lastname# - #DateDiff('yyyy', birthdate, now())# years old</td>
								<td width="20%">#familylastname# Family (###hostid#)</td>
								<td width="25%">#placefirstname# #placelastname# (###userid#)</td>
							</tr>
						</cfif>
					</cfloop>
				</cfloop>
				</table><br>
			</td>
		</tr>				
	<!---regions--->
	</cfloop> 
</table>

</cfoutput>

</body>
</html>