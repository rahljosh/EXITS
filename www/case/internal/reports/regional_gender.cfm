<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
SELECT	ProgramID, programname, startdate, enddate, companyid, type,
		programtype
FROM 	smg_programs 
LEFT OUTER JOIN smg_program_type
ON type = programtypeid
WHERE programid = #form.programid#
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="caseusa">
SELECT	regionname, company, regionid
FROM smg_regions
WHERE company = '#client.companyid#'
ORDER BY regionname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="caseusa">
SELECT	count(studentid) as Count_stu
FROM 	smg_students
WHERE programid = #form.programid# and companyid = #client.companyid# and active = '1'
</cfquery>

<span class="application_section_header"><cfoutput>#companyshort.companyshort# Gender Report</cfoutput></span>
<br>

<cfoutput query="get_program">
<table width="70%" cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program: <b> &nbsp; (#ProgramID#) &nbsp; #programname#</b><br>
	Starts  &nbsp; #dateformat(StartDate)#,  &nbsp; Ends  &nbsp; #dateformat(endDate)#<br>
	Total of Students: &nbsp; #get_total_students.count_stu#<br>
</td></tr>
</table>
</cfoutput>
<br>

<table width="70%" cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="70%">Region</th> <th width="30%" align="center">Total Assigned</th></tr>
</table>
<br>
<cfloop query="get_region">
	
	<!--- Get Total Students By Region --->
	<Cfquery name="stu_count" datasource="caseusa">
	select studentid, countryresident
	from smg_students
	where active = '1' and regionassigned = '#get_region.regionid#' and companyid = '#client.companyid#' and programid = #form.programid#
	</cfquery>  

	<cfif #stu_count.recordcount# is 0><cfelse>
		<table width="70%" cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr>	<th width="70%"><cfoutput>#get_region.regionname#</th>
			 	<td width="30%" colspan="2" align="center">#stu_count.recordcount#</td></cfoutput>
		</tr>
			<!--- Get Countries --->
			<Cfquery name="get_country" datasource="caseusa">
			SELECT countryresident, regionassigned, 
					countryname, countryid
			FROM smg_students
			INNER JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
			where active = '1' and regionassigned = '#get_region.regionid#' and companyid = '#client.companyid#' and programid = #form.programid#
			group by countryid
			ORDER BY countryname
			</cfquery>				

			<cfif #get_country.recordcount# is 0><cfelse>
				<tr><td width="70%"></td><td width="15%" align="center">Female</td><td width="15%" align="center">Male</td></tr>						
				<cfloop query="get_country">
					<cfoutput>				
					<tr><td bgcolor="#iif(get_country.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">#get_country.countryname#</td>
							
					<!--- Get Total Female by Country --->
					<Cfquery name="get_gender" datasource="caseusa">
					select sum(if(Sex = 'Female', 1, 0)) as total_female,
					       sum(if(Sex = 'Male', 1, 0)) as total_male
					from smg_students
					where active = '1' and regionassigned = '#get_country.regionassigned#' 
					and companyid = '#client.companyid#' and countryresident = '#get_country.countryid#' and programid = #form.programid#
					</cfquery>
					<td align="center" bgcolor="#iif(get_country.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">#numberformat(get_gender.total_female)#</td>
					<td align="center" bgcolor="#iif(get_country.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">#numberformat(get_gender.total_male)#</td></tr>						
					</cfoutput>
				</cfloop>
				</table>			
				<br>	
			</cfif>
	</cfif>
</cfloop>
<br>

