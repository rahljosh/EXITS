<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
SELECT	*
FROM 	smg_programs 
LEFT OUTER JOIN smg_program_type
ON type = programtypeid
WHERE 	(<cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="get_region" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is  not 0>
			AND regionid = '#form.regionid#'	
		</cfif>
	ORDER BY regionname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="caseusa">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# and active = '1'
		AND hostid <> '0' AND doubleplace <> '0'
		AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<table width='100%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Double Placement Students</cfoutput></span>
</table>
<br>

<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfoutput query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
	<cfoutput>Total of Students <b>placed</b> in program: #get_total_students.recordcount#</cfoutput>
</td></tr>

<br> <!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
</table>
<br>

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>
	<Cfquery name="get_total_in_region" datasource="caseusa">
		select studentid
		from smg_students
		where active = '1' AND regionassigned = '#get_region.regionid#'  AND companyid = '#client.companyid#' 
						AND hostid <> '0' AND doubleplace <> '0'
						AND (<cfloop list=#form.programid# index='prog'>
						programid = #prog# 
						<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
						</cfloop> )
	</cfquery> 
	
	<cfif get_total_in_region.recordcount is not 0>
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="#CCCCCC"><cfoutput>#get_region.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td></cfoutput></tr>
	</table><br>

	<Cfquery name="get_students_region" datasource="caseusa">
		select studentid, countryresident, firstname, familylastname, sex, programid, placerepid, date_pis_received,
		dblplace_doc_stu, dblplace_doc_fam, dblplace_doc_host, dblplace_doc_school, dblplace_doc_dpt
		from smg_students
		where active = '1' AND regionassigned = '#current_region#' 
					 AND companyid = '#client.companyid#' AND hostid <> '0'
					 AND doubleplace <> '0' 
						AND (<cfloop list=#form.programid# index='prog'>
						programid = #prog# 
						<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
						</cfloop> )
	</cfquery> 
		
	<cfif get_students_region.recordcount is not 0> 			
		<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
			<tr>
				<td width="8%">ID</th>
				<td width="30%">Student</td>
				<td width="10%">Placement</td>
				<td width="52%">Missing Documents</td>
			</tr>	
		<cfoutput query="get_students_region">			 
			<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td>#DateFormat(date_pis_received, 'mm/dd/yyyy')#</td>
				<td align="left"><i><font size="-2">
						<cfif dblplace_doc_stu is ''>Student &nbsp; &nbsp; &nbsp;</cfif>
						<cfif dblplace_doc_fam is ''>Natural Family &nbsp; &nbsp; &nbsp;</cfif>
						<cfif dblplace_doc_host is ''>Host Family &nbsp; &nbsp; &nbsp;</cfif>
						<cfif dblplace_doc_school is ''>School &nbsp; &nbsp; &nbsp;</cfif>
						<cfif dblplace_doc_dpt is ''>Department of State &nbsp; &nbsp; &nbsp;</cfif>
						<!--- everything is ok --->
						<cfif dblplace_doc_stu is not '' and dblplace_doc_fam is not '' and dblplace_doc_host is not ''
						and dblplace_doc_school is not '' and dblplace_doc_dpt is not ''>All documents have been received.</cfif>
						</font></i></td>		
			</tr>								
		</cfoutput>	
		</table>
		<br>				
	</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop><br> <!--- cfloop query="get_region" --->