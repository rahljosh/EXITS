<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New User</title>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin -->
function UserName() {
	document.new_user.username.value = document.new_user.email.value;
}
//  End -->
</script>

</head>
<body>

<cftry>

<cfinclude template="../querys/statelist.cfm">

<cfinclude template="../querys/countrylist.cfm">

<!--- GET COMPANIES SESSION.USERID HAS ACCESS TO --->
<cfquery name="list_companies" datasource="MySql">
	SELECT DISTINCT uar.userid, uar.companyid, c.companyshort
	FROM user_access_rights uar
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	WHERE userid = '#client.userid#'
		AND c.system_id = '4'
	GROUP BY uar.companyid
</cfquery>

<cfinclude template="../querys/get_usertype.cfm">
<!--- END OF - GET COMPANIES SESSION.USERID HAS ACCESS TO --->

<cfoutput>

<cfform method="post" name="new_user" action="?curdoc=user/qr_new_user">

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; New User</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">	
				<tr>
					<td width="49%" valign="top">
						<!--- PERSONAL INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>First Name:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="firstname" size="30" maxlength="100" required="yes" message="First Name is Required."></td>
										</tr>
										<tr>
											<td class="style1"><b>Middle Name:</b></td>
											<td class="style1"><cfinput type="text" name="middlename" size="30" maxlength="100"></td>
										</tr>											
										<tr>
											<td class="style1"><b>Last Name:</b></td>
											<td class="style1"><cfinput type="text" name="lastname" size="30" maxlength="100" required="yes" message="Last Name is Required."></td>
										</tr>
										<tr>
											<td class="style1"><b>Sex:</b></td>
											<td class="style1">
												<cfinput type="radio" name="sex" value="Male"> Male
												<cfinput type="radio" name="sex" value="Female"> Female 
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Date of Birth:</b></td>
											<td class="style1"><cfinput type="text" name="dob" size="8" maxlength="10"> mm/dd/yyyy</td>
										</tr>																				
										<tr>
											<td class="style1"><b>Drivers License:</b></td>
											<td class="style1"><cfinput type="text" name="drivers_license" size="20" maxlength="20"></td>											
										</tr>																				
										<tr>
											<td class="style1"><b>Address:</b></td>
											<td class="style1"><cfinput type="text" name="address" size="40" maxlength="100"></td>											
										</tr>
										<tr>
											<td class="style1"></td>
											<td class="style1"><cfinput type="text" name="address2" size="40" maxlength="100"></td>											
										</tr>											
										<tr>
											<td class="style1"><b>City:</b></td>
											<td class="style1"><cfinput type="text" name="city" size="30" maxlength="100"></td>											
										</tr>
										<tr>
											<td class="style1"><b>State:</b></td>
											<td colspan="3" class="style1">
												<cfselect name="state" class="style1">
													<option value="0">State...</option>
													<cfloop query="statelist">
													<option value="#id#">#statename#</option>
													</cfloop>
												</cfselect>		
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Country:</b></td>
											<td colspan="3" class="style1">
												<cfselect name="country"  class="style1">
													<option value="0">Country...</option>
													<cfloop query="countrylist">
													<option value="#countryid#" <cfif countryid EQ 232>selected</cfif>>#countryname#</option>
													</cfloop>
												</cfselect>		
											</td>
										</tr>										
										<tr>
											<td class="style1"><b>Postal Code:</b></td>
											<td class="style1"><cfinput type="text" name="zip" size="8" maxlength="10"></td>											
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<br>
						<!--- EMPLOYMENT INFORMATION --->	
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Employment Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Occupation :</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="occupation" size="40" maxlength="100"></td>
										</tr>											
										<tr>
											<td class="style1" width="30%"><b>Employer:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="businessname" size="40" maxlength="100"></td>
										</tr>	
										<tr>
											<td class="style1"><b>Work Phone:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="work_phone" size="15" maxlength="20"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<br>
						<!--- NOTES / MISCELLANEOUS INFORMATION --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Notes / Miscellaneous Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%" valign="top"><b>Notes:</b></td>
											<td class="style1" width="70%"><textarea cols="40" rows="8" name="comments"></textarea></td>
										</tr>
									</table>									
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<!--- CONTACT INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF" bordercolor="FFFFFF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Contact Information</td>
										</tr>
										<tr>
											<td class="style1"><b>Home Phone:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="phone" size="15" maxlength="20"></td>
										</tr>
										<tr>
											<td class="style1"><b>Cell Phone:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="cell_phone" size="15" maxlength="20"></td>
										</tr>
										<tr>
											<td class="style1"><b>Fax:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="fax" size="15" maxlength="20"></td>
										</tr>											
										
										<tr>
											<td class="style1"><b>Email:</b></td>
											<td class="style1"><cfinput type="text" name="email" size="40" maxlength="100" onChange="UserName()"></td>
										</tr>
										<tr>
											<td class="style1"><b>Alt. Email:</b></td>
											<td class="style1"><cfinput type="text" name="email2" size="40" maxlength="100"></td>
										</tr>
									</table>																		
								</td>
							</tr>
						</table>
						<br>
						<!--- LOGIN INFORMATION --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Usertype / Login Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Username:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="username" size="40" maxlength="50" required="yes" message="You must enter a username in order to continue."></td>
										</tr>
										<tr><td></td><td><font size="-2">* Defaults to email address, change if desire.</font></td></tr>											
										<tr>
											<td class="style1"><b>Password:</b></td>
											<td class="style1"><cfinput type="text" name="password" value="temp#RandRange(100000, 999999)#" size="10" maxlength="15" required="yes" message="You must enter a password in order to continue."></td>											
										</tr>
									</table>									
								</td>
							</tr>
						</table>
						<br>
						<!--- COMPANY ACCESS INFORMATION --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Company Access</td>
										</tr>
										<tr>
											<td class="style1" width="45%"><b>Company</b></td>
											<td class="style1" width="45%"><b>Usertype</b></td>
											<td class="style1" width="10%">&nbsp;</td>
										</tr>
										<!--- NEW COMPANY ACCESS --->
										<tr>
											<td class="style1">
												<cfselect name="companyid" required="yes" message="You must select a company in order to continue">
													<option value="0"></option>
													<cfloop query="list_companies">
														<option value="#companyid#">#companyshort#</option>
													</cfloop>
												</cfselect>
											</td>
											<td class="style1">
												<cfselect name="usertype" required="yes" message="You must select an usertype in order to continue">
													<option value="0"></option>
													<cfloop query="get_usertype">
														<option value="#usertypeid#">#usertype#</option>
													</cfloop>
												</cfselect>	
											</td>
										</tr>
									</table>									
								</td>
							</tr>
						</table>						
					</td>	
				</tr>
			</table>
			<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
				<tr><td align="center"><br><cfinput name="Submit" type="image" value="  next  " src="../pics/save.gif" alt="Next" border="0"></td></tr>
			</table>				
		</td>
	</tr>
</table>
	
</cfform>
</cfoutput>
	
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>

</body>
</html>