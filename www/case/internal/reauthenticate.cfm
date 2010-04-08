<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://techteamd.isu.edu/DEVELOPMENT/drew-comcom/loose.dtd">

<cfif not isDefined('client.companyid')>
<cfset client.companyid = 5>
</cfif>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Login Retrieval</title>
<link rel="stylesheet" href="login.css" type="text/css">

</head>
<cfquery name="original_company_info" datasource="caseusa">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>

<div id="login">
<div class="pagecell"><br>


<CFFORM name="login" action="get_pass.cfm" method="post">
			
<table width=75% align="Center" border=0>
	<TR>
			<TD align="left"><Cfoutput><img src="pics/case_logo_small.jpg" alt="" border="0"></td><td align="right"><h3>Cultural Academic Student Exchange<Br>Account Access</h3></TD></Cfoutput></TR>
			
				
	</tr>
	<tr>
		<td colspan=4><div align="center"><h2><br>
		 Login Retrieval<br></h2>
		  <br>
	    </td>
	</tr>
</table>
		<div class="grey_box"><br>
		
		<table border=0 align="center">
			<tr>
				<td colspan=2><div align="Center"><STRONG><font size=-1>Email Address / User ID: </strong> <CFINPUT name="Username" type="text" size="10" required="yes" message="You must enter an Email / User ID. This value cannot be blank."></td> </div>
			</tr>
			<tr>
				<Td></td><td><div align="right"><img src="pics/lock4.gif" width="18" height="17"> <input type="image" name="Submit" src="pics/submit.gif" border=0></span></td>
			</tr>
	</table>
		</font>
			 
		</div>
		<font size=-2>For account access, you must be using a browser that supports 128bit Encryption and have cookies enabled.  <br><br>
  </CFFORM>	
	<table width="90%" align="center">
		<tr>
			<td valign="top"><font size=-1> <div align="center">To maintain the security of your account, please keep your password private and secure as you would any other piece of sensitive information.</div></td>
		</tr>
	</table>
		
  <!--- <div id="siteInfo" align="center"> 
    <a href="#">About Us</a> | <a href="#">Site
    Map</a> | <a href="#">Privacy Policy</a> | <a href="#">Contact Us</a> <br> &copy;2003
    Student Management  Group
  </div> --->
</div> 


</BODY>