<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Applicant Information</title>
</head>
<body>

<cfif NOT isDefined('form.doc_application')> 
	<cfset form.doc_application = '0'>
<cfelse>
	<cfset form.doc_application = '1'>
</cfif>

<cfif NOT isDefined('form.doc_resume')> 
	<cfset form.doc_resume = '0'>
<cfelse>
	<cfset form.doc_resume = '1'>
</cfif>

<cfif NOT isDefined('form.doc_proficiency')> 
	<cfset form.doc_proficiency = '0'>
<cfelse>
	<cfset form.doc_proficiency = '1'>
</cfif>

<cfif NOT isDefined('form.doc_passportphoto')> 
	<cfset form.doc_passportphoto = '0'>
<cfelse>
	<cfset form.doc_passportphoto = '1'>
</cfif>

<cfif NOT isDefined('form.doc_recom_letter')> 
	<cfset form.doc_recom_letter = '0'>
<cfelse>
	<cfset form.doc_recom_letter = '1'>
</cfif>

<cfif NOT isDefined('form.doc_insu')> 
	<cfset form.doc_insu = '0'>
<cfelse>
	<cfset form.doc_insu = '1'>
</cfif>

<cfif NOT isDefined('form.doc_sponsor_letter')> 
	<cfset form.doc_sponsor_letter = '0'>
<cfelse>
	<cfset form.doc_sponsor_letter = '1'>
</cfif>  

	<!--- CREATE UNIQUE ID ---->
	<cfset form.uniqueid = createuuid()>
	
	<cfquery name="insert_candidate" datasource="mysql">
		INSERT INTO extra_candidates
			(companyid, uniqueid, status, programid, intrep, subfieldid, fieldstudyid, entrydate, firstname, middlename, lastname, sex,
			dob, home_address, home_city, home_zip, home_country, home_phone, birth_city, birth_country, citizen_country,
			residence_country, emergency_phone, emergency_name, emergency_relationship, email, remarks, degree,
			degree_other, degree_comments, trainee_sponsor, startdate, enddate, personal_info,earliestarrival,
			doc_application, doc_resume, doc_proficiency, doc_passportphoto, doc_recom_letter, doc_insu, doc_sponsor_letter,
			missing_documents, 
			<!---- auto add ticket 1038 --->
			ds2019_street, ds2019_city, ds2019_state, ds2019_zip			
			)
		VALUES ('#client..companyid#', '#form.uniqueid#', '1', '#form.programid#', '#form.intrep#', '#form.listsubcat#', '#form.fieldstudyid#',
				 #CreateODBCDate(now())#, '#form.firstname#', '#form.middlename#', '#form.lastname#', 
				'#form.sex#', <cfif form.dob NEQ ''>#CreateODBCDate(form.dob)#<cfelse>NULL</cfif>, '#form.home_address#',
				'#form.home_city#', '#form.home_zip#', '#form.home_country#', '#form.home_phone#', '#form.birth_city#', '#form.birth_country#',
				'#form.citizen_country#', '#form.residence_country#', '#form.emergency_phone#', '#form.emergency_name#', '#form.emergency_relationship#', 
				'#form.email#', '#form.remarks#', '#form.degree#', '#form.degree_other#', 
				'#form.degree_comments#', '#form.trainee_sponsor#',
				<cfif form.startdate NEQ ''>#CreateODBCDate(form.startdate)#<cfelse>NULL</cfif>,
				<cfif form.enddate NEQ ''>#CreateODBCDate(form.enddate)#<cfelse>NULL</cfif>,
				'#form.personal_info#',
				<cfif form.earliestarrival NEQ ''>#CreateODBCDate(form.earliestarrival)#<cfelse>NULL</cfif>,
				'#form.doc_application#', '#form.doc_resume#', '#form.doc_proficiency#', '#form.doc_passportphoto#', '#form.doc_recom_letter#',
				'#form.doc_insu#', '#form.doc_sponsor_letter#', '#form.missing_documents#',  
				<!---- auto add ticket 1038 --->
				<!----<cfif ds2019_street is '' and ds2019_city is '' and ds2019_state is '' and ds2019_zip is ''>---->
				'119 Cooper Street', 'Babylon', 'NY', 11702	
				<!---<cfelse>
				'#form.ds2019_street#', '#form.ds2019_city#', '#form.ds2019_state#', '#form.ds2019_zip#'
				</cfif>---->
				
				)
	</cfquery>
	
	<cfquery name="get_candidateid" datasource="mysql">
		SELECT Max(candidateid) as candidateid, uniqueid
		FROM extra_candidates
		GROUP BY uniqueid 
	</cfquery>
		
	<cfoutput query="get_candidateid">
	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully created this candidate. Thank You.");
		//location.replace("?curdoc=candidate/candidate_form2&unqid=#uniqueid#");
		location.replace("?curdoc=candidate/candidates&order=candidateid&status=All");
	-->
	</script>
	</head>
	</html> 		
	</cfoutput>
		

</body>
</html>