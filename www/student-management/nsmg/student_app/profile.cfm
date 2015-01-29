<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
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
	<cfquery name="qGetStudentByUniqueID" datasource="#APPLICATION.DSN#">
		SELECT *
		FROM smg_students
		WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.unqid#">
	</cfquery>
	<cfset client.studentid = qGetStudentByUniqueID.studentid>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfinclude template="../querys/get_students_host.cfm">

<cfscript>
	vFatherAge = "";
	vMotherAge = "";
	
	if ( isDate(get_student_info.fatherDOB) ) {
		vFatherAge = "(#DateDiff('yyyy', get_student_info.fatherDOB, now())# years old)";
	}

	if ( isDate(get_student_info.motherDOB) ) {
		vMotherAge = "(#DateDiff('yyyy', get_student_info.motherDOB, now())# years old)";
	}
</cfscript>

<!--- Student Picture --->
<cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#get_student_info.studentID#.*">

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
		The student ID you are looking for, <cfoutput>#URL.studentid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
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

<cfquery name="regions" datasource="#APPLICATION.DSN#">
select regionname
from smg_regions
where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_Student_info.regionassigned#">
</cfquery>

<cfquery name="region_guarantee" datasource="#APPLICATION.DSN#">
select regionname
from smg_regions
where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_Student_info.regionalguarantee#">
</cfquery>

<Cfquery name="religion" datasource="#APPLICATION.DSN#">
select religionname 
from smg_religions
where religionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_Student_info.religiousaffiliation#">
</cfquery>

<cfquery name="int_Agent" datasource="#APPLICATION.DSN#">
select companyid, businessname
from smg_users 
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_Student_info.intrep#">
</cfquery>

<Cfquery name="companyshort" datasource="#APPLICATION.DSN#">
select companyshort
from smg_companies
where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.companyid#">
</Cfquery>

<cfquery name="program_name" datasource="#APPLICATION.DSN#">
select programname
from smg_programs
where programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_Student_info.programid#">
</cfquery>

<cfquery name="get_siblings" datasource="#APPLICATION.DSN#">
Select name, liveathome, sex, birthdate, studentid, childid
From smg_student_siblings
Where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
Order by birthdate
</cfquery>

<cfquery name="country_birth" datasource="#APPLICATION.DSN#">
	SELECT countryname 
	FROM smg_countrylist	
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.countrybirth#">
</cfquery>

<cfquery name="country_citizen" datasource="#APPLICATION.DSN#">
	SELECT countryname  
	FROM smg_countrylist 
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.countrycitizen#">
</cfquery>

<cfquery name="country_resident" datasource="#APPLICATION.DSN#">
	SELECT countryname  
	FROM smg_countrylist
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.countryresident#">
</cfquery>

<cfquery name="get_state_guarantee" datasource="#APPLICATION.DSN#">
	SELECT statename  
	FROM smg_states
	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.state_guarantee#">
</cfquery>
	
<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Student Profile</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td valign="top" width=180>
		 Intl. Agent: <cfif len(#int_agent.businessname#) gt  25>#Left(int_agent.businessname,22)#..</font></a><cfelse>#int_agent.businessname#</cfif><br>
		 Date Entry: #DateFormat(get_Student_info.dateapplication, 'mmm d, yyyy')#<br>
		<Cfif get_Student_info.hostid NEQ 0 AND get_student_info.host_fam_approved LTE 4>
		Date Placed:  #DateFormat(get_Student_info.dateplaced, 'mmm d, yyyy')#
		<cfelse>
		 Today's Date: #DateFormat(now(), 'mmm d, yyyy')#<br>
		 Days Unplaced: #DateDiff('d',get_Student_info.dateapplication, now())#
	  </cfif></td> 
	<td valign="top"><div align="center">
		<font size=+2><b>#companyshort.companyshort#</b></font><br>
		Program: #program_name.programname#<br>
		Region: #regions.regionname# 
		<cfif #get_student_info.regionguar# is 'yes'><b> - #region_guarantee.regionname# Preference</b></cfif>
		<cfif #get_student_info.state_guarantee# NEQ 0><b> - #get_state_guarantee.statename# Preference</b></cfif><br>
		<cfif get_student_info.scholarship is '1'>Participant of Scholarship Program</cfif></td>
	</div><td><img src="../pics/logos/5.gif"  alt="" border="0" align="right"></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td colspan="2"><hr width=80% align="center"></td></tr>
	<tr>
          <td width="135">
              <!--- Use a cftry instead of cfif. Using cfif when image is not available CF throws an error. --->
              <cftry>
              
                  <cfscript>
                      // CF throws errors if can't read head of the file "ColdFusion was unable to create an image from the specified source file". 
                      // Possible cause is a gif file renamed as jpg. Student #17567 per instance.
                  
                      // this file is really a gif, not a jpeg
                      pathToImage = AppPath.onlineApp.picture & studentPicture.name;
                      imageFile = createObject("java", "java.io.File").init(pathToImage);
                      
                      // read the image into a BufferedImage
                      ImageIO = createObject("java", "javax.imageio.ImageIO");
                      bi = ImageIO.read(imageFile);
                      img = ImageNew(bi);
                  </cfscript>              
                  
                  <cfimage source="#img#" name="myImage">
                  <!---- <cfset ImageScaleToFit(myimage, 250, 135)> ---->
                  <cfimage source="#myImage#" action="writeToBrowser" border="0" width="135px"><br />
                 
                  <cfcatch type="any">
                      <img src="../pics/no_stupicture.jpg" width="135">
                  </cfcatch>
                  
              </cftry>
          </td>
		<td valign="top" width=504>
		<span class="application_section_header">STUDENT PROFILE</span><br><br>
		
		<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
			<tr><td width="50"><font face="" color="Gray">Name: </font><b></td><td>#get_student_info.firstname# #get_student_info.middlename# #get_student_info.familylastname# (#get_student_info.studentid#)</b></td></tr>	
			<tr><td><font face="" color="Gray">Sex: </font></td><td>#get_student_info.sex#</td></tr>
			<tr><td><font face="" color="Gray">DOB: </font></td><td>#DateFormat(get_student_info.dob, 'mmm d, yyyy')#</td></tr>
		</table><br> 
		
		<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
			<tr><td><font face="" color="Gray">Age:</font></td><td>#DateDiff('yyyy', get_student_info.dob, now())#</td><td></td><td><font face="" color="Gray">Smoker:</font></td><td>#get_student_info.smoke#</td></tr>
			<tr><td><font face="" color="Gray">Height:</font></td><td>#get_student_info.height#</td><td width=15%></td><td><font face="" color="Gray">Hair:</font></td><td>#get_student_info.haircolor#</td></tr>
			<tr><td><font face="" color="Gray">Weight:</font></td><td>#get_student_info.weight#</td><td></td><td><font face="" color="Gray">Eyes:</font></td><td>#get_student_info.eyecolor#</td></tr>					
		</table><br>
		
		<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
			<tr><td align="center" width="360">
				<!--- ONLINE APPLICATION ---->
				<cfif get_student_info.app_current_status NEQ 0>
                    <cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="stuletter" filter="#get_student_info.studentID#.*">
					<cfif ListFind("jpg,gif", LCase(Right(stuletter.name, 3)))>
                        <a href="javascript:OpenApp('print_letter_profile.cfm?studentID=#get_student_info.studentID#&letter=students');">Student's Letter</a>
                    <cfelseif stuletter.recordcount>
                        <a href="../uploadedfiles/letters/students/#get_student_info.studentid#.pdf" target="_blank">Student's Letter</a>
                    <cfelseif get_student_info.app_current_status NEQ 0>
                        <a href="javascript:OpenApp('section1/page5print.cfm');">Student's Letter</a>
                    <cfelse>
                        Students Letter n/a				
                    </cfif>
					&nbsp &nbsp - &nbsp &nbsp
					<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="paletter" filter="#get_student_info.studentID#.*">
					<cfif ListFind("jpg,gif", LCase(Right(paletter.name, 3)))>
                        <a href="javascript:OpenApp('print_letter_profile.cfm?studentID=#get_student_info.studentID#&letter=parents');">Parent's Letter</a>
                    <cfelseif paletter.recordcount>
                        <a href="../uploadedfiles/letters/parents/#get_student_info.studentid#.pdf" target="_blank">Parent's Letter</a>
                    <cfelseif get_student_info.app_current_status NEQ 0>
                        <a href="javascript:OpenApp('section1/page6print.cfm');">Parent's Letter</a>
                    <cfelse>
                        Parents Letter n/a
					</cfif>
				</cfif>
				</td></tr>
		</table>
	</tr></td>
</table><br>

<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td colspan="2"><hr width=80% align="center"></td></tr>
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
			<tr><td width="150"><font color="Gray">Religion:</font></td><td width="180">#religion.religionname#</td></tr>
			<tr><td><font color="Gray">Participation:</font></td><td>#get_student_info.religious_participation#</td></tr>
			<tr><td><font face="" color="Gray">Attend with host family:</font></td><td>#get_student_info.churchfam#</td></tr>
			<tr><td><font face="" color="Gray">Church groups:</font></td><td><cfif get_Student_info.churchgroup is ''>n/a<cfelse>#get_Student_info.churchgroup#</cfif></td></tr>
		</table>
	</td></tr>
</table><br>
	
<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td colspan="2"><hr width=80% align="center"></td></tr>
	<tr><td colspan="2"><span class="application_section_header">Natural Parents & Family In Home Country</span></td></tr>
	<tr><td width="50%">
		<table>
			<tr><td width="100"><font color="Gray">Father:</font></td><td width="180">#get_student_info.fathersname# #vFatherAge#</td></tr>
			<tr><td><font color="Gray">Occupation:</font></td><td><cfif get_Student_info.fatherworkposition is ''>n/a<cfelse>#get_Student_info.fatherworkposition#</cfif></td></tr>
			<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#get_Student_info.fatherenglish#</td></tr>
		</table>	
	</td>
	<td width="50%">
		<table>
			<tr><td width="100"><font color="Gray">Mother:</font></td><td width="180">#get_student_info.mothersname# #vMotherAge#</td></tr>
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
	<tr><td colspan="3"><hr width=80% align="center"></td></tr>
	<tr><td colspan="3"><span class="application_section_header">Academic and Language Evaluation</span></td></tr>
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
	<tr><td colspan="4"><hr width=80% align="center"></td></tr>
	<tr><td colspan="4"><span class="application_section_header">Personal Information</span></td></tr>
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
			<cfquery name="get_interests" datasource="#APPLICATION.DSN#">
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
		<cfquery name="private_schools" datasource="#APPLICATION.DSN#">
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
</table><br><br>
</div>

</cfoutput>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">

</body>
</html>