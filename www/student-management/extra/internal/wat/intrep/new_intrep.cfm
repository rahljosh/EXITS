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

<cfinclude template="../querys/countrylist.cfm">

<cfoutput>

<cfform method="post" name="new_user" action="?curdoc=intrep/qr_new_intrep">
<cfinput name="usertype" type="hidden" value="8">

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">
			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; New International Representative</td>
				</tr>
			</table>
			<br>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">	
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
											<td class="style1" width="30%"><b>Company Name:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="businessname" size="40" maxlength="100"></td>
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
											<td class="style1"><b>Country:</b></td>
											<td colspan="3" class="style1">
												<cfselect name="country"  class="style1">
													<option value="0">Country...</option>
													<cfloop query="countrylist">
													<option value="#countryid#">#countryname#</option>
													</cfloop>
												</cfselect>		
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Postal Code:</b></td>
											<td class="style1"><cfinput type="text" name="zip" size="8" maxlength="10"></td>											
										</tr>
										<tr>
											<td class="style1"><b>Phone:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="phone" size="15" maxlength="20"></td>
										</tr>
										<tr>
											<td class="style1"><b>Fax:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="fax" size="15" maxlength="20"></td>
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
											<td class="style1" width="70%"><cfinput type="text" name="firstname" size="30" maxlength="100"></td>
										</tr>
										<tr>
											<td class="style1"><b>Middle Name:</b></td>
											<td class="style1"><cfinput type="text" name="middlename" size="30" maxlength="100"></td>
										</tr>											
										<tr>
											<td class="style1"><b>Last Name:</b></td>
											<td class="style1"><cfinput type="text" name="lastname" size="30" maxlength="100"></td>
										</tr>
										<tr>
											<td class="style1"><b>Date of Birth:</b></td>
											<td class="style1"><cfinput type="text" name="dob" size="8" maxlength="10"> mm/dd/yyyy</td>
										</tr>
										<tr>
											<td class="style1"><b>Sex:</b></td>
											<td class="style1">
												<cfinput type="radio" name="sex" value="Male"> Male
												<cfinput type="radio" name="sex" value="Female"> Female 
											</td>
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
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
					
					
					<!---- 1061 --- WAT Contact Info ---->
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: WAT Information</td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Contact:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="wat_contact" size="40" maxlength="50"></td>
										</tr>
						
										<tr>
											<td class="style1"><b>Email:</b></td>
											<td class="style1"><cfinput type="text" name="wat_email" size="40" maxlength="50"></td>											
										</tr>
									</table>									
								</td>
							</tr>
						</table>
				
						<br>
						
					
					
					
						<!--- BILLING INFORMATION --->	
						<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
									<table width="100%" cellpadding=3 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Billing Information &nbsp &nbsp &nbsp &nbsp &nbsp <cfinput type="checkbox" name="copy_personal" onClick="CopyPersonal()">Copy Personal Information</td>
										</tr>
										<tr><td colspan="2" class="style1"><cfinput type="checkbox" name="usebilling">Use billing address on invoice</td></tr>										
										<tr>
											<td class="style1" width="30%"><b>Company Name:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="billing_company" size="40" maxlength="100"></td>
										</tr>
										<tr>
											<td class="style1" width="30%"><b>Contact:</b></td>
											<td class="style1" width="70%"><cfinput type="text" name="billing_contact" size="40" maxlength="100"></td>
										</tr>
										<tr>
											<td class="style1"><b>Email:</b></td>
											<td class="style1"><cfinput type="text" name="billing_email" size="40" maxlength="100"></td>
										</tr>																																																																		
										<tr>
											<td class="style1"><b>Address:</b></td>
											<td class="style1"><cfinput type="text" name="billing_address" size="40" maxlength="100"></td>											
										</tr>
										<tr>
											<td class="style1"></td>
											<td class="style1"><cfinput type="text" name="billing_address2" size="40" maxlength="100"></td>											
										</tr>											
										<tr>
											<td class="style1"><b>City:</b></td>
											<td class="style1"><cfinput type="text" name="billing_city" size="30" maxlength="100"></td>											
										</tr>
										<tr>
											<td class="style1"><b>Country:</b></td>
											<td colspan="3" class="style1">
												<cfselect name="billing_country"  class="style1">
													<option value="0">Country...</option>
													<cfloop query="countrylist">
													<option value="#countryid#">#countryname#</option>
													</cfloop>
												</cfselect>		
											</td>
										</tr>
										<tr>
											<td class="style1"><b>Postal Code:</b></td>
											<td class="style1"><cfinput type="text" name="billing_zip" size="8" maxlength="10"></td>											
										</tr>
										<tr>
											<td class="style1"><b>Phone:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="billing_phone" size="15" maxlength="20"></td>
										</tr>
										<tr>
											<td class="style1"><b>Fax:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" name="billing_fax" size="15" maxlength="20"></td>
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
											<td class="style1" width="70%"><cfinput type="text" name="username" size="40" maxlength="50"></td>
										</tr>
										<tr><td></td><td><font size="-2">* Defaults to email address, change if desire.</font></td></tr>											
										<tr>
											<td class="style1"><b>Password:</b></td>
											<td class="style1"><cfinput type="text" name="password" value="temp#RandRange(100000, 999999)#" size="10" maxlength="15"></td>											
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