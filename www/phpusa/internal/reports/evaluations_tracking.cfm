<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Evaluations/Grades Tracking Report</title>
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
		smg_programs.programname,
		u.businessname,
		sc.schoolname,
		stu_prog.datecreated, stu_prog.doc_evaluation2, stu_prog.doc_evaluation4, stu_prog.doc_evaluation6, stu_prog.doc_evaluation9,
		stu_prog.doc_evaluation12, stu_prog.doc_grade1, stu_prog.doc_grade2, stu_prog.doc_grade3, stu_prog.doc_grade4, stu_prog.doc_grade5, stu_prog.doc_grade6, stu_prog.doc_grade7, stu_prog.doc_grade8, stu_prog.return_student
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN smg_programs ON smg_programs.programid = stu_prog.programid 
	LEFT JOIN smg_users u on u.userid = s.intrep 
	LEFT JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
	WHERE stu_prog.companyid = '#client.companyid#' 
		AND stu_prog.active = '1'
		AND (<cfloop list="#form.programid#" index='prog'>
				stu_prog.programid = #prog# <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			 </cfloop> )
		ORDER BY #form.orderby# 
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>

<table width="95%" cellpadding=0 cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Evaluations/Grades Tracking Report</span></td></tr>
</table><br>

<table width="95%" cellpadding=4 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		Total of Students <b>placed</b> in program: #get_students.recordcount#
	</td></tr>
</table><br>

<table width="95%" cellpadding=0 cellspacing="0" align="center" frame="below">	
	<tr>
		<td width="20%" valign="top"><b>Student</b></td>
		<td width="20%" valign="top"><b>Intl. Agent</b></td>
		<td width="25%" valign="top"><b>School</b></td>
		<td width="20%" align="center">
			<b>Evaluations</b>
			<table width="90%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20%" align="center">1</td>
					<td width="20%" align="center">2</td>
					<td width="20%" align="center">3</td>
					<td width="20%" align="center">4</td>
					<td width="20%" align="center">5</td>
				</tr>				
			</table>
		</td>
		<td width="15%" align="center">
			<b>Grades</b>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="12%" align="center">1</td>
					<td width="12%" align="center">2</td>
					<td width="12%" align="center">3</td>
					<td width="12%" align="center">4</td>
					<td width="12%" align="center">5</td>
					<td width="12%" align="center">6</td>
					<td width="12%" align="center">7</td>
					<td width="12%" align="center">8</td>
				</tr>				
			</table>		
		</td>
	</tr>
</table><br>

<table width="95%" cellpadding=2 cellspacing="0" align="center" frame="below">	
	<cfloop query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="20%" valign="top">#firstname# #familylastname# (###studentid#)</td>
			<td width="20%" valign="top">#businessname#</td>
			<td width="25%" valign="top">#schoolname#</td>
			<td width="20%" align="center">
				<table width="90%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20%" align="center"><cfif doc_evaluation2 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="20%" align="center"><cfif doc_evaluation4 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="20%" align="center"><cfif doc_evaluation6 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="20%" align="center"><cfif doc_evaluation9 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="20%" align="center"><cfif doc_evaluation12 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
					</tr>				
				</table>		
			</td>
			<td width="15%" align="center">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="12%" align="center"><cfif doc_grade1 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade2 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade3 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade4 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade5 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade6 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade7 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
						<td width="12%" align="center"><cfif doc_grade8 NEQ ''><img border="0" src="../pics/checkY.gif"><cfelse><img border="0" src="../pics/checkN.gif"></cfif></td>
					</tr>				
				</table>		
			</td>
		</tr>								
	</cfloop>
</table><br><br>

</cfoutput>

</body>
</html>