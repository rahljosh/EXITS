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
		<p><strong>Message: #CFCATCH.Message#<br>
					Details: #CFCATCH.Detail#</strong></p>
		 <p>The error message is displayed above.  Please check to see if the error is just a data entry error. On pages that ask for dates, make sure they are formatted correctly (mm/dd/yyyy). <u> If you don't have a date to enter please leave the field blank.</u></p>
		<p>This error and relative information has been submitted to the system administrator.  If it is a data entry error, you may not receive an email response, for all other errors you will receive an email when the issue has been resolved. </p>
		
		
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
<cfsavecontent variable="email_message">
There was an error on #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.
On  #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#
<cfif IsDefined('CFCATCH.Type')>Type: #CFCATCH.Type#</cfif>
<cfif IsDefined('CFCATCH.Message')>Message: #CFCATCH.Message#</cfif>
<cfif IsDefined('CFCATCH.Detail')>Details: #CFCATCH.Detail#</cfif>
<cfif IsDefined('cfcatch.NativeErrorCode')>Native Error: #cfcatch.NativeErrorCode#</cfif>
<cfif IsDefined('cfcatch.sqlstate')>SQLState: #cfcatch.SQLState#</cfif>
<cfif IsDefined('client.studentid')>
    <cfquery name="get_email" datasource="MySql">
        SELECT studentid, email 
        FROM smg_students
        WHERE studentid = '#client.studentid#'
    </cfquery>
    StudentID: ###client.studentid#
    Email: #get_email.email#
<cfelse>
    Non student related.
</cfif> 
</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#APPLICATION.EMAIL.errors#">
                <cfinvokeargument name="email_subject" value="Online App - Error on page #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#companyshort#-support@exitsapplication.com">
            </cfinvoke>

</cfoutput>

</body>
</html>