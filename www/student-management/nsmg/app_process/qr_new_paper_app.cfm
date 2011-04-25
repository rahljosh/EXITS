<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>Receive Paper Application</title>
</head>

<body>

<cfif form.firstname EQ '' OR form.familylastname EQ ''>
	<br>
	<table width="90%" cellpadding=0 cellspacing=0 border=0 height=24 align="center">
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Applicant Information</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="90%" class="section" align="center">	
		<tr><td align="center"><h2>Sorry, this student account could not be created.</h2><br></td></tr>
		<tr><th>You must fill out both student's first name and last name in order to create an account. Please go back and try again.<br><br>
				<div align="center"><input name="back" type="image" src="pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
			</th>
		</tr>
	</table>
	<table width="90%" cellpadding=0 cellspacing=0 border=0 align="center">
		<tr valign=bottom >
			<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif"></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
		</tr>
	</table>
	<cfabort>
</cfif>	

<cfquery name="check_new_student" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.dob
	FROM smg_students s
	WHERE s.firstname = '#form.firstname#' 
		AND	s.familylastname = '#form.familylastname#'
		AND s.dob = '#DateFormat(form.dob, 'yyyy/mm/dd')#'
		AND s.sex = '#form.sex#'
</cfquery>

<cfif check_new_student.recordcount>
	<br>
	<table width="90%" cellpadding=0 cellspacing=0 border=0 height=24 align="center">
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Applicant Information</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<cfoutput query="check_new_student">
	<table width="90%" class="section" align="center">	
		<tr><td><h2>Sorry, but this student has been entered in the database as follow:</h2><br></td></tr>
		<tr><td><a href="?curdoc=student_info&studentid=#check_new_student.studentid#">#firstname# #familylastname# (###studentid#)</a><br><br>
				<div align="center"><input name="back" type="image" src="pics/back.gif" align="middle" border=0 onClick="history.back()"></div>
			</td>
		</tr>
	</table>
	</cfoutput>
	<table width="90%" cellpadding=0 cellspacing=0 border=0 align="center">
		<tr valign=bottom >
			<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
		</tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="insert_first_page" datasource="mysql">
	INSERT INTO smg_students 
		(uniqueid, familylastname, firstname, dob, sex, countryresident, active, app_current_status, dateapplication, entered_by, app_indicated_program, intrep, companyid)
	VALUES 
		('#form.uniqueid#', '#form.familylastname#', '#form.firstname#', #CreateODBCDate(form.dob)#, '#form.sex#', #form.Countryresidence#, '1', '8', #now()#, '#client.userid#', '#form.app_indicated_program#', '#form.intrep#', #client.companyid#)
</cfquery>

<!--- APPLICATION RECEIVED - SEND OUT NOTIFICATION --->
<cfquery name="get_last_student" datasource="MySql">
	SELECT MAX(studentid) as studentid
	FROM smg_students
</cfquery>

<cfquery name="get_student" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.app_current_status, s.app_indicated_program, s.randid,
		u.userid, u.businessname, u.email as intrepemail, u.congrats_email,
		p.app_program
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	WHERE s.studentid = <cfqueryparam value="#get_last_student.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<!---- CREATE HISTORY ---->
<cfquery name="approve_application" datasource="MySQL">
	INSERT INTO smg_student_app_status (studentid, status, reason, approvedby)
	VALUES ('#get_student.studentid#', '8', 'New paper application', '#client.userid#')
</cfquery>

<!--- APPLICATION RECEIVED - SEND OUT NOTIFICATION --->
<cfinclude template="../student_app/app_received_email.cfm">

<cflocation url="index.cfm?curdoc=app_process/apps_received">

</body>
</html>