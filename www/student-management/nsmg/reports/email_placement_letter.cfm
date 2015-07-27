<link rel="stylesheet" href="reports.css" type="text/css">

<cfif isdefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfinclude template="../querys/get_students_host.cfm">

<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
	select *
	from smg_companies
	where companyid = '#get_student_info.companyid#'
</Cfquery>

<!-----Regions----->
<cfquery name="regions" datasource="MySQL">
	select regionname, regionfacilitator
	from smg_regions
	where regionid = #get_Student_info.regionassigned#
</cfquery>

<!-----Intl. Agent----->
<cfquery name="GetIntlReps" datasource="MySQL">
	select companyid, businessname, fax, email, firstname, lastname, businessphone, master_accountid
	from smg_users 
	where userid = '#get_Student_info.intrep#'
</cfquery>

<!-----Program Name----->
<cfquery name="program_name" datasource="MySQL">
	select programname
	from smg_programs
	where programid = '#get_Student_info.programid#'
</cfquery>

<!-----Area Rep----->
<cfquery name="get_area_rep" datasource="MySQL">
	Select userid, firstname, lastname, phone, address, city, state, zip, email
	From smg_users
	Where userid = '#get_student_info.arearepid#'
</cfquery>

<!---Regional Manager --->
<cfquery name="get_regional_manager" datasource="MySQL">
	select s.regionassigned, u.userID, u.firstname, u.lastname, u.phone, u.address, u.city, u.state, u.zip, u.email
    from smg_students s 
    	left outer join user_access_rights uar on s.regionassigned = uar.regionID
        left outer join smg_users u on uar.userID = u.userID
    Where uar.usertype = 5
    	and uar.regionID = '#get_student_info.regionassigned#'
    Group by
    	u.userID
</cfquery>    

<!-----Facilitator----->
<cfif get_student_info.regionassigned is not 0>
	<cfquery name="get_facilitator" datasource="MySQL">
	select firstname, lastname 
	from smg_users
	where userid = '#regions.regionfacilitator#' 
	</cfquery>
</cfif>

<!-----Host Family----->
<cfquery name="get_host_family" datasource="MySQL">
	Select *
	From smg_hosts
	Where hostid = '#get_student_info.hostid#'
</cfquery>

<!-----Host Children----->
<cfquery name="get_host_children" datasource="MySQL">
	Select *
	From smg_host_children
	Where hostid = '#get_student_info.hostid#'
    	AND isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	Order by birthdate
</cfquery>

<!-----Get Host Family Pets----->
<cfquery name="get_host_pets" datasource="MySQL">
	select hostid, animaltype, number, indoor
	from smg_host_animals
	Where hostid = '#get_student_info.hostid#'
</cfquery>

<!-----Get Host Family Religion----->
<cfif get_student_info.hostid is ''><cfelse>
<cfquery name="get_host_religion" datasource="MySQL">
	select religionname, religionid 
	from smg_religions
	where religionid = '#get_host_family.religion#'
</cfquery>
</cfif>

<!-----Get School----->
<cfquery name="get_school" datasource="MySQL">
	select *
	from smg_schools
	Where schoolid = '#get_student_info.schoolid#'
</cfquery>

<cfquery name="get_school_dates" datasource="MySql">
	SELECT schooldateid, schoolid, smg_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
			p.programid
	FROM smg_school_dates
	INNER JOIN smg_programs p ON p.seasonid = smg_school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#get_student_info.schoolid#" cfsqltype="cf_sql_integer">
	AND p.programid = <cfqueryparam value="#get_student_info.programid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- get history to check if this is a relocation --->
<cfquery name="get_history" datasource="MySql">
	SELECT historyid, isRelocation
	FROM smg_hosthistory
	WHERE hostid <> '0' AND studentid = '#get_student_info.studentid#'
	ORDER BY historyid DESC
</cfquery>

<!-----Facilitator----->
<cfif #get_student_info.regionassigned# is not 0>
	<cfquery name="get_facilitator" datasource="MySQL">
	select firstname, lastname, email
	from smg_users
	where userid = '#regions.regionfacilitator#' 
	</cfquery>
</cfif>

<cfquery name="get_current_user" datasource="MySql">
	SELECT email, firstname, lastname
	FROM smg_users
	WHERE userid = #client.userid#
</cfquery>

<cfif IsDefined('form.self')>
	<cfset emails = '#get_current_user.email#'>
	<!--- COPY linnea.nattochdag@ef.com on all EF placements --->
<cfelseif GetIntlReps.master_accountid EQ 10115>
	<cfset emails = '#GetIntlReps.email#;Maria.Ma@ef.com'>
<cfelse>
	<cfset emails = '#GetIntlReps.email#'>
</cfif>

<cfoutput>

<CFMAIL SUBJECT="Placement Information Letter for #get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )"
	TO="#emails#"
    cc="#get_regional_manager.email#"
	bcc="#get_current_user.email#"
    failto="#get_current_user.email#" 
	replyto="""#companyshort.companyname#"" <#get_facilitator.email#>"
	from="#client.support_email#"
    TYPE="HTML">

<HTML>
<HEAD>

<style type="text/css">
.application_section_header_bold {
	border-bottom: 1px dashed Gray;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;
	background;
	background: DCDCDC;
	font-size: small;
	font-weight: bold; 
}
.profile_section_header {
	border-bottom: 1px dashed Gray;
	text-transform: uppercase;
	letter-spacing: 5px;
	width:100%;
	text-align:center;
	background;
	background: DCDCDC;
	font-size: x-small;
}
.sub_profile_section_header {
	border-bottom: 1px dashed Gray;
	width:100%;
	text-align:center;
	background;
	background: DCDCDC;
	font-size: x-small;
}
</style>
</HEAD>
<BODY>

<cfinclude template="email_intl_header.cfm"><br>

<!--- HEADER - OTHER INFORMATION --->
<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td><p>Please DO NOT reply to this message. If you are not able to read this e-mail please contact #companyshort.companyshort_nocolor#.</p></td></tr>
	
	<tr><td>
	We are pleased to give you the placement information for #get_student_info.firstname# #get_student_info.familylastname# (Student ID: #get_student_info.studentid#).
	</td></tr>
	<cfif get_student_info.doubleplace is '0'>
	<cfelse> <tr><td><div align="justify"> Please note that there will be another exchange student living in the same house.
			Refer to the Double Placement paperwork attached.</div></td></tr></cfif>
</table><br>

<!--- PLACEMENT INFORMATION - HOST FATHER AND MOTHER --->
<table  width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header_bold">PLACEMENT INFORMATION</span><br>
	<cfif get_area_rep.recordcount is not 0>
		<tr><td>The Supervising Area Representative will be #get_area_rep.firstname# #get_area_rep.lastname#. (#get_area_rep.address#, 
				#get_area_rep.city#, #get_area_rep.state# #get_area_rep.zip#). The Phone number is: #get_area_rep.phone#.</td></tr></cfif>
	<tr><td><br>
		<table align="left" width=350 style="font-size:13px">	
			<cfif #get_host_family.fatherfirstname# is ''><cfelse>
			<tr><td width="100">Host Father:</td>
			<td width="250">#get_host_family.fatherfirstname# #get_host_family.fatherlastname#, 
			  	<cfif #get_host_family.fatherbirth# is '0'><cfelse>
					<cfset calc_age_father = #CreateDate(get_host_family.fatherbirth,01,01)#> (#DateDiff('yyyy', calc_age_father, now())#)
				</cfif> &nbsp;</td></tr>
		    <tr><td>Occupation:</td>
			<td>#get_host_family.fatherworktype#</td></tr></cfif>
    		<tr><td> </td></tr>
			<cfif #get_host_family.motherfirstname# is ''><cfelse>
			<tr><td>Host Mother:</td>
			<td>#get_host_family.motherfirstname# #get_host_family.motherlastname#, 
				<cfif #get_host_family.motherbirth# is '0'><cfelse>
					<cfset calc_age_mom = #CreateDate(get_host_family.motherbirth,01,01)#> (#DateDiff('yyyy', calc_age_mom, now())#)
				</cfif> &nbsp;</td></tr>
			<tr><td>Occupation:</td>
			<td>#get_host_family.motherworktype#</td></tr></cfif>
		</table>
		<table align="left" style="font-size:13px">	
			<tr><i>#get_host_family.address#</i></td></tr>		 	
			<tr><td><i>#get_host_family.city#  #get_host_family.state#, #get_host_family.zip#</i></td></tr>
			<tr><td><i>#get_host_family.email#</i></td></tr>		
			<tr><td><i>#get_host_family.phone#</i></td></tr>
		</table><br> 	    
	</td></tr>
		<table width=650 align="center" style="font-size:13px">	
			<cfloop query="get_host_children">
				<cfif get_host_children.shared is 'yes'>
				<tr><td>The student will share a room with #get_host_children.name#.</td></tr></cfif>
			</cfloop>
			<cfif get_host_family.acceptsmoking  is 'yes'>
				<tr><td>The Host Family will accept a student who smokes.</td></tr></cfif>
			<cfif get_host_family.attendchurch is 'yes'>
			<tr><td>Host Family attends church 
					<cfif #get_host_family.religious_participation# is "active">several times per week.</cfif>
			        <cfif #get_host_family.religious_participation# is "average">once per week.</cfif>
					<cfif #get_host_family.religious_participation# is "little interest">occasionally.</cfif>
				&nbsp; 
				<cfif get_host_family.churchfam is 'no'>The student will be expected to attend church.</cfif>
				</td></tr>
			</cfif>
 		</table>
</table><br>

<!--- CHILDREN, INTERESTS AND PETS INFORMATION --->
<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<hr width=80% align="center">
		<tr><td>
		<table align="left" width=370 style="font-size:13px" cellpadding="0" cellspacing="1">
			<tr>
			<td width="130"><span class="profile_section_header">OTHERS</span><br></td>
			<td width="85"><span class="sub_profile_section_header">Relationship</span><br></td>
			<td width="45"><span class="sub_profile_section_header">Age</span><br></td>
			<td width="45"><span class="sub_profile_section_header">Sex</span><br></td>
			<td width="60"><span class="sub_profile_section_header">At home</span><br></td>
			<td width="5"><br></td>
			</tr>
			<cfloop query="get_host_children">
			<tr>
			<td>#get_host_children.name# &nbsp;</td>
			<td align="center">#membertype#</td>
			<td align="center"><cfif get_host_children.birthdate is ''><cfelse>#DateDiff('yyyy', get_host_children.birthdate, now())#</cfif></td>
			<td align="center">#get_host_children.sex#</td>
			<td align="center">#get_host_children.liveathome#</td>
			</tr>
			</cfloop></table>
		<table align="left" width=150 style="font-size:13px" cellpadding="0" cellspacing="1">
			<tr><td><span class="profile_section_header">INTERESTS</span><br></td>			
			<td width="5"><br></td></tr>
			<tr><td align="center">
				<cfset count = 0>
				<cfloop list=#get_host_family.interests# index=i> <!--- take all the interests from a list --->
					<cfset count = count + 1>
					<cfif count lt 7> <!---it shows up to 6 interests --->
						<cfquery name="get_interests" datasource="MySQL">
							Select interest 
							from smg_interests 
							where interestid = #i#
						</cfquery>					
					#LCASE(get_interests.interest)#<br>
					</cfif>
				</cfloop>
			</td></tr></table>
		<table align="left" width=130 style="font-size:13px" cellpadding="0" cellspacing="1">
			<tr>
			<td width="80%"><span class="profile_section_header">PETS</span><br></td>
			<td width="20%"><span class="sub_profile_section_header">No.</span><br></td>
			</tr>
			<cfloop query="get_host_pets">
			<tr>		
			<td align="center">#get_host_pets.animaltype#</td>
			<td align="center">#get_host_pets.number#</td>
			</tr>
			</cfloop>
		</table><br>
		<cfif get_host_family.interests_other is ''><cfelse>
		<tr><td><div align="justify">Other Interests: #get_host_family.interests_other#</div></tr></td></cfif>
</table><br>

<!--- SCHOOL INFORMATION --->
<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header_bold">SCHOOL INFORMATION</span><br> 	
	<tr><td>The student will attend the following school: #get_school.schoolname#.</tr></td>
	<tr><td>Address: <cfif get_school.address is ''>#get_school.address2#<cfelse>#get_school.address#</cfif>, #get_school.city#, 
			#get_school.state# #get_school.zip#. Phone: #get_school.phone#. (Distance: #get_host_family.schooldistance# miles). 
			Student will be transported to school by #get_host_family.schooltransportation#.</tr></td>
    <cfif get_school.principal is ''><cfelse>
	<tr><td>The school contact person will be #get_school.principal#.</tr></td></cfif> 
	<tr><td><cfif get_school_dates.enrollment is ''><cfelse>The school orientation will be on #DateFormat(get_school_dates.enrollment, 'mm-dd-yyyy')#. &nbsp;</cfif>
			<cfif get_school_dates.year_begins is ''><cfelse>School year will begin on #DateFormat(get_school_dates.year_begins, 'mm-dd-yyyy')#.</cfif> 
			<cfif get_school_dates.semester_ends is ''><cfelse>First semester will end on #DateFormat(get_school_dates.semester_ends, 'mm-dd-yyyy')#. &nbsp;</cfif>
			<cfif get_school_dates.semester_begins is ''><cfelse>Second semester will start on #DateFormat(get_school_dates.semester_begins, 'mm-dd-yyyy')#.</cfif>
			<cfif get_school_dates.year_ends is ''><cfelse>School year will end on #DateFormat(get_school_dates.year_ends, 'mm-dd-yyyy')#.</cfif> &nbsp;		
		</td></tr>
	<cfif get_host_family.schoolcosts is ''><cfelse>
	<tr><td>The student is responsible for the following costs: #get_host_family.schoolcosts#</td></tr>
	</cfif>
	<cfif get_school.url EQ ''><cfelse>
	<tr><td>Website: #get_school.url#</td></tr>
	</cfif>	
</table><br>

<!--- COMMUNITY INFORMATION --->
<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header_bold">COMMUNITY INFORMATION</span><br>
		<tr><td>
		<cfif get_host_family.community is ''><cfelse>The community is #get_host_family.community#</cfif><cfif get_host_family.community is 'small'> town</cfif>.		<cfif get_host_family.nearbigcity is ''><cfelse>The nearest big city is #get_host_family.nearbigcity# 
		(#get_host_family.near_city_dist# miles).</cfif>
		<cfif get_host_family.major_air_code is ''><cfelse>The Closest arrival airport is #get_host_family.major_air_code#
		<cfif get_host_family.airport_city is ''><cfelse>, in the city of #get_host_family.airport_city#</cfif>
			<cfif get_host_family.airport_state is ''><cfelse>, #get_host_family.airport_state#</cfif>.
		</cfif>
		<cfif get_host_family.pert_info is ''><cfelse>Points of interest in the community: #get_host_family.pert_info#</cfif>
		</td></tr>
</table><br>

<!--- STUDENT INFORMATION --->
<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<hr width=80% align="center">
	<span class="application_section_header_bold">STUDENT INFORMATION</span><br>
		<tr><td>
		<cfif get_student_info.placement_notes is ''><cfelse>#get_student_info.placement_notes#<br></cfif>		
		We will be sending you the complete Host Family application shortly. 

		<cfif get_history.recordcount EQ 0 OR get_history.isRelocation EQ 0>
			The student should plan to arrive within five days from start of school. Please advise us of 
			#get_student_info.firstname#'s arrival information as soon as possible.
		<cfelse>
			Note: this is a RELOCATION.
		</cfif><br>
		<cfif get_student_info.isWelcomeFamily EQ 1>PLEASE NOTE THIS IS A WELCOME FAMILY</cfif>		
		</td></tr>
</table><br>

<!--- PAGE BOTTON --->	
<table width=650 border=0 align="center" bgcolor="FFFFFF" style="font-size:13px">
	<tr><td align="left">
	Regards,<br>
	#get_facilitator.firstname# #get_facilitator.lastname#
	</td></tr>
</table>

</body>
</html>
</CFMAIL>

<span class="application_section_header">PLACEMENT INFORMATION LETTER</span>
<div class="row"><br>

<div align="center"><h2><u>#get_student_info.firstname# #get_student_info.familylastname# ( #get_student_info.studentid# )</u></h2></div>

<table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
<cfif IsDefined('form.self')>
	<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The PIS has been sent to #get_current_user.firstname# #get_current_user.lastname#</span></td></tr>
<cfelse>
	<tr align="center" bgcolor="ACB9CD"><td><span class="get_Attention">The PIS has been sent to #GetIntlReps.businessname# at #GetIntlReps.email# and you will receive a copy.</span></td></tr>
</cfif>
<tr>
<td align="center" bgcolor="ACB9CD">
	<input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
	<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
</td></tr>
</table>
</div>
</cfoutput>