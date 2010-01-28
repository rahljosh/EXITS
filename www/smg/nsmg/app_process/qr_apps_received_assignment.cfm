<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Application Assignment</title>
</head>

<body>

<cfif form.companyid EQ 0>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Application Assignment</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border=0 cellpadding=4 cellspacing=2 align="center" class="section">
		<tr><td align="center">You must select a company. Please go back and try again.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<cfquery name="update" datasource="MySql">
	UPDATE smg_students
	SET companyid = '#form.companyid#'
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery>
<!----Send Email if company is CASE---->
<cfif form.companyid eq 10>
<cfquery name="email_info" datasource="#application.dsn#">
select u.businessname, u.email, s.firstname, s.familylastname
from smg_students s 
LEFT join smg_users u on u.userid = s.intrep
where studentid = #form.studentid#
</cfquery>

<cfoutput>
<cfsavecontent variable="email_message">
#email_info.businessname#<br><Br>

The application for #email_info.firstname# #email_info.familylastname# has been transfered to CASE.
<br>
You will receive notification from CASE with final approval information.
<Br><br>
Regards-<br>
#client.name#<br><br>
<font size=-2>Companies that use EXITS systems are able to transfer applications to each other, if desired.  You are receiving this notice as an application has been transfered from one company to another.  Please contact #client.email# with any questions.</font>     
</cfsavecontent>
</cfoutput>

<cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#email_info.email#, josh@pokytrails.com">
                <cfinvokeargument name="reply_to" value="#client.email#">
                <cfinvokeargument name="email_subject" value="EXITS Application Transfered">
                <cfinvokeargument name="email_message" value="#email_message#">
            </cfinvoke>

<cfoutput>
</cfif>
<script language="JavaScript">
<!-- 
alert("This application has been assigned to the company selected. If transfered to CASE, an email was sent to the student.");
	location.replace("index.cfm?curdoc=app_process/apps_received");
-->
</script>
</cfoutput>
		
</body>
</html>