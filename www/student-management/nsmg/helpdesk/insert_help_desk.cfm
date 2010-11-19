<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Help Desk</title>
</head>

<body>

<!-----User Information----->
<cfinclude template="../querys/get_user_info.cfm">

<cfif form.title is '' or form.category is 0 or form.section is 0 or form.text is ''>
	<br>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Help Desk - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><div align="justify"><h3>
						<p>Sorry, we could not submit your message at this time because you did not fill out all required fields.</p>
						<p>Please go back, make sure that you fill out all of them and re-submit your message.</p>
						<p>Thanks for your cooperation.</p></h3></div></td>
	</tr>
	<tr><td align="center"><input name="back" type="image" src="pics/back.gif" align="middle" border=0 onClick="history.back()"></td></tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom">
			<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
		</tr>
	</table>
<cfabort>
</cfif>

<cfquery name="assigned_to" datasource="MySql">
	SELECT sectionid,  sectionname,  assignedid,  
	userid, firstname, lastname, email 
	FROM smg_help_desk_section
	LEFT JOIN smg_users ON assignedid = userid
	WHERE sectionid = #form.section#
</cfquery>

<cfquery name="get_support" datasource="MySql">
	SELECT firstname, lastname, email
	FROM smg_users
	WHERE userid = #assigned_to.assignedid#
</cfquery>

<cfset newtext = #Replace(form.text,"#chr(10)#","<br>","all")#>

<cfquery name="insert_help_desk" datasource="MySql">
	INSERT INTO smg_help_desk
		(title, category, section, priority, text, status, submitid, assignid, date)
	VALUES ('#form.title#','#form.category#', '#form.section#',
			<cfif form.category is 'suggestion' or form.category is 'question'>'low',</cfif>
			<cfif form.category is 'error' or form.category is 'request'>'medium',</cfif>
			<cfif form.category is 'problem'>'high',</cfif>
			<cfqueryparam value="#newtext#" cfsqltype="cf_sql_longvarchar">, 'initial','#client.userid#', '#assigned_to.assignedid#', #CreateODBCDateTime(now())#)
</cfquery>

<cfquery name="retrive_helpdeskid" datasource="mysql">
	Select Max(helpdeskid) as helpdeskid
	from smg_help_desk
</cfquery>

<cfquery name="insert_link" datasource="MySQL">
	insert into smg_links (link)
		values ('#CLIENT.exits_url#/exits/index.cfm?curdoc=helpdesk/help_desk_view&amp;helpdeskid=#retrive_helpdeskid.helpdeskid#')
</cfquery>

<cfquery name="get_link_id" datasource="MySQL">
	Select Max(id) as linkid
	from smg_links
</cfquery>

<!--- message sent to the users to confirm that they have submitted a request --->
<cfoutput>
<cfmail from="#client.support_email#" to="#get_user_info.email#" subject="#client.companyshort# Help Desk - New Message Submitted">
Dear #get_user_info.firstname# #get_user_info.lastname#,

On #dateformat (now(), "dd/mm/yyyy")# at #timeformat(now(), 'h:mm:ss tt')# you submitted a request for service in the help desk 
and the #client.companyshort# Technical Support Team will be reviewing it soon.

Please login at <a href="#client.site_url#">#client.site_url#</a> to check the status, review the item, or add additional information. 
*Authentication maybe required if you are not currently logged on to the Student Management website.*

You will receive an e-mail when we update/answer your ticket.

Please DO NOT reply to this email message.  All comments on this item need to be submitted through the helpdesk system.
If you would like to post a message, please visit the link above and enter your comment in the area labled: 'Enter New Message'

#client.companyshort# Technical Support
===================================================
This is confidential information automatically
generated by #client.companyshort#.  If you have any concerns please
contact #client.support_email# immediately.
===================================================
</cfmail>

<!--- message sent to the Technical Support --->
<cfmail from="#client.support_email#" to="#assigned_to.email#, pat@student-management.com" subject="#client.companyshort# Help Desk - New Message Submitted">
Dear #assigned_to.firstname# #assigned_to.lastname#,

A new request of service has been submitted to you.

Title: #form.title#
Category: #form.category#

Text: #form.text#

Submitted on: #dateformat (now(), "dd/mm/yyyy")# by #get_user_info.firstname# #get_user_info.lastname#.
</cfmail>
</cfoutput>
			
<html>
<head>
<script language="JavaScript">
<!-- 
alert("Your ticket has successfully been sent, Thank You.");
<!-- 
location.replace("?curdoc=helpdesk/help_desk_list");
-->
</script>
</head>
</html> 

</body>
</html>
