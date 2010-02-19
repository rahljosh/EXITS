<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Candidate</title>

<script type="text/JavaScript">
<!--
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].sub+"'");
  if (restore) selObj.selectedIndex=0;
}
//-->
</script>

<!--// load the Client/Server Gateway API //-->
<script language="JavaScript1.2" src="./candidate/lib/gateway.js"></script> 	

<!--// [start] custom JavaScript //-->
<script language="JavaScript"> 	
	<!--// // create the gateway object
	oGateway = new Gateway("./candidate/NewCandidateSelect.cfm", false);
	function init(){ 
		// when the page first loads, grab the Categories and populate the select box
		oGateway.onReceive = updateOptions; 
		// clear option boxes
		document.NewCandidate.listsubcat.length = 1;
		loadOptions("listsubcat");
	}
	function populate(f, a){
		var oField = document.NewCandidate[f];
		oField.options.length = 0;
		for( var i=0; i < a.length; i++ ) oField.options[oField.options.length] = new Option(a[i][0], a[i][1]);
	}
	function loadOptions(f){
		var d = {}, oForm = document.NewCandidate;
		
		if( f == "listsubcat" ){
			document.NewCandidate.listsubcat.length = 1;
		} 
		
		var sfieldstudyid = oForm.fieldstudyid.options[oForm.fieldstudyid.options.selectedIndex].value;
		
		displayLoadMsg(f);
		oGateway.sendPacket({field: f, fieldstudyid: sfieldstudyid});
	}
	function updateOptions(){
		if( this.received == null ) return false; 
		populate(this.received[0], this.received[1]);
		return true;
	}
	function displayLoadMsg(f){
		var oField = document.NewCandidate[f];
		oField.options.length = 0;
		oField.options[oField.options.length] = new Option("Loading data...", "");
	}
	//-->
</script> 	
<!--// [ end ] custom JavaScript //-->

</head>
<body onLoad="init();">

<cftry>

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
						<td class="title1">&nbsp; &nbsp; Adding Candidate </td>
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
												<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>First Name:</b></td>
												<td class="style1" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="firstname" size=32 maxlength="100" required="yes" message="First Name is Required"></td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>Middle Name:</b></td>
												<td class="style1" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="middlename" size=32 maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>Last Name:</b></td>
												<td class="style1" bordercolor="FFFFFF" width="65%"><cfinput type="text" name="lastname" size=32 maxlength="100" required="yes" message="Last Name is Required"></td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>Sex:</b></td>
												<td class="style1" bordercolor="FFFFFF" width="65%">
													<cfinput type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex."> Male
						              <cfinput type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex."> Female 
												</td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>Date of Birth:</b></td>
												<td class="style1" bordercolor="FFFFFF" width="65%"><cfinput type="text" class="date-pick" name="dob" size=15 maxlength="100" validate="date" message="Date of Birth MM/DD/YYYY"> <br/>mm/dd/yyyy</td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>Place of Birth:</b></td>
												<td class="style1" bordercolor="FFFFFF" width="65%"><input type="text" name="birth_city" size=32 maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>Country of Birth:</b></td>
												<td class="style1" bordercolor="FFFFFF">
				
													<cfselect name="birth_country" required="yes" message="You must select a country of birth." class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>
												
												</td>
											</tr>		
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>C. of Citizenship:</b></td>
												<td class="style1" bordercolor="FFFFFF">
												
													<cfselect name="citizen_country" required="yes" message="You must select a country of residence." class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>
												
												</td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>C. Perm. Resid.:</b></td>
												<td class="style1" bordercolor="FFFFFF">
												
													<cfselect name="residence_country" required="yes" message="You must select a country of residence." class="style1">
														<option value="0">Country...</option>
														<cfloop query="countrylist">
															<option value="#countryid#">#countryname#</option>
														</cfloop>
													</cfselect>
												
												</td>
											</tr>
											<tr>				
												<td class="style1" bordercolor="FFFFFF" colspan="2">
				
													<table width="100%" cellpadding=1 cellspacing=2 border=1 bordercolor="C7CFDC" bgcolor="F7F7F7">
														<tr bordercolor="F7F7F7">
															<td colspan="4" class="style1"><b>Mailing Address:</b> <input type="text" name="home_address" size=49 maxlength="200"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="right"><b>City:</b></td>
															<td class="style1"><input type="text" name="home_city" size=11 maxlength="100"></td>
															<td class="style1" align="right"><b>Zip:</b></td>
															<td class="style1"><input type="text" name="home_zip" size=11 maxlength="15"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="right"><b>Country:</b></td>
															<td colspan="3" class="style1">
															
																<cfselect name="home_country"  class="style1">
																	<option value="0">Country...</option>
																	<cfloop query="countrylist">
																	<option value="#countryid#">#countryname#</option>
																	</cfloop>
																</cfselect>		
															
															</td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="right"><b>Phone:</b></td>
															<td class="style1" colspan="3"><input type="text" name="home_phone" size=38 maxlength="50"></td>
														</tr>
														<tr bordercolor="F7F7F7">
															<td class="style1" align="right"><b>Email:</b></td>
															<td class="style1" colspan="3"><input type="text" name="email" size=38 maxlength="100"></td>
														</tr>
													</table>
												
												</td>					
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>English Assessment:</b></td>
												<td class="style1" bordercolor="FFFFFF"><textarea name="personal_info" cols="25" rows="3"></textarea></td>
											</tr>
										</table>
										
									</td>
								</tr>
							</table>
														
							
							<br>
							
							<!--- DEGREE INFORMATION --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Degree Information</td>
											</tr>
											<tr>
												<td width="30%" class="style1" align="right"><b>Degree:</b></td>
												<td class="style1"><input type="text" name="degree" size=34 maxlength="200"></td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>Other Degree:</b></td>
												<td class="style1"><input type="text" name="degree_other" size=34 maxlength="200"></td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>Category:</b></td>
												<td class="style1">
													<select name="fieldstudyid" onChange="loadOptions('listsubcat');">
														<option value="0">Select...</option>
														<cfloop query="fieldstudy">
															<option value="#fieldstudyid#"><cfif len(fieldstudy) GT 33>#Left(fieldstudy,30)#...<cfelse>#fieldstudy#</cfif></option>
														</cfloop>
													</select>
												</td>
											</tr>
											<tr>
											  <td class="style1" align="right"><b>Sub Category:</b></td>
												<td class="style1">
													<select name="listsubcat">
														<option> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
													 </select>
												</td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>Comments/ Evaluation:</b></td>
												<td class="style1"><textarea name="degree_comments" cols="26" rows="3" ></textarea></td>
											</tr>
										</table>	
										
									</td>
								</tr>
							</table>
							
							
						</td>
						<td width="2%" valign="top">&nbsp;</td>
						<td width="49%" valign="top">
						
							
							<!--- EMERGENCY CONTACT --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
											</tr>
											<tr>
												<td width="10" class="style1" align="right"><b>Name:</b></td>
												<td colspan="2" class="style1"><cfinput type="text" name="emergency_name" size=32 maxlength="200"></td>
											</tr>
											<tr>
												<td width="10" class="style1" align="right"><b>Phone:</b></td>
												<td colspan="2" class="style1"><cfinput type="text" name="emergency_phone" size=32 maxlength="50"></td>
											</tr>
											<tr>
												<td width="10" class="style1" align="right"><b>Relationship:</b></td>
												<td colspan="2" class="style1"><cfinput type="text" name="emergency_relationship" size=32 maxlength="50"></td>
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
												<td class="style1" bordercolor="FFFFFF" align="right" width="27%"><b>Program:</b></td>
												<td bordercolor="FFFFFF" width="73%" colspan="3">
													<cfselect name="programid"  class="style1">
														<option value="0">Select....</option>
														<cfloop query="program">
															<option value="#programid#">#programname#</option>
														</cfloop>
													</cfselect>
												</td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>Int. Rep.:</b></td>
												<td class="style1" bordercolor="FFFFFF" colspan="3">
												
													<cfselect name="intrep"  class="style1">
														<option value="0">Select...</option>
														<cfloop query="internationalagents">
															<option value="#userid#"><cfif len(businessname) gt 30>#Left(businessname,28)#...<cfelse>#businessname#</cfif></option>
														</cfloop>
													</cfselect>
														
												</td>
											</tr>	
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>Sponsor:</b></td>
												<td class="style1" bordercolor="FFFFFF" colspan="3">													
													
													<cfselect name="trainee_sponsor"  class="style1">
														<option value="0">Select....</option>
														<option value="ISE">ISE</option>
														<option value="IX">IX</option>
													</cfselect>
														
												</td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>Earliest Arri:</b></td>
												<td class="style1" bordercolor="FFFFFF" colspan="3"><cfinput type="text" name="earliestarrival" size=35 maxlength="35"></td>
											</tr>		
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>Start:</b></td>
												<td class="style1" bordercolor="FFFFFF"><cfinput type="text" class="date-pick" name="startdate" size=10 maxlength="10"  validate="date" message="Start MM/DD/YYYY"><font size="1">mm/dd/yyyy</font></td>
												<td class="style1" bordercolor="FFFFFF" align="right"></td>
												<td class="style1" bordercolor="FFFFFF"></td>
											</tr>	
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>End:</b></td>
												<td class="style1" bordercolor="FFFFFF"><cfinput type="text" class="date-pick" name="enddate" size=10 maxlength="10" validate="date" message="End Date MM/DD/YYYY"><font size="1">mm/dd/yyyy</font></td>
												<td class="style1" bordercolor="FFFFFF" align="right"></td>
												<td class="style1" bordercolor="FFFFFF"></td>
											</tr>
											<tr>
												<td class="style1" bordercolor="FFFFFF" align="right"><b>Remarks:</b></td>
												<td class="style1" bordercolor="FFFFFF" colspan="3"><cftextarea name="remarks" cols="25" rows="3"></cftextarea></td>
											</tr>	
										</table>
														
									</td>
								</tr>
							</table>
							
							<br>
							
			<!----	<!--- INSURANCE INFO --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">		
										
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Insurance</td>
											</tr>
											<tr>
												<td width="5%"><!---<cfif smg_users.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif>---></td>
												<td width="35%" class="style1" align="right"><b>Policy Type:</b></td>
												<td width="60%" class="style1"><!---<cfif smg_users.insurance_typeid EQ '0'>
														<font color="FF0000">Missing Policy Type</font>
													<cfelseif smg_users.insurance_typeid EQ '1'> n/a
													<cfelse> 
													#smg_users.insurance_policy_type#	</cfif>--->	</td>
											</tr>
											<tr>
												<td><!---<Cfif insured_date is ''><input type="checkbox" name="insured_date" disabled><Cfelse><input type="checkbox" name="insured_date" checked disabled></cfif>---></td>
												<td class="style1" align="right"><b>Insured Date:</b></td>
												<td class="style1"><!---<cfif smg_users.insurance_typeid EQ '1'> n/a
													<cfelseif smg_users.insurance_typeid GT '1' AND insurance EQ ''> not insured yet.
													<cfelse> 
														<a href="" class="nav_bar" onClick="javascript: win=window.open('insurance/insurance_history.cfm?candidateid=#candidateid#', 'Settings', 'height=350, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#DateFormat(insu_date, 'mm/dd/yyyy')#</a>
													</cfif>	---></td>
											</tr>
											<tr>
												<td><!---<Cfif cancelinsurancedate is ''><input type="checkbox" name="insurance_Cancel" disabled><Cfelse><input type="checkbox" name="insurance_Cancel" checked disabled></cfif>---></td>
												<td class="style1" align="right"><b>Canceled on:</b></td>
												<td class="style1"><!---<a href="javascript:OpenLetter('insurance/insurance_history.cfm?candidateid=#candidateid#');">#DateFormat(insu_cancel_date, 'mm/dd/yyyy')#</a>---></td>
											</tr>
										</table>
										
									</td>	
								</tr>
							</table>  
							
							<br> 
							
							<!--- PLACEMENT INFORMATION --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Placement Information</td>
											</tr>
											<tr>
												<td width="10" class="style1" align="right"><b>Company:</b></td>
												<td colspan="2" class="style1"><!--- <cfif edit EQ 'no'>#emergency_name#<cfelse><input type="text" name="placement_name" size=32 value="#emergency_name#" maxlength="35"></cfif>---></td>
											</tr>
											<tr>
												<td width="10" class="style1" align="right"><b>Position:</b></td>
												<td colspan="2" class="style1"><!--- <cfif edit EQ 'no'>#emergency_phone#<cfelse><input type="text" name="placement_position" size=32 value="#emergency_phone#" maxlength="35"></cfif>---></td>
											</tr>
										</table>	
										
									</td>
								</tr>
							</table>
							
							<br>
							
							<!----DS2019 Form---->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=3 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Form DS-2019</td>
											</tr>				
											<tr>	
												<td class="style1" align="right"><b>No.:</b></td>
												<td class="style1" colspan="3"><input type="text" name="ds2019" size="12" maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>Position:</b></td>
												<td class="style1"><input type="text" name="ds2019_position" size="12" maxlength="50"></td>
												<td class="style1" align="right"><b>Subject:</b></td>
												<td class="style1"><input type="text" name="ds2019_subject" size="12" maxlength="50"></td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>Street:</b></td>
												<td class="style1"><input type="text" name="ds2019_street" size="12" maxlength="150"></td>
												<td class="style1" align="right"><b>City:</b></td>
												<td class="style1"><input type="text" name="ds2019_city" size="12" maxlength="100"></td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>State:</b></td>
												<td class="style1"><input type="text" name="ds2019_state" size="12" maxlength="12"></td>
												<td class="style1" align="right"><b>Zip:</b></td>
												<td class="style1"><input type="text" name="ds2019_zip" size="12" maxlength="10"></td>
											</tr>
											<tr>
												<td class="style1" align="right"><b>Start:</b></td>
												<td class="style1"><input type="text" name="ds2019_startdate" size="12" maxlength="12"></td>
												<td class="style1" align="right"><b>End:</b></td>
												<td class="style1"><input type="text" name="ds2019_enddate" size="12"  maxlength="12"></td>
											</tr>
										</table>
										
									</td>
								</tr>
							</table>
							
							<br> ---->
							
							<!---DOCUMENTS CONTROL --->
							<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
								<tr>
									<td bordercolor="FFFFFF">
									
										<table width="100%" cellpadding=5 cellspacing=0 border=0>
											<tr bgcolor="##C2D1EF">
												<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
											</tr>
											<tr>
												<td width="46%" class="style1" colspan="2"><cfinput type="checkbox" name="doc_application">  Application</td>
												<td width="54%" class="style1" colspan="2"><cfinput type="checkbox" name="doc_passportphoto">  Passport Photocopy</td>
											</tr>
											<tr>
												<td class="style1" colspan="2"><cfinput type="checkbox" name="doc_resume"> Resume</td>
												<td class="style1" colspan="2"><cfinput type="checkbox" name="doc_insu">  Medical Insurance Appli.</td>
											</tr>
											<tr>
												<td class="style1" colspan="2"><cfinput type="checkbox" name="doc_proficiency"> Proficiency Test</td>
												<td class="style1" colspan="2"><cfinput type="checkbox" name="doc_sponsor_letter"> Home Sponsor Letter</td>
											</tr>
											<tr>
												<td class="style1" colspan="4"><cfinput type="checkbox" name="doc_recom_letter"> Letters of Recommendation</td>
											</tr>
											<tr>
												<td class="style1"> Missing Documents:</td>
												<td class="style1" colspan="3"><cftextarea name="missing_documents" cols="22" rows="3"></cftextarea></td>
											</tr>
										</table>
										
									</td>
								</tr>
							</table>
							
						
						</td>	
					</tr>
				</table>
				
		
				
				</cfform>

				</cfoutput>
	
			</td>
		</tr>
	</table>

<script>
	// place this on the page where you want the gateway to appear
	oGateway.create();
</script>						

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>