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
<table width="100%"cellpadding=0 cellspacing=0 border=0 height=24 bgcolor=##ffffff>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" class="tablecenter" background="pics/header_background.gif"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter" background="pics/header_background.gif"><h2>SMG - System Error</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section"><br>
<table width=660 cellpadding=0 cellspacing=0 border=0 align="center">
		<Tr>
			<td colspan=2>
			<!-- Error Message -->
						<table cellSpacing="0" cellPadding="0" width="100%" border="0">
							<tr>
								<td width="6"><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-lefttopcorner.gif" width=6></td>
								<td bgColor="##bb0000" height="6"><img height=6 src="spacer.gif" width=1 ></td>
								<td width="6"><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-righttopcorner.gif" width=6></td>
							</tr>

							<tr>
								<td class="errMessageGradientStyle" bgColor="##bb0000"><img height=45 src="spacer.gif" width=1 >
								</td>
								<td class="errMessageGradientStyle" bgColor="##bb0000">
									<table cellSpacing="0" cellPadding="10" width="100%" border="0">
										<tr>
											<td vAlign="middle" align="center"><img src="http://www.phpusa.com/internal/pics/error-exclamate.gif" ></td>
											
											<td vAlign="middle" align="left"><font color="white"><strong><span class=upper>ALERT!&nbsp;&nbsp; ALARM!&nbsp;&nbsp;  Alarma!&nbsp;&nbsp;  Alerte!&nbsp;&nbsp;  Allarme!&nbsp;&nbsp;  Alerta!</span> </strong><br>
											
A system error has occured. ID:<cfset errorid='#client.userid#-#dateformat(now(),'mmddyyyy')#-#timeformat(now(),'hhmmss')#'> #errorid#
											</td>
										</tr>
									</table>
								</td>
								<td class="errMessageGradientStyle" bgColor="##bb0000"><img 
							height=45 src="spacer.gif" width=1 >
								</td>
							</tr>

							<tr>
								<td><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-leftbottcorner.gif" width=6></td>
								<td bgColor="##bb0000"><img height=6 src="spacer.gif" width=1 ></td>
								<td><img height=6 src="http://www.phpusa.com/internal/pics/table-borders/red-err-rightbottomcorner.gif" width=6></td>
							</tr>
						</table>
					</div>
					
			<!-- End error message end -->
			</td>			
		</Tr>
	<tr><td>
		
		The following information has been submitted to the support folks:<br>
		<br>
		
		SUBJECT: Site Error<br> ID: #errorid#<br>
		
		
		DATE: #DateFormat(now(), 'mm/dd/yyyy')# <br>
	   	TIME: #TimeFormat(now(), 'hh:mm tt')#<br>
	   	USER: #client.name# (#client.userid#)<br>
		IP: #cgi.REMOTE_ADDR#<br>
		IP2: #cgi.REMOTE_IDENT#<br>
	   <Br>
	   	ERROR DETAILS:<br>
	   <cfif IsDefined('CFCATCH.Type')>TYPE: #CFCATCH.Type#<br></cfif>
	   <cfif IsDefined('CFCATCH.Message')>MESSAGE: #CFCATCH.Message#<Br></cfif>
		Other error specific details have also been included.<Br><br>
		
		If you would like to specify more information that you feel would help, please follow this link or refrence the ID number in an email to:
		<a href="mailto:support@student-management.com?subject=ErrorID: #errorid#">support@student-management.com</a><Br><br>
		You may or may not recive an email asking about more information or status update of the issue, depending on what the error is.
		
		 <br>
		 <div align="center"><input name="back" type="image" src="#path#pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br><br>
		 <br><br>
	</td></tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
</table>

	
<CFMAIL TO="support@student-management.com" FROM="#client.email#"
	 SUBJECT="General Site Error ID: #errorid#" type="html"> 
	   Date: #DateFormat(now(), 'mm/dd/yyyy')# <br>
	   Time: #TimeFormat(now(), 'hh:mm tt')#<br>
	   User: #client.name# (#client.userid#)<br>
		IP: #cgi.REMOTE_ADDR#<br>
		IP: #cgi.REMOTE_IDENT#<br>
		<!--- Referer: #cgi. --->
		<br>
	   experienced the following error:<br>
	   
	   #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.
	  
	  Other details: 
	   	FILE: #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#.<Br>
	   <cfif IsDefined('CFCATCH.Type')>TYPE: #CFCATCH.Type#<br></cfif>
	   <cfif IsDefined('CFCATCH.Message')>MESSAGE: #CFCATCH.Message#<Br></cfif>
	   <cfif IsDefined('CFCATCH.Detail')>DETAILS: #CFCATCH.Detail#<br></cfif>
	   <cfif IsDefined('cfcatch.NativeErrorCode')>NATIVE ERROR: #cfcatch.NativeErrorCode#<br></cfif>
	   <cfif IsDefined('cfcatch.sqlstate')>SQL STATE: #cfcatch.SQLState#<br></cfif>
	   <cfif IsDefined('client.studentid')>STUDENT: #client.studentid#<br></cfif> 
		Session Variable:<br>
		<cfdump var="#session#">
		<br>
		<br>
		CGI Info:<br>
		<cfdump var="#cgi#">
		<br>
		<br>
		CFCATCH Info:<br>
		<cfdump var="#cfcatch#">
</CFMAIL>		
</cfoutput>

</tr>
</table>