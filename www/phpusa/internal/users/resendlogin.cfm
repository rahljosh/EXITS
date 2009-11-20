<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Resend Login</title>
</head>

<body>
<cfquery name="get_info_for_email" datasource="mysql">
	select users.firstname, users.lastname, users.password, users.email
	from smg_users users
	where userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfoutput query="get_info_for_email">

	<cfmail from="support@phpusa.com" to="#email#" subject="New Account Created / Login Information">
		****This email has been resent.  You may or may not be prompted to change your password, depending on your account settings.****
		
		An account has been created for you on the www.phpusa.com website. Your account login information is below.  
		
		Login ID / Username: #email#
		Password: #password#
		
		Upon your first login, you will need to activate your account by providing your zip code and the last four digits of your phone number. 
		You will then be prompted to change your password from the temporary password to one of your choosing.  Once you have changed your password 
		you will have to login again with your new password.
		
		After you have successfully completed your login, you can change your password, username or any other account information by going to Users 
		from the main menu and clicking on your name, then on Edit.  All changes that you make will be immediate. 
		
		Two things to keep in mind when changing your password:
		*your password MUST be at least 6 characters long
		*you password can not start with the word 'temp'
		
		You can login immediately by visiting:  http://www.phpusa.com then click on Contact Us and log in with the information above. 
		
		If you have any questions or problems with logging in please contact support@phpusa.com  or by replying to this email.
		
		Sincerely-
		
		PHP Technical Support
		--
		Internal Ref: u#url.userid#
	</cfmail>
</cfoutput>
<cfoutput>
<cflocation url="?curdoc=users/user_info&id=#url.userid#&es">
</cfoutput>

</body>
</html>