<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<title>Available Public Profiles</title>
</head>
<body bgcolor=#e7e5df>

<style>
.application_section_header{
	border-bottom: 1px dashed orange;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;
	background: #A9CDEB;
	font-size:12px;
	display:block;
}
</style>

<Table align="center" bgcolor="white">
	<tr><td><img src="flags.jpg" width=796></td><tr>
	<tr><td id="navs">

<cfif NOT isDefined('url.id')>
	<cfset url.id = 0>
</cfif>

<cfparam name="session.allow" default="no">

<cfif isDefined('form.user') AND form.user NEQ ''>
	<cfif form.user EQ 'gene' and form.pass EQ 'tipton'>
		<cfset session.allow = 'yes'>
	</cfif>
</cfif>

<cfif isDefined('form.name') AND form.name NEQ '' AND form.email NEQ ''>
	<cfset session.allow = 'yes'>
	
	<!--- EMAIL TO GENE LEWIS --->
	<cfmail to="gene@sea-usa.org" from="webmaster@sea-usa.org" subject="Contact Info from SEA Website">
		The following information was collected so the user could view students:
		Name: #form.name#
		Email: #form.email#
		Phone: #form.phone#
		Initial Student Clicked on: http://profiles.student-management.com/public_profile.cfm?id=#url.id#
		An email was sent to the host family showing gene and tipton as the user and pass, and they were allowed to view students.
	</cfmail>
	
	<!--- EMAIL TO HOST FAMILY --->
	<cfmail to="#form.email#" from="webmaster@sea-usa.org" subject="Thank you for your interest in the Exchange Student Information Center" TYPE="HTML">
		<html><head><title>Thank You!</title></head><body>
		<table width="80%" align="center" cellpadding="0" cellspacing="0">
		<tr><td>
			<font face=arial size=3 color=##11395c>Dear #form.name# Family: <br><br>
			<div align="justify">
			Thank you for sharing your interest in hosting an SEA program member exchange student.
			Also, thanks to those of you who are inquiring about being a local representative. <br><br>
			By opening your heart and home to an exchange student, you can:<br>
			<ul>
			   <li>Share our American culture and values with the world.
			   <li>Join the many other families who enjoy the enrichment of hosting an exchange student.</li>
			   <li>Become America's ##1 diplomat by being an 'Ambassador for America.</li> 
			   <li>Experience another culture first hand with your family and community.</li>
			   <li>Build the bridges of international friendship and cultural understanding.</li>
			</ul>
			With the public opinion of the United States so severally decreasing over the last few years, now is the best
			time to get your family involved by opening your door to the world!
			Thousands of students are so eager to come to the U.S. every year.  The SEA family of programs
			has over 57 different countries that will include Europe, Pacific Rim, Latin America, and Africa; we know
			there is a student just right for your family with similar interests and lifestyle. <br><br>
			Join thousands of others as together they can make a difference:<br>
			<ul>
				<li>Call 1-877-562-7135 to speak with about your interests.</li>
				<li>E-mail us at gene@sea-usa.org</li>
			</ul>
			We look forward to hearing from you soon and we really thank you for making the world a better place for
			our children and grandchildren's future. <br><br>
			PS: If you would like to view the students later, you can use the following information to gain access:<br><br>
			&Username: gene<br>
			Password: tipton <br><br>
			Best Regards,<br><br>
			Gene Lewis<br>
			Founder<br><br><br><br>
		   </div>
		   </td></tr>
		</table>
	   </body></html>				
		<!--- You recently submitted information to view students at www.sea-usa.org.
		You should have seen the students that are available.  If you did not or you would like to view them
		later, you can use the following information to gain access.
		User: gene
		pass: tipton --->
	</cfmail>
</cfif>

<!--- FORMS --->
<cfif session.allow EQ 'no'>
	<cfoutput>
	<cfform name="frmEmail" method="post" action="public_profile.cfm?id=#url.id#">
	
	<h2>SEA would like to thank you for your interest in meeting our students.</h2>
	<table width="796" align="center">
		<tr>
			<td width=50% valign="top">
				<!----Have Password---->
				<p>If you've already submitted your contact info, please enter the user/pass you received in your email.</p>
				<table>
					<tr><td>Username:</td><Td><cfinput type="text" name="user" size=8/></Td></tr>
					<tr><td>Passphrase:</td><Td><cfinput type="password" name="pass" size=8/></Td></tr>
					<tr><td colspan=2><input type="submit" value="View Students"/></td></tr>
				</table>
			</td>
			<td valign="top">
				<p>If you don't have a user/pass, please fill out this form for immediate access.<p>
				<span id="lblUserMessage"></span>
				<table id="tblEmail">
					<tr><td>Name</td><td><cfinput name="name" type="text" size=25></td></tr>
					<tr><td>Phone: </td><td><cfinput name="phone" type="text" size=25></td></tr>
					<tr><td>Email:</td><td><cfinput name="email" type="text" size=25></td></tr>
					<tr><td colspan="2"><cfinput type="submit" name="btnSubmit" value="Submit" onclick="if (typeof(Page_ClientValidate) == 'function') Page_ClientValidate(); " language="javascript" id="btnSubmit" class="moveright" /> </td></tr>
				</table>
			</td>
		</tr>
	</table>
	</cfform>
	</cfoutput>
<!--- PROFILE --->		
<cfelse>
	<cfif NOT IsDefined('url.id')>
		An error has ocurred. Please try again.
		<cfabort>
	</cfif>
	
	<cfquery name="get_student_info" datasource="MySql">
		 SELECT *
		 FROM smg_students
		 WHERE uniqueid =  <cfqueryparam value="#url.id#" cfsqltype="cf_sql_char">
	</cfquery>
	
	<cfif get_student_info.recordcount EQ '0'>
		An error has ocurred. Please try again.
		<cfabort>
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
	select religionname 
	from smg_religions
	where religionid = #get_Student_info.religiousaffiliation#
	</cfquery>
	
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
		
	<cfoutput><br>
	
	<CFSET image_path="D:\websites\nsmg\uploadedfiles\web-students\#get_student_info.studentid#.jpg">
	<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px" align="center"> 
		<tr><td bgcolor="F3F3F3" valign="top" width=133 align="left">
			<CFIF FileExists(image_path)>
				<img src="http://www.student-management.com/nsmg/uploadedfiles/web-students/#get_student_info.studentid#.jpg" border=0 width="133"> 
			<CFELSE>
				<img src="http://www.student-management.com/nsmg/pics/no_stupicture.jpg" border=0></span>	
			</CFIF><br>
		</td>
		<td valign="top" width=517>
		<span class="application_section_header">STUDENT PROFILE</span><br><br>
		<table cellpadding=0 cellspacing=0 border=0 style="font-size:13px">
			<tr><td width="70"><font face="" color="Gray">Name: </font><b></td><td>#get_student_info.firstname# (#get_student_info.studentid#)</b></td></tr>	
			<tr><td><font face="" color="Gray">Sex: </font></td><td>#get_student_info.sex#</td></tr>
			<tr><td><font face="" color="Gray">Program: </font></td><td> #program_name.programname#</td></tr>
		</table>
		<br> 
		<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
			<tr><td><font face="" color="Gray">Age:</font></td><td>#DateDiff('yyyy', get_student_info.dob, now())#</td><td></td><td><font face="" color="Gray">Smoker:</font></td><td>#get_student_info.smoke#</td></tr>
			<tr><td><font face="" color="Gray">Height:</font></td><td>#get_student_info.height#</td><td width=15%></td><td><font face="" color="Gray">Hair:</font></td><td>#get_student_info.haircolor#</td></tr>
			<tr><td><font face="" color="Gray">Weight:</font></td><td>#get_student_info.weight#</td><td></td><td><font face="" color="Gray">Eyes:</font></td><td>#get_student_info.eyecolor#</td></tr>					
		</table>
		<br>
		<table cellpadding=0 cellspacing=0 border=0 width=65% style="font-size:13px">
			<tr><td align="center" width="360">&nbsp;</td></tr>
		</table>
	</table>
	<br>
	
	<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<tr><td colspan=4><hr width=80% align="center"></td></tr>
		<tr><td width="50%">
		<span class="application_section_header">Citizenship</span><br>
			<table>
				<tr><td width="150"><font face="" color="Gray">Country of Birth:</font></td><td>#country_birth.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Citizenship:</font></td><td>#country_citizen.countryname#</td></tr>
				<tr><td><font face="" color="Gray">Country of Residence:</font></td><td>#country_resident.countryname#</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
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
	<tr>
		<td colspan=4><hr width=80% align="center"><span class="application_section_header">Natural Parents & Family In Home Country</span></td>
	</tr>
		<tr><td width="50%">
			<table>
				<tr><td><font color="Gray">Father's Occupation:</font></td><td><cfif get_Student_info.fatherworkposition is ''>n/a<cfelse>#get_Student_info.fatherworkposition#</cfif></td></tr>
				<tr><td><font face="" color="Gray">Speaks English:</font></td><td>#get_Student_info.fatherenglish#</td></tr>
			</table>	
		</td>
		<td width="50%">
			<table>
				<tr><td><font color="Gray">Mother's Occupation:</font></td><td><cfif get_Student_info.motherworkposition is ''>n/a<cfelse>#get_Student_info.motherworkposition#</cfif></td></tr>
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
	<Tr>
		<td colspan=4><hr width=80% align="center">
	<span class="application_section_header">Academic and Language Evaluation</span></td>
	</Tr>
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
	<tr>
		<td colspan=4>
		<hr width=80% align="center">
	<span class="application_section_header">Personal Information</span>
		</td>
	</tr>
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
	</table><br>
	</cfoutput>
	<div align="center">For more information, please contact <a href="mailto:gene@sea-usa.org">gene@sea-usa.org</a></div>
</cfif>

</td></tr>
</table>

</body>
</html>