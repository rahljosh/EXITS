<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Applicant Information</title>
</head>
<body>

<cfquery name="check_new_candidate" datasource="mysql">
	SELECT candidateid, firstname, lastname, dob
	FROM extra_candidates
	WHERE firstname = '#form.firstname#' 
		AND	lastname = '#form.lastname#'
		AND DOB = '#DateFormat(form.dob, 'yyyy/mm/dd')#'
</cfquery>

<cfif check_new_candidate.recordcount NEQ '0'><br>
	<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
		<tr><th background="images/back_menu2.gif" class="title1">EXITS - Error Message</th>
		</tr>
		<tr><td class="style1">Sorry, but this candidate has been entered in the database as follow:</td></tr>
		<tr>
			<td align="center">
				<cfoutput query="check_new_candidate">
				<a href="?curdoc=forms/candidate_info&candidateid=#check_new_candidate.candidateid#">#firstname# #lastname# (#candidateid#)</a>
				</cfoutput>
			</td>
		</tr>
		<tr><td align="center"><input name="back" type="image" src="../pics/goback.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
	</table>
	<cfabort>
</cfif>

<cfif form.email NEQ ''>
	<cfquery name="check_username" datasource="MySql">
		SELECT email
		FROM extra_candidates
		WHERE email = '#form.email#'
	</cfquery>
	<cfif check_username.recordcount NEQ '0'><br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90%>
			<tr><th background="images/back_menu2.gif" class="title1">EXITS - Error Message</th>
			</tr>
			<cfoutput>
			<tr><td class="style1">Sorry, the e-mail address <b>#form.email#</b> is being used by another account.</td></tr>
			<tr><td class="style1">Please click on the "back" button below and enter a new e-mail address.</td></tr>
			<tr><td align="center"><input name="back" type="image" src="../pics/goback.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
			</cfoutput>
		</table>
		<cfabort>
	</cfif>
</cfif>

	<!--- CREATE UNIQUE ID ---->
	<cfset form.uniqueid = createuuid()>
	
	<!---- ADD TO TABLE ---->
	<cfquery name="insert_candidate" datasource="mysql">
		INSERT INTO extra_candidates
			(companyid, uniqueid, status, programid, intrep, h2b_participated , entrydate, firstname, middlename, lastname, sex,
			dob, home_address, <!----home_city, home_zip, ---->home_country, home_phone, birth_city, birth_country, citizen_country,
			residence_country, emergency_phone, emergency_name, <!----emergency_relationship,----> email, personal_info, <!-----earliestarrival, latestarrival,---->
			passport_number, passport_country, ssn, passport_date, passport_expires, requested_placement, startdate, enddate )
		VALUES ('#client.companyid#', '#form.uniqueid#', '1', '#form.programid#', '#form.intrep#', '#form.h2b_participated #',
				#CreateODBCDate(now())#, '#form.firstname#', '#form.middlename#', '#form.lastname#', '#form.sex#',
				<cfif form.dob NEQ ''>#CreateODBCDate(form.dob)#<cfelse>NULL</cfif>, '#form.home_address#',
				<!----'#form.home_city#', '#form.home_zip#', --->'#form.home_country#', '#form.home_phone#', '#form.birth_city#', '#form.birth_country#',
				'#form.citizen_country#', '#form.residence_country#', '#form.emergency_phone#', '#form.emergency_name#', 
				<!----'#form.emergency_relationship#',---> '#form.email#', '#form.personal_info#',
				<!-----<cfif form.earliestarrival NEQ ''>#CreateODBCDate(form.earliestarrival)#<cfelse>NULL</cfif>,
				<cfif form.latestarrival NEQ ''>#CreateODBCDate(form.latestarrival)#<cfelse>NULL</cfif>,------>
				'#form.passport_number#',	'#form.passport_country#',	'#form.ssn#',
				<cfif form.passport_date NEQ ''>#CreateODBCDate(form.passport_date)#<cfelse>NULL</cfif>,
				<cfif form.passport_expires NEQ ''>#CreateODBCDate(form.passport_expires)#<cfelse>NULL</cfif>,

				<cfif form.combo_request NEQ ''>'#form.combo_request#' <cfelse>NULL</cfif>,
				
				<cfif form.program_startdate NEQ ''>#CreateODBCDate(form.program_startdate)#<cfelse>NULL</cfif>,
				<cfif form.program_enddate NEQ ''>#CreateODBCDate(form.program_enddate)#<cfelse>NULL</cfif>
				
				)
	</cfquery>
	
	<!---- GET ID ---->
	<cfquery name="get_candidateid" datasource="mysql">
		SELECT Max( candidateid ) AS candidateid
		FROM extra_candidates 
	</cfquery>
	
	
	<!---- PROGRAM HISTORY ---->
	<cfif #form.programid# NEQ ''>
		<cfquery name="program_history" datasource="mysql">
		INSERT INTO extra_program_history
			(candidateid, reason, date, programid, userid )
		VALUES ('#get_candidateid.candidateid#', 'Candidate was unassigned', #CreateODBCDate(now())#, '#form.programid#', '#client.userid#')
		</cfquery>
	</cfif>
		
		
		<cfquery name="get_max_candidate" datasource="mysql">
		  SELECT uniqueid 
		  FROM extra_candidates
		  WHERE candidateid = #get_candidateid.candidateid#
		</cfquery>
		
	<cfoutput query="get_max_candidate">
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully created this candidate. Thank You.");
		//location.replace("?curdoc=candidate/candidate_form2&unqid=#uniqueid#");
		//location.replace("?curdoc=candidate/candidates&order=candidateid&status=All");
		location.replace("?curdoc=candidate/candidate_info&uniqueid=#uniqueid#");
	-->
	</script>
	</head>
	</html> 		
	</cfoutput>
		

</body>
</html>