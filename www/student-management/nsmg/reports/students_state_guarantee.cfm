<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>
<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	DISTINCT 
		p.programid, p.programname, 
		c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE 	<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is 0><cfelse>AND regionid = '#form.regionid#'</cfif>
	ORDER BY regionname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid, 
	countryname
	FROM 	smg_students 
	INNER JOIN smg_countrylist c ON countryresident = c.countryid
	WHERE companyid = #client.companyid# and active = '1'
	<cfif form.status is 1>AND hostid != '0' AND s.host_fam_approved <= '4'</cfif>
	<cfif form.status is 2>	AND hostid = '0'</cfif>
	AND	( <cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
    AND
    	smg_students.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
</cfquery>


<table width='90%' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Students State Preference per Region</cfoutput></span>
</table>
<br>

<cfoutput>
<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of Students <cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in program: #get_total_students.recordcount#</div>
</td></tr>
</table>
</cfoutput><br>

<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">Region</th> <th width="25%">Total Assigned</th></tr>
</table><br>

<cfloop query="get_region">
	<!--- Get Students By Region --->
	<Cfquery name="get_students" datasource="MySQL">
		select studentid, firstname, familylastname, sex, dob,
		countryname,
		state.statename
		FROM smg_students
		INNER JOIN smg_countrylist c ON countryresident = c.countryid
		INNER JOIN smg_states state ON state_guarantee = state.id
		where smg_students.active = '1' and regionassigned = '#get_region.regionid#' and companyid = '#client.companyid#'
		<cfif form.status is "1">AND hostid != '0' AND s.host_fam_approved <= '4'</cfif>
		<cfif form.status is "2">AND hostid = '0'</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		Order by firstname
	</cfquery>  

	<cfif #get_students.recordcount# is 0><cfelse>
		<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><th width="75%"><cfoutput>#get_region.regionname#</th><td width="25%" align="center">#get_students.recordcount#</td></cfoutput></tr>
		</table>
			<table width='90%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr><td width="8%"><b>ID</b></th>
					<td width="19%"><b>First Name</b></td>
					<td width="19%"><b>Last Name</b></td>
					<td width="10%"><b>Gender</b></td>
					<td width="10%"><b>DOB</b></td>
					<td width="20%"><b>Country</b></td>
					<td width="14%"><b>State Preference</b></td></tr>	
				<cfoutput query="get_students">
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#studentid#</td>
					<td>#firstname#</td>
					<td>#familylastname#</td>
					<td>#sex#</td>
					<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
					<td>#countryname#</td>
					<td>#statename#</td></tr>							
				</cfoutput>	
			</table><br>
	</cfif>
</cfloop><br>
</body>
</html>
