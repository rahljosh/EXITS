<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>SMG - System Error</title>
</head>
<body>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>SMG - System Error</h2></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="670" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td>
		<p>A system error has occurred. The error message and relative data has been sent to the system administrator
		 and a support ticket has been opened with this error. <br> 
		 We	are sorry for the inconvenience and you will receive an email as soon as the issue has been resolved.</p> 
		 <br><br>
		 <div align="center"><input name="back" type="image" src="#path#pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
	</td></tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

<CFMAIL TO="marcus@student-management.com" FROM="support@student-management.com"
	 SUBJECT="Online App - Error on page #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#"> 
	   There was an error on #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.
	   On  #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#
	   <cfif IsDefined('CFCATCH.Type')>Type: #CFCATCH.Type#</cfif>
	   <cfif IsDefined('CFCATCH.Message')>Message: #CFCATCH.Message#</cfif>
	   <cfif IsDefined('CFCATCH.Detail')>Details: #CFCATCH.Detail#</cfif>
	   <cfif IsDefined('cfcatch.NativeErrorCode')>Native Error: #cfcatch.NativeErrorCode#</cfif>
	   <cfif IsDefined('cfcatch.sqlstate')>SQLState: #cfcatch.SQLState#</cfif>
	   <cfif IsDefined('client.studentid')>StudentID: #client.studentid#<cfelse>Non student related.</cfif> 
	   
	   
</CFMAIL>

</cfoutput>

</body>
</html>