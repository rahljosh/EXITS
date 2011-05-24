<!--- ------------------------------------------------------------------------- ----
	
	File:		error_message.cfm
	Author:		Marcus Melo
	Date:		May 24, 2011
	Desc:		Displays error message for the user and emails support

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param variables --->
    <cfparam name="URL.curdoc" default="">
    <cfparam name="URL.path" default="">
    <cfparam name="URL.exits_app" default="">
    
    <cfscript>
		if ( CGI.SCRIPT_NAME EQ '/exits_app.cfm' ) {
			exitsPath = "nsmg/student_app/";
		} else if ( LEN(URL.curdoc) OR LEN(URL.path) ) {
			exitsPath = "../";
		} else if ( LEN(URL.exits_app) ) {
			exitsPath = "nsmg/student_app/";
		} else {
			 exitsPath = "";
		}
	</cfscript>
    
</cfsilent>    


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>System Error</title>
    <link rel="shortcut icon" href="nsmg/pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="nsmg/smg.css" type="text/css">
    <link rel="stylesheet" href="nsmg/linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link media="screen" rel="stylesheet" href="nsmg/linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <cfoutput>
		<link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
    	<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
		<script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
	</cfoutput>        
	<script type="text/javascript" src="nsmg/linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
	<script type="text/javascript" src="nsmg/linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
    <script type="text/javascript" src="nsmg/linked/js/basescript.js "></script> <!-- BaseScript -->
</head>
<body>

<cfoutput>

	<!--- HEADER OF TABLE --->
    <table width="90%" cellpadding="0" cellspacing="0" align="center" border="0" style="margin-top:20px; background-color:##FFF;">
        <tr height="33">
            <td width="8"><img src="#exitsPath#pics/p_topleft.gif" width="8"></td>
            <td width="26"style="border-top:2px solid ##999"><img src="#exitsPath#pics/students.gif"></td>
            <td style="border-top:2px solid ##999"><h2>System Error</h2></td>
            <td width="42"><img src="#exitsPath#pics/p_topright.gif" width="42"></td>
        </tr>
    </table>
    
    <table width=90% cellpadding=4 cellspacing=4 border=0 align="center" style="background-color:##FFF; border-top:2px solid ##999;border-right:2px solid ##999;border-left:2px solid ##999;">
        <tr>
            <td align="center"><h1>Error Message</h1></td>
        </tr>
        <tr>
        	<td align="center">
                <p>
                	Sorry, an error has occurred. The error message and relative data has been sent to the system administrator. We are sorry for the inconvenience.
                </p>
                
                <p> 
                    On pages that ask for dates, make sure they are formatted correctly (mm/dd/yyyy) or else are blank.
                </p>
                
                <cfif IsDefined('CFCATCH.Message')>
                	<p>Message: #CFCATCH.Message#</p>
				</cfif>
                
                <p><input name="back" type="image" src="#exitsPath#pics/back.gif" align="middle" border=0 onClick="history.back()"></p>
        	</td>
		</tr>
    </table>
    
    <!--- FOOTER OF TABLE --->
    <table width="90%" cellpadding="0" cellspacing="0" align="center" border="0" style="background-color:##FFF;">
        <tr height="8">
            <td width="8"><img src="#exitsPath#pics/p_bottonleft.gif" width="8"></td>
            <td class="tablebotton" style="border-bottom:2px solid ##999"></td>
            <td width="42"><img src="#exitsPath#pics/p_bottonright.gif" width="42"></td>
        </tr>
    </table>
	
    <cfsavecontent variable="email_message">
        There was an error on #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#<br>
        On  #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#<Br>
        <cfif IsDefined('CFCATCH.Type')>Type: #CFCATCH.Type#<br></cfif>
        <cfif IsDefined('CFCATCH.Message')>Message: #CFCATCH.Message#<br></cfif>
        <cfif IsDefined('CFCATCH.Detail')>Details: #CFCATCH.Detail#<br></cfif>
        <cfif IsDefined('cfcatch.NativeErrorCode')>Native Error: #cfcatch.NativeErrorCode#<br></cfif>
        <cfif IsDefined('cfcatch.sqlstate')>SQLState: #cfcatch.SQLState#<br></cfif>
        <cfif IsDefined('client.studentid')>StudentID: #client.studentid#<br><cfelse>Non student related.<br></cfif> 
    </cfsavecontent>
				
	<!--- send email --->
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
        <cfinvokeargument name="email_to" value="#APPLICATION.EMAIL.errors#">
        <cfinvokeargument name="email_subject" value="Online App - Error on page #CGI.CF_TEMPLATE_PATH#?#cgi.query_string#">
        <cfinvokeargument name="email_message" value="#email_message#">
        <cfinvokeargument name="email_from" value="#APPLICATION.EMAIL.support#">
    </cfinvoke>
    
</cfoutput>

<cfabort>
</body>
</html>