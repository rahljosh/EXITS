<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Document Tracking Report</title>
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
	SELECT 
    	s.studentid, s.firstname, s.familylastname, s.sex, s.country, s.uniqueid, s.programid, s.dob,
		smg_programs.programname,
		u.businessname,
		sc.schoolname,
		stu_prog.datecreated, stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.hf_placement, stu_prog.i20received,
		stu_prog.hf_application, stu_prog.transfer_type, stu_prog.return_student,
        IFNULL(alp.name, 'n/a') AS PHPReturnOption
	FROM 
    	smg_students s
	INNER JOIN
    	php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN 
    	smg_programs ON smg_programs.programid = stu_prog.programid 
	LEFT JOIN 
    	smg_users u on u.userid = s.intrep 
	LEFT JOIN 
    	php_schools sc ON sc.schoolid = stu_prog.schoolid
    LEFT OUTER JOIN
        applicationLookUp alp ON alp.fieldID = stu_prog.return_student
             AND
                fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHPReturnOptions">            
    WHERE 
    	stu_prog.companyid = '#client.companyid#' 
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
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - Document Tracking Report</span></td></tr>
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
		<td width="16%"><b>Student</b></td>
		<td width="7%"><b>DOB</b></td>
		<td width="15%"><b>Intl. Agent</b></td>
		<td width="7%"><b>Date Entered</b></td>
		<td width="20%"><b>School</b></td>
		<td width="7%"><b>Ret/Trans/Ext</b></td>
		<td width="7%"><b>School Accep.</b></td>
		<td width="7%"><b>I-20</b></td>
		<td width="7%"><b>HF Place</b></td>
		<td width="7%"><b>HF App</b></td>
	</tr>
</table><br>

<table width="95%" cellpadding=2 cellspacing="0" align="center" frame="below">	
	<cfloop query="get_students">
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td width="16%">#firstname# #familylastname# (###studentid#)</td>
			<td width="8%"><cfif dob NEQ ''>#DateFormat(dob, 'mm/dd/yyyy')#</cfif></td>			
			<td width="16%">#businessname#</td>
			<td width="8%"><cfif datecreated NEQ ''>#DateFormat(datecreated, 'mm/dd/yyyy')#</cfif></td>
			<td width="20%">#schoolname#</td>
			<td width="7%"><i><font size="-2">#PHPReturnOption#</font></i></td>
			<td width="8%"><i><font size="-2"><cfif school_acceptance NEQ ''>#DateFormat(school_acceptance, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
			<td width="8%"><i><font size="-2"><cfif i20received NEQ ''>#DateFormat(i20received, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
			<td width="8%"><i><font size="-2"><cfif hf_placement NEQ ''>#DateFormat(hf_placement, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
			<td width="8%"><i><font size="-2"><cfif hf_application NEQ ''>#DateFormat(hf_application, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>		
		</tr>								
	</cfloop>
</table><br><br>

</cfoutput>

</body>
</html>
