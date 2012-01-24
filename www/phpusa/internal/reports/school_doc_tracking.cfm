<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Document Tracking Report</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif not IsDefined('FORM.programid')>
	<cfinclude template="../error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="qGetPrograms" datasource="MYSQL">
	SELECT	
    	*
	FROM 	
    	smg_programs 
	LEFT JOIN 
    	smg_program_type ON type = programtypeid
	WHERE 
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
</cfquery>

<cfquery name="qGetResults" datasource="MySql">
	SELECT 
    	s.studentid, 
        s.firstname, 
        s.familylastname, 
        s.sex, 
        s.country, 
        s.uniqueid, 
        s.programid, 
        s.dob,
        s.php_grade_student,
		smg_programs.programname,
		u.businessname,
		sc.schoolname,
		php.datecreated, 
        php.dateplaced, 
        php.school_acceptance, 
        php.hf_placement, 
        php.i20received,
		php.hf_application, 
        php.transfer_type, 
        php.return_student,
        
        IFNULL(alp.name, 'n/a') AS PHPReturnOption
	FROM 
    	smg_students s
	INNER JOIN
    	php_students_in_program php ON php.studentid = s.studentid
	LEFT JOIN 
    	smg_programs ON smg_programs.programid = php.programid 
	LEFT JOIN 
    	smg_users u on u.userid = s.intrep 
	LEFT JOIN 
    	php_schools sc ON sc.schoolid = php.schoolid
    LEFT OUTER JOIN
        applicationLookUp alp ON alp.fieldID = php.return_student
             AND
                fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="PHPReturnOptions">            
    WHERE 
    	php.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
    AND 
    	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND
    	php.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
    ORDER BY 
    	#FORM.orderby# 
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
		<cfloop query="qGetPrograms"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		Total of Students <b>placed</b> in program: #qGetResults.recordcount#
	</td></tr>
</table><br>

<table width="95%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##666;">	
	<tr>
		<td width="15%"><b>Student</b></td>
        <td width="6%"><b>GRD.</b></td>
		<td width="7%"><b>DOB</b></td>
		<td width="15%"><b>Intl. Agent</b></td>
		<td width="7%"><b>Date Entered</b></td>
		<td width="16%"><b>School</b></td>
		<td width="7%"><b>Ret/Trans/Ext</b></td>
		<td width="7%"><b>School Accep.</b></td>
		<td width="6%"><b>I-20</b></td>
		<td width="7%"><b>HF Place</b></td>
		<td width="7%"><b>HF App</b></td>
	</tr>
	<cfloop query="qGetResults">
		<tr bgcolor="#iif(qGetResults.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#qGetResults.firstname# #qGetResults.familylastname# (###qGetResults.studentid#)</td>
            <td><cfif VAL(qGetResults.php_grade_student)>#qGetResults.php_grade_student#th</cfif></td>
			<td><cfif qGetResults.dob NEQ ''>#DateFormat(qGetResults.dob, 'mm/dd/yyyy')#</cfif></td>			
			<td>#qGetResults.businessname#</td>
			<td><cfif qGetResults.datecreated NEQ ''>#DateFormat(qGetResults.datecreated, 'mm/dd/yyyy')#</cfif></td>
			<td>#qGetResults.schoolname#</td>
			<td><i><font size="-2">#qGetResults.PHPReturnOption#</font></i></td>
			<td><i><font size="-2"><cfif qGetResults.school_acceptance NEQ ''>#DateFormat(qGetResults.school_acceptance, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
			<td><i><font size="-2"><cfif qGetResults.i20received NEQ ''>#DateFormat(qGetResults.i20received, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
			<td><i><font size="-2"><cfif qGetResults.hf_placement NEQ ''>#DateFormat(qGetResults.hf_placement, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>
			<td><i><font size="-2"><cfif qGetResults.hf_application NEQ ''>#DateFormat(qGetResults.hf_application, 'mm/dd/yy')#<cfelse>n/a</cfif></font></i></td>		
		</tr>								
	</cfloop>
</table>

</cfoutput>

</body>
</html>
