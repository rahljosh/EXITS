<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Letter Day School</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_unqid" datasource="MySql">
	SELECT 
    	s.studentid, s.firstname, s.familylastname, s.uniqueid, s.intrep,
		sc.schoolid, sc.schoolname, sc.address as schooladdress, sc.address2 as schooladdress2, sc.city as schoolcity, sc.zip as schoolzip,
		sc.email as schoolemail, sc.contact as schoolcontact, sc.phone as schoolphone, sc.major_air_code, sc.airport_city, sc.airport_state,
		sc.nearbigcity,
        sc.fk_ny_user,
		sta.state as schoolstate,
		p.programid, p.programname, p.startdate,
		u.businessname, u.php_contact_name, u.fax, u.php_contact_email, u.php_contact_phone,
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.assignedid, stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no
	FROM 
    	smg_students s
	INNER JOIN 
    	php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	LEFT JOIN 
    	smg_users u ON u.userid = s.intrep
	LEFT JOIN 
    	smg_programs p ON stu_prog.programid = p.programid
	LEFT JOIN 
    	php_schools sc ON stu_prog.schoolid = sc.schoolid 
	LEFT JOIN 
    	smg_states sta ON sc.state = sta.id
	WHERE 
    	s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	AND 
    	stu_prog.assignedid = <cfqueryparam value="#url.assignedid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif get_student_unqid.schoolid EQ ''>
	<table width="670" align="center" border=0 bgcolor="#FFFFFF" cellpadding="2" style="font-size:13px"> 
		<tr><td>Student is not assigned to a school. Please assign the student to a school.</td></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="get_school_dates" datasource="MySql">
	SELECT schooldateid, schoolid, php_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
			p.programid
	FROM php_school_dates
	INNER JOIN smg_programs p ON p.seasonid = php_school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#get_student_unqid.schoolid#" cfsqltype="cf_sql_integer">
	AND p.programid = <cfqueryparam value="#get_student_unqid.programid#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Get NY Facilitator --->
<cfquery name="qGetNYFacilitator" datasource="mySql">
	SELECT
    	u.userID,
        u.firstName,
        u.lastName,
        u.email
	FROM
    	smg_users u
	WHERE
    	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.fk_ny_user#">                      
</cfquery>

<!-----Host Family----->
<cfquery name="get_hf" datasource="MySQL">
	Select *
	From smg_hosts
	Where hostid = '#get_student_unqid.hostid#'
</cfquery>

<!-----Host Children----->
<cfquery name="get_hf_children" datasource="MySQL">
	Select *
	From smg_host_children
	Where hostid = '#get_student_unqid.hostid#'
	Order by birthdate
</cfquery>

<!-----Get Host Family Pets----->
<cfquery name="get_hf_pets" datasource="MySQL">
	select hostid, animaltype, number, indoor
	from smg_host_animals
	Where hostid = '#get_student_unqid.hostid#'
</cfquery>

<cfif get_student_unqid.hostid EQ 0>
	<table width="670" align="center" border=0 bgcolor="#FFFFFF" cellpadding="2" style="font-size:13px"> 
		<tr><td>Student is not assigned to a host family. Please assign a student to a host family or print the boarding school placement letter.</td></tr>
	</table>
	<cfabort>
</cfif>

<cfoutput>

<!--- Page Header --->
<table width="670" align="center" border=0 bgcolor="##FFFFFF" cellpadding="2" style="font-size:13px"> 
	<tr>
		<td>
		<table>
			<tr><td>To:</td><td>#get_student_unqid.businessname#</td></tr>
			<tr><td>Att:</td><td>#get_student_unqid.php_contact_name#</td>
			<tr><td>Fax:</td><td>#get_student_unqid.fax#</td></tr>
			<tr><td>E-mail:</td><td><a href="mailto:#get_student_unqid.php_contact_email#">#get_student_unqid.php_contact_email#</a></td></tr>
			<tr><td colspan="2">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		</td>
		<td valign="top" rowspan=4 align="center"><img src="../pics/dmd-logo.jpg"></td>
		<td valign="top" align="right" > 
			<b>#companyshort.companyname#</b><br>
			#companyshort.address#<br>
			#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
			<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
			<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
			<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif>
		</td>
	</tr>
</table>

<!--- HEADER - OTHER INFORMATION --->
<table width=670 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td>We are pleased to give you the placement information for #get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#).</td></tr><br>
	<cfif VAL(qGetNYFacilitator.recordCount)>
    	<tr>	
        	<td> 
            	<br>
            	Please note for the Agent and Student, the Main Office Student Services Facilitator will be #qGetNYFacilitator.firstName# #qGetNYFacilitator.lastName#. <br>                
			    You may contact this person by email at <a href="mailto:#qGetNYFacilitator.email#">#qGetNYFacilitator.email#</a>
            </td>
       </tr>
    </cfif>
</table>

<!--- PLACEMENT INFORMATION --->
<table width=670 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td colspan="2"><hr width=100% align="center"></td></tr>
	<tr><td colspan="2" class="application_section_header">Placement Information</td></tr> 	
	<tr>
		<td width="50%" valign="top">
			<table width="100%">
				<cfif get_hf.fatherfirstname NEQ ''>
					<tr>
						<td width="100">Host Father : </td>
						<td>#get_hf.fatherfirstname# #get_hf.fatherlastname# <cfif LEN(get_hf.fatherbirth)>(#Year(now())-get_hf.fatherbirth#)</cfif></td>
					</tr>
					<tr><td>Occupation : </td><td>#get_hf.fatherworktype#</td></tr>
				</cfif>
				<cfif get_hf.motherfirstname NEQ ''>
					<tr>
						<td width="100">Host Mother : </td>
						<td>#get_hf.motherfirstname# #get_hf.motherlastname# <cfif LEN(get_hf.motherBirth)>(#Year(now())-get_hf.motherBirth#)</cfif></td>
					</tr>
					<tr><td>Occupation : </td><td>#get_hf.motherworktype#</td></tr>
				</cfif>
			</table>
		</td>
		<td width="50%" valign="top">
			<table width="100%">
				<tr><td><i>#get_hf.address#</i></td></tr>		 	
				<tr><td><i>#get_hf.city#  #get_hf.state#, #get_hf.zip#</i></td></tr>
				<tr><td><i>#get_hf.email#</i></td></tr>		
				<tr><td><i>#get_hf.phone#</i></td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%">
				<cfloop query="get_hf_children">
					<cfif shared EQ 'yes'>
						<tr><td>The student will share a room with #name#.</td></tr>
					</cfif>
				</cfloop>
				<cfif get_hf.acceptsmoking  EQ 'yes'>
					<tr><td>The Host Family will accept a student who smokes.</td></tr></cfif>
				<cfif get_hf.attendchurch EQ 'yes'>
					<tr><td>
							Host Family attends church 
							<cfif get_hf.religious_participation EQ "active">several times per week.
							<cfelseif get_hf.religious_participation EQ "average">once per week.
							<cfelseif get_hf.religious_participation EQ "little interest">occasionally.
							</cfif>
							<cfif get_hf.churchfam EQ 'no'> The student will be expected to attend church.</cfif>
						</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>

<!--- CHILDREN, INTERESTS AND PETS INFORMATION --->
<table width=650 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
		<tr><td>
				<table align="left" width="370" style="font-size:13px" cellpadding="0" cellspacing="1">
					<tr>
						<td width="100" class="profile_section_header">OTHERS</td>
						<td width="90" class="profile_section_header">Relationship</td>
						<td width="55" class="profile_section_header">Age</td>
						<td width="55" class="profile_section_header">Sex</td>
						<td width="85" class="profile_section_header">At home</td>
						<td width="5">&nbsp;</td>
					</tr>
					<cfloop query="get_hf_children">
					<tr>
					<td>#name# &nbsp;</td>
					<td align="center">#membertype#</td>
					<td align="center"><cfif birthdate NEQ ''>#DateDiff('yyyy', birthdate, now())#</cfif></td>
					<td align="center">#sex#</td>
					<td align="center">#liveathome#</td>
					</tr>
					</cfloop>
				</table>
				<table align="left" width=150 style="font-size:13px" cellpadding="0" cellspacing="1">
					<tr><td class="profile_section_header">INTERESTS<br></td>			
					<td width="5"><br></td></tr>
					<tr><td align="center">
						<cfset count = 0>
						<cfloop list="#get_hf.interests#" index="i"> <!--- gets all interests from a list --->
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
					</td></tr>
				</table>
				<table align="left" width=130 style="font-size:13px" cellpadding="0" cellspacing="1">
					<tr>
						<td width="80%" class="profile_section_header">PETS<br></td>
						<td width="20%" class="profile_section_header">No.<br></td>
					</tr>
					<cfloop query="get_hf_pets">
						<tr>		
							<td align="center">#animaltype#</td>
							<td align="center">#number#</td>
						</tr>
					</cfloop>
				</table><br>
		<cfif get_hf.interests_other NEQ ''><tr><td><div align="justify">Other Interests: #get_hf.interests_other#</div></tr></td></cfif>
</table>

<!--- SCHOOL INFORMATION --->
<table width=670 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td><hr width=100% align="center"></td></tr>
	<tr><td class="application_section_header">School Information</td></tr> 	
	<tr><td>The student will attend the following school: #get_student_unqid.schoolname#.</tr></td>
	<tr><td>Address: <cfif get_student_unqid.schooladdress EQ ''>#get_student_unqid.schooladdress2#<cfelse>#get_student_unqid.schooladdress#</cfif>,
			#get_student_unqid.schoolcity#, #get_student_unqid.schoolstate# #get_student_unqid.schoolzip#. Phone: #get_student_unqid.schoolphone#. 
		</td>
	</tr>
	<tr><td>The school contact person will be #get_student_unqid.schoolcontact#.</td></tr>
	<tr><td>
			<cfif get_school_dates.year_begins NEQ ''>School year will begin on #DateFormat(get_school_dates.year_begins, 'mm-dd-yyyy')#. &nbsp;</cfif>
			<cfif get_school_dates.semester_ends NEQ ''>First semester will end on #DateFormat(get_school_dates.semester_ends, 'mm-dd-yyyy')#. &nbsp; </cfif>
			<cfif get_school_dates.semester_begins NEQ ''>Second semester will start on #DateFormat(get_school_dates.semester_begins, 'mm-dd-yyyy')#. &nbsp; </cfif>
			<cfif get_school_dates.year_ends NEQ ''>School year will end on #DateFormat(get_school_dates.year_ends, 'mm-dd-yyyy')#. &nbsp; </cfif>	
			<cfif get_school_dates.enrollment NEQ ''>The school orientation will be on #DateFormat(get_school_dates.enrollment, 'mm-dd-yyyy')#.&nbsp;</cfif>
		</td>
	</tr>
	<tr><td><cfif get_student_unqid.nearbigcity NEQ ''>The nearest big city is #get_student_unqid.nearbigcity#. &nbsp;</cfif> The closest arrival airport is #get_student_unqid.airport_city#, #get_student_unqid.airport_state# <cfif get_student_unqid.major_air_code NEQ ''>(#get_student_unqid.major_air_code#)</cfif>.</td></tr>
</table><br>

<!--- STUDENT INFORMATION --->
<table width=670 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td><hr width=100% align="center"></td></tr>
	<tr><td class="application_section_header">Student Information</td></tr> 	
	<cfif get_student_unqid.placerepid NEQ 0>
		<cfquery name="get_placerep" datasource="MySql">
			SELECT u.firstname, u.lastname, u.address, u.city, u.zip, u.phone, sta.state
			FROM smg_users u
			LEFT JOIN smg_states sta ON u.state = sta.id 
			WHERE userid = '#get_student_unqid.placerepid#'
		</cfquery>
		<tr><td>Your local contact will be #get_placerep.firstname# #get_placerep.lastname#. &nbsp; Address: #get_placerep.address# #get_placerep.state# #get_placerep.zip#. &nbsp; Phone: #get_placerep.phone# .</td></tr>
	</cfif>
	<tr>
		<td>We will be sending you the complete Host Family application shortly. The student should plan to arrive within five days from start of school.
			Please advise us of #get_student_unqid.firstname#'s arrival information as soon as possible.
		</td>
	</tr>
</table><br>

<!--- PAGE BOTTON --->	
<table width="670" align="center" border=0 cellpadding="1" cellspacing="1" style="font-size:13px">
	<tr><td>Best Regards,</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
	<tr><td>Luke Davis</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table>

</cfoutput>

</body>
</html>