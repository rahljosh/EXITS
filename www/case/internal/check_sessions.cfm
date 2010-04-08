<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Application</title>
</head>

<body>

<cfoutput>

<!--- IF SESSIONS ARE NOT DEFINED REDIRECT THEM TO THE LOGIN PAGE --->



<cfif NOT IsDefined ('client.companyid')>
	<cflocation url="loginform.cfm" addtoken="no">

<cfelseif NOT IsDefined ('client.userid')>
	<cflocation url="loginform.cfm" addtoken="no">

<cfelseif NOT IsDefined ('client.usertype')>
	<cflocation url="loginform.cfm" addtoken="no">
</Cfif>

</cfoutput>

</body>
</html>
