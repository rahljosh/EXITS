<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Password Change</title>
<link rel="stylesheet" href="login.css" type="text/css">
</head>


<cfset tempvariable = StructDelete(session,"smgfail")>
<cfset tempvariable = StructDelete(session,"smgtempuser")>
<body>
<cfquery name="original_company_info" datasource="caseusa">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<cfquery name="user_email" datasource="caseusa">
select username, email, password, zip
from smg_users 
where userid = #client.userid#
</cfquery>

<body>
<div id="login">
<div class="pagecell"><br>
	<cfoutput>
	<cfif user_email.password is #form.pass1#>
		<cfset same = 'yes'>
	<cfelse>
		<cfset same = 'no'>
	</cfif>
	<cfif #form.pass1# is #form.pass2#>
	<cfset match = 'yes'>
	<cfelse>
	<cfset match = 'no'>
	</cfif>
	<cfif #len(form.pass1)# gte 6>
	<Cfset len='ok'>
	<cfelse>
	<cfset len = 'bad'>
	</cfif>
	<cfif #form.pass1# is #user_email.username# >
	<cfset useremail = 'yes'>
	<cfelse>
	<cfset useremail = 'no'>
	</cfif>
	
	<cfif IsDefined('form.zip') AND (form.zip EQ user_email.zip)>
		<cfset userzip = 'yes'>
	<cfelse>
		<cfset userzip = 'no'>
	</cfif>
	
	<Cfif #left(form.pass1,4)# is 'temp'>
	<cfset temp = 'yes'>
	<cfelse>
	<Cfset temp = 'no'>
	</Cfif>
#user_email.username# #user_email.email#
</cfoutput>
	
		<table width=100% align="center">
			<TR>
			<TD align="left"><Cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif" alt="" border="0"></td><td align="right"><h3>#original_company_info.companyname#<Br>Account Access</h3></TD></Cfoutput></TR>
			
		</table>
		<div class="grey_box"><br>
		
		<table border=0 align="center">
			<tr>
				<td>
	<div align="left">
	<cfif match is 'yes' and len is 'ok' and useremail is 'no' and temp is 'no' and same is 'no' and userzip is 'yes'>
	<cfquery name="set_pass" datasource="caseusa">
	update smg_users
	set password = '#form.pass1#',
		changepass = 0,
		datefirstlogin = #now()#
	where userid = #client.userid#
	</cfquery>
	Your password has been changed.  You can now log in.<br>
	You will be redirected to the login page, if not <cfif url.u eq 8><a href="../int_agent2.cfm"><cfelse><a href="loginform.cfm"></cfif>click here to login.</a>
	
	<cfif url.u eq 8><meta http-equiv="Refresh" content="5;url=https://www.student-management.com/int_agent2.cfm"><cfelse><meta http-equiv="Refresh" content="5;url=loginform.cfm"></cfif>
	<cfelse>
	There was a problem with your password.  Please Correct items in RED.<br>
	Please use your browsers back button and change your new password.<br>
	<cfif userzip is 'yes'>
		<font color="green">Your zip code matches the zip on your account.<br></font>
	<cfelse>
		<font color="red">The zip code you entered does not match the zip code on your account.<br></font>
	</cfif>
	
	<cfif same is 'no'>
	<font color="green">New password is not your old password.<br></font>
	<cfelse>
	<font color="red">Your new password can not be the same as your current password.<br></font>
	</cfif>
	<cfif match is 'yes'>
	<font color="green">Passwords match<br></font>
	<cfelse>
	<font color="red">Passwords do not match<br></font>
	</cfif>
	
	<cfif len is 'ok'>
	<font color="green">Length of password is six characters or greater<br></font>
	<cfelse>
	<font color="red">Length of password is less than six characters.<br></font>
	</cfif>
	
	<cfif useremail is 'no'>
	<font color="green">Password doesn't match your email or login id<br></font>
	<cfelse>
	<font color="red">Password matchs your email or login id<br></font>
	</cfif>
	
	<cfif temp is 'no'>
	<font color="green">Your password doesn't start with 'temp'<br></font>
	<cfelse>
	<font color="red">Password starts with 'temp'<br></font>
	</cfif>
	</cfif>
</td> </div>
			</tr>
			<tr>
				<Td></td><td><cfif match is 'yes' and len is 'ok' and useremail is 'no' and temp is 'no'> <cfelse><div align="right"><img src="pics/lock4.gif" width="18" height="17"> <input type="image" name="Submit" src="pics/back.gif"  onclick="history.back()" border=0></span></cfif></td>
			</tr>
			</table>
		</font>
			 
		</div>
		<font size=-2>For account access, you must be using a browser that supports 128bit Encryption and have cookies enabled.  <br><br>

	<table>
		<tr>
			<td valign="top" width=200><font size=-1><a href="reauthenticate.cfm">Forgot User Name or Password?</a> <br><Br>
			</td>
			<td valign="top"><font size=-1> To maintain the security of your account, please keep your password private and secure as you would any other piece of sensitive information.</td>
		</tr>
	</table>
		
   <div id="siteInfo" align="center"> 
    <a href="#">About Us</a> | <a href="#">Site
    Map</a> | <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> <br> &copy;2003
    Student Management  Group
  	</div>
  </div> 







</body>
</html>
