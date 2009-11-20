<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Applicant Information</title>
</head>
<body>

<!--- <cftry> --->

<cfif form.firstname EQ '' AND form.familylastname EQ ''><br>
	<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
		<tr><th background="images/back_menu2.gif">AXIS - Error Message</th></tr>
		<tr><td>You must enter student's firstname and/or last name in order to continue. Please go back and try again.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="check_new_student" datasource="mysql">
	SELECT s.studentid, s.firstname, s.familylastname, s.dob
	FROM smg_students s
	WHERE s.firstname = '#form.firstname#' 
		AND	s.familylastname = '#form.familylastname#'
		AND s.dob = '#DateFormat(form.dob, 'yyyy/mm/dd')#'
</cfquery>

<cfif check_new_student.recordcount NEQ '0'><br>
	<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
		<tr><th background="images/back_menu2.gif">AXIS - Error Message</th></tr>
		<tr><td>Sorry, but this student has been entered in the database as follow:</td></tr>
		<tr>
			<td align="center">
				<cfoutput query="check_new_student">
				<a href="?curdoc=forms/student_info&studentid=#check_new_student.studentid#">#firstname# #familylastname# (#studentid#)</a>
				</cfoutput> 
			</td>
		</tr>
		<tr><td align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
	</table>
	<cfabort>
</cfif>

<cfif form.email NEQ ''>
	<cfquery name="check_username" datasource="MySql">
		SELECT email
		FROM smg_students
		WHERE email = '#form.email#'
	</cfquery>
	<cfif check_username.recordcount NEQ '0'><br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
			<tr><th background="images/back_menu2.gif">AXIS - Error Message</th></tr>
			<cfoutput>
			<tr><td>Sorry, the e-mail address <b>#form.email#</b> is being used by another account.</td></tr>
			<tr><td>Please click on the "back" button below and enter a new e-mail address.</td></tr>
			<tr><td align="center"><input name="back" type="image" src="../pics/back.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
			</cfoutput>
		</table>
		<cfabort>
	</cfif>
</cfif>

<cftransaction action="begin" isolation="serializable">	
	
	<cfquery name="insert_student" datasource="mysql">
		INSERT INTO smg_students
			(uniqueid, companyid, entered_by, dateapplication, familylastname, firstname, middlename, address, address2, city, country, zip, phone, fax,
			email, sex, dob, citybirth, countrybirth, countryresident, countrycitizen, passportnumber, height, weight, haircolor, eyecolor)
		VALUES ('#form.uniqueid#', '#client.companyid#', '#client.userid#', #now()#,
				<cfqueryparam value="#form.familylastname#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#form.middlename#" cfsqltype="cf_sql_char">,
				'#form.address#', '#form.address2#', '#form.city#', '#form.country#', 
				'#form.zip#',	'#form.phone#', '#form.fax#', '#form.email#',
				<cfif IsDefined('form.sex')> '#form.sex#'<cfelse>''</cfif>,
				<cfif form.dob NEQ ''>#CreateODBCDate(form.dob)#<cfelse>NULL</cfif>,
				'#form.citybirth#', '#form.countrybirth#', '#form.countryresident#', '#form.countrycitizen#',
				'#form.passportnumber#', '#form.height#', '#form.weight#', '#form.haircolor#', '#form.eyecolor#')
	</cfquery>
	
	<cfquery name="get_studentid" datasource="mysql">
		SELECT Max(studentid) as studentid
		FROM smg_students
	</cfquery>

	<cfquery name="get_uniqueid" datasource="mysql">
		SELECT uniqueid
		FROM smg_students
		WHERE studentid = '#get_studentid.studentid#'
	</cfquery>
	
	<cfquery name="add_student" datasource="MySql">
		INSERT INTO php_students_in_program 
			(studentid, companyid, inputby, active, datecreated) 
		VALUES ('#get_studentid.studentid#', '#client.companyid#', '#client.userid#', '1', #CreateODBCDate(now())#)		
	</cfquery>		
	
	<cfoutput>
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully created this student. Thank You.");
		location.replace("?curdoc=student/student_form2&unqid=#get_uniqueid.uniqueid#");
	-->
	</script>
	</head>
	</html> 		
	</cfoutput>
		
</cftransaction>

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry> --->
</body>
</html>