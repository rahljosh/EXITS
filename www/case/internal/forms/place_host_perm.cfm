<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Permanent Family</title>
</head>

<body>

<cfif NOT IsDefined('url.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="permanent_family" datasource="caseusa">
	UPDATE smg_students
	SET welcome_family = '0'
	WHERE studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer" maxlength="6">
	LIMIT 1
</cfquery>

<cflocation url="place_host.cfm" addtoken="no">

</body>
</html>