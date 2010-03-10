<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px dashed #FF9933;}
</style>

<cfparam name="CLIENT.exits_url" default="http://www.student-management.com">

<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfparam name="client.support_email" default="support@case-usa.org">
	<cfparam name="client.site_url" default="http://www.case-usa.org">
    <cfparam name="client.companyname" default ="Cultural Academic Student Exchange">
<cfelse>
    <cfparam name="client.support_email" default="support@student-management.com">
    <cfparam name="client.site_url" default="http://www.student-management.com">
    <cfparam name="client.companyname" default ="Student Management Group">
</cfif>

<cfquery name="get_name" datasource="mysql">
	select email, firstname, familylastname, password, app_current_status, application_expires
	from smg_students
	where studentid = '#client.studentid#'
</cfquery>

<!--- DO NOT UPDATE STATUS IF STATUS IS BIGGER THAN 1 --->
<cfif get_name.app_current_status LTE 1>
	<cfquery name="assign_student_pass" datasource="MySQL">
		update smg_students
		set password = '#form.password1#',
		app_current_status = 2
		WHERE studentid = '#client.studentid#'
	</cfquery>
	
	<cfquery name="update_status" datasource="MySQL">
		INSERT INTO smg_student_app_status (status, studentid)
				values ('2', '#client.studentid#')
	</cfquery>
</cfif>

<cfoutput query="get_name">
<cfsavecontent variable="email_message">
#firstname# #familylastname#-
<br><br>
Your account has been Successfully created. Below is your login information for your records.
<br><br>
Login ID (User ID) : #email#<br>
Password: #password1#
<br><br>
You can log in and out of the EXITS Online Application System at any time using this login information.
To login to the EXITS Online Application, go to the EXITS Login Portal at #client.exits_url#
<br><br>
Please remember that if your application will expire on #DateFormat(application_expires, 'mmm dd, yyyy')# at #TimeFormat(application_expires, 'h:mm tt')# MST.  
<br><br>
Sincerely-<br>
#client.companyname# / EXITS Support
</cfsavecontent>
			
			<!--- send email --->
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_name.email#">
                <cfinvokeargument name="email_subject" value="#client.companyshort# Account Information">
                <cfinvokeargument name="email_message" value="#email_message#">
                <cfinvokeargument name="email_from" value="#client.support_email#">
            </cfinvoke>
    <!----End of Email---->


<table align="center" width=550 class=thin-border>
			
			<tr>
				<td align="center" colspan=2><h1>Account Verification</h1></td>
			</tr>
			<tr>
				<td colspan=2>
				<h2>Your account has been activated!</h2>
				You will receive an email shortly that has your account information in it for future reference. <br><Br>
				Here are a few things to keep in mind:
				<ul>
				<li>Your application will expire on #DateFormat(application_expires, 'mmm dd, yyyy')# at #TimeFormat(application_expires, 'h:mm tt')# MST
				<li>You can check on the current status of your application at any time by logging into EXITS through the EXITS Login Portal at <a href="#client.site_url#">#client.site_url#</a>
				<li>If you forget your password, you can click on the "Forgot your login?" link on the EXITS Login Portal to retrieve your account information.
				<li>If you are having problems with the EXITS system, please contact support via the Support link on the student application.
				
				<li>If you are having problems with the application, or do not understand what the applicatiion is asking for, please contact your international representative.  Your representatives contact information is located at the 
				top of your application.
				</ul>
				Click the Start Application Process button if you are ready to start your application.<br><br><div align="center">
				<form method=post action="#client.site_url#"><input type="hidden" value=#email# name="username"><input type="hidden" name="password" value="#password1#"><input type="image" src="pics/start-application.gif" border=0 alt="Start Application"></div></form>
				</td>
			</tr>
</table>
</cfoutput>