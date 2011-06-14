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
<cfparam name="FORM.ds2019_dateActivated" default="">

<cfquery name="qGetCandidateInfo" datasource="mysql">
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

    <cfquery datasource="mysql">
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
	<cfquery datasource="mysql">
		UPDATE
			extra_candidate_place_company
		SET            
            status = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
		WHERE
			candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateID#">                            	        
	</cfquery>        

	<!--- Insert New Host Company --->
	<cfquery datasource="mysql">
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
	<cfquery datasource="mysql">
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

<cfquery name="check_sevis" datasource="mysql">
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


<cfquery name="edit_candidate" datasource="mysql">
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
        doc_midterm_evaluation = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.doc_midterm_evaluation#" null="#NOT IsDate(FORM.doc_midterm_evaluation)#">,
        doc_summative_evaluation = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.doc_summative_evaluation#" null="#NOT IsDate(FORM.doc_summative_evaluation)#">,
        doc_application = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_application#">,	 
        doc_resume = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_resume#">,
        doc_proficiency = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_proficiency#">,	  
        doc_passportphoto = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_passportphoto#">,	  
        doc_recom_letter = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_recom_letter#">,	
        doc_insu = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_insu#">,	  
        doc_sponsor_letter = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.doc_sponsor_letter#">,	 
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
        ds2019_street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_street#">, 
        ds2019_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_city#">, 
        ds2019_state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_state#">, 
        ds2019_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_zip#">, 
        ds2019_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_cell#">,
        ds2019_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_phone#">
    WHERE 
        uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueid#">
</cfquery>


<cfif sendemail eq 'yes' AND LEN(FORM.ds2019)>

    <cfquery name="get_intrep_email" datasource="mysql">
        SELECT 	
            email
        FROM 
            smg_users
        WHERE 
            userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
    </cfquery>

    <cfinclude template="SevisFeeLetterEmail.cfm">

</cfif>
    
<cfoutput>
<script language="JavaScript">
    <!-- 
    // alert("Candidate Updated!");
        //location.replace("?curdoc=candidate/candidate_form2&unqid=#uniqueid#");
        location.replace("?curdoc=candidate/candidate_info&uniqueid=#FORM.uniqueid#");
    -->
</script>
</cfoutput>
