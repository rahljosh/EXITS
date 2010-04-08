<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
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

<!--- get total students in each program according to the company --->
<cfquery name="total_students" datasource="caseusa">
SELECT 	s.studentid, s.programid as program, p.programname
FROM	smg_students s
INNER JOIN 	smg_programs p ON s.programid = p.programid
INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
WHERE 	s.active = '1' AND c.continent = '#form.continent#'
	<cfif client.companyid is 5><cfelse>AND s.companyid = '#client.companyid#'</cfif>
 	<cfif form.status is 1>AND hostid != '0' AND s.host_fam_approved <= '4'</cfif>
	<cfif form.status is 2>AND hostid = '0'</cfif>
	<cfif form.regionid is 0><cfelse>AND s.regionassigned = '#form.regionid#'</cfif>
	AND	( <cfloop list=#form.programid# index='prog'>
		s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
</cfquery>

<cfoutput>
<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Total of Students Per Region</span>
</table>
<br>

<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th colspan="2">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of Students <cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in program (s): #total_students.recordcount#</div>
	<cfif form.continent is not 0>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Continent: &nbsp; #form.continent#</cfif>
</th></tr>
<tr><th width="75%">Country</th><th width="25%">Total</th></tr>

<cfquery name="totals_in_region" datasource="caseusa">
	SELECT 	count(studentid) as total, r.regionname, r.regionid, programid
	FROM 	smg_students
	INNER JOIN smg_countrylist c ON countryresident = c.countryid
	INNER JOIN smg_regions r ON r.regionid = regionassigned
	WHERE 	smg_students.active = '1' 
		 AND c.continent = '#form.continent#' 
		<cfif form.regionid is 0><cfelse>AND regionassigned = '#form.regionid#'</cfif>
		<cfif form.status is 1>AND hostid != '0' AND s.host_fam_approved <= '4'</cfif>
		<cfif form.status is 2>AND hostid = '0'</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
	GROUP BY regionname
	ORDER BY regionname
</cfquery>

<cfloop query="totals_in_region"> <!--- region loop --->
	
	<!--- Get countries according to the program --->
	<cfquery name="total_per_country" datasource="caseusa">
	SELECT 	count(studentid) as total_students, 
	countryname
	FROM 	smg_students
	INNER JOIN smg_countrylist c ON countryresident = c.countryid
	WHERE 	active = '1' 
		AND c.continent = '#form.continent#'
		AND regionassigned = '#totals_in_region.regionid#'
		<cfif form.status is 1>AND hostid != '0' AND s.host_fam_approved <= '4'</cfif>
		<cfif form.status is 2>AND hostid = '0'</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
	GROUP BY Countryname
	</cfquery>

	<!--- 0 students will skip the table --->
	<cfif total_per_country.recordcount is 0><cfelse>
		<tr><td align="center"><b>#totals_in_region.regionname#</b></td>
			<td align="center">#totals_in_region.total#</td></tr>
		<!--- Country Loop --->
		<cfloop query="total_per_country">
		<tr bgcolor="#iif(total_per_country.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="75%">#countryname#</td>
			<td width="25%" align="center">#total_students#</td>
		</tr>
		</cfloop>
		<tr><td colspan="2">&nbsp;</td></tr>
	</cfif>
</cfloop> <!--- get regions --->
</table>
<br><br>

<cfquery name="get_list_countries" datasource="caseusa">
	SELECT *
	FROM smg_countrylist
	WHERE continent = '#form.continent#' 
	ORDER BY countryname
</cfquery>

<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center" bgcolor="ededed">
<cfif form.continent is 'Europe'>European<cfelse>#form.continent#n</cfif> countries included in this report:</td></tr>	
<tr><td><cfloop query="get_list_countries">#get_list_countries.countryname# &nbsp; &nbsp;</cfloop></td></tr>
<tr><td><font size="-3"><i>If you would like to add/delete countries, please go to Tools -> Countries</i></font></td></tr>	
</table>

</cfoutput>	