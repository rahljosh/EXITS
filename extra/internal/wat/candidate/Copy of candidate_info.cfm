<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate Info</title>

</head>
<body>

	<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
		<tr>
			<td bordercolor="FFFFFF">

<!---<cftry>--->

<cfparam name="edit" default="no">
<!----<cfif edit NEQ 'no'>--->
<Cfquery name="hostcompany2" datasource="MySQL">
	SELECT name, extra_hostcompany.hostcompanyid, extra_candidates.candidateid, extra_candidates.uniqueid
	FROM extra_hostcompany
	INNER JOIN extra_candidates ON extra_candidates.hostcompanyid = extra_hostcompany.hostcompanyid
<cfif edit NEQ 'no'>
	WHERE extra_candidates.uniqueid = '#url.uniqueid#'
</cfif>
</Cfquery>


	<cfquery name="get_position" datasource="mysql">
									SELECT extra_jobs.id, extra_jobs.title, extra_jobs.wage, extra_jobs.hours
									FROM extra_jobs
									INNER JOIN extra_candidate_place_company ON extra_candidate_place_company.candcompid = extra_jobs.id
									
<cfif IsDefined('hostcompanyid')>
									WHERE extra_jobs.hostcompanyid = '#hostcompany2.hostcompanyid#'
</cfif>

									<!----#form.hostcompanyid_combo#---->
									
									<!--- #client.companyid# will bring number 8 --->
	</cfquery>

<!----</cfif>	 ---->

<!-----Int Rep----->
<Cfquery name="int_Reps" datasource="MySQL">
	SELECT userid, firstname, lastname, businessname, country
	FROM smg_users
	WHERE usertype = 8
	AND active = '1'
	ORDER BY businessname
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

<cfinclude template="../querys/get_candidate_unqid.cfm">
<cfinclude template="../querys/countrylist.cfm">
<cfinclude template="../querys/fieldstudy.cfm">
<cfinclude template="../querys/program.cfm">
<cfinclude template="../querys/intagents.cfm">

<Cfquery name="candidate_place_company" datasource="MySQL">
	SELECT *
	FROM extra_candidate_place_company
	WHERE candidateid = '#get_candidate_unqid.candidateid#'
	AND status = 1
</Cfquery>
<!----<cfdump var="#candidate_place_company#">---->

<Cfquery name="hostcompany" datasource="MySQL">
	SELECT name, hostcompanyid
	FROM extra_hostcompany
	WHERE extra_hostcompany.companyid = 8
	ORDER BY name
</Cfquery>

<Cfquery name="hostcompany2" datasource="MySQL">
	SELECT name, extra_hostcompany.hostcompanyid, extra_candidates.candidateid, extra_candidates.uniqueid
	FROM extra_hostcompany
	INNER JOIN extra_candidates ON extra_candidates.hostcompanyid = extra_hostcompany.hostcompanyid
WHERE extra_candidates.uniqueid = '#url.uniqueid#'
</Cfquery>

<!---- some tests ----
<cfoutput>
hostcompany2 = #hostcompany2.hostcompanyid#<br>
hostcompany = #hostcompany.hostcompanyid#<br>
#candidate_place_company.hostcompanyid# ->>> it's bringing number 8 !! 
</cfoutput>
--------->
			
<cfif IsDefined('candidate_place_company.hostcompanyid') >
<!--// load the Client/Server Gateway API //-->
	<script language="JavaScript1.2" src="./candidate/lib/gateway.js"></script> 	
	
	<!--// [start] custom JavaScript //-->
	<script language="JavaScript"> 	
		<!--// // create the gateway object
		oGateway = new Gateway("./candidate/NewPositionSelect.cfm", false);
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
			   if (document.CandidateInfo.listsubcat.options[i].value == <cfoutput>#get_position.id#</cfoutput>){ <!---- // get_candidate_unqid.subfieldid /// ------>
				 Counter++;
			   }
			}
			if (Counter == 1){		
			 document.CandidateInfo.listsubcat.value = <cfoutput>#get_position.id#</cfoutput>;
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

//program history
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
//-->
</script> 	<!--// [ end ] custom JavaScript //-->

<cfif NOT IsDefined('url.uniqueid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>
<!---
<cfdump var="#candidate_place_company#">---->

<cfif isDefined('form.edit') AND client.usertype LTE '4'> <cfset edit = '#form.edit#'> </cfif>
<cfif NOT isDefined('form.edithost')> <cfset edithost = 'no'></cfif>

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

<!----Get Expired candidate Programs---->
<cfquery name="check_for_expired_program" datasource="mysql">
	SELECT candidateid, extra_candidates.programid
	FROM smg_programs  inner join extra_candidates  on smg_programs.programid = extra_candidates.programid
	WHERE smg_programs.enddate <= #currentdate# and candidateid = #get_candidate_unqid.candidateid#
</cfquery>

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
								<td align="center" colspan="2" class="title1">#firstname# #middlename# #lastname# <font size="2">(###candidateid#)</font></td>
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
								<td colspan="2">
									
									<table width="100%" cellpadding="2" align="left">
										<tr>
											<td width="32%" align="right" class="style1"><b>Date of Entry: </b></td>
											<td width="68%" class="style1">#DateFormat(entrydate, 'mm/dd/yyyy')#</td>
										</tr>
										<tr>
											<td align="right">
													<input type="checkbox" name="status" <cfif #cancel_date# EQ ''>checked="Yes"</cfif> disabled>
											</td>
											<td class="style1">Candidate is <b>Active</b></td>
											
										</tr>													
									</table>									
								</td>
							</tr>
						</table>
						
					<cfelse>
					
						<table width="100%" cellpadding="2">
							<tr>
								<td align="right" class="style1"><b>First Name:</b></td>
								<td><cfinput type="text" name="firstname" size=32 value="#firstname#" maxlength="200" required="yes"></td>
							</tr>
							<tr>
								<td align="right" class="style1"><b>Middle Name:</b> </td>
								<td><cfinput type="text" name="middlename" size=32 value="#middlename#" maxlength="200"></td>
							<tr>
								<td align="right" class="style1"><b>Last Name:</b> </td>
								<td><cfinput type="text" name="lastname" size=32 value="#lastname#" maxlength="200" required="yes"></td>
							</tr>
			 				<tr>
								<td align="center" class="style1"><b>Date of Birth:</b></td>
								<td class="style1"><cfinput type="text" name="dob" size=10 value="#dateformat (dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)">&nbsp; <b>Sex:</b> <span class="style1">
					    <input type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex." <cfif sex Eq 'M'>checked="checked"</cfif>>Male &nbsp; &nbsp;
              <input type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex." <cfif sex Eq 'F'>checked="checked"</cfif>>Female </span></td>
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
								<td class="style1" bordercolor="FFFFFF" width="65%"><cfif edit EQ 'no'>#birth_city#<cfelse><cfinput type="text" name="birth_city" size=32 value="#birth_city#" maxlength="100"></cfif></td>
							</tr>
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Country of Birth:</b></td>
								<td class="style1" bordercolor="FFFFFF">

									<cfif edit EQ 'no'>
										<cfloop query="countrylist">
											<cfif countryid EQ get_candidate_unqid.birth_country> #countryname#</cfif></option>
										</cfloop>
									<cfelse>
										<select name="birth_country" <cfif edit EQ 'no'>disabled</cfif> >
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
										<select name="citizen_country" <cfif edit EQ 'no'>disabled</cfif>  >
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
										<select name="residence_country" <cfif edit EQ 'no'>disabled</cfif>  >
										<option value="0"></option>		
										<cfloop query="countrylist">
											<option value="#countryid#" <cfif countryid EQ get_candidate_unqid.residence_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
										</cfloop>
										</select>			
									</cfif>
								
								</td>
							</tr>
							<tr>
								<td width="33%" class="style1" align="right"><b>Passport No.:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#passport_number#<cfelse><cfinput name="passport_number" value="#passport_number#" type="text"  size="38" maxlength="100"></cfif></td>
							</tr>
							<tr>				
								<td class="style1" bordercolor="FFFFFF" colspan="2">

									<table width="100%" cellpadding=1 cellspacing=2 border=0 bordercolor="C7CFDC" bgcolor="F7F7F7">
										<tr bordercolor="F7F7F7">
											<td colspan="4" class="style1"><b>Mailing Address:</b> <cfif edit EQ 'no'>#home_address#<cfelse><cfinput type="text" name="home_address" size=49 value="#home_address#" maxlength="200"></cfif></td>
										</tr>
										<tr bordercolor="F7F7F7">
											<td class="style1" align="right"><b>City:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#home_city#<cfelse><cfinput type="text" name="home_city" size=11 value="#home_city#" maxlength="100"></cfif></td>
											<td class="style1" align="right"><b>Zip:</b></td>
											<td class="style1"><cfif edit EQ 'no'>#home_zip#<cfelse><cfinput type="text" name="home_zip" size=11 value="#home_zip#" maxlength="15"></cfif></td>
										</tr>
										<tr bordercolor="F7F7F7">
											<td class="style1" align="right"><b>Country:</b></td>
											<td colspan="3" class="style1">
											
												<cfif edit EQ 'no'>
													<cfloop query="countrylist">
														<cfif countryid EQ get_candidate_unqid.home_country> #countryname#</cfif></option>
													</cfloop>
												<cfelse>
													<select name="home_country" <cfif edit EQ 'no'>disabled</cfif>  >
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
											<td class="style1" colspan="3"><cfif edit EQ 'no'>#home_phone#<cfelse><cfinput type="text" name="home_phone" size=38 value="#home_phone#" maxlength="50"></cfif></td>
										</tr>
										<tr bordercolor="F7F7F7">
											<td class="style1" align="right"><b>Email:</b></td>
											<td class="style1" colspan="3"><cfif edit EQ 'no'>#email#<cfelse><cfinput type="text" name="email" size=38 value="#email#" maxlength="100"></cfif></td>
										</tr>
																
									</table>
								
								</td>					
							</tr>					
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Personal Info./ Preferences:</b></td>
								<td class="style1" bordercolor="FFFFFF"><cfif edit EQ 'no'>#personal_info#<cfelse><cftextarea name="personal_info" cols="25" rows="3">#personal_info#</cftextarea></cfif></td>
							</tr>
						</table>
										
					</td>
				</tr>
			</table>
			
			<br />
					
			<!--- SCHOOL INFORMATION --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Dates of the Official Vacation</td>
							</tr>
							<tr>
								<td width="23%" class="style1" align="right"><b>Start Date:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (wat_vacation_start, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="wat_vacation_start" size=20 value="#dateformat (wat_vacation_start, 'mm/dd/yyyy')#" maxlength="50"  validate="date" message="Official Vacation - First Date (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>End Date:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (wat_vacation_end, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="wat_vacation_end" size=20 value="#dateformat (wat_vacation_end, 'mm/dd/yyyy')#" maxlength="50" validate="date" message="Official Vacation - Last Date (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							
							<!--- ticket 996 --- and take it out 1047 
							<tr>
								<td class="style1" align="right"><b>Weeks:</b></td>
								<td class="style1"> <cfif wat_vacation_start IS NOT '' AND wat_vacation_end IS NOT ''> #DateDiff('ww', wat_vacation_start, wat_vacation_end)# </cfif></td>
							</tr>
							<!--- end ticket 996 ---> --->
						</table>	
						
					</td>
				</tr>
			</table>

			
			<br>
			
			<!----
			<!--- PASSPORT INFORMATION --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Passport Information</td>
							</tr>
							<tr>
								<td width="33%" class="style1" align="right"><b>Passport No.:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#passport_number#<cfelse><cfinput name="passport_number" value="#passport_number#" type="text" id="passport_number" size="31" maxlength="200"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Country Issued:</b></td>
								<td class="style1">
									<cfif edit EQ 'no'>
										<cfloop query="countrylist">
											<cfif countryid EQ get_candidate_unqid.passport_country> #countryname#</cfif></option>
										</cfloop>
									<cfelse>
									<select name="passport_country" required="yes" message="You must select a country of birth." class="style1">
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
								<td class="style1"><cfif edit EQ 'no'>#dateformat (passport_date, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="passport_date" value="#dateformat (passport_date, 'mm/dd/yyyy')#" size="16" maxlength="20" validate="date" message="Passport Date Issued must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Date Expires:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (passport_expires, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="passport_expires" value="#dateformat (passport_expires, 'mm/dd/yyyy')#" size="16" maxlength="20" validate="date" message="Passport Date Expires must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
						</table>	
						
					</td>
				</tr>
			</table>
						
			<br />
					---->	
			<!--- EMERGENCY CONTACT --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
							</tr>
							<tr>
								<td width="25%" class="style1" align="right"><b>Name:</b></td>
								<td colspan="2" class="style1"><cfif edit EQ 'no'>#emergency_name#<cfelse><input type="text" name="emergency_name" size=32 value="#emergency_name#" maxlength="200"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Phone:</b></td>
								<td colspan="2" class="style1"><cfif edit EQ 'no'>#emergency_phone#<cfelse><input type="text" name="emergency_phone" size=32 value="#emergency_phone#" maxlength="50"></cfif></td>
							</tr>
							<!---- 1052 ----
							<tr>
								<td  class="style1" align="right"><b>Relationship:</b></td>
								<td colspan="2" class="style1"><cfif edit EQ 'no'>#emergency_relationship#<cfelse><input type="text" name="emergency_relationship" size=32 value="#emergency_relationship#" maxlength="50"></cfif></td>
							</tr> ----->
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
								<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
							</tr>
							<tr>
								<td width="46%" class="style1" colspan="2"><Cfif wat_doc_agreement Eq '0'><input type="checkbox" name="wat_doc_agreement" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="wat_doc_agreement" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Agreement</td>
								<td width="54%" class="style1" colspan="2"><Cfif wat_doc_college_letter Eq '0'><input type="checkbox" name="wat_doc_college_letter" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="wat_doc_college_letter" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> College Letter</td>
							</tr>
							<tr>
								<td class="style1" colspan="2"><Cfif wat_doc_passport_copy Eq '0'><input type="checkbox" name="wat_doc_passport_copy" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="wat_doc_passport_copy" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Passport Copy</td>
								<td class="style1" colspan="2"><Cfif wat_doc_job_offer Eq '0'><input type="checkbox" name="wat_doc_job_offer" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="wat_doc_job_offer" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Job Offer</td>
							</tr>
							<tr>
								<td class="style1" colspan="2"><Cfif wat_doc_orientation Eq '0'><input type="checkbox" name="wat_doc_orientation" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="wat_doc_orientation" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Orient. Sign Off</td>
								<td class="style1" colspan="2">&nbsp;</td>
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
			
			
			
		</td>
		
		
		
		<td width="2%" valign="top">&nbsp;</td>
		<td width="49%" valign="top">
		
			<!--- HOST COMPANY INFO / PLACEMENT INFO --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="C2D1EF">
								<td colspan="2" class="style2" bgcolor="006699">&nbsp;:: Placement Information [<a href="javascript:OpenHistory2('candidate/candidate_host_history.cfm?unqid=#uniqueid#');"><font class="style3" color="FFFFFF"> History </font></a> ]</span></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Company Name:</b></td>
								<td class="style1">
									<cfif edit EQ 'no'>
										<cfloop query="hostcompany2">
											<a href="?curdoc=hostcompany/hostcompany_profile&hostcompanyid=#hostcompany2.hostcompanyid#" class="style4">
<!----<cfif hostcompany.hostcompanyid EQ candidate_place_company.hostcompanyid><font size="2">#hostcompany.name#</font></cfif>---->
<font size="2">#hostcompany2.name#</font>
</a>
										</cfloop>
									<cfelse>
									
									<select name="hostcompanyid_combo"> 
									<option value=0></option><!--- candidate_place_company.hostcompanyid but bring 8---->
											<cfloop query="hostcompany">
											<cfif hostcompany.hostcompanyid EQ hostcompany2.hostcompanyid><option value="#hostcompanyid#" selected><cfif #len(name)# gt 30>#Left(name, 28)#...<cfelse>#name#</cfif></option><cfelse>
											<option value="#hostcompanyid#"><cfif #len(name)# gt 30>#Left(name, 28)#...<cfelse>#name#</cfif></option></cfif>
											</cfloop>
									</select>
									
									</cfif>
									
									
									
								</td>
							</tr>
							<tr id="host_history" bgcolor="FFBD9D">
								<td class="style1" align="right"><b>Reason:</b></td>
								<td class="style1"><input type="text" size="20" name="reason_host"></td>
							</tr>
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
							<cfif edit EQ 'no'><tr>
								<td colspan="2" class="style1" align="left"><b>Placement Date:</b> #dateformat (candidate_place_company.placement_date, 'mm/dd/yyyy')#</td>
							</tr></cfif>
							<tr>
								<td class="style1" align="right"><b>Start Date:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="host_startdate" size=20 value="#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')#" maxlength="50"  validate="date" message="Host Company - Start Date (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>End Date:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="host_enddate" size=20 value="#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#" maxlength="50" validate="date" message="Host Company - End Date (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
<!-----							<tr>
								<td colspan="2" class="style1" align="left"><b>Confirmation Received:</b> <cfif edit EQ 'no'><cfif candidate_place_company.confirmation_received EQ '1'>Yes</cfif><cfif candidate_place_company.confirmation_received EQ '0'>No</cfif>
								<cfelse>
									<input type="radio" name="confirmation_received" value="1" <cfif candidate_place_company.confirmation_received EQ '1'>checked="yes" </cfif>>
									Yes&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="confirmation_received" value="0" <cfif candidate_place_company.confirmation_received EQ '0'>checked="yes" </cfif>>
									No
								</cfif>
								</td>
							</tr>------>
						</table>	
						
					</td>
				</tr>
			</table>
			
			
			
			<!--------------------- placement info // taking out ---------
			<!--- Placement Information - adicionado depois por Arleston --->
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

				<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Placement Information	</td>
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
			</table>	------------>
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
								<td bordercolor="FFFFFF" width="73%" colspan="3"><cfif check_for_expired_program.recordcount is '1'>
										#check_for_expired_program.programname#
									<cfelse>
										<select name="programid" <cfif edit EQ 'no'>disabled</cfif>>
											<option value="0">Unassigned</option>
											<cfloop query="program">
											<cfif get_candidate_unqid.programid EQ programid><option value="#programid#" selected>#programname#</option><cfelse>
											<option value="#programid#">#programname#</option></cfif>
											</cfloop>
										</select>
									</cfif>
								</td>
							</tr>
							<tr id="program_history" bgcolor="FFBD9D">
								<td class="style1" align="right"><b>Reason:</b></td>
								<td class="style1"><input type="text" size="20" name="reason"></td>
							</tr>
							<!--- ticket 996
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Earliest Arri:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#dateformat (earliestarrival, 'mm/dd/yyyy')#<cfelse><cfinput type="text" value="#dateformat (earliestarrival, 'mm/dd/yyyy')#" name="earliestarrival" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Latest Arri:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#dateformat (latestarrival, 'mm/dd/yyyy')#<cfelse><cfinput type="text" value="#dateformat (latestarrival, 'mm/dd/yyyy')#" name="latestarrival" size="18" maxlength="20" validate="date" message="Earliest Arrival must be MM/DD/YYYY"><font size="1"> (mm/dd/yyyy)</font></cfif></td>
							</tr>		------>
<!---- ticket 1047 ----
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Req. Length:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#wat_length# <cfif wat_length NEQ ''>weeks</cfif><cfelse> 
								
								<cfselect name="wat_length"  class="style1" required="no">
														<option value="">Select....</option>
														<option value="4" <cfif wat_length EQ '4'>selected="selected"</cfif>>4</option>
														<option value="6" <cfif wat_length EQ '6'>selected="selected"</cfif>>6</option>
														<option value="8" <cfif wat_length EQ '8'>selected="selected"</cfif>>8</option>
														<option value="9" <cfif wat_length EQ '9'>selected="selected"</cfif>>9</option>
														<option value="10" <cfif wat_length EQ '10'>selected="selected"</cfif>>10</option>
														<option value="11" <cfif wat_length EQ '11'>selected="selected"</cfif>>11</option>
														<option value="12" <cfif wat_length EQ '12'>selected="selected"</cfif>>12</option>
														<option value="13" <cfif wat_length EQ '13'>selected="selected"</cfif>>13</option>
														<option value="14" <cfif wat_length EQ '14'>selected="selected"</cfif>>14</option>
														<option value="15" <cfif wat_length EQ '15'>selected="selected"</cfif>>15</option>
														<option value="16" <cfif wat_length EQ '15'>selected="selected"</cfif>>16</option>
												</cfselect> weeks
												</cfif></td>
							</tr>	-------->
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Option: <!--- Placement---></b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"><cfif edit EQ 'no'>#wat_placement#<cfelse>
									<cfselect name="wat_placement"  class="style1" required="no">
											<option value="">Select....</option>
											<option value="Self-Placement" <cfif wat_placement EQ 'Self-Placement'>selected="selected"</cfif>>Self-Placement</option>
											<option value="INTO-Placement" <cfif wat_placement EQ 'INTO-Placement'>selected="selected"</cfif>>INTO-Placement</option>
									</cfselect>
								</cfif></td>
							</tr>		
							<tr>
								<td class="style1" bordercolor="FFFFFF" align="center" colspan="4"><b>Number of Participation in the Program:</b><br>
									<cfif edit EQ 'no'>#wat_participation#<cfelse><cfinput name="wat_participation" value="#wat_participation#" type="text" id="wat_participation" size="5" maxlength="5"></cfif> times
								</td>
							</tr>
							
							<!--- ticket 1013 ---->
							<!----<tr><td width="10" class="style1" align="right"><b>DS2019:</b>
							<td width="10" class="style1"> #ds2019# <br></td></tr>---->
						
					
							<tr><td width="10" class="style1" align="right"><b>Request:</b>
							<td width="10" class="style1"> 

							<!--- #Left(name, 28)# utilizar length---->
							<cfif edit EQ 'no'>
							<cfselect name="combo_request" disabled="disabled">
								<option value=""></option>
									<cfloop query="hostcompany">
								<option value="#hostcompanyid#" <cfif get_candidate_unqid.requested_placement eq #hostcompanyid#>selected</cfif>> #Left(name, 30)# </option>
									</cfloop>
							</cfselect>
							<!----#get_request.# FAZER COMBOBOX trazendo hostcompany name e gravando hostcompanyid. ----><br></td></tr>
							<cfelse>
								<cfselect name="combo_request">
										<option value=""></option>
											<cfloop query="hostcompany">
										<option value="#hostcompanyid#" <cfif get_candidate_unqid.requested_placement eq #hostcompanyid#>selected</cfif>> #Left(name, 30)# </option>
											</cfloop>
								</cfselect>
<br></td></tr>			
													
							</cfif>
					<td width="10" class="style1" align="right"><b>Comment:</b>
							<cfif edit EQ 'no'>
							<td width="10" class="style1"> <textarea name="change_requested_comment" value="change_requested_comment" cols="20" rows="2" disabled="disabled">#change_requested_comment#</textarea> </td></tr>
							<cfelse>
							<td width="10" class="style1"> <textarea name="change_requested_comment"  value="change_requested_comment" cols="20" rows="2">#change_requested_comment#</textarea> </td></tr>
							</cfif>

			<!--- 1047 #3 --->
			<cfif edit EQ 'no'>
				<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Start Date:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"> #dateformat (startdate, 'mm/dd/yyyy')#
								<!----<cfif startdate IS NOT ''> #dateformat (startdate, 'mm/dd/yyyy')#</cfif>---->
								</td>
				</tr>
				<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>End Date:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3">#dateformat (enddate, 'mm/dd/yyyy')#
						<!---	<cfif enddate IS NOT ''>	<cfif enddate LTE wat_vacation_date>#dateformat (enddate, 'mm/dd/yyyy')#<cfelse> Date incorrect</cfif></cfif> ----- get_candidate_unqid. --->
								</td>
				</tr>
			<!--- edit --->
			<cfelse>
			
			<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>Start Date:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3"> <cfinput type="text" name="program_startdate" size=20 value="#dateformat (startdate, 'mm/dd/yyyy')#" maxlength="50"  validate="date" message="Start Date of the Program (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font>
								</td>
				</tr>
				<tr>
								<td class="style1" bordercolor="FFFFFF" align="right"><b>End Date:</b></td>
								<td class="style1" bordercolor="FFFFFF" colspan="3">
								<cfinput type="text" name="program_enddate" size=20 value="#dateformat (enddate, 'mm/dd/yyyy')#" maxlength="50"  validate="date" message="End Date of the Program (MM/DD/YYYY)"><font size="1"> (mm/dd/yyyy)</font>
						
								<!--- <cfif get_candidate_unqid.enddate LTE get_candidate_unqid.wat_vacation_date>#get_candidate_unqid.enddate# <cfelse> Date incorrect</cfif> --->
								</td>
				</tr>
			
			</cfif>
			
							
						</table>

										
					</td>
				</tr>
			</table>
			
			<br>
			
		
			
			<!--- CENCELATION --->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=5 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Cancelation	</td>
							</tr>
							<tr>
								<td width="10" class="style1"><Cfif #DateFormat(cancel_date, 'mm/dd/yyyy')# is ''> <input type="checkbox" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif></td>
								<td colspan="2" class="style1">Candidate Cancelled  &nbsp; &nbsp; &nbsp; &nbsp; <b>Date: </b>&nbsp; <cfif edit EQ 'no'>#DateFormat(cancel_date, 'mm/dd/yyyy')#<cfelse><input type="text" name="cancel_date" size=8 value="#DateFormat(cancel_date, 'mm/dd/yyyy')#"></cfif></td>
							</tr>
						</table>	
						
					</td>
				</tr>
			</table>
			
			<br>
		
		
			
			<!----DS2019 Form---- added after---->
			<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF">
					
						<table width="100%" cellpadding=3 cellspacing=0 border=0>
							<tr bgcolor="##C2D1EF">
								<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Form DS-2019</td>
							</tr>				
							<tr>	
								<td class="style1" align="right"><b>No.:</b></td>
								<td class="style1" colspan="3"><cfif edit EQ 'no'>#ds2019#<cfelse><cfinput type="text" name="ds2019" size=12 value="#ds2019#" maxlength="100"></cfif></td>
							</tr>
						<!---	<tr>
								<td class="style1" align="right"><b>Position:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#ds2019_position#<cfelse><cfinput type="text" name="ds2019_position" size=12 value="#ds2019_position#" maxlength="50"></cfif></td>
								<td class="style1" align="right"><b>Subject:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#ds2019_subject#<cfelse><cfinput type="text" name="ds2019_subject" size=12 value="#ds2019_subject#" maxlength="50"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Street:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#ds2019_street#<cfelse><cfinput type="text" name="ds2019_street" size=12 value="#ds2019_street#" maxlength="150"></cfif></td>
								<td class="style1" align="right"><b>City:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#ds2019_city#<cfelse><cfinput type="text" name="ds2019_city" size=12 value="#ds2019_city#" maxlength="100"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>State:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#ds2019_state#<cfelse><cfinput type="text" name="ds2019_state" size=12 value="#ds2019_state#" maxlength="12"></cfif></td>
								<td class="style1" align="right"><b>Zip:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#ds2019_zip#<cfelse><cfinput type="text" name="ds2019_zip" size=12 value="#ds2019_zip#" maxlength="10"></cfif></td>
							</tr>
							<tr>
								<td class="style1" align="right"><b>Start:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#DateFormat(ds2019_startdate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="ds2019_startdate" size=12 value="#DateFormat(ds2019_startdate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 Start Date (MM/DD/YYYY)"></cfif></td>
								<td class="style1" align="right"><b>End:</b></td>
								<td class="style1"><cfif edit EQ 'no'>#DateFormat(ds2019_enddate, 'mm/dd/yyyy')#<cfelse><cfinput type="text" name="ds2019_enddate" size=12 value="#DateFormat(ds2019_enddate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 End Date(MM/DD/YYYY)"></cfif></td>
							</tr> --->
						</table>
						
					</td>
				</tr>
			</table>
			
		</td>
	</tr>
</table>

			
			<br>
			
	
		
	

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

</cfoutput>

<!---<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch> 

</cftry>--->

			</td>
		</tr>
	</table>

</body>
</html>