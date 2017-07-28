<!--- ------------------------------------------------------------------------- ----
	
	File:		pending_hosts.cfm
	Author:		Marcus Melo
	Date:		February 13, 2012
	Desc:		Pending Host Families

	Updated:  	08/03/2012 - Placement Type added

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL variables --->
    <cfparam name="URL.sortBy" default="">
    <cfparam name="URL.sortOrder" default="ASC">
    <cfparam name="URL.preAypCamp" default="">
    <cfparam name="URL.status" default="">
    <cfparam name="URL.seasonID" default="0">
    <cfparam name="URL.programID" default="0">
    <cfparam name="URL.activerep" default="2">
     <cfparam name="URL.facilitator" default="">
     <cfparam name="URL.toEmail" default="">
    <!--- Default Facilitators, field, CASE and ESI to All --->
	<!---<cfif ListFind("1,2,3,4,5,6,7", CLIENT.userType) OR listFind("10,14", CLIENT.companyID)>--->
    	<cfparam name="URL.pending_status" default="all_pending">
	<!---<cfelse>
    	<cfparam name="URL.pending_status" default="newPlacements">
    </cfif>--->
    <cfparam name="URL.regionID" default="">
    <cfparam name="URL.seasonid" default="">
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.preAypCamp" default="">
    <cfparam name="FORM.pending_status" default="all_pending">
    <cfparam name="FORM.regionID" default="#CLIENT.regionID#">
    <cfparam name="FORM.userType" default="#CLIENT.userType#">
	
    <cfscript>
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=FORM.userType);

		// Get AYP English Camps
		qAYPEnglishCamps = APPCFC.SCHOOL.getAYPCamps(campType='english');	

		vSetClassNotification = '';

        // make sure we have a valid sortOrder value
		if ( NOT ListFind("ASC,DESC", URL.sortOrder) ) {
			URL.sortOrder = "ASC";				  
		}

		// Build New URL based on preAypCAmp and Placement Type Selection in order to keep the option selected when refreshing the page
		if ( VAL(FORM.submitted) ) {

			// rebuilt QueryString and remove placementType and preAypCamp
			vNewQueryString = CGI.QUERY_STRING;

			// Clean Up preAypCamp URL
			if ( ListContainsNoCase(vNewQueryString, "preAypCamp", "&") ) {
				vNewQueryString = ListDeleteAt(vNewQueryString, ListContainsNoCase(vNewQueryString, "preAypCamp", "&"), "&");
			}
			
			// Clean Up pending_status URL
			if ( ListContainsNoCase(vNewQueryString, "pending_status", "&") ) {
				vNewQueryString = ListDeleteAt(vNewQueryString, ListContainsNoCase(vNewQueryString, "pending_status", "&"), "&");
			}
			
			// Get Current URL
			vNewURL = CGI.SCRIPT_NAME & "?" & vNewQueryString;
			
			if ( LEN(FORM.pending_status) ) {
				vNewURL = vNewURL & "&pending_status=" & FORM.pending_status;
			}
			
			if ( LEN(FORM.preAypCamp) ) {
				vNewURL = vNewURL & "&preAypCamp=" & FORM.preAypCamp;
			}
			
			// Reload Page with proper URL variables
			location(vNewURL, "no");
			
		}
	</cfscript>

    <!--- Field Viewing --->
    <cfif NOT APPLICATION.CFC.USER.isOfficeUser()>
        
		<!--- Get Usertype From Selected Region --->
        <cfquery name="qGetUserTypeByRegion" datasource="#APPLICATION.DSN#"> 
 			SELECT 
                uar.regionID, 
                uar.usertype, 
                u.usertype AS user_access
            FROM 
                user_access_rights uar
            INNER JOIN 
                smg_usertype u ON  u.usertypeid = uar.usertype
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            AND 
                companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">	
            AND 
                uar.usertype != <cfqueryparam cfsqltype="cf_sql_integer" value="9">
            AND 
                uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#">
		</cfquery>  
        
        <cfscript>
			// Set new access level based on region choice
			FORM.userType = qGetUserTypeByRegion.userType;
			
			// User Does Not Have Access - Set default values
			if ( NOT VAL(qGetUserTypeByRegion.recordCount) ) {
				FORM.userType = CLIENT.userType;
				FORM.regionID = CLIENT.regionID;
			}
		</cfscript>
        
    </cfif>
    
	<cfquery name="qGetPendingHosts" datasource="#APPLICATION.DSN#">
		SELECT 
        	DISTINCT
            s.hostid, 
            s.studentid, 
            s.uniqueID,
            s.firstname AS studentFirstName, 
            s.familylastname AS studentLastName, 
            s.regionAssigned, 
            s.placeRepID,
            s.arearepid,
            s.dateplaced,
        	s.host_fam_approved,
            DATEDIFF(CURRENT_DATE(), s.date_host_fam_approved) AS timeOnPending, 
            s.date_host_fam_approved, 
			sh.datePISEmailed,
            sh.doc_school_accept_date,
            h.familylastname AS hostFamilyLastName, 
            h.fatherFirstName, 
            h.fatherLastName, 
            h.motherLastName, 
            h.motherFirstName, 
            h.city, 
            h.state,
            h.regionid,  
			p.programname,
           	p.programid,
           	p.seasonid,
           	season.season, 
            c.companyShort,
            r.regionName,
            arearep.active, 
            facilitator.firstname as FacilitatorFirst,
            facilitator.lastname as FacilitatorLast,
			facilitator.userID as FacilitatorID,
            advisor.userID AS advisorID, 
            sh.secondVisitRepID,  
            sh.historyID,
            sh.doc_school_accept_date,
            sh.compliance_school_accept_date,
            sh.doc_host_app_page1_date,
            sh.compliance_host_app_page1_date,
            sh.doc_host_app_page2_date,
            sh.compliance_host_app_page2_date,
            sh.doc_letter_rec_date,
            sh.compliance_letter_rec_date,
            sh.doc_photos_rec_date,
            sh.compliance_photos_rec_date,
            sh.doc_bedroom_photo,
            sh.compliance_bedroom_photo,
            sh.doc_bathroom_photo,
            sh.compliance_bathroom_photo,
            sh.doc_kitchen_photo,
            sh.compliance_kitchen_photo,
            sh.doc_living_room_photo,
            sh.compliance_living_room_photo,
            sh.doc_outside_photo,
            sh.compliance_outside_photo,
            sh.doc_rules_rec_date,
            sh.compliance_rules_rec_date,
            sh.doc_rules_sign_date,
            sh.compliance_rules_sign_date,
            sh.doc_school_profile_rec,
            sh.compliance_school_profile_rec,
            sh.doc_income_ver_date,
            sh.compliance_income_ver_date,
            sh.doc_conf_host_rec,
            sh.compliance_conf_host_rec,
            sh.doc_date_of_visit,
            sh.compliance_date_of_visit,
            sh.doc_ref_form_1,
            sh.compliance_ref_form_1,
            sh.doc_ref_check1,
            sh.compliance_ref_check1,
            sh.doc_ref_form_2,
            sh.compliance_ref_form_2,
            sh.doc_ref_check2,
            sh.compliance_ref_check2,
            sh.doc_single_ref_form_1,
            sh.compliance_single_ref_form_1,
            sh.doc_single_ref_form_2,
            sh.compliance_single_ref_form_2,
            sh.doc_single_place_auth,
            sh.compliance_single_place_auth,
            sh.doc_single_parents_sign_date,
            sh.compliance_single_parents_sign_date,
            sh.doc_single_student_sign_date,
            sh.compliance_single_student_sign_date,
            sh.hfSupervisingDistance,
            
            sht_doubleplacement.isDoublePlacementPaperworkRequired,
            sht_doubleplacement.doublePlacementParentsDateSigned,
            sht_doubleplacement.doublePlacementParentsDateCompliance,
            sht_doubleplacement.doublePlacementStudentDateSigned,
            sht_doubleplacement.doublePlacementStudentDateCompliance,
            sht_doubleplacement.doublePlacementHostFamilyDateCompliance,
            sht_doubleplacement.doublePlacementHostFamilyDateSigned,

            placrep.firstname AS placeRepFirstName,
            placrep.lastname AS placeRepLastName,
            ( 
            	SELECT
                	ah.actions
                FROM
                	applicationhistory ah
				WHERE
                	ah.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistory">
                AND
                	ah.foreignID = sh.historyID
                ORDER BY
                	ah.dateCreated DESC
                LIMIT 1
			) AS placementAction,
			notes.appNotes,
            notes.dateUpdated AS noteDate,
            count(childid) AS totalChildren                  	
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN 
        	smg_programs p ON p.programid = s.programid
		INNER JOIN 
        	smg_hosthistory sh ON sh.studentID = s.studentID
            AND
            	sh.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND	
            	sh.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- Filter out PHP --->
		INNER JOIN
        	smg_companies c ON c.companyID = s.companyID            
		INNER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
        INNER JOIN 
           	user_access_rights uar ON s.placeRepID = uar.userID
            AND s.regionassigned = uar.regionID
        LEFT JOIN 
            smg_users advisor ON uar.advisorID = advisor.userID
        LEFT JOIN 
            smg_users arearep ON s.areaRepID = arearep.userid
        LEFT JOIN 
            smg_users placrep ON s.placeRepID = placrep.userid
        LEFT JOIN 
            smg_users facilitator ON  r.regionfacilitator = facilitator.userid 
        LEFT JOIN 
            smg_seasons season ON season.seasonid = p.seasonid
        LEFT OUTER JOIN 
            smg_aypcamps english ON s.aypenglish = english.campID
        LEFT OUTER JOIN
        	smg_notes notes ON notes.hostid = h.hostid

        LEFT OUTER JOIN (
                      SELECT    MAX(id) id, studentid, historyID
                      FROM      smg_hosthistorytracking
                      GROUP BY  studentid
                  ) shtMax ON (shtMax.historyID = sh.historyID AND shtMax.studentID = s.studentID)
        LEFT OUTER JOIN
            smg_hosthistorytracking sht ON sht.id = shtMax.id

        LEFT OUTER JOIN smg_hosthistorytracking sht_doubleplacement ON sht_doubleplacement.historyID = sh.historyID 
            AND sht_doubleplacement.fieldName = 'doublePlacementID'

        LEFT JOIN smg_host_children ON (smg_host_children.hostID = h.hostID 
            AND liveAtHome = 'yes' 
            AND smg_host_children.isDeleted = 0)
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	s.host_fam_approved > <cfqueryparam cfsqltype="cf_sql_integer" value="4">	
           		
		<cfif CLIENT.companyID EQ 5>
            AND
                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
		<cfelse>        	
            AND
                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        
        <!--- Pre-AYP Filter --->
		<cfif URL.preAypCamp EQ 'All'>
            AND 
                s.aypenglish = english.campID 
        <cfelseif VAL(URL.preAypCamp)>
            AND 
                s.aypenglish IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.preAypCamp#"> )
        </cfif>        
        <!----Region Filter---->
        <cfif val(URL.regionID)>
        	AND
        		h.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.regionID#">
        </cfif>
          <!----Program Filter---->
        <cfif val(URL.programID)>
        	AND
        		s.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.programID#">
        </cfif>
        <!----Season Filter---->
        <cfif val(URL.seasonID)>
        	AND
        		p.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.seasonID#">
        </cfif>


        <cfif URL.pending_status EQ 'to_approve'>
            AND (compliance_school_accept_date IS NOT NULL AND compliance_school_accept_date <> '')
            AND (compliance_host_app_page1_date IS NOT NULL AND compliance_host_app_page1_date <> '')
            AND (compliance_host_app_page2_date IS NOT NULL AND compliance_host_app_page2_date <> '')
            AND (compliance_letter_rec_date IS NOT NULL AND compliance_letter_rec_date <> '')
            AND (compliance_photos_rec_date IS NOT NULL AND compliance_photos_rec_date <> '')
            AND (compliance_bedroom_photo IS NOT NULL AND compliance_bedroom_photo <> '')
            AND (compliance_bathroom_photo IS NOT NULL AND compliance_bathroom_photo <> '')
            AND (compliance_kitchen_photo IS NOT NULL AND compliance_kitchen_photo <> '')
            AND (compliance_living_room_photo IS NOT NULL AND compliance_living_room_photo <> '')
            AND (compliance_outside_photo IS NOT NULL AND compliance_outside_photo <> '')
            AND (compliance_rules_rec_date IS NOT NULL AND compliance_rules_rec_date <> '')
            AND (compliance_rules_sign_date IS NOT NULL AND compliance_rules_sign_date <> '')
            AND (compliance_school_profile_rec IS NOT  NULL AND compliance_school_profile_rec <> '')
            AND (compliance_income_ver_date IS NOT NULL AND compliance_income_ver_date <> '')
            AND (compliance_conf_host_rec IS NOT NULL AND compliance_conf_host_rec <> '')
            AND (compliance_date_of_visit IS NOT NULL AND compliance_date_of_visit <> '')
            AND (compliance_ref_form_1 IS NOT NULL AND compliance_ref_form_1 <> '')
            AND (compliance_ref_check1 IS NOT NULL AND compliance_ref_check1 <> '')
            AND (compliance_ref_form_2 IS NOT NULL AND compliance_ref_form_2 <> '')
            AND (compliance_ref_check2 IS NOT NULL AND compliance_ref_check2 <> '')

            AND (doc_school_accept_date IS NOT NULL AND doc_school_accept_date <> '')
            AND (doc_host_app_page1_date IS NOT NULL AND doc_host_app_page1_date <> '')
            AND (doc_host_app_page2_date IS NOT NULL AND doc_host_app_page2_date <> '')
            AND (doc_letter_rec_date IS NOT NULL AND doc_letter_rec_date <> '')
            AND (doc_photos_rec_date IS NOT NULL AND doc_photos_rec_date <> '')
            AND (doc_bedroom_photo IS NOT NULL AND doc_bedroom_photo <> '')
            AND (doc_bathroom_photo IS NOT NULL AND doc_bathroom_photo <> '')
            AND (doc_kitchen_photo IS NOT NULL AND doc_kitchen_photo <> '')
            AND (doc_living_room_photo IS NOT NULL AND doc_living_room_photo <> '')
            AND (doc_outside_photo IS NOT NULL AND doc_outside_photo <> '')
            AND (doc_rules_rec_date IS NOT NULL AND doc_rules_rec_date <> '')
            AND (doc_rules_sign_date IS NOT NULL AND doc_rules_sign_date <> '')
            AND (doc_school_profile_rec IS NOT  NULL AND doc_school_profile_rec <> '')
            AND (doc_income_ver_date IS NOT NULL AND doc_income_ver_date <> '')
            AND (doc_conf_host_rec IS NOT NULL AND doc_conf_host_rec <> '')
            AND (doc_date_of_visit IS NOT NULL AND doc_date_of_visit <> '')
            AND (doc_ref_form_1 IS NOT NULL AND doc_ref_form_1 <> '')
            AND (doc_ref_check1 IS NOT NULL AND doc_ref_check1 <> '')
            AND (doc_ref_form_2 IS NOT NULL AND doc_ref_form_2 <> '')
            AND (doc_ref_check2 IS NOT NULL AND doc_ref_check2 <> '')

            AND (hfSupervisingDistance < 120)

            AND ((fatherFirstName IS NOT NULL AND fatherFirstName <> '' AND motherFirstName IS NOT NULL AND motherFirstName <> '')
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                AND (childid = 0 OR childid IS NULL OR childid = '')
                AND compliance_single_ref_form_1 IS NOT NULL 
                AND compliance_single_ref_form_1 <> ''
                AND compliance_single_ref_form_2 IS NOT NULL 
                AND compliance_single_ref_form_2 <> ''
                AND doc_single_ref_form_1 IS NOT NULL 
                AND doc_single_ref_form_1 <> ''
                AND doc_single_ref_form_2 IS NOT NULL 
                AND doc_single_ref_form_2 <> ''))
                
            AND ((sht_doubleplacement.isDoublePlacementPaperworkRequired = 0 OR sht_doubleplacement.isDoublePlacementPaperworkRequired IS NULL)
                OR (sht_doubleplacement.isDoublePlacementPaperworkRequired = 1
                    AND sht_doubleplacement.doublePlacementHostFamilyDateCompliance IS NOT NULL 
                    AND sht_doubleplacement.doublePlacementHostFamilyDateCompliance <> ''
                    AND sht_doubleplacement.doublePlacementHostFamilyDateSigned IS NOT NULL 
                    AND sht_doubleplacement.doublePlacementHostFamilyDateSigned <> ''))

            AND ((sht_doubleplacement.isDoublePlacementPaperworkRequired = 0 OR sht_doubleplacement.isDoublePlacementPaperworkRequired IS NULL)
                OR (sht_doubleplacement.isDoublePlacementPaperworkRequired = 1
                    AND sht_doubleplacement.doublePlacementParentsDateCompliance IS NOT NULL 
                    AND sht_doubleplacement.doublePlacementParentsDateCompliance <> ''
                    AND sht_doubleplacement.doublePlacementStudentDateCompliance IS NOT NULL 
                    AND sht_doubleplacement.doublePlacementStudentDateCompliance = ''
                    AND sht_doubleplacement.doublePlacementParentsDateSigned IS NOT NULL 
                    AND sht_doubleplacement.doublePlacementParentsDateSigned <> ''
                    AND sht_doubleplacement.doublePlacementStudentDateSigned IS NOT NULL 
                    AND sht_doubleplacement.doublePlacementStudentDateSigned = ''))
            
            AND ((fatherFirstName IS NOT NULL AND fatherFirstName <> '' AND motherFirstName IS NOT NULL AND motherFirstName <> '')
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (childid = 0 OR childid IS NULL OR childid = '')
                    AND compliance_single_place_auth IS NOT NULL 
                    AND compliance_single_place_auth <> ''
                    AND compliance_single_parents_sign_date IS NOT NULL 
                    AND compliance_single_parents_sign_date <> ''
                    AND compliance_single_student_sign_date IS NOT NULL 
                    AND compliance_single_student_sign_date <> ''
                    AND doc_single_place_auth IS NOT NULL 
                    AND doc_single_place_auth <> ''
                    AND doc_single_parents_sign_date IS NOT NULL 
                    AND doc_single_parents_sign_date <> ''
                    AND doc_single_student_sign_date IS NOT NULL 
                    AND doc_single_student_sign_date <> ''))

            AND (sh.secondVisitRepID IS NOT NULL AND sh.secondVisitRepID > 0)

        <cfelseif URL.pending_status EQ 'saf_and_hf'>
            AND (((compliance_school_accept_date IS NULL OR compliance_school_accept_date = '')
                OR (compliance_host_app_page1_date IS NULL OR compliance_host_app_page1_date = '')
                OR (compliance_host_app_page2_date IS NULL OR compliance_host_app_page2_date = '')
                OR (compliance_letter_rec_date IS NULL OR compliance_letter_rec_date = '')
                OR (compliance_photos_rec_date IS NULL OR compliance_photos_rec_date = '')
                OR (compliance_bedroom_photo IS NULL OR compliance_bedroom_photo = '')
                OR (compliance_bathroom_photo IS NULL OR compliance_bathroom_photo = '')
                OR (compliance_kitchen_photo IS NULL OR compliance_kitchen_photo = '')
                OR (compliance_living_room_photo IS NULL OR compliance_living_room_photo = '')
                OR (compliance_outside_photo IS NULL OR compliance_outside_photo = '')
                OR (compliance_rules_rec_date IS NULL OR compliance_rules_rec_date = '')
                OR (compliance_rules_sign_date IS NULL OR compliance_rules_sign_date = '')
                OR (compliance_school_profile_rec IS  NULL OR compliance_school_profile_rec = '')
                OR (compliance_income_ver_date IS NULL OR compliance_income_ver_date = '')
                OR (compliance_conf_host_rec IS NULL OR compliance_conf_host_rec = '')
                OR (compliance_date_of_visit IS NULL OR compliance_date_of_visit = '')
                OR (compliance_ref_form_1 IS NULL OR compliance_ref_form_1 = '')
                OR (compliance_ref_check1 IS NULL OR compliance_ref_check1 = '')
                OR (compliance_ref_form_2 IS NULL OR compliance_ref_form_2 = '')
                OR (compliance_ref_check2 IS NULL OR compliance_ref_check2 = '')

                OR (doc_school_accept_date IS NULL OR doc_school_accept_date = '')
                OR (doc_host_app_page1_date IS NULL OR doc_host_app_page1_date = '')
                OR (doc_host_app_page2_date IS NULL OR doc_host_app_page2_date = '')
                OR (doc_letter_rec_date IS NULL OR doc_letter_rec_date = '')
                OR (doc_photos_rec_date IS NULL OR doc_photos_rec_date = '')
                OR (doc_bedroom_photo IS NULL OR doc_bedroom_photo = '')
                OR (doc_bathroom_photo IS NULL OR doc_bathroom_photo = '')
                OR (doc_kitchen_photo IS NULL OR doc_kitchen_photo = '')
                OR (doc_living_room_photo IS NULL OR doc_living_room_photo = '')
                OR (doc_outside_photo IS NULL OR doc_outside_photo = '')
                OR (doc_rules_rec_date IS NULL OR doc_rules_rec_date = '')
                OR (doc_rules_sign_date IS NULL OR doc_rules_sign_date = '')
                OR (doc_school_profile_rec IS  NULL OR doc_school_profile_rec = '')
                OR (doc_income_ver_date IS NULL OR doc_income_ver_date = '')
                OR (doc_conf_host_rec IS NULL OR doc_conf_host_rec = '')
                OR (doc_date_of_visit IS NULL OR doc_date_of_visit = '')
                OR (doc_ref_form_1 IS NULL OR doc_ref_form_1 = '')
                OR (doc_ref_check1 IS NULL OR doc_ref_check1 = '')
                OR (doc_ref_form_2 IS NULL OR doc_ref_form_2 = '')
                OR (doc_ref_check2 IS NULL OR doc_ref_check2 = ''))

                OR (((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (childid = 0 OR childid IS NULL OR childid = ''))
                    AND ((compliance_single_ref_form_1 IS NULL OR compliance_single_ref_form_1 = '')
                        OR (compliance_single_ref_form_2 IS NULL OR compliance_single_ref_form_2 = '')
                        OR (doc_single_ref_form_1 IS NULL OR doc_single_ref_form_1 = '')
                        OR (doc_single_ref_form_2 IS NULL OR doc_single_ref_form_2 = '')))
                
                OR ((sht_doubleplacement.isDoublePlacementPaperworkRequired = 1)
                    AND (sht_doubleplacement.doublePlacementHostFamilyDateCompliance IS NULL OR sht_doubleplacement.doublePlacementHostFamilyDateCompliance = ''
                        OR sht_doubleplacement.doublePlacementHostFamilyDateSigned IS NULL OR sht_doubleplacement.doublePlacementHostFamilyDateSigned = ''))
                
                OR (hfSupervisingDistance >= 120)

                OR (sh.secondVisitRepID IS NULL OR sh.secondVisitRepID = 0))

        <cfelseif URL.pending_status EQ 'int_agent'>
            AND ((sht_doubleplacement.isDoublePlacementPaperworkRequired = 1
                AND (sht_doubleplacement.doublePlacementParentsDateCompliance IS NULL OR sht_doubleplacement.doublePlacementParentsDateCompliance = ''
                    OR sht_doubleplacement.doublePlacementStudentDateCompliance IS NULL OR sht_doubleplacement.doublePlacementStudentDateCompliance = ''))
            
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (childid = 0 OR childid IS NULL OR childid = '')
                    AND (compliance_single_place_auth IS NULL OR compliance_single_place_auth = ''
                        OR compliance_single_parents_sign_date IS NULL OR compliance_single_parents_sign_date = ''
                        OR compliance_single_student_sign_date IS NULL OR compliance_single_student_sign_date = ''
                        OR doc_single_place_auth IS NULL OR doc_single_place_auth = ''
                        OR doc_single_parents_sign_date IS NULL OR doc_single_parents_sign_date = ''
                        OR doc_single_student_sign_date IS NULL OR doc_single_student_sign_date = '')))
        </cfif>


        <!--- Placement Type 
        <cfif URL.placementType EQ 'newPlacements'>
        	AND
            	sh.datePlaced IS NULL
        	AND
            	sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        <cfelseif URL.placementType EQ 'previouslyApproved'>
        	AND
            	sh.datePlaced IS NOT NULL
        	AND
            	sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        <cfelseif URL.placementType EQ 'relocations'>
        	AND
            	sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfif>
        --->



	   <Cfif val(URL.activerep) eq 1>
			AND 
				arearep.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		<Cfelseif URL.activerep eq 0>
			AND 
				arearep.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		</Cfif>
    	<cfif val(url.facilitator)>
            AND
                r.regionFacilitator = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.facilitator#">
        </cfif>
        	
        <cfswitch expression="#FORM.userType#">
        	
            <!--- Filter Out Placements Waiting on AR --->
            <cfcase value="1,2,3">
            	<!---
                AND
                	s.host_fam_approved != <cfqueryparam cfsqltype="cf_sql_integer" value="10">
				--->
            </cfcase>
            <!--- Filter by Facilitator ---> 
        	<cfcase value="4">
                AND
                    r.regionFacilitator = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            	<!--- 
                AND
                	s.host_fam_approved != <cfqueryparam cfsqltype="cf_sql_integer" value="10">
				--->
            </cfcase>
        	
            <!--- Filter by Regional Manager --->
        	<cfcase value="5">
                AND 
                    s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#">
            </cfcase>
        
        	<!--- Filter by Regional Advisor --->
        	<cfcase value="6">
            	AND
                	s.placeRepID IN (
                        SELECT DISTINCT 
                        	userID 
                        FROM 
                        	user_access_rights
                        WHERE
                        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        OR
                        	( 
                                advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#"> 
                            AND 
                                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                       		)
                    )
            </cfcase>
        
        	<!--- Filter by Area Representative --->
        	<cfcase value="7">
                AND 
                    (
                        s.arearepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    OR
                        s.placerepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    )
            </cfcase>
        
        </cfswitch>


       
        GROUP BY
        	s.studentID

		
        ORDER BY
        
        <cfswitch expression="#URL.sortBy#">
            
            <cfcase value="studentID">                    
                s.studentID #URL.sortOrder#,
                studentLastName
            </cfcase>
        
            <cfcase value="studentLastName">
                studentLastName #URL.sortOrder#
            </cfcase>

            <cfcase value="studentFirstName">
                studentFirstName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="regionName">
                r.regionName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="programName">
                p.programName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="hostFamilyLastName">
                hostFamilyLastName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="placementAction">
                placementAction #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="datePISEmailed">
                sh.datePISEmailed #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="actions">
                s.host_fam_approved #URL.sortOrder#,
                p.programName ASC,
                studentLastName
            </cfcase>

            <cfcase value="timeOnPending">
                timeOnPending #URL.sortOrder#,
                studentLastName
            </cfcase>
            
            <!--- Default by program | if field default by approval level --->
            <cfdefaultcase>
                s.date_host_fam_approved
               
            </cfdefaultcase>

        </cfswitch>
        
	</cfquery>
    
    <cfquery name="AvailableRegions" dbtype="query">
    	select distinct regionid, regionname
    	from qGetPendingHosts
    </cfquery>
    
    <cfquery name="AvailablePrograms" dbtype="query">
    	select distinct programID, programName
    	from qGetPendingHosts
    </cfquery>
    
    <cfquery name="AvailableSeasons" dbtype="query">
    	select distinct seasonID, season
    	from qGetPendingHosts
    </cfquery>
    
     <cfquery name="AvailableFacilitators" dbtype="query">
    	select distinct facilitatorFirst, facilitatorLast, facilitatorID
    	from qGetPendingHosts
    	order by 
    	facilitatorFirst
    </cfquery>
    
</cfsilent>   


<script language="javascript">	
	<!-- Begin

    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal - Refresh Student Info page after closing placement management
		$(".jQueryModalPL").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true
		});	
		
		// Submit preAypCamp form when option changes
		$("#placementType").change(function() {
			$("#placementFilterForm").submit();
		});

		// Submit Placement Type form when option changes
		$("#preAypCamp").change(function() {
			$("#placementFilterForm").submit();
		});

	

	});

		
</script>

<cfoutput>

    <div class="sky-form">
	<div class="row">
		<section class="col col-2">
            <!---
			<h3 style="margin:10px 0">Placement Type</h3>
			<label class="select ">
			 <select name="placementType" id="placementType" class="largeField"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=pendingPlacementList&placementType=newPlacements&preAypCamp=#URL.preAypCamp#&regionid=0&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.placementType EQ 'All'> selected="selected" </cfif> >All Placement Types</option>
				<option value="?curdoc=pendingPlacementList&placementType=newPlacements&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.placementType EQ 'newPlacements'> selected="selected" </cfif> >New Placements</option>
                
                <option value="?curdoc=pendingPlacementList&placementType=pendingStatus&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.placementType EQ 'pendingStatus'> selected="selected" </cfif> >Pending Status</option>

				<option value="?curdoc=pendingPlacementList&placementType=previouslyApproved&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.placementType EQ 'previouslyApproved'> selected="selected" </cfif> >Previously Approved</option>
				<option value="?curdoc=pendingPlacementList&placementType=relocations&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.placementType EQ 'relocations'> selected="selected" </cfif> >Relocations</option>
                </select>
            </label>
            --->
            <h3 style="margin:10px 0">Pending Reason</h3>
            <label class="select ">
            <select name="pending_status" id="pending_status" class="largeField"  onChange="top.location.href=this.options[this.selectedIndex].value;">
                <option value="?curdoc=pendingPlacementList&pending_status=&preAypCamp=#URL.preAypCamp#&regionid=0&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.pending_status EQ ''> selected="selected" </cfif> >All Pending</option>

                <option value="?curdoc=pendingPlacementList&pending_status=to_approve&preAypCamp=#URL.preAypCamp#&regionid=0&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.pending_status EQ 'to_approve'> selected="selected" </cfif> >Review & Approve</option>

                <option value="?curdoc=pendingPlacementList&pending_status=saf_and_hf&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.pending_status EQ 'saf_and_hf'> selected="selected" </cfif> >Missing SAF, HF App Info, Sec.Visit Rep and/or Rep within 120mi</option>

                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <option value="?curdoc=pendingPlacementList&pending_status=int_agent&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.pending_status EQ 'int_agent'> selected="selected" </cfif> >International Agent</option>
                </cfif>

            </select>
            </label>
		</section>

		<section class="col col-2">
			<h3 style="margin:10px 0">Pre-AYP Camp:</h3>
			<label class="select ">
			   <select name="preAypCamp" id="preAypCamp" class="largeField"  onChange="top.location.href=this.options[this.selectedIndex].value;">
					<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=0&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.preAypCamp EQ 'All'> selected="selected" </cfif> >All Pre-AYP Camps</option>
					<cfloop query="qAYPEnglishCamps">
						<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#qAYPEnglishCamps.campID#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif URL.preAypCamp EQ qAYPEnglishCamps.campID> selected="selected" </cfif> >#qAYPEnglishCamps.name#</option>
					</cfloop>
				</select>
		</label>
		</section>
		<section class="col col-2">
		<h3 style="margin:10px 0">Region</h3>
		<label class="select ">
		<select name="regionID" id="activerep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&regionID=0&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" curdoc=pendingPlacementList&pending_status=#URL.pending_status#&region=0"">All Regions</option>
			<cfloop query="availableRegions">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif regionID EQ URL.regionID>selected="selected"</cfif>>#regionname#</option>
			</cfloop>
			</select>  

		</label>
		</section>
		
		<section class="col col-2">
		<h3 style="margin:10px 0">Facilitator</h3>
		<label class="select ">
		<select name="regionID" id="activerep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=0&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#">All Facilitators</option>

			<cfloop query="availableFacilitators">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=#facilitatorID#&programid=#URL.programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif facilitatorID EQ URL.facilitator>selected="selected"</cfif>>#FacilitatorFirst# #FacilitatorLast#</option>
			</cfloop>

			</select>  

		</label>
		</section>
		
		<section class="col col-1">
		<h3 style="margin:10px 0">Program</h3>
		<label class="select ">
		<select name="regionID" id="activerep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=#URL.facilitator#&programid=0&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#">All Programs</option>
			<cfloop query="availablePrograms">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#programID#&toEmail=#URL.toEmail#&activeRep=#URL.activeRep#" <cfif programID EQ URL.programID>selected="selected"</cfif>>#programName#</option>
			</cfloop>
			</select>  

		</label>
		</section>
		
        <!---
		<section class="col col-1">
		<h3 style="margin:10px 0">Season</h3>
		<label class="select ">
		<select name="regionID" id="activerep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=pendingPlacementList&placementType=#URL.placementType#&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&seasonID=0&activeRep=#URL.activeRep#">All Seasons</option>
			<cfloop query="AvailableSeasons">
				<option value="?curdoc=pendingPlacementList&placementType=#URL.placementType#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&seasonID=#seasonid#&activeRep=#URL.activeRep#" <cfif seasonID EQ URL.seasonID>selected="selected"</cfif>>#AvailableSeasons.season#</option>
			</cfloop>
			</select>  
		</label>
		</section>
        --->

        <section class="col col-1">
        <h3 style="margin:10px 0">To Email</h3>
        <label class="select ">
        <select name="toEmail" id="toEmail"  onChange="top.location.href=this.options[this.selectedIndex].value;">
                <option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=&activeRep=#URL.activeRep#">All</option>
                <option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=1&activeRep=#URL.activeRep#" <cfif 1 EQ URL.toEmail>selected="selected"</cfif>>Yes</option>
                <option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=0&activeRep=#URL.activeRep#" <cfif 0 EQ URL.toEmail>selected="selected"</cfif>>No</option>
            </select>  
        </label>
        </section>
		
		<section class="col col-1">
		<h3 style="margin:10px 0">Active Rep</h3>
		<label class="select ">
			<select name="activerep" id="activerep"  onChange="top.location.href=this.options[this.selectedIndex].value;">
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#toEmail#&activeRep=2" <cfif URL.activerep EQ 2>selected</cfif>>All</option>
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#toEmail#&activeRep=1" <cfif URL.activerep EQ 1>selected</cfif>>Yes</option>
				<option value="?curdoc=pendingPlacementList&pending_status=#URL.pending_status#&preAypCamp=#URL.preAypCamp#&regionid=#URL.regionid#&facilitator=#URL.facilitator#&programid=#URL.programID#&toEmail=#toEmail#&activeRep=0"<cfif URL.activerep EQ 0>selected</cfif>>No</option>
			</select>  

		</label>
		</section>
		
	
		<section class="counters col col-1">
			<span class="counter" id="totalCounter">-</span>
			<h3>Pending</h>
		</section>
		
	</div>
</div>
                               

    <table  class="table table-striped table-hover">
       <thead>
            <td class="sectionHeader" colspan="5" align="center" bgcolor="##afcee3">
                <strong>S T U D E N T &nbsp;&nbsp;&nbsp; I N F O</strong>
            </td>
            <td class="sectionHeader" colspan="5" align="center" bgcolor="##ede3d0">
                <strong>P L A C E M E N T &nbsp;&nbsp;&nbsp; I N F O</strong>
            </td>
        </thead>
        <tr style="font-weight:bold;" bgcolor="##8E8182">
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Student ID">Student ID</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentLastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Last Name">Last Name</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentFirstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By First Name">First Name</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='regionName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Region">Region-Placing Rep</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='programName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Program">Program</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='hostFamilyLastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Host Family">Host Family</a></td>
            <td class="sectionHeader" width="380"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='placementAction',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Reason">Reason</a></td>
            <td class="sectionHeader" width="120">Notes</td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='datePISEmailed',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Date PIS Emailed">Date PIS Emailed</a></td>
	        <td class="sectionHeader">Actions</td>
            <td class="sectionHeader" align="center"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='timeOnPending',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Time on Pending">Time on Pending</a></td>

            <td class="sectionHeader" align="center"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='missingDocuments',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Missing Documents">Missing Documents</a></td>
        </tr>
        <td>
				
			</td> 
        <cfset totalShown = 0 />
        <cfloop query="qGetPendingHosts">
        
			<!---<cfscript>
				// Set Default Value
				vTimeOnPending = '';
				
				// Set Default Value
				vNumberWaiting = 'n/a';

				// Reset Class Notification
				vSetClassNotification = "attention";
			
                // Only check paperwork for placements pending HQ approval
                if ( qGetPendingHosts.host_fam_approved EQ 5 OR APPLICATION.CFC.USER.isOfficeUser() ) {
                
                    // Check if we have CBC and School Acceptance in order to allow PIS to be emailed out
                    vDisplayEmailLink = 0;
                    
					// Do not check compliance for Wayne Brewer - Page will load quicker
                    if ( CLIENT.userID NEQ 1956 ) { 
                    
                        // Check if Host Family is in compliance
                        vHostInCompliance = APPLICATION.CFC.CBC.checkHostFamilyCompliance(
                                                hostID=qGetPendingHosts.hostID, 
                                                studentID=qGetPendingHosts.studentID,
                                                schoolAcceptanceDate = qGetPendingHosts.doc_school_accept_date
                                            );
                        
                        if ( NOT LEN(vHostInCompliance) ) {
                            vDisplayEmailLink = 1;
                        }
                    
                    }
                
                    if ( NOT isDate(qGetPendingHosts.datePISEmailed) AND VAL(vDisplayEmailLink) AND APPLICATION.CFC.USER.isOfficeUser() ) {
                        
                        vTimeOnPending = '<a href="reports/placementInfoSheet.cfm?uniqueID=#qGetPendingHosts.uniqueID#&closeModal=1" class="jQueryModalPL">[Email]</a>';
                        
                    } else if ( NOT VAL(vDisplayEmailLink) AND CLIENT.userID NEQ 1956 ) { // Wayne
                    
                        //vTimeOnPending = 'waiting on CBC <br /> and/or school acceptance';
                        
                    } else if ( isDate(qGetPendingHosts.datePISEmailed) ) {
                        
						vSetClassNotification = "attentionGreen";
                        vTimeOnPending = '#DateFormat(qGetPendingHosts.datePISEmailed, 'mm/dd/yyyy')#';
                        
                        
                    }
				
				}
            </cfscript>--->
			<cfscript>
				// Set Default Value
				vDisplayStudent = true;
				
				// If selecting Pre-AYP display only students that are pending documents
				if ( LEN(URL.preAypCamp) AND vSetClassNotification EQ 'attentionGreen' ) {
					vDisplayStudent = true;
				}
            </cfscript>

            <cfif NOT isDate(qGetPendingHosts.datePISEmailed) 
                AND APPLICATION.CFC.USER.isOfficeUser()
                AND ((VAL(qGetPendingHosts.isDoublePlacementPaperworkRequired)
                        AND (NOT isDate(qGetPendingHosts.doublePlacementParentsDateCompliance)
                        OR NOT isDate(qGetPendingHosts.doublePlacementStudentDateCompliance)
                        OR NOT isDate(qGetPendingHosts.doublePlacementParentsDateSigned)
                        OR NOT isDate(qGetPendingHosts.doublePlacementStudentDateSigned)))

                    OR ((LEN(qGetPendingHosts.fatherFirstName) EQ 0 OR LEN(qGetPendingHosts.motherFirstName) EQ 0)
                        AND qGetPendingHosts.totalChildren EQ 0
                        AND (NOT isDate(qGetPendingHosts.compliance_single_place_auth)
                            OR NOT isDate(qGetPendingHosts.compliance_single_parents_sign_date)
                            OR NOT isDate(qGetPendingHosts.compliance_single_student_sign_date)
                            OR NOT isDate(qGetPendingHosts.doc_single_place_auth)
                            OR NOT isDate(qGetPendingHosts.doc_single_parents_sign_date)
                            OR NOT isDate(qGetPendingHosts.doc_single_student_sign_date))))>
                <cfset vDisplayEmailLink = true />
            <cfelse>
                <cfset vDisplayEmailLink = false />
            </cfif>
        	
            <cfif vDisplayStudent AND 
                    (URL.toEmail EQ '' 
                        OR (VAL(URL.toEmail) EQ 1 
                            AND vDisplayEmailLink
                        )
                        OR (VAL(URL.toEmail) EQ 0
                            AND NOT vDisplayEmailLink)
                        )
                    >

                    <cfset totalShown = totalShown + 1 />
            
                <tr bgcolor="#iif(qGetPendingHosts.currentRow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                    <td class="sectionHeader" ><a href="index.cfm?curdoc=student_info&studentID=#qGetPendingHosts.studentid#" target="_blank">#qGetPendingHosts.studentid#</a></td>
                    <td class="sectionHeader">#qGetPendingHosts.studentLastName#</td>
                    <td class="sectionHeader">#qGetPendingHosts.studentFirstName#</td>
                    <td class="sectionHeader">
                        <cfif CLIENT.companyID EQ 5>
                            #qGetPendingHosts.companyShort# - 
                        </cfif>
                        #qGetPendingHosts.regionname# - #LEFT(placeRepFirstName,1)#. #placeRepLastName# (###placeRepID#)
                    </td>
                    <td class="sectionHeader">#qGetPendingHosts.programname# </td>
                    <td class="sectionHeader">
                        <a href="index.cfm?curdoc=host_fam_info&hostid=#qGetPendingHosts.hostID#" target="_blank">
                            #APPLICATION.CFC.HOST.displayHostFamilyName(
                                hostID=qGetPendingHosts.hostID,
                                fatherFirstName=qGetPendingHosts.fatherFirstName,
                                fatherLastName=qGetPendingHosts.fatherLastName,
                                motherFirstName=qGetPendingHosts.motherFirstName,
                                motherLastName=qGetPendingHosts.motherLastName,
                                familyLastName=qGetPendingHosts.hostFamilyLastName
    
                            )#
                        </a>            
                    </td>
                    <td class="sectionHeader">#qGetPendingHosts.placementAction#</td>
                    <td class="sectionHeader">
                    	<a href="pending-list/appNotes.cfm?hostID=#qGetPendingHosts.hostid#" class="jQueryModalPL" title="Open Notes">
							<cfif qGetPendingHosts.appNotes is ''>
								<button type="button" class="btn btn-default btn-sm"><i class="fa fa-comments-o" aria-hidden="true"></i> Add Notes</button>
							<cfelse>
								<button type="button" class="btn btn-warning btn-sm"><i class="fa fa-comments-o" aria-hidden="true"></i> #DATEFORMAT(qGetPendingHosts.noteDate, 'm/dd/yy')#</button>
							</cfif>
						</a>
					</td>
                    <td class="sectionHeader">
                        <cfif NOT isDate(qGetPendingHosts.datePISEmailed) 
                            AND APPLICATION.CFC.USER.isOfficeUser()
                            AND vDisplayEmailLink>
                            <a href="reports/placementInfoSheet.cfm?uniqueID=#qGetPendingHosts.uniqueID#&closeModal=1" class="jQueryModalPL">[Email]</a>
                        </cfif>
                        <cfif isDate(qGetPendingHosts.datePISEmailed) >
                            #dateFormat(qGetPendingHosts.datePISEmailed, 'm/dd/yy')#
                        </cfif>
                    </td>
                    <td class="sectionHeader">
                        
                        <cfswitch expression="#qGetPendingHosts.host_fam_approved#">
                            
                            <!--- Pending HQ Approval --->
                            <cfcase value="5">
                                
                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL btn btn-success btn-sm" style="color:##fff"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                <cfelse>
                                    (Pending HQ Approval)
                                </cfif>
                                
                            </cfcase>                    
    
                            <!--- Pending Regional Manager Approval --->
                            <cfcase value="6">
    
                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL btn btn-success btn-sm" style="display:block; color:##fff"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                </cfif>
                                
                                <cfif FORM.userType EQ 5>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL btn btn-success btn-sm" style="color:##fff"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                <cfelse>
                                    (Pending RM Approval)
                                </cfif>
                                
                            </cfcase>                    
                            
                            <!--- Pending Regional Advisor Approval --->
                            <cfcase value="7">
    
                                <cfif listFind("1,2,3,4,5", FORM.userType)>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL  btn btn-success btn-sm" style="display:block; color:##fff"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                </cfif>
                                
                                <cfif CLIENT.userID EQ qGetPendingHosts.advisorID>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL btn btn-success btn-sm"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                <cfelseif VAL(qGetPendingHosts.advisorID)>
                                    (Pending RA Approval)
                                <cfelse>
                                    (Pending RM Approval)
                                </cfif>
                                
                            </cfcase>                    
                        
                            <!--- Pending Area Representative Approval --->
                            <cfcase value="10">
    
                                <cfif listFind("1,2,3,4,5,6", FORM.userType)>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL btn btn-success btn-sm" style="display:block;"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                </cfif>
                                
                                <cfif CLIENT.userID EQ qGetPendingHosts.placeRepID>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL btn btn-success btn-sm"><i class="fa fa-thumbs-o-up" aria-hidden="true"></i> Review</a>
                                <cfelse>
                                    (Pending AR Approval)
                                </cfif>
                                
                            </cfcase>                    
                            
                            <!--- Rejected --->
                            <cfcase value="99">
                                Rejected
                                <cfset vSetClassNotification = "rejected">
                            </cfcase>                    
    
                        </cfswitch>
                    </td>
                    <!--- class = #vSetClassNotification# --->
                    <!--- No color <=5 Days
                       - Yellow >5 && <=10
                       - Orange >10 && <=15
                       - Red >15 days 
                    --->
                    <td class="sectionHeader"
                        <cfif DateDiff("d", qGetPendingHosts.date_host_fam_approved, now()) GT 5 
                            AND DateDiff("d", qGetPendingHosts.date_host_fam_approved, now()) LTE 10>
                            style="background-color: ##ffff9d"
                        <cfelseif DateDiff("d", qGetPendingHosts.date_host_fam_approved, now()) GT 10 
                            AND DateDiff("d", qGetPendingHosts.date_host_fam_approved, now()) LTE 15>
                            style="background-color: ##ffcf9d"
                        <cfelseif DateDiff("d", qGetPendingHosts.date_host_fam_approved, now()) GT 15>
                            style="background-color:##CC0000; color:##fff;"
                        </cfif>

                         align="center">	
                        <strong>#APPLICATION.CFC.UDF.calculateTimePassed(dateStarted=qGetPendingHosts.date_host_fam_approved, dateEnded=now())#</strong>
                    </td>
                    <td class="sectionHeader">
                        <cfif NOT isDate(qGetPendingHosts.compliance_school_accept_date)
                            OR NOT isDate(qGetPendingHosts.doc_school_accept_date)>
                            - SAF<br />
                        </cfif>

                        <cfif NOT isDate(qGetPendingHosts.compliance_host_app_page1_date)
                            OR NOT isDate(qGetPendingHosts.compliance_host_app_page2_date)
                            OR NOT isDate(qGetPendingHosts.compliance_letter_rec_date)
                            OR NOT isDate(qGetPendingHosts.compliance_photos_rec_date)
                            OR NOT isDate(qGetPendingHosts.compliance_bedroom_photo)
                            OR NOT isDate(qGetPendingHosts.compliance_bathroom_photo)
                            OR NOT isDate(qGetPendingHosts.compliance_kitchen_photo)
                            OR NOT isDate(qGetPendingHosts.compliance_living_room_photo)
                            OR NOT isDate(qGetPendingHosts.compliance_outside_photo)
                            OR NOT isDate(qGetPendingHosts.compliance_rules_rec_date)
                            OR NOT isDate(qGetPendingHosts.compliance_rules_sign_date)
                            OR NOT isDate(qGetPendingHosts.compliance_school_profile_rec)
                            OR NOT isDate(qGetPendingHosts.compliance_income_ver_date)
                            OR NOT isDate(qGetPendingHosts.compliance_conf_host_rec)
                            OR NOT isDate(qGetPendingHosts.compliance_date_of_visit)
                            OR NOT isDate(qGetPendingHosts.compliance_ref_form_1)
                            OR NOT isDate(qGetPendingHosts.compliance_ref_check1)
                            OR NOT isDate(qGetPendingHosts.compliance_ref_form_2)
                            OR NOT isDate(qGetPendingHosts.compliance_ref_check2)

                            OR NOT isDate(qGetPendingHosts.doc_host_app_page1_date)
                            OR NOT isDate(qGetPendingHosts.doc_host_app_page2_date)
                            OR NOT isDate(qGetPendingHosts.doc_letter_rec_date)
                            OR NOT isDate(qGetPendingHosts.doc_photos_rec_date)
                            OR NOT isDate(qGetPendingHosts.doc_bedroom_photo)
                            OR NOT isDate(qGetPendingHosts.doc_bathroom_photo)
                            OR NOT isDate(qGetPendingHosts.doc_kitchen_photo)
                            OR NOT isDate(qGetPendingHosts.doc_living_room_photo)
                            OR NOT isDate(qGetPendingHosts.doc_outside_photo)
                            OR NOT isDate(qGetPendingHosts.doc_rules_rec_date)
                            OR NOT isDate(qGetPendingHosts.doc_rules_sign_date)
                            OR NOT isDate(qGetPendingHosts.doc_school_profile_rec)
                            OR NOT isDate(qGetPendingHosts.doc_income_ver_date)
                            OR NOT isDate(qGetPendingHosts.doc_conf_host_rec)
                            OR NOT isDate(qGetPendingHosts.doc_date_of_visit)
                            OR NOT isDate(qGetPendingHosts.doc_ref_form_1)
                            OR NOT isDate(qGetPendingHosts.doc_ref_check1)
                            OR NOT isDate(qGetPendingHosts.doc_ref_form_2)
                            OR NOT isDate(qGetPendingHosts.doc_ref_check2)>

                            - HF App Info<br />
                        </cfif>

                        <cfif (LEN(qGetPendingHosts.fatherFirstName) EQ 0 OR LEN(qGetPendingHosts.motherFirstName) EQ 0)
                            AND qGetPendingHosts.totalChildren EQ 0
                            AND (NOT isDate(qGetPendingHosts.compliance_single_ref_form_1)
                                OR NOT isDate(qGetPendingHosts.compliance_single_ref_form_2)
                                OR NOT isDate(qGetPendingHosts.doc_single_ref_form_1)
                                OR NOT isDate(qGetPendingHosts.doc_single_ref_form_2))>

                            - HF Single Person References<br />
                        </cfif>

                        <cfif VAL(qGetPendingHosts.isDoublePlacementPaperworkRequired) 
                                AND (NOT isDate(qGetPendingHosts.doublePlacementHostFamilyDateCompliance)
                                    OR NOT isDate(qGetPendingHosts.doublePlacementHostFamilyDateSigned))>

                            - HF Double Placement<br />
                        </cfif>

                        <cfif VAL(qGetPendingHosts.isDoublePlacementPaperworkRequired)
                                AND (NOT isDate(qGetPendingHosts.doublePlacementParentsDateCompliance)
                                OR NOT isDate(qGetPendingHosts.doublePlacementStudentDateCompliance)
                                OR NOT isDate(qGetPendingHosts.doublePlacementParentsDateSigned)
                                OR NOT isDate(qGetPendingHosts.doublePlacementStudentDateSigned))>
                            - IA Double Placement <br />
                        </cfif>

                        <cfif (LEN(qGetPendingHosts.fatherFirstName) EQ 0 OR LEN(qGetPendingHosts.motherFirstName) EQ 0)
                                AND qGetPendingHosts.totalChildren EQ 0
                                AND (NOT isDate(qGetPendingHosts.compliance_single_place_auth)
                                    OR NOT isDate(qGetPendingHosts.compliance_single_parents_sign_date)
                                    OR NOT isDate(qGetPendingHosts.compliance_single_student_sign_date)
                                    OR NOT isDate(qGetPendingHosts.doc_single_place_auth)
                                    OR NOT isDate(qGetPendingHosts.doc_single_parents_sign_date)
                                    OR NOT isDate(qGetPendingHosts.doc_single_student_sign_date))>
                            - IA Single Person Placement <br />
                        </cfif>

                        <cfif VAL(qGetPendingHosts.hfSupervisingDistance) GT 120 >
                            - Super. Rep Distance
                        </cfif>

                        <cfif NOT VAL(secondVisitRepID)>
                            - Second Visit Rep.
                        </cfif>

                    </td>
                </tr>

			</cfif>
                
        </cfloop>
        
    </table>

    <script >
    $( document ).ready(function() {
        $("##totalCounter").html(#totalShown#);
    });
    </script>

	<!--- Table Footer --->
   
	
    <p style="margin-top:10px;">*you can override anyone below you in the approval process. You can not approve past your level.</p>

    <!---
    <table align="center" cellpadding="4" cellspacing="0" class="nav_bar">
        <th bgcolor="##CC0000" ><font color="##FFFFFF">Key</font></th>
        <tr class="attention">
            <td align="Center">Waiting for CBC and/or School Acceptance Form</td>
        </tr>
        <tr class="attentionGreen">
            <td align="Center">Waiting for Host Family Application</td>
        </tr>
            <tr class="rejected">
            <td align="Center">Rejected</td>
        </tr>
    </table>
    --->

</cfoutput>
