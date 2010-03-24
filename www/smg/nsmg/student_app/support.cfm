<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Support Options</title>
</head>
<body>

<cftry>

<cfinclude template="../querys/get_student_info.cfm">

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Support Options</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfoutput>
<div class="section"><br>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td colspan=3>Please contact your international representative if you have questions about the information 
			that is being requested on the application. EXITS support staff will not be able to answer those questions and you will be
			directed to your international representative if you contact EXITS support concerning information that is requested on the application.
		</td>
	</tr>
	<tr>
		<td valign="top" width="33%" colspan=3 align="center">
			<br>
			<h3><u>General Application Questions</u></h3>
			<cfquery name="agent_info" datasource="MySQL">
				SELECT firstname, lastname, phone, email, businessname, studentcontactemail
				FROM smg_users 
				WHERE userid = <cfif get_student_info.branchid EQ '0'>'#get_student_info.intrep#'<cfelse>'#get_student_info.branchid#'</cfif>  
			</cfquery>
			<u>Your Local Representative</u><br>
			#agent_info.businessname#<br>
			<cfif agent_info.studentcontactemail NEQ ''>Email: <a href="mailto:#agent_info.studentcontactemail#">#agent_info.studentcontactemail#</a><br></cfif>
			<cfif agent_info.phone NEQ ''>Phone: #agent_info.phone#</cfif>
		</td>
	</tr>
	<tr>
		<td valign="top" width="100%" align="center" colspan=3><br><br>
			If you are experiencing problems with the EXITS application system (technical issues such as errors on screen, information not saving, etc.) 
			please use one of the contact methods below.<br><br>
		</td>
	</tr>
	<tr>
		<td valign="top" width="49%" align="center">
			<h3><u>Live Chat</u></h3>
		<table cellpadding="0" cellspacing="0" border="0" align="center">
			<tr>
				<td align="center"><!-- http://www.LiveZilla.net Chat Button Link Code --><div style="text-align:center;width:128px;"><a href="javascript:void(window.open('http://www.exitsapplication.com/livezilla/livezilla.php','','width=600,height=600,left=0,top=0,resizable=yes,menubar=no,location=yes,status=yes,scrollbars=yes'))"><img src="http://www.exitsapplication.com/livezilla/image.php?id=04" width="128" height="42" border="0" alt="LiveZilla Live Help"></a><noscript><div><a href="http://www.exitsapplication.com/livezilla/livezilla.php" target="_blank">Start Live Help Chat</a></div></noscript><div style="margin-top:2px;"></div></div><!-- http://www.LiveZilla.net Chat Button Link Code --></td></tr><tr><td align="center"></td></tr></table>
				Live chat will be available between 
				8am - 4pm MST as support staff is available.<br>
			</td>
			<td valign="top" width="2%">&nbsp;</td>
			<td valign="top" width="49%" align="center">
			<h3><u>Email</u></h3>
			Please fill out this form for general questions about <cfoutput>#qOrgInfo.companyshort_nocolor#</cfoutput> or the EXITS application system. You will receive a reply on this page so do not forget to check it later.<br>
			<a href="?curdoc=contact&id=su">Click Here</a>
		</td>		
	</tr>
</table>
<br><br>

<cfquery name="help_desk" datasource="mysql">
	SELECT title, text, status, helpdeskid, date
	FROM smg_help_desk 
	WHERE studentid = '#client.studentid#'
</cfquery>

<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr><td>Messages Submitted:</td></tr>
	<cfloop query="help_desk">
		<tr><td><hr width=650 align="left"></td></tr>
		<tr bgcolor="CCCCCC"><td>Date: #DateFormat(date, 'mm-dd-yyyy')# - #TimeFormat(date, 'hh:mm tt')# &nbsp; - &nbsp; Message ID: (###helpdeskid#)</td></tr>
		<tr><td>Status: <cfif status is 'Complete'>Issue Resolved<cfelse>In Progress</cfif></td></tr>	
		<tr><td></td></tr>
		<tr><td>Subject: #title#</td></tr>
		<tr><td><h3><u>Message:</u></h3></td></tr>
		<tr><td><div align="justify">#text#</div></td></tr>
		<cfquery name="help_desk_items" datasource="MySql">
			SELECT itemsid, helpdeskid, submitid, text, date, 
			firstname, lastname, usertype
			FROM smg_help_desk_items
			LEFT JOIN smg_users ON smg_help_desk_items.submitid = smg_users.userid
			WHERE helpdeskid = '#help_desk.helpdeskid#'
			ORDER BY DATE
		</cfquery>
		<cfif help_desk_items.recordcount NEQ '0'>
			<tr bgcolor="CCCCCC"><td>Date: #DateFormat(help_desk_items.date, 'mm-dd-yyyy')# - #TimeFormat(help_desk_items.date, 'hh:mm tt')# &nbsp; &middot &nbsp; #help_desk_items.firstname# #help_desk_items.lastname#  wrote:</td></tr>	
			<tr><td><h3><u>Message:</u></h3></td></tr>
			<tr><td><div align="justify">#help_desk_items.text#</div></td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</cfloop>		
</table>
</cfoutput>
</div>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>

