<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfquery name="get_php_intl_reps" datasource="MySql">
	SELECT u.userid, u.businessname	
	FROM smg_users u
	INNER JOIN smg_students s ON s.intrep = u.userid
	INNER JOIN php_students_in_program php ON php.studentid = s.studentid
	WHERE php.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
	GROUP BY u.userid
	ORDER BY u.businessname, familylastname
</cfquery>

</body>
</html>
