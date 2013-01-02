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
<cfparam name="FORM.arrival_address" default="">
<cfparam name="FORM.arrival_city" default="">
<cfparam name="FORM.arrival_state" default="0">
<cfparam name="FORM.arrival_zip" default="">
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
<cfparam name="FORM.cancelStatus" default="">
<!--- Program Information --->
<cfparam name="FORM.wat_participation" default="">
<cfparam name="FORM.wat_participation_info" default="">
<!--- Host Company --->
<cfparam name="FORM.authentication_secretaryOfState" default="0">
<cfparam name="FORM.authentication_departmentOfLabor" default="0">
<cfparam name="FORM.authentication_googleEarth" default="0">
<cfparam name="FORM.authentication_incorporation" default="0">
<cfparam name="FORM.authentication_certificateOfExistence" default="0">
<cfparam name="FORM.authentication_certificateOfReinstatement" default="0">
<cfparam name="FORM.authentication_departmentOfState" default="0">
<cfparam name="FORM.authentication_businessLicenseNotAvailable" default="0">
<cfparam name="FORM.EIN" default="">
<cfparam name="FORM.workmensCompensation" default="">
<cfparam name="FORM.WC_carrierName" default="">
<cfparam name="FORM.WC_carrierPhone" default="">
<cfparam name="FORM.WC_policyNumber" default="">
<cfparam name="FORM.WCDateExpried" default="">
<cfparam name="FORM.hostCompanyID" default="0">
<cfparam name="FORM.candCompID" default="0">
<cfparam name="FORM.confirmation" default="0">
<cfparam name="FORM.numberPositionsSelect" default="0">
<!--- End of Host Company --->
<cfparam name="FORM.selfConfirmationDate" default="">
<cfparam name="FORM.selfFindJobOffer" default="">
<cfparam name="FORM.selfConfirmationNotes" default="">
<cfparam name="FORM.isSecondary" default="0">
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
<!--- Secondary Placement Information --->
<cfscript>
	qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
	qGetAllPlacements = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidate.candidateID, displayAll="1");
</cfscript>
<cfloop query="qGetAllPlacements">
	<cfif qGetAllPlacements.isSecondary EQ "1">
        <cfparam name="FORM.selfJobOfferStatus_#qGetAllPlacements.candCompID#" default="Pending">
        <cfparam name="FORM.selfConfirmationName_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.selfConfirmationMethod_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.selfPhoneConfirmationDate_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.cancelStatus_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.authentication_secretaryOfState_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_departmentOfLabor_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_googleEarth_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_incorporation_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_certificateOfExistence_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_certificateOfReinstatement_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_departmentOfState_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.authentication_businessLicenseNotAvailable_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.EIN_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.workmensCompensation_#qGetAllPlacements.candCompID#" default="0">
        <cfparam name="FORM.WC_carrierName_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.WC_carrierPhone_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.WC_policyNumber_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.WCDateExpried_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.selfFindJobOffer_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.newJobOffer_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.newHousingAddress_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.sevisUpdated_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.jobID_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.confirmation_#qGetAllPlacements.candCompID#" default="">
        <cfparam name="FORM.numberPositionsSelect_#qGetAllPlacements.candCompID#" default="">
    </cfif>
</cfloop>

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

<cfquery name="qGetActivePrograms" datasource="MySql">
    SELECT p.programID, p.startDate, p.programName
    FROM smg_programs p
    INNER JOIN smg_companies c ON c.companyID = p.companyID
    WHERE dateDiff(p.endDate,NOW()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND p.is_deleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
    AND p.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
</cfquery>
	
<cfscript>
	qGetCurrentPlacement = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidateInfo.candidateID);

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

<!--- UPDATE ALL SECONDARY PLACEMENTS --->
<cfloop query="qGetAllPlacements">
	<cfif qGetAllPlacements.isSecondary EQ "1">
    
    	<!--- REMOVE SECONDARY PLACEMENT --->
    	<cfif FORM['cancelStatus_#qGetAllPlacements.candCompID#'] EQ "1">
        
    		<cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE
                	extra_candidate_place_company
               	SET
                	status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
              	WHERE
                	candcompid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAllPlacements.candCompID#">
            </cfquery>
            
        <!--- UPDATE SECONDARY PLACEMENT --->
        <cfelse>
        	
            <cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE 
                    extra_hostCompany
                SET
                    EIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['EIN_#qGetAllPlacements.candCompID#']#">,
                    authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_secretaryOfState_#qGetAllPlacements.candCompID#']#">,
                    authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_departmentOfLabor_#qGetAllPlacements.candCompID#']#">,
                    authentication_googleEarth = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_googleEarth_#qGetAllPlacements.candCompID#']#">,
                    authentication_incorporation = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_incorporation_#qGetAllPlacements.candCompID#']#">,
                    authentication_certificateOfExistence = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_certificateOfExistence_#qGetAllPlacements.candCompID#']#">,
                    authentication_certificateOfReinstatement = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_certificateOfReinstatement_#qGetAllPlacements.candCompID#']#">,
                    authentication_departmentOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_departmentOfState_#qGetAllPlacements.candCompID#']#">,
                    authentication_businessLicenseNotAvailable = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['authentication_businessLicenseNotAvailable_#qGetAllPlacements.candCompID#']#">,
                    workmensCompensation = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM['workmensCompensation_#qGetAllPlacements.candCompID#']#" null="#NOT IsNumeric(FORM['workmensCompensation_#qGetAllPlacements.candCompID#'])#">,
                    WC_carrierName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['WC_carrierName_#qGetAllPlacements.candCompID#']#">,
                    WC_carrierPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['WC_carrierPhone_#qGetAllPlacements.candCompID#']#">,
                    WC_policyNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['WC_policyNumber_#qGetAllPlacements.candCompID#']#">,
                    WCDateExpired = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['WCDateExpired_#qGetAllPlacements.candCompID#']#" null="#NOT IsDate(FORM['WCDateExpired_#qGetAllPlacements.candCompID#'])#">
                WHERE
                    hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAllPlacements.hostCompanyID#">
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE 
                    extra_candidate_place_company
                SET 
                	jobID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM['jobID_#qGetAllPlacements.candCompID#']#">, 
                    selfConfirmationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['selfConfirmationName_#qGetAllPlacements.candCompID#']#">,
                    selfJobOfferStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['selfJobOfferStatus_#qGetAllPlacements.candCompID#']#">,
                    selfPhoneConfirmationDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM['selfPhoneConfirmationDate_#qGetAllPlacements.candCompID#']#">,
                    selfConfirmationNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['selfConfirmationNotes_#qGetAllPlacements.candCompID#']#">,
                    selfFindJobOffer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['selfFindJobOffer_#qGetAllPlacements.candCompID#']#">,
                    isTransferJobOfferReceived = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM['newJobOffer_#qGetAllPlacements.candCompID#'])#">,
                	isTransferHousingAddressReceived = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM['newHousingAddress_#qGetAllPlacements.candCompID#'])#">,                
                	isTransferSevisUpdated = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM['sevisUpdated_#qGetAllPlacements.candCompID#'])#">
                WHERE
                    candcompid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAllPlacements.candCompID#">
            </cfquery>
            
            <!--- Update secondary confirmations --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE extra_confirmations
                SET confirmed = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM['confirmation_#qGetAllPlacements.candCompID#']#">
                WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetAllPlacements.hostCompanyID)#">
                AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetAllPlacements.programID)#">
            </cfquery>
            
            <!--- Updated secondary J1 positions --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE extra_j1_positions
                SET numberPositions = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM['numberPositionsSelect_#qGetAllPlacements.candCompID#']#">
                WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetAllPlacements.hostCompanyID)#">
                AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetAllPlacements.programID)#">
            </cfquery>
            
             <cfquery name="qGetHost" datasource="#APPLICATION.DSN.Source#">
                SELECT *
                FROM extra_hostcompany
                WHERE hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetAllPlacements.hostCompanyID)#">
            </cfquery>
            
            <!--- Add History Record --->
            <cfoutput query="qGetHost">
                <cfquery datasource="MySql">
                    INSERT INTO extra_hostinfohistory (
                        hostID,
                        changedBy,
                        dateChanged,
                        personJobOfferName,
                        personJobOfferTitle,
                        EIN,
                        workmensCompensation,
                        WC_carrierName,
                        WC_carrierPhone,
                        WC_policyNumber,
                        WCDateExpired,
                        homepage,
                        observations,
                        authentication_secretaryOfState,
                        authentication_departmentOfLabor,
                        authentication_googleEarth,
                        authentication_incorporation,
                        authentication_certificateOfExistence,
                        authentication_certificateOfReinstatement,
                        authentication_departmentOfState,
                        authentication_secretaryOfStateExpiration,
                        authentication_departmentOfLaborExpiration,
                        authentication_googleEarthExpiration,
                        authentication_incorporationExpiration,
                        authentication_certificateOfExistenceExpiration,
                        authentication_certificateOfReinstatementExpiration,
                        authentication_departmentOfStateExpiration,
                        authentication_businessLicenseNotAvailable )
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#personJobOfferName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#personJobOfferTitle#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#EIN#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#workmensCompensation#" null="#NOT IsNumeric(workmensCompensation)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#WC_carrierName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#WC_carrierPhone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#WC_policyNumber#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#WCDateExpired#" null="#NOT IsDate(WCDateExpired)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#homepage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#observations#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_secretaryOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_departmentOfLabor)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_googleEarth)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_incorporation)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_certificateOfExistence)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_certificateOfReinstatement)#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_departmentOfState)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_secretaryOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_departmentOfLaborExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_googleEarthExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_incorporationExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_certificateOfExistenceExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_certificateOfReinstatementExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_departmentOfStateExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#authentication_businessLicenseNotAvailable#"> )
                </cfquery>
           	</cfoutput>
            <!--- End Add History Record --->
            
            <!--- Insert Season History --->
            <cfquery name="qGetNewHistoryID" datasource="#APPLICATION.DSN.Source#">
                SELECT historyID
                FROM extra_hostinfohistory
                WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHost.hostCompanyID#">
                ORDER BY historyID DESC
                LIMIT 1
            </cfquery>
            <cfloop query="qGetActivePrograms">
                <cfquery name="qGetNewConfirmations" datasource="#APPLICATION.DSN.Source#">
                    SELECT confirmed, confirmedDate
                    FROM extra_confirmations
                    WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHost.hostCompanyID#">
                    AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
                </cfquery>
                <cfquery name="qGetNewPositions" datasource="#APPLICATION.DSN.Source#">
                    SELECT numberPositions, verifiedDate
                    FROM extra_j1_positions
                    WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHost.hostCompanyID#">
                    AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
                </cfquery>
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO extra_hostseasonhistory (
                        hostHistoryID,
                        programID,
                        j1Date,
                        confirmedDate,
                        j1Positions,
                        confirmed )
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewHistoryID.historyID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetNewPositions.verifiedDate#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetNewConfirmations.confirmedDate#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetNewPositions.numberPositions#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetNewConfirmations.confirmed#"> )
                </cfquery>
          	</cfloop>
            <!--- End Insert Season History --->
            
        </cfif>
        
    </cfif>
    
</cfloop>
<!--- END OF UPDATE ALL SECONDARY PLACEMENTS --->

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
    
    <!--- Update authentications on Host Company Table --->
    <cfquery datasource="#APPLICATION.DSN.Source#">
    	UPDATE 
        	extra_hostcompany
        SET
        	authentication_secretaryOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_secretaryOfState)#">,
            authentication_departmentOfLabor = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfLabor)#">,
            authentication_googleEarth = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_googleEarth)#">,
            authentication_incorporation = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_incorporation)#">,
            authentication_certificateOfExistence = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfExistence)#">,
            authentication_certificateOfReinstatement = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_certificateOfReinstatement)#">,
            authentication_departmentOfState = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_departmentOfState)#">,
            authentication_businessLicenseNotAvailable = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.authentication_businessLicenseNotAvailable)#">,
            WC_carrierName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierName#">,
            WC_carrierPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_carrierPhone#">,
            WC_policyNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.WC_policyNumber#">
      	WHERE
       		hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">	
    </cfquery>
    
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
        
  	<cfscript>
		hostCompanies = valueList(qGetAllPlacements.hostCompanyID);
	</cfscript>
     
   	<!--- New Host Company --->   
   	<cfif NOT ListFind(hostCompanies, FORM.hostCompanyID)>    
        
        <!--- Set previous company to inactive if this is not a secondary placement --->
        <cfif NOT VAL(isSecondary)>
        
			<!--- Set old records to inactive --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE
                    extra_candidate_place_company
                SET
                    status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
              	AND
                	isSecondary = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            </cfquery>
            
      	</cfif>
            
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
                isSecondary,
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
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isSecondary)#">,
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
                candcompid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCurrentPlacement.candCompID#">
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
    
	<!--- Update confirmations --->
    <cfquery datasource="#APPLICATION.DSN.Source#">
        UPDATE extra_confirmations
        SET confirmed = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.confirmation#">
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostCompanyID)#">
        AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCurrentPlacement.programID)#">
    </cfquery>
    
    <!--- Update J1 positions --->
    <cfquery datasource="#APPLICATION.DSN.Source#">
        UPDATE extra_j1_positions
        SET numberPositions = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.numberPositionsSelect#">
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostCompanyID)#">
        AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCurrentPlacement.programID)#">
    </cfquery>
    
    <cfquery name="qGetHost" datasource="#APPLICATION.DSN.Source#">
    	SELECT *
        FROM extra_hostcompany
        WHERE hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostCompanyID)#">
    </cfquery>
    
    <!--- Add History Record --->
    <cfoutput query="qGetHost">
        <cfquery datasource="MySql">
            INSERT INTO extra_hostinfohistory (
                hostID,
                changedBy,
                dateChanged,
                personJobOfferName,
                personJobOfferTitle,
                EIN,
                workmensCompensation,
                WC_carrierName,
                WC_carrierPhone,
                WC_policyNumber,
                WCDateExpired,
                homepage,
                observations,
                authentication_secretaryOfState,
                authentication_departmentOfLabor,
                authentication_googleEarth,
                authentication_incorporation,
                authentication_certificateOfExistence,
                authentication_certificateOfReinstatement,
                authentication_departmentOfState,
                authentication_secretaryOfStateExpiration,
                authentication_departmentOfLaborExpiration,
                authentication_googleEarthExpiration,
                authentication_incorporationExpiration,
                authentication_certificateOfExistenceExpiration,
                authentication_certificateOfReinstatementExpiration,
                authentication_departmentOfStateExpiration,
                authentication_businessLicenseNotAvailable )
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#hostCompanyID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#personJobOfferName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#personJobOfferTitle#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#EIN#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#workmensCompensation#" null="#NOT IsNumeric(workmensCompensation)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#WC_carrierName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#WC_carrierPhone#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#WC_policyNumber#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#WCDateExpired#" null="#NOT IsDate(WCDateExpired)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#homepage#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#observations#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_secretaryOfState)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_departmentOfLabor)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_googleEarth)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_incorporation)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_certificateOfExistence)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_certificateOfReinstatement)#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(authentication_departmentOfState)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_secretaryOfStateExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_departmentOfLaborExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_googleEarthExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_incorporationExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_certificateOfExistenceExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_certificateOfReinstatementExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#authentication_departmentOfStateExpiration#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#authentication_businessLicenseNotAvailable#"> )
        </cfquery>
   	</cfoutput>
    <!--- End Add History Record --->
    
    <!--- Insert Season History --->
    <cfquery name="qGetNewHistoryID" datasource="#APPLICATION.DSN.Source#">
        SELECT historyID
        FROM extra_hostinfohistory
        WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHost.hostCompanyID#">
        ORDER BY historyID DESC
        LIMIT 1
    </cfquery>
    <cfloop query="qGetActivePrograms">
        <cfquery name="qGetNewConfirmations" datasource="#APPLICATION.DSN.Source#">
            SELECT confirmed, confirmedDate
            FROM extra_confirmations
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHost.hostCompanyID#">
            AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
        </cfquery>
        <cfquery name="qGetNewPositions" datasource="#APPLICATION.DSN.Source#">
            SELECT numberPositions, verifiedDate
            FROM extra_j1_positions
            WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHost.hostCompanyID#">
            AND programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">
        </cfquery>
        <cfquery datasource="#APPLICATION.DSN.Source#">
            INSERT INTO extra_hostseasonhistory (
                hostHistoryID,
                programID,
                j1Date,
                confirmedDate,
                j1Positions,
                confirmed )
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewHistoryID.historyID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#programID#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetNewPositions.verifiedDate#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#qGetNewConfirmations.confirmedDate#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewPositions.numberPositions)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetNewConfirmations.confirmed)#"> )
        </cfquery>
   	</cfloop>
    <!--- End Insert Season History --->
    
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
    	<cfif NOT VAL(FORM.isSecondary)>
        	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyID#">,
       	</cfif>
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
        emergency_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_email#">,
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
        arrival_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_address#">,
        arrival_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_city#">,
        arrival_state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.arrival_state#">,
        arrival_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_zip#">,
        <!---  Evaluation  --->
        watDateEvaluation1 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation1#" null="#NOT IsDate(FORM.watDateEvaluation1)#">,
        watDateEvaluation2 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation2#" null="#NOT IsDate(FORM.watDateEvaluation2)#">,
        watDateEvaluation3 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation3#" null="#NOT IsDate(FORM.watDateEvaluation3)#">,
        watDateEvaluation4 = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateEvaluation4#" null="#NOT IsDate(FORM.watDateEvaluation4)#">
    WHERE 
    	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
</cfquery>

<cfquery name="qGetCandidateInfo" datasource="#APPLICATION.DSN.Source#">
	SELECT *
    FROM extra_candidates
    WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
</cfquery>

<!--- History Record --->
<cfquery datasource="#APPLICATION.DSN.Source#">
    INSERT INTO extra_candidates_history (
        candidateID,
        changedBy,
        dateChanged,
        hostCompanyID,
        firstname, 
        lastname, 
        middlename,
        dob,
        sex, 
        intrep,
        birth_city, 
        birth_country,
        citizen_country,
        residence_country,
        home_address,
        home_city,
        home_zip,
        home_country,
        home_phone,
        email,
        englishAssessment,
        englishAssessmentDate,
        englishAssessmentComment,
        emergency_name,
        emergency_phone,
        emergency_email,
        passport_number,
        programID,        
       	ssn,      
        wat_participation,
        wat_participation_info,
        wat_placement,
        wat_vacation_start,
        wat_vacation_end,
        wat_doc_agreement,
        wat_doc_walk_in_agreement,
        wat_doc_cv,
        wat_doc_passport_copy,
        wat_doc_orientation,
        wat_doc_signed_assessment,
        wat_doc_college_letter,
        wat_doc_college_letter_translation,
        wat_doc_job_offer_applicant,
        wat_doc_job_offer_employer,
        wat_doc_other,
        wat_doc_other_received,
        verification_received,
        ds2019,
        requested_placement,
        change_requested_comment,
        status,
        cancel_date,
        cancel_reason,
        startdate,
        enddate,
        verification_address,
        verification_sevis,
        watDateCheckedIn,
        us_phone,
        arrival_address,
        arrival_city,
        arrival_state,
        arrival_zip,
        watDateEvaluation1,
        watDateEvaluation2,
        watDateEvaluation3,
        watDateEvaluation4 )
  	VALUES (
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.hostcompanyID#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.firstname#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.lastname#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.middlename#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.dob#" null="#NOT IsDate(qGetCandidateInfo.dob)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.sex#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.intrep#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.birth_city#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.birth_country#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.citizen_country#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.residence_country#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_address#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_city#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_zip#">,	
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.home_country#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_phone#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.email#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.englishAssessment#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.englishAssessmentDate#" null="#NOT IsDate(qGetCandidateInfo.englishAssessmentDate)#">, 
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#qGetCandidateInfo.englishAssessmentComment#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_phone#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_email#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.passport_number#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.programID#">,         
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.SSN#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.wat_participation)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_participation_info#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_placement#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.wat_vacation_start#" null="#NOT IsDate(qGetCandidateInfo.wat_vacation_start)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.wat_vacation_end#" null="#NOT IsDate(qGetCandidateInfo.wat_vacation_end)#">,
		<cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_agreement#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_walk_in_agreement#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_cv#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_passport_copy#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_orientation#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_signed_assessment#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_college_letter#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_college_letter_translation#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_job_offer_applicant#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.wat_doc_job_offer_employer#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_doc_other#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.wat_doc_other_received#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.verification_received#" null="#NOT IsDate(qGetCandidateInfo.verification_received)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.ds2019#">, 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.requested_placement#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.change_requested_comment#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.status#">, 
		<cfif isDate(qGetCandidateInfo.cancel_date) AND qGetCandidateInfo.status EQ 'canceled'>
        	<cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.cancel_date#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.cancel_reason#">,
        <cfelse>
        	<cfqueryparam cfsqltype="cf_sql_date" null="yes">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
        </cfif>
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.startdate#" null="#NOT IsDate(qGetCandidateInfo.startdate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.enddate#" null="#NOT IsDate(qGetCandidateInfo.enddate)#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.verification_address#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#qGetCandidateInfo.verification_sevis#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateCheckedIn#" null="#NOT IsDate(qGetCandidateInfo.watDateCheckedIn)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.us_phone#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_address#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_city#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.arrival_state#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_zip#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation1#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation1)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation2#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation2)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation3#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation3)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation4#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation4)#"> )
</cfquery>

<cflocation url="index.cfm?curdoc=candidate/candidate_info&uniqueid=#URL.uniqueID#" addtoken="no">
