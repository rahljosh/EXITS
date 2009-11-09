<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New International Representative</title>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin -->
function CopyPersonal() {
if (document.new_user.copy_personal.checked) {
	document.new_user.billing_company.value = document.new_user.businessname.value;
	document.new_user.billing_contact.value = document.new_user.firstname.value+' '+document.new_user.lastname.value;
	document.new_user.billing_email.value = document.new_user.email.value;
	document.new_user.billing_address.value = document.new_user.address.value;
	document.new_user.billing_address2.value = document.new_user.address2.value;
	document.new_user.billing_city.value = document.new_user.city.value;  
	document.new_user.billing_country.value = document.new_user.country.value;
	document.new_user.billing_zip.value = document.new_user.zip.value;
	document.new_user.billing_phone.value = document.new_user.phone.value;
	document.new_user.billing_fax.value = document.new_user.fax.value;	 	   	
	}
else {
	document.new_user.billing_company.value = '';
	document.new_user.billing_contact.value = '';
	document.new_user.billing_email.value = '';
	document.new_user.billing_address.value = '';
	document.new_user.billing_address2.value = '';
	document.new_user.billing_city.value = '';
	document.new_user.billing_country.value = '0';
	document.new_user.billing_zip.value = '';
	document.new_user.billing_phone.value = '';
	document.new_user.billing_fax.value = '';	 	   		
   }
}
function UserName() {
	document.new_user.username.value = document.new_user.email.value;
}
//  End -->
</script>

</head>
<body>

<cftry>

<cfquery name="get_intrep" datasource="MySql">
	SELECT *
	FROM smg_users
	WHERE uniqueid = <cfqueryparam value="#url.uniqueid#" cfsqltype="cf_sql_char">
</cfquery>

<cfinclude template="../querys/countrylist.cfm">

<cfparam name="edit" default="no">

<cfoutput>

<cfform method="post" name="new_user" action="?curdoc=intrep/qr_intrep_info">
<cfinput type="hidden" name="userid" value="#get_intrep.userid#">
<cfinput type="hidden" name="uniqueid" value="#get_intrep.uniqueid#">

<cfif isDefined('form.edit') AND client..usertype LTE '4'>
	<cfset edit = '#form.edit#'>
</cfif>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; International Representative Information</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
				<tr>
					<td width="49%" valign="top">
						<!--- COMPANY INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Company Information</td>
										</tr>
										<tr>
											<td class="style1"><b>Status:</b></td>
											<td class="style1">
												<cfif edit EQ 'yes'>
													<cfif get_intrep.active EQ '1'><cfinput type="radio" name="active" value="1" checked="yes"> <cfelse> <cfinput type="radio" name="active" value="1"> </cfif> Active
													<cfif get_intrep.active EQ '0'><cfinput type="radio" name="active" value="0" checked="yes"> <cfelse> <cfinput type="radio" name="active" value="1"> </cfif> Inactive																
												<cfelse>
													<cfif get_intrep.active EQ '1'>Active<cfelse>Inactive</cfif>
												</cfif>											
											</td>
										</tr>																																																																															
										<tr>
											<td class="style1" width="30%"><b>Company Name:</b></td>
											<td class="style1" width="70%"><cfif edit EQ 'yes'><cfinput type="text" name="businessname" value="#get_intrep.businessname#" size="40" maxlength="100"><cfelse>#get_intrep.businessname#</cfif></td>
										</tr>											
										<tr>
											<td class="style1"><b>Address:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="address" value="#get_intrep.address#" size="40" maxlength="100"><cfelse>#get_intrep.address#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="address2" value="#get_intrep.address2#" size="40" maxlength="100"><cfelse>#get_intrep.address2#</cfif></td>											
										</tr>											
										<tr>
											<td class="style1"><b>City:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="city" value="#get_intrep.city#" size="30" maxlength="100"><cfelse>#get_intrep.city#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"><b>Country:</b></td>
											<td class="style1">
												<cfif edit EQ 'yes'>		
													<cfselect name="country"  class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
														<option value="#countryid#" <cfif countryid EQ get_intrep.country>selected</cfif>>#countryname#</option>
														</cfloop>
													</cfselect>	
												<cfelse>
													<cfloop query="countrylist">
														<cfif countryid EQ get_intrep.country>#countryname#</cfif>
													</cfloop>
												</cfif>	
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Postal Code:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="zip" value="#get_intrep.zip#" size="8" maxlength="10"><cfelse>#get_intrep.zip#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"><b>Phone:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="phone" value="#get_intrep.phone#" size="15" maxlength="20"><cfelse>#get_intrep.phone#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Fax:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="fax" value="#get_intrep.fax#" size="15" maxlength="20"><cfelse>#get_intrep.fax#</cfif></td>
										</tr>											
									</table>
								</td>
							</tr>
						</table>
						<br>
						<!--- CONTACT INFO --->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF" bordercolor="FFFFFF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Contact Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>First Name:</b></td>
											<td class="style1" width="70%"><cfif edit EQ 'yes'><cfinput type="text" name="firstname" value="#get_intrep.firstname#" size="30" maxlength="100"><cfelse>#get_intrep.firstname#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Middle Name:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="middlename" value="#get_intrep.middlename#" size="30" maxlength="100"><cfelse>#get_intrep.middlename#</cfif></td>
										</tr>											
										<tr>
											<td class="style1"><b>Last Name:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="lastname" value="#get_intrep.lastname#" size="30" maxlength="100"><cfelse>#get_intrep.lastname#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Date of Birth:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="dob" value="#DateFormat(get_intrep.dob, 'mm/dd/yyyy')#" size="8" maxlength="10"><cfelse>#DateFormat(get_intrep.dob, 'mm/dd/yyyy')#</cfif> mm/dd/yyyy</td>
										</tr>
										<tr>
											<td class="style1"><b>Sex:</b></td>
											<td class="style1">
												<cfif edit EQ 'yes'>
													<cfif get_intrep.sex EQ 'Male'><cfinput type="radio" name="sex" value="Male" checked="yes"> <cfelse> <cfinput type="radio" name="sex" value="Male"> </cfif> Male
													<cfif get_intrep.sex EQ 'Female'><cfinput type="radio" name="sex" value="Female" checked="yes"> <cfelse> <cfinput type="radio" name="sex" value="Female"> </cfif> Female																
												<cfelse>
													<cfif get_intrep.sex EQ 'Male'>Male<cfelse>Female</cfif>
												</cfif>
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Email:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="email" value="#get_intrep.email#"  size="40" maxlength="100" onChange="UserName()"><cfelse>#get_intrep.email#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Alt. Email:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="email2" value="#get_intrep.email2#" size="40" maxlength="100"><cfelse>#get_intrep.email2#</cfif></td>
										</tr>
									</table>																		
								</td>
							</tr>
						</table>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
						<!--- BILLING INFORMATION --->	
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Billing Information &nbsp &nbsp &nbsp &nbsp &nbsp <cfif edit EQ 'yes'><cfinput type="checkbox" name="copy_personal" onClick="CopyPersonal()">Copy Personal Information</cfif></td>
										</tr>
										<tr><td colspan="2" class="style1"><cfif edit EQ 'yes'><cfinput type="checkbox" name="usebilling"><cfelse><cfinput type="checkbox" name="usebilling" disabled="disabled"></cfif>Use billing address on invoice</td></tr>										
										<tr>
											<td class="style1" width="30%"><b>Company Name:</b></td>
											<td class="style1" width="70%"><cfif edit EQ 'yes'><cfinput type="text" name="billing_company" value="#get_intrep.billing_company#" size="40" maxlength="100"><cfelse>#get_intrep.billing_company#</cfif></td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Contact:</b></td>
											<td class="style1" width="70%"><cfif edit EQ 'yes'><cfinput type="text" name="billing_contact" value="#get_intrep.billing_contact#" size="40" maxlength="100"><cfelse>#get_intrep.billing_contact#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Email:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="billing_email" size="40" value="#get_intrep.billing_email#" maxlength="100"><cfelse>#get_intrep.billing_email#</cfif></td>
										</tr>																																																																		
										<tr>
											<td class="style1"><b>Address:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="billing_address" size="40" value="#get_intrep.billing_address#" maxlength="100"><cfelse>#get_intrep.billing_address#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="billing_address2" size="40" value="#get_intrep.billing_address2#" maxlength="100"><cfelse>#get_intrep.billing_address2#</cfif></td>											
										</tr>											
										<tr>
											<td class="style1"><b>City:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="billing_city" size="30" value="#get_intrep.billing_city#" maxlength="100"><cfelse>#get_intrep.billing_city#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"><b>Country:</b></td>
											<td class="style1">
												<cfif edit EQ 'yes'>
													<cfselect name="billing_country"  class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
														<option value="#countryid#" <cfif countryid EQ get_intrep.billing_country>selected</cfif>>#countryname#</option>
														</cfloop>
													</cfselect>	
												<cfelse>
													<cfloop query="countrylist">
														<cfif countryid EQ get_intrep.billing_country>#countryname#</cfif>
													</cfloop>
												</cfif>	
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Postal Code:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="billing_zip" value="#get_intrep.billing_zip#" size="8" maxlength="10"><cfelse>#get_intrep.billing_zip#</cfif></td>											
										</tr>
										<tr>
											<td class="style1"><b>Phone:</b></td>
											<td class="style1" colspan="3"><cfif edit EQ 'yes'><cfinput type="text" name="billing_phone" value="#get_intrep.billing_phone#" size="15" maxlength="20"><cfelse>#get_intrep.billing_phone#</cfif></td>
										</tr>
										<tr>
											<td class="style1"><b>Fax:</b></td>
											<td class="style1" colspan="3"><cfif edit EQ 'yes'><cfinput type="text" name="billing_fax" value="#get_intrep.billing_fax#" size="15" maxlength="20"><cfelse>#get_intrep.billing_fax#</cfif></td>
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
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Login Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Username:</b></td>
											<td class="style1" width="70%"><cfif edit EQ 'yes'><cfinput type="text" name="username" value="#get_intrep.username#" size="40" maxlength="50"><cfelse>#get_intrep.username#</cfif></td>
										</tr>
										<tr><td></td><td><font size="-2">* Defaults to email address, change if desire.</font></td></tr>											
										<tr>
											<td class="style1"><b>Password:</b></td>
											<td class="style1"><cfif edit EQ 'yes'><cfinput type="text" name="password" value="#get_intrep.password#" size="10" maxlength="15"><cfelse>#get_intrep.password#</cfif></td>											
										</tr>
									</table>									
								</td>
							</tr>
						</table>
					</td>	
				</tr>
			</table>
			<!---- SAVE BUTTON - OFFICE USERS  ---->
			<cfif client..usertype LTE '4' AND EDIT EQ 'yes'>
			<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
				<tr><td align="center"><br><cfinput name="Submit" type="image" value="  save  " src="../pics/save.gif" alt="Save" border="0"></td></tr>
			</table>
			</cfif>
			</cfform>
			
			<!---- EDIT BUTTON - OFFICE USERS  ---->
			<cfif client..usertype LTE '4' AND edit EQ 'no'>
			<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
				<tr><td align="center">
					<cfform action="" method="post">&nbsp;
						<cfinput type="hidden" name="edit" value="yes">
						<cfinput name="Submit" type="image" value="  edit  " src="../pics/edit.gif" alt="Edit"  border=0>
					</cfform>
					</td>
				</tr>
			</table>
			</cfif>
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