<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>

<cfif cgi.SERVER_NAME eq 'ise.exitsapplication.com'>
	<cflocation url= "https://www.iseusa.com/hostApp">
<cfelse>
	<cflocation url = "http://www.case-usa.org/hostApp">
</cfif>

</body>
</html>