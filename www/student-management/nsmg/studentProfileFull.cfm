<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="smg.css">
	<title>Student Profile</title>
</head>
<body>

<!--- CHECK SESSIONS --->
<cfinclude template="check_sessions.cfm">

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
	<cfif  isDefined('url.uniqued')>
    <cfif url.uniqueid is ''>
        You have not specified a valid studentid.
        <cfabort>
    </cfif>
</cfif>


<cfif isdefined('url.uniqueid') >
	<cfquery name="get_id" datasource="mysql">
		select studentid 
		from smg_students
		where uniqueid = '#url.uniqueid#'
	</cfquery>
	<cfset url.studentid = #get_id.studentid#>
</cfif>


<cfquery name="get_student_info" datasource="mysql">
	select *
	from smg_students
	where studentid = #url.studentid#
</cfquery>

<cfquery name="get_students_host" datasource="MySQL">
select smg_students.studentid, smg_students.hostid, smg_hosts.*
from smg_students inner join smg_hosts
where (smg_students.studentid = #url.studentid#) and (smg_students.hostid = smg_hosts.hostid)
</cfquery>

<cfif client.usertype GT 4> <!--- Block if they try to cheat changing the student id in the address bar --->
	<cfquery name="check_stu_region" datasource="MySql">
		SELECT regionid, companyid, userid 		FROM user_access_rights
			WHERE regionid = '#get_student_info.regionassigned#' 
			AND  userid = #client.userid#
	</cfquery>		
	<cfif get_Student_info.companyid is not #client.companyid# OR check_stu_region.recordcount is 0><br>
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
				<td background="pics/header_background.gif"><h2>Students View - Error </h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td align="center"><br><div align="justify"><h3>
							<p>You are trying to access a student that is not assigned to this company or to your region.</p>
							<p>If you have access rights to the company the student belongs to, you must change company views, then access the student.</p></h3></div></td></tr>
		<tr><td align="center"><input type="image" value="Back" onClick="history.go(-1)" src="pics/back.gif"></td></tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="regions" datasource="MySQL">
select regionname
from smg_regions
where regionid = #get_Student_info.regionassigned#
</cfquery>

<cfquery name="region_guarantee" datasource="MySQL">
select regionname
from smg_regions
where regionid = #get_Student_info.regionalguarantee#
</cfquery>

<Cfquery name="religion" datasource="MySQL">
select religionname, religionid
from smg_religions
where religionid = #get_Student_info.religiousaffiliation#
</cfquery>

<cfquery name="int_Agent" datasource="MySQL">
select companyid, businessname
from smg_users 
where userid = #get_Student_info.intrep#
</cfquery>

<Cfquery name="companyshort" datasource="MySQL">
select companyshort, companyshort_nocolor, team_id
from smg_companies
where companyid = #client.companyid#
</Cfquery>

<cfquery name="program_name" datasource="MySQL">
select programname
from smg_programs
where programid = #get_Student_info.programid#
</cfquery>

<cfquery name="get_siblings" datasource="MySQL">
Select name, liveathome, sex, birthdate, studentid, childid
From smg_student_siblings
Where studentid = #get_student_info.studentid#
Order by birthdate
</cfquery>

<cfquery name="country_birth" datasource="MySql">
	SELECT countryname 
	FROM smg_countrylist	
	WHERE countryid = '#get_student_info.countrybirth#'
</cfquery>

<cfquery name="country_citizen" datasource="MySql">
	SELECT countryname  
	FROM smg_countrylist 
	WHERE countryid = '#get_student_info.countrycitizen#'
</cfquery>

<cfquery name="country_resident" datasource="MySql">
	SELECT countryname  
	FROM smg_countrylist
	WHERE countryid = '#get_student_info.countryresident#'
</cfquery>

<cfquery name="get_state_guarantee" datasource="MySql">
	SELECT statename  
	FROM smg_states
	WHERE id = '#get_student_info.state_guarantee#'
</cfquery>
	
<link rel="stylesheet" href="profile.css" type="text/css">

<cfoutput>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td valign="top" width=200><span id="titleleft">
		 Intl. Agent: <cfif len(#int_agent.businessname#) gt  25>#Left(int_agent.businessname,22)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		 <!--- Date Entry: #DateFormat(get_Student_info.dateapplication, 'mmm d, yyyy')# ---><br><br>
		<Cfif get_Student_info.hostid is not 0>
		Date Placed:  #DateFormat(get_Student_info.dateplaced, 'mmm d, yyyy')#
		<cfelse>
		 Today's Date: #DateFormat(now(), 'mmm d, yyyy')#<br>
		 <!--- Days Unplaced: #DateDiff('d',get_Student_info.dateapplication, now())# --->
	  </cfif></td> 
	<td valign="top"><div align="center">
		<font size=+2><b>#companyshort.companyshort_nocolor#</b></font><br>
		
		Program: #program_name.programname#<br>
		Region: #regions.regionname# 
		<cfif #get_student_info.regionguar# is 'yes'><b> - #region_guarantee.regionname# Guaranteed</b></cfif>
		<cfif #get_student_info.state_guarantee# NEQ 0><b> - #get_state_guarantee.statename# Guaranteed</b></cfif><br>
		<cfif get_student_info.scholarship is '1'>Participant of Scholarship Program</cfif></td>
	</div><td><img src="pics/logos/#client.companyid#_small.gif" border="0" align="right"></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=100% align="center">
	<td bgcolor="F3F3F3" valign="top" width=133><div align="left">
		<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#url.studentid#.*">
		<cfif file.recordcount>
			<img src="uploadedfiles/web-students/#file.name#" width="135">
		<cfelse>
			<img src="pics/no_stupicture.jpg" width="135">
		</cfif>
	<br>
	<!--- <td bgcolor="F3F3F3" valign="top" width=133><div align="left"><img <cfif #get_student_info.old_stuid# is 0>src="#CLIENT.exits_url#/pics/#client.studentid#.jpg"<cfelse> src="#CLIENT.exits_url#/pics/web-students/#client.studentid#.jpg"</cfif> width=133><br> --->
	</div></td>
	<td valign="top" width=504>
	<span class="application_section_header">STUDENT PROFILE</span><br>
	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
		<tr><td width="50"><font face="" color="Gray">Name: </font><b></td><td>#get_student_info.firstname# #get_student_info.middlename# #get_student_info.familylastname# (#get_student_info.studentid#)</b></td></tr>	
		<tr><td><font face="" color="Gray">Sex: </font></td><td>#get_student_info.sex#</td></tr>
		<tr><td><font face="" color="Gray">DOB: </font></td><td>#DateFormat(get_student_info.dob, 'mmm d, yyyy')#</td></tr>
	</table>
	<br> 
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr>
        	<td><font face="" color="Gray">Age:</font></td>
        	<td><cfif IsDate(get_student_info.dob)>#DateDiff('yyyy', get_student_info.dob, now())#<cfelse>Missing</cfif></td>
            <td></td>
            <td><font face="" color="Gray">Smoker:</font></td>
            <td>#get_student_info.smoke#</td></tr>
		<tr><td><font face="" color="Gray">Height:</font></td><td>#get_student_info.height#</td><td width=15%></td><td><font face="" color="Gray">Hair:</font></td><td>#get_student_info.haircolor#</td></tr>
		<tr><td><font face="" color="Gray">Weight:</font></td><td>#get_student_info.weight#</td><td></td><td><font face="" color="Gray">Eyes:</font></td><td>#get_student_info.eyecolor#</td></tr>					
	</table>
	<br>
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr><td align="center" width="360">
				<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="stuletter" filter="#get_student_info.studentid#.*">
				<cfif ListFind("jpg,gif", LCase(Right(stuletter.name, 3)))>
					<a href="javascript:OpenApp('student_app/print_letter_profile.cfm?studentid=#get_student_info.studentid#&letter=students');">Student's Letter</a>
				<cfelseif stuletter.recordcount>
					<a href="uploadedfiles/letters/students/#stuletter.name#" target="_blank">Student's Letter</a>
				<cfelseif get_student_info.app_current_status NEQ 0>
					<a href="javascript:OpenApp('student_app/section1/page5print.cfm?uniqueid=#url.uniqueid#');">Student's Letter</a>
				<cfelse>
					Students Letter n/a					
				</cfif>
				&nbsp - &nbsp  
				<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="paletter" filter="#get_student_info.studentid#.*">
				<cfif ListFind("jpg,gif", LCase(Right(paletter.name, 3)))>
					<a href="javascript:OpenApp('student_app/print_letter_profile.cfm?studentid=#get_student_info.studentid#&letter=parents');">Parent's Letter</a>
				<cfelseif paletter.recordcount>
					<a href="uploadedfiles/letters/parents/#paletter.name#" target="_blank">Parent's Letter</a>
				<cfelseif get_student_info.app_current_status NEQ 0>
					<a href="javascript:OpenApp('student_app/section1/page6print.cfm?uniqueid=#url.uniqueid#');">Parent's Letter</a>
				<cfelse>
					Parents Letter n/a
				</cfif>
				&nbsp - &nbsp 
				<a href="" onClick="javascript: win=window.open('reports/flight_information.cfm', 'Settings', 'height=480,width=800, location=yes, scrollbars=yes,  toolbar=yes, menubar=yes, resizable=yes'); win.opener=self; return false;">Flight Information</a>
			</td></tr>
	</table>
</table>
<br>

	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="50%">
		<span class="application_section_header">Citizenship</span><br>
			<table>
				<tr><td width="150"><font face="" color="Gray">Place of Birth:</font></td><td width="180">#get_student_info.citybirth#</td></tr>
				<tr><td><font face="" color="Gray">Country of Birth:</font></td><td>#country_birth.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Citizenship:</font></td><td>#country_citizen.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Residence:</font></td><td>#country_resident.countryname#</td></tr>
			</table>
		</td>
		<td width="50%">
		<span class="application_section_header">Religious Info</span><br>
			<table>
				<tr><td width="150"><font color="Gray">Religion:</font></td><td width="180"><cfif religion.religionid eq 3>Not Interested<cfelse>#religion.religionname#</cfif></td></tr>
				<tr><td><font color="Gray">Participation:</font></td><td>#get_student_info.religious_participation#</td></tr>
				<tr><td><font face="" color="Gray">Attend with host family:</font></td><td>#get_student_info.churchfam#</td></tr>
				<tr><td><font face="" color="Gray">Church groups:</font></td><td><cfif get_Student_info.churchgroup is ''>n/a<cfelse>#get_Student_info.churchgroup#</cfif></td></tr>
			</table>
		</td></tr>
	</table><br>
	
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header">Natural Parents & Family In Home Country</span><br> 
		<tr><td width="50%">
			<table>
				<tr><td width="100"><font color="Gray">Father:</font></td><td width="180">#get_student_info.fathersname# <cfif get_student_info.fatherbirth is '0'><cfelse><cfset calc_age_father = #CreateDate(get_student_info.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#)</cfif></td></tr>
				<tr><td><font color="Gray">Occupation:</font></td><td><cfif get_Student_info.fatherworkposition is ''>n/a<cfelse>#get_Student_info.fatherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#get_Student_info.fatherenglish#</td></tr>
			</table>	
		</td>
		<td width="50%">
			<table>
				<tr><td width="100"><font color="Gray">Mother:</font></td><td width="180">#get_student_info.mothersname# <cfif get_student_info.motherbirth is '0'><cfelse><cfset calc_age_mom = #CreateDate(get_student_info.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#)</cfif></td></tr>
				<tr><td><font color="Gray">Occupation:</font></td><td><cfif get_Student_info.motherworkposition is ''>n/a<cfelse>#get_Student_info.motherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#get_Student_info.motherenglish#</td></tr>
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
		<td width="250"><font face="" color="Gray">Band: &nbsp </font><cfif get_student_info.band is ''><cfelse>#get_student_info.band#</cfif></td>
		<td width="200"><font face="" color="Gray">Orchestra: &nbsp </font><cfif get_student_info.orchestra is ''><cfelse>#get_Student_info.orchestra#</cfif></td>
		<td width="200"><font face="" color="Gray">Est. GPA: &nbsp </font><cfif get_student_info.orchestra is ''><cfelse>#get_Student_info.estgpa#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>	
		<tr>
   		<td><font face="" color="Gray">
			<cfif get_student_info.grades is '12'>Must be placed in: &nbsp </font>#get_student_info.grades#th grade<cfelse>				
				  Last Grade Completed: &nbsp </font><cfif get_student_info.grades is '0'>n/a<cfelse>#get_student_info.grades#th grade</cfif></cfif></td>
    	<td><font face="" color="Gray">Years of English: &nbsp </font><cfif get_student_info.yearsenglish is '0'>n/a<cfelse>#get_student_info.yearsenglish#</cfif></td>
		<td><font face="" color="Gray">Convalidation needed: &nbsp </font><cfif get_student_info.convalidation_needed is ''>no<cfelse>#get_student_info.convalidation_needed#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>
	</table><br>

	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header">Personal Information</span><br>
		<tr>
		<td width="110"><font face="" color="Gray">Allergies</font></td>
		<td width="140"><font face="" color="Gray">Animal: &nbsp </font><cfif get_Student_info.animal_allergies is ''>no<cfelse>#get_Student_info.animal_allergies#</cfif></td>
		<td width="200"><font face="" color="Gray">Medical Allergies: &nbsp </font><cfif get_Student_info.med_allergies is ''>no<cfelse>#get_Student_info.med_allergies#</cfif></td>
		<td width="200"><font face="" color="Gray">Other: &nbsp </font><cfif get_Student_info.other_allergies is ''>no<cfelse>#get_Student_info.other_allergies#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>
		<tr>
		<td colspan="4">
			<font face="" color="Gray">Interests: &nbsp </font>
			<cfloop list=#get_student_info.interests# index=i>
				<cfquery name="get_interests" datasource="MySQL">
				Select interest 
				from smg_interests 
				where interestid = #i#
				</cfquery>
				#LCASE(get_interests.interest)#  &nbsp &nbsp
			</cfloop></td>

		</tr>	
		<tr><td> </td></tr>
		<tr><td> </td></tr>	
		<cfif get_student_info.aypenglish is 'no' ><cfelse>
			<tr><td colspan="4">The Student Participant of the Pre-AYP English Camp.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>				
		<cfif get_student_info.ayporientation is 'no' ><cfelse>
			<tr><td colspan="4">The Student Participant of the Pre-AYP Orientation Camp.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>	
		<cfif get_student_info.iffschool is 'no' ><cfelse>
			<tr><td colspan="4">The Student Accepts IFF School.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>
		<cfif get_student_info.privateschool is 0><cfelse>
			<cfquery name="private_schools" datasource="MySQL">
				SELECT *
				FROM smg_private_schools
				WHERE privateschoolid = #get_student_info.privateschool#
			</cfquery>
			<tr><td colspan="4">The Student Accepts Private HS #private_schools.privateschoolprice#.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>				
		<tr>
		<td colspan="4"><div align="justify"><font face="" color="Gray">Comments: &nbsp </font>#get_Student_info.interests_other#</div></td>
		</tr>
	</table>
</cfoutput>