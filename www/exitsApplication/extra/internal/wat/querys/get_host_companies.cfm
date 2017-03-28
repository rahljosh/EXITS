<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Host Company List</title>
</head>

<body>

<cftry>

<cfquery name="get_host_companies" datasource="mysql">
	SELECT hostcompanyid, name
	FROM extra_hostcompany
	WHERE active = 1
	ORDER BY name
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
