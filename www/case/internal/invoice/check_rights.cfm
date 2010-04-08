<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Check Invoice Rights</title>
</head>

<body>

<cfquery name="check_rights" datasource="caseusa">
	SELECT invoice_access
	FROM smg_users
	WHERE userid = '#client.userid#'
</cfquery>

<cfif client.usertype GTE 4 OR check_rights.invoice_access EQ 0>
	<table width="90%" align="center">
		<th>You do not have rights to view this page.</th>
	</table>
	<cfabort>
</cfif>

</body>
</html>
