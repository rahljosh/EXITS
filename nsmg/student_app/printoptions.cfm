<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Print Options</title>
</head>
<body>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Print Options</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<br><br>
<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td valign="top" width="49%" align="center">
		<a class="item2" href="" onClick="javascript: win=window.open('print_blankapplication.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;">
			<img src="pics/print_blank_app.gif" border="0">
		</a><br>
		Use the link above to print a complete blank online application.
		</td>		
		<td valign="top" width="2%">&nbsp;</td>
		<td valign="top" width="49%" align="center">
		<a class="item2" href="" onClick="javascript: win=window.open('print_application.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;">
			<img src="pics/print_completed_app.gif" border="0">
		</a><br>
		Use the link above to print your completed online application.
		</td>
	</tr>
</table>
<br><br>

</div>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>