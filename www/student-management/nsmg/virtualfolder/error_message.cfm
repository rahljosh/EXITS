<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" href="../smg.css" type="text/css">
	<title>System Error</title>
</head>
<body>

<cfoutput>
<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/helpdesk.gif"></td>
		<td background="../pics/header_background.gif"><h2>Virtual Folder Error</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section"><br>
<table width=660 cellpadding=0 cellspacing=0 border=0 align="center">
<tr>
  <td> Virtual Folder Error</td></tr>
	<tr><td>
		<p>A system error has occurred. The error message and relative data has been sent to the system administrator. <br>
		 It will be fixed shortly.<br> 
		 We are sorry for the inconvenience.</p><br>
		 <div align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
		 <br><br>
	</td></tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

<!---	
<CFMAIL TO="#APPLICATION.EMAIL.errors#" FROM="#APPLICATION.EMAIL.support#"
	 SUBJECT="Virtual Folder Error on page #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#"> 
	   There was an error on #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.
	   On  #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#
	   <cfif IsDefined('CFCATCH.Type')>Type: #CFCATCH.Type#</cfif>
	   <cfif IsDefined('CFCATCH.Message')>Message: #CFCATCH.Message#</cfif>
	   <cfif IsDefined('CFCATCH.Detail')>Details: #CFCATCH.Detail#</cfif>
	   <cfif IsDefined('cfcatch.NativeErrorCode')>Native Error: #cfcatch.NativeErrorCode#</cfif>
	   <cfif IsDefined('cfcatch.sqlstate')>SQLState: #cfcatch.SQLState#</cfif>
	   <cfif IsDefined('client.studentid')>StudentID: #client.studentid#<cfelse>Non student related.</cfif> 
</CFMAIL>
--->

</cfoutput>
</body>
</html>