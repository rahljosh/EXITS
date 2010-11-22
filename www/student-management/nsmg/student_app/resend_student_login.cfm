<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Resend Student Welcome Email</title>
</head>

<body>

<cftry>

	<cfoutput>

	<cfif NOT IsDefined('url.unqid')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>


	<cfquery name="get_student" datasource="mysql">
		SELECT firstname, familylastname, email, password, randid, uniqueid, intrep, branchid
		FROM smg_students
		WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>

	<!--- send a copy to MAIN OFFICE OR BRANCH - IT DEPENDS WHO CREATED THE STUDENT --->
	<cfquery name="agent_info" datasource="MySQL">
		SELECT businessname, phone, email, studentcontactemail
		FROM smg_users 
		WHERE userid = <cfif get_student.branchid EQ 0>'#get_student.intrep#'<cfelse>'#get_student.branchid#'</cfif>
	</cfquery>
	<!--- MAIN OFFICE --->
	<cfif get_student.branchid EQ 0>
		<cfset int_email = '#agent_info.email#'>
	<!--- BRANCH --->
	<cfelse>
		<cfset int_email = '#agent_info.studentcontactemail#'>
	</cfif>
<cfsavecontent variable="email_message">
#get_student.firstname#-
<br><br>
**This email has been resent to you. This may indicate that your login info has changed, please note any changes to your login info below.**
<br /><br />

See your login information below: 
<br /><br />
username: #get_student.email# <br>
password: #get_student.password# 
<br /><br />

Please visit <a href="#client.exits_url#">#client.exits_url#</a> to log in into your online application.
<br><br>
If you have any questions about the application or the information you need to submit, please contact your international representative:
<br><br>
#agent_info.businessname#<br>
#agent_info.phone#<br>
#agent_info.email#<br><br>

For technical issues with EXITS, submit questions to the support staff via the EXITS system.
</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_student.email#">
                <cfinvokeargument name="email_subject" value="#client.companyshort# Exchange Application - Login Information">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
    <!----End of Email---->


	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("EXITS - You have successfully resent the login information for #get_student.firstname# #get_student.familylastname#. Thank You.");
	location.replace("querys/close_window.cfm");		
	-->
	</script>
	</head>
	</html> 		

	</cfoutput>
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>	