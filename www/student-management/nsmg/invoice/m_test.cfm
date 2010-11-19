<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>



<!--- <cfdirectory directory="#AppPath.uploadedFiles#invoices_pdf " action="delete" mode="777">
blalbalzzz
<cfabort> --->

<!--- CHECK INVOICE RIGHTS ---->
<!--- <cfinclude template="check_rights.cfm">

<cfquery name="marcel" datasource="MySql">
	SELECT DISTINCT stuid, smg_programs.programid
	FROM smg_charges
	INNER JOIN smg_students ON smg_students.studentid = smg_charges.stuid
	INNER JOIN smg_programs ON smg_programs.programid = smg_students.programid
	WHERE stuid != '0' AND smg_charges.programid = '0'
	ORDER BY stuid
	LIMIT 500
</cfquery>

<cfoutput query="marcel">

	#marcel.stuid# UPDATED<br>
	
	<cfquery name="update" datasource="MySql">
		UPDATE smg_charges
		SET programid = '#marcel.programid#'
		WHERE stuid = '#marcel.stuid#'
			AND programid = '0'
	</cfquery>

</cfoutput> --->

</body>
</html>
