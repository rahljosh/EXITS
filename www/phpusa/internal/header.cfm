<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="Author" content="Josh Rahl">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Private High School Program</title>
<link rel="stylesheet" href="phpusa.css" type="text/css">
<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
<!-- DatePicker CSS -->
<link rel="stylesheet" href="linked/css/datePicker.css" type="text/css">
<!-- jQuery -->
<script src="linked/js/jquery.js" type="text/javascript"></script>
<!-- required plugins -->
<script src="linked/js/date.js" type="text/javascript"></script>
<!-- jquery.datePicker.js -->
<script src="linked/js/jquery.datePicker.js " type="text/javascript"></script>

<script type="text/javascript" language="javascript">
	$(function() {
		$('.date-pick').datePicker({startDate:'01/01/2009'});
	});	
</script>

</head>
<body>

<cfif not isdefined ('client.userid')>
	<cflocation url="../axis.cfm?to" addtoken="no">
</Cfif>
<cfif client.usertype EQ "">
	<cflocation url="../axis.cfm?access" addtoken="no">
</cfif>

<cfquery name="get_messages" datasource="#application.dsn#">
    SELECT *
    FROM smg_news_messages
    WHERE messagetype IN ('alert','update')
    AND expires > #now()# and startdate < #now()#
    AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    ORDER BY startdate DESC
</cfquery>
<cfquery name="alert_messages" dbtype="query">
    SELECT *
    FROM get_messages
    WHERE messagetype = 'alert'
</cfquery>
<cfquery name="update_messages" dbtype="query">
    SELECT *
    FROM get_messages 
    WHERE messagetype = 'update'
</cfquery>
<table align="center" border="0" height="12" width="90%" cellspacing="0" cellpadding="0">
  <tr>
    <td height="12" align="right" background="images/top_02.gif" ><img src="images/top_01.gif" width="11" height="12"></td>
    <td width="99%" background="images/top_02.gif" height="12"></td>
    <td height="12" align="left" background="images/top_02.gif" ><img src="images/top_03.gif" width="11" height="12"></td>
  </tr>
</table>
<table width=90% align="center" bgcolor="#e9ecf1" border=0>
	<tr>
		<td rowspan=3 width=110><A href="index.cfm?curdoc=initial_welcome"><img src="pics/dmd-logo.jpg" width="110" height="65" border=0></a></td>
    	<cfoutput>
		<td valign="top">
        	Welcome back #client.firstname#!<br>
			[ <A href="index.cfm?curdoc=initial_welcome">Home</a> ] [ <a href="logout.cfm">Logout</a> ]
		</td>
        <td align="right" valign="top">
        	Last Login: #DateFormat(client.lastlogin, 'mmm d, yyyy')#<br>
			at #TimeFormat(client.lastlogin, 'h:mm tt')#
		</td>
    	</cfoutput>
	</tr>
	<tr valign="top">
		<td align="right">
			<cfif update_messages.recordcount neq 0>
                <table bgcolor="#009966" width=40%>
                    <tr><td>
                        <font color="FFFFFF"><b><u>System Updates:</u></b></font><br>
                        <cfoutput query="update_messages">
                            <a class="nav_bar" href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="FFFFFF"><b>#message#</b></font></a><br>
                        </cfoutput>
                    </td></tr>
                </table>
            </cfif>
		</td>
		<td>
			<cfif alert_messages.recordcount neq 0>
                <table bgcolor="#CC3300" width=40%>
                    <tr><td>
                        <font color="FFFFFF"><b><u>Alerts:</u></b></font><br>
                        <cfoutput query="alert_messages">
                            <a class="nav_bar" href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="FFFFFF"><b>#message#</b></font></a><br>
                        </cfoutput>
                    </td></tr>
                </table>
            </cfif>
		</td>
	</tr>
	<tr>
		<td colspan=2>
            <table width="100%" cellspacing="1" cellpadding="0" bgcolor="CCCCCC">
              <tr>
                <td bgcolor="eeeeee"><cfinclude template="menu.cfm"></td>
              </tr>
            </table>
        </td>
	</tr>
</table>
<script type="text/javascript">
var ddmx = new DropDownMenuX('menu1');
ddmx.delay.show = 0;
ddmx.delay.hide = 400;
ddmx.position.levelX.left = 2;
ddmx.init();
</script>