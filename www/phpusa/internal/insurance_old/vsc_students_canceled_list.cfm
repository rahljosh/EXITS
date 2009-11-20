<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>VSC Students Canceled List</title>
</head>

<body>

<!--- VSC ONLY --->
<cfquery name="check_cancel_insurance" datasource="MySql">
	SELECT i.studentid, i.firstname, i.lastname, type.type,
		php.canceldate, php.cancelreason, php.insurancecanceldate,
		u.businessname
	FROM smg_insurance i 
	INNER JOIN php_students_in_program php ON php.studentid = i.studentid
	INNER JOIN smg_students s ON s.studentid = i.studentid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = php.programid
	INNER JOIN smg_insurance_type type ON u.php_insurance_typeid = type.insutypeid
	WHERE php.canceldate IS NOT NULL
		AND type.provider = 'caremed'
		AND php.insurancedate IS NOT NULL
		AND php.insurancecanceldate IS NULL
		AND p.enddate >= NOW()
		AND i.sent_to_caremed IS NOT NULL
		AND i.companyid = '6'
	GROUP BY i.studentid
	ORDER BY u.businessname, type.type, i.firstname
</cfquery>

<cfoutput>

<table width="90%" cellpadding=:"4" cellspacing="0" align="center">
	<tr><th>PHP - CANCELED STUDENTS WITH ACTIVE INSURANCE</th></tr>
</table><br>

<table width="90%" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td><b>Intl. Agent</b></td>
		<td><b>Student</b></td>
		<td><b>Policy Type</b></td>
		<td><b>Cancel Date</b></td>
		<td><b>Cancel Reason</b></td>
		<td><b>Insurance Canceled</b></td>
	</tr>
	<cfloop query="check_cancel_insurance">
		<tr bgcolor="#IIF(currentrow MOD 2, DE("white"), DE("C9C9C9") )#"> 
			<td>#businessname#</td>
			<td>#firstname# #lastname# (###studentid#)</td>
			<td>#type#</td>
			<td>#DateFormat(canceldate, 'mm/dd/yyyy')#</td>
			<td>#cancelreason#</td>
			<td>#DateFormat(insurancecanceldate, 'mm/dd/yyyy')#</td>
		</tr>
	</cfloop>
</table>

</cfoutput>

</body>
</html>
