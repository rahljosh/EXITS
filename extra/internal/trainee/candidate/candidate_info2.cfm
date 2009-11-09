<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate Info</title>

<!--- <cftry> ---->

<!---- position from wat ---->
<cfparam name="edit" default="no">

<!----<cfif edit NEQ 'no'>--->
<Cfquery name="hostcompany2" datasource="MySQL">
	SELECT name, extra_hostcompany.hostcompanyid, extra_candidates.candidateid, extra_candidates.uniqueid
	FROM extra_hostcompany
	INNER JOIN extra_candidates ON extra_candidates.hostcompanyid = extra_hostcompany.hostcompanyid
	WHERE extra_candidates.uniqueid = '#url.uniqueid#'
</Cfquery>

<cfquery name="get_position" datasource="mysql">
	SELECT extra_jobs.id, extra_jobs.title, extra_jobs.wage, extra_jobs.hours
	FROM extra_jobs
	INNER JOIN extra_candidate_place_company ON extra_candidate_place_company.candcompid = extra_jobs.id
	
	<cfif IsDefined('hostcompanyid')>
	WHERE extra_jobs.hostcompanyid = '#hostcompany2.hostcompanyid#'
	</cfif>
</cfquery>
<!---- /// position from wat---->	

<cfif NOT IsDefined('url.uniqueid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>
	
<cfinclude template="../querys/get_candidate_unqid.cfm">

<cfparam name="edit" default="no">
<cfif isDefined('form.edit') AND client..usertype LTE '4'>
	<cfset edit = '#form.edit#'>
</cfif>

<cfif edit NEQ 'no'>
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
			document.CandidateInfo.listsubcat.length = 1;
			loadOptions("listsubcat");
		}
		function populate(f, a){
			var oField = document.CandidateInfo[f];
			oField.options.length = 0;
			for( var i=0; i < a.length; i++ ) oField.options[oField.options.length] = new Option(a[i][0], a[i][1]);
			/******** Set the value of sub category below  *******/
			var Counter = 0;
			for (i=0; i<document.CandidateInfo.listsubcat.length; i++){
			   if (document.CandidateInfo.listsubcat.options[i].value == <cfoutput>#get_candidate_unqid.subfieldid#</cfoutput>){
				 Counter++;
			   }
			}
			if (Counter == 1){		
			 document.CandidateInfo.listsubcat.value = <cfoutput>#get_candidate_unqid.subfieldid#</cfoutput>;
			}		
		}
		function loadOptions(f){
			var d = {}, oForm = document.CandidateInfo;
			if( f == "listsubcat" ){
				document.CandidateInfo.listsubcat.length = 1;
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
			var oField = document.CandidateInfo[f];
			oField.options.length = 0;
			oField.options[oField.options.length] = new Option("Loading data...", "");
		}
		//-->
	</script> <!--// [ end ] custom JavaScript //-->
</cfif>

<script language="JavaScript"> 
//open program history
function OpenHistory(url) {
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function OpenHistory2(url) {
	newwindow=window.open(url, 'Application', 'height=400, width=750, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
function OpenInsurance(url) {
	newwindow=window.open(url, 'Application', 'height=500, width=800, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
// history
function CheckProgram(currentprogram, currenthost) {
	// PROGRAM HISTORY
   if ((currentprogram > '0') && (document.CandidateInfo.programid.value != currentprogram) && (document.CandidateInfo.reason.value == '')) {
	alert("In order to change the program you must enter a reason (for history purpose).");
	document.getElementById('program_history').style.display = 'inline';
	document.CandidateInfo.reason.focus(); 
	return false; }
	// HOST HISTORY
   if ((currenthost > '0') && (document.CandidateInfo.hostcompanyid.value != currenthost) && (document.CandidateInfo.reason_host.value == '')) {
	alert("In order to change the Host Company you must enter a reason (for history purpose).");
	document.getElementById('host_history').style.display = 'inline';
	document.CandidateInfo.reason_host.focus(); 
	return false; }
}

function cancelation() {
	if (document.CandidateInfo.status.value == '1') {
		document.getElementById('cancelation').style.display = 'none';
		document.getElementById('cancelation2').style.display = 'none';
	}
	if (document.CandidateInfo.status.value == '0') {
		document.getElementById('cancelation').style.display = 'none';
		document.getElementById('cancelation2').style.display = 'none';
	}
	if (document.CandidateInfo.status.value == 'canceled') {
		document.getElementById('cancelation').style.display = '';
		document.getElementById('cancelation2').style.display = '';
	}
}
//-->
</script> 

</head>

<body <cfif edit NEQ 'no'>onLoad="init();"</cfif>>

<!-----Int Rep----->
<Cfquery name="int_reps" datasource="MySQL">
	SELECT userid, firstname, lastname, businessname, country
	FROM smg_users
	WHERE usertype = 8
		AND active = '1'
	ORDER BY businessname
</Cfquery>

<Cfquery name="get_int_rep" datasource="MySQL">
	SELECT u.userid, u.businessname, u.extra_insurance_typeid, type.type
	FROM smg_users u
	LEFT JOIN smg_insurance_type type ON type.insutypeid = u.extra_insurance_typeid
	WHERE u.userid = '#get_candidate_unqid.intrep#'
</Cfquery>

<cfinclude template="../querys/countrylist.cfm">
<cfinclude template="../querys/fieldstudy.cfm">
<cfinclude template="../querys/program.cfm">

<Cfquery name="candidate_place_company" datasource="MySQL">
	SELECT *
	FROM extra_candidate_place_company
	WHERE candidateid = #get_candidate_unqid.candidateid#
	ORDER BY candcompid DESC
</Cfquery>

<Cfquery name="hostcompany" datasource="MySQL">
	SELECT name, hostcompanyid
	FROM extra_hostcompany
	WHERE extra_hostcompany.companyid = 7
	ORDER BY name
</Cfquery>

<cfset currentdate = #now()#>

<!--- candidate does not exist --->
<cfif get_candidate_unqid.recordcount EQ 0>
	The candidate ID you are looking for, <cfoutput>#url.candidateid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
	<tr>
		<td bordercolor="FFFFFF">

			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
				<tr bgcolor="E4E4E4">
					<td class="title1">&nbsp; &nbsp; Candidate Information </td>
				</tr>
			</table>
			<br>

			<cfoutput query="get_candidate_unqid">
			
			<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate" onsubmit="return CheckProgram(#get_candidate_unqid.programid#, #candidate_place_company.hostcompanyid#);">
			<cfinput type="hidden" name="candidateid" value="#get_candidate_unqid.candidateid#">
			<cfinput type="hidden" name="uniqueid" value="#get_candidate_unqid.uniqueid#">
			
			<table width="770" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##ffffff">	
				<tr>
					<td valign="top" width="770" class="box">
					
						<table width="100%" align="Center" cellpadding="2">				
							<tr>
								<td width="135">
								
									<table width="100%" cellpadding="2">
										<tr>
											<td width="135" valign="top">			
												<cfif '#FileExists("/var/www/html/student-management/extra/internal/uploadedfiles/web-candidates/#candidateid#.#get_candidate_unqid.picture_type#")#'>
													<img src="../uploadedfiles/web-candidates/#candidateid#.#get_candidate_unqid.picture_type#" width="135" /><br>
													<a  class="style4Big" href="" onClick="javascript: win=window.open('candidate/upload_picture.cfm?uniqueid=#uniqueid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><b><center>Change Picture</center></b></a>
												<cfelse>
													<a class=nav_bar href="" onClick="javascript: win=window.open('candidate/upload_picture.cfm?uniqueid=#uniqueid#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/no_logo.jpg" width="135" border=0></a>
												</cfif>						
											</td>
										</tr>
									</table>
									
								</td>
								<td valign="top">
								
									<cfif edit EQ 'no'>
										
										<table width="100%" cellpadding="2">
											<tr>
												<td align="center" colspan="2" class="title1">#firstname# #middlename# #lastname# (###candidateid#)</td>
											</tr>
											<tr>
												<td align="center" colspan="2"><span class="style4">[ <a href='candidate/candidate_profile.cfm?uniqueid=#get_candidate_unqid.uniqueid#' target="_blank"><span class="style4">profile</span></a> ]</span></td>
											</tr>
											<tr>
												<td align="center" colspan="2" class="style1"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old</cfif> - <cfif sex EQ 'm'>Male<cfelse>Female</cfif></td>
											</tr> 
											<tr>
												<td width="18%" align="right" class="style1"><b>Intl. Rep.:</b></td>
												<td width="82%" class="style1"><select name="intrep" <cfif edit EQ 'no'>disabled</cfif> >
													<option value="0"></option>		
													<cfloop query="int_Reps">
														<option value="#userid#" <cfif userid EQ get_candidate_unqid.intrep> selected </cfif>><cfif #len(businessname)# gt 45>#Left(businessname, 42)#...<cfelse>#businessname#</cfif></option>
													</cfloop>
													</select>
											  </td>
											</tr>
											<tr>
												<td width="18%" align="right" class="style1"><b>Sponsor:</b></td>
												<td width="82%" class="style1">#trainee_sponsor#
											  </td>
											</tr>
											<tr>
												<td align="right" class="style1"><b>Date of Entry: </b></td>
												<td class="style1">#DateFormat(entrydate, 'mm/dd/yyyy')#</td>
											</tr>
											<tr>
												<td align="right"><!---- <input type="checkbox" name="active" <cfif active EQ 1>checked="Yes"</cfif> <cfif edit EQ 'no'>disabled</cfif>> ----></td>
												<td class="style1">Candidate is <b><cfif status EQ '1'>ACTIVE</cfif> <cfif status EQ '0'>INACTIVE</cfif> <cfif status EQ 'canceled'>CANCELED</cfif> </b></td>
											</tr>													
										</table>
									
									<cfelse>
								
										<table width="100%" cellpadding="2">
											<tr>
												<td align="right" class="style1"><b>First Name:</b></td>
												<td><cfinput type="text" name="firstname" class="style1" size=32 value="#firstname#" maxlength="200" required="yes"></td>
											</tr>
											<tr>
												<td align="right" class="style1"><b>Middle Name:</b> </td>
												<td><cfinput type="text" name="middlename" class="style1" size=32 value="#middlename#" maxlength="200"></td>
											<tr>
												<td align="right" class="style1"><b>Last Name:</b> </td>
												<td><cfinput type="text" name="lastname" class="style1" size=32 value="#lastname#" maxlength="200" required="yes"></td>
											</tr>
											<tr>
												<td align="center" class="style1"><b>Date of Birth:</b></td>
												<td class="style1"><cfinput type="text" name="dob" class="style1" size=12 value="#dateformat (dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)" required="yes">&nbsp; <b>Sex:</b> <span class="style1">
													<input type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex." <cfif sex Eq 'M'>checked="checked"</cfif>>Male &nbsp; &nbsp;
												  <input type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex." <cfif sex Eq 'F'>checked="checked"</cfif>>Female </span></td>
											</tr> 
											<tr>
												<td width="18%" align="right" class="style1"><b>Intl. Rep.:</b></td>
												<td width="82%" class="style1"><select name="intrep" class="style1" <cfif edit EQ 'no'>disabled</cfif> >
													<option value="0"></option>		
													<cfloop query="int_Reps">
														<option value="#userid#" <cfif userid EQ get_candidate_unqid.intrep> selected </cfif>><cfif #len(businessname)# gt 45>#Left(businessname, 42)#...<cfelse>#businessname#</cfif></option>
													</cfloop>
													</select>
											  </td>
											</tr>
											<tr>
												<td width="18%" align="right" class="style1"><b>Sponsor:</b></td>
												<td width="82%" class="style1"><select name="trainee_sponsor" class="style1" >
												<option value="0"></option>
												<option value="ISE" <cfif get_candidate_unqid.trainee_sponsor Eq 'ISE'>selected="selected"</cfif>>ISE</option>
												<option value="IX" <cfif get_candidate_unqid.trainee_sponsor Eq 'IX'>selected="selected"</cfif>>IX</option>
												</select>
											  </td>
											</tr>
											<tr>
											<tr>
												<td align="right" class="style1"><b>Date of Entry: </b></td>
												<td class="style1">#DateFormat(entrydate, 'mm/dd/yyyy')#</td>
											</tr>												
											<tr>
												<td align="right"><!---- <input type="checkbox" name="active" <cfif active EQ 1>checked="Yes"</cfif> <cfif edit EQ 'no'>disabled</cfif>> ----></td>
												<td class="style1">Status: </b>
												  <select id="status" name="status" <cfif get_candidate_unqid.status NEq 'canceled'> onchange="javascript:cancelation();" </cfif> >
													<option value="1" <cfif get_candidate_unqid.status Eq '1'>selected="selected"</cfif>>active</option>
													<option value="0" <cfif get_candidate_unqid.status Eq '0'>selected="selected"</cfif>>inactive</option>
													<option value="canceled" <cfif get_candidate_unqid.status Eq 'canceled'>selected="selected"</cfif>>cancel</option>
												  </select>
												</td>
											</tr>													
										</table>
									
									</cfif>
									
																	
								</td>
							</tr>
					  </table>
						
					</td>	
				</tr>
			</table>
			
			<br>
			
			<table width="770" border=0 cellpadding=0 cellspacing=0 align="center">	
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
											<td class="style1" bordercolor="FFFFFF" width="35%" align="right"><b>Place of Birth:</b></td>
											<td class="style1" bordercolor="FFFFFF" width="65%"><cfif edit EQ 'no'>#birth_city#<cfelse><cfinput type="text" class="style1" name="birth_city" size=32 value="#birth_city#" maxlength="100"></cfif></td>
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>Country of Birth:</b></td>
											<td class="style1" bordercolor="FFFFFF">
			
												<cfif edit EQ 'no'>
													<cfloop query="countrylist">
														<cfif countryid EQ get_candidate_unqid.birth_country> #countryname#</cfif></option>
													</cfloop>
												<cfelse>
													<select name="birth_country" class="style1" <cfif edit EQ 'no'>disabled</cfif>  >
													<option value="0"></option>		
													<cfloop query="countrylist">
														<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.birth_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
													</cfloop>
													</select>
												</cfif>
											
											</td>
										</tr>		
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>C. of Citizenship:</b></td>
											<td class="style1" bordercolor="FFFFFF">
											
												<cfif edit EQ 'no'>
													<cfloop query="countrylist">
														<cfif countryid EQ get_candidate_unqid.citizen_country> #countryname#</cfif></option>
													</cfloop>
												<cfelse>
													<select name="citizen_country" class="style1" <cfif edit EQ 'no'>disabled</cfif>  >
													<option value="0"></option>		
													<cfloop query="countrylist">
														<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.citizen_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
													</cfloop>
													</select>
												</cfif>
											
											</td>
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>C. Perm. Resid.:</b></td>
											<td class="style1" bordercolor="FFFFFF">
											
												<cfif edit EQ 'no'>
													<cfloop query="countrylist">
														<cfif countryid EQ get_candidate_unqid.residence_country> #countryname#</cfif></option>
													</cfloop>
												<cfelse>
													<select name="residence_country" class="style1" <cfif edit EQ 'no'>disabled</cfif>  >
													<option value="0"></option>		
													<cfloop query="countrylist">
														<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.residence_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
													</cfloop>
													</select>			
												</cfif>
											
											</td>
										</tr>
										<tr>				
											<td class="style1" bordercolor="FFFFFF" colspan="2">
			
												<table width="100%" cellpadding=1 cellspacing=2 border=1 bordercolor="C7CFDC" bgcolor="F7F7F7">
													<tr bordercolor="F7F7F7">
														<td colspan="4" class="style1"><b>Mailing Address:</b> <cfif edit EQ 'no'>#home_address#<cfelse><cfinput type="text" class="style1" name="home_address" size=49 value="#home_address#" maxlength="200"></cfif></td>
													</tr>
													<tr bordercolor="F7F7F7">
														<td class="style1" align="right"><b>City:</b></td>
														<td class="style1"><cfif edit EQ 'no'>#home_city#<cfelse><cfinput type="text" class="style1" name="home_city" size=11 value="#home_city#" maxlength="100"></cfif></td>
														<td class="style1" align="right"><b>Zip:</b></td>
														<td class="style1"><cfif edit EQ 'no'>#home_zip#<cfelse><cfinput type="text" class="style1" name="home_zip" size=11 value="#home_zip#" maxlength="15"></cfif></td>
													</tr>
													<tr bordercolor="F7F7F7">
														<td class="style1" align="right"><b>Country:</b></td>
														<td colspan="3" class="style1">
														
															<cfif edit EQ 'no'>
																<cfloop query="countrylist">
																	<cfif countryid EQ get_candidate_unqid.home_country> #countryname#</cfif></option>
																</cfloop>
															<cfelse>
																<select name="home_country" class="style1" <cfif edit EQ 'no'>disabled</cfif>  >
																<option value="0"></option>		
																<cfloop query="countrylist">
																	<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.home_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
																</cfloop>
																</select>
															</cfif>
														
														</td>
													</tr>
													<tr bordercolor="F7F7F7">
														<td class="style1" align="right"><b>Phone:</b></td>
														<td class="style1" colspan="3"><cfif edit EQ 'no'>#home_phone#<cfelse><cfinput type="text" class="style1" name="home_phone" size=38 value="#home_phone#" maxlength="50"></cfif></td>
													</tr>
													<tr bordercolor="F7F7F7">
														<td class="style1" align="right"><b>Email:</b></td>
														<td class="style1" colspan="3"><cfif edit EQ 'no'>#email#<cfelse><cfinput type="text" class="style1" name="email" size=38 value="#email#" maxlength="100"></cfif></td>
													</tr>
												</table>
											
											</td>					
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>Personal Info./ Preferences:</b></td>
											<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#personal_info#<cfelse><cftextarea name="personal_info" class="style1" cols="25" rows="3">#personal_info#</cftextarea></cfif></td>
										</tr>
									</table>
													
								</td>
							</tr>
						</table>
						
						<br>
						
						<!--- EMERGENCY CONTACT --->
						<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
								
									<table width="100%" cellpadding=5 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
										</tr>
										<tr>
											<td width="15%" class="style1" align="right"><b>Name:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#emergency_name#<cfelse><cfinput type="text" class="style1" name="emergency_name" size=32 value="#emergency_name#" maxlength="200"></cfif></td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>Phone:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#emergency_phone#<cfelse><cfinput type="text" class="style1" name="emergency_phone" size=32 value="#emergency_phone#" maxlength="50"></cfif></td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>Relationship:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#emergency_relationship#<cfelse><cfinput type="text" class="style1" name="emergency_relationship" size=32 value="#emergency_relationship#" maxlength="50"></cfif></td>
										</tr>
									</table>	
									
								</td>
							</tr>
						</table>
						
						<br>
						
						<!--- LETTERS --->
						<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
								
									<table width="100%" cellpadding=5 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Letters</td>
										</tr>
										<tr>
											<td width="15%" class="style4" colspan="2" align="center"><a href='reports/enrollment_confirmation.cfm?uniqueid=#get_candidate_unqid.uniqueid#' class="style4Big", target="_blank"><b>Enrollment Confirmation</b></a></td>
											<tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/SevisFeeLetter.cfm?uniqueid=#get_candidate_unqid.uniqueid#' class="style4Big", target="_blank"><b>Sevis Fee Instruction Letter</b></a></td>
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
											<td width="30%" align="right" valign="top" class="style1"><b>Degree:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#degree#<cfelse><cfinput type="text" class="style1" name="degree" size=34 value="#degree#" maxlength="200"></cfif></td>
										</tr>
										<tr>
											<td class="style1" align="right" valign="top"><b>Other Degree:</b></td>
											<td class="style1">
												<cfif edit EQ 'no'>
												   <cfif #degree_other# eq ''> n/a <cfelse>
													 #degree_other#
													</cfif>
												<cfelse>
													<cfinput type="text" class="style1" name="degree_other" size=34 value="#degree_other#" maxlength="200">
												</cfif></td>
										</tr>							
										<tr>
											<td class="style1" valign="top" align="right"><b>Category:</b></td>
											<td class="style1">
												<cfif edit EQ 'no'>
													<cfif 'getCategory.recordcount' eq 0>n/a <cfelse>
													<cfquery name="getCategory" datasource="MySql">
														SELECT DISTINCT fieldstudy
														FROM extra_sevis_fieldstudy
														WHERE fieldstudyid = '#get_candidate_unqid.fieldstudyid#'
													</cfquery>
													#getCategory.fieldstudy# </cfif>
												<cfelse>
													<select name="fieldstudyid" class="style1" onChange="loadOptions('listsubcat');">
														<option value="0">Select...</option>
														<cfloop query="fieldstudy">
															<option value="#fieldstudyid#" <cfif fieldstudyid EQ get_candidate_unqid.fieldstudyid>selected</cfif>><cfif len(fieldstudy) GT 35>#Left(fieldstudy,30)#...<cfelse>#fieldstudy#</cfif></option>
														</cfloop>
													</select>
												</cfif>
											</td>
										</tr>
										<tr>
										  <td class="style1" valign="top" align="right"><b>Sub Category:</b></td>
											<td class="style1">
												<cfif edit EQ 'no'>
													<cfif 'getSubCategory' eq 0>n/a <cfelse>
													<cfquery name="getSubCategory" datasource="MySql">
														SELECT DISTINCT subfield
														FROM extra_sevis_sub_fieldstudy
														WHERE subfieldid = '#get_candidate_unqid.subfieldid#'
													</cfquery>
													#getSubCategory.subfield#</cfif>
												<cfelse>
													<select name="listsubcat" class="style1">
														<option> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
														<option></option><option></option><option></option><option></option><option></option><option></option>
													 </select>
												 </cfif>
											</td>
										</tr>
										<tr>
											<td class="style1" valign="top" align="right"><b>Comments/ Evaluation:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#degree_comments#<cfelse><cftextarea name="degree_comments" class="style1" cols="26" rows="3" >#degree_comments#</cftextarea></cfif></td>
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
											<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
										</tr>
										<tr>
											<td width="46%" class="style1" colspan="2"><Cfif #doc_application# Eq '0'><input type="checkbox" name="doc_application" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_application" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Application</td>
											<td width="54%" class="style1" colspan="2"><Cfif #doc_passportphoto# Eq '0'><input type="checkbox" name="doc_passportphoto" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_passportphoto" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Passport Photocopy</td>
										</tr>
										<tr>
											<td class="style1" colspan="2"><Cfif #doc_resume# Eq '0'><input type="checkbox" name="doc_resume" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_resume" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Resume</td>
											<td class="style1" colspan="2"><Cfif #doc_insu# Eq '0'><input type="checkbox" name="doc_insu" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_insu" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Medical Insurance Appli.</td>
										</tr>
										<tr>
											<td class="style1" colspan="2"><Cfif #doc_proficiency# Eq '0'><input type="checkbox" name="doc_proficiency" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_proficiency" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Proficiency Verification</td>
											<td class="style1" colspan="2"><Cfif #doc_sponsor_letter# Eq '0'><input type="checkbox" name="doc_sponsor_letter" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_sponsor_letter" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Home Sponsor Letter</td>
										</tr>
										<tr>
											<td class="style1" colspan="4"><Cfif #doc_recom_letter# Eq '0'><input type="checkbox" name="doc_recom_letter" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_recom_letter" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Letters of Recommendation</td>
										</tr>
										<tr>
											<td class="style1"> Missing Documents:</td>
											<td class="style1" colspan="3"><cfif edit EQ 'no'>#missing_documents#<cfelse><textarea name="missing_documents" class="style1" cols="25" rows="3">#missing_documents#</textarea></cfif></td>
										</tr>
									</table>
									
								</td>
							</tr>
						</table>
						
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td width="49%" valign="top">
					
					
						<!--- CANCELATION --->
						<table id="cancelation" cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">
								
									<table width="100%" cellpadding=5 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Cancelation	</td>
										</tr>
										<tr>
											<!---- <td width="20">
												<Cfif #DateFormat(cancel_date, 'mm/dd/yyyy')# is ''> 
													<input name="cancel_date_check" type="checkbox" <cfif edit EQ 'no'>disabled="disabled"</cfif>> 
												<cfelse> 
													<input type="checkbox" name="cancel_date_check" checked="checked" <cfif edit EQ 'no'> disabled="disabled" </cfif>> 
												</Cfif>
										  </td> ---->
										  	<td class="style1" bordercolor="FFFFFF" align="right" valign="top"><b>Date:</b></td>
											<td class="style1" width="85%"><cfif edit EQ 'no'>#DateFormat(cancel_date, 'mm/dd/yyyy')#<cfelse><input type="text" class="style1" name="cancel_date" size=20 value="#DateFormat(cancel_date, 'mm/dd/yyyy')#"></cfif></td>
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right" valign="top"><b>Reason:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#cancel_reason# <cfelse><input type="text" class="style1" name="cancel_reason" size=40 value="#cancel_reason#"></cfif></td>								
										</tr>
									</table>
									
								</td>
							</tr>
						</table>
						
						<table id="cancelation2" cellpadding="0" border="0" cellspacing="0">
							<tr>
								<td>&nbsp;
								</td>
							</tr>
						</table>
					
						<!--- HOST COMPANY INFO --->
						<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF" valign="top">
								
									<table width="100%" cellpadding=5 cellspacing=0 border=0>
										<tr bgcolor="C2D1EF">
											<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Host Company Information [<a href="javascript:OpenHistory2('candidate/candidate_host_history.cfm?unqid=#uniqueid#');"><font class="style3" color="FFFFFF"> History </font></a> ]</span></td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>Company Name:</b></td>
											<td class="style1">
												<cfif edit EQ 'no'>
													<cfloop query="hostcompany">
														<a href="?curdoc=hostcompany/hostcompany_profile&hostcompanyid=#candidate_place_company.hostcompanyid#" class="style4"><cfif hostcompany.hostcompanyid EQ candidate_place_company.hostcompanyid><b>#name#</b></cfif></a>
													</cfloop>
												<cfelse>
												
												<select name="hostcompanyid"  class="style1">
														<cfloop query="hostcompany">
														<cfif hostcompany.hostcompanyid EQ candidate_place_company.hostcompanyid><option value="#hostcompanyid#" selected><cfif #len(name)# gt 30>#Left(name, 28)#...<cfelse>#name#</cfif></option><cfelse>
														<option value="#hostcompanyid#"><cfif #len(name)# gt 30>#Left(name, 28)#...<cfelse>#name#</cfif></option></cfif>
														</cfloop>
												</select>
												
												</cfif>
											</td>
										</tr>
										<tr id="host_history" bgcolor="FFBD9D">
											<td class="style1" align="right"><b>Reason:</b></td>
											<td class="style1"><input type="text" class="style1" size="20" name="reason_host"></td>
										</tr>
									
											<!---- position from wat ---->
											<cfquery name="get_extrajobs" datasource="mysql">
												SELECT id, title, extra_jobs.hostcompanyid, wage, low_wage, wage_type, hours, extra_hostcompany.name
												FROM extra_jobs
												INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_jobs.hostcompanyid
												INNER  JOIN extra_candidate_place_company ON extra_candidate_place_company.jobid = extra_jobs.id
												WHERE status = 1 
												AND candidateid = #get_candidate_unqid.candidateid#
											</cfquery>
			
											<input type="hidden" name="currentjob" value=#candidate_place_company.jobid#>
											<input type="hidden" name="currentjobid" value=#candidate_place_company.candcompid#>
			
										<tr>
											<td class="style1" align="right"><b>Position:</b> </td>
											<td class="style1">
											
											<cfquery name="get_position" datasource="mysql">
												SELECT extra_jobs.id, extra_jobs.title, extra_jobs.wage, extra_jobs.hours
												FROM extra_jobs
												<cfif candidate_place_company.hostcompanyid GT 0> 
												LEFT JOIN extra_candidate_place_company cpc  on cpc.hostcompanyid = extra_jobs.hostcompanyid
												WHERE extra_jobs.hostcompanyid = #candidate_place_company.hostcompanyid#
													and cpc.candidateid = #get_candidate_unqid.candidateid# and status = 1
												</cfif>
											</cfquery>
											
											<cfif edit EQ 'no'>#get_extrajobs.title# <cfelse> 
			
											<!----<cfif form.hostcompanyid_combo is NOT 0>--->
											<cfif 'hostcompany2.recordcount' NEQ 0>
											<select name="combo_position"  class="style1">
												<option value=0></option>
														<cfloop query="get_position">	
														<cfif get_position.id EQ candidate_place_company.jobid><option value="#id#" selected>#title# </option><cfelse>
														<option value="#id#">#title#</option></cfif>
														</cfloop>
												</select>
			
											 </cfif></cfif>	 
											</td>
										</tr>
										
									 <!---- // close position from wat --->			
										
										<tr>
											<td width="35%" class="style1" align="right"><b>Status:</b></td>
											<td class="style1"><cfif edit EQ 'no'><cfif candidate_place_company.status EQ '1'>Active</cfif><cfif candidate_place_company.status EQ '0'>Inactive</cfif>
											<cfelse>
												<input type="radio" name="hostcompany_status" value="1" <cfif candidate_place_company.status EQ '1'>checked="yes" </cfif>>
												Active&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="radio" name="hostcompany_status" value="0" <cfif candidate_place_company.status EQ '0'>checked="yes" </cfif>>
												Inactive
											</cfif></td>
										</tr>
											<cfif edit EQ 'no'>
										<tr>
											<td colspan="2" class="style1" align="left"><b>Placement Date:</b> #dateformat (candidate_place_company.placement_date, 'mm/dd/yyyy')#</td>
										</tr>
											</cfif>
										<tr>
											<td class="style1" align="right"><b>Start Date:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="host_startdate" class="style1" size=30 value="#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')#" maxlength="50"></cfif></td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>End Date:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="host_enddate" class="style1" size=30 value="#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#" maxlength="50"></cfif></td>
										</tr>
										<tr>
											<td colspan="2" class="style1" align="left"><b>Confirmation Received:</b> <cfif edit EQ 'no'><cfif candidate_place_company.confirmation_received EQ '1'>Yes</cfif><cfif candidate_place_company.confirmation_received EQ '0'>No</cfif>
											<cfelse>
												<input type="radio" name="confirmation_received" value="1" <cfif candidate_place_company.confirmation_received EQ '1'>checked="yes" </cfif>>
												Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="radio" name="confirmation_received" value="0" <cfif candidate_place_company.confirmation_received EQ '0'>checked="yes" </cfif>>
												No
											</cfif>
											</td>
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
											<td class="style2" bgcolor="8FB6C9" colspan="4">&nbsp;:: Program Information &nbsp;  [<a href="javascript:OpenHistory('candidate/candidate_program_history.cfm?unqid=#uniqueid#');"><font class="style3" color="FFFFFF"> History </font></a> ]</span></td>
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right" width="27%"><b>Program:</b></td>
											<td bordercolor="FFFFFF" width="73%" colspan="3">
													<select name="programid" class="style1" <cfif edit EQ 'no'>disabled</cfif>>
													<option value="0">Unassigned</option>
													<cfloop query="program">
													<cfif get_candidate_unqid.programid EQ programid><option value="#programid#" selected>#programname#</option><cfelse>
													<option value="#programid#">#programname#</option></cfif>
													</cfloop>
													</select>
												
											</td>
										</tr>
										<tr id="program_history" bgcolor="FFBD9D">
											<td class="style1" align="right"><b>Reason:</b></td>
											<td class="style1" colspan="3"><cfinput type="text" class="style1" size="35" name="reason"></td>
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>Earliest Arri:</b></td>
											<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#dateformat (earliestarrival, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="earliestarrival" size=35 value="#dateformat (earliestarrival, 'mm/dd/yyyy')#" maxlength="35"  validate="date" message="Earlisest Arrival (MM/DD/YYYY)"></cfif></td>
										</tr>		
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>Start:</b></td>
											<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#dateformat (startdate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="startdate" size=10 value="#dateformat (startdate, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Start Date (MM/DD/YYYY)"></cfif></td>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>End:</b></td>
											<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#dateformat (enddate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="enddate" size=10 value="#dateformat (enddate, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="End Date(MM/DD/YYYY)"></cfif></td>
										</tr>
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>Arrival Date:</b></td>
											<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#dateformat (arrivaldate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="arrivaldate" size=35 value="#dateformat (arrivaldate, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Arrival Date(MM/DD/YYYY)"></cfif></td>
										</tr>	
										<tr>
											<td class="style1" bordercolor="FFFFFF" align="right"><b>Remarks:</b></td>
											<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#remarks#<cfelse><cftextarea name="remarks" class="style1" cols="25" rows="3">#remarks#</cftextarea></cfif></td>
										</tr>	
									</table>
													
								</td>
							</tr>
						</table>
						
						<br>
					
						<!--- INSURANCE INFO --->
						<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
							<tr>
								<td bordercolor="FFFFFF">		
									
									<table width="100%" cellpadding=5 cellspacing=0 border=0>
										<tr bgcolor="##C2D1EF">
											<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Insurance &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; [ <a href="javascript:OpenInsurance('insurance/insurance_mgmt.cfm?uniqueid=#uniqueid#');"><font class="style2" color="FFFFFF">Insurance Management</font></a> ]</td>
										</tr>
										<tr>
										  <td width="2%"><cfif get_int_rep.extra_insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
											<td width="30%" class="style1" align="right"><b>Policy Type:</b></td>
											<td width="68%" class="style1"><cfif get_int_rep.extra_insurance_typeid EQ 0><font color="FF0000">Missing Policy Type</font><cfelse>#get_int_rep.type#</cfif></td>
										</tr>
										<tr>
											<td><cfif insurance_date EQ ''><input type="checkbox" name="insurance_date" disabled><Cfelse><input type="checkbox" name="insurance_date" checked disabled></cfif></td>
											<td class="style1" align="right"><b>Filed Date:</b></td>
											<td class="style1">
												<cfif get_int_rep.extra_insurance_typeid GT '1' AND insurance_date EQ ''>
													not insured yet
												<cfelseif insurance_date NEQ ''>
													#DateFormat(insurance_date, 'mm/dd/yyyy')#
												<cfelse>
													n/a
												</cfif>
											</td>
										</tr>
										<tr>
											<td><cfif insurance_cancel_date EQ ''><input type="checkbox" name="insurance_Cancel" disabled="disabled"><Cfelse><input type="checkbox" name="insurance_Cancel" checked="checked" disabled="disabled"></cfif></td>
											<td class="style1" align="right"><b>Cancel Date:</b></td>
											<td class="style1">#DateFormat(insurance_cancel_date, 'mm/dd/yyyy')#</td>
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
										<tr bgcolor="C2D1EF">
											<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Form DS-2019</td>
										</tr>				
										<tr>	
											<td width="10%" align="right" class="style1"><b>No.:</b></td>
											<td class="style1" colspan="3"><cfif edit EQ 'no'>#ds2019#<cfelse><cfinput type="text" class="style1" name="ds2019" size=12 value="#ds2019#" maxlength="100"></cfif></td>
										</tr>
									
										<!---- 1054 add combo Subject/Field --->
										<cfquery name="get_subfield" datasource="mysql">
											SELECT code, subfield <!---, extra_candidates.candidateid, extra_candidates.ds2019_subject--->
											FROM extra_sevis_sub_fieldstudy
											<cfif edit EQ 'no'>
												INNER JOIN extra_candidates ON extra_candidates.ds2019_subject = extra_sevis_sub_fieldstudy.code
												WHERE extra_candidates.candidateid = #get_candidate_unqid.candidateid#					
											</cfif>
										</cfquery>
										
										<cfquery name="get_candidate_subject" datasource="mysql">
											SELECT candidateid, ds2019_subject
											FROM extra_candidates
											WHERE extra_candidates.candidateid = #get_candidate_unqid.candidateid#
										</cfquery>
										
										<tr>
											<td class="style1" align="right"><b>Subject/Field:</b></td>
											<td class="style1" colspan="3" >
												<cfif edit EQ 'no'>
												#left(get_subfield.subfield,45)# - #get_subfield.code#
												<cfelse>
											
												<select name="combo_subfield" class="style1" >
														<option value=0></option>
														<cfloop query="get_subfield">	
														<option value="#code#" <cfif get_subfield.code EQ get_candidate_subject.ds2019_subject>selected</cfif>>#code# <cfif len(subfield) GT 27>#Left(subfield,25)#...<cfelse>#subfield#</cfif> </option>
														
														</cfloop>
												</select>
												</cfif>											</td>
										</tr>
										<tr>
											<td class="style1" align="right"><b>Street:</b></td>
											<td colspan="3" class="style1"><cfif edit EQ 'no'>#ds2019_street#<cfelse><cfinput type="text" class="style1" name="ds2019_street" size=50 value="#ds2019_street#" maxlength="150"></cfif></td>
										</tr>
										<tr>
										  <td class="style1" align="right"><b>City:</b></td>
										  <td class="style1"><cfif edit EQ 'no'>
										    #ds2019_city#
										        <cfelse>
										    <cfinput class="style1" type="text" name="ds2019_city" size=20 value="#ds2019_city#" maxlength="100">
										    </cfif></td>
											<td align="right" class="style1"><b>Zip:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#ds2019_zip#<cfelse><cfinput type="text" class="style1" name="ds2019_zip" size=12 value="#ds2019_zip#" maxlength="10"></cfif></td>
										</tr>
										<tr>
										  <td align="right" class="style1"><b>State:</b></td>
										  <td class="style1"><cfif edit EQ 'no'>
										    #ds2019_state#
										        <cfelse>
										    <cfinput type="text" class="style1" name="ds2019_state" size=12 value="#ds2019_state#" maxlength="12">
										    </cfif></td>
									      <td align="right" class="style1">&nbsp;</td>
									      <td class="style1">&nbsp;</td>
									  </tr>
										<tr>
										  <td align="right" class="style1"><b>Home Phone:</b></td>
										  <td class="style1"><cfif edit EQ 'no'>
										    #ds2019_phone#
										    <cfelse>
        									<cfinput type="text" class="style1" name="ds2019_phone" size=20 value="#ds2019_phone#" maxlength="12">
                                          </cfif></td>
										  <td align="right" class="style1"><b>Cell.:</b></td>
										  <td class="style1"><cfif edit EQ 'no'>
										    #ds2019_cell#
										    <cfelse>
        									<cfinput type="text" class="style1" name="ds2019_cell" size=20 value="#ds2019_cell#" maxlength="12">
                                          </cfif></td>
									  </tr>
										<tr>
											<td class="style1" align="right"><b>Start:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#DateFormat(ds2019_startdate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="ds2019_startdate" size=20 value="#DateFormat(ds2019_startdate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 Start Date (MM/DD/YYYY)"></cfif></td>
											<td class="style1" align="right"><b>End:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#DateFormat(ds2019_enddate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="ds2019_enddate" size=20 value="#DateFormat(ds2019_enddate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 End Date(MM/DD/YYYY)"></cfif></td>
										</tr>
									</table>
									
								</td>
							</tr>
						</table>
			
					</td>	
				</tr>
			</table>
			
			<br>
			
			<!--- UPDATE BUTTON --->
			<cfif edit NEQ 'no'>
			<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
				<tr><td align="center"><cfinput name="Submit" type="image" src="../pics/update.gif" alt="Update Profile" border=0></td></tr>
			</table>
			</cfif>
			</cfform>
					
			<cfif edit NEQ 'no'>
				<script>
					// place this on the page where you want the gateway to appear
					oGateway.create();
				</script>
			</cfif>							
					
			<script language="javascript">
				// hide field reason (changing program)
				document.getElementById('program_history').style.display = 'none';
				document.getElementById('host_history').style.display = 'none';
			</script>	
			
			<cfif get_candidate_unqid.status NEq 'canceled'>
				<script language="javascript">
					document.getElementById('cancelation').style.display = 'none';
					document.getElementById('cancelation2').style.display = 'none';
				</script>
			</cfif>
					
			<!---- EDIT BUTTON - OFFICE USERS  ---->
			<cfif client..usertype LTE '4' AND edit EQ 'no'>
			<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
				<tr>
					<td align="center">
						<cfform action="" method="post">&nbsp;
							<cfinput type="hidden" name="edit" value="yes">
							<cfinput name="Submit" type="image" src="../pics/edit.gif" alt="Edit" border=0>
						</cfform>
					</td>
				</tr>
			</table>
			</cfif>
			
			</cfoutput>

		</td>
	</tr>
</table>

<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch> 

</cftry>
--->

</body>
</html>