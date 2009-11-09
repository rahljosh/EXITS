<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Redirect Link</title>
</head>

<body>

<cfoutput>

<cfquery name="get_link" datasource="MySQL">
	SELECT link
	FROM smg_links 
	WHERE id = '#cookie.smglink#'
</cfquery>

<cfcookie name="smglink" value="" expires="now">

<cfif get_link.recordcount eq 0>
	The link you followed is invalid.<br>
	You wil be redirected to the internal site shortly, if you are not redirected, click <a href="index.cfm">here.</a>
	<meta http-equiv="Refresh" content="1;url=index.cfm">
<cfelse>
	<meta http-equiv="Refresh" content="1;url=#get_link.link#">
</cfif>

</cfoutput>

</body>
</html>
