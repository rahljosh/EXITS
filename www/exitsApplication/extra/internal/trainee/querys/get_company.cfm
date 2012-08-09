<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Get Company</title>
</head>

<body>

<cftry>

<cfquery name="get_company" datasource="mysql">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
