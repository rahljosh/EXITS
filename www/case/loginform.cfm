
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" ">
<cfif not isDefined('client.companyid')>
<cfset client.companyid = '99'>
</cfif>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Login</title>
<link rel="stylesheet" href="login.css" type="text/css">
<!----If user is following a link and they are already logged in, bypas login info---->
<cfif isDefined('cookie.smglink')>
	<cfif client.companyid neq 99>
		<cflocation url="redirect_link.cfm">
	</cfif>
<cfelse>
</cfif>

<cfif isDefined("client.smgfail")>
<cfelse>
<cfset client.smgfail='no'>
<cfset client.smgtempuser=''>
</cfif>
</head>
<BODY bgcolor="#FFFFFF">

<cfquery name="original_company_info" datasource="MySQL">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<div id="login">
<div class="pagecell"><br>
<cfif original_company_info.recordcount is 0>
	
	
<table width=75% align="Center" border=0>
	<tr>
		<td align="Center">
		<a href="http://www.dmdusa.com/"><img src="pics/logos/dmd_logo.jpg" width="60" height="75" alt="" border="0"></a>
		</td>
		<td align="Center">

<a href="intoedventures/index.html"><img src="pics/logos/into_ed_logo.gif" width="75" height="75" border="0" alt=""></a>
		</td>
		<td align="Center">
<a href="iseusa/index.cfm"><img src="pics/logos/ise_logo.jpg" width="80" height="75" alt="" border="0"></a>
		</td>
		<td align="Center">
		<a href="http://www.asainternational.com"><img src="pics/logos/asa_logo.jpg" width="72" height="75" alt="" border="0"></a>
		</td>
		
	</tr>
<cfif isDefined('cookie.smglink')>
			<tr>
				<td colspan=4><div align="center"><h2>Student Managment Group<br>Family of Companies</h2>The link you followed requires authentication.  Please login and you will be taken to the link.</td>
			</tr>
			
<cfelse>
	<tr>
		<td colspan=4><div align="center"><h2>Student Managment Group<br>Family of Companies</h2>If you have an account with any of the SMG companies enter your login information here.</td></tr>
</cfif>
</table>
</cfif>

<CFFORM action="loginprocess.cfm" target="_top" method="post" name="login">
	<cfif original_company_info.recordcount is 0>
	<cfelse>
		<table width=100% align="center">
			<TR>
			<TD align="left"><Cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif" alt="" border="0"></td><td align="right"><h3>#original_company_info.companyname#<Br>Account Access</h3></TD></Cfoutput></TR>
			<cfif isDefined('cookie.smglink')>
			<tr>
				<td colspan=2>The link you followed requires authentication.  Please login and you will be taken to the link.</td>
			</tr>
			
			</cfif>
			
				
			
		</table>
		</cfif>
		<div class="grey_box"><br>
		
		<table border=0 align="center">
			<tr>
				<td colspan=2><div align="Center"><STRONG><font size=-1>User ID: </strong> <CFINPUT name="Username" type="text" size="20" required="yes" value='#client.smgtempuser#' message="You must enter a User ID. This value cannot be blank.">&nbsp;&nbsp;&nbsp; : : : &nbsp;&nbsp;&nbsp;   <strong>Password: </strong><CFINPUT name="Password" type="password" required="yes" size="10" message="You must enter a Password. This value cannot be blank."></td> </div>
			</tr>
			<tr>
				<Td><Cfif client.smgfail is 'true'><span class="get_attention"><font size=-1>
There was an error with either your User ID or Password.<br>We were unable to log you on successfully. Please try again.
 </span></Cfif></td><td><div align="right"><img src="pics/lock4.gif" width="18" height="17"><input type="image" name="Submit" src="pics/submit.gif" border=0></span></td>
			</tr>
			</table>
		</font>
			 
		</div>
		<font size=-2><!----For account access, you must be using a browser that supports 128bit Encryption and have cookies enabled.---->  <br><br>
	</CFFORM>	
	<table>
		<tr>
			<td colspan=2>
			<font size=-2>
			If this is your first time loging into the system, your account has been assigned a temporary password.  This
			password starts with the word 'temp' followed by 6 digits.  You MUST include the word temp as part of the password or you will not be able
			to succesfully log in.</font><br><br>
			</td>
		</tr>
	
		<tr>
			<td valign="top" width=200><font size=-1><a href="reauthenticate.cfm">Forgot User Name or Password?</a>
			<br><br>
			</td>
			<td valign="top"><font size=-1> To maintain the security of your account, please keep your password private and secure as you would any other piece of sensitive information.</td>
		</tr>
	</table>
		
   <div id="siteInfo" align="center"> 
    <a href="../../letterfromthefounder.cfm">About Us</a> | <a href="#">Privacy Policy</a> | <a href="../../contact.cfm">Contact Us</a> <br> &copy;2005
    Student Management  Group
  	</div>
  </div> 


</BODY>
