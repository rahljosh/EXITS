<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif client.usertype EQ 1>

<cfquery name="get_users" datasource="MySql">
	SELECT u.userid, u.firstname, u.lastname, u.email,
		uar.usertype, uar.regionid
	FROM smg_users u
	INNER JOIN user_access_rights uar ON uar.userid = u.userid
	WHERE u.active = '1'
		AND uar.regionid = '1243'
		AND uar.usertype > '4'
		AND u.email != ''
	ORDER BY u.lastname
</cfquery>

Emails:<br>
<cfoutput query="get_users">
	#email#;
</cfoutput>

<br><br><br>

Names:<br>
<cfoutput query="get_users">
	#firstname# #lastname#<br>
</cfoutput>

</cfif>
</body>
</html>
