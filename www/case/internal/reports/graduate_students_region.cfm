<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Graduate Students</title>
</head>

<body>

<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get total students in each program according to the company --->
<cfquery name="get_total_stu" datasource="caseusa">
	SELECT 	programname
	FROM	smg_programs
	WHERE <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> 
	ORDER BY programname
</cfquery>

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Graduated Students<br> (12th grade / Placed only)</cfoutput></span>
</table><br>

<!--- Get countries according to the program --->
<cfquery name="list_regions" datasource="caseusa">
	SELECT 	count(studentid) as total_students, regionname, regionid
	FROM 	smg_students s
	INNER JOIN smg_regions r ON regionassigned = r.regionid
	WHERE 	(s.active = '1' 
			AND hostid != '0'
			<cfif IsDefined('form.dateplaced')>AND s.dateplaced <= #CreateODBCDate(form.dateplaced)#</cfif>
			AND	( <cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			<cfif form.regionid NEQ '0'>AND regionassigned = '#form.regionid#'</cfif>
			AND grades = '12')
		OR
			(s.active = '1' 
			AND hostid != '0'
			<cfif IsDefined('form.dateplaced')>AND s.dateplaced <= #CreateODBCDate(form.dateplaced)#</cfif>
			AND	( <cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			<cfif form.regionid NEQ '0'>AND regionassigned = '#form.regionid#'</cfif>
			AND grades = '11' and (countryresident = '49' or countryresident = '237'))
	GROUP BY regionname	
</cfquery>

<!--- 0 students will skip the table --->
<cfif list_regions.recordcount is 0><cfelse> 	
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<cfoutput>
		<tr>
			<td colspan="2">Program(s): &nbsp;<br> <cfloop query="get_total_stu"><i><u>#programname# &nbsp;</u></i><br></cfloop></td>
		</tr>
		</cfoutput>
		<tr><th width="75%">Region</th> <th width="25%">Total</th></tr>
		<!--- Country Loop --->
 		<cfoutput query="list_regions">
			<tr><th width="75%">#regionname#</th><th width="25%" align="center">#total_students#</th></tr>
			<cfquery name="list_students" datasource="caseusa">
				SELECT 	studentid, firstname, familylastname, r.regionname, dateplaced
				FROM 	smg_students s
				INNER JOIN smg_regions r ON regionassigned = r.regionid
				WHERE 	(s.active = '1'
						AND hostid != '0' 
						<cfif IsDefined('form.dateplaced')>AND s.dateplaced <= #CreateODBCDate(form.dateplaced)#</cfif>
						AND	( <cfloop list=#form.programid# index='prog'>
							programid = #prog# 
							<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
							</cfloop> )
						AND regionassigned = '#list_regions.regionid#'
						AND grades = '12')
					OR
						(s.active = '1' 
						AND hostid != '0'
						<cfif IsDefined('form.dateplaced')>AND s.dateplaced <= #CreateODBCDate(form.dateplaced)#</cfif>
						AND	( <cfloop list=#form.programid# index='prog'>
							programid = #prog# 
							<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
							</cfloop> )
						AND regionassigned = '#list_regions.regionid#'
						AND grades = '11' and (countryresident = '49' or countryresident = '237'))
				ORDER BY familylastname			
			</cfquery>
		<cfloop query="list_students">
		<tr bgcolor="#iif(list_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#"><td colspan="2"> &nbsp; &nbsp; #firstname# #familylastname# (#studentid#)</td></tr>
		</cfloop>
		</cfoutput>
	</table>
	<br><br>	
</cfif>

</body>
</html>