<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>
<cfoutput>
<frameset rows="80,*" cols="*" frameborder="NO" border="0" framespacing="0">
  <frame src="" name="topFrame" scrolling="NO" noresize>
  <frameset cols="*,50%" frameborder="NO" border="0" framespacing="0">
    <frame src="../querys/update_mail_ip.cfm?ip=#form.newip#" name="mainFrame">
    <frame src="../querys/update_ftp_ip.cfm?ip=#form.newip#" name="rightFrame" scrolling="NO" noresize>
  </frameset>
</frameset>
</cfoutput>
<noframes><body>
</body></noframes>
</html>
