
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
<html>
<head>
<title>Change Password</title>
<link rel="stylesheet" href="login.css" type="text/css">

</head>
<cfquery name="original_company_info" datasource="caseusa">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<div id="login">
<div class="pagecell"><br> 
<CFFORM name="login" action="set_password.cfm?u=#url.u#" method="post">
	
		<table width=100% align="center">
			<TR>
			<TD align="left"><Cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif" alt="" border="0"></td><td align="right"><h3>#original_company_info.companyname#<Br>Account Access<br>Change Password</h3></TD></Cfoutput></TR>
			
		</table>
		<div class="grey_box"><br>
		
	
	You must change your password, use the form below to change your password.  <br><br>
	<div align="center"><StronG>Password Change</StronG></div><br>
		  	<table align="center">
				<Tr>
					<td align="right"><font size=-2>Zip Code:</td><td><cfinput type="text" size=15 name=zip required message="To verify your account, please enter your zip code."></td>
				</Tr>
				<Tr>
					<td align="right"><font size=-2>New Password:</td><td><cfinput type="password" size=15 name=pass1 required message="You must enter a new password"></td>
				</Tr>
				<tr>
					<td align="right"><font size=-2>Verify New Password:</td><td><cfinput type="password" size=15 name=pass2 required message="You must verify your new password"></td>
				</tr>
				</table>
<div align="right"><img src="pics/lock4.gif" width="18" height="17"> <input type="image" name="Submit" src="pics/submit.gif" border=0></span></div>
			 
			</div>
			<span class="get_Attention">Please follow these guidlines when creating your password:<br>
			<ul>
			<li>MUST be between at least 6 characters long</li>
			<li>CAN NOT be your user id  </li>
			<li>CAN NOT start with 'temp'</li>
			<li>should not be alphabetic characters only </li>
			<li>should not re-use your existing password </li>
			<li>should not be easily recognizable passwords, incorporating things such as "password," your name, birth dates, names of children, or words found in a dictionary   </li>
			</ul></span>
			



		</CFFORM>	
   <div id="siteInfo" align="center"> 
    <a href="#">About Us</a> | <a href="#">Site
    Map</a> | <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> <br> &copy;2003
    Student Management  Group

  </div> 
  </div>
