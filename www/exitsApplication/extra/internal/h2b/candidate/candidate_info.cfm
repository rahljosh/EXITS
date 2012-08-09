<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate Info</title>


</head>
<body>

<!--- <cftry>---->

<cfparam name="edit" default="no">
<!----<cfif edit NEQ 'no'>--->
<Cfquery name="hostcompany2" datasource="MySQL">
	SELECT name, extra_hostcompany.hostcompanyid, extra_candidates.candidateid, extra_candidates.uniqueid
	FROM extra_hostcompany
	INNER JOIN extra_candidates ON extra_candidates.hostcompanyid = extra_hostcompany.hostcompanyid
<cfif edit NEQ 'no'>
	WHERE extra_candidates.uniqueid = '#url.uniqueid#'
	AND extra_hostcompany.companyid = 9
</cfif>
</Cfquery>

<cfquery name="get_position" datasource="mysql">
	SELECT extra_jobs.id, extra_jobs.title, extra_jobs.wage, extra_jobs.hours
	FROM extra_jobs
	INNER JOIN extra_candidate_place_company ON extra_candidate_place_company.candcompid = extra_jobs.id
	<cfif IsDefined('hostcompanyid')>
	WHERE extra_jobs.hostcompanyid = '#hostcompany2.hostcompanyid#'
	</cfif>
</cfquery>
	
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
</script> 	<!--// [ end ] custom JavaScript //-->

<cfif NOT IsDefined('url.uniqueid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_candidate_unqid.cfm">
<cfinclude template="../querys/countrylist.cfm">
<cfinclude template="../querys/fieldstudy.cfm">
<cfinclude template="../querys/program.cfm">

<!-----Int Rep----->
<Cfquery name="int_Reps" datasource="MySQL">
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

<Cfquery name="categories" datasource="MySQL">
	SELECT fieldstudyid, fieldstudy
	FROM extra_sevis_fieldstudy
</Cfquery>

<Cfquery name="subcategories" datasource="MySQL">
	SELECT subfieldid, fieldstudyid, subfield
	FROM extra_sevis_sub_fieldstudy
</Cfquery>

<Cfquery name="companyshort" datasource="MySQL">
	SELECT *
	FROM smg_companies
	WHERE companyid = '#client.companyid#'
</Cfquery>

<Cfquery name="candidate_place_company" datasource="MySQL">
	SELECT *
	FROM extra_candidate_place_company
	WHERE candidateid = '#get_candidate_unqid.candidateid#'
	AND status = 1
</Cfquery>

<Cfquery name="hostcompany" datasource="MySQL">
	SELECT name, hostcompanyid
	FROM extra_hostcompany
	WHERE extra_hostcompany.companyid = 9 <!--- get only from H2B program ---->
	ORDER BY name
</Cfquery>

<Cfquery name="hostcompany2" datasource="MySQL">
	SELECT name, extra_hostcompany.hostcompanyid, extra_candidates.candidateid, extra_candidates.uniqueid
	FROM extra_hostcompany
	INNER JOIN extra_candidates ON extra_candidates.hostcompanyid = extra_hostcompany.hostcompanyid
WHERE extra_candidates.uniqueid = '#url.uniqueid#' 
</Cfquery>


<cfparam name="edit" default="no">

<cfif isDefined('form.edit') AND client.usertype LTE '4'> <cfset edit = '#form.edit#'> </cfif>

<cfset currentdate = #now()#>

<!--- candidate does not exist --->
<cfif get_candidate_unqid.recordcount EQ 0>
	The candidate ID you are looking for, <cfoutput>#url.candidateid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access lefts to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<!----Get Expired candidate Programs---->
<cfquery name="check_for_expired_program" datasource="mysql">
	SELECT candidateid, extra_candidates.programid, programname
	FROM smg_programs  inner join extra_candidates  on smg_programs.programid = extra_candidates.programid
	WHERE smg_programs.enddate <= #currentdate# and candidateid = #get_candidate_unqid.candidateid#
</cfquery>

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
<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate&uniqueid=#get_candidate_unqid.uniqueid#" onsubmit="return CheckProgram(#get_candidate_unqid.programid#, #candidate_place_company.hostcompanyid#);">
<cfinput type="hidden" name="candidateid" value="#get_candidate_unqid.candidateid#">
<div class="section">

<table width="770" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##ffffff">	
	<tr>
		<td valign="top" width="770" class="box">
		
			<table width="100%" align="Center" cellpadding="2">				
	   			<tr>
					<td width="135">
					
						<table width="100%" cellpadding="2">
							<tr>
								<td width="135" valign="top">
									<cfif '#FileExists('#expandPath("../uploadedfiles/web-candidates/#candidateid#.jpg")#')#'>
										<img src="../uploadedfiles/web-candidates/#candidateid#.jpg" width="135">
									<cfelse>
										<img src="../pics/no_stupicture.jpg" width="137" height="137">
									</cfif>
								</td>
							</tr>
						</table>
						
					</td>
					<td valign="top">
					
						<cfif edit EQ 'no'>
						<table width="100%" cellpadding="2">
							<tr>
								<td align="center" colspan="2" class="title1">#firstname# #middlename# #lastname# (## #candidateid#)</td>
							</tr>
							<tr>
								<td align="center" colspan="2"><span class="style4">[ <a href='candidate/candidate_profile.cfm?uniqueid=#get_candidate_unqid.uniqueid#' target="_blank"><span class="style4">profile</span></a> ]</span></td>
							</tr>
			 				<tr>
								<td align="center" colspan="2" class="style1"><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old</cfif> - <cfif sex EQ 'm'>Male<cfelse>Female</cfif></td>
							</tr> 
							<tr>
								<td colspan="2" align="center" class="style1"><b>Intl. Rep.:</b> <select name="intrep" <cfif edit EQ 'no'>disabled</cfif> >
									<option value="0"></option>		
									<cfloop query="int_Reps">
										<option value="#userid#" <cfif userid EQ get_candidate_unqid.intrep> selected </cfif>><cfif #len(businessname)# gt 45>#Left(businessname, 42)#...<cfelse>#businessname#</cfif></option>
									</cfloop>
									</select>
							  </td>
							</tr>
							<tr>
								<td colspan="2">
									
									<table width="100%" cellpadding="2" align="left">
										<tr>
											<td colspan="2" align="center" class="style1"><b>Date of Entry: </b> #DateFormat(entrydate, 'mm/dd/yyyy')#</td>
										</tr>
										<tr class="style1">
											<td colspan="2" align="center"><br>
													Candidate is <b><cfif status EQ 1>ACTIVE</cfif><cfif status EQ 0>INACTIVE</cfif><cfif status EQ 'canceled'>CANCELED</cfif>
											</td>	
										</tr>								
									</table>
																		
								</td>
							</tr>
						</table>
						
					<cfelse>
					
						<table width="100%" cellpadding="2">
							<tr>
								<td align="right" class="style1"><b>First Name: </b></td>
								<td><cfinput type="text" class="style1" name="firstname" size=32 value="#firstname#" maxlength="200" required="yes" message="First Name is Required"></td>
							</tr>
							<tr>
								<td align="right" class="style1"><b>Middle Name: </b> </td>
								<td><cfinput type="text" class="style1" name="middlename" size=32 value="#middlename#" maxlength="200"></td>
							<tr>
								<td align="right" class="style1"><b>Last Name: </b> </td>
								<td><cfinput type="text" class="style1" name="lastname" size=32 value="#lastname#" maxlength="200" required="yes" message="Last Name is Required"></td>
							</tr>
			 				<tr>
								<td align="right" class="style1"><b>Date of Birth: </b></td>
								<td class="style1"><cfinput type="text" name="dob" class="style1" size=15 value="#dateformat (dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)">&nbsp;  &nbsp; <b>Sex:</b> <span class="style1">
					    <input type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex." <cfif sex Eq 'M'>checked="checked"</cfif>>Male &nbsp; &nbsp;
              <input type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex." <cfif sex Eq 'F'>checked="checked"</cfif>>Female </span></td>
							</tr> 
							<tr>
								<td width="18%" align="right" class="style1"><b>Intl. Rep.: </b></td>
								<td width="82%" class="style1"><select name="intrep" class="style1" <cfif edit EQ 'no'>disabled</cfif> >
									<option value="0"></option>		
									<cfloop query="int_Reps">
										<option value="#userid#" <cfif userid EQ get_candidate_unqid.intrep> selected </cfif>><cfif #len(businessname)# gt 45>#Left(businessname, 42)#...<cfelse>#businessname#</cfif></option>
									</cfloop>
									</select>
							  </td>
							</tr>
							<tr>
								<td width="18%" align="right" class="style1"><b>Status: </b> </td>
								<td><select id="status" name="status" class="style1" <cfif get_candidate_unqid.status NEq 'canceled'> onchange="javascript:cancelation();" </cfif> >
													<option value="1" <cfif get_candidate_unqid.status Eq '1'>selected="selected"</cfif>>Active</option>
													<option value="0" <cfif get_candidate_unqid.status Eq '0'>selected="selected"</cfif>>Inactive</option>
													<option value="canceled" <cfif get_candidate_unqid.status Eq 'canceled'>selected="selected"</cfif>>Canceled</option>
												  </select></td>
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
								<td class="style1" bordercolor="FFFFFF" width="40%" align="right"><b>Place of Birth:</b></td>
								<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#birth_city#<cfelse><cfinput type="text" class="style1" name="birth_city" size=32 value="#birth_city#" maxlength="100"></cfif></td>
							</tr>
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Country of Birth:</b></td>
								<td class="style1" bordercolor="FFFFFF">

									<cfif edit EQ 'no'>
										<cfloop query="countrylist">
											<cfif countryid EQ get_candidate_unqid.birth_country> #countryname#</cfif></option>
										</cfloop>
									<cfelse>
										<select name="birth_country" class="style1" <cfif edit EQ 'no'>disabled</cfif> >
											<option value="0"></option>		
											<cfloop query="countrylist">
												<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.birth_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
											</cfloop>
										</select>
									</cfif>
								
								</td>
							</tr>		
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Country of Citizenship:</b></td>
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
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Country of Permanent Residence:</b></td>
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
											<td colspan="4" class="style1"><b>Mailing Address:</b> <cfif edit EQ 'no'>#home_address#<cfelse><cfinput type="text" name="home_address" class="style1" size=63 value="#home_address#" maxlength="200"></cfif></td>
										</tr><!-----1074---
										<tr bordercolor="F7F7F7">
											<td class="style1" align="left"><b>City:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#home_city#<cfelse><cfinput type="text" name="home_city" size=11 value="#home_city#" maxlength="100"></cfif></td>
											<td class="style1" align="left"><b>Zip:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#home_zip#<cfelse><cfinput type="text" name="home_zip" size=11 value="#home_zip#" maxlength="15"></cfif></td>
											</tr>---->
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
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Social Security ##:</b></td>
								<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#ssn#<cfelse><cfinput name="ssn" class="style1" type="text" id="ssn" size="18" value="#ssn#" maxlength="100" validate="social_security_number" message="This is not a valid SSN. Please enter a valid SSN for host father in the following format xxx-xx-xxxx"> xxx-xx-xxxx</cfif></td>
							</tr>							
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right" valign="top"><b>Personal Info./ Preferences:</b></td>
								<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#personal_info#<cfelse><cftextarea name="personal_info" class="style1" cols="30" rows="5">#personal_info#</cftextarea></cfif></td>
							</tr>
						</table>
										
					</td>
				</tr>
			</table>
			
			<br>
			
			<!--- PASSPORT INFORMATION --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Passport Information</td>
							</tr>
							<tr>
								<td width="33%" class="style1" align="right"><b>Passport Number:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#passport_number#<cfelse><cfinput name="passport_number" class="style1" value="#passport_number#" type="text" id="passport_number" size="31" maxlength="200"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Country Issued:</b></td>
								<td class="style1">
									<cfif edit EQ 'no'>
										<cfloop query="countrylist">
											<cfif countryid EQ get_candidate_unqid.passport_country> #countryname#</cfif></option>
										</cfloop>
									<cfelse>
									<select name="passport_country" required="yes" class="style1" message="You must select a country of birth." class="style1">
										<option value="0">Country...</option>
										<cfloop query="countrylist">
											<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.passport_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
										</cfloop>
									</select>
									</cfif>
								</td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Date Issued:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (passport_date, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="passport_date" value="#dateformat (passport_date, 'mm/dd/yyyy')#" size="16" maxlength="20" validate="date" message="Passport Date Issued must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Date Expires:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (passport_expires, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="passport_expires" value="#dateformat (passport_expires, 'mm/dd/yyyy')#" size="16" maxlength="20" validate="date" message="Passport Date Expires must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
						</table>	
						
					</td>
				</tr>
			</table>
						
			<br />
						
			<!--- EMERGENCY CONTACT --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
							</tr>
							<tr>
								<td width="15%" class="style1" align="left"><b>Name:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#emergency_name#<cfelse><input type="text" class="style1" name="emergency_name" size=32 value="#emergency_name#" maxlength="200"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="left"><b>Phone:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#emergency_phone#<cfelse><input type="text" class="style1" name="emergency_phone" size=32 value="#emergency_phone#" maxlength="50"></cfif></td>
							</tr>
							
						</table>	
						
					</td>
				</tr>
			</table>
			
			
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
		
			<!--- CANCELATION --->
			<table cellpadding=5 id="cancelation" cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Cancelation	</td>
							</tr>
							<tr>
								<td width="12%" class="style1"><b>Date: </b></td>
								<td colspan="2" class="style1"><cfif edit EQ 'no'>#DateFormat(cancel_date, 'mm/dd/yyyy')#<cfelse><input type="text" name="cancel_date" class="style1" size=15 value="#DateFormat(cancel_date, 'mm/dd/yyyy')#"> (mm/dd/yyyy)</cfif></td>
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
			
		
		
<!--- HOST COMPANY INFO / PLACEMENT INFORMATION --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Placement Information [<a href="javascript:OpenHistory2('candidate/candidate_host_history.cfm?unqid=#uniqueid#');" class="style2"> History </a> ]</span></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Company Name:</b></td>
								<td class="style1">
									<cfif edit EQ 'no'>
										<cfloop query="hostcompany2">
											<a href="?curdoc=hostcompany/hostcompany_profile&hostcompanyid=#hostcompany2.hostcompanyid#" class="style4">
											<!----<cfif hostcompany.hostcompanyid EQ candidate_place_company.hostcompanyid><b>#hostcompany.name#</b></cfif>---->
											<b>#hostcompany2.name#</b>
											</a>
										</cfloop>
									<cfelse>
									
									<select name="hostcompanyid_combo" class="style1" onChange="loadOptions('listsubcat');"> 
									<option value=0></option>
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
								<td class="style1"><input type="text" size="20" class="style1" name="reason_host"></td>
							</tr>
							<tr>
								<td width="30%" class="style1" align="right"><b>Status:</b></td>
								<td class="style1"><cfif edit EQ 'no'><cfif candidate_place_company.status EQ '1'>Active</cfif><cfif candidate_place_company.status EQ '0'>Inactive</cfif>
								<cfelse>
									<input type="radio" name="hostcompany_status" class="style1" value="1" <cfif candidate_place_company.status EQ '1'>checked="yes" </cfif>>
									Active&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="hostcompany_status" class="style1" value="0" <cfif candidate_place_company.status EQ '0'>checked="yes" </cfif>>
									Inactive
								</cfif></td>
							</tr>
							
							<input type="hidden" name="get_hostcompanyid_combo" value="#hostcompany.hostcompanyid#">
							<input type="hidden" name="get_status" value="#candidate_place_company.status#">
							<input type="hidden" name="get_startdate" value="#candidate_place_company.startdate#">
							<input type="hidden" name="get_enddate" value="#candidate_place_company.enddate#">
							<input type="hidden" name="get_confirmation" value="#candidate_place_company.confirmation_received#">	
							
							
							<cfif edit EQ 'no'><tr>
								<td class="style1" align="right"><b>Placement Date:</b></td>
								<td class="style1">#dateformat (candidate_place_company.placement_date, 'mm/dd/yyyy')# </td>
							</tr></cfif>
							<tr>
								<td class="style1" align="right"><b>Start Date:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="host_startdate" size=20 value="#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')#" maxlength="50"  validate="date" message="Host Company - Start Date (MM/DD/YYYY)"> (mm/dd/yyyy)</cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>End Date:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" class="style1" name="host_enddate" size=20 value="#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#" maxlength="50" validate="date" message="Host Company - End Date (MM/DD/YYYY)"> (mm/dd/yyyy)</cfif></td>
							</tr>
							<!----<tr>
								<td colspan="2" class="style1" align="left"><b>Confirmation Received:</b> <cfif edit EQ 'no'><cfif candidate_place_company.confirmation_received EQ '1'>Yes</cfif><cfif candidate_place_company.confirmation_received EQ '0'>No</cfif>
								<cfelse>
									<input type="radio" name="confirmation_received" value="1" <cfif candidate_place_company.confirmation_received EQ '1'>checked="yes" </cfif>>
									Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="confirmation_received" value="0" <cfif candidate_place_company.confirmation_received EQ '0'>checked="yes" </cfif>>
									No
								</cfif>
								</td>
							</tr>---->
						</table>	
						
					</td>
				</tr>
			</table>
			
			<br>
		
		<!------------------------- JOB OFFER INFO -------------------------
			<!--- Job Offer Info / Placement Information - adicionado depois por Arleston --->
				<cfquery name="get_extrajobs" datasource="mysql">
					SELECT id, title, extra_jobs.hostcompanyid, wage, low_wage, wage_type, hours, extra_hostcompany.name
					FROM extra_jobs
					INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_jobs.hostcompanyid
					INNER  JOIN extra_candidate_place_company ON extra_candidate_place_company.jobid = extra_jobs.id
					WHERE status = 1 
					AND candidateid = #get_candidate_unqid.candidateid#
				</cfquery>

<input type="hidden" name="currentjob" value="#candidate_place_company.jobid#">
<input type="hidden" name="currentjobid" value="#candidate_place_company.candcompid#">

				<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="3" class="style2" bgcolor="006699">&nbsp;:: Job Offer Information	</td>
							</tr>
							<tr>
								<td width="10" class="style1"><b>Position:</b> 
								<cfif edit EQ 'no'><a href="javascript:OpenHistory('hostcompany/edit_newjob.cfm?jobid=#get_extrajobs.id#');" class="style4">#get_extrajobs.title# </a><cfelse> 

								<cfquery name="get_position" datasource="mysql">
									SELECT extra_jobs.id, extra_jobs.title, extra_jobs.wage, extra_jobs.hours
									FROM extra_jobs
									
									<cfif IsDefined('hostcompanyid')>
									WHERE extra_jobs.hostcompanyid = '#hostcompany2.hostcompanyid#'
									</cfif>
									<!----#form.hostcompanyid_combo#---->
									
									<!--- #client.companyid# will bring number 8 --->
								</cfquery>
<!----<cfif form.hostcompanyid_combo is NOT 0>--->
<cfif 'hostcompany2.recordcount' NEQ 0>
								<select name="combo_position" >
									<option value=0></option>
											<cfloop query="get_position">	
											<cfif get_position.id EQ candidate_place_company.jobid><option value="#id#" selected>#title# </option><cfelse>
											<option value="#id#">#title#</option></cfif>
											</cfloop>
									</select>

								 </cfif></cfif>	
							  <br></td></tr>
								<tr><td width="10" class="style1"><b>Payment:</b><a href="javascript:OpenHistory('hostcompany/edit_newjob.cfm?jobid=#get_extrajobs.id#');" class="style4"><cfif get_extrajobs.wage is NOT ''> #get_extrajobs.wage# </cfif></a><br></td></tr>
								<tr><td width="10" class="style1"><b>Hours:</b> <a href="javascript:OpenHistory('hostcompany/edit_newjob.cfm?jobid=#get_extrajobs.id#');" class="style4"><cfif get_extrajobs.hours is not ''>#get_extrajobs.hours# </cfif></a></td>
							</tr>
						
						</table>	
						
					</td>
				</tr>
			</table>
			<br>
		-------------------------------->
		
			<!--- PROGRAM INFO --->
			
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF" bordercolor="FFFFFF">
								<td class="style2" bgcolor="8FB6C9" colspan="4">&nbsp;:: Program Information &nbsp;  [<a href="javascript:OpenHistory('candidate/candidate_program_history.cfm?unqid=#uniqueid#');" class="style2"> History </a> ]</span></td>
							</tr>						
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right" width="37%"><b>Program:</b></td>
								<td bordercolor="FFFFFF" colspan="3" class="style1">
								    <!--- <cfif check_for_expired_program.recordcount is '1'>
										#check_for_expired_program.programname# 
									<cfelse>--->
										<select name="programid" class="style1" <cfif edit EQ 'no'>disabled</cfif>>
											<option value="0">Unassigned</option>
											<cfloop query="program">
											<cfif get_candidate_unqid.programid EQ programid><option value="#programid#" selected>#programname#</option><cfelse>
											<option value="#programid#">#programname#</option></cfif>
											</cfloop>
										</select>
									<!---</cfif>--->
								</td>
							</tr>
							<tr id="program_history" bgcolor="FFBD9D">
								<td class="style1" align="right"><b>Reason:</b></td>
								<td class="style1"><input type="text" size="20" class="style1" name="reason"></td>
							</tr>
							<!---<tr>
								<td class="style1" bordercolor="FFFFFF" align="left"><b>Earliest Arri:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#dateformat (earliestarrival, 'mm/dd/yyyy')#<cfelse><cfinput type="text" value="#dateformat (earliestarrival, 'mm/dd/yyyy')#" name="earliestarrival" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="left"><b>Latest Arri:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#dateformat (latestarrival, 'mm/dd/yyyy')#<cfelse><cfinput type="text" value="#dateformat (latestarrival, 'mm/dd/yyyy')#" name="latestarrival" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>---->		
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="center" colspan="4"><b>Previously participated in the H2B Program?</b><br>
										<input type="radio" name="h2b_participated" value="1" <cfif get_candidate_unqid.h2b_participated EQ '1'>checked="yes" </cfif> <cfif edit EQ 'no'>disabled </cfif>>
										Yes											
										<input type="radio" name="h2b_participated" value="0" <cfif get_candidate_unqid.h2b_participated EQ '0'>checked="yes" </cfif><cfif edit EQ 'no'>disabled </cfif>>
										No
								</td>
							</tr>
									<!---- I-94 I94 --->
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>I-94 Number: </b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3">
											<cfif get_candidate_unqid.h2b_participated EQ '1'>
											<cfif edit EQ 'no'><cfinput type="text" value="#h2b_i94#" name="h2b_i94" size="18" maxlength="40" message="Please, fill out the I-94 number" disabled="disabled">
											<cfelse><cfinput type="text" value="#h2b_i94#" name="h2b_i94" size="18" maxlength="40" message="Please, fill out the I-94 number">
											</cfif>
											
											</td>
											</tr>
										<tr>
											<td class="style1" align="right"><b>Date H-2B Expires:</b> </td>
											<td><cfif edit EQ 'no'><cfinput type="text" value="#dateformat (h2b_date_expires, 'mm/dd/yyyy')#" name="h2b_date_expires" size="18" maxlength="20" validate="date" message="Please, the date H-2B expires must be MM/DD/YYYY" disabled="disabled"><cfelse>
											<cfinput type="text" value="#dateformat (h2b_date_expires, 'mm/dd/yyyy')#" name="h2b_date_expires" size="18" maxlength="20" validate="date" message="Please, the date H-2B expires must be MM/DD/YYYY">
											</cfif>
											</td>											
										</tr></cfif>

							
						<!--- from wat - Requested placement --->	
							<tr>
							<td  class="style1" align="right"><b>Request Placement:</b></td>
							<td class="style1" colspan="2"> 

						
							<cfif edit EQ 'no'>
							<cfselect name="combo_request" class="style1" disabled="disabled">
								<option value=""></option>
									<cfloop query="hostcompany">
								<option value="#hostcompanyid#" <cfif get_candidate_unqid.requested_placement eq #hostcompanyid#>selected</cfif>> #Left(name, 30)# </option>
									</cfloop>
							</cfselect>

							<cfelse>
								<cfselect name="combo_request" class="style1">
										<option value=""></option>
											<cfloop query="hostcompany">
										<option value="#hostcompanyid#" <cfif get_candidate_unqid.requested_placement eq #hostcompanyid#>selected</cfif>> #Left(name, 30)# </option>
											</cfloop>
								</cfselect>
		</cfif>
		<br></td></tr>
							<!---- // close requested placement --->

<!---- I-129 filed ? / 1126 ticket ---->
					<tr>
					<td class="style1" bordercolor="FFFFFF" align="right"><b>I-129 filed?: </b></td>
					<td class="style1" bordercolor="FFFFFF" colspan="3">
									
<input type="checkbox" name="check_i129" <cfif edit EQ 'no'>disabled</cfif> <cfif #h2b_i129_filled# EQ '1'>checked </cfif>>

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
								<td width="28%" class="style1" align="right"><b>Policy Type:</b></td>
								<td width="70%" class="style1"><cfif get_int_rep.extra_insurance_typeid EQ 0><font color="FF0000">Missing Policy Type</font><cfelse>#get_int_rep.type#</cfif></td>
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
								<td><cfif insurance_cancel_date EQ ''><input type="checkbox" name="insurance_Cancel" disabled><Cfelse><input type="checkbox" name="insurance_Cancel" checked disabled></cfif></td>
								<td class="style1" align="right"><b>Cancel Date:</b></td>
								<td class="style1">#DateFormat(insurance_cancel_date, 'mm/dd/yyyy')#</td>
							</tr>
						</table>
					</td>	
				</tr>
			</table>
			<br>					
		</td>	
	</tr>
</table>

<br>

</div>

<!--- UPDATE BUTTON --->
<cfif edit NEQ 'no'>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
	<tr>
		<td align="center">
	<cfinput name="Submit" type="image" src="../pics/update.gif" alt="Update Profile"  border=0>
	</cfinput>
		</td>
	</tr>
</table>
</cfif>
</cfform>
		
<!---- EDIT BUTTON - OFFICE USERS  ---->
<cfif client.usertype LTE '4' AND edit EQ 'no'>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">	
	<tr>
		<td align="center">
			<cfform action="" method="post">&nbsp;
				<cfinput type="hidden" name="edit" value="yes">
				<cfinput name="Submit" type="image" src="../pics/edit.gif" alt="Edit"  border=0>
			</cfform>
		</td>
	</tr>
</table>
</cfif>

<script>
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

</cfoutput>
<!----
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch> 

</cftry> ---->

			</td>
		</tr>
	</table>

</body>
</html>