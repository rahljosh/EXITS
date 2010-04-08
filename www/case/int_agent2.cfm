

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Login</title>
<link rel="stylesheet" href="internal/login.css" type="text/css">
<!----If user is following a link and they are already logged in, bypas login info---->


</head>
<BODY bgcolor="#FFFFFF">
<div id="login">
<div class="pagecell"><br>

		<table width=770 align="center">
			<TR>
			<TD align="left"><Cfoutput><img src="internal/pics/case_logo_small.jpg" alt="" border="0"></td><td align="right"><h3>Cultural Academic Student Exchange<Br>Account Access</h3></TD></Cfoutput></TR>
			
				
			
		</table>
<table width="770" border="0" cellspacing="0" cellpadding="0" align="center">

    <tr>
      <td background="flash/images/about_02.gif">	  <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
         
          <td width="76%"><table align="center" class="style1" width=98% cellspacing=0 cellpadding =2>
            <Tr>
				<td colspan=2 align="Center">If you have an account on another EXITS system, your username / password are the same.</td>
				<td colspan= align="Center">Student Access is not yet available.</td>
			</Tr>
			<tr>
              <td width=50% align="center" class="thin-border-top" bgcolor="#D1E0EF"><h3>International Agents</font></h3></td>
              <td>&nbsp;</td>
              <td width=50% align="center"class="thin-border-top" bgcolor="#D1E0EF"><h3>Students</font></h3></td>
            </Tr>
            <tr>
              <td class="thin-border-bottom" valign="top"><br>
                  <cfform action="internal/loginprocess.cfm" method="post" target="_top">
                    <div align="center">Username:
                       <cfinput name="username" type="text" class="style1" required="yes" message="A username is required to login.">
                        <br>
                        <br>
                        Password:
                        <cfinput name="password" type="password" class="style1" required="yes" message="A password is required to login.">
                        <br>
                        <input name="Submit" type="submit" class="style2" value="Login">
                    </div>
                    <br>
                    <a href="http://www.case-usa.org/int_agent.cfm" class="style2">Need to activate your account?</a><br>
                    <a href="http://www.case-usa.org/exits_reauthenticate.cfm" class="style2">Forgot your login?</a><br>
                  </cfform>
              </td>
              <td></td>
              <td class="thin-border-bottom" valign="top"><br>
                  <cfform action="internal/loginprocess.cfm" method="post" target="_top">
                    <div align="center">Username:
                       <cfinput type="text" name="username" message="A username is required to login." required="yes" disabled class="style1">
                        <br>
                        <br>
                        Password:
                       <cfinput type="password" name="password" message="A password is required to login." required="yes" disabled class="style1">
                        <br>
                        <input name="Submit" type="submit" class="style2" value="Login">
                    </div>
                    <br>
                    <a href="http://www.case-usa.org/exits_reauthenticate.cfm" class="style2">Forgot your login? </a><br>
                  </cfform>
              </td>
            </tr>
          </table>
            <div align="center" class="style1">Username defaults to your email address in EXITS unless you have changed it.</div></td>
        </tr>
      </table></td>
	</tr>
	
  </table>