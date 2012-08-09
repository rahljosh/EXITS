<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Candidate</title>


<style type="text/css">
<!--
.smaller_font {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.smaller_title {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:FFFFFF;
	font:bold;
}
.smaller_title2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color:black;
	font:bold;
}
-->
<!---- style 1 = smaller_font // style 2 = smaller_title !---------->
<!--- r i g h t por l e f t ---->
<!----- space is using a underline with white color >> <font color="FFFFFF">_</font>  ---->
</style>

</head>

<body>

<!---- <cftry>---->

<cfinclude template="../querys/countrylist.cfm">
<cfinclude template="../querys/fieldstudy.cfm">
<cfinclude template="../querys/program.cfm">
<cfinclude template="../querys/intagents.cfm">

	
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="FFFFFF">
	<tr>
		<td bordercolor="FFFFFF">

			<cfoutput>
			
			<cfform method="post" name="NewCandidate" id="NewCandidate" action="?curdoc=candidate/qr_new_candidate">
			<cfset tid = createuuid()>
			<cfinput type="hidden" name="uniqueid" value='#tid#'>

				<!----Header Table---->
				<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
					<tr bgcolor="E4E4E4">
						<td class="smaller_title2">&nbsp; &nbsp; Adding Candidate </td>
					</tr>
				</table>
			
				<br>
				
				<table width="770" border="0" cellpadding="0" cellspacing="0" align="center">	
					<tr>
						<td width="49%" valign="top">
						
							<!--- PERSONAL INFO --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="C2D1EF" bordercolor="FFFFFF">
												<td colspan="2" class="smaller_title" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" width="35%" align="left"><b>Last Name:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="lastname" size="32" maxlength="100" required="yes" message="First Name!"></td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" width="35%" align="left"><b>First Name:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="firstname" size="32" maxlength="100" required="yes" message="Last Name!"></td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" width="35%" align="left"><b>Middle Name:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="middlename" size="32" maxlength="100"></td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" width="35%" align="left"><b>Sex:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" width="65%">
													<cfinput type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex."> Male
						              <cfinput type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex."> Female												</td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" width="35%" align="left"><b>Date of Birth:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="dob" size="18" maxlength="20" required="yes" validate="date" message="Date of Birth (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font></td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" width="35%" align="left"><b>Place of Birth:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="birth_city" size=32 maxlength="100"></td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" align="left"><b>Country of Birth:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF">
				
													<cfselect name="birth_country" required="yes" message="You must select a country of birth." class="smaller_font">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>												</td>
											</tr>		
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" align="left"><b>Country<font color="FFFFFF">_</font>of<font color="FFFFFF">_</font>Citizenship:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF">
												
													<cfselect name="citizen_country" required="yes" message="You must select a country of residence." class="smaller_font">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>												</td>
											</tr>
											<tr>
												<td class="smaller_font" bordercolor="FFFFFF" align="left"><b>Country<font color="FFFFFF">_</font>of<font color="FFFFFF">_</font>Permanent<font color="FFFFFF">_</font>Residence:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF">
												
													<cfselect name="residence_country" required="yes" message="You must select a country of residence." class="smaller_font">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>												</td>
											</tr>
											<tr>				
												<td class="smaller_font" bordercolor="FFFFFF" colspan="2">
				
													<table width="100%" cellpadding=1 cellspacing=2 border=1 bordercolor="C7CFDC" bgcolor="F7F7F7">
														<tr bordercolor="F7F7F7">
															<td colspan="4" class="smaller_font"><b>Mailing Address:</b> <cfinput type="text" name="home_address" size=49 maxlength="200"></td>
														</tr><!----
														<tr bordercolor="F7F7F7">
															<td class="smaller_font" align="left"><b>City:</b></td>
															<td class="smaller_font"><cfinput type="text" name="home_city" size=11 maxlength="100"></td>
															<td class="smaller_font" align="left"><b>Zip:</b></td>
															<td class="smaller_font"><cfinput type="text" name="home_zip" size=11 maxlength="15"></td>
														</tr>---->
														<tr bordercolor="F7F7F7">
															<td class="smaller_font" align="left"><b>Country:</b></td>
															<td colspan="3" class="smaller_font">
															
																<cfselect name="home_country"  class="smaller_font">
																	<option value="0">Country...</option>
																	<cfloop query="countrylist">
																	<option value="#countryid#">#countryname#</option>
																	</cfloop>
																</cfselect>															</td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="smaller_font" align="left"><b>Phone:</b></td>
															<td class="smaller_font" colspan="3"><cfinput type="text" name="home_phone" size=38 maxlength="50"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="smaller_font" align="left"><b>Email:</b></td>
															<td class="smaller_font" colspan="3"><cfinput type="text" name="email" size=38 maxlength="100"></td>
														</tr>
													</table>												</td>					
											</tr>
											<tr>
												<td align="left" bordercolor="FFFFFF" class="smaller_font"><b>Social Security Number:</b></td>
												<td class="smaller_font" bordercolor="FFFFFF"><cfinput name="ssn" type="text" id="ssn" size="18" maxlength="100" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for host father in the following format xxx-xx-xxxx"> xxx-xx-xxxx</td>
											</tr>
											<tr>
											  <td align="left" bordercolor="FFFFFF" class="smaller_font"><b>English Assessment:</b></td>
											  <td class="smaller_font" bordercolor="FFFFFF"><cftextarea name="personal_info" cols="25" rows="3"></cftextarea></td>
											  </tr>
										</table>
										
									</td>
								</tr>
							</table>
														
							
						<!--- PASSPORT INFORMATION ---></td>
						<td width="2%" valign="top">&nbsp;</td>
						<td width="49%" valign="top"><table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
              <tr>
                <td bordercolor="FFFFFF"><table width="100%" cellpadding=5 cellspacing=0 border=0>
                    <tr bgcolor="##C2D1EF">
                      <td colspan="2" class="smaller_title" bgcolor="8FB6C9">&nbsp;:: Passport Information </td>
                    </tr>
                    <tr>
                      <td width="33%" class="smaller_font" align="left"><b>Passport<font color="FFFFFF">_</font>Number:</b></td>
                      <td class="smaller_font"><cfinput name="passport_number" type="text" id="passport_number" size="31" maxlength="200"></td>
                    </tr>
                    <tr>
                      <td class="smaller_font" align="left"><b>Country<font color="FFFFFF">_</font>Where<font color="FFFFFF">_</font>Issued:</b></td>
                      <td class="smaller_font">
											<cfselect name="passport_country" required="yes" message="You must select a country of birth." class="smaller_font">
                        <option value="0">Country...</option>
                        <cfloop query="countrylist">
                          <option value="#countryid#">#countryname#</option>
                        </cfloop>
                      </cfselect>
											</td>
                    </tr>
                    <tr>
                      <td class="smaller_font" align="left"><b>Date Issued:</b></td>
                      <td class="smaller_font"><cfinput type="text" name="passport_date" size="16" maxlength="20" validate="date" message="Passport Date Issued must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
                    </tr>
                    <tr>
                      <td class="smaller_font" align="left"><b>Date Expires:</b></td>
                      <td class="smaller_font"><cfinput type="text" name="passport_expires" size="16" maxlength="20" validate="date" message="Passport Date Expires must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
                    </tr>
                </table></td>
              </tr>
            </table>
              <br>
							  <!--- EMERGENCY CONTACT --->
							  <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="3" class="smaller_title" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
											</tr>
											<tr>
												<td align="left" class="smaller_font"><b>Name:</b></td>
												<td colspan="2" class="smaller_font"><cfinput type="text" name="emergency_name" size="32" maxlength="200"></td>
											</tr>
											<tr>
												<td align="left" class="smaller_font"><b>Phone:</b></td>
												<td colspan="2" class="smaller_font"><cfinput type="text" name="emergency_phone" size="32" maxlength="50"></td>
											</tr><!-----1074 (2) --- 
											<tr>
											  <td align="left" class="smaller_font"><b>Relationship:</b></td>
											  <td colspan="2" class="smaller_font"><cfinput name="emergency_relationship" type="text" id="emergency_relationship" size="32" maxlength="50"></td>
											  </tr>----->
										</table>	
										
									</td>
								</tr>
							</table>
							
							<br>
							
							<!--- PROGRAM INFO --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF" bordercolor="FFFFFF">
												<td class="smaller_title" bgcolor="8FB6C9" colspan="4">&nbsp;:: Program Information &nbsp;</td>
											</tr>
											<tr>
												<td width="27%" align="left" bordercolor="FFFFFF" class="smaller_font"><b>Program:</b></td>
												<td width="73" colspan="3" bordercolor="FFFFFF" class="smaller_font">
												
													<cfselect name="programid"  class="smaller_font" required="yes">
														<option value="0">Select....</option>
														<cfloop query="program">
															<option value="#programid#">#programname#</option>
														</cfloop>
													</cfselect>
													
												</td>
											</tr>
	
											<tr>
												<td width="27%" align="left" bordercolor="FFFFFF" class="smaller_font"><b>Int. Rep.:</b></td>
												<td width="73" colspan="3" bordercolor="FFFFFF" class="smaller_font">
												
													<cfselect name="intrep"  class="smaller_font" required="yes">
														<option value="0">Select...</option>
														<cfloop query="internationalagents">
															<option value="#userid#"><cfif len(businessname) gt 30>#Left(businessname,28)#...<cfelse>#businessname#</cfif></option>
														</cfloop>
													</cfselect>												</td>
											</tr>
											
											
											<!--- from wat - Requested placement --->	
							<tr><td width="10" class="smaller_font" align="left"><b>Request<font color="FFFFFF">_</font>Placement:</b>
							<td width="10" class="smaller_font"> 
							
							<Cfquery name="hostcompany" datasource="MySQL">
								SELECT name, hostcompanyid, companyid
								FROM extra_hostcompany
								WHERE companyid = 9
								ORDER BY name
							</Cfquery>

							
									<cfselect name="combo_request">
											<option value="">Select...</option>
												<cfloop query="hostcompany">
											<option value="#hostcompanyid#"> #Left(name, 30)# </option>
												</cfloop>
									</cfselect>
	<br></td></tr>			
											<!---- // close requested placement --->
											
											
											<tr>
												<td align="left" bordercolor="FFFFFF" class="smaller_font"><b><br>Start Date</b></td>
												<td class="smaller_font" bordercolor="FFFFFF" colspan="3"><cfinput type="text" name="program_startdate" size="18" maxlength="20" validate="date" message="Start Date must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
											</tr>
											<tr>
											  <td align="left" bordercolor="FFFFFF" class="smaller_font"><b>End Date:</b></td>
											  <td class="smaller_font" bordercolor="FFFFFF" colspan="3"><cfinput type="text" name="program_enddate" size="18" maxlength="20" validate="date" message="End Date must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
											</tr>
											<tr>
												<td colspan="4" bordercolor="FFFFFF" class="smaller_font"><div align="center"><b>Previously participated in the H2B Program?<br>
												      </b>
												    <cfinput type="radio" name="h2b_participated" value="1" required="yes" message="Previously participated in the H2B Program?">
												  Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <cfinput type="radio" name="h2b_participated" value="0" required="yes" message="Previously participated in the H2B Program?">
												  No</div>
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
					<tr>
						<td align="center"><br><cfinput name="Submit" type="image" value="  next  " src="../pics/save.gif" alt="Next" border="0"><br></td>
					</tr>
				</table>
				
				</cfform>

				</cfoutput>
	
			</td>
		</tr>
	</table>
<!----

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry> ---->