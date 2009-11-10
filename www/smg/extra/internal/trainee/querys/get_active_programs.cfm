<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Programs List</title>
</head>

<body>

<cftry> 

<cfquery name="get_active_programs" datasource="mysql">
	SELECT	*
	FROM smg_programs p
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE p.active = '1'
		AND p.companyid = '#client.companyid#'
	ORDER BY startdate DESC, programname
	<!--- enddate > '#DateFormat(now(), 'yyyy-mm-dd')#' --->
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>