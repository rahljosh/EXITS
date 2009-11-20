<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Edit User</title>
<link rel="stylesheet" type="text/css" href="forms/phpcss.css">
<style>
.vline { BACKGROUND-IMAGE: url(pics/table-borders/left-vert-line.gif); BACKGROUND-REPEAT: repeat-y }
.grouptopleft { BACKGROUND-POSITION: 50% bottom; BACKGROUND-IMAGE: url(pics/table-borders/topleft.gif); BACKGROUND-REPEAT: no-repeat }
.groupTop { BACKGROUND-POSITION: 50% bottom; BACKGROUND-IMAGE: url(pics/table-borders/top.gif); BACKGROUND-REPEAT: repeat-x }
.groupTopRight { BACKGROUND-POSITION: left bottom; BACKGROUND-IMAGE: url(pics/table-borders/topright.gif); BACKGROUND-REPEAT: no-repeat }
.groupLeft { BACKGROUND-POSITION-X: right; BACKGROUND-IMAGE: url(pics/table-borders/left-vert-line.gif); BACKGROUND-REPEAT: repeat-y }
.groupRight { BACKGROUND-IMAGE: url(pics/table-borders/right.gif); BACKGROUND-REPEAT: repeat-y }
.groupBottomLeft { BACKGROUND-POSITION: right top; BACKGROUND-IMAGE: url(pics/table-borders/bottomleft.gif); BACKGROUND-REPEAT: no-repeat }
.groupBottom { BACKGROUND-POSITION: 50% top; BACKGROUND-IMAGE: url(pics/table-borders/bottom.gif); BACKGROUND-REPEAT: repeat-x }
.groupBottomRight { BACKGROUND-POSITION: left top; BACKGROUND-IMAGE: url(pics/table-borders/bottomright.gif); BACKGROUND-REPEAT: no-repeat }
.header { BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #000000  }
.footer { BACKGROUND-IMAGE: url(pics/table-borders/footerBackground.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #bf0301 }
.errMessageGradientStyle { BACKGROUND-IMAGE: url(pics/error-backgradient.gif); BACKGROUND-REPEAT: repeat-x }
.normRegistrationHeader { BACKGROUND-IMAGE: url(pics/norm-backimage.gif); BACKGROUND-REPEAT: repeat-x }
.redLine { BACKGROUND-POSITION: left 50%; BACKGROUND-IMAGE: url(pics/orange_gradiant.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #ff7e0d }
</style>
</head>

<body>
	
<cfquery name="userinfo" datasource="mysql">
	SELECT u.firstname, u.lastname, u.username, u.city, u.state, u.zip, u.country, u.dob,
		u.email, u.userid, u.usertype, u.address, u.address2,  u.password, smg_countrylist.countryname, smg_states.state as st,
	 	u.lastchange,u.datelastlogin, u.datecreated, u.occupation, u.businessname, u.emergency_phone,u.emergency_contact,
		u.phone, u.phone_ext, u.cell_phone, u.work_phone, u.work_ext, u.fax, u.whocreated, 
		u.billing_company, u.billing_contact, u.billing_address, 
		u.php_contact_name, u.php_contact_phone, u.php_contact_email,
		u.billing_address2, u.billing_city, u.active, u.billing_country, u.billing_zip, u.billing_phone, u.billing_fax, 
		u.billing_email
	FROM smg_users u
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = u.country  
	LEFT JOIN smg_states ON smg_states.id = u.state  
	WHERE userid = '#url.id#'
</cfquery>

<cfquery name="get_countrylist" datasource="MySql">
	SELECT countryid, countryname
	FROM smg_countrylist
	ORDER BY countryname
</cfquery>	

<cfquery name="state_list" datasource="mysql">
	select statename, id
	from smg_states
	ORDER BY statename
</cfquery>

<cfoutput>
<cfform name="Form1" action="?curdoc=users/edit_user_qr" id="Form1" method="post">
<cfinput type="hidden" name="userid" value="#userinfo.userid#">
<br />
<TABLE cellSpacing="0" cellPadding="0" align="center" class="regContainer">
	<tr><td class="header" colSpan="3"></td></tr>
	<TR vAlign="top">
		<TD></td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
	<tr><td class="orangeLine" colSpan="3" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
	<tr><td colSpan="3" height="10">&nbsp;</td></tr>
	<tr>
		<td width="10">&nbsp;</td>
		<td>
			<table cellSpacing="0" cellPadding="0" border="0">
				<tr>
					<td width="20">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td width="20">&nbsp;</td>
					<td><span class="reqField">*</span> Indicates a required field.</td>
				</tr>
				<tr>
					<td width="20" height="5"><img height=5 src="spacer.gif" width=1 ></td>
					<td><img height=5 src="spacer.gif" width=1 ></td>
				</tr>
			</table>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr borderColor="##d3d3d3">
		<td width="10">&nbsp;</td>
		<td>
			<!-- Personal Details Group -->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Personal Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<TBODY>
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"><span class="reqField">*</span></TD>
											<TD id="label"><span id="lblTitle" class="normalLabel">First name:</span></TD>
											<TD id="input"><input name="firstname" type="text" maxlength="225" id="firstname" value="#userinfo.firstname#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!-----Last Name---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"><span class="reqField">*</span></TD>
											<TD><span id="lblTitle" class="normalLabel">Last name:</span></TD>
											<TD id="input"><input name="lastname" type="text" maxlength="225" id="lastname" value="#userinfo.lastname#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----Date of Birth---->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Date of birth:</span>&nbsp;</td>
											<td id="input"><input name="dob" size="8" type="text" value="#DateFormat(userinfo.dob, 'mm/dd/yyyy')#" maxlength="10"/> <em>mm/dd/yyyy</em></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Email---->
										<TR vAlign="top" height="30">
											<TD width="20" align="center"><span class="reqField">*</span></TD>
											<TD><span id="lblTitle" class="normalLabel">Email address:</span></TD>
											<TD id="input"><input name="email" value="#userinfo.email#" type="text" maxlength="225" id="email" onchange="javascript:copy()"></TD>
											<TD height="1"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----- Phone ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Phone:</span></TD>
											<TD align="left"><input name="phone" type="text" maxlength="15" value="#userinfo.phone#"></TD>
											<TD height="1" colspan="2"><span id="lblTitle" class="normalLabel">Ext. </span> <cfinput type="text" name="phone_ext" value="#userinfo.phone_ext#" size="5"> <em>only numbers</em> <IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----Cell---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Cell Phone:</span></td>
											<td id="input"><input name="cell_phone" value="#userinfo.cell_phone#" type="text" maxlength="20"></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Work---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Work Phone:</span></td>
											<td id="input"><input name="work_phone" value="#userinfo.work_phone#" type="text" maxlength="20"></td>
											<td height="1" colspan="2"><span id="lblTitle" class="normalLabel">Ext. </span> <cfinput type="text" name="work_ext" size="5" value="#userinfo.work_ext#"> <em>only numbers</em> <IMG height=1 src="spacer.gif" width=20></td>
										</tr>										
											<!----- Fax ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Fax:</span></TD>
											<TD align="left"><input name="fax" type="text" maxlength="15" value="#userinfo.fax#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>	
										<!----- Emergency Contact ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Emergency Contact:</span></TD>
											<TD align="left"><input name="emergency_contact" type="text" maxlength="15" value="#userinfo.emergency_contact#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>									
										<!----- Emergency Phone ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Emergency Phone:</span></TD>
											<TD align="left"><input name="emergency_phone" type="text" maxlength="15" value="#userinfo.emergency_phone#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>																	
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
					<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
					<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table> 
			<!--- End of Personal Details --->
			
			<!--- PHP CONTACT --->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">PHP Contact Information</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbAddressDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<TBODY>
										<!-----Contact Name ---->
										<TR vAlign="middle" height="30">
											<TD width="20" align="center"></TD>
											<TD id="label"><span id="lblTitle" class="normalLabel">Contact Name:</span></TD>
											<TD id="input"><input name="php_contact_name" type="text" maxlength="150" value="#userinfo.php_contact_name#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----Phone---->
										<TR vAlign="middle" height="30">
											<TD align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Phone:</span></TD>

											<TD id="input"><input name="php_contact_phone" type="text" maxlength="20" value="#userinfo.php_contact_phone#"></TD>
											<TD height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
										<!----Email---->
										<TR vAlign="top" height="30">
											<TD align="center"></TD>
											<TD><span id="lblTitle" class="normalLabel">Email Address:</span></TD>
											<TD id="input"><input name="php_contact_email" type="text" maxlength="100" value="#userinfo.php_contact_email#"></TD>
											<TD height="1"><IMG height=1 src="spacer.gif" width=20></TD>
										</TR>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
					<td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
					<td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table> 
			
			<!--- Address details --->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Address Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbAddressDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<!----Businessname---->
										<tr vAlign="middle" height="30">
											<td width="20" align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Business Name:</span>&nbsp;</td>
											<td id="input"><input name="businessname" type="text" maxlength="60" id="businessname" value='#userinfo.businessname#'></td>
											<td height="1" colspan="2"><IMG height=1 src="spacer.gif" width=20></td>
										</tr>
										<!----Address 1---->
										<TR vAlign="middle" height="30">
											<td><LABEL id="lblAddressInd" class="reqField">*</LABEL></TD>
											<TD id="label"><span id="lblTitle" class="normalLabel">Address:</span></TD>
											<TD id="input"><input name="address" type="text" maxlength="150" id="address" value="#userinfo.address#"></TD>
											<TD width="20"><IMG height=1 src="spacer.gif" width=20></TD>
											<TD class="helpmsg"><IMG height=1 src="spacer.gif"></TD>
										</TR>
										<!----address2---->
										<TR vAlign="middle" height="30">
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input"><span id="lblTitle" class="normalLabel"><input name="address2" type="text" value="#userinfo.address2#" maxlength="150" id="address2"/></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----City---->
										<TR vAlign="middle" height="30">
											<TD align="center"><LABEL id="lblCityTownInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblTitle" class="normalLabel">City / Town:</span></TD>
											<TD id="input"><input name="city" type="text" maxlength="225" id="city" value="#userinfo.city#"></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----State---->
										<TR vAlign="middle" height="30">
											<TD align="center"><LABEL id="lblCityTownInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblTitle" class="normalLabel">State</span></TD>
											<TD id="input">
												<cfquery name="states" datasource="mysql">
													select * 
													from smg_states
												</cfquery>
												<select name="state">
													<option value='0'></option>
													<cfloop query="states">
														<option value="#id#" <cfif userinfo.state EQ states.id>selected</cfif>>#statename# - #state#</option>
													</cfloop>
												</select>
											</TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----Zip---->
										<TR vAlign="middle" height="30">
											<TD align="center"><LABEL id="lblZipCodeInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblTitle" class="normalLabel">Post / ZIP code:</span></TD>
											<TD id="input"><input name="zip" type="text" maxlength="100" id="zip" value="#userinfo.zip#"></TD>
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!--- COUNTRY --->
										<tr vAlign="middle" height="30">
											<td align="center"></td>
											<td><span id="lblTitle" class="normalLabel">Country:</span></td>
											<td id="input">
												<select name="country">
													<cfloop query="get_countrylist">
													<option value="#countryid#" <cfif countryid EQ userinfo.country>selected</cfif>>#countryname#</option>
													</cfloop>
												</select>								
											</td>
											<td colSpan="2"><IMG height=1 src="spacer.gif" width=1></td>
										</tr>
									</TABLE>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table>
			<!--- End of Address details --->
			<!--- Account Details --->
			<table cellspacing="0" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="groupTopLeft">&nbsp;</td>
					<td class="groupCaption" nowrap="true">Account Details</td>
					<td class="groupTop" width="95%">&nbsp;</td>
					<td class="groupTopRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupLeft">&nbsp;</td>
					<td colspan="2">
						<table id="rgbAccountDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td>
									<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
										<!----Username---->
										<TR vAlign="middle" height="30">
											<TD align="center" width="20"><LABEL id="lblUsernameInd" class="reqField">*</LABEL></TD>
											<TD id="label"><span id="lblTitle" class="normalLabel">Username:</span></TD>
											<TD id="input"><input name="username" type="text" maxlength="64" id="username" value="#userinfo.username#" />&nbsp;</TD>
											<TD width="20"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----Password---->
										<TR vAlign="top" height="30">
											<TD align="center"><LABEL id="lblPasswordInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblTitle" class="normalLabel">Password:</span>&nbsp; <SPAN class="helpmsg">(6 characters minimum)</SPAN></TD>										
											<input type="hidden" name="passok" value='no'>
											<TD id="input"><input name="password" type="password" maxlength="32" id="Password" value="#userinfo.password#" onkeyup="javascript:passwordChanged(this);" onchange="javascript:passwordChanged(this);" /></TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
											<TD class="helpmsg" vAlign="top" rowSpan="3">We recommend using a strong password:<BR><IMG height=5 src="spacer.gif" width=1>
												<DIV style="MARGIN-LEFT: 15px">- At least 2 letters<LABEL id="lblUsernameInd" class="reqField">*</LABEL><BR>
													- At least 2 numbers<LABEL id="lblUsernameInd" class="reqField">*</LABEL><BR>
													- One or more special characters (e.g. !, $, ##)
												</DIV>
											</TD>
										</TR>
										<!----Password Indicator---->
										<TR vAlign="top">
											<TD colSpan="2" height="8"><IMG height=8 src="spacer.gif" width=1></TD>
											<TD id="input" height="20">Password strength indicator:</TD>
											<TD height="8"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<TR vAlign="top" height="30">
											<TD colSpan="2"><IMG height=1 src="spacer.gif" width=1></TD>
											<TD id="input">
												<TABLE id="pwOuterTable" cellSpacing="0" cellPadding="1">
													<TR>
														<TD>
															<TABLE id="pwTable" cellSpacing="0" cellPadding="3" width="100%">
																<TR>
																	<TD id="pwWeak" title="Has at least 2 letters but less than 2 numbers" align="center" width="34%">Unacceptable</TD>
																	<TD id="pwMedium" title="Has at least 2 letters and 2 numbers and at least 6 characters in length" align="center" width="33%">Acceptable</TD>
																	<TD id="pwStrong" title="Has at least 2 letters, 2 numbers and either 10 characters in length or has at least one special characters" align="center" width="33%">Strong</TD>
																</TR>
															</TABLE>
														</TD>
													</TR>
												</TABLE>
											</TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
										<!----Confirm Passoword---->
										<TR vAlign="middle" height="30">
											<TD align="center"><LABEL id="lblConfirmPwdInd" class="reqField">*</LABEL></TD>
											<TD><span id="lblConfirmPwd" class="normalLabel">Confirm password:</span></TD>
											<TD id="input"><input name="password2" type="password" maxlength="32" value="#userinfo.password#" id="ConfirmPwd" /></TD>
											<TD><IMG height=1 src="spacer.gif" width=1></TD>
											<TD class="helpmsg"><IMG height=1 src="spacer.gif" width=1></TD>
										</TR>
									</TABLE>
								</td>
							</tr>
						</table>
					</td>
					<td class="groupRight">&nbsp;</td>
				</tr>
				<tr>
					<td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td><td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td><td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
				</tr>
			</table>
		</TD>
		<td width="10">&nbsp;</td>
	</TR>
	<tr>
		<td><IMG height=55 src="spacer.gif" width=1></td>
        <td align="center"><input type="image" name="imgSubmit"  src="pics/update.gif" alt="Submit" border="0" /></td>
		<td>&nbsp;</td>
	</tr>
	<tr><td class="footer" colSpan="3"></td></tr>
</TABLE>
<br />

</TD>
</TR>
</TBODY>
</TABLE> 

</cfform>
</cfoutput>
</body>
</html>