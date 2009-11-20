<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" type="text/css" href="../php.css">
<title>PHP - Returning J1 Students</title>
</head>

<body>

<cfif client.usertype GTE '5'>
	You do not have sufficient rights to edit programs.
	<cfabort>
</cfif>

<cfoutput>
<br />
<table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
	<tr valign="middle" height=24>
		<td width="100%" valign="middle" bgcolor="e9ecf1"><h3 class="style1">&nbsp; R E T U R N I N G &nbsp; &nbsp; J 1 &nbsp; &nbsp; S T U D E N T S </h3></td>
	</tr>
</table>

<cfif NOT IsDefined('form.studentid')>

	<cfform name="get_student" action="index.cfm?curdoc=tools/returning_j1_students" method="post">
	<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
		<tr><td colspan="2">Please use the feature below to assign J1 students to the PHP Program.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td align="right" width="25%">Student ID:</td><td><cfinput name="studentid" type="text" size="4" maxlength="5"></td></tr>
		<tr><td colspan="2" align="center"><cfinput name="Submit" type="image" src="pics/next.gif" border=0></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	</cfform>

<cfelseif NOT IsDefined('form.confirm')>

	<cfquery name="get_student" datasource="MySql">
		SELECT s.studentid, s.firstname, s.familylastname, s.active,
			u.businessname, 
			c.companyshort
			
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		INNER JOIN smg_companies c ON c.companyid = s.companyid
	
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>
	

	<cfform method="post" name="assign_student" action="index.cfm?curdoc=tools/returning_j1_students">
	<cfinput type="hidden" name="studentid" value="#get_student.studentid#">
	<cfinput type="hidden" name="confirm" value="yes">
	<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
		<tr><td colspan="2">Please review the information below. If you wish to transfer this student to PHP please click on the button bellow.</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td align="right" width="25%"><b>Student Name:</b></td><td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#)</td></tr>
		<tr><td align="right"><b>Students Status:</b></td><td><cfif get_student.active EQ '1'>Active<cfelse>Inactive</cfif></td></tr>
		<tr><td align="right"><b>Intl. Representative:</b></td><td>#get_student.businessname#</td></tr>
		<tr><td align="right"><b>Assigned to:</b></td><td>#get_student.companyshort#</td></tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right"><cfinput name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.go(-1)"> &nbsp;  &nbsp; </td>
			<td align="left"> &nbsp;  &nbsp; <cfinput name="Submit" type="image" value="  next  " src="pics/next.gif" alt="Next" border="0"></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	</cfform>
	
<cfelse>

	<cfquery name="get_student" datasource="MySql">
		SELECT s.studentid, s.firstname, s.familylastname, s.active,
			u.businessname, 
			c.companyshort
			
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		INNER JOIN smg_companies c ON c.companyid = s.companyid
		
		WHERE studentid = <cfqueryparam value="#form.studentid#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="search_student" datasource="MySql">
		SELECT studentid
		FROM php_students_in_program 
		WHERE studentid = '#form.studentid#'
			AND companyid = '#client.companyid#'
	</cfquery>

	<cfif search_student.recordcount EQ '0'>
	
		<cfquery name="add_student" datasource="MySql">
			INSERT INTO php_students_in_program 
				(studentid, companyid, inputby, active, datecreated) 
			VALUES ('#get_student.studentid#', '#client.companyid#', '#client.userid#', '1', #CreateODBCDate(now())#)		
		</cfquery>
	
		<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
			<tr><td align="right" width="25%"><b>Student Name:</b></td><td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#) ASSIGNED TO PHP</td></tr>		
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2"><a href="index.cfm?curdoc=tools/returning_j1_students">Return to Main Menu</a></td></tr>
		</table>
	<cfelse>	
		<table border=0 cellpadding=2 cellspacing=2 align="center" width=90%>
			<tr><td align="right" width="25%"><b>Student Name:</b></td><td>#get_student.firstname# #get_student.familylastname# (###get_student.studentid#) is already assigned to PHP.</td></tr>		
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2"><a href="index.cfm?curdoc=tools/returning_j1_students">Return to Main Menu</a></td></tr>
		</table>
	</cfif>
	
</cfif>
</cfoutput>

<!--- 
	<cfquery name="get_student" datasource="MySql">
		SELECT s.studentid, s.firstname, s.familylastname, s.active, s.programid, s.hostid, s.schoolid, s.arearepid, s.placerepid, ds2019_no,
			u.businessname, 
			c.companyshort,
			p.programname
		FROM smg_students s
		LEFT JOIN smg_users u ON u.userid = s.intrep
		LEFT JOIN smg_companies c ON c.companyid = s.companyid
		LEFT JOIN smg_programs p ON p.programid = s.programid
		WHERE s.companyid = '6'
	</cfquery>

	<cfloop query="get_student">
		
		<cfquery name="search" datasource="MySql">
			SELECT studentid
			FROM php_students_in_program
			WHERE studentid = '#get_student.studentid#'
		</cfquery>

		<cfif search.recordcount EQ '0'>
			<cfquery name="add_student" datasource="MySql">
				INSERT INTO php_students_in_program 
					(studentid, companyid, programid, hostid, schoolid, arearepid, placerepid, inputby, active, datecreated, i20no) 
				VALUES ('#get_student.studentid#', '#client.companyid#', '#get_student.programid#', '#get_student.hostid#',
				'#get_student.schoolid#', '#get_student.arearepid#', '#get_student.placerepid#', '#client.userid#', '1', 
				#CreateODBCDate(now())#, '#get_student.ds2019_no#')		
			</cfquery>
		</cfif>
	</cfloop>

 --->
</body>
</html>