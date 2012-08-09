<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>International Agents List</title>
</head>

<body>

<cftry>

<cfquery name="get_intl_reps" datasource="mysql">
	SELECT userid, businessname
	FROM smg_users
	WHERE usertype = '8'
	ORDER BY businessname
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>
