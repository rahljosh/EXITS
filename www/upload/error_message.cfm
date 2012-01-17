<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>SMG - Upload Error</title>
</head>
<body>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#AppPath.onlineApp.imageURL#p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#AppPath.onlineApp.imageURL#students.gif"></td>
		<td class="tablecenter"><h2>SMG - Upload Error</h2></td>
		<td width="42" class="tableside"><img src="#AppPath.onlineApp.imageURL#p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="100%" border=0 cellpadding=6 cellspacing=0 align="center">
	<tr><td>
		 <p>An upload error has occurred. The error message and relative data has been sent to the system administrator.
		 <p>We	re sorry for the inconvenience. </p>
		 <p>Please try again. If the error persists contact support@student-management.com.</p> <br>
		 <div align="center"><input name="back" type="image" src="#AppPath.onlineApp.imageURL#close.gif" align="middle" border=0 onClick="window.close()"></div><br><br>
	</td></tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#AppPath.onlineApp.imageURL#p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#AppPath.onlineApp.imageURL#p_spacer.gif"></td>
		<td width="42"><img src="#AppPath.onlineApp.imageURL#p_bottonright.gif" width="42"></td>
	</tr>
</table>

<cfif IsDefined('form.studentid')>
	<cfset url.studentid = form.studentid>
</cfif>

<CFMAIL TO="errors@student-management.com" FROM="errors@student-management.com" SUBJECT="Online App - Upload Error on page #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#"> 
	There was an error on #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.
	On  #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#
	<cfif IsDefined('CFCATCH.Type')>Type: #CFCATCH.Type#</cfif>
	<cfif IsDefined('CFCATCH.Message')>Message: #CFCATCH.Message#</cfif>
	<cfif IsDefined('CFCATCH.Detail')>Details: #CFCATCH.Detail#</cfif>
	<cfif IsDefined('cfcatch.NativeErrorCode')>Native Error: #cfcatch.NativeErrorCode#</cfif>
	<cfif IsDefined('cfcatch.sqlstate')>SQLState: #cfcatch.SQLState#</cfif>
	<cfif IsDefined('url.student')>
		<cfquery name="get_email" datasource="MySql">
			SELECT s.studentid, s.email, s.firstname, s.familylastname,
				u.businessname
			FROM smg_students s
			INNER JOIN smg_users u ON u.userid = s.intrep
			WHERE s.studentid = '#url.student#'
		</cfquery>
		Intl. Agent: #get_email.businessname#
		Student: #get_email.firstname# #get_email.familylastname# (###get_email.studentid#)
		Student's Email: #get_email.email#
	<cfelse>
		Non student related.
	</cfif> 
</CFMAIL>

</cfoutput>

</body>
</html>