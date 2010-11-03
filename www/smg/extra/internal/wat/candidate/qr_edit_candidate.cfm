<!--- Param FORM Variables --->
<cfparam name="FORM.hostcompany_status" default="0">
<cfparam name="FORM.wat_doc_agreement" default="0">
<cfparam name="FORM.wat_doc_college_letter" default="0">
<cfparam name="FORM.wat_doc_passport_copy" default="0">
<cfparam name="FORM.wat_doc_job_offer" default="0">
<cfparam name="FORM.wat_doc_orientation" default="0">
<cfparam name="FORM.wat_doc_walk_in_agreement" default="0">
<cfparam name="FORM.verification_address" default="0">
<cfparam name="FORM.verification_sevis" default="0">
<cfparam name="FORM.verification_arrival" default="0">

<cfquery name="qGetCandidateInfo" datasource="mysql">
    SELECT 
    	candidateID, 
        programid, 
        hostCompanyID
    FROM 
    	extra_candidates
    WHERE 
    	uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uniqueid#">
</cfquery>
	
<cfquery name="qGetCurrentPlacement" datasource="mysql">
    SELECT 
    	MAX(candcompid) as candcompid
    FROM 
    	extra_candidate_place_company
    WHERE 
    	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
</cfquery>

	
<cfscript>
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
<cfif qGetCandidateInfo.programid NEQ FORM.programid>
	
    <cfquery datasource="mysql">
		INSERT INTO 
        	extra_program_history
		(
        	candidateID, 
            reason, 
            date, 
            programid, 
            userid 
		)
		VALUES 
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason#">, 
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        )
	</cfquery>
    
</cfif>

	
<!---- HOST COMPANY HISTORY ---->
<cfif VAL(FORM.hostCompanyID_combo)>
	
	<cfif qGetCandidateInfo.hostCompanyID NEQ FORM.hostCompanyID_combo>
		
        <!--- Set old records to inactive --->
        <cfquery datasource="mysql">
        	UPDATE
            	extra_candidate_place_company
            SET
            	status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        	WHERE
            	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
        </cfquery>
        
        <!--- New Host Company Information --->
        <cfquery datasource="mysql">
            INSERT INTO 
            	extra_candidate_place_company
            (
            	candidateID, 
                hostCompanyID, 
                placement_date, 
                startdate, 
                enddate, 
                status, 
                reason_host
            )
            VALUES 
            (	
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID_combo#">, 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                <cfif LEN(FORM.host_startdate)>
                	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.host_startdate)#">,
                <cfelse>
                	<cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                </cfif>
                <cfif LEN(FORM.host_enddate)>
                	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.host_enddate)#">,
                <cfelse>
                	<cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompany_status#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason_host#">
			)
		</cfquery>
	
    <cfelse>
		
        <!--- Update Current Host Company Information --->
		<cfquery  datasource="mysql">
            UPDATE 
            	extra_candidate_place_company
            SET 
				<cfif LEN(FORM.host_startdate)>
                    startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.host_startdate)#">,
                <cfelse>
                    startdate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                </cfif>
				<cfif LEN(FORM.host_enddate)>
                    enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.host_enddate)#">,
                <cfelse>
                    enddate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
                </cfif>
                status = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompany_status#">
            WHERE 
            	candcompid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCurrentPlacement.candcompid#">
		</cfquery>
		
	</cfif>

</cfif>

<cfquery datasource="mysql">
    UPDATE 
    	extra_candidates
    SET 
        hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID_combo#">,
        firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">, 
        lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">, 
        middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">,
		<cfif isDate(FORM.dob)>
        	dob = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.dob)#">,
        <cfelse>
        	dob = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,        
        </cfif>
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
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.status#">, 
        personal_info = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.personal_info#">, 
        emergency_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_name#">,
        emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">, 
        passport_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.passport_number#">,
        programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">, 
        ssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ssn#">, 
        wat_participation = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.wat_participation#">, 
        wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_placement#">,
		
		<cfif isDate(FORM.wat_vacation_start)>
        	wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.wat_vacation_start)#">,
        <cfelse>
        	wat_vacation_start = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
        </cfif>
		
		<cfif isDate(FORM.wat_vacation_end)>
        	wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.wat_vacation_end)#">,
        <cfelse>
        	wat_vacation_end = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
        </cfif>
        
		<!--- document control --->
        wat_doc_agreement = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_agreement#">,
        wat_doc_college_letter = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_college_letter#">,
        wat_doc_passport_copy = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_passport_copy#">,
        wat_doc_job_offer = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_job_offer#">,
        wat_doc_orientation = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_orientation#">,
        wat_doc_walk_in_agreement = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.wat_doc_walk_in_agreement#">,
        
		<!---- form DS-2019 ---->
        <cfif isDate(FORM.verification_received)>
            verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.verification_received)#">,
        <cfelse>
            verification_received = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
        </cfif>
        
        <!--- DS2019 stuff ---> 
        ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019#">, 
        requested_placement = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.requested_placement#">,
        
        <!--- change_requested_comment --->
        change_requested_comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.change_requested_comment#">,
        
        <cfif LEN(FORM.cancel_date)>
        	cancel_date = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.cancel_date)#">, 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
        <cfelse>
        	cancel_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
        </cfif>
        cancel_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancel_reason#">,
        
		<cfif LEN(FORM.program_startdate)>
        	startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.program_startdate)#">,
        <cfelse>
        	startdate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
        </cfif>
       
		<cfif LEN(FORM.program_enddate)>
        	enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.program_enddate)#">,
        <cfelse>
       		enddate = <cfqueryparam cfsqltype="cf_sql_date" null="yes">,
        </cfif>
        
        <!---  Arrival Verification  --->
        verification_address = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.verification_address#">,
        verification_sevis = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.verification_sevis#">,
        verification_arrival = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.verification_arrival#">
            
    WHERE 
    	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">
</cfquery>

<cflocation url="index.cfm?curdoc=candidate/candidate_info&uniqueid=#url.uniqueid#" addtoken="no">
