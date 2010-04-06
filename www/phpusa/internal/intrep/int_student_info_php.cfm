<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>PHP Student Info</title>
</head>

<body>

<cfif isdefined('url.unqid')>
	<cfquery name="get_unqid" datasource="MySql">
		SELECT *
		FROM smg_students
		WHERE uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = #get_unqid.studentid#>
	
</cfif>

<cfquery name="get_student_info" datasource="mysql">
	SELECT s.studentid, s.uniqueid, s.familylastname, s.firstname, s.middlename, s.fathersname, s.fatheraddress,
		s.fatheraddress2, s.fathercity, s.fathercountry, s.fatherzip, s.fatherbirth, s.fathercompany, s.fatherworkphone,
		s.fatherworkposition, s.fatherworktype, s.fatherenglish, s.motherenglish, s.mothersname, s.motheraddress,
		s.motheraddress2, s.mothercity, s.mothercountry, s.motherzip, s.motherbirth, s.mothercompany, s.motherworkphone,
		s.motherworkposition, s.motherworktype, s.emergency_phone, s.emergency_name,s. emergency_address, 
		s.emergency_country, s.address, s.address2, s.city, s.country, s.zip, s.phone, s.fax, s.email, s.citybirth, s.countrybirth,
		s.countryresident, s.countrycitizen, s.sex, s.dob, s.religiousaffiliation, s.dateapplication, s.entered_by,
		s.passportnumber, s.intrep, s.branchid, s.current_state, s.approved, s.band, s.orchestra, s.comp_sports, 
		s.familyletter, s.pictures, s.interests, s.interests_other, s.religious_participation, s.churchfam, s.churchgroup,
		s.smoke, s.animal_allergies, s.med_allergies, s.other_allergies, s.chores, s.chores_list, s.weekday_curfew, 
		s.weekend_curfew, s.letter, s.height, s.weight, s.haircolor, s.eyecolor, s.graduated, s.direct_placement, 
		s.direct_place_nature, s.insurance, s.cancelinsurancedate, s.termination_date, 
		s.notes, s.yearsenglish, s.estgpa, s.transcript, s.language_eval, s.social_skills, s.health immunization, s.health,
		s.minorauthorization, s.placement_notes, s.needs_smoking_house, s.likes_pets, s.accepts_private_high,
		s.app_completed_school, s.visano, s.grades, s.slep_Score, s.convalidation_needed, s.other_missing_docs,
		s.verification_received, s.flight_info_notes, s.scholarship, s.app_current_status, s.php_wishes_graduate, s.php_grade_student,
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no, stu_prog.i20received, stu_prog.doubleplace, 
		stu_prog.canceldate, stu_prog.cancelreason, stu_prog.hf_placement, stu_prog.hf_application, 
		stu_prog.sevis_fee_paid,
		php_schools.schoolname
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN php_schools ON php_schools.schoolid = stu_prog.schoolid
	WHERE s.studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY assignedid DESC
</cfquery>

<!----International Rep---->
<cfquery name="int_Agent" datasource="MySQL">
	SELECT  u.userid, u.businessname, u.firstname, u.lastname, u.master_accountid, u.accepts_sevis_fee, u.insurance_typeid, insu.type
	FROM smg_users u
	LEFT JOIN smg_insurance_type insu ON insu.insutypeid = u.insurance_typeid
	WHERE u.userid = '#get_student_info.intrep#'
</cfquery>

<!--- error message if the student is not found --->
<cfif get_student_info.recordcount is 0>
	The student ID you are looking for, <cfoutput>#get_uniqid.studentid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the student record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the student
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<!--- error message if student does not belong to current int. rep --->
<cfif get_Student_info.intrep NEQ client.userid AND get_Student_info.branchid NEQ client.userid AND int_Agent.master_accountid NEQ client.userid><br>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><h3><p>You are trying to access a student that does not belong to your company.</p></h3>
	<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<cfquery name="get_stu_company" datasource="MySql">
	SELECT companyname, companyshort
	FROM smg_companies
	WHERE companyid = '#get_student_info.companyid#'
</cfquery>

<cfquery name="program" datasource="mysql">
	select programname, programid
	from smg_programs
	where programid = '#get_student_info.programid#'
</cfquery>

<cfquery name="get_branches" datasource="MySQL">
	select userid, businessname
	from smg_users 
	where intrepid = '#get_Student_info.intrep#'
	<cfif get_student_info.intrep NEQ client.userid>	
		AND userid = '#client.userid#'
	</cfif>
	ORDER BY businessname
</cfquery>

<cfquery name="get_super_rep" datasource="MySQL">
	Select firstname, lastname, userid from smg_users 
	where userid = '#get_Student_info.arearepid#'
</cfquery>

<cfquery name="get_place_rep" datasource="MySQL">
	Select firstname, lastname, userid from smg_users 
	where userid = '#get_Student_info.placerepid#'
</cfquery>

<!----Header Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height="24">
	<tr valign=middle height="24">
		<td height="24" width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Student Information </td><td background="pics/header_background.gif" align="right"></td>
		<td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput query="get_student_info">
<div class="section">
<table align="center" width="75%">  
	<tr><td align="center" colspan="2"><h2>#get_stu_company.companyname#</h2></td></tr>
	<tr>
		<td>
			<cfif get_student_info.schoolid EQ 0 AND get_student_info.canceldate EQ ''>
			<table background="pics/unplaced.jpg" cellpadding="2" width="100%"> 
			<cfelseif get_student_info.schoolid EQ 0 and get_student_info.canceldate NEQ ''>
			<table background="pics/canceled.jpg" cellpadding="2" width="100%"> 
			<cfelse>
			<table width=100% align="Center" cellpadding="3">				
			</cfif>
				<tr>
					<td width="133">
						<table width="100%" cellpadding="3">
							<tr><td><td width="133">
								<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#client.studentid#.*">
								<cfif file.recordcount>
									<img src="uploadedfiles/web-students/#file.name#" width="135">
								<cfelse>
									<img src="pics/no_stupicture.jpg" width="135">
								</cfif>
							</td></tr>
						</table>
					</td>
					<td valign="top">
						<table width="100%" cellpadding="3">
							<tr><td align="center" colspan="2"><h1>#firstname# #middlename# #familylastname# (#studentid#)</h1></td></tr>
							<tr><td align="center" colspan="2"><font size=-1><span class="edit_link">[ <a href='?curdoc=intrep/int_student_profile_php&unqid=#uniqueid#'>PROFILE</a></span></font> ]</td></tr>
			 				<tr><td align="center" colspan="2"><cfif dob is ''><cfelse>#dateformat (dob, 'mm/dd/yyyy')# - #datediff('yyyy',dob,now())# year old #sex# </cfif></td></tr> 
							<tr><td align="right">Intl. Rep. : </td><td>#int_agent.businessname#</td></tr>
							<tr><td align="right">Branch : </td>
								<cfif get_student_info.intrep EQ client.userid>
									<cfform name="branch" action="?curdoc=intrep/qr_int_student_info" method="post">
										<cfinput type="hidden" name="php" value="php">
										<cfinput type="hidden" name="studentid" value="#studentid#">
											<td valign="middle"><cfselect name="branchid">
												<option value="0">Main Office</option>
												<cfloop query="get_branches">
												<option value="#userid#" <cfif get_student_info.branchid EQ	get_branches.userid>selected</cfif>>#businessname#</option>
												</cfloop>
												</cfselect>
												&nbsp; &nbsp; <cfinput name="submit" type="image" src="pics/update.gif" border=0 alt=" update branch information ">
											</td>
									</cfform>
								<cfelse>
									<td>#get_branches.businessname#</td>
								</cfif>
							</tr>							
							<tr><td align="right">Date of Entry : </td><td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td></tr>
							<tr><td align="right"><cfif #canceldate# is not ''><cfelse><cfif #active# is 1><input type="checkbox" name="active" checked="Yes" disabled><cfelse><input type="checkbox" name="active" disabled></cfif></td><td>Student is Active</td></cfif></tr>														
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td align="right" valign="top">
			<div id="subMenuNav"> 
				<div id="subMenuLinks">  
				<a href="" onClick="javascript: win=window.open('virtualfolder/list_vfolder.cfm?unqid=#get_student_info.uniqueid#', 'Settings', 'height=600, width=700, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Virtual Folder</a>		
				<a class=nav_bar href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?stuid=#client.studentid#', 'Reports', 'height=250, width=620, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A>  
				<a class=nav_bar href="" onClick="javascript: win=window.open('intrep/int_flight_info.cfm?unqid=#get_student_info.uniqueid#', 'Settings', 'height=500, width=740, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Flight Information</A>
			
				<cfif get_student_info.hostid NEQ '0'>
					<a class=nav_bar href="index.cfm?curdoc=intrep/int_host_fam_info&hostid=#get_student_info.hostid#">Host Family</A>
				</cfif>
				
				</div>
			</div>
		</td>
	</tr>
</table>

<table align="center" width="75%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>:: </b></span>Program</td></tr>
				<tr><td>Program :</td><td><cfif program.recordcount NEQ '0'>#program.programname#<cfelse>n/a</cfif></td></tr>
				<tr><td>Supervising Rep. :</td><td><cfif get_Student_info.arearepid is 0>Not Assigned<cfelse>#get_super_rep.firstname# #get_super_rep.lastname#</cfif></td></tr>
				<tr><td>Placing Rep. :</td><td><cfif get_Student_info.placerepid is 0>Not Assigned<cfelse>#get_place_rep.firstname# #get_place_rep.lastname#</cfif> </td></tr>												
			</table>
		</td>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>:: </b></span>School</td></tr>
				<tr><td>Name :</td><td><cfif schoolid NEQ '0'>#schoolname#<cfelse>n/a</cfif></td></tr>
			</table>	
		</td>	
	</tr>
</table>

<table align="center" width="75%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="3"><span class="get_attention"><b>:: </b></span>DS-2019 Form</td></tr>
				<tr>		
					<td width="4"><Cfif verification_received EQ ''><input type="checkbox" name="verification_box" disabled> <cfelse> <input type="checkbox" name="verification_box" checked disabled> </cfif>
					<td>I-20 Verification Received &nbsp; Date: &nbsp; #DateFormat(verification_received, 'mm/dd/yyyy')#</td>
				</tr>
				<tr><td></td><td>I-20 number : &nbsp; <cfif i20no EQ ''>n/a<cfelse>#i20no#</cfif></td></tr>	
				<tr>
					<td width="4"><cfif int_Agent.accepts_sevis_fee EQ '1'><input type="checkbox" name="accepts_sevis_fee" checked disabled><cfelse><input type="checkbox" name="accepts_sevis_fee" disabled></cfif></td>
					<td><cfif int_Agent.accepts_sevis_fee EQ ''>
							<font color="FF0000">SEVIS Fee Information is missing</font>
						<cfelseif int_Agent.accepts_sevis_fee EQ '0'>
							Intl. Agent does not accept SEVIS Fee
						<cfelseif int_Agent.accepts_sevis_fee EQ '1'>
							Intl. Agent Accepts SEVIS Fee
						</cfif>
					</td>
				</tr>
				<cfif int_Agent.accepts_sevis_fee EQ '1'>
				<tr><td></td><td>Fee Status: &nbsp; <cfif sevis_fee_paid EQ ''>Unpaid <cfelse>Paid  on: &nbsp; #DateFormat(sevis_fee_paid, 'mm/dd/yyyy')#</cfif></td></tr>	
				</cfif>
			</table>
		</td>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="3"><span class="get_attention"><b>:: </b></span>Insurance</td></tr>
				<tr>
					<td width="10"><cfif int_Agent.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
					<td align="left" colspan="2"><cfif int_Agent.insurance_typeid EQ '0'> <font color="FF0000">Insurance Information is missing</font>
						<cfelseif int_Agent.insurance_typeid EQ '1'> Does not take Insurance Provided by SMG
						<cfelse> Takes Insurance Provided by SMG</cfif>
					</td>
				</tr>
				<tr>
					<td><cfif int_Agent.insurance_typeid LTE '1'><input type="checkbox" name="insurance_check" disabled><cfelse><input type="checkbox" name="insurance_check" checked disabled></cfif></td>
					<td>Policy Type :</td>
					<td align="left">
						<cfif int_Agent.insurance_typeid EQ '0'>
							<font color="FF0000">Missing Policy Type</font>
						<cfelseif int_Agent.insurance_typeid EQ '1'> n/a
						<cfelse> #int_Agent.type#	</cfif>		
					</td>
				</tr>
				<tr><td><Cfif insurance is ''><input type="checkbox" name="insured_date" disabled><Cfelse><input type="checkbox" name="insured_date" checked disabled></cfif></td>
					<td>Insured Date :</td>
					<td>#DateFormat(insurance, 'mm/dd/yyyy')#</td></tr>
				<tr><td><Cfif cancelinsurancedate is ''><input type="checkbox" name="insurance_Cancel" disabled><Cfelse><input type="checkbox" name="insurance_Cancel" checked disabled></cfif></td>
					<td>Canceled on :</td>
					<td>#DateFormat(cancelinsurancedate, 'mm/dd/yyyy')#</td></tr>
			</table>	
		</td>	
	</tr>
</table>

<table align="center" width="75%">
	<tr>
		<td width="50%" valign="top">
			<!----
			<table cellpadding="3" width="100%">
				<tr bgcolor="e2efc7"><td colspan="2"><span class="get_attention"><b>:: </b></span>Letters</td></tr>
				<tr><td>: : <a href="" onClick="javascript: win=window.open('reports/acceptance_letter.cfm', 'Settings', 'height=480,width=800, location=yes, scrollbars=yes,  toolbar=yes, menubar=yes, resizable=yes'); win.opener=self; return false;">Acceptance Letter</a></td></tr>
				<tr><td><cfif get_student_info.schoolid NEQ '0'>: : <a href="" onClick="javascript: win=window.open('reports/placement_letter.cfm', 'Settings', 'height=480,width=800, location=yes, scrollbars=yes,  toolbar=yes, menubar=yes, resizable=yes'); win.opener=self; return false;">Placement</a> &nbsp;</cfif></td></tr>
				<tr><td><cfif get_student_info.schoolid NEQ '0'>: : <a href="" onClick="javascript: win=window.open('intrep/int_flight_information_letter.cfm?unqid=#get_student_info.uniqueid#', 'Settings', 'height=480,width=800, location=yes, scrollbars=yes,  toolbar=yes, menubar=yes, resizable=yes'); win.opener=self; return false;">Flight Information</a></cfif></td></tr>
			</table>
			--->
		</td>
		<td width="50%" valign="top">
			<table cellpadding="3" width="100%">
			</table>	
		</td>	
	</tr>
</table>
</div>

</cfoutput>
<cfinclude template="../table_footer.cfm">

</body>
</html>
