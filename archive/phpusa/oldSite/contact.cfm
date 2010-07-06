<HTML>
<HEAD>
<TITLE>DM Discoveries : Private High School Program</TITLE>
<META NAME="Keywords" CONTENT="exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, private high school program, private high school, American exchange, host family, host families">
<META NAME="Description" CONTENT="The Private High School Program offers students, age 13-19 years old, the opportunity to study and live in the United States. Students are able to further their own education by attending a high level academic institution while at the same time interacting with American families and friends.">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
<script src="menu.js"></script>
<style type="text/css">
<!--
.style5 {	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: xx-small;
}
-->
</style>
</HEAD>

<BODY>
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD background="images/botton_02.gif"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td height="29"><table width="92%"  border="0" align="right" cellpadding="0" cellspacing="0">
              <tr>
                <td><P align="justify" class="style1"><span class="style2">:: Contact Us ::</span></P>
                </td>
              </tr>
            </table>              </td>
            <td width="38%" rowspan="2"><div align="center">
			<table width="80%" align="center">
			  <Cfoutput>
							  <cfif isDefined('url.user')>
							  <Tr>
								<td bgcolor="##FF3300" class="style1" align="center"><font color="white">Accounts are automatically logged out after 2 hrs of inactivity.<br>  Please re-login to continue.</td>
							  </Tr>
							  </cfif>
							  
							  <cfif isDefined('url.access')>
							  <Tr>
								<td bgcolor="##FF3300" class="style1" align="center" height="25"><font color="white">You don't have access to AXIS.</td>
							  </Tr>
							  </cfif>
						  </Cfoutput>
			  </table>
			<cfform action="loginprocess.cfm" target="_top" method="post" name="login">
              <table width="160"  border="0" cellpadding="3" cellspacing="1" bgcolor="#0078A9">
                <tr>
                  <td bgcolor="#FFFFFF" class="style1">
                      <div align="center">
                        <table width="100%"  border="0" align="center" cellpadding="2" cellspacing="1" bordercolor="#DDE0E5">
                          <cfif isDefined('client.isloggedin')>
                            <cfif client.isloggedin is 'no'>
                              <tr>
                                <td align="center" class="style1"> Username or Password Incorrect</td>
                              </tr>
                            </cfif>
                          </cfif>
                          <tr>
                            <td bordercolor="#E9ECF1" bgcolor="#FF7E0D" class="style4"><span class="style12 style19 style13"><strong>User:</strong></span> </td>
                          </tr>
                          <tr>
                            <td height="19" valign="top" bordercolor="#E9ECF1"><cfinput name="username" type="text" size="23" required="yes" message="A username is required to login." class="style1"></td>
                          </tr>
                          <tr>
                            <td bordercolor="#E9ECF1" bgcolor="#FF7E0D"><span class="style4"><strong>Pass:</strong></span></td>
                          </tr>
                          <tr>
                            <td height="19" valign="top" bordercolor="#E9ECF1"><cfinput name="password" type="password" size="23" required="yes" message="A password is required to login." class="style1"></td>
                          </tr>
                          <tr>
                            <td bordercolor="#E9ECF1"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td><a href="http://www.phpusa.com/reauthenticate.cfm" target="_top" class="style2">Forgot Login?</a></td>
                                  <td><input name="Submit" type="submit" class="style1" value="Login"></td>
                                </tr>
                            </table></td>
                          </tr>	
                        </table>
                      </div>
                  </td>
                </tr>
				</cfform>
              </table>
            </div></td>
          </tr>
          <tr>
            <td width="62%"><table width="95%"  border="0" align="right" cellpadding="0" cellspacing="0">
              <tr>
                <td class="style1"><P align="center"><br>
                  <br>
                  Luke Davis - Program Director <BR>
                    E-mail: <A href="mailto:luke@phpusa.com" 
target=_blank class="style3">luke@phpusa.com</A><BR>
                    Toll Free: 1-866-822-1095 <BR>Phone: 631-422-1095<BR>
                    Fax: 631-669-1252 </P>
                  <P align="center" class="style1"><strong>DM Discoveries </strong><BR>
                    119 Cooper Street <BR>
  Babylon, NY 11702</P>                  <div align="center">
                  </div></td>
              </tr>
            </table>              
            <P align="justify" class="style1"><br>
              <br>
            </P>
            </td>
          </tr>
          <tr>
            <td colspan="2"><br>
              <table width="92%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td><P align="center" class="style1">&nbsp;&nbsp;If you are interested in participating in a DMD Program, click on the "Student Form" button<br> 
                  to fill out your information and a representative from your home country will contact you.<br>
                  <br>
                  </P>
                </td>
              </tr>
              <tr>
                <td><div align="center">
                  <script>contact();</script>
                </div></td>
              </tr>
            </table>            </td>
          </tr>
        </table>  </TD>
	</TR>
	<TR>
		<TD>
			<IMG SRC="images/index2_06.gif" ALT="" WIDTH=770 HEIGHT=88 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>
<map name="Map">
  <area shape="rect" coords="54,21,167,73" href="http://www.student-management.com" target="_blank">
</map>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-6";
urchinTracker();
</script>
</BODY>
</HTML>