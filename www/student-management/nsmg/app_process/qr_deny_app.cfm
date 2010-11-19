<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Deny Application</title>
</head>

<body>

<!--- APPLICATION DENIED --->
<cfset newstatus = 9>

<cfquery name="deny_application" datasource="MySQL">
	UPDATE smg_students 
	SET app_current_status = '#newstatus#',
		companyid = '#form.companyid#',
		cancelreason = '#form.cancelreason#',
		active = '0',
		canceldate = #CreateODBCDate(now())#
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery>

<cfquery name="deny_application_status" datasource="MySQL">
	INSERT INTO smg_student_app_status (studentid, status, reason, approvedby)
	VALUES ('#form.studentid#', '#newstatus#', '#form.cancelreason#', '#client.userid#')
</cfquery>

<cfinclude template="email_deny.cfm">

</body>
</html>