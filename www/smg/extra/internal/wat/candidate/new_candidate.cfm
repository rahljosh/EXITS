<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Candidate</title>


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
						<td class="title1"><font size="2">&nbsp; &nbsp; Adding Candidate </font> </td>
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
												<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
											</tr>
											
											<tr>
											  <td class="style1" width="35%" align="left"><font size="1"><b>Last Name:</b></font></td>
											  <td class="style1" width="65%"><cfinput type="text" name="lastname" size="32" maxlength="100" required="yes" message="Last Name!"></td>
											</tr>
											<tr>
												<td class="style1" width="35%" align="left"><font size="1"><b>First Name:</b></font></td>
												<td class="style1" width="65%"><cfinput type="text" name="firstname" size="32" maxlength="100" required="yes" message="First Name!"></td>
											</tr>
											<tr>
												<td class="style1" width="35%" align="left"><font size="1"><b>Middle Name:</b></font></td>
												<td class="style1" width="65%"><cfinput type="text" name="middlename" size="32" maxlength="100"></td>
											</tr>
										
											<tr>
												<td class="style1" width="35%" align="left"><font size="1"><b>Sex:</b></font></td>
												<td class="style1" width="65%">
													<cfinput type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex."><font size="1"> Male</font>
						              				<cfinput type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex."> <font size="1">Female</font>												</td>
											</tr>
											<tr>
												<td class="style1" align="left"><font size="1"><b>Date of Birth:</b></font></td>
												<td class="style1"><cfinput type="text" class="datePicker" name="dob" maxlength="20" required="yes" validate="date" message="Date of Birth (MM/DD/YYYY)"> <font size="1">(mm/dd/yyyy)</font> </td>
											</tr>
											<tr>
												<td class="style1" width="35%" align="left"><font size="1"><b>City of Birth:</b></font></td>
												<td class="style1" width="65%"><cfinput type="text" name="birth_city" size=32 maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="left"><font size="1"><b>Country of Birth:</b></font></td>
												<td class="style1" bordercolor="FFFFFF">
				
													<cfselect name="birth_country" required="yes" message="You must select a country of birth." class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#"><font size="1">#countryname#</font></option>
														</cfloop>
													</cfselect>												</td>
											</tr>		
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="left"><font size="1"><b>Country of Citizenship:</b></font></td>
												<td class="style1" bordercolor="FFFFFF">
												
													<cfselect name="citizen_country" required="yes" message="You must select a country of residence." class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>												</td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="left"><font size="1"><b>Country<font color="FFFFFF">_</font>of<font color="FFFFFF">_</font>Permanent<font color="FFFFFF">_</font>Residence:</b></font></td>
												<td class="style1" bordercolor="FFFFFF">
												
													<cfselect name="residence_country" required="yes" message="You must select a country of residence." class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>												</td>
											</tr>
											<tr>				
												<td class="style1" bordercolor="FFFFFF" colspan="2">
				
													<table width="100%" cellpadding=1 cellspacing=2 border=1 bordercolor="C7CFDC" bgcolor="F7F7F7">
														<tr bordercolor="F7F7F7">
															<td colspan="4" class="style1"><font size="1"><b>Mailing Address:</b> </font><cfinput type="text" name="home_address" size=49 maxlength="200"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="left"><font size="1"><b>City:</b></font></td>
															<td class="style1"><cfinput type="text" name="home_city" size=11 maxlength="100"></td>
															<td class="style1" align="left"><font size="1"><b>Zip:</b></font></td>
															<td class="style1"><cfinput type="text" name="home_zip" size=11 maxlength="15"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="left"><font size="1"><b>Country:</b></font></td>
															<td colspan="3" class="style1">
															
																<cfselect name="home_country"  class="style1">
																	<option value="0">Country...</option>
																	<cfloop query="countrylist">
																	<option value="#countryid#">#countryname#</option>
																	</cfloop>
																</cfselect>															</td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="left"><font size="1"><b>Phone:</b></font></td>
															<td class="style1" colspan="3"><cfinput type="text" name="home_phone" size=38 maxlength="50"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="left"><font size="1"><b>Email:</b></font></td>
															<td class="style1" colspan="3"><cfinput type="text" name="email" size=38 maxlength="100"></td>
														</tr>
													</table>												</td>					
											</tr>
											<tr>
												<td class="style1" width="35%" align="left"><font size="1"><b>Social Security Number:</b></font></td>
												<td class="style1" width="65%"><cfinput type="text" name="ssn" size=32 maxlength="15"></td>
											</tr>
											<tr>
											  <td align="left" bordercolor="FFFFFF" class="style1"><font size="1"><b>English Assessment:</b></font><br>


</td>
											  <td class="style1" bordercolor="FFFFFF"><cftextarea name="personal_info" cols="25" rows="3"></cftextarea></td>
											  </tr>
										</table>
										
									</td>
								</tr>
							</table>
										
							<br>
							<!---DOCUMENTS CONTROL --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
											</tr>
											<tr>
												<td width="46%" class="style1"><input type="checkbox" name="wat_doc_agreement"><font size="1"> Agreement</font></td>
												<td width="54%" class="style1"><input type="checkbox" name="wat_doc_college_letter"><font size="1"> College Letter </font></td>
											</tr>
											<tr>
												<td class="style1"><input type="checkbox" name="wat_doc_passport_copy"><font size="1"> Passport Copy</font></td>
												<td class="style1"><input type="checkbox" name="wat_doc_job_offer"><font size="1"> Job Offer</font></td>
											</tr>
											<tr>
												<td class="style1"><input type="checkbox" name="wat_doc_orientation"><font size="1"> Orient. Sign Off</font></td>
                                                <td class="style1">
                                                    <input type="checkbox" name="wat_doc_walk_in_agreement" id="wat_doc_walk_in_agreement" value="1"> 
                                                    <label for="wat_doc_walk_in_agreement">Walk-In Agreement</label>
                                                </td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<br>
														
							
						<!--- PASSPORT INFORMATION ---></td>
						<td width="2%" valign="top">&nbsp;</td>
						<td width="49%" valign="top"><table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
              <tr>
                <td bordercolor="FFFFFF"><table width="100%" cellpadding=5 cellspacing=0 border=0>
                    <tr bgcolor="##C2D1EF">
                      <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Passport Information </td>
                    </tr>
                    <tr>
                      <td width="33%" class="style1" align="left"><font size="1"><b>Passport Number:</b></font></td>
                      <td class="style1"><cfinput name="passport_number" type="text" id="passport_number" size="31" maxlength="200"></td>
                    </tr> <!--- ticket 1037 ----
                    <tr>
                      <td class="style1" align="left"><b>Country Issued:</b></td>
                      <td class="style1">
											<cfselect name="passport_country" required="yes" message="You must select a country of birth." class="style1">
                        <option value="0">Country...</option>
                        <cfloop query="countrylist">
                          <option value="#countryid#">#countryname#</option>
                        </cfloop>
                      </cfselect>
											</td>
                    </tr>
                    <tr>
                      <td class="style1" align="left"><b>Date Issued:</b></td>
                      <td class="style1"><cfinput type="text" name="passport_date" size="16" maxlength="20" validate="date" message="Passport Date Issued must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
                    </tr>
                    <tr>
                      <td class="style1" align="left"><b>Date Expires:</b></td>
                      <td class="style1"><cfinput type="text" name="passport_expires" size="16" maxlength="20" validate="date" message="Passport Date Expires must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
                    </tr>--->
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
										<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
									</tr>
									<tr>
										<td align="left" class="style1"><font size="1"><b>Name:</b></font></td>
										<td colspan="2" class="style1"><cfinput type="text" name="emergency_name" size="32" maxlength="200"></td>
									</tr>
									<tr>
										<td align="left" class="style1"><font size="1"><b>Phone:</b></font></td>
										<td colspan="2" class="style1"><cfinput type="text" name="emergency_phone" size="32" maxlength="50"></td>
									</tr><!----- 1052 ----
									<tr>
										<td align="left" class="style1"><font size="1"><b>Relationship:</b></td>
										<td colspan="2" class="style1"><cfinput name="emergency_relationship" type="text" id="emergency_relationship" size="32" maxlength="50"></td>
										</tr>----->
								</table>	
								
							</td>
						</tr>
					</table>
							
							<br>
							 <!--- DATES OF THE OFFICIAL VACATION --->
							 <table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Dates of the Official Vacation</td>
											</tr>
											<tr>
												<td align="left" class="style1"><font size="1"><b>Start Date:</b></font></td>
												<td colspan="2" class="style1"><cfinput type="text" class="datePicker" name="wat_vacation_start" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"> <font size="1">(mm/dd/yyyy)</font></td>
											</tr>
											<tr>
												<td align="left" class="style1"><font size="1"><b>End Date:</b></font></td>
												<td colspan="2" class="style1"><cfinput type="text" class="datePicker" name="wat_vacation_end" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"> <font size="1">(mm/dd/yyyy)</font></td>
											</tr>
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
												<td class="style2" bgcolor="8FB6C9" colspan="4">&nbsp;:: Program Information &nbsp;</td>
											</tr>
											<tr>
												<td width="27%" align="left" bordercolor="FFFFFF" class="style1"><font size="1"><b>Program:</b></font></td>
												<td width="73" colspan="3" bordercolor="FFFFFF" class="style1">
												
													<cfselect name="programid"  class="style1" required="yes">
														<option value="0">Select....</option>
														<cfloop query="program">
															<option value="#programid#">#programname#</option>
														</cfloop>
													</cfselect>
													
												</td>
											</tr>
	
											<tr>
												<td width="27%" align="left" bordercolor="FFFFFF" class="style1"><font size="1"><b>Int. Rep.:</b></font></td>
												<td width="73" colspan="3" bordercolor="FFFFFF" class="style1">
												
													<cfselect name="intrep"  class="style1" required="yes">
														<option value="0">Select...</option>
														<cfloop query="internationalagents">
															<option value="#userid#"><cfif len(businessname) gt 30>#Left(businessname,28)#...<cfelse>#businessname#</cfif></option>
														</cfloop>
													</cfselect>												</td>
											</tr>
										<!---ticket 996
											<tr>
												<td align="left" bordercolor="FFFFFF" class="style1"><b>Earliest Arri:</b></td>
												<td class="style1" bordercolor="FFFFFF" colspan="3"><cfinput type="text" name="earliestarrival" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
											</tr>
											<tr>
											  <td align="left" bordercolor="FFFFFF" class="style1"><b>Latest Arri:</b></td>
											  <td class="style1" bordercolor="FFFFFF" colspan="3"><cfinput type="text" name="latestarrival" size="18" maxlength="20" validate="date" message="Latyest Arrival must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></td>
											</tr> ----->
											
											<!---- ticket 1047 ---
											<tr> 
											  <td align="left" bordercolor="FFFFFF" class="style1"><b>Req. Length:</b></td>
											  <td class="style1" bordercolor="FFFFFF" colspan="3">
												
												<cfselect name="wat_length"  class="style1" required="no">
														<option value="">Select....</option>
														<option value="4">4</option>
														<option value="6">6</option>
														<option value="8">8</option>
														<option value="9">9</option>
														<option value="10">10</option>
														<option value="11">11</option>
														<option value="12">12</option>
														<option value="13">13</option>
														<option value="14">14</option>
														<option value="15">15</option>
														<option value="16">16</option>
												</cfselect>
												 weeks
												</td>
											</tr>--------->
											<tr>
											  <td align="left" bordercolor="FFFFFF" class="style1"><font size="1"><b>Option:</b></font></td>
											  <td class="style1" bordercolor="FFFFFF" colspan="3">
												
												<cfselect name="wat_placement" class="style1" required="no">
														<option value="">Select....</option>
														<option value="Self-Placement">Self-Placement</option>
														<option value="CSB-Placement">CSB-Placement</option>
                                                        <option value="Walk-In">Walk-In</option>
												</cfselect>
												
												</td>
											</tr>
											
											<!---- adding Requested placement --->
											
											<tr>
											<td align="left" bordercolor="FFFFFF" class="style1"><font size="1"><b>Requested<font color="FFFFFF">_</font>Placement:</b></font></td>
											  <td class="style1" bordercolor="FFFFFF" colspan="3">

											<Cfquery name="hostcompany" datasource="MySQL">
												SELECT name, hostcompanyid
												FROM extra_hostcompany
												ORDER BY name
											</Cfquery>											
											
																						
												<cfselect name="combo_request">
												<option value=""></option>
													<cfloop query="hostcompany">
												<option value="#hostcompanyid#"> #Left(name, 30)# </option>
													</cfloop>
												</cfselect>
												
												</td>
											</tr>
										
											
											<tr>
												<td bordercolor="FFFFFF" class="style1" align="left"><font size="1">
                                                	<b>Participations<font color="FFFFFF">_</font>in<font color="FFFFFF">_</font>Program:</b></font> 
                                                </td>
                                                <td class="style1" bordercolor="FFFFFF" colspan="3">
                                                    <select name="wat_participation" class="style1">
                                                        <cfloop from="0" to="15" index="i">
                                                            <option value="#i#">#i#</option>                                                    
                                                        </cfloop>
                                                    </select>               
                                                    <font size="1"> times</font>
												</td>
											</tr>
											
											
											<!---- 1047 #3 ---->
											
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="left"><font size="1"><b>Start Date:</b></font></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"> <cfinput type="text" class="datePicker" name="startdate" size=20 maxlength="50" validate="date" message="Start Date of the Program (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font>
								</td>
				</tr>
				<tr>
								<td class="style1" bordercolor="FFFFFF" align="left"><font size="1"><b>End Date:</b></font></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3">
								<cfinput type="text" class="datePicker" name="enddate" size=20 maxlength="50"  validate="date" message="End Date of the Program (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font>
						
								<!--- <cfif get_candidate_unqid.enddate LTE get_candidate_unqid.wat_vacation_date>#get_candidate_unqid.enddate# <cfelse> Date incorrect</cfif> --->
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