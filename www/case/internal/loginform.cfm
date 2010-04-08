

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Login</title>
<link rel="stylesheet" href="login.css" type="text/css">
<!----If user is following a link and they are already logged in, bypas login info---->


</head>
<BODY bgcolor="#FFFFFF">

<div id="login">
<div class="pagecell"><br>

	
	


<CFFORM action="loginprocess.cfm" target="_top" method="post" name="login">

		<table width=100% align="center" >
			<TR>
			<TD align="left"><Cfoutput><img src="pics/case_logo_small.jpg" alt="" border="0"></td><td align="right"><h3>Cultural Academic Student Exchange<Br>Account Access</h3></TD></Cfoutput></TR>
			
				
			
		</table>

		<div class="grey_box"><br>
		
		<table border=0 align="center">
			<tr>
				<td colspan=2><div align="Center"><h3>Local Reps, Managers & Office Users</h3><STRONG><font size=-1>User ID: </strong> <CFINPUT name="Username" type="text" size="20" required="yes"  message="You must enter a User ID. This value cannot be blank.">&nbsp;&nbsp;&nbsp; : : : &nbsp;&nbsp;&nbsp;   <strong>Password: </strong><CFINPUT name="Password" type="password" required="yes" size="10" message="You must enter a Password. This value cannot be blank."></td> </div>
			</tr>
			<tr>
				<Td></td><td><div align="right"><img src="pics/lock4.gif" width="18" height="17"><input type="image" name="Submit" src="pics/submit.gif" border=0></span></td>
			</tr>
			</table>
		</font>
			 
		</div>
<div align="center"><a href="../int_agent2.cfm">International Agents, Login Here</a></div>
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
    <a href="../../letterfromthefounder.cfm">About Us</a> | <a href="#">Privacy Policy</a> | <a href="../../contact.cfm">Contact Us</a> <br> 
  	</div>
  </div> 


</BODY>
