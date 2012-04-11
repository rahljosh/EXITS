<!--- ------------------------------------------------------------------------- ----
	
	File:		header.cfm
	Author:		Marcus Melo
	Date:		May 12, 2011
	Desc:		Applicaton Header

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param Variables --->
    <cfparam name="CLIENT.userID" default="0">
    <cfparam name="URL.ID" default="0">

	<cfif NOT VAL(CLIENT.userID)>
        <cflocation url="../axis.cfm?to" addtoken="no">
    </Cfif>
    
    <cfif NOT LEN(CLIENT.usertype)>
        <cflocation url="../axis.cfm?access" addtoken="no">
    </cfif>
    
    <cfquery name="get_messages" datasource="#application.dsn#">
        SELECT *
        FROM 
        	smg_news_messages
        WHERE 
        	messagetype IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="alert,update" list="yes"> )
        AND 
        	expires > #now()# and startdate < #now()#
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        ORDER BY 
        	startdate DESC
    </cfquery>
    
    <cfquery name="alert_messages" dbtype="query">
        SELECT 
        	*
        FROM 
        	get_messages
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="alert">
    </cfquery>
    
    <cfquery name="update_messages" dbtype="query">
        SELECT 
        	*
        FROM 
        	get_messages 
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="update">
    </cfquery>

</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="Author" content="Private High School Program">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Private High School Program</title>
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
	<link rel="stylesheet" href="phpusa.css" type="text/css">
    <link rel="stylesheet" href="SpryAssets/SpryMenuBarHorizontal.css"type="text/css" /> <!-- Menu CSS -->
    <link rel="stylesheet" href="linked/css/colorBox.css" type="text/css"> <!-- Color Box -->
    <link rel="stylesheet" href="linked/css/baseStyle.css" type="text/css"> <!-- Base Style -->
    <cfoutput>
        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
        <script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
    </cfoutput>
    <script type="text/javascript" src="SpryAssets/SpryMenuBar.js"></script> <!-- Menu Script -->
    <script type="text/javascript" src="linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker --> 
    <script type="text/javascript" src="linked/js/basescript.js"></script> <!-- Base Script -->
</head>
<body>

<cfoutput>
<table align="center" border="0" height="12" width="90%" cellspacing="0" cellpadding="0">
    <tr>
        <td height="12" align="right" background="images/top_02.gif" >
        	<img src="images/top_01.gif" width="11" height="12">
        </td>
        <td width="99%" background="images/top_02.gif" height="12">&nbsp;</td>
        <td height="12" align="left" background="images/top_02.gif" >
        	<img src="images/top_03.gif" width="11" height="12">
        </td>
    </tr>
</table>

<table width="90%" align="center" bgcolor="##e9ecf1" border=0>
	<tr>
		<td rowspan=3 width=110><A href="index.cfm?curdoc=initial_welcome"><img src="pics/dmd-logo.jpg" width="110" height="65" border=0></a></td>
		<td valign="top">
        	Welcome back #CLIENT.firstname#!<br>
			[ <A href="index.cfm?curdoc=initial_welcome">Home</a> ] [ <a href="logout.cfm">Logout</a> ]
		</td>
        <td align="right" valign="top">
        	Last Login: #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')#<br>
			at #TimeFormat(CLIENT.lastlogin, 'h:mm tt')#
		</td>
	</tr>
	<tr valign="top">
		<td align="right">
			<cfif update_messages.recordcount neq 0>
                <table bgcolor="##009966" width=40%>
                    <tr>
                    	<td>
                            <font color="##FFFFFF"><b><u>System Updates:</u></b></font><br>
                            <cfloop query="update_messages">
                                <a class="nav_bar" href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##FFFFFF"><b>#message#</b></font></a><br>
                            </cfloop>
                    	</td>
					</tr>
                </table>
            </cfif>
		</td>
		<td>
			<cfif alert_messages.recordcount neq 0>
                <table bgcolor="##CC3300" width=40%>
                    <tr>
                    	<td>
                            <font color="##FFFFFF"><b><u>Alerts:</u></b></font><br>
                            <cfloop query="alert_messages">
                                <a class="nav_bar" href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="##FFFFFF"><b>#message#</b></font></a><br>
                            </cfloop>
                    	</td>
                 	</tr>
                </table>
            </cfif>
		</td>
	</tr>
	<tr>
		<td colspan="2">
        
            <table width="100%" cellspacing="1" cellpadding="0" bgcolor="##CCCCCC">
              	<tr>
					<td bgcolor="##EEEEEE"><cfinclude template="menu.cfm"></td>
	            </tr>
            </table>
            
        </td>
	</tr>
</table>
<!--- Start of Table Body --->
<table align="center" width="90%" cellpadding="0" cellspacing="0" border="0" bgcolor="##e9ecf1"> 
	<tr>
		<td>


</cfoutput>