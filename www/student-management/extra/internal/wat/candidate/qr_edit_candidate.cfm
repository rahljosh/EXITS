
<!--- Param FORM Variables --->
<cfparam name="FORM.wat_doc_agreement" default="0">
<cfparam name="FORM.wat_doc_walk_in_agreement" default="0">
<cfparam name="FORM.wat_doc_cv" default="0">
<cfparam name="FORM.wat_doc_passport_copy" default="0">
<cfparam name="FORM.wat_doc_orientation" default="0">
<cfparam name="FORM.wat_doc_signed_assessment" default="0">
<cfparam name="FORM.wat_doc_college_letter" default="0">
<cfparam name="FORM.wat_doc_college_letter_translation" default="0">
<cfparam name="FORM.wat_doc_job_offer_applicant" default="0">
<cfparam name="FORM.wat_doc_job_offer_employer" default="0">
<cfparam name="FORM.wat_doc_other" default="">
<cfparam name="FORM.wat_doc_other_received" default="">
<cfparam name="FORM.verification_address" default="0">
<cfparam name="FORM.verification_sevis" default="0">
<cfparam name="FORM.watDateCheckedIn" default="">
<cfparam name="FORM.usPhone" default="">
<cfparam name="FORM.watDateEvaluation1" default="">
<cfparam name="FORM.watDateEvaluation2" default="">
<cfparam name="FORM.watDateEvaluation3" default="">
<cfparam name="FORM.watDateEvaluation4" default="">
<!--- Placement Information --->
<cfparam name="FORM.jobID" default="0">
<cfparam name="FORM.selfJobOfferStatus" default="Pending">
<cfparam name="FORM.selfConfirmationName" default="">
<cfparam name="FORM.selfConfirmationDate" default="">
<cfparam name="FORM.selfConfirmationMethod" default="">
<cfparam name="FORM.selfEmailConfirmationDate" default="">
<cfparam name="FORM.selfPhoneConfirmationDate" default="">
<!--- Program Information --->
<cfparam name="FORM.wat_participation" default="">
<cfparam name="FORM.wat_participation_info" default="">
<!--- Host Company --->
<cfparam name="FORM.authenticationType" default="">
<cfparam name="FORM.EIN" default="">
<cfparam name="FORM.workmensCompensation" default="">
<cfparam name="FORM.WCDateExpried" default="">
<!--- End of Host Company --->
<cfparam name="FORM.selfConfirmationDate" default="">
<cfparam name="FORM.selfFindJobOffer" default="">
<cfparam name="FORM.selfConfirmationNotes" default="">
<!--- Transfer ---->
<cfparam name="FORM.isTransfer" default="0">
<cfparam name="FORM.dateTransferConfirmed" default="">
<cfparam name="FORM.isTransferJobOfferReceived" default="0">
<cfparam name="FORM.isTransferHousingAddressReceived" default="0">
<cfparam name="FORM.isTransferSevisUpdated" default="0">
<!--- English Assessment --->
<cfparam name="FORM.englishAssessment" default="">
<cfparam name="FORM.englishAssessmentDate" default="">
<cfparam name="FORM.englishAssessmentComment" default="">

<cfquery name="qGetCandidateInfo" datasource="#APPLICATION.DSN.Source#">
    SELECT 
    	candidateID, 
        programID, 
        hostCompanyID
    FROM 
    	extra_candidates
    WHERE 
    	uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.uniqueid#">
</cfquery>
	
<cfscript>
	qGetCurrentPlacement = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=FORM.candidateID);

	// SSN - Check if we need to update or not SSN
	vUpdateSSN = 0;
	// Will update if it's blank or there is a new number
	if ( isValid("social_security_number", Trim(FORM.SSN)) ) {
		// Encrypt Social
		FORM.SSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
		// Update
		vUpdateSSN = 1;
	} else if ( NOT LEN(FORM.SSN) ) {
		// Update - Erase SSN
		vUpdateSSN = 1;
	}
	
	// Add stamp to notes
	if ( LEN(FORM.selfConfirmationNotes) AND CompareNoCase(FORM.selfConfirmationNotes, qGetCurrentPlacement.selfConfirmationNotes) NEQ 0 ) {
		// Add User Time Stamp to notes
		FORM.selfConfirmationNotes = FORM.selfConfirmationNotes & " - Added by #CLIENT.firstName# #CLIENT.lastName# on #DateFormat(now(), 'mm/dd/yy')# at #TimeFormat(now(), 'hh:mm tt')# EST";
	}
	
	/*** Online Application ***/
	
	// Get Questions for section 1
	qGetQuestionsSection1 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section1');
	
	// Param Online Application Form Variables 
	for ( i=1; i LTE qGetQuestionsSection1.recordCount; i=i+1 ) {
		param name="FORM[qGetQuestionsSection1.fieldKey[i]]" default="";
	}

	// Insert/Update Application Fields 
	for ( i=1; i LTE qGetQuestionsSection1.recordCount; i=i+1 ) {
		APPLICATION.CFC.ONLINEAPP.insertAnswer(	
			applicationQuestionID=qGetQuestionsSection1.ID[i],
			foreignTable=APPLICATION.foreignTable,
			foreignID=FORM.candidateID,
			fieldKey=qGetQuestionsSection1.fieldKey[i],
			answer=FORM[qGetQuestionsSection1.fieldKey[i]]						
		);	
	}

	// Get Questions for section 3
	qGetQuestionsSection3 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section3');
	
	// Param Online Application Form Variables 
	for ( i=1; i LTE qGetQuestionsSection3.recordCount; i=i+1 ) {
		param name="FORM[qGetQuestionsSection3.fieldKey[i]]" default="";
	}

	// Insert/Update Application Fields 
	for ( i=1; i LTE qGetQuestionsSection3.recordCount; i=i+1 ) {
		APPLICATION.CFC.ONLINEAPP.insertAnswer(	
			applicationQuestionID=qGetQuestionsSection3.ID[i],
			foreignTable=APPLICATION.foreignTable,
			foreignID=FORM.candidateID,
			fieldKey=qGetQuestionsSection3.fieldKey[i],
			answer=FORM[qGetQuestionsSection3.fieldKey[i]]						
		);	
	}
</cfscript>

    
<!---- PROGRAM HISTORY ---->
<cfif qGetCandidateInfo.programID NEQ FORM.programID>
	
    <cfquery datasource="#APPLICATION.DSN.Source#">
		INSERT INTO 
        	extra_program_history
		(
        	candidateID, 
            reason, 
            date, 
            programID, 
            userid 
		)
		VALUES 
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason#">, 
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        )
	</cfquery>
    
</cfif>


<!---- HOST COMPANY INFORMATION ---->
<cfif VAL(FORM.hostcompanyID)>
	
	<!--- Update EIN on Host Company Table --->
    <cfif LEN(FORM.EIN)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                extra_hostCompany
            SET 
                EIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.EIN#">
            WHERE
                hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
        </cfquery> 

	</cfif>
    
	<!--- Update authenticationType on Host Company Table --->
    <cfif LEN(FORM.authenticationType)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                extra_hostCompany
            SET 
                authenticationType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.authenticationType#">
            WHERE
                hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
        </cfquery> 

	</cfif>
    
	<!--- Update workmensCompensation on Host Company Table --->
    <cfif LEN(FORM.workmensCompensation)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                extra_hostCompany
            SET 
                workmensCompensation = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.workmensCompensation#" null="#NOT IsNumeric(FORM.workmensCompensation)#">
            WHERE
                hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
        </cfquery> 

	</cfif>
    
    <!--- Update WCExpirationDate on Host Company Table --->
    <cfif LEN(FORM.WCDateExpired)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                extra_hostCompany
            SET 
                WCDateExpired = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.WCDateExpired#" null="#NOT IsDate(FORM.WCDateExpired)#">
            WHERE
                hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
        </cfquery> 

	</cfif>
    	
	<!--- New Host Company --->
    <cfif qGetCandidateInfo.hostCompanyID NEQ FORM.hostcompanyID>
        
        <!--- Set old records to inactive --->
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE
                extra_candidate_place_company
            SET
                status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            WHERE
                candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
        </cfquery>
        
        <cfscript>
			// Add user and time stamp to reason_host
			FORM.reason_host = FORM.reason_host & '<br /> Added by ' & CLIENT.firstName & ' ' & CLIENT.lastName & ' on ' & DateFormat(now(), 'mm/dd/yyyy') & ' at ' & TimeFormat(now(), 'hh:mm tt');		
		</cfscript>
        
		<!--- New Host Company Information --->
        <cfquery datasource="#APPLICATION.DSN.Source#">
            INSERT INTO 
                extra_candidate_place_company
            (
                candidateID, 
                hostCompanyID, 
                jobID,
                placement_date, 
                startdate, 
                enddate, 
                status, 
                reason_host,
                selfConfirmationName,
                selfConfirmationMethod,
                selfJobOfferStatus,
                selfConfirmationDate,
                selfEmailConfirmationDate,
                selfPhoneConfirmationDate,
                selfFindJobOffer,
                selfConfirmationNotes,
                isTransfer,
                dateTransferConfirmed,
                isTransferJobOfferReceived,
                isTransferHousingAddressReceived,                
                isTransferSevisUpdated
            )
            VALUES 
            (	
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.jobID#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.program_startdate#" null="#NOT IsDate(FORM.program_startdate)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.program_enddate#" null="#NOT IsDate(FORM.program_enddate)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason_host#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfConfirmationName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfConfirmationMethod#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfJobOfferStatus#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfConfirmationDate#" null="#NOT IsDate(FORM.selfConfirmationDate)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfEmailConfirmationDate#" null="#NOT IsDate(FORM.selfEmailConfirmationDate)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfPhoneConfirmationDate#" null="#NOT IsDate(FORM.selfPhoneConfirmationDate)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfFindJobOffer#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfConfirmationNotes#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransfer)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateTransferConfirmed#" null="#NOT IsDate(FORM.dateTransferConfirmed)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransferJobOfferReceived)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransferHousingAddressReceived)#">,                
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransferSevisUpdated)#">
            )
        </cfquery>
        
    <cfelse>
        
        <!--- Update Current Host Company Information --->
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                extra_candidate_place_company
            SET 
                jobID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.jobID#">,
                startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.program_startdate#" null="#NOT IsDate(FORM.program_startdate)#">,
                enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.program_enddate#" null="#NOT IsDate(FORM.program_enddate)#">,
                status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                selfConfirmationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfConfirmationName#">,
                selfConfirmationMethod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfConfirmationMethod#">,
                selfJobOfferStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfJobOfferStatus#">,
                selfConfirmationDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfConfirmationDate#" null="#NOT IsDate(FORM.selfConfirmationDate)#">,
                selfEmailConfirmationDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfEmailConfirmationDate#" null="#NOT IsDate(FORM.selfEmailConfirmationDate)#">,
                selfPhoneConfirmationDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfPhoneConfirmationDate#" null="#NOT IsDate(FORM.selfPhoneConfirmationDate)#">,
                selfFindJobOffer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfFindJobOffer#">,     
                selfConfirmationNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.selfConfirmationNotes#">,                
				isTransfer = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransfer)#">, 
                dateTransferConfirmed = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateTransferConfirmed#" null="#NOT IsDate(FORM.dateTransferConfirmed)#">,
                isTransferJobOfferReceived = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransferJobOfferReceived)#">,
                isTransferHousingAddressReceived = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransferHousingAddressReceived)#">,                
                isTransferSevisUpdated = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isTransferSevisUpdated)#">
            WHERE 
                candcompid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCurrentPlacement.candcompid)#">
        </cfquery>
	
    </cfif>
    
    <!--- Update other records assigned to same host company and program --->
    <cfif IsDate(FORM.selfPhoneConfirmationDate)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
                extra_candidate_place_company ecpc
            INNER JOIN
            	extra_candidates ec ON ec.candidateID = ecpc.candidateID
                    AND
                        ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">   
                    AND	
                   		ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">             
            SET 
                ecpc.selfPhoneConfirmationDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.selfPhoneConfirmationDate#">
            WHERE 
            	ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
           	AND     
                ecpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND
            	ecpc.selfPhoneConfirmationDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        </cfquery>
    
    <!--- Check if there is a date in other records, if there is update this record --->
    <cfelse>

        <cfquery name="qGetPlaceCompanyInfo" datasource="#APPLICATION.DSN.Source#">
            SELECT
            	ecpc.selfPhoneConfirmationDate
            FROM
            	extra_candidate_place_company ecpc
            INNER JOIN
            	extra_candidates ec ON ec.candidateID = ecpc.candidateID
                    AND
                        ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">   
                    AND	
                   		ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">             
            WHERE 
            	ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
           	AND     
                ecpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            AND
            	ecpc.selfPhoneConfirmationDate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
			LIMIT 1                
        </cfquery>
        
        <cfif isDate(qGetPlaceCompanyInfo.selfPhoneConfirmationDate)>

            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                    extra_candidate_place_company ecpc
                INNER JOIN
                    extra_candidates ec ON ec.candidateID = ecpc.candidateID
                        AND
                            ec.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">   
                        AND	
                            ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">             
                SET 
                    ecpc.selfPhoneConfirmationDate = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetPlaceCompanyInfo.selfPhoneConfirmationDate#">
                WHERE 
                    ecpc.hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">
                AND     
                    ecpc.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND
                    ecpc.selfPhoneConfirmationDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            </cfquery>

    	</cfif>
    
    </cfif>
    
<!--- Not a valid Host Company Assigned --->
<cfelseif VAL(qGetCurrentPlacement.candcompid)>
	
	<!--- Set as Unplaced / Set old records to inactive --->
    <cfquery datasource="#APPLICATION.DSN.Source#">
        UPDATE
            extra_candidate_place_company
        SET
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE
            candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
    </cfquery>
			
</cfif>
<!--- END OF HOST COMPANY HISTORY --->

<cfquery datasource="#APPLICATION.DSN.Source#">
    UPDATE 
    	extra_candidates
    SET 
        hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">,
        firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">, 
        lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">, 
        middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">,
        dob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">,
        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">, 
        intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">,
        birth_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.birth_city#">, 
        birth_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.birth_country#">, 
        citizen_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.citizen_country#">, 
        residence_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.residence_country#">, 
        home_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_address#">, 
        home_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_city#">, 
        home_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_zip#">,	
        home_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.home_country#">,
        home_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_phone#">,
        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">, 
        englishAssessment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.englishAssessment#">,
        englishAssessmentDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.englishAssessmentDate#" null="#NOT IsDate(FORM.englishAssessmentDate)#">, 
        englishAssessmentComment = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.englishAssessmentComment#">, 
        emergency_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_name#">,
        emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">, 
        passport_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.passport_number#">,
        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">,         
        <cfif VAL(vUpdateSSN)>
            ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SSN#">, 
        </cfif>        
        wat_participation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.wat_participation)#">,
        wat_participation_info = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_participation_info#">,
        wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_placement#">,
        wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.wat_vacation_start#" null="#NOT IsDate(FORM.wat_vacation_start)#">,
        wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.wat_vacation_end#" null="#NOT IsDate(FORM.wat_vacation_end)#">,
		
		<!--- document control --->
        wat_doc_agreement = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_agreement#">,
        wat_doc_walk_in_agreement = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_walk_in_agreement#">,
        wat_doc_cv = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_cv#">,
        wat_doc_passport_copy = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_passport_copy#">,
        wat_doc_orientation = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_orientation#">,
        wat_doc_signed_assessment = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_signed_assessment#">,
        wat_doc_college_letter = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_college_letter#">,
        wat_doc_college_letter_translation = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_college_letter_translation#">,
        wat_doc_job_offer_applicant = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_job_offer_applicant#">,
        wat_doc_job_offer_employer = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_job_offer_employer#">,
		wat_doc_other = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_doc_other#">,
        wat_doc_other_received = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_doc_other_received#">,
		
		<!---- form DS-2019 ---->
        verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#" null="#NOT IsDate(FORM.verification_received)#">,
        
		<!--- DS2019 stuff ---> 
        ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019#">, 

        requested_placement = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.requested_placement#">,
        
		<!--- change_requested_comment --->
        change_requested_comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.change_requested_comment#">,
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.status#">, 
        
		<cfif isDate(FORM.cancel_date) AND FORM.status EQ 'canceled'>
        	cancel_date = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.cancel_date#">,
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            cancel_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancel_reason#">,
        <cfelse>
        	cancel_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
            cancel_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
        </cfif>
        startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.program_startdate#" null="#NOT IsDate(FORM.program_startdate)#">,
        enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.program_enddate#" null="#NOT IsDate(FORM.program_enddate)#">,
        <!---  Arrival Verification  --->
        verification_address = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.verification_address#">,
        verification_sevis = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.verification_sevis#">,
        watDateCheckedIn = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateCheckedIn#" null="#NOT IsDate(FORM.watDateCheckedIn)#">,
        us_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.usPhone#">,
        <!---  Evaluation  --->
        watDateEvaluation1 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation1#" null="#NOT IsDate(FORM.watDateEvaluation1)#">,
        watDateEvaluation2 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation2#" null="#NOT IsDate(FORM.watDateEvaluation2)#">,
        watDateEvaluation3 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation3#" null="#NOT IsDate(FORM.watDateEvaluation3)#">,
        watDateEvaluation4 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation4#" null="#NOT IsDate(FORM.watDateEvaluation4)#">
    WHERE 
    	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
</cfquery>

<cflocation url="index.cfm?curdoc=candidate/candidate_info&uniqueid=#URL.uniqueID#" addtoken="no">
