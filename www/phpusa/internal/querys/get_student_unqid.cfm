<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Student Information</title>
</head>

<body>

<cftry>

<!--- IF STUDENTS IN PROGRAM IS NOT DEFINED --->
<cfif NOT IsDefined('url.assignedid')>
	<cfquery name="get_assignedid" datasource="#application.dsn#">
		SELECT s.studentid,
			stu_prog.assignedid
		FROM smg_students s
		INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
		WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
		ORDER BY stu_prog.active DESC, assignedid
	</cfquery>
	<cfparam name="url.assignedid" default="#get_assignedid.assignedid#">
</cfif>

<cfquery name="get_student_unqid" datasource="#application.dsn#">
	SELECT s.studentid, uniqueid, familylastname, firstname, middlename, fathersname, fatheraddress,
		fatheraddress2, fathercity, fathercountry, fatherzip, fatherbirth, fathercompany, fatherworkphone,
		fatherworkposition, fatherworktype, fatherenglish, motherenglish, mothersname, motheraddress,
		motheraddress2, mothercity, mothercountry, motherzip, motherbirth, mothercompany, motherworkphone,
		motherworkposition, motherworktype, emergency_phone, emergency_name, emergency_address, 
		emergency_country, address, address2, city, country, zip, phone, fax, email, citybirth, countrybirth,
		countryresident, countrycitizen, sex, dob, religiousaffiliation, dateapplication, entered_by,
		passportnumber, intrep, current_state, approved, band, orchestra, comp_sports, cell_phone, additional_phone,
		emergency_name, emergency_phone, convalidation_completed,
		familyletter, pictures, interests, interests_other, religious_participation, churchfam, churchgroup,
		smoke, animal_allergies, med_allergies, other_allergies, chores, chores_list, weekday_curfew, 
		weekend_curfew, letter, height, weight, haircolor, eyecolor, graduated, direct_placement, 
		direct_place_nature, termination_date, 
		notes, yearsenglish, estgpa, transcript, language_eval, social_skills, health immunization, health,
		minorauthorization, placement_notes, needs_smoking_house, likes_pets, accepts_private_high,
		app_completed_school, visano, grades, slep_Score, convalidation_needed, other_missing_docs, 
		flight_info_notes, scholarship, app_current_status, php_wishes_graduate, php_grade_student,  
		php_passport_copy, 
		<!--- FROM THE NEW TABLE PHP_STUDENTS_IN_PROGRAM --->		
		stu_prog.assignedid, stu_prog.companyid, stu_prog.programid, stu_prog.hostid, stu_prog.schoolid, stu_prog.placerepid, stu_prog.arearepid,
		stu_prog.dateplaced, stu_prog.school_acceptance, stu_prog.active, stu_prog.i20no, stu_prog.i20received, stu_prog.i20note,
		stu_prog.i20sent, stu_prog.doubleplace, stu_prog.canceldate, stu_prog.cancelreason, stu_prog.insurancedate, stu_prog.insurancecanceldate,
		stu_prog.hf_placement, stu_prog.hf_application, stu_prog.sevis_fee_paid, stu_prog.transfer_type,
		stu_prog.doc_evaluation9, stu_prog.doc_evaluation12, stu_prog.doc_evaluation2, stu_prog.doc_evaluation4, stu_prog.doc_evaluation6, 
		stu_prog.doc_grade1, stu_prog.doc_grade2, stu_prog.doc_grade3, stu_prog.doc_grade4, stu_prog.doc_grade5, stu_prog.doc_grade6,stu_prog.doc_grade7,
		stu_prog.doc_grade8,
		stu_prog.return_student, stu_prog.flightinfo_sent, stu_prog.flightinfo_received, stu_prog.flightinfo_no, stu_prog.flightinfo_note
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
		AND stu_prog.assignedid = <cfqueryparam value="#url.assignedid#" cfsqltype="cf_sql_integer" maxlength="5">
</cfquery>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
</body>
</html>