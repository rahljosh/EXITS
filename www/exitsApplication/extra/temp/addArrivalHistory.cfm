<cfsetting requesttimeout="9999">

<cfquery name="qGetCandidateInfo" datasource="#APPLICATION.DSN.Source#">
	SELECT *
    FROM extra_candidates
    WHERE status = 1
    AND candidateID NOT IN (SELECT candidateID FROM extra_candidates_history)
</cfquery>

<cfloop query="qGetCandidateInfo">
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
            <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.hostcompanyID)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.firstname#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.lastname#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.middlename#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.dob#" null="#NOT IsDate(qGetCandidateInfo.dob)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.sex#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.intrep)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.birth_city#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.birth_country)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.citizen_country)#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.residence_country)#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_address#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_city#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_zip#">,	
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.home_country)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.home_phone#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.email#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.englishAssessment#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.englishAssessmentDate#" null="#NOT IsDate(qGetCandidateInfo.englishAssessmentDate)#">, 
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#qGetCandidateInfo.englishAssessmentComment#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_phone#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.emergency_email#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.passport_number#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.programID)#">,         
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
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.requested_placement)#">,
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
            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidateInfo.arrival_state)#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidateInfo.arrival_zip#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation1#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation1)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation2#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation2)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation3#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation3)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidateInfo.watDateEvaluation4#" null="#NOT IsDate(qGetCandidateInfo.watDateEvaluation4)#"> )
	</cfquery>
</cfloop>