<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>SMG - System Error</title>
</head>
<body>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<cfoutput>
<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>CASE - System Error</h2></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width=660 cellpadding=0 cellspacing=0 border=0 align="center">
<tr>
  <td>CASE - Error Message</td>
</tr>
	<tr><td>
		<p>A system error has occurred. The error message and relative data has been sent to the system administrator. <br>
		 It will be fixed shortly.<br> 
		 We are sorry for the inconvenience.</p><br>
		The error is below.  On pages that ask for dates, make sure they are formatted correctly (mm/dd/yyyy) or else are blank.<br>
		Message: #CFCATCH.Message#<br>
	 
		 <div align="center"><input name="back" type="image" src="#path#pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
		 <br><br>
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

<CFMAIL TO="support@student-management.com" FROM="support@student-management.com"
	 SUBJECT="Online App - Error on page #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#"> 
	   There was an error on #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.<br>
	   On  #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#<Br>
	   <cfif IsDefined('CFCATCH.Type')>Type: #CFCATCH.Type#<br></cfif>
	   <cfif IsDefined('CFCATCH.Message')>Message: #CFCATCH.Message#<br></cfif>
	   <cfif IsDefined('CFCATCH.Detail')>Details: #CFCATCH.Detail#<br></cfif>
	   <cfif IsDefined('cfcatch.NativeErrorCode')>Native Error: #cfcatch.NativeErrorCode#<br></cfif>
	   <cfif IsDefined('cfcatch.sqlstate')>SQLState: #cfcatch.SQLState#<br></cfif>
	   <cfif IsDefined('client.studentid')>StudentID: #client.studentid#<br><cfelse>Non student related.<br></cfif> 
</CFMAIL>

</cfoutput>
</body>
</html>