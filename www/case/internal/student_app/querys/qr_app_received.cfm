<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Print Application</title>
</head>

<body>

<cfquery name="get_student" datasource="caseusa">
	SELECT s.studentid, s.firstname, s.familylastname, s.app_current_status, s.app_indicated_program, s.randid,
		u.userid, u.businessname, u.email as intrepemail, u.congrats_email,
		p.app_program
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_student_app_programs p ON p.app_programid = s.app_indicated_program
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
</cfquery>	

<cfquery name="get_latest_date" datasource="caseusa">
	SELECT id, date
	FROM smg_student_app_status
	WHERE studentid = <cfqueryparam value="#get_student.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY id DESC
</cfquery>

<cfquery name="get_status" datasource="caseusa">
	SELECT status 
	FROM smg_student_app_status
	WHERE date = '#get_latest_date.date#' 
		AND studentid = <cfqueryparam value="#get_student.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Set application received - New Status 8 ---->
<cfif get_student.recordcount EQ '1' AND get_student.app_current_status EQ '7' AND get_status.status EQ '7'>

	<cfquery name="application_received" datasource="caseusa">
		INSERT INTO smg_student_app_status (studentid, status, date, approvedby)
		VALUES ('#get_student.studentid#', '8', #now()#, '#client.userid#')
	</cfquery>
	<cfquery name="application_received" datasource="caseusa">
		UPDATE smg_students 
		SET app_current_status = '8'
		WHERE studentid = '#get_student.studentid#' 
	</cfquery>
		
	<!--- APPLICATION RECEIVED - SEND OUT NOTIFICATION --->
	<cfinclude template="../app_received_email.cfm">
		
</cfif>

<meta http-equiv="refresh" content="3;url=close_window.cfm">
<body onLoad="opener.location.reload()"> 
<table align="center" width="95%" bordercolor="e2efc7" frame="box" cellpadding="0" cellspacing="0">
	<tr><td><img src="../pics/top-email.gif" border="0"></td></tr>
	<tr><td align="center"><br />This application has been received and is now waiting to be approved. <br />This window should close automatically.</td></tr>
	<tr><td bgcolor="e2efc7">&nbsp;</td></tr>
</table>
</body>
</html>