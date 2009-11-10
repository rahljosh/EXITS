<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfquery name="get_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE active = '1'
</cfquery>

</body>
</html>
