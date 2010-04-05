<cfdocument format="pdf" orientation="portrait" backgroundvisible="yes" overwrite="no" fontembed="yes">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../profile.css">
	<title>: EXTRA  ::  Candidate Profile :</title>
</head>
<body>

<SCRIPT>
<!--
// open online application 
function OpenApp(url)
{
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</SCRIPT>

<cfif NOT IsDefined('url.uniqueid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

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
	WHERE companyid = '#client..companyid#'
</Cfquery>

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
	AND userid = '#get_candidate_unqid.intrep#'
</Cfquery>

<cfparam name="edit" default="no">

<cfif isDefined('form.edit') AND client..usertype LTE '4'> <cfset edit = '#form.edit#'> </cfif>

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

	
<link rel="stylesheet" href="profile.css" type="text/css">

<cfoutput query="get_candidate_unqid">

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td valign="top" width=180> <span id="titleleft">
		 <b>Intl. Rep.:</b> #int_Reps.businessname#<br>
		 <b>Date Entry:</b> #DateFormat(get_candidate_unqid.entrydate, 'mmm d, yyyy')#<br>
		 <b>Today's Date:</b> #DateFormat(now(), 'mmm d, yyyy')#<br><br>
		</span>
	</td> 
	<td valign="top"><div align="center">
		<font size=+2><b>Exchange Training Abroad</b></b></font><br>
		<b>Program:</b> 
		
			<cfloop query="program">
				<cfif get_candidate_unqid.programid EQ program.programid> #programname#</cfif>
			</cfloop>
		
		</td>
	</div><td><!----<cfif client..usertype gte 8><img src="http://www.phpusa.com/internal/pics/dmd-logo.jpg"><cfelse>----><img src="../../pics/extra-logo.jpg" width="60" height="81" border=0><!----</cfif>----></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<td bgcolor="F3F3F3" valign="top" width=133><div align="left">
		<!--- <cfif '#FileExists('#expandPath("../uploadedfiles/web-candidates/#candidateid#.jpg")#')#'>
			<img src="../uploadedfiles/web-candidates/#candidateid#.jpg" width="135">
		<cfelse>
			<img src="../../images/no_stupicture.jpg" width="137" height="137">
		</cfif>---->
		
			<cfif FileExists("#AppPath.candidatePicture##candidateid#.#get_candidate_unqid.picture_type#")>
				<img src="../../uploadedfiles/web-candidates/#candidateid#.#get_candidate_unqid.picture_type#" width="135" />
			<cfelse>
				<img src="../../pics/no_logo.jpg" width="135" border=0></a>
			</cfif>
	</div></td>
	<td valign="top" width=504>
	<span class="application_section_header"><b>TRAINEE PROFILE</b></span><br>
	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
		<tr><td width="50"><font face="" color="Gray"><b>Name:</b> </font><b></td><td>#firstname# #middlename# #lastname# (#candidateid#)</b></td></tr>	
		<tr><td><font face="" color="Gray"><b>Sex:</b> </font></td><td><cfif sex EQ 'm'>Male<cfelse>Female</cfif></td></tr>
		<tr><td><font face="" color="Gray"><b>DOB:</b> </font></td><td><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old</cfif></td></tr>
	</table>
	 			
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px" width="100%">
		<tr bgcolor="C2D1EF">
			<td colspan="4" class="application_section_header"><b>DOCUMENTS CONTROL</b></td>
		</tr>
		<tr>
			<td width="46%" class="style1" colspan="2"><br><Cfif #doc_application# Eq '0'><input type="checkbox" name="doc_application" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_application" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Application</td>
			<td width="54%" class="style1" colspan="2"><br><Cfif #doc_passportphoto# Eq '0'><input type="checkbox" name="doc_passportphoto" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_passportphoto" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Passport Photocopy</td>
		</tr>
		<tr>
			<td class="style1" colspan="2"><Cfif #doc_resume# Eq '0'><input type="checkbox" name="doc_resume" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_resume" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Resume</td>
			<td class="style1" colspan="2"><Cfif #doc_insu# Eq '0'><input type="checkbox" name="doc_insu" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_insu" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Medical Insurance Appli.</td>
		</tr>
		<tr>
			<td class="style1" colspan="2"><Cfif #doc_proficiency# Eq '0'><input type="checkbox" name="doc_proficiency" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_proficiency" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Proeficiency Verification</td>
			<td class="style1" colspan="2"><Cfif #doc_sponsor_letter# Eq '0'><input type="checkbox" name="doc_sponsor_letter" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_sponsor_letter" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Home Sponsor Letter</td>
		</tr>
		<tr>
			<td class="style1" colspan="4"><Cfif #doc_recom_letter# Eq '0'><input type="checkbox" name="doc_recom_letter" <cfif edit EQ 'no'>disabled</cfif>> <cfelse> <input type="checkbox" name="doc_recom_letter" checked <cfif edit EQ 'no'>disabled</cfif> > </cfif> Letters of Recommendation</td>
		</tr>
		<tr>
			<td class="style1" colspan="4"><font face="" color="Gray"><b> Missing Documents:</b></font> <cfif edit EQ 'no'>#missing_documents#<cfelse><textarea name="missing_documents" cols="25" rows="3">#missing_documents#</textarea></cfif></td>
		</tr>
	</table>
	
	</td>
</tr>
</table>
				

	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="50%">
		<span class="application_section_header"><b>Citizenship</b></span><br>
			<table>
				<tr>
					<td width="150"><font color="Gray" size="2"><b>Place of Birth:</b></font></td>
					<td width="180"> <font size="2">#birth_city#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Country of Birth:</b></font></td>
					<td> <font size="2">
					
						<cfloop query="countrylist">
							<cfif countryid EQ get_candidate_unqid.birth_country> #countryname#</cfif>
						</cfloop>
						
					</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Country of Citizenship:</b></font></td>
					<td> <font size="2">
					
						<cfloop query="countrylist">
							<cfif countryid EQ get_candidate_unqid.citizen_country> #countryname#</cfif>
						</cfloop>
					
					</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Country of Residence:</b></font></td>
					<td> <font size="2">
					
						<cfloop query="countrylist">
							<cfif countryid EQ get_candidate_unqid.residence_country> #countryname#</cfif>
						</cfloop>
					
					</font></td>
				</tr>
				<tr>
					<td><font size="2">&nbsp;</font></td>
					<td><font size="2">&nbsp;</font></td>
				</tr>
			</table>
		</td>
		<td width="50%">
		<span class="application_section_header"><b>MAILING ADDRESS</b></span><br>
			<table>
				<tr>
					<td width="30%"><font color="Gray" size="2"><b>Address:</b></font></td>
					<td width="70%"><font size="2">#home_address#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>City:</b></font></td>
					<td><font size="2">#home_city#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Country:</b></font></td>
					<td><font size="2">
					
						<cfloop query="countrylist">
							<cfif countryid EQ get_candidate_unqid.home_country> #countryname#</cfif>
						</cfloop>

					</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Phone:</b></font></td>
					<td><font size="2">#home_phone#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Email:</b></font></td>
					<td><font size="2">#email#</font></td>
				</tr>
			</table>
		</td>
		</tr>
		<tr>
			<td colspan="2"><font color="Gray" size="2"><b>Personal Info / Preferences:</b></font> #personal_info#
			</td>
		</tr>
		<tr>
			<td colspan="2">
				
				<table width="90%" cellpadding="1" cellspacing="0" border="0" bgcolor="CCCCCC" align="center">
					<tr>
					 <td>

						<table width="100%" cellpadding="3" cellspacing="0" border="0" bgcolor="F7F7F7">
							<tr>
								<td colspan="4"><font color="Gray" size="2"><b>Emergency Contact</b></font></td>
							</tr>
							<tr>
								<td width="10%"><font color="Gray" size="2"><b>Name:</b></font></td>
								<td width="50%"><font size="2">#emergency_name#</font></td>
								<td width="10%"><font color="Gray" size="2"><b>Phone:</b></font></td>
								<td width="30%"><font size="2">#emergency_phone#</font></td>
						</table>
						

					 </td>
					</tr>
				</table>
				
			</td>
		</tr>
	</table>
	
	
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="100%">
		<span class="application_section_header"><b>Degree Information</b></span><br>
			<table>
				<tr>
					<td width="10%"><font color="Gray" size="2"><b>Degree:</b></font></td>
					<td width="36%"> <font size="2">#degree#</font></td>
					<td width="16%"><font color="Gray" size="2"><b>Work Experience:</b></font></td>
					<td width="36%"> <font size="2">
										<cfif #degree_other# eq ''> n/a <cfelse>
										 #degree_other#
										</cfif></font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Category: </td>
					<td> <font size="2"><cfif 'getCategory.recordcount' eq 0> n/a <cfelse>
										<cfquery name="getCategory" datasource="MySql">
											SELECT DISTINCT fieldstudy
											FROM extra_sevis_fieldstudy
											WHERE fieldstudyid = '#get_candidate_unqid.fieldstudyid#'
										</cfquery>
										#getCategory.fieldstudy# </cfif>
									</b></font></font></td>
					<td><font color="Gray" size="2"><b>Sub-Category: 
									</b></font></td>
					<td> <font size="2"><cfif 'getSubCategory.recordcount' eq 0>n/a<cfelse>
										<cfquery name="getSubCategory" datasource="MySql">
											SELECT DISTINCT subfield
											FROM extra_sevis_sub_fieldstudy
											WHERE subfieldid = '#get_candidate_unqid.subfieldid#'
										</cfquery>
										#getSubCategory.subfield# </cfif>
										</font></td>
				</tr>
				<tr>
					<td colspan="4"><font color="Gray" size="2"><b>Comments / Evaluation:</b></font> <font size="2">#degree_comments#</font></td>
				</tr>
			</table>
		</td>
		</tr>
	</table>


 	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr valign="top">
			<td width="100%" valign="top">
			<span class="application_section_header"><b>Program Information</b></span><br>
				<table>
					<tr>
					<!---	<td width="17%"><font color="Gray" size="2"><b>Earliest Arrival:</b></font></td>--->
						<!---<td width="33%"> <font size="2">#dateformat (earliestarrival, 'mm/dd/yyyy')# </font></td>--->
						<td width="15%"><font color="Gray" size="2"><b>Arrival Date:</b> </td>
						<td><font color="black" size="2">#dateformat (arrivaldate, 'mm/dd/yyyy')#</font></td>

						<td><font color="Gray" size="2"><b>Start Date:</b></td>		
						<td> <font color="black" size="2">#dateformat (startdate, 'mm/dd/yyyy')#</font></td>				
						<td><font color="Gray" size="2"><b>End Date:</b> </td>
						<td><font color="black" size="2"> #dateformat (enddate, 'mm/dd/yyyy')#</font></td>

					<td colspan="4"><font color="Gray" size="2"><b>Remarks:</b></font><font size="2"> #remarks#</font></td>
						
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<!----<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr valign="top">
			<td width="100%" valign="top">
			<span class="application_section_header"><b>Form DS-2019</b></span><br>
			<table>
				<tr>
					<td width="10%"><font color="Gray" size="2"><b>No.:</b></font></td>
					<td width="70%" colspan="3"><font size="2">#ds2019#</font></td>
				</tr>
				<tr>
					<td width="10%"><font color="Gray" size="2"><b>Subject/Field:</b></font></td>
					<td width="40%"><font size="2">#ds2019_position#</font></td>
					<td width="10%"><font color="Gray" size="2"><b>Subject/Field Code:</b></font></td>
					<td width="40%"><font size="2">#ds2019_subject#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Street:</b></font></td>
					<td><font size="2">#ds2019_street#</font></td>
					<td><font color="Gray" size="2"><b>City:</b></font></td>
					<td><font size="2">#ds2019_city#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>State:</b></font></td>
					<td><font size="2">#ds2019_state#</font></td>
					<td><font color="Gray" size="2"><b>Zip:</b></font></td>
					<td><font size="2">#ds2019_zip#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Start:</b></font></td>
					<td><font size="2">#dateformat (ds2019_startdate, 'mm/dd/yyyy')#</font></td>
					<td><font color="Gray" size="2"><b>End:</b></font></td>
					<td><font size="2">#dateformat (ds2019_enddate, 'mm/dd/yyyy')#</font></td>
				</tr>
			</table>
			
			</td>
		</tr>
	</table>
 --->
 


</cfoutput>
</cfdocument>