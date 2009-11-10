<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
SELECT	programid, programname, type
FROM 	smg_programs 
LEFT OUTER JOIN smg_program_type ON type = programtypeid
WHERE 	<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>

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
	select s.studentid, s.firstname, s.familylastname, u.businessname
	from smg_students s
	INNER JOIN smg_users u ON u.userid = intrep
	WHERE s.companyid = #client.companyid# and s.active = '1' and hostid = '0' and (
		<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
			   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		   </cfloop>)
</cfquery>

<table width='95%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Total of Unplaced Days</cfoutput></span>
</table>
<br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<cfoutput query="get_program"><b>Program: (#ProgramID#) #programname#</b><br></cfoutput>
	<cfoutput>Total of #get_total_students.recordcount# Unplaced Students</cfoutput>
	</td></tr>
</table><br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">Region</th> <th width="25%">Total Assigned</th></tr>
</table>
<br>
<cfloop query="get_region">
	<!--- Get Students By Region --->
	<Cfquery name="get_students" datasource="MySQL">
	select s.studentid, s.firstname, s.familylastname, s.sex, s.dateapplication, 
			u.businessname
	from smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	where s.active = '1' and s.regionassigned = '#get_region.regionid#' and s.companyid = '#client.companyid#' and  hostid = '0' and (
		<cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop>)
	</cfquery>  <!--- PS: PROGRAM TYPE = 3 - 1ST SEMESTER --->
	
	<cfif #get_students.recordcount# is 0><cfelse>
		<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">	
		<tr><th width="75%"><cfoutput>#get_region.regionname#</th><td width="25%" align="center">#get_students.recordcount#</td></cfoutput></tr>
		</table>
			<table width='95%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr><td width="8%"><b>ID</b></th>
					<td width="28%"><b>Sudent</b></td>
					<td width="10%"><b>Sex</b></td>
					<td width="28%"><b>Intl. Agent</b></td>
					<td width="14%"><b>Date Entry</b></td>
					<td width="12%" align="center"><b>Days Unplaced</b></td></tr>	
				<cfoutput query="get_students">
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td>#sex#</td>
					<td>#businessname#</td>
					<td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td>
					<td align="center">#DateDiff('d',dateapplication, now())#</td></tr>							
				</cfoutput>	
			</table><br>
	</cfif>
</cfloop>