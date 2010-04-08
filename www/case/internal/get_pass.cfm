<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Login Request</title>
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
<cfquery name="get_pass" datasource="caseusa">
select password, email, username
from smg_users
where username = '#form.username#' or email = '#form.username#'
</cfquery>
<cfif get_pass.recordcount gt 0>
<cfoutput>
<cfmail to="#get_pass.email#" replyto="passrequest@iseusa.com" failto="josh@pokytrails.com" from="accounts@iseusa.com" subject="Requested Password">
You recently requested your password from the SMG website.  The requested information is below:
Your login id is: #get_pass.username#
Your password is: #get_pass.password#

To login in please vist: <A href="http://www.student-management.com">http://www.student-management.com</a>

</cfmail>
</cfoutput>
</cfif>
<div id="login">
<div class="pagecell"><br>


<CFFORM name="login" action="get_pass.cfm" method="post">
	
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
	<tr>
		<td colspan=4><div align="center">
		<h2>Cultural Academic Student Exchange <br>
		  Family of Companies</h2>Login Retrieval</td></tr>
</table>
		<div class="grey_box"><br>
		
		<table border=0 align="center">
			<tr>
				<td colspan=2><div align="Center"><cfif get_pass.recordcount gt 0>You will receive an email shortly that contains your password.<br>
													<a href="loginform.cfm">Back to Login</a><cfelse>That Email / User ID was not found.  Please try again.<br>
													<tr>
				<div align="Center"><STRONG><font size=-1>Email Address / User ID: </strong> <CFINPUT name="Username" type="text" size="10" required="yes" message="You must enter an Email / User ID. This value cannot be blank."> </div>
			</tr>
													</cfif></td> </div>
			</tr>
			<tr>
				<Td></td><td><div align="right"><img src="pics/lock4.gif" width="18" height="17"> <input type="image" name="Submit" src="pics/submit.gif" border=0></span></td>
			</tr>
			</table>
		</font>
			 
		</div>
		<font size=-2>For account access, you must be using a browser that supports 128bit Encryption and have cookies enabled.  <br><br>
	</CFFORM>	
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
