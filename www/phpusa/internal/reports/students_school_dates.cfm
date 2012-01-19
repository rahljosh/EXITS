<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Students Per Grade</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif not IsDefined('form.programid')>
	<cfinclude template="../error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list="#form.programid#" index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<cfquery name="get_students" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.sex, s.country, s.uniqueid, s.programid, s.dob,
		p.programname, p.seasonid, p.type,
		u.businessname,
		stu_prog.schoolid, stu_prog.datecreated, stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.hf_placement, 
		stu_prog.hf_application, stu_prog.transfer_type,
		sc.schoolname,
		sc_dates.year_begins, sc_dates.semester_ends, sc_dates.semester_begins, sc_dates.year_ends 
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
	LEFT JOIN smg_programs p ON p.programid = stu_prog.programid 
	LEFT JOIN smg_users u on u.userid = s.intrep 
	LEFT JOIN php_school_dates sc_dates ON (sc_dates.seasonid = p.seasonid AND sc_dates.schoolid = stu_prog.schoolid)
	WHERE stu_prog.companyid = '#client.companyid#' 
		AND stu_prog.active = '1'
		<cfif form.intrep NEQ 0>AND s.intrep = '#form.intrep#'</cfif>
		AND (<cfloop list="#form.programid#" index='prog'>
				stu_prog.programid = #prog# <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			 </cfloop> )
	GROUP BY s.studentid
	ORDER BY u.businessname, s.familylastname 
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>

<table width="95%" cellpadding=0 cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - School Dates</span></td></tr>
</table><br>

<table width="95%" cellpadding=4 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		Total of Students: #get_students.recordcount#
	</td></tr>
</table><br>

<table width="95%" cellpadding=0 cellspacing="0" align="center" frame="below">	
	<tr>
		<td width="20%"><b>Student</b></td>
		<td width="25%"><b>Intl. Agent</b></td>
		<td width="10%"><b>Program</b></td>
		<td width="25%"><b>School</b></td>
		<td width="10%"><b>Start Date</b></td>
		<td width="10%"><b>End Date</b></td>
	</tr>
	<cfloop query="get_students">
		<!--- PROGRAM TYPES
		1 AYP 10 months
		2 AYP 12 months
		3 AYP 1st semester
		4 AYP 2nd semester
		--->
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td>#businessname#</td>
			<td>#programname#</td>
			<td>#schoolname#</td>
			<td>
				<cfif type EQ 4>
					<cfif semester_begins NEQ ''>#DateFormat(semester_begins, 'mm/dd/yyyy')#</cfif>
				<cfelse>
					<cfif year_begins NEQ ''>#DateFormat(year_begins, 'mm/dd/yyyy')#</cfif>
				</cfif>		
			</td>
			<td>
				<cfif type EQ 3>
					<cfif semester_ends NEQ ''>#DateFormat(semester_ends, 'mm/dd/yyyy')#</cfif>
				<cfelse>
					<cfif year_ends NEQ ''>#DateFormat(year_ends, 'mm/dd/yyyy')#</cfif>
				</cfif>
			</td>
		</tr>								
	</cfloop>
</table><br><br>

</cfoutput>

</body>
</html>
