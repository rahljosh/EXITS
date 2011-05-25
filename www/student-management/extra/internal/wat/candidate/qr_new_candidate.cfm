<cfparam name="FORM.wat_participation" default="0">
<cfparam name="FORM.wat_doc_agreement" default="0">
<cfparam name="FORM.wat_doc_walk_in_agreement" default="0">
<cfparam name="FORM.wat_doc_cv" default="0">
<cfparam name="FORM.wat_doc_passport_copy" default="0">
<cfparam name="FORM.wat_doc_orientation" default="0">
<cfparam name="FORM.wat_doc_signed_assessment" default="0">
<cfparam name="FORM.wat_doc_college_letter" default="0">
<cfparam name="FORM.wat_doc_college_letter_translation" default="0">
<cfparam name="FORM.wat_doc_job_offer" default="0">
<cfparam name="FORM.wat_doc_job_offer_applicant" default="0">
<cfparam name="FORM.wat_doc_job_offer_employer" default="0">
<cfparam name="FORM.wat_doc_other" default="">

<cfquery name="qCheckForExistingCandidate" datasource="mysql">
	SELECT 
    	candidateid, 
        uniqueid,
        firstname, 
        lastname, 
        dob        
	FROM 
    	extra_candidates
	WHERE 
    	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">
    AND	
    	lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">
    AND 
    	DOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#">
</cfquery>

<cfif VAL(qCheckForExistingCandidate.recordcount)>
    <table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90% style="margin-top:10px;">
        <tr><th background="images/back_menu2.gif" class="title1">EXITS - Error Message</th></tr>
        <tr><td class="style1">Sorry, but this candidate has been entered in the database as follow:</td></tr>
        <tr>
            <td align="center">
				<cfoutput>
                    <a href="index.cfm?curdoc=candidate/candidate_info&uniqueid=#qCheckForExistingCandidate.uniqueid#">
	                    #qCheckForExistingCandidate.firstname# #qCheckForExistingCandidate.lastname# (###qCheckForExistingCandidate.candidateid#)
                    </a>
                </cfoutput>
            </td>
        </tr>
        <tr><td align="center"><input name="back" type="image" src="../pics/goback.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
    </table>
	<cfabort>
</cfif>

<cfif NOT LEN(FORM.email)>

	<cfquery name="qCheckUsername" datasource="MySql">
		SELECT email
		FROM extra_candidates
		WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
	</cfquery>
    
	<cfif VAL(qCheckUsername.recordcount)><br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=90% style="margin-top:10px;">
			<tr><th background="images/back_menu2.gif" class="title1">EXITS - Error Message</th></tr>
			<cfoutput>
			<tr><td class="style1">Sorry, the e-mail address <b>#FORM.email#</b> is being used by another account.</td></tr>
			<tr><td class="style1">Please click on the "back" button below and enter a new e-mail address.</td></tr>
			<tr><td align="center"><input name="back" type="image" src="../pics/goback.gif" align="middle" border=0 onClick="history.back()"></div><br></td></tr>
			</cfoutput>
		</table>
		<cfabort>
	</cfif>
    
</cfif>

<cfset FORM.uniqueID = CreateUUID()>

<!---- INSERT CANDIDATE ---->
<cfquery datasource="mysql" result="newRecord">
	INSERT INTO 
		extra_candidates
	(
		companyid, 
		uniqueid, 
		status, 
		programid, 
		intrep, 
		wat_participation, 
		entrydate,
		firstname, 
		middlename, 
		lastname, 
		sex,
		dob, 
		email, 
		home_address, 
		home_city, 
		home_zip, 
		home_country, 
		home_phone, 
		birth_city, 
		birth_country, 
		citizen_country,
		residence_country, 
		emergency_phone, 
		emergency_name,
		passport_number,
		ssn, 
		englishAssessment,
		englishAssessmentDate, 
		englishAssessmentComment, 
		wat_placement,  
		wat_vacation_start,
		wat_vacation_end, 
		<!---- documents control --->
        wat_doc_agreement,
        wat_doc_walk_in_agreement,
        wat_doc_cv,
        wat_doc_passport_copy,
        wat_doc_orientation,
        wat_doc_signed_assessment,
        wat_doc_college_letter,
        wat_doc_college_letter_translation,
        wat_doc_job_offer,
        wat_doc_job_offer_applicant,
        wat_doc_job_offer_employer,
		wat_doc_other,
		requested_placement, 
		startdate, 
		enddate
	)
	VALUES 
	(	
		<cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_participation#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_address#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_city#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_zip#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_country#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_phone#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.birth_city#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.birth_country#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.citizen_country#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.residence_country#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.passport_number#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.encryptVariable(FORM.SSN)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.englishAssessment#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.englishAssessmentDate#" null="#NOT IsDate(FORM.englishAssessmentDate)#">, 
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.englishAssessmentComment#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_placement#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.wat_vacation_start#" null="#NOT IsDate(FORM.wat_vacation_start)#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.wat_vacation_end#" null="#NOT IsDate(FORM.wat_vacation_end)#">, 
		<!--- document control --->
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_agreement#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_walk_in_agreement#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_cv#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_passport_copy#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_orientation#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_signed_assessment#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_college_letter#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_college_letter_translation#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_job_offer#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_job_offer_applicant#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_job_offer_employer#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_doc_other#">,
        
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.combo_request#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.startdate#" null="#NOT IsDate(FORM.startdate)#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.enddate#" null="#NOT IsDate(FORM.enddate)#"> 
	)
</cfquery>

<!---- PROGRAM HISTORY ---->
<cfif VAL(FORM.programid)>

	<cfquery name="program_history" datasource="mysql">
        INSERT INTO 
        	extra_program_history
        (
        	candidateid, 
            reason, 
            date, 
            programid, 
            userid 
		)
        VALUES 
        (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Candidate was unassigned">, 
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
		)
	</cfquery>
    
</cfif>
	
<cflocation url="?curdoc=candidate/candidate_info&uniqueid=#FORM.uniqueid#" addtoken="no">
