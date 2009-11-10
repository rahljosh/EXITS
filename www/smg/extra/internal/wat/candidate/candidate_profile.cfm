<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../profile.css">
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
	WHERE companyid = '#client.companyid#'
</Cfquery>

<cfinclude template="../querys/get_candidate_unqid.cfm">
<cfinclude template="../querys/countrylist.cfm">
<cfinclude template="../querys/fieldstudy.cfm">
<cfinclude template="../querys/program.cfm">

<Cfquery name="candidate_place_company" datasource="MySQL">
	SELECT *
	FROM extra_candidate_place_company
	WHERE candidateid = '#get_candidate_unqid.candidateid#'
	ORDER BY candcompid DESC
</Cfquery>

<!-----Int Rep----->
<Cfquery name="int_Reps" datasource="MySQL">
	SELECT userid, firstname, lastname, businessname, country
	FROM smg_users
	WHERE usertype = 8
	AND active = '1'
	AND userid = '#get_candidate_unqid.intrep#'
</Cfquery>

<Cfquery name="hostcompany" datasource="MySQL">
	SELECT name, hostcompanyid
	FROM extra_hostcompany
	ORDER BY name
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
		 <b>Intl. Agent:</b> #int_Reps.businessname#<br>
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
		
		<br></td>
	</div><td><!----<cfif client.usertype gte 8><img src="http://www.phpusa.com/internal/../pics/dmd-logo.jpg"><cfelse>----><img src="../../../images/extra-logo.jpg" width="60" height="81" border=0><!----</cfif>----></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<td bgcolor="F3F3F3" valign="top" width=133><div align="left">
		<cfif '#FileExists('#expandPath("../../uploadedfiles/web-candidates/#candidateid#.jpg")#')#'>
			<img src="../../uploadedfiles/web-candidates/#candidateid#.jpg" width="135">
		<cfelse>
			<img src="../../pics/no_stupicture.jpg" width="137" height="137">
		</cfif>
	<br></div></td>
	<td valign="top" width=504>
	<span class="application_section_header"><b>CANDIDATE PROFILE</b></span><br>
	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
		<tr><td width="50"><font face="" color="Gray"><b>Name:</b> </font><b></td><td>#firstname# #middlename# #lastname# (#candidateid#)</b></td></tr>	
		<tr><td><font face="" color="Gray"><b>Sex:</b> </font></td><td><cfif sex EQ 'm'>Male<cfelse>Female</cfif></td></tr>
		<tr><td><font face="" color="Gray"><b>DOB:</b> </font></td><td><cfif dob EQ ''>n/a<cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old</cfif></td></tr>

<cfquery name="get_candidate_unqid_requested" datasource="mysql">
	SELECT *
	FROM extra_candidates
	INNER JOIN extra_hostcompany ON extra_hostcompany.hostcompanyid = extra_candidates.requested_placement
	WHERE uniqueid = <cfqueryparam value="#url.uniqueid#" cfsqltype="cf_sql_char">
	
</cfquery>

		
		<tr><td><font face="" color="Gray"><b>Requested Placement:</b> </font></td><td> #get_candidate_unqid_requested.name#  </td></tr>
		
	</table>
	
	<br> 		
	
	<!---- MAILING ADDRESS ---->	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px" width="100%">
		<tr bgcolor="C2D1EF">
			<td colspan="4" class="application_section_header"><b>Mailing Address</b></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="15%"><font color="Gray" size="2"><b>Address:</b></font></td>
			<td width="35%"><font size="2">#home_address#</font></td>
			<td width="15%"><font color="Gray" size="2"><b>City:</b></font></td>
			<td width="35%"><font size="2">#home_city#</font></td>
		</tr>
		<tr>
			<td><font color="Gray" size="2"><b>Zip:</b></font></td>
			<td><font size="2">#home_zip#</font></td>
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
			<td><font color="Gray" size="2"><b>Email:</b></font></td>
			<td><font size="2">#email#</font></td>
		</tr>
	</table>
	
	</td>
</tr>
</table>
			<!---- ticket 1067 ------	
<br>
	<!---- CITIZENSHIP ---->
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
			</table>
		</td>
		<td width="50%" valign="top">
		
		<!---- EMERGENCY CONTACT ---->
		<span class="application_section_header"><b>Emergency Contact</b></span><br>
			<table>
				<tr>
					<td width="30%"><font color="Gray" size="2"><b>Name:</b></font></td>
					<td width="70%"><font size="2">#emergency_name#</font></td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Phone:</b></font></td>
					<td><font size="2">#emergency_phone#</font></td>
				</tr><!---- 1052 ----
				<tr>
					<td><font color="Gray" size="2"><b>Relationship:</b></font></td>
					<td><font size="2">#emergency_relationship#</font></td>
				</tr>--->
			</table>
			
		</td>
		</tr>
		<tr>
			<td colspan="2"><font color="Gray" size="2"><b>Personal Info / Preferences:</b></font> #personal_info#
			</td>
		</tr>
	</table>
				
			</td>
		</tr>
	</table>
	
	<br>
	<!---- ticket 1047 ---
	<!---- SCHOOL INFORMATION ---->
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="100%">
		<span class="application_section_header"><b>School Information</b></span><br>
		
			<table width="100%">
				<tr>
					<td colspan="4"><font color="Gray" size="2"><b>Dates of the Official Vacation:</b></font></td>
				</tr>
				<tr>
					<td width="10%"><font color="Gray" size="2"><b>Start Date:</b></font></td>
					<td width="40%"> <font size="2">#dateformat (wat_vacation_start, 'mm/dd/yyyy')#</font></td>
					<td width="10%"><font color="Gray" size="2"><b>End Date:</b></font></td>
					<td width="40%"> <font size="2">#dateformat (wat_vacation_end, 'mm/dd/yyyy')#</font></td>
				</tr>
			</table>
			
		</td>
		</tr>
	</table>
	
	<br> ----> 
	
	<!---- PASSPORT INFORMATION ---->
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="100%">
		<span class="application_section_header"><b>Passport Information</b></span><br>
		
			<table>
				<tr>
					<td width="15%"><font color="Gray" size="2"><b>Passport No.:</b></font></td>
					<td width="35%"> <font size="2">#passport_number#</font></td>
					<td width="16%"><font color="Gray" size="2"><b>Country Issued:</b></font></td>
					<td width="34%"> <font size="2">
						<cfloop query="countrylist">
							<cfif countryid EQ get_candidate_unqid.passport_country> #countryname#</cfif>
						</cfloop></font>
					</td>
				</tr>
				<tr>
					<td><font color="Gray" size="2"><b>Date Issued:</b></font></td>
					<td> <font size="2">#dateformat (passport_date, 'mm/dd/yyyy')#</font></td>
					<td><font color="Gray" size="2"><b>Date Expires::</b></font></td>
					<td> <font size="2">#dateformat (passport_expires, 'mm/dd/yyyy')#</font></td>
				</tr>
			</table>
			
		</td>
		</tr>
	</table>
	
	<br>

	<!---- PROGRAM INFORMATION ---->
 	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr valign="top">
			<td width="100%" valign="top">
			<span class="application_section_header"><b>Program Information</b></span><br>
				<table>
					<tr>
						<td width="21%"><font color="Gray" size="2"><b>Earliest Arrival:</b></font></td>
						<td width="29%"> <font size="2">#dateformat (earliestarrival, 'mm/dd/yyyy')# </font></td>
						<td width="15%"><font color="Gray" size="2"><b>Latest Arrival:</b></font></td>
						<td width="35%"> <font size="2">#dateformat (latestarrival, 'mm/dd/yyyy')#</font></td>
					</tr>
	<!---- ticket 1047				<tr>
						<td><font color="Gray" size="2"><b>Requested Length:</b></font></td>
						<td> <font size="2">#wat_length# <cfif wat_length NEQ ''>weeks</cfif></font></td>
						<td><font color="Gray" size="2"><b>Placement:</b></font></td>
						<td> <font size="2">#wat_placement#</font></td>
					</tr> ------->
					
					<tr>
						<td colspan="4"><font color="Gray" size="2"><b>Number of Participation in the Program:</b></font> <font size="2">#wat_participation# times</font></td>
					</tr>
					
					<!---- 1047 #3 --->
					
						<tr>
						<td width="21%"><font color="Gray" size="2"><b>Start Date:</b></font></td>
						<td width="29%"> <font size="2">#dateformat (startdate, 'mm/dd/yyyy')# </font></td>
						<td width="15%"><font color="Gray" size="2"><b>End Date:</b></font></td>
						<td width="35%"> <font size="2">#dateformat (enddate, 'mm/dd/yyyy')#</font></td>
					</tr>
									
					
					
				</table>
			</td>
		</tr>
	</table>
	
	<br>

	<!---- HOST COMPANY INFORMATION ---->
 	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr valign="top">
			<td width="100%" valign="top">
			<span class="application_section_header"><b>Host Company Information</b></span><br>
				<table width="100%">
					<tr>
						<td width="18%"><font color="Gray" size="2"><b>Company Name:</b></font></td>
						<td width="32%"> <font size="2">
							<cfloop query="hostcompany">
								<cfif hostcompanyid EQ candidate_place_company.hostcompanyid> #name#</cfif>
							</cfloop></font>
						</td>
						<td width="12%"><font color="Gray" size="2"><b>Status:</b></font></td>
						<td width="38%"> <font size="2"><cfif candidate_place_company.status EQ '1'>Yes</cfif><cfif candidate_place_company.status EQ '0'>No</cfif></font></td>
					</tr>
					<tr>
						<td><font color="Gray" size="2"><b>Start Date:</b></font></td>
						<td> <font size="2">#dateformat (candidate_place_company.startdate, 'mm/dd/yyyy')# </font></td>
						<td><font color="Gray" size="2"><b>End Date:</b></font></td>
						<td> <font size="2">#dateformat (candidate_place_company.enddate, 'mm/dd/yyyy')#</font></td>
					</tr>
					<tr>
						<td colspan="4"><font color="Gray" size="2"><b>Confirmation Received:</b></font> <font size="2"><cfif candidate_place_company.confirmation_received EQ '1'>Yes</cfif><cfif candidate_place_company.confirmation_received EQ '0'>No</cfif></font></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
closing ticket 1067 ------------>
			</td>
		</tr>
	</table>
 
</cfoutput>