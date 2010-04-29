<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Login</title>
<style type="text/css">
<!--
.style8 {
font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
-->
</style>
</head>
<BODY bgcolor="#FFFFFF">
<div align="center"><img src="images/ISE-Logo.gif" width="150" height="138"><br>
  <br>
</div>
<cfform action="http://www.student-management.com/flash/login.cfm" target="_top" method="post" name="login">
<cfinput type="hidden" name="login_submitted" value=1>
<table width="18%"  border="0" align="center" cellpadding="1" cellspacing="0">
  <tr>
    <td class="style2"><span class="style8">&nbsp;&nbsp;User:</span></td>
  </tr>
  <tr>
    <td height="26" valign="top">&nbsp;&nbsp;
        <cfinput name="username" type="text" size="20" required="yes" message="A username is required to login."></td>
  </tr>
  <tr>
    <td height="27" valign="bottom" ><strong class="style8">&nbsp;&nbsp;Pass:</strong></td>
  </tr>
  <tr>
    <td height="26" valign="top" class="style6">&nbsp;&nbsp;
        <cfinput name="password" type="password" size="20" required="yes" message="A password is required to login."></td>
  </tr>
  <tr>
    <td class="style1"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="55%" height="41" valign="bottom" class="style3 style1 style7"><div align="center"><a href="http://www.student-management.com/nsmg/reauthenticate.cfm" target="_top" class="style8">&nbsp;Forgot Login?</a></div></td>
        <td width="45%" valign="bottom" class="style3 style1 style7"><div align="center">
          <input name="Submit" type="submit" class="style8" value="Login">
        </div></td>
      </tr>
    </table>



	</td>
  </tr>
</table>
</cfform>



</BODY>
