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
	SELECT s.studentid, s.firstname, s.familylastname, s.sex, s.country, s.uniqueid, s.programid, s.dob, s.grades,
		smg_programs.programname,
		u.businessname,
		stu_prog.datecreated, stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.hf_placement, 
		stu_prog.hf_application, stu_prog.transfer_type, stu_prog.return_student
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN smg_programs ON smg_programs.programid = stu_prog.programid 
	LEFT JOIN smg_users u on u.userid = s.intrep 
	WHERE stu_prog.companyid = '#client.companyid#' 
		AND stu_prog.active = '1'
		<cfif form.grades NEQ ''>AND grades = '#form.grades#'</cfif>
		AND (<cfloop list="#form.programid#" index='prog'>
				stu_prog.programid = #prog# <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			 </cfloop> )
		ORDER BY s.grades DESC, s.familylastname 
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>

<table width="95%" cellpadding=0 cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Students by Grade Level</span></td></tr>
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
		<td width="30%"><b>Student</b></td>
		<td width="15%"><b>DOB</b></td>
		<td width="25%"><b>Intl. Agent</b></td>
		<td width="15%"><b>Program</b></td>
		<td width="15%"><b>Last Grade Completed</b></td>
	</tr>
	<cfloop query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td><cfif dob NEQ ''>#DateFormat(dob, 'mm/dd/yyyy')#</cfif></td>			
			<td>#businessname#</td>
			<td>#programname#</td>
			<td align="center">#grades#</td>
		</tr>								
	</cfloop>
</table><br><br>

</cfoutput>

</body>
</html>
