<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Welcome Family Report</title>
</head>
<link rel="stylesheet" href="reports.css" type="text/css">

<body>
<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="get_regions" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid NEQ 0>
			AND regionid = '#form.regionid#'	
		</cfif>
	ORDER BY regionname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="caseusa">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE active = '1'
		AND hostid != '0' 
		AND host_fam_approved < '5'
		AND welcome_family = '1'
		AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<cfoutput>

<table width='100%' cellpadding=4 cellspacing="0" align="center">
<tr><th><span class="application_section_header">#companyshort.companyshort# - Welcome Family Report</span></th></tr>
</table><br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	Total of Students in this report: #get_total_students.recordcount#
</td></tr>
</table><br>

<!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
</table><br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>
	<Cfquery name="get_total_in_region" datasource="caseusa">
		select studentid
		from smg_students
		where active = '1' 
			AND regionassigned = '#get_regions.regionid#'
			AND hostid != '0' 
			AND host_fam_approved < '5'
			AND welcome_family = '1'
			AND (<cfloop list="#form.programid#" index="prog">
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
			<!--- AND (placement_notes LIKE '%welcome family%' OR placement_notes LIKE '%temp family%') --->
	</cfquery> 
	
	<cfif get_total_in_region.recordcount>
	<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="CCCCCC">#get_regions.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td></tr>
	</table>

	<Cfquery name="get_students_region" datasource="caseusa">
		select studentid, countryresident, firstname, familylastname, sex, programid, placerepid, date_pis_received, placement_notes, hostid
		from smg_students
		where active = '1' 
			AND regionassigned = '#current_region#' 
			AND hostid != '0'
			AND host_fam_approved < '5'
			AND welcome_family = '1'
 			AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	</cfquery> 
		
	<cfif get_students_region.recordcount> 			
		<table width='100%' frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
			<tr>
				<td width="8%"><b>ID</b></th>
				<td width="30%"><b>Student</b></td>
				<td width="10%"><b>Placement</b></td>
				<td width="52%"><b>Placement Notes</b></td>
			</tr>	
		<cfloop query="get_students_region">			 
			<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td>#DateFormat(date_pis_received, 'mm/dd/yyyy')#</td>
				<td align="left">#placement_notes#</td>		
			</tr>
			<!---
			<cfif client.userid eq 510>
				<cfquery name="get" datasource="caseusa">
					SELECT historyid, hostid, studentid
					FROM smg_hosthistory
					WHERE studentid = #studentid# AND hostid = #hostid#
					ORDER BY historyid DESC
				</cfquery>
				<cfquery name="update" datasource="caseusa">
					UPDATE	smg_hosthistory			
					SET welcome_family = '1'
					WHERE historyid = '#get.historyid#' 
					LIMIT 1
				</cfquery>
			</cfif>
			--->
		</cfloop>	
		</table>					
	</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	<br>
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop><br> <!--- cfloop query="get_regions" --->

</cfoutput>
</body>
</html>