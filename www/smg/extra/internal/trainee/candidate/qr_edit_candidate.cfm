<!--- ------------------------------------------------------------------------- ----
	
	File:		qr_edit_candidate.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Updates candidate.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>Edit Candidate</title>
</head>
<body>

<cfif NOT isDefined('FORM.doc_application')> 
	<cfset FORM.doc_application = '0'>
<cfelse>
	<cfset FORM.doc_application = '1'>
</cfif>

<cfif NOT isDefined('FORM.doc_resume')> 
	<cfset FORM.doc_resume = '0'>
<cfelse>
	<cfset FORM.doc_resume = '1'>
</cfif>

<cfif NOT isDefined('FORM.doc_proficiency')> 
	<cfset FORM.doc_proficiency = '0'>
<cfelse>
	<cfset FORM.doc_proficiency = '1'>
</cfif>

<cfif NOT isDefined('FORM.doc_passportphoto')> 
	<cfset FORM.doc_passportphoto = '0'>
<cfelse>
	<cfset FORM.doc_passportphoto = '1'>
</cfif>

<cfif NOT isDefined('FORM.doc_recom_letter')> 
	<cfset FORM.doc_recom_letter = '0'>
<cfelse>
	<cfset FORM.doc_recom_letter = '1'>
</cfif>

<cfif NOT isDefined('FORM.doc_insu')> 
	<cfset FORM.doc_insu = '0'>
<cfelse>
	<cfset FORM.doc_insu = '1'>
</cfif>

<cfif NOT isDefined('FORM.doc_sponsor_letter')> 
	<cfset FORM.doc_sponsor_letter = '0'>
<cfelse>
	<cfset FORM.doc_sponsor_letter = '1'>
</cfif>

<cfif NOT isDefined('FORM.hostcompany_status')> 
	<cfset FORM.hostcompany_status = '0'>
</cfif>

<cfif NOT isDefined('FORM.confirmation_received')> 
	<cfset FORM.confirmation_received = '0'>
</cfif>

<cfquery name="get_candidate_info" datasource="mysql">
    SELECT 
        candidateid, 
        programid, 
        hostcompanyid
    FROM 
        extra_candidates
    WHERE 
        uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueid#">
</cfquery>

<cfquery name="get_max_candcompid" datasource="mysql">
    SELECT 
        MAX(candcompid) as candcompid
    FROM 
        extra_candidate_place_company
    WHERE 
        candidateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_info.candidateid#">
</cfquery>

<!---- PROGRAM HISTORY ---->
<cfif get_candidate_info.programid NEQ FORM.programid>

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
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateid#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason#">,                 
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        )
    </cfquery>
    
</cfif>

<!---- HOST COMPANY HISTORY ---->
<cfif  VAL(FORM.hostcompanyid)>

    <cfif get_candidate_info.hostcompanyid NEQ FORM.hostcompanyid>
        <cfquery name="host_history" datasource="mysql">
            INSERT INTO 
                extra_candidate_place_company
            (
                candidateid, 
                hostcompanyid, 
                placement_date, 
                startdate, 
                enddate, 
                status, 
                confirmation_received, 
                reason_host
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.candidateid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyid#">, 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                <cfif LEN(FORM.host_startdate)>
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.host_startdate)#">
                <cfelse>
                    NULL
                </cfif>,
                <cfif LEN(FORM.host_enddate)>
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.host_enddate)#">
                <cfelse>
                    NULL
                </cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompany_status#">, 
                <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.confirmation_received#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason_host#">
            )
    </cfquery>
<cfelse>
        <cfquery name="host_history_update" datasource="mysql">
            UPDATE 
                extra_candidate_place_company
            SET 
                jobid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.combo_position#">, 
                startdate = <cfif LEN(FORM.host_startdate)> <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.host_startdate)#"> <cfelse> NULL </cfif>,
                enddate = <cfif LEN(FORM.host_enddate)> <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(FORM.host_enddate)#"> <cfelse> NULL </cfif>,
                status = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompany_status#">, 
                confirmation_received = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.confirmation_received#">
            WHERE 
                candcompid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_candcompid.candcompid#">
        </cfquery>
    </cfif>

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
        dob = <cfif LEN(FORM.dob)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.dob)#"> <cfelse> NULL </cfif>,
        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,  
        intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">,  
        trainee_sponsor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.trainee_sponsor#">,   
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
        emergency_relationship = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_relationship#">,	
        degree = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree#">,	 
        degree_other = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree_other#">,	
        degree_comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.degree_comments#">,	
        fieldstudyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fieldstudyid#">,	 
        subfieldid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.listsubcat#">,	 
        doc_application = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_application#">,	 
        doc_resume = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_resume#">,
        doc_proficiency = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_proficiency#">,	  
        doc_passportphoto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_passportphoto#">,	  
        doc_recom_letter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_recom_letter#">,	
        doc_insu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_insu#">,	  
        doc_sponsor_letter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.doc_sponsor_letter#">,	 
        missing_documents = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.missing_documents#">,	  
        programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#">,	
        hostcompanyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostcompanyid#">,		  		
        <!--- earliestarrival = <cfif LEN(FORM.earliestarrival)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.earliestarrival)#"> <cfelse> NULL </cfif>,  --->
        arrivaldate = <cfif LEN(FORM.arrivaldate)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.arrivaldate)#"> <cfelse> NULL </cfif>,
        startdate = <cfif LEN(FORM.startdate)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.startdate)#"> <cfelse> NULL </cfif>, 
        enddate = <cfif LEN(FORM.enddate)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.enddate)#"> <cfelse> NULL </cfif>, 
        remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.remarks#">,  
        cancel_date = <cfif LEN(FORM.cancel_date)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.cancel_date)#"> <cfelse> NULL </cfif>,
        cancel_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancel_reason#">,
        <!--- DS 2019 --->
		verification_received = <cfif LEN(FORM.verification_received)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.verification_received)#"> <cfelse> NULL </cfif>,
        ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019#">,
        <!---ds2019_position = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_position#">, ----> 
        ds2019_subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.combo_subfield#">,
        ds2019_street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_street#">, 
        ds2019_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_city#">, 
        ds2019_state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_state#">, 
        ds2019_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_zip#">, 
        ds2019_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_cell#">,
        ds2019_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ds2019_phone#">,
        ds2019_startdate = <cfif LEN(FORM.ds2019_startdate)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.ds2019_startdate)#"> <cfelse> NULL </cfif>,
        ds2019_enddate = <cfif LEN(FORM.ds2019_enddate)> <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.ds2019_enddate)#"> <cfelse> NULL </cfif>
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
    
<html>
<head>
<cfoutput>
<script language="JavaScript">
    <!-- 
    alert("Candidate Updated!");
        //location.replace("?curdoc=candidate/candidate_form2&unqid=#uniqueid#");
        location.replace("?curdoc=candidate/candidate_info&uniqueid=#FORM.uniqueid#");
    -->
</script>
</cfoutput>
</head>
</html> 		

</body>
</html>