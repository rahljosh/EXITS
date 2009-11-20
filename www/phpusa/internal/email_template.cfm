<!--- this is included by cfc/email.cfc, send_mail function --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Private High School Program</title>
</head>
<body>
<cfoutput>

<!--- sample image
<img src="#application.site_url#/images/email/email-header.jpg" width="750" height="100" border="0" usemap="#Map" />--->

#email_message#<br /><br />

<p><font size="1"><a href="#application.site_url#">#application.site_url#</a></font></p>

</cfoutput>
</body>
</html>