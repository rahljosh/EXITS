<!--- this is included by cfc/email.cfc, send_mail function --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>S</title>
</head>
<body>
<cfoutput>

<!--- sample image
<img src="#application.site_url#/images/email/email-header.jpg" width="750" height="100" border="0" usemap="#Map" />--->

<cfif trim(email_message) NEQ ''>
	#email_message#<br /><br />
</cfif>

<cfswitch expression="#include_content#">
<!--- Send/resend login info:  used when called by: forms/user_form.cfm, user_info.cfm --->
<cfcase value="send_login,resend_login">
    <cfquery name="get_user" datasource="#application.dsn#">
        SELECT smg_users.*, smg_companies.companyname
        FROM smg_users LEFT JOIN smg_companies ON smg_users.defaultcompany = smg_companies.companyid
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
    </cfquery>

	<cfif include_content EQ 'resend_login'>
		<p>****This email has been resent.  You may or may not be prompted to change your password, depending on your account settings.****</p>
    </cfif>

    <p>An account has been created for you on the #client.companyname# website.  Your account login information is below.</p>
    
    <p>Login ID / Username: #get_user.username#<br />
    Password: #get_user.password#</p>
    
    <p>Upon your first login, you will need to activate your account by providing your zip code and the last four digits of your phone number. 
    You will then be prompted to change your password from the temporary password to one of your choosing.  Once you have changed your password 
    you will have to login again with your new password.</p>
    
    <p>After you have successfully completed your login, you can change your password, username or any other account information by going to Users 
    from the main menu and clicking on your name, then on Edit.  All changes that you make will be immediate.</p> 
    
    <p>Two things to keep in mind when changing your password:<br />
    * your password MUST be at least 6 characters long<br />
    * your password can not start with the word 'temp'</p>
    
    <p>You can login immediately by visiting:  <a href="#client.site_url#">#client.site_url#</a>  and log in with the information above.</p> 
    
    <p>If you have any questions or problems with logging in please contact <a href="mailto:#client.support_email#">#client.support_email#</a> or by replying to this email.</p>
    
    <p>If you have questions regarding your account access levels, please contact your Regional Advisor or Regional Director.</p> 
    
    <br />
    <p>Sincerely-</p>
    
    <p>#client.companyshort# Technical Support</p>
</cfcase>
</cfswitch>

<p><font size="1"><a href="#client.site_url#">#client.site_url#</a></font></p>

</cfoutput>
</body>
</html>