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

<script type="text/javascript">
<!--
// open online application 
function OpenApp(url) {
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<cfif isDefined('URL.uniqued')>
    <cfif URL.uniqueid is ''>
        You have not specified a valid studentID.
        <cfabort>
    </cfif>
</cfif>

<cfif isdefined('URL.uniqueid') >
	<cfquery name="qLookUpStudent" datasource="mysql">
		select 
        	studentID 
		from 
        	smg_students
		where 
        	uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.uniqueid#">
	</cfquery>
	<cfset URL.studentID = qLookUpStudent.studentID>
</cfif>

<cfquery name="qGetStudentInfo" datasource="mysql">
	select 	
    	*
	from 
    	smg_students
	where 
    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.studentID)#">
</cfquery>

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

<!--- Block if they try to cheat changing the student id in the address bar --->
<cfif client.usertype GT 4> 

	<cfquery name="qCheckUserAccess" datasource="MySql">
		SELECT 
        	regionid, companyid, userid 		
        FROM 
        	user_access_rights
		WHERE 
        	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.regionassigned)#"> 
		AND  
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(client.userid)#">
	</cfquery>	
    	
	<cfif qGetStudentInfo.companyid is not client.companyid OR qCheckUserAccess.recordcount is 0><br>
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

<cfquery name="qGetRegionAssigned" datasource="MySQL">
select regionname
from smg_regions
where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.regionassigned)#">
</cfquery>

<cfquery name="qGetRegionGuaranteed" datasource="MySQL">
select regionname
from smg_regions
where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.regionalguarantee)#">
</cfquery>

<Cfquery name="qGetReligionInfo" datasource="MySQL">
select religionname, religionid
from smg_religions
where religionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.religiousaffiliation)#">
</cfquery>

<cfquery name="qGetIntlRep" datasource="MySQL">
select companyid, businessname
from smg_users 
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.intrep)#">
</cfquery>

<Cfquery name="qGetCompanyShort" datasource="MySQL">
select companyshort, companyshort_nocolor, team_id
from smg_companies
where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(client.companyid)#">
</Cfquery>

<cfquery name="qGetProgramName" datasource="MySQL">
select programname
from smg_programs
where programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.programid)#">
</cfquery>

<cfquery name="qGetSiblings" datasource="MySQL">
Select name, liveathome, sex, birthdate, studentID, childid
From smg_student_siblings
Where studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
Order by birthdate
</cfquery>

<cfquery name="qGetCountryBirth" datasource="MySql">
	SELECT countryname 
	FROM smg_countrylist	
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.countrybirth)#">
</cfquery>

<cfquery name="qGetCountryCitizenship" datasource="MySql">
	SELECT countryname  
	FROM smg_countrylist 
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.countrycitizen)#">
</cfquery>

<cfquery name="qGetCountryResidence" datasource="MySql">
	SELECT countryname  
	FROM smg_countrylist
	WHERE countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.countryresident)#">
</cfquery>

<cfquery name="qGetStateGuaranteed" datasource="MySql">
	SELECT statename  
	FROM smg_states
	WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.state_guarantee)#">
</cfquery>
	
<link rel="stylesheet" href="profile.css" type="text/css">

<cfoutput>

<table width=650 align="center" border=0 bgcolor="FFFFFF">
	<tr>
	<td valign="top" width=200><span id="titleleft">
		 Intl. Agent: <cfif len(#qGetIntlRep.businessname#) gt  25>#Left(qGetIntlRep.businessname,22)#..</font></a><cfelse>#qGetIntlRep.businessname#</cfif><br>
		 <!--- Date Entry: #DateFormat(qGetStudentInfo.dateapplication, 'mmm d, yyyy')# ---><br><br>
		<Cfif qGetStudentInfo.hostid is not 0>
		Date Placed:  #DateFormat(qGetStudentInfo.dateplaced, 'mmm d, yyyy')#
		<cfelse>
		 Today's Date: #DateFormat(now(), 'mmm d, yyyy')#<br>
		 <!--- Days Unplaced: #DateDiff('d',qGetStudentInfo.dateapplication, now())# --->
	  </cfif></td> 
	<td valign="top"><div align="center">
		<font size=+2><b>#qGetCompanyShort.companyshort_nocolor#</b></font><br>
		
		Program: #qGetProgramName.programname#<br>
		Region: #qGetRegionAssigned.regionname# 
		<cfif #qGetStudentInfo.regionguar# is 'yes'><b> - #qGetRegionGuaranteed.regionname# Guaranteed</b></cfif>
		<cfif #qGetStudentInfo.state_guarantee# NEQ 0><b> - #qGetStateGuaranteed.statename# Guaranteed</b></cfif><br>
		<cfif qGetStudentInfo.scholarship is '1'>Participant of Scholarship Program</cfif></td>
	</div><td><img src="pics/logos/#client.companyid#_small.gif" border="0" align="right"></td></tr>	
</table>

<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=100% align="center">
	<td bgcolor="F3F3F3" valign="top" width=133><div align="left">
		<cfdirectory directory="#AppPath.onlineApp.picture#" name="file" filter="#URL.studentID#.*">
		<cfif file.recordcount>
			<img src="uploadedfiles/web-students/#file.name#" width="135">
		<cfelse>
			<img src="pics/no_stupicture.jpg" width="135">
		</cfif>
	<br>
	<!--- <td bgcolor="F3F3F3" valign="top" width=133><div align="left"><img <cfif #qGetStudentInfo.old_stuid# is 0>src="#CLIENT.exits_url#/pics/#client.studentID#.jpg"<cfelse> src="#CLIENT.exits_url#/pics/web-students/#client.studentID#.jpg"</cfif> width=133><br> --->
	</div></td>
	<td valign="top" width=504>
	<span class="application_section_header">STUDENT PROFILE</span><br>
	
	<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
		<tr><td width="50"><font face="" color="Gray">Name: </font><b></td><td>#qGetStudentInfo.firstname# #qGetStudentInfo.middlename# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentID#)</b></td></tr>	
		<tr><td><font face="" color="Gray">Sex: </font></td><td>#qGetStudentInfo.sex#</td></tr>
		<tr><td><font face="" color="Gray">DOB: </font></td><td>#DateFormat(qGetStudentInfo.dob, 'mmm d, yyyy')#</td></tr>
	</table>
	<br> 
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr>
        	<td><font face="" color="Gray">Age:</font></td>
        	<td><cfif IsDate(qGetStudentInfo.dob)>#DateDiff('yyyy', qGetStudentInfo.dob, now())#<cfelse>Missing</cfif></td>
            <td></td>
            <td><font face="" color="Gray">Smoker:</font></td>
            <td>#qGetStudentInfo.smoke#</td></tr>
		<tr><td><font face="" color="Gray">Height:</font></td><td>#qGetStudentInfo.height#</td><td width=15%></td><td><font face="" color="Gray">Hair:</font></td><td>#qGetStudentInfo.haircolor#</td></tr>
		<tr><td><font face="" color="Gray">Weight:</font></td><td>#qGetStudentInfo.weight#</td><td></td><td><font face="" color="Gray">Eyes:</font></td><td>#qGetStudentInfo.eyecolor#</td></tr>					
	</table>
	<br>
	<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
		<tr><td align="center" width="360">
				<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="stuletter" filter="#qGetStudentInfo.studentID#.*">
				<cfif ListFind("jpg,gif", LCase(Right(stuletter.name, 3)))>
					<a href="javascript:OpenApp('student_app/print_letter_profile.cfm?studentID=#qGetStudentInfo.studentID#&letter=students');">Student's Letter</a>
				<cfelseif stuletter.recordcount>
					<a href="uploadedfiles/letters/students/#stuletter.name#" target="_blank">Student's Letter</a>
				<cfelseif qGetStudentInfo.app_current_status NEQ 0>
					<a href="javascript:OpenApp('student_app/section1/page5print.cfm?uniqueid=#URL.uniqueid#');">Student's Letter</a>
				<cfelse>
					Students Letter n/a					
				</cfif>
				&nbsp - &nbsp  
				<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="paletter" filter="#qGetStudentInfo.studentID#.*">
				<cfif ListFind("jpg,gif,pdf", LCase(Right(paletter.name, 3)))>
					<a href="javascript:OpenApp('student_app/print_letter_profile.cfm?studentID=#qGetStudentInfo.studentID#&letter=parents');">Parent's Letter</a>
				<cfelseif paletter.recordcount>
					<a href="uploadedfiles/letters/parents/#paletter.name#" target="_blank">Parent's Letter</a>
				<cfelseif qGetStudentInfo.app_current_status NEQ 0>
					<a href="javascript:OpenApp('student_app/section1/page6print.cfm?uniqueid=#URL.uniqueid#');">Parent's Letter</a>
				<cfelse>
					Parents Letter n/a
				</cfif>
				&nbsp - &nbsp 
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
				<tr><td><font face="" color="Gray">Country of Birth:</font></td><td>#qGetCountryBirth.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Citizenship:</font></td><td>#qGetCountryCitizenship.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Residence:</font></td><td>#qGetCountryResidence.countryname#</td></tr>
			</table>
		</td>
		<td width="50%">
		<span class="application_section_header">Religious Info</span><br>
			<table>
				<tr><td width="150"><font color="Gray">Religion:</font></td><td width="180"><cfif qGetReligionInfo.religionid eq 3>Not Interested<cfelse>#qGetReligionInfo.religionname#</cfif></td></tr>
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
            <cfoutput query="qGetSiblings">
                #qGetSiblings.name# <cfif isDate(qGetSiblings.birthdate)>#DateDiff('yyyy', qGetSiblings.birthdate, now())# years old</cfif> 
                #iif(Sex is 'Female', de("Sister"), de("Brother"))# &nbsp &nbsp; 
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
			<cfloop list=#qGetStudentInfo.interests# index=i>
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
		<cfif qGetStudentInfo.aypenglish NEQ 'no' >
			<tr><td colspan="4">The Student Participant of the Pre-AYP English Camp.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>				
		<cfif qGetStudentInfo.ayporientation NEQ 'no' >
			<tr><td colspan="4">The Student Participant of the Pre-AYP Orientation Camp.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>	
		<cfif qGetStudentInfo.iffschool NEQ 'no' >
			<tr><td colspan="4">The Student Accepts IFF School.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>
		<cfif VAL(qGetStudentInfo.privateschool)>
			<cfquery name="private_schools" datasource="MySQL">
				SELECT *
				FROM smg_private_schools
				WHERE privateschoolid = #qGetStudentInfo.privateschool#
			</cfquery>
			<tr><td colspan="4">The Student Accepts Private HS #private_schools.privateschoolprice#.</td></tr>
			<tr><td> </td></tr>
			<tr><td> </td></tr>	
		</cfif>				
		<tr>
		<td colspan="4"><div align="justify"><font face="" color="Gray">Comments: &nbsp </font>#qGetStudentInfo.interests_other#</div></td>
		</tr>
	</table>
</cfoutput>