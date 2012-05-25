<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>Student Profile</title>
</head>
<body>

<script type="text/javascript">
<!--
// open online application 
function OpenApp(url) {
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<cfif isdefined('URL.unqid')>
	<cfquery name="qGetStudentByUniqueID" datasource="MySql">
		SELECT *
		FROM smg_students
		WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.unqid#">
	</cfquery>
	<cfset client.studentid = qGetStudentByUniqueID.studentid>
</cfif>

<cfquery name="qGetStudentInfo" datasource="mysql">
	SELECT s.studentid, s.uniqueid, s.familylastname, s.firstname, s.middlename, s.fathersname, s.fatheraddress,
		s.fatheraddress2, s.fathercity, s.fathercountry, s.fatherzip, s.fatherDOB, s.fathercompany, s.fatherworkphone,
		s.fatherworkposition, s.fatherworktype, s.fatherenglish, s.motherenglish, s.mothersname, s.motheraddress,
		s.motheraddress2, s.mothercity, s.mothercountry, s.motherzip, s.motherDOB, s.mothercompany, s.motherworkphone,
		s.motherworkposition, s.motherworktype, s.emergency_phone, s.emergency_name,s. emergency_address, 
		s.emergency_country, s.address, s.address2, s.city, s.country, s.zip, s.phone, s.fax, s.email, s.citybirth, s.countrybirth,
		s.countryresident, s.countrycitizen, s.sex, s.dob, s.religiousaffiliation, s.entered_by,
		s.passportnumber, s.intrep, s.current_state, s.approved, s.band, s.orchestra, s.comp_sports, 
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
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no, stu_prog.i20received, 
		stu_prog.doubleplace, stu_prog.canceldate, stu_prog.cancelreason, stu_prog.hf_placement, stu_prog.hf_application, 
		stu_prog.sevis_fee_paid, stu_prog.datecreated, php_schools.schoolname
	FROM smg_students s
	INNER JOIN 
    	php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN 
    	php_schools ON php_schools.schoolid = stu_prog.schoolid
	WHERE 
    	s.studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY assignedid DESC
</cfquery>

<cfinclude template="../querys/get_students_host.cfm">

<cfscript>
	vFatherAge = "";
	vMotherAge = "";
	
	if ( isDate(qGetStudentInfo.fatherDOB) ) {
		vFatherAge = "(#DateDiff('yyyy', qGetStudentInfo.fatherDOB, now())# years old)";
	}

	if ( isDate(qGetStudentInfo.motherDOB) ) {
		vMotherAge = "(#DateDiff('yyyy', qGetStudentInfo.motherDOB, now())# years old)";
	}
</cfscript>

<cfif qGetStudentByUniqueID.recordcount EQ 0> <!--- Block if they try to cheat changing the student id in the address bar --->
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
			<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
	</table>
	<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td align="center"><br><div align="justify"><h3>
		The student ID you are looking for, <cfoutput>#url.studentid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
		<ul>
			<li>the student record was deleted or renumbered
			<li>the link you are following is out of date
			<li>you do not have proper access rights to view the student
		</ul>
			If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
			</p></h3></div>
		</td>
	</tr>
	<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
		<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
			<td width=100% background="pics/header_background_footer.gif"></td>
			<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
	</table>
	<cfabort>
</cfif>

<Cfquery name="religion" datasource="MySQL">
select religionname 
from smg_religions
where religionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.religiousaffiliation)#">
</cfquery>

<cfquery name="int_Agent" datasource="MySQL">
select companyid, businessname
from smg_users 
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.intrep)#">
</cfquery>

<Cfquery name="companyshort" datasource="MySQL">
select companyshort
from smg_companies
where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.companyid)#">
</Cfquery>

<cfquery name="program_name" datasource="MySQL">
select programname
from smg_programs
where programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.programid)#">
</cfquery>

<cfquery name="get_siblings" datasource="MySQL">
Select name, liveathome, sex, birthdate, studentid, childid
From smg_student_siblings
Where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentid)#">
Order by birthdate
</cfquery>

<cfquery name="country_birth" datasource="MySql">
	SELECT countryname 
	FROM smg_countrylist	
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.countrybirth)#">
</cfquery>

<cfquery name="country_citizen" datasource="MySql">
	SELECT countryname  
	FROM smg_countrylist 
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.countrycitizen)#">
</cfquery>

<cfquery name="country_resident" datasource="MySql">
	SELECT countryname  
	FROM smg_countrylist
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.countryresident)#">
</cfquery>

<link rel="stylesheet" href="../profile.css" type="text/css">

<cfoutput>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td valign="top" width=180><span id="titleleft">
		 Intl. Agent: <cfif len(#int_agent.businessname#) gt  25>#Left(int_agent.businessname,22)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		 Date Entry: #DateFormat(qGetStudentInfo.datecreated, 'mmm d, yyyy')#<br>
		<Cfif qGetStudentInfo.hostid is not 0>
		 Date Placed:  #DateFormat(qGetStudentInfo.dateplaced, 'mmm d, yyyy')#
		<cfelse>
		 Today's Date: #DateFormat(now(), 'mmm d, yyyy')#<br>
		 Days Unplaced: #DateDiff('d',qGetStudentInfo.datecreated, now())#
	  </cfif></td> 
	<td valign="top"><div align="center">
		<font size=+2><b>#companyshort.companyshort#</b></font><br>
		Program: #program_name.programname#<br>
	</td>
	</div><td><img src="pics/logos/#client.companyid#.gif"  alt="" border="0" align="right"></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<td bgcolor="F3F3F3" valign="top" width=133><div align="left">
		<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#client.studentid#.*">
		<cfif file.recordcount>
			<img src="uploadedfiles/web-students/#file.name#" width="135">
		<cfelse>
			<img src="pics/no_stupicture.jpg" width="135">
		</cfif>
	<br>
	<!--- <td bgcolor="F3F3F3" valign="top" width=133><div align="left"><img <cfif #qGetStudentInfo.old_stuid# is 0>src="#CLIENT.exits_url#/pics/#client.studentid#.jpg"<cfelse> src="#CLIENT.exits_url#/pics/web-students/#client.studentid#.jpg"</cfif> width=133><br> --->
	</div></td>
	<td valign="top" width=504>
	<span class="application_section_header">STUDENT PROFILE</span><br><br>
	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
		<tr><td width="50"><font face="" color="Gray">Name: </font><b></td><td>#qGetStudentInfo.firstname# #qGetStudentInfo.middlename# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentid#)</b></td></tr>	
		<tr><td><font face="" color="Gray">Sex: </font></td><td>#qGetStudentInfo.sex#</td></tr>
		<tr><td><font face="" color="Gray">DOB: </font></td><td>#DateFormat(qGetStudentInfo.dob, 'mmm d, yyyy')#</td></tr>
	</table>
	<br> 
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr><td><font face="" color="Gray">Age:</font></td><td>#DateDiff('yyyy', qGetStudentInfo.dob, now())#</td><td></td><td><font face="" color="Gray">Smoker:</font></td><td>#qGetStudentInfo.smoke#</td></tr>
		<tr><td><font face="" color="Gray">Height:</font></td><td>#qGetStudentInfo.height#</td><td width=15%></td><td><font face="" color="Gray">Hair:</font></td><td>#qGetStudentInfo.haircolor#</td></tr>
		<tr><td><font face="" color="Gray">Weight:</font></td><td>#qGetStudentInfo.weight#</td><td></td><td><font face="" color="Gray">Eyes:</font></td><td>#qGetStudentInfo.eyecolor#</td></tr>					
	</table>
	<br>
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr><td align="center" width="360">
			<!--- ONLINE APPLICATION ---->
			<cfif qGetStudentInfo.app_current_status NEQ 0>
				<cfif #FileExists("uploadedfiles/letters/students/#qGetStudentInfo.studentid#.pdf")#>
					<a href="uploadedfiles/letters/students/#qGetStudentInfo.studentid#.pdf">Students Letter</a>
				<cfelse>
					<a href="javascript:OpenApp('student_app/section1/page5print.cfm');">Students Letter</a>
				</cfif>
				&nbsp &nbsp - &nbsp &nbsp
				<cfif #FileExists("uploadedfiles/letters/parents/#qGetStudentInfo.studentid#.pdf")#>
					<a href="uploadedfiles/letters/parents/#qGetStudentInfo.studentid#.pdf">Parents Letter</a>
				<cfelse>
					<a href="javascript:OpenApp('student_app/section1/page6print.cfm');">Parents Letter</a>
				</cfif>
				&nbsp &nbsp - &nbsp &nbsp
			<!--- REGULAR APPLICATION --->
			<cfelse>
				<a href="uploadedfiles/letters/students/#qGetStudentInfo.studentid#.pdf">Students Letter</a>
				&nbsp &nbsp - &nbsp &nbsp
				<a href="uploadedfiles/letters/parents/#qGetStudentInfo.studentid#.pdf">Parents Letter</a>
				&nbsp &nbsp - &nbsp &nbsp
			</cfif>
			<a href="student/index.cfm?action=printFlightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#">Flight Information</a>
			</td></tr>
	</table>
</table>
<br>

	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="50%">
		<span class="application_section_header">Citizenship</span><br>
			<table>
				<tr><td width="150"><font face="" color="Gray">Place of Birth:</font></td><td width="180">#qGetStudentInfo.citybirth#</td></tr>
				<tr><td><font face="" color="Gray">Country of Birth:</font></td><td>#country_birth.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Citizenship:</font></td><td>#country_citizen.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Residence:</font></td><td>#country_resident.countryname#</td></tr>
			</table>
		</td>
		<td width="50%">
		<span class="application_section_header">Religious Info</span><br>
			<table>
				<tr><td width="150"><font color="Gray">Religion:</font></td><td width="180">#religion.religionname#</td></tr>
				<tr><td><font color="Gray">Participation:</font></td><td>#qGetStudentInfo.religious_participation#</td></tr>
				<tr><td><font face="" color="Gray">Attend with host family:</font></td><td>#qGetStudentInfo.churchfam#</td></tr>
				<tr><td><font face="" color="Gray">Church groups:</font></td><td><cfif qGetStudentInfo.churchgroup is ''>n/a<cfelse>#qGetStudentInfo.churchgroup#</cfif></td></tr>
			</table>
		</td></tr>
	</table><br>
	
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header">Natural Parents & Family In Home Country</span><br> 
		<tr><td width="50%">
			<table>
				<tr><td width="100"><font color="Gray">Father:</font></td><td width="180">#qGetStudentInfo.fathersname# #vFatherAge#</td></tr>
				<tr><td><font color="Gray">Occupation:</font></td><td><cfif qGetStudentInfo.fatherworkposition is ''>n/a<cfelse>#qGetStudentInfo.fatherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#qGetStudentInfo.fatherenglish#</td></tr>
			</table>	
		</td>
		<td width="50%">
			<table>
				<tr><td width="100"><font color="Gray">Mother:</font></td><td width="180">#qGetStudentInfo.mothersname# #vMotherAge#</td></tr>
				<tr><td><font color="Gray">Occupation:</font></td><td><cfif qGetStudentInfo.motherworkposition is ''>n/a<cfelse>#qGetStudentInfo.motherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#qGetStudentInfo.motherenglish#</td></tr>
			</table>	
		</td>
		</tr>		
		<tr><td colspan="2">
		</cfoutput>
			<table>
				<tr><td><font face="" color="Gray">Siblings: &nbsp </font>
				<cfoutput query="get_siblings">
				#get_siblings.name# <cfif get_siblings.birthdate is ''><cfelse>#DateDiff('yyyy', get_siblings.birthdate, now())#
				year old</cfif> #iif(Sex is 'Female', de("Sister"), de("Brother"))# &nbsp &nbsp; 
				</cfoutput></td></tr>
			</table>
			</td></tr>
	</table><br>
	
	<cfoutput> 
  	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header">Academic and Language Evaluation</span>
		<tr>
		<td width="250"><font face="" color="Gray">Band: &nbsp </font><cfif qGetStudentInfo.band is ''><cfelse>#qGetStudentInfo.band#</cfif></td>
		<td width="200"><font face="" color="Gray">Orchestra: &nbsp </font><cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.orchestra#</cfif></td>
		<td width="200"><font face="" color="Gray">Est. GPA: &nbsp </font><cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.estgpa#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>	
		<tr>
   		<td><font face="" color="Gray">
			<cfif qGetStudentInfo.grades is '12'>Must be placed in: &nbsp </font>#qGetStudentInfo.grades#th grade<cfelse>				
				  Last Grade Completed: &nbsp </font><cfif qGetStudentInfo.grades is '0'>n/a<cfelse>#qGetStudentInfo.grades#th grade</cfif></cfif></td>
    	<td><font face="" color="Gray">Years of English: &nbsp </font><cfif qGetStudentInfo.yearsenglish is '0'>n/a<cfelse>#qGetStudentInfo.yearsenglish#</cfif></td>
		<td><font face="" color="Gray">Convalidation needed: &nbsp </font><cfif qGetStudentInfo.convalidation_needed is ''>no<cfelse>#qGetStudentInfo.convalidation_needed#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>
	</table><br>

	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header">Personal Information</span><br>
		<tr>
		<td width="110"><font face="" color="Gray">Allergies</font></td>
		<td width="140"><font face="" color="Gray">Animal: &nbsp </font><cfif qGetStudentInfo.animal_allergies is ''>no<cfelse>#qGetStudentInfo.animal_allergies#</cfif></td>
		<td width="200"><font face="" color="Gray">Medical Allergies: &nbsp </font><cfif qGetStudentInfo.med_allergies is ''>no<cfelse>#qGetStudentInfo.med_allergies#</cfif></td>
		<td width="200"><font face="" color="Gray">Other: &nbsp </font><cfif qGetStudentInfo.other_allergies is ''>no<cfelse>#qGetStudentInfo.other_allergies#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>
		<tr>
		<td colspan="4">
			<font face="" color="Gray">Interests: &nbsp </font>
			<cfloop list="#qGetStudentInfo.interests#" index="i">
				<cfquery name="get_interests" datasource="MySQL">
				Select interest 
				from smg_interests 
				where interestid = #i#
				</cfquery>
				#LCASE(get_interests.interest)#  &nbsp &nbsp
			</cfloop></td>
		</tr>	
		<tr><td> </td></tr>
		<tr>
		<td colspan="4"><div align="justify"><font face="" color="Gray">Comments: &nbsp </font>#qGetStudentInfo.interests_other#</div></td>
		</tr>
	</table>
</cfoutput>