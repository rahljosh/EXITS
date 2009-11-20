<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Letter Board School</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_student_unqid" datasource="MySql">
	SELECT s.studentid, s.firstname, s.familylastname, s.uniqueid, s.intrep,
		sc.schoolid, sc.schoolname, sc.address as schooladdress, sc.address2 as schooladdress2, sc.city as schoolcity, sc.zip as schoolzip,
		sc.email as schoolemail, sc.contact as schoolcontact, sc.phone as schoolphone, sc.major_air_code, sc.airport_city, sc.airport_state,
		sc.nearbigcity,
		sta.state as schoolstate,
		p.programid, p.programname, p.startdate,
		u.businessname, u.php_contact_name, u.fax, u.php_contact_email, u.php_contact_phone,
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.assignedid, stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_programs p ON stu_prog.programid = p.programid
	LEFT JOIN php_schools sc ON stu_prog.schoolid = sc.schoolid 
	LEFT JOIN smg_states sta ON sc.state = sta.id 
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	ORDER BY assignedid DESC	
</cfquery>

<cfquery name="get_school_dates" datasource="MySql">
	SELECT schooldateid, schoolid, php_school_dates.seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends,
			p.programid
	FROM php_school_dates
	INNER JOIN smg_programs p ON p.seasonid = php_school_dates.seasonid
	WHERE schoolid = <cfqueryparam value="#get_student_unqid.schoolid#" cfsqltype="cf_sql_integer">
		AND p.programid = <cfqueryparam value="#get_student_unqid.programid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>
<!--- Page Header --->
<table width="670" align="center" border=0 bgcolor="##FFFFFF" cellpadding="2" style="font-size:13px"> 
	<tr>
		<td>
		<table>
			<tr><td>To:</td><td>#get_student_unqid.businessname#</td></tr>
			<tr><td>Att:</td><td>#get_student_unqid.php_contact_name#</td></tr>
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
</table><br>

<!--- HEADER - OTHER INFORMATION --->
<table width=670 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td>We are pleased to give you the placement information for #get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#).</td></tr>
</table><br>

<!--- SCHOOL INFORMATION --->
<table width=670 align="center" border=0 bgcolor="FFFFFF" style="font-size:13px"> 
	<tr><td><hr width=100% align="center"></td></tr>
	<tr><td><div align="center"><span class="application_section_header"><font size=+1><b><u>School Information</u></b></font></span></div><br></td></tr> 	
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
	<tr><td><div align="center"><span class="application_section_header"><font size=+1><b><u>Student Information</u></b></font></span></div><br></td></tr> 	
	<tr><td>Student is applying for the #get_student_unqid.programname# program starting in #DateFormat(get_school_dates.year_begins, 'mmmm')#.</td></tr>
	<tr><td>A complete program packet will be sent to you shortly. Please advise us of #get_student_unqid.firstname#'<cfif #right(get_student_unqid.firstname, 1)# NEQ 's'>s</cfif> arrival information as soon as possible.</td></tr>
</table><br>

<!--- PAGE BOTTON --->	
<table width="670" align="center" border=0 cellpadding="1" cellspacing="1" style="font-size:13px">
	<tr><td>Best Regards,</td></tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
	<tr><td>Luke Davis</td></tr>	
	<tr><td>#companyshort.companyname#</td></tr>			
</table><br />

</cfoutput>

</body>
</html>