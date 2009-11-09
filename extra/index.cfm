<link href="internal/style.css" rel="stylesheet" type="text/css" />
<title>EXTRA - Exchange Training Abroad</title>

<cfif isDefined('link')>
	<cfset cookie.smglink = '#url.link#'>
	<!--- relocate is user is logged in --->
	<cfif IsDefined('client.companyid') AND client.companyid NEQ 99>
		<cflocation url="redirect_link.cfm" addtoken="no">
	</cfif>
	<cflocation url="index.cfm" addtoken="no">
</Cfif> 

<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="497" align="center" valign="middle"><table width="720" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td height="389" background="login.gif"><br />
            <br />
              <br />
              <table width="91%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="55%">&nbsp;</td>
                  <td width="45%">
									<cfform action="loginprocess.cfm" target="_top" method="post" name="login">
                    <table width="250"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#999999">
                      <tr>
                        <td bgcolor="#FFFFFF" class="style1"><div align="center">
												
                            <table width="100%"  border="0" align="center" cellpadding="5" cellspacing="1" bordercolor="#DDE0E5">
														 <Cfoutput>
															<cfif isDefined('url.user')>
																<Tr>
																	<td bgcolor="##FF3300"><font color="white">Accounts are automatically logged out after 2 hrs of inactivity.<br>  Please re-login to continue.</td>
																</Tr>
															</cfif>
							  </Cfoutput>
                              <tr>
                                <td bordercolor="#E9ECF1" bgcolor="#FF7E0D" class="style4"><span class="style2"><strong>&nbsp;&nbsp;User:</strong></span> </td>
                              </tr>
                              <tr>
                                <td height="19" valign="top" bordercolor="#E9ECF1"><cfinput type="text" name="username" message="A username is required to login." required="yes" class="style1" size="35"></td>
                              </tr>
                              <tr>
                                <td bordercolor="#E9ECF1" bgcolor="#FF7E0D"><span class="style2"><strong>&nbsp;&nbsp;Pass:</strong></span></td>
                              </tr>
                              <tr>
                                <td height="19" valign="top" bordercolor="#E9ECF1"><cfinput type="password" name="password" message="A password is required to login." required="yes" class="style1" size="35"></td>
                              </tr>
                              <tr>
                                <td bordercolor="#E9ECF1"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td><a href="reauthenticate.cfm" target="_top" class="style1">Forgot Login?</a></td>
                                      <td><input name="Submit" type="submit" class="style1" value="Login" /></td>
                                    </tr>
                                </table></td>
                              </tr>
                            </table>
                        </div></td>
                      </tr>
                    </table>
                  </cfform>
				  </td>
                </tr>
              </table></td>
      </tr>
    </table></td>
  </tr>
</table>
