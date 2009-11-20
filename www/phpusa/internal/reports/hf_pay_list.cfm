<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Host Families to be Paid</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif not IsDefined('form.programid')>
	<cfinclude template="../error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_programs" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list="#form.programid#" index="prog">
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width="95%" cellpadding=0 cellspacing="0" align="center">
	<tr><td align="center"><span class="application_section_header">#companyshort.companyshort# - List of Host Families to be Paid</span></td></tr>
</table><br>

<table width="95%" cellpadding=4 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_programs"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	</td></tr>
</table><br>

<cfloop query="get_programs">
	<cfquery name="get_students" datasource="MySql">
		SELECT DISTINCT stu_prog.programid,
			s.studentid, s.firstname, s.familylastname,
			smg_programs.programname,
			u.businessname,
			sc.schoolid, sc.schoolname,
			h.hostid, h.familylastname as hostlastname, h.motherfirstname, h.motherlastname, h.fatherfirstname, h.fatherlastname,
			h.address, h.city, h.zip, h.state
		FROM smg_students s
		INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
		INNER JOIN php_schools sc ON sc.schoolid = stu_prog.schoolid
		INNER JOIN smg_hosts h ON h.hostid = stu_prog.hostid
		INNER JOIN smg_programs ON smg_programs.programid = stu_prog.programid
		INNER JOIN smg_users u on u.userid = s.intrep 
		WHERE stu_prog.companyid = '#client.companyid#' 
			AND stu_prog.active = '1'
			AND sc.payhost = '1'
			AND stu_prog.programid = '#programid#'
			ORDER BY schoolname, familylastname
	</cfquery>		
	<table width="95%" cellpadding=0 cellspacing="0" align="center" frame="below">	
		<tr><td><b>Program #programname# &nbsp; &nbsp; &nbsp; Total of #get_students.recordcount# student(s)</b></td></tr>	
	</table><br>
	
	<table width="95%" cellpadding=0 cellspacing="0" align="center" frame="below">	
		<tr>
			<td width="16%"><b>Student</b></td>
			<td width="7%"><b>Host Family</b></td>
			<td width="15%"><b>Address</b></td>
			<td width="7%"><b>School</b></td>
		</tr>
	</table><br>
		
	<table width="95%" cellpadding=2 cellspacing="0" align="center" frame="below">	
		<cfloop query="get_students">
			<tr bgcolor="#iif(currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td width="16%">#firstname# #familylastname# (###studentid#)</td>
				<td width="8%">
					<cfif motherlastname NEQ ''>#motherfirstname# #motherlastname#
					<cfelseif fatherlastname NEQ ''>#fatherfirstname# #fatherlastname#</cfif>
					(###hostid#)
				</td>			
				<td width="16%">#address#, #city# #state# #zip#</td>
				<td width="16%">#schoolname# (###schoolid#)</td>
			</tr>
		</cfloop>								
	</table><br><br>
</cfloop>

</cfoutput>
</body>
</html>