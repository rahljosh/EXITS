<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get total students in each program according to the company --->
<cfquery name="get_total_stu" datasource="MySQL">
SELECT 	programname
FROM	smg_programs
WHERE <cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	</cfloop> 
ORDER BY programname
</cfquery>

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Total of Graduated Students<br> (12th grade)</cfoutput></span>
</table><br>

<!--- Get countries according to the program --->
<cfquery name="list_countries" datasource="MySQL">
SELECT 	count(studentid) as total_students, smg_students.countryresident, countryname, countryid
FROM 	smg_students
INNER JOIN smg_countrylist c ON countryresident = c.countryid
WHERE 	(active = '1' 
		AND	( <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		<cfif form.countryid is not '0'>AND countryresident = '#form.countryid#'</cfif>
		AND grades = '12')
	OR
		(active = '1' 
		AND	( <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		<cfif form.countryid is not '0'>AND countryresident = '#form.countryid#'</cfif>
		AND grades = '11' and (countryresident = '49' or countryresident = '237'))
GROUP BY countryname
</cfquery>

<!--- 0 students will skip the table --->
<cfif list_countries.recordcount is 0><cfelse> 	
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<cfoutput>
		<tr>
			<td colspan="2">Program(s): &nbsp;<br> <cfloop query="get_total_stu"><i><u>#programname# &nbsp;</u></i><br></cfloop></td>
		</tr>
		</cfoutput>
		<tr><th width="75%">Country</th> <th width="25%">Total</th></tr>
		<!--- Country Loop --->
 		<cfoutput query="list_countries">
			<tr><th width="75%">#countryname#</th><th width="25%" align="center">#total_students#</th></tr>
<!---		<cfquery name="list_students" datasource="MySql">
			SELECT 	studentid, firstname, familylastname, c.countryname
			FROM 	smg_students
			INNER JOIN smg_countrylist c ON countryresident = c.countryid
			WHERE 	(active = '1' 
					AND	( <cfloop list=#form.programid# index='prog'>
						programid = #prog# 
						<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
						</cfloop> )
					AND countryresident = '#list_countries.countryid#'
					AND grades = '12')
				OR
					(active = '1'  AND countryresident = '#list_countries.countryid#'
					AND	( <cfloop list=#form.programid# index='prog'>
						programid = #prog# 
						<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
						</cfloop> )
					<cfif form.countryid is not '0'>AND countryresident = '#form.countryid#'</cfif>
					AND grades = '11' and (countryresident = '49' or countryresident = '237'))
			ORDER BY familylastname			
		</cfquery>
		<cfloop query="list_students">
		<tr bgcolor="#iif(list_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#"><td colspan="2"> &nbsp; &nbsp; #firstname# #familylastname# (#studentid#)</td></tr>
		</cfloop> --->
		</cfoutput>
	</table>
	<br><br>	
</cfif>