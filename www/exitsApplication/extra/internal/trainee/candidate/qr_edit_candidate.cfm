<!--- ------------------------------------------------------------------------- ----
	
	File:		qr_edit_candidate.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Updates candidate.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Param FORM variables --->
<cfparam name="FORM.reason" default="">
<cfparam name="FORM.reason_host" default="">
<cfparam name="FORM.doc_midterm_evaluation" default="">
<cfparam name="FORM.doc_summative_evaluation" default="">
<cfparam name="FORM.doc_application" default="0">
<cfparam name="FORM.doc_resume" default="0">
<cfparam name="FORM.doc_proficiency" default="0">
<cfparam name="FORM.doc_passportphoto" default="0">
<cfparam name="FORM.doc_recom_letter" default="0">
<cfparam name="FORM.doc_insu" default="0">
<cfparam name="FORM.doc_sponsor_letter" default="0">
<cfparam name="FORM.doc_agreement" default="0">
<cfparam name="FORM.doc_ISEInterviewReport" default="0">
<cfparam name="FORM.doc_hostEmployerInformation" default="0">
<cfparam name="FORM.doc_degreeCopy" default="0">
<cfparam name="FORM.doc_DS7002_applicant" default="0">
<cfparam name="FORM.doc_DS7002_hostCompany" default="0">
<cfparam name="FORM.ds2019_dateActivated" default="">
<!--- Arrival Verification --->
<cfparam name="FORM.watDateCheckedIn" default="">
<cfparam name="FORM.usPhone" default="">
<cfparam name="FORM.arrival_address" default="">
<cfparam name="FORM.arrival_city" default="">
<cfparam name="FORM.arrival_state" default="0">
<cfparam name="FORM.arrival_zip" default="">

<cfquery name="qGetCandidateInfo" datasource="#APPLICATION.DSN.Source#">
    SELECT 
        candidateID, 
        programID, 
        hostCompanyID
    FROM 
        extra_candidates
    WHERE 
        candidateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.candidateID#">
</cfquery>

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

<!--- HOST COMPANY HISTORY --->
<cfif qGetCandidateInfo.hostCompanyID NEQ FORM.hostCompanyID>
	
    <cfif NOT VAL(qGetCandidateInfo.hostCompanyID) AND NOT LEN(FORM.reason_host)>
    	<cfset FORM.reason_host = "Original Placement">
	</cfif>
        
	<!--- Set Any Previous Companies to Inactive --->
	<cfquery datasource="#APPLICATION.DSN.Source#">
		UPDATE
			extra_candidate_place_company
		SET            
            status = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		WHERE
			candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">                            	        
	</cfquery>        

	<!--- Insert New Host Company --->
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
			confirmation_received,
            reason_host
		)
		VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.jobID#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.host_startdate#" null="#NOT IsDate(FORM.host_startdate)#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.host_enddate#" null="#NOT IsDate(FORM.host_enddate)#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
			<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason_host#">
		)
	</cfquery>

<cfelse>

	<!--- Update Current Host Company --->
	<cfquery datasource="#APPLICATION.DSN.Source#">
		UPDATE 
			extra_candidate_place_company
		SET 
			jobid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.jobID)#">, 
			startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.host_startdate#" null="#NOT IsDate(FORM.host_startdate)#">,
			enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.host_enddate#" null="#NOT IsDate(FORM.host_enddate)#">
		WHERE 
			candCompID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candCompID#">
	</cfquery>

</cfif>

<cfquery name="check_sevis" datasource="#APPLICATION.DSN.Source#">
    SELECT 
        ds2019
    FROM 
        extra_candidates
    WHERE 
        uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueid#">
</cfquery>

<cfif LEN(check_sevis.ds2019)>
    <cfset sendemail = 'no'>		
<cfelse>
    <cfset sendemail = 'yes'>
</cfif>

<cfquery name="edit_candidate" datasource="#APPLICATION.DSN.Source#">
    UPDATE 
        extra_candidates
    SET 
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
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.status#">,	 
        emergency_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_name#">,	
        emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">,	
        emergency_relationship = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_relationship#">,	
        degree = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree#">,	 
        degree_other = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree_other#">,	
        fieldstudyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fieldstudyid#">,	 
     	subfieldid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.listsubcat#">,	
        <!--- Documents Control --->
        doc_midterm_evaluation = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.doc_midterm_evaluation#" null="#NOT IsDate(FORM.doc_midterm_evaluation)#">,
        doc_summative_evaluation = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.doc_summative_evaluation#" null="#NOT IsDate(FORM.doc_summative_evaluation)#">,
        doc_application = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_application#">,	 
        doc_resume = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_resume#">,
        doc_proficiency = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_proficiency#">,
        doc_passportphoto = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_passportphoto#">,	  
        doc_recom_letter = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_recom_letter#">,	
        doc_insu = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_insu#">,	  
        doc_sponsor_letter = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_sponsor_letter#">,
        doc_agreement = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_agreement#">,
        doc_ISEInterviewReport = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_ISEInterviewReport#">,
        doc_hostEmployerInformation = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_hostEmployerInformation#">,
        doc_degreeCopy = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_degreeCopy#">,
        doc_DS7002_applicant = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_DS7002_applicant#">, 
        doc_DS7002_hostCompany = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_DS7002_hostCompany#">,
        missing_documents = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.missing_documents#">,	  
        programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">,	
        hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">,		  		
		<!--- Use DS2019 Dates and Not Program Dates --->
        startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_startdate#" null="#NOT IsDate(FORM.ds2019_startdate)#">,
        enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_enddate#" null="#NOT IsDate(FORM.ds2019_enddate)#">,
		remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.remarks#">,  		
        cancel_date = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.cancel_date#" null="#NOT IsDate(FORM.cancel_date)#">,
        cancel_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancel_reason#">,
		<!--- DS 2019 --->
		verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#" null="#NOT IsDate(FORM.verification_received)#">,
        ds2019_dateActivated = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_dateActivated#" null="#NOT IsDate(FORM.ds2019_dateActivated)#">,
        ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019#">,
        ds2019_startdate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_startdate#" null="#NOT IsDate(FORM.ds2019_startdate)#">,
        ds2019_enddate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_enddate#" null="#NOT IsDate(FORM.ds2019_enddate)#">,
        <!--- Use Sub Category --->
        ds2019_subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.listsubcat#">,
        <!--- Arrival Verification --->
        watDateCheckedIn = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateCheckedIn#" null="#NOT IsDate(FORM.watDateCheckedIn)#">,
        us_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.usPhone#">,
        arrival_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_address#">,
        arrival_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_city#">,
        arrival_state = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.arrival_state#">,
        arrival_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_zip#">
    WHERE 
        uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueid#">
</cfquery>

<!--- Insert History Record --->
<cfquery datasource="#APPLICATION.DSN.Source#">
	INSERT INTO extra_candidates_history (
    	candidateID,
        changedBy,
        dateChanged,
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
        status,	 
        emergency_name,	
        emergency_phone,	
        emergency_relationship,	
        degree,	 
        degree_other,	
        fieldstudyid,	 
     	subfieldid,	
        <!--- Documents Control --->
        doc_midterm_evaluation,
        doc_summative_evaluation,
        doc_application,	 
        doc_resume,
        doc_proficiency,
        doc_passportphoto,	  
        doc_recom_letter,	
        doc_insu,	  
        doc_sponsor_letter,
        doc_agreement,
        doc_ISEInterviewReport,
        doc_hostEmployerInformation,
        doc_degreeCopy,
        doc_DS7002_applicant,
        doc_DS7002_hostCompany,
        missing_documents,	  
        programID,	
        hostCompanyID,		  		
		<!--- Use DS2019 Dates and Not Program Dates --->
        startdate,
        enddate,
		remarks,  		
        cancel_date,
        cancel_reason,
		<!--- DS 2019 --->
		verification_received,
        ds2019_dateActivated,
        ds2019,
        ds2019_startdate,
        ds2019_enddate,
        <!--- Use Sub Category --->
        ds2019_subject,
        <!--- Arrival Verification --->
        watDateCheckedIn,
        us_phone,
        arrival_address,
        arrival_city,
        arrival_state,
        arrival_zip )
  	VALUES (
    	<cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidateInfo.candidateID#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">, 
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,  
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">,  
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.birth_city#">,    
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.birth_country#">,    
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.citizen_country#">, 
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.residence_country#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_address#">,  
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_city#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_zip#">,	
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.home_country#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.home_phone#">,	 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,	 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.status#">,	 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_name#">,	
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#">,	
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_relationship#">,	
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree#">,	 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree_other#">,	
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fieldstudyid#">,	 
     	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.listsubcat#">,	
        <!--- Documents Control --->
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.doc_midterm_evaluation#" null="#NOT IsDate(FORM.doc_midterm_evaluation)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.doc_summative_evaluation#" null="#NOT IsDate(FORM.doc_summative_evaluation)#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_application#">,	 
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_resume#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_proficiency#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_passportphoto#">,	  
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_recom_letter#">,	
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_insu#">,	  
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_sponsor_letter#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_agreement#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_ISEInterviewReport#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_hostEmployerInformation#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_degreeCopy#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_DS7002_applicant#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_DS7002_hostCompany#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.missing_documents#">,	  
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">,	
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostCompanyID#">,		  		
		<!--- Use DS2019 Dates and Not Program Dates --->
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_startdate#" null="#NOT IsDate(FORM.ds2019_startdate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_enddate#" null="#NOT IsDate(FORM.ds2019_enddate)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.remarks#">,  		
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.cancel_date#" null="#NOT IsDate(FORM.cancel_date)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancel_reason#">,
		<!--- DS 2019 --->
		<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#" null="#NOT IsDate(FORM.verification_received)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_dateActivated#" null="#NOT IsDate(FORM.ds2019_dateActivated)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_startdate#" null="#NOT IsDate(FORM.ds2019_startdate)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.ds2019_enddate#" null="#NOT IsDate(FORM.ds2019_enddate)#">,
        <!--- Use Sub Category --->
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.listsubcat#">,
        <!--- Arrival Verification --->
        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDateCheckedIn#" null="#NOT IsDate(FORM.watDateCheckedIn)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.usPhone#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_address#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_city#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.arrival_state#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.arrival_zip#"> )
</cfquery>


<cfif sendemail eq 'yes' AND LEN(FORM.ds2019)>
    <cfinclude template="SevisFeeLetterEmail.cfm">
</cfif>
    
<cfoutput>
<script language="JavaScript">
    location.replace("?curdoc=candidate/candidate_info&uniqueid=#FORM.uniqueid#");
</script>
</cfoutput>