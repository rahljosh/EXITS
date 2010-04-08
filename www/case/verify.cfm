
<cfquery name="verify_user" datasource="MySQL">
	select *  
	from smg_users
	where userid = '#client.userid#'
</cfquery>

<cfquery name="get_rep_info" datasource="MySql">
	SELECT DISTINCT usertype
	FROM user_access_rights
	WHERE userid = '#client.userid#'
</cfquery>

<cfif #form.zip# is #verify_user.zip#>
<cfset zipmatched = 'yes'>
<cfelse>
<cfset zipmatched = 'no'>
</cfif>

<cfif verify_user.usertype eq 8 OR verify_user.usertype eq 11>
	<cfset phonematched = 'yes'>
<cfelse>
	<cfif #form.phone# is #right(verify_user.phone,4)#>
		<Cfset phonematched = 'yes'>
	<cfelse>
		<cfset phonematched = 'no'>
	</cfif>
</cfif>	


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<title>Verification</title>
<link rel="stylesheet" href="login.css" type="text/css">

</head>


<cfquery name="original_company_info" datasource="MySQL">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<div id="login">
<div class="pagecell"><br> 
<cfif (zipmatched is not 'yes') or (phonematched is not 'yes') >
<CFFORM name="login" action="verify.cfm?u=#url.u#" method="post">
	
		<table width=100% align="center">
			<TR>
			<TD align="left"><Cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif" alt="" border="0"></td><td align="right"><h3>#original_company_info.companyname#<Br>Account Access<br>Verification</h3></TD></Cfoutput></TR>
			
		</table>
		<div class="grey_box"><br>
		
	
	Since this is your first time loging in, your will need to verify your account and change your password.<br><br>
	<div align="center"><StronG>Verification Information</StronG></div><br>
		  	<table align="center">
				<Tr>
				<td align="right"><font size=-2>Zip Code:</td><td><cfinput name=zip type="text" value="#form.zip#" size=5 required message="You must enter your zip code to verify your account"></td>
				</Tr>
				
				<cfif get_rep_info.usertype neq 8 OR get_rep_info.usertype neq 11>
				<tr>
					<td align="right"><font size=-2>Home Phone (last four):</td><td><cfinput type="text" size=5 name=phone></td>
				</tr>
				</cfif>	
				</table>
			<div align="right"><img src="pics/lock4.gif" width="18" height="17"><input type="image" name="Submit" src="pics/submit.gif" border=0> </span></div>
			 
			</div>
			<span class="get_Attention">Either your zip, last four of your phone or both did not match.  Please verify the information entered, and try again.  If you can not verify your account, 
			please fill out this form.</span>
		</CFFORM>	
   <div id="siteInfo" align="center"> 
    <a href="#">About Us</a> | <a href="#">Site
    Map</a> | <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> <br>Powered by <a href="http://www.exitgroup.org/" target="_blank"><font color="black">E</font><font color="orange">X</font><font color="black">ITS</font></a>

  </div> 
  </div>

<cfelse>
<CFFORM name="login" action="set_password.cfm?u=#url.u#" method="post">
		<cfinput type="hidden" name="zip" value="#form.zip#">
		<table width=100% align="center">
			<TR>
			<TD align="left"><Cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif" alt="" border="0"></td><td align="right"><h3>#original_company_info.companyname#<Br>Account Access<br>Verification</h3></TD></Cfoutput></TR>
			
		</table>
		<div class="grey_box"><br>
		
	
	Your have verified your account.  Please change your password below.  <br><br>
	<div align="center"><StronG>Password Change</StronG></div><br>
		  	<table align="center">
				<Tr>
				<td align="right"><font size=-2>New Password:</td><td><cfinput type="password" size=15 name=pass1 required message="You must enter a new password"></td>
				</Tr>
				<tr>
					<td align="right"><font size=-2>Verify Password:</td><td><cfinput type="password" size=15 name=pass2 required message="You must enter a new password"></td>
				</tr>
				</table>
<div align="right"><img src="pics/lock4.gif" width="18" height="17"> <input type="image" name="Submit" src="pics/submit.gif" border=0></span></div>
			 
			</div>
			<span class="get_Attention">Please follow these guidlines when creating your password:<br>
			<ul>
			<li>MUST be be at least 6 characters long</li>
			<li>CAN NOT be your user id  </li>
			<li>CAN NOT start with 'temp'</li>
			<li>should not be alphabetic characters only </li>
			<li>should not re-use your existing password </li>
			<li>should not be easily recognizable passwords, incorporating things such as "password," your name, birth dates, names of children, or words found in a dictionary   </li>
			</ul></span>
			



		</CFFORM>	
   <div id="siteInfo" align="center"> 
    <a href="#">About Us</a> | <a href="#">Site
    Map</a> | <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> <br>Powered by <a href="http://www.exitgroup.org/" target="_blank"><font color="black">E</font><font color="orange">X</font><font color="black">ITS</font></a>

  </div> 
  </div>
</cfif>
</BODY>