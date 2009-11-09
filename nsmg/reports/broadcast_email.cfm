<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Broadcast Email</title>

</head>

<body>

<cfif client.usertype EQ 1>

BROADCAST EMAIL LIST <br /><br />

<cfquery name="get_active_reps" datasource="MySql">
	SELECT u.userid, u.firstname, u.lastname, u.email
	FROM smg_users u
	WHERE u.active = '1'
		AND u.email != ''
		AND u.email LIKE '%@%'
		AND u.companyid != '0'
		AND u.usertype != '0'
		AND u.usertype != '8' <!--- int rep --->
		AND u.usertype != '10' <!--- student --->
		AND u.usertype != '11' <!--- int branch --->
		AND u.usertype != '12' <!--- php school --->	
		AND u.usertype != '13' <!--- intl. user --->
	GROUP BY u.email
	ORDER BY u.usertype, u.firstname
</cfquery>

<cfoutput>

<cfloop query="get_active_reps">
	#email#<br />
</cfloop>

<br /><br />
Total of #get_active_reps.recordcount# active users.

</cfoutput>

<cfelse>
	You do not have privileges to see this page.
	<cfabort>
</cfif>

</body>
</html>
