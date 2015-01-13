<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../profile.css">
	<title>Student Profile</title>
</head>
<body>

<style>


</style>

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

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<!--- Block if they try to cheat changing the student id in the address bar --->


<Cfquery name="religion" datasource="mysql">
select religionname 
from smg_religions
where religionid = #get_student_unqid.religiousaffiliation#
</cfquery>

<cfquery name="int_Agent" datasource="mysql">
select  businessname
from smg_users 
where userid = #get_student_unqid.intrep#
</cfquery>

<cfquery name="program_name" datasource="mysql">
select programname
from smg_programs
where programid = #get_student_unqid.programid#
</cfquery>

<cfquery name="get_siblings" datasource="mysql">
Select name, liveathome, sex, birthdate, studentid, childid
From smg_student_siblings
Where studentid = #get_student_unqid.studentid#
Order by birthdate
</cfquery>

<cfquery name="country_birth" datasource="mysql">
	SELECT countryname 
	FROM smg_countrylist	
	WHERE countryid = '#get_student_unqid.countrybirth#'
</cfquery>

<cfquery name="country_citizen" datasource="mysql">
	SELECT countryname  
	FROM smg_countrylist 
	WHERE countryid = '#get_student_unqid.countrycitizen#'
</cfquery>

<cfquery name="country_resident" datasource="mysql">
	SELECT countryname  
	FROM smg_countrylist
	WHERE countryid = '#get_student_unqid.countryresident#'
</cfquery>

<cfquery name="school_name" datasource="mysql">
select schoolname
from php_schools
left join php_students_in_program on php_students_in_program.schoolid = php_schools.schoolid
where php_students_in_program.studentid = #get_student_unqid.studentid#
</cfquery>

<link rel="stylesheet" href="profile.css" type="text/css">

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {
				
		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
</script>

<cfoutput query="get_student_unqid">

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td valign="top" width=180> <span id="titleleft">
	<cfif client.usertype eq 12 or client.usertype eq 7><cfelse>
		<cfif client.usertype eq 8>School: #school_name.schoolname#<cfelse> Intl. Agent: <cfif len(#int_agent.businessname#) gt  25>#Left(int_agent.businessname,22)#..</font></a><cfelse>#int_agent.businessname#</cfif></cfif><br></cfif>
		 Date Entry: #DateFormat(get_student_unqid.dateapplication, 'mmm d, yyyy')#<br>
		<Cfif get_student_unqid.schoolid is not 0>
		Date Placed:  #DateFormat(get_student_unqid.dateplaced, 'mmm d, yyyy')#
		<cfelse>
		 Today's Date: #DateFormat(now(), 'mmm d, yyyy')#<br><br>
	 	</cfif>
		</span>
	</td> 
	<td valign="top"><div align="center">
		<font size=+2><b>Private High School Program</b></b></font><br>
		Program: #program_name.programname#<br></td>
	</div><td><cfif client.usertype gte 8><img src="http://www.phpusa.com/internal/pics/dmd-logo.jpg"><cfelse><img src="http://www.phpusa.com/internal/pics/dmd-logo.jpg"></cfif></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<td bgcolor="F3F3F3" valign="top" width=133><div align="left">
		<cfdirectory directory="#APPLICATION.PATH.onlineApp.picture#" name="stupicture" filter="#studentid#.*">
		<cfif stupicture.recordcount>
			<img src="http://ise.exitsapplication.com/nsmg/uploadedfiles/web-students/#stupicture.name#" width="135" height="200">
		<cfelse>
			<img src="pics/no_stupicture.jpg" width="135">
		</cfif>
	<br></div></td>
	<td valign="top" width=504>
	<span class="application_section_header">STUDENT PROFILE</span><br><br>
	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
		<tr><td width="50"><font face="" color="Gray">Name: </font><b></td><td>#firstname# #middlename# #familylastname# (#studentid#)</b></td></tr>	
		<tr><td><font face="" color="Gray">Sex: </font></td><td>#sex#</td></tr>
		<tr><td><font face="" color="Gray">DOB: </font></td><td>#DateFormat(dob, 'mmm d, yyyy')#</td></tr>
	</table>
	<br> 
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr><td><font face="" color="Gray">Age:</font></td><td>#DateDiff('yyyy', dob, now())#</td><td></td><td><font face="" color="Gray">Smoker:</font></td><td>#smoke#</td></tr>
		<tr><td><font face="" color="Gray">Height:</font></td><td>#height#</td><td width=15%></td><td><font face="" color="Gray">Hair:</font></td><td>#haircolor#</td></tr>
		<tr><td><font face="" color="Gray">Weight:</font></td><td>#weight#</td><td></td><td><font face="" color="Gray">Eyes:</font></td><td>#eyecolor#</td></tr>					
	</table>
	<br>
	<table cellpadding=0 cellspacing=0 border=0 width=80% style="font-size:13px">
		<tr><td align="center" width="360">
				<cfdirectory directory="#APPLICATION.PATH.onlineApp.studentLetter#" name="stuletter" filter="#studentid#.*">
				<cfif Right(stuletter.name, 3) EQ 'jpg' OR Right(stuletter.name, 3) EQ 'gif'>
					<a href="javascript:OpenApp('https://ise.exitsapplication.com/nsmg/student_app/print_letter_profile.cfm?studentid=#studentid#&letter=students');">Students Letter</a>
				<cfelseif stuletter.recordcount>
					<a href="http://ise.exitsapplication.com/nsmg/uploadedfiles/letters/students/#stuletter.name#">Students Letter</a>
				<cfelseif app_current_status NEQ 0>
					<a href="javascript:OpenApp('https://ise.exitsapplication.com/nsmg/student_app/section1/page5print.cfm?studentid=#studentid#');">Students Letter</a>
				<cfelse>
					Students Letter n/a					
				</cfif>
				&nbsp - &nbsp
				<cfdirectory directory="#APPLICATION.PATH.onlineApp.parentLetter#" name="paletter" filter="#studentid#.*">
				<cfif Right(paletter.name, 3) EQ 'jpg' OR Right(paletter.name, 3) EQ 'gif'>
					<a href="javascript:OpenApp('https://ise.exitsapplication.com/nsmg/student_app/print_letter_profile.cfm?studentid=#studentid#&letter=parents');">Parents Letter</a>
				<cfelseif paletter.recordcount>
					<a href="http://ise.exitsapplication.com/nsmg/uploadedfiles/letters/parents/#paletter.name#">Students Letter</a>
				<cfelseif app_current_status NEQ 0>
					<a href="javascript:OpenApp('https://ise.exitsapplication.com/nsmg/student_app/section1/page6print.cfm?studentid=#studentid#');">Parents Letter</a>
				<cfelse>
					Parents Letter n/a
				</cfif>
				<!----&nbsp - &nbsp			
                <!--- Flight Information --->
                <a href="student/index.cfm?action=flightInformation&uniqueID=#get_student_unqid.uniqueid#&programID=#get_student_unqid.programID#" class="jQueryModal">Flight Information</a>
                &nbsp - &nbsp
                <a href="" onClick="javascript: win=window.open('forms/received_progress_reports.cfm?unqid=#get_student_unqid.uniqueid#', 'Reports', 'height=450, width=610, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Progress Reports</A> 
				---->
			</td></tr>
	</table>
</table>
<br>
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td width="50%">
		<span class="application_section_header">Citizenship</span><br>
			<table>
				<tr><td width="150"><font face="" color="Gray">Place of Birth:</font></td><td width="180">#citybirth#</td></tr>
				<tr><td><font face="" color="Gray">Country of Birth:</font></td><td>#country_birth.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Citizenship:</font></td><td>#country_citizen.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Residence:</font></td><td>#country_resident.countryname#</td></tr>
			</table>
		</td>
		<td width="50%">
		<span class="application_section_header">Religious Info</span><br>
			<table>
				<tr><td width="150"><font color="Gray">Religion:</font></td><td width="180">#religion.religionname#</td></tr>
				<tr><td><font color="Gray">Participation:</font></td><td>#religious_participation#</td></tr>
				<tr><td><font face="" color="Gray">Attend with host family:</font></td><td>#churchfam#</td></tr>
				<tr><td><font face="" color="Gray">Church groups:</font></td><td><cfif churchgroup is ''>n/a<cfelse>#churchgroup#</cfif></td></tr>
			</table>
		</td></tr>
	</table><br>
	
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">

		<tr>
		<td colspan=5>	<span class="application_section_header">Natural Parents & Family In Home Country</span></td>
		</tr>
		<tr>
		<td width="50%">
			<table>
				<tr><td width="100"><font color="Gray">Father:</font></td><td width="180">#fathersname# <cfif isDate(fatherDOB)><cfset calc_age_father = #DateFormat(fatherDOB, "mm/dd/yyyy")#> (#DateDiff('yyyy', calc_age_father, now())#)</cfif></td></tr>
				<tr><td><font color="Gray">Occupation:</font></td><td><cfif fatherworkposition is ''>n/a<cfelse>#fatherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#fatherenglish#</td></tr>
			</table>	
		</td>
		<td width="50%">
			<table>
				<tr><td width="100"><font color="Gray">Mother:</font></td><td width="180">#mothersname# <cfif isDate(motherDOB)><cfset calc_age_mom = #DateFormat(motherDOB,"mm/dd/yyyy")#> (#DateDiff('yyyy', calc_age_mom, now())#)</cfif></td></tr>
				<tr><td><font color="Gray">Occupation:</font></td><td><cfif motherworkposition is ''>n/a<cfelse>#motherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#motherenglish#</td></tr>
			</table>	
		</td>
		</tr>		
		<tr><td colspan="2">

			<table>
				<tr><td><font face="" color="Gray">Siblings: &nbsp </font>
				<cfloop query="get_siblings">
				#get_siblings.name# <cfif get_siblings.birthdate is ''><cfelse>#DateDiff('yyyy', get_siblings.birthdate, now())#
				year old</cfif> #iif(Sex is 'Female', de("Sister"), de("Brother"))# &nbsp &nbsp; 
				</cfloop></td></tr>
			</table>
			</td></tr>
	</table><br>

  	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	
		<tr>
		<td colspan=5>	<span class="application_section_header">Academic and Language Evaluation</span></td>
		</tr>
		<tr>
		<td width="200"><font face="" color="Gray">Est. GPA: &nbsp </font><cfif orchestra is ''><cfelse>#estgpa#</cfif></td>
		
		<td><font face="" color="Gray">Years of English: &nbsp </font><cfif yearsenglish is '0'>n/a<cfelse>#yearsenglish#</cfif></td>
		 		<td><font face="" color="Gray">
			<cfif grades is '12'>Must be placed in: &nbsp </font>#grades#th grade<cfelse>				
				  Last Grade Completed: &nbsp </font><cfif grades is '0'>n/a<cfelse>#grades#th grade</cfif></cfif></td>
		</tr>
	</table><br>

	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	
		<tr>
		<td colspan=5>	<span class="application_section_header">Personal Information</span></td>
		</tr>
		<tr>
		<td width="110"><font face="" color="Gray">Allergies</font></td>
		<td width="140"><font face="" color="Gray">Animal: &nbsp </font><cfif animal_allergies is ''>no<cfelse>#animal_allergies#</cfif></td>
		<td width="200"><font face="" color="Gray">Medical Allergies: &nbsp </font><cfif med_allergies is ''>no<cfelse>#med_allergies#</cfif></td>
		<td width="200"><font face="" color="Gray">Other: &nbsp </font><cfif other_allergies is ''>no<cfelse>#other_allergies#</cfif></td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>	
		
	</table>
		<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	
		<tr>
		<td colspan=5>	<span class="application_section_header">About Me</span></td>
		</tr>
		<tr>
			<td>#interests_other#</td>
		</tr>
		<tr><td> </td></tr>
		<tr><td> </td></tr>	
		
	</table>
</cfoutput>
