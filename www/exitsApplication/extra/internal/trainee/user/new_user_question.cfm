<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Grant Access / Add User</title>
</head>

<body>

<cftry>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=100% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Grant Access / Add User</td>
				</tr>
			</table><br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">	
				<tr>
					<td width="49%" valign="top">
						<!--- COMPANY INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td class="style2" bgcolor="8FB6C9">&nbsp;:: Grant Access</td>
										</tr>
										<tr><td class="style1">If the person you would like to add already has access to one of the SMG companies, please click grant access to give them access to EXTRA</td></tr>
										<tr><td align="center">
											<cfform action="?curdoc=user/grant_access" method="post">&nbsp;
												<cfinput type="hidden" name="edit" value="yes">
												<cfinput name="Submit" type="image" value="  edit  " src="../pics/grant-access.gif" alt="Edit"  border=0>
											</cfform>
											</td>
										</tr>										
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Add User</td>
										</tr>
										<tr><td class="style1">If the person you would like to add does not have access to one of the SMG companies, please click add user to give them access to EXTRA</td></tr>
										<tr><td align="center">
											<cfform action="?curdoc=user/new_user" method="post">&nbsp;
												<cfinput type="hidden" name="edit" value="yes">
												<cfinput name="Submit" type="image" value="  edit  " src="../pics/add-user.gif" alt="Edit"  border=0>
											</cfform>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>	
				</tr>
			</table><br />
		</td>
	</tr>
</table>
</cfoutput>
	
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>