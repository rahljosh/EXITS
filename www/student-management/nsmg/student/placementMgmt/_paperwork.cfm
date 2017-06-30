<!--- ------------------------------------------------------------------------- ----
	
	File:		_paperwork.cfm
	Author:		Marcus Melo
	Date:		June 15, 2011
	Desc:		Placement Paperwork Management

	Updated:	10/26/2012 - Adding Check All option for paperwork and compliance
				06/20/2012 - Compliance log added. 
					PS: smg_hosthistory is already taken by the placement history 
					so I set foreignTable value as smg_hosthistorycompliance
				06/12/2012 - User Role Access Added
				05/30/2012 - Added Compliances
				04/03/2012 - Displaying non-compliant message in line instead of gui
				03/30/2012 - Displaying when records are out of compliance on the fly
				03/09/2012 - Adding double placement docs to the Compliance
				03/02/2012 - Combining _paperworkHistory and _paperwork
				03/02/2012 - Added 3 documents for double placement paperwork
				03/01/2012 - Added 2 documents for single placement paperwork														
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.sendEmail" default="0">
	<!--- Single Person Placement --->
    <cfparam name="FORM.doc_single_place_auth" default="">
    <cfparam name="FORM.compliance_single_place_auth" default="">
    <cfparam name="FORM.doc_single_ref_form_1" default="">
    <cfparam name="FORM.compliance_single_ref_form_1" default="">
    <cfparam name="FORM.doc_single_ref_check1" default="">
    <cfparam name="FORM.compliance_single_ref_check1" default="">
    <cfparam name="FORM.doc_single_ref_form_2" default="">
    <cfparam name="FORM.compliance_single_ref_form_2" default="">
    <cfparam name="FORM.doc_single_ref_check2" default="">
    <cfparam name="FORM.compliance_single_ref_check2" default="">
    <cfparam name="FORM.doc_single_parents_sign_date" default="">
    <cfparam name="FORM.compliance_single_parents_sign_date" default="">
    <cfparam name="FORM.doc_single_student_sign_date" default="">
    <cfparam name="FORM.compliance_single_student_sign_date" default="">
    <!--- Placement Paperwork --->
    <cfparam name="FORM.datePlaced" default="">
    <cfparam name="FORM.dateRelocated" default="">
    <!--- Page 1 --->
    <cfparam name="FORM.doc_host_app_page1_date" default="">
    <cfparam name="FORM.compliance_host_app_page1_date" default="">
    <!--- Page 2 --->
    <cfparam name="FORM.doc_host_app_page2_date" default="">
    <cfparam name="FORM.compliance_host_app_page2_date" default="">
    <!--- Page 3 - Letter --->
    <cfparam name="FORM.doc_letter_rec_date" default="">
    <cfparam name="FORM.compliance_letter_rec_date" default="">
    <!--- Page 4,5,6 - Photos --->
    <cfparam name="FORM.doc_photos_rec_date" default="">
    <cfparam name="FORM.compliance_photos_rec_date" default="">
    <cfparam name="FORM.doc_bedroom_photo" default="">
    <cfparam name="FORM.compliance_bedroom_photo" default="">
    <cfparam name="FORM.doc_bathroom_photo" default="">
    <cfparam name="FORM.compliance_bathroom_photo" default="">
    <cfparam name="FORM.doc_kitchen_photo" default="">
    <cfparam name="FORM.compliance_kitchen_photo" default="">
    <cfparam name="FORM.doc_living_room_photo" default="">
    <cfparam name="FORM.compliance_living_room_photo" default="">
    <cfparam name="FORM.doc_outside_photo" default="">
    <cfparam name="FORM.compliance_outside_photo" default="">   
    <!--- Page 7 - HF Rules ---> 
    <cfparam name="FORM.doc_rules_rec_date" default="">
    <cfparam name="FORM.compliance_rules_rec_date" default="">
    <cfparam name="FORM.doc_rules_sign_date" default="">
    <cfparam name="FORM.compliance_rules_sign_date" default="">
    <!--- Page 8 - School & Community Profile ---> 
    <cfparam name="FORM.doc_school_profile_rec" default="">
    <cfparam name="FORM.compliance_school_profile_rec" default="">
    <!--- Page 9 - Income Verification ---> 
    <cfparam name="FORM.doc_income_ver_date" default="">
    <cfparam name="FORM.compliance_income_ver_date" default="">
    <!--- Page 10 - Confidential HF Visit ---> 
    <cfparam name="FORM.doc_conf_host_rec" default="">
    <cfparam name="FORM.compliance_conf_host_rec" default="">
    <cfparam name="FORM.doc_date_of_visit" default="">
    <cfparam name="FORM.compliance_date_of_visit" default="">
    <!--- Page 11 - Reference 1 ---> 
    <cfparam name="FORM.doc_ref_form_1" default="">
    <cfparam name="FORM.compliance_ref_form_1" default="">    
    <cfparam name="FORM.doc_ref_check1" default="">
    <cfparam name="FORM.compliance_ref_check1" default="">
    <!--- Page 12 - Reference 2 ---> 
    <cfparam name="FORM.doc_ref_form_2" default="">
    <cfparam name="FORM.compliance_ref_form_2" default="">
    <cfparam name="FORM.doc_ref_check2" default="">
    <cfparam name="FORM.compliance_ref_check2" default="">
    <!--- Arrival Compliance --->
    <cfparam name="FORM.doc_school_accept_date" default="">
    <cfparam name="FORM.compliance_school_accept_date" default="">
    <cfparam name="FORM.doc_school_sign_date" default="">
    <cfparam name="FORM.compliance_school_sign_date" default="">
    <!--- Arrival Orientation --->
    <cfparam name="FORM.stu_arrival_orientation" default="">
    <cfparam name="FORM.compliance_stu_arrival_orientation" default="">
    <cfparam name="FORM.host_arrival_orientation" default="">
    <cfparam name="FORM.compliance_host_arrival_orientation" default="">
    <cfparam name="FORM.doc_class_schedule" default=""> 
    <cfparam name="FORM.compliance_class_schedule" default=""> 
    <!--- Double Placement Paperwork --->
    <cfparam name="FORM.doublePlacementIDList" default="">
    <!--- Compliance Log --->
    <cfparam name="FORM.complianceLogNotes" default="">
    <cfparam name="FORM.complianceLogIsResolved" default="0">
    <!--- Second Visit Date Compliance --->
    <cfparam name="FORM.secondVisitDateCompliance" default="">
	<!--- CBC Compliance --->
    <cfparam name="FORM.cbcDateComplianceIDList" default="">
	<!--- Compliance Log --->
    <cfparam name="FORM.compliandeLogIDList" default="">
	<!--- Compliance Review ---->
	<cfparam name="FORM.compliance_review" default="">
	<!----Emails Possibly Sent---->
    <cfparam name="FORM.rmEmail" default="">
    <cfparam name="FORM.arEmail" default="">
    <cfparam name="FORM.prEmail" default="">
	<cfparam name="FORM.ccEmail" default="">
	<cfparam name="FORM.otherEmail" default="">
    <cfparam name="FORM.stuNameID" default="">
	
    <cfset tempEmail = "#form.rmEmail#, #form.arEmail#, #form.prEmail#, #FORM.ccEmail#, #FORM.otherEMail#">
	<cfset FORM.email_to = rereplace(tempEmail, " , ", "", "all")> 
    <cfset FORM.logMessage = "Log sent to #FORM.email_to#">
    <cfscript>
		// PS: smg_hosthistory is already taken by the placement history so I set table name as smg_hosthistorycompliance
		vComplianceTableName = "smg_hosthistorycompliance";
		
		// Get Most Recent CBCs
		qGetMostRecentCBC = APPLICATION.CFC.CBC.getLastHostCBC(hostID=qGetPlacementHistoryByID.hostID);

		// Get Student Info
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentFullInformationByID(studentID=client.studentID);
		
		// Param CBC Compliance FORM Variables 
		for ( i=1; i LTE qGetMostRecentCBC.recordCount; i=i+1 ) {
			param name="FORM.#qGetMostRecentCBC.cbcFamID[i]#_cbcDateCompliance" default="";
		}

		// Get Compliance Log
		qGetComplianceHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																				   
			foreignTable=vComplianceTableName,
			foreignID=qGetPlacementHistoryByID.historyID
		);
		
		// Param Compliance History FORM Variables
		for ( i=1; i LTE qGetComplianceHistory.recordCount; i=i+1 ) {
			param name="FORM.#qGetComplianceHistory.ID[i]#_complianceLogisResolved" default="";
		}

		// Param Double Placement Paperwork FORM Variables 
		for ( i=1; i LTE qGetDoublePlacementPaperworkHistory.recordCount; i=i+1 ) {
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_isDoublePlacementPaperworkRequired" default="1";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementParentsDateSigned" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementParentsDateCompliance" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementStudentDateSigned" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementStudentDateCompliance" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementHostFamilyDateSigned" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementHostFamilyDateCompliance" default="";
		}
			
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {
				// Data Validation
				
		}
		if ( VAL(FORM.submitted) ) {
			//Date of student orientation after arrival
			if ( isDate(FORM.stu_arrival_orientation) AND ( FORM.stu_arrival_orientation LT FORM.studentArrivalDate ) ) {
				SESSION.formErrors.Add("Student orientation date must be completed after Student Arrival - #dateFormat(studentArrivalDate, 'mm/dd/yyyy')#");
				form.stu_arrival_orientation = '';
			}
			//if ( isDate(FORM.doc_date_of_visit) AND ( FORM.host_arrival_orientation LT FORM.hostFamConfVisit OR FORM.host_arrival_orientation GT FORM.studentArrivalDate ) ) {
			//SESSION.formErrors.Add("HF Orientation must be completed after Conf. Host Visit - #dateFormat(form.hostFamConfVisit, 'mm/dd/yyyy')# and before Student Arrival - #dateFormat(FORM.studentArrivalDate, 'mm/dd/yyyy')#");
			//	form.host_arrival_orientation = '';
			//}	
			
			// Update fields on the student table
			APPLICATION.CFC.STUDENT.updatePlacementPaperworkHistory(
				studentID = FORM.studentID,
				historyID = qGetPlacementHistoryByID.historyID,
				// Single Person Placement Paperwork
				doc_single_place_auth = FORM.doc_single_place_auth,
				compliance_single_place_auth = FORM.compliance_single_place_auth,
				doc_single_parents_sign_date = FORM.doc_single_parents_sign_date,
				compliance_single_parents_sign_date = FORM.compliance_single_parents_sign_date,
				doc_single_student_sign_date = FORM.doc_single_student_sign_date,
				compliance_single_student_sign_date = FORM.compliance_single_student_sign_date,
				doc_single_ref_form_1 = FORM.doc_single_ref_form_1,
				compliance_single_ref_form_1 = FORM.compliance_single_ref_form_1,
				doc_single_ref_check1 = FORM.doc_single_ref_check1,
				compliance_single_ref_check1 = FORM.compliance_single_ref_check1,
				doc_single_ref_form_2 = FORM.doc_single_ref_form_2,
				compliance_single_ref_form_2 = FORM.compliance_single_ref_form_2,
				doc_single_ref_check2 = FORM.doc_single_ref_check2,
				compliance_single_ref_check2 = FORM.compliance_single_ref_check2,
				// Placement Paperwork
				datePlaced = FORM.datePlaced,
				previousDatePlaced = qGetPlacementHistoryByID.datePlaced,
				dateRelocated = FORM.dateRelocated,
				// Page 1
				doc_host_app_page1_date = FORM.doc_host_app_page1_date,
				compliance_host_app_page1_date = FORM.compliance_host_app_page1_date,
				// Page 2
				doc_host_app_page2_date = FORM.doc_host_app_page2_date,
				compliance_host_app_page2_date = FORM.compliance_host_app_page2_date,
				// Page 3 - Letter
				doc_letter_rec_date = FORM.doc_letter_rec_date,
				compliance_letter_rec_date = FORM.compliance_letter_rec_date,
				// Page 4,5,6 - Photos
				doc_photos_rec_date = FORM.doc_photos_rec_date,
				compliance_photos_rec_date = FORM.compliance_photos_rec_date,
				doc_bedroom_photo = FORM.doc_bedroom_photo,
				compliance_bedroom_photo = FORM.compliance_bedroom_photo,
				doc_bathroom_photo = FORM.doc_bathroom_photo,
				compliance_bathroom_photo = FORM.compliance_bathroom_photo,
				doc_kitchen_photo = FORM.doc_kitchen_photo,
				compliance_kitchen_photo = FORM.compliance_kitchen_photo,
				doc_living_room_photo = FORM.doc_living_room_photo,
				compliance_living_room_photo = FORM.compliance_living_room_photo,
				doc_outside_photo = FORM.doc_outside_photo,
				compliance_outside_photo = FORM.compliance_outside_photo,
				// Page 7 - HF Rules
				doc_rules_rec_date = FORM.doc_rules_rec_date,
				compliance_rules_rec_date = FORM.compliance_rules_rec_date,
				doc_rules_sign_date = FORM.doc_rules_sign_date,
				compliance_rules_sign_date = FORM.compliance_rules_sign_date,
				// Page 8 - School & Community Profile
				doc_school_profile_rec = FORM.doc_school_profile_rec,
				compliance_school_profile_rec = FORM.compliance_school_profile_rec,
				// Page 9 - Income Verification
				doc_income_ver_date = FORM.doc_income_ver_date,
				compliance_income_ver_date = FORM.compliance_income_ver_date,
				// Page 10 - Confidential HF Visit
				doc_conf_host_rec = FORM.doc_conf_host_rec,
				compliance_conf_host_rec = FORM.compliance_conf_host_rec,
				doc_date_of_visit = FORM.doc_date_of_visit,
				compliance_date_of_visit = FORM.compliance_date_of_visit,
				// Page 11 - Reference 1
				doc_ref_form_1 = FORM.doc_ref_form_1,
				compliance_ref_form_1 = FORM.compliance_ref_form_1,
				doc_ref_check1 = FORM.doc_ref_check1,
				compliance_ref_check1 = FORM.compliance_ref_check1,
				// Page 12 - Reference 2
				doc_ref_form_2 = FORM.doc_ref_form_2,
				compliance_ref_form_2 = FORM.compliance_ref_form_2,
				doc_ref_check2 = FORM.doc_ref_check2,
				compliance_ref_check2 = FORM.compliance_ref_check2,
				// Arrival Compliance
				doc_school_accept_date = FORM.doc_school_accept_date,
				compliance_school_accept_date = FORM.compliance_school_accept_date,
				doc_school_sign_date = FORM.doc_school_sign_date,
				compliance_school_sign_date = FORM.compliance_school_sign_date,
				// Arrival Orientation
				stu_arrival_orientation = FORM.stu_arrival_orientation,
				compliance_stu_arrival_orientation = FORM.compliance_stu_arrival_orientation,
				host_arrival_orientation = FORM.host_arrival_orientation,
				compliance_host_arrival_orientation = FORM.compliance_host_arrival_orientation,
				doc_class_schedule = FORM.doc_class_schedule,
				compliance_class_schedule = FORM.compliance_class_schedule,
				// Compliance Review
				compliance_review = FORM.compliance_review
			);
			
			/**********************************************
				Compliance Check - Only Compliance Users
			**********************************************/
			if ( APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="studentComplianceCheckList") ) {
			
				// Check if we have an entry for the compliance Log
				if ( LEN(FORM.complianceLogNotes) ) {
				
					// Insert Compliance Log Into Separate Table
					APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
						applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																	  
						foreignTable=vComplianceTableName,
						foreignID=qGetPlacementHistoryByID.historyID,
						enteredByID=CLIENT.userID,
						actions=FORM.complianceLogNotes,
						formatActionsText=1,
						isResolved=FORM.complianceLogIsResolved
					);			
				
				}
	
				// Update Compliance Log History - isResolved Yes/No
				for (i=1;i LTE ListLen(FORM.compliandeLogIDList); i=i+1) {
					
					APPLICATION.CFC.LOOKUPTABLES.updateApplicationHistory (
						ID = ListGetAt(FORM.compliandeLogIDList, i),
						isResolved = FORM[ListGetAt(FORM.compliandeLogIDList, i) & "_complianceLogisResolved"]
					);	
					
				}
				
			
				// Update CBC Compliance Date Check
				for (i=1;i LTE ListLen(FORM.cbcDateComplianceIDList); i=i+1) {
					
					APPLICATION.CFC.CBC.updateHostDateCompliance (
						cbcFamID = ListGetAt(FORM.cbcDateComplianceIDList, i),
						dateCompliance = FORM[ListGetAt(FORM.cbcDateComplianceIDList, i) & "_cbcDateCompliance"]
					);	
					
				}

				// Update Second Visit Compliance Date Check
				if ( VAL(qGetSecondVisitReport.ID) ) {
					APPLICATION.CFC.PROGRESSREPORT.updateSecondVisitDateCompliance(ID=qGetSecondVisitReport.ID, dateCompliance=FORM.secondVisitDateCompliance);	
				}

			}

			// Update Double Placement Paperwork
			for (i=1;i LTE ListLen(FORM.doublePlacementIDList); i=i+1) {
				
				APPLICATION.CFC.STUDENT.updateDoublePlacementTrackingHistory(
					ID = ListGetAt(FORM.doublePlacementIDList, i),
					isDoublePlacementPaperworkRequired = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_isDoublePlacementPaperworkRequired"],
					doublePlacementParentsDateSigned = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementParentsDateSigned"],
					doublePlacementParentsDateCompliance = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementParentsDateCompliance"],
					doublePlacementStudentDateSigned = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementStudentDateSigned"],
					doublePlacementStudentDateCompliance = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementStudentDateCompliance"],
					doublePlacementHostFamilyDateSigned = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementHostFamilyDateSigned"],
					doublePlacementHostFamilyDateCompliance = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementHostFamilyDateCompliance"]
				);		
				
			}

		  // Set Page Message
		  SESSION.pageMessages.Add("Form successfully submitted.");
		 
		  if (val(form.sendEmail))
					{
					APPLICATION.CFC.UDF.sendComplianceLog(
						email_to=FORM.email_to,
						stuNameID = FORM.stuNameID,
						historyID = qGetPlacementHistoryByID.historyID,
						foreignTable = vComplianceTableName);
						
					//Set success message
					SESSION.pageMessages.Add("Emails succesfully sent.");
					
					// Insert record of email sent  Log Into Separate Table
					APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
						applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																	  
						foreignTable=vComplianceTableName,
						foreignID=qGetPlacementHistoryByID.historyID,
						enteredByID=CLIENT.userID,
						actions= FORM.logMessage,
						formatActionsText=1,
						isResolved=1
					);	
					}
		 		 // Check if we have an entry for the compliance Log
				
				
							
				
				
			
		  // Reload page
		  location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetPlacementHistoryByID.studentID;
			
			// Single Person Placement Paperwork
			FORM.doc_single_place_auth = qGetPlacementHistoryByID.doc_single_place_auth;
			FORM.compliance_single_place_auth = qGetPlacementHistoryByID.compliance_single_place_auth;
			FORM.doc_single_parents_sign_date = qGetPlacementHistoryByID.doc_single_parents_sign_date;
			FORM.compliance_single_parents_sign_date = qGetPlacementHistoryByID.compliance_single_parents_sign_date;
			FORM.doc_single_student_sign_date = qGetPlacementHistoryByID.doc_single_student_sign_date;
			FORM.compliance_single_student_sign_date = qGetPlacementHistoryByID.compliance_single_student_sign_date;
			FORM.doc_single_ref_form_1 = qGetPlacementHistoryByID.doc_single_ref_form_1;
			FORM.compliance_single_ref_form_1 = qGetPlacementHistoryByID.compliance_single_ref_form_1;
			FORM.doc_single_ref_check1 = qGetPlacementHistoryByID.doc_single_ref_check1;
			FORM.compliance_single_ref_check1 = qGetPlacementHistoryByID.compliance_single_ref_check1;
			FORM.doc_single_ref_form_2 = qGetPlacementHistoryByID.doc_single_ref_form_2;
			FORM.compliance_single_ref_form_2 = qGetPlacementHistoryByID.compliance_single_ref_form_2;
			FORM.doc_single_ref_check2 = qGetPlacementHistoryByID.doc_single_ref_check2;
			FORM.compliance_single_ref_check2 = qGetPlacementHistoryByID.compliance_single_ref_check2;
			
			// Placement Paperwork
			FORM.datePlaced = qGetPlacementHistoryByID.datePlaced;
			FORM.dateRelocated = qGetPlacementHistoryByID.dateRelocated;
			// Page 1
			FORM.doc_host_app_page1_date = qGetPlacementHistoryByID.doc_host_app_page1_date;
			FORM.compliance_host_app_page1_date = qGetPlacementHistoryByID.compliance_host_app_page1_date;
			// Page 2
			FORM.doc_host_app_page2_date = qGetPlacementHistoryByID.doc_host_app_page2_date;
			FORM.compliance_host_app_page2_date = qGetPlacementHistoryByID.compliance_host_app_page2_date;
			// Page 3 - Letter
			FORM.doc_letter_rec_date = qGetPlacementHistoryByID.doc_letter_rec_date;
			FORM.compliance_letter_rec_date = qGetPlacementHistoryByID.compliance_letter_rec_date;
			// Page 4,5,6 - Photos
			FORM.doc_photos_rec_date = qGetPlacementHistoryByID.doc_photos_rec_date;
			FORM.compliance_photos_rec_date = qGetPlacementHistoryByID.compliance_photos_rec_date;
			FORM.doc_bedroom_photo = qGetPlacementHistoryByID.doc_bedroom_photo;
			FORM.compliance_bedroom_photo = qGetPlacementHistoryByID.compliance_bedroom_photo;
			FORM.doc_bathroom_photo = qGetPlacementHistoryByID.doc_bathroom_photo;
			FORM.compliance_bathroom_photo = qGetPlacementHistoryByID.compliance_bathroom_photo;
			FORM.doc_kitchen_photo = qGetPlacementHistoryByID.doc_kitchen_photo;
			FORM.compliance_kitchen_photo = qGetPlacementHistoryByID.compliance_kitchen_photo;
			FORM.doc_living_room_photo = qGetPlacementHistoryByID.doc_living_room_photo;
			FORM.compliance_living_room_photo = qGetPlacementHistoryByID.compliance_living_room_photo;
			FORM.doc_outside_photo = qGetPlacementHistoryByID.doc_outside_photo;
			FORM.compliance_outside_photo = qGetPlacementHistoryByID.compliance_outside_photo;
			// Page 7 - HF Rules
			FORM.doc_rules_rec_date = qGetPlacementHistoryByID.doc_rules_rec_date;
			FORM.compliance_rules_rec_date = qGetPlacementHistoryByID.compliance_rules_rec_date;
			FORM.doc_rules_sign_date = qGetPlacementHistoryByID.doc_rules_sign_date;
			FORM.compliance_rules_sign_date = qGetPlacementHistoryByID.compliance_rules_sign_date;
			// Page 8 - School & Community Profile
			FORM.doc_school_profile_rec = qGetPlacementHistoryByID.doc_school_profile_rec;
			FORM.compliance_school_profile_rec = qGetPlacementHistoryByID.compliance_school_profile_rec;
			// Page 9 - Income Verification
			FORM.doc_income_ver_date = qGetPlacementHistoryByID.doc_income_ver_date;
			FORM.compliance_income_ver_date = qGetPlacementHistoryByID.compliance_income_ver_date;
			// Page 10 - Confidential HF Visit
			FORM.doc_conf_host_rec = qGetPlacementHistoryByID.doc_conf_host_rec;
			FORM.compliance_conf_host_rec = qGetPlacementHistoryByID.compliance_conf_host_rec;
			FORM.doc_date_of_visit = qGetPlacementHistoryByID.doc_date_of_visit;
			FORM.compliance_date_of_visit = qGetPlacementHistoryByID.compliance_date_of_visit;
			//Page 11 - Reference 1
			FORM.doc_ref_form_1 = qGetPlacementHistoryByID.doc_ref_form_1;
			FORM.compliance_ref_form_1 = qGetPlacementHistoryByID.compliance_ref_form_1;
			FORM.doc_ref_check1 = qGetPlacementHistoryByID.doc_ref_check1;
			FORM.compliance_ref_check1 = qGetPlacementHistoryByID.compliance_ref_check1;
			// Page 12- Reference 2
			FORM.doc_ref_form_2 = qGetPlacementHistoryByID.doc_ref_form_2;
			FORM.compliance_ref_form_2 = qGetPlacementHistoryByID.compliance_ref_form_2;
			FORM.doc_ref_check2 = qGetPlacementHistoryByID.doc_ref_check2;
			FORM.compliance_ref_check2 = qGetPlacementHistoryByID.compliance_ref_check2;
			// Arrival Compliance
			FORM.doc_school_accept_date = qGetPlacementHistoryByID.doc_school_accept_date;
			FORM.compliance_school_accept_date = qGetPlacementHistoryByID.compliance_school_accept_date;
			FORM.doc_school_sign_date = qGetPlacementHistoryByID.doc_school_sign_date;
			FORM.compliance_school_sign_date = qGetPlacementHistoryByID.compliance_school_sign_date;
			// Arrival Orientation
			FORM.stu_arrival_orientation = qGetPlacementHistoryByID.stu_arrival_orientation;
			FORM.compliance_stu_arrival_orientation = qGetPlacementHistoryByID.compliance_stu_arrival_orientation;
			FORM.host_arrival_orientation = qGetPlacementHistoryByID.host_arrival_orientation;
			FORM.compliance_host_arrival_orientation = qGetPlacementHistoryByID.compliance_host_arrival_orientation;
			FORM.doc_class_schedule = qGetPlacementHistoryByID.doc_class_schedule;
			FORM.compliance_class_schedule = qGetPlacementHistoryByID.compliance_class_schedule;
			// Compliance Review
			FORM.compliance_review = qGetPlacementHistoryByID.compliance_review;

			// Second Visit Compliance Date Check
			FORM.secondVisitDateCompliance = qGetSecondVisitReport.dateCompliance;

			// CBC Compliance Date Check
			for ( i=1; i LTE qGetMostRecentCBC.recordCount; i=i+1 ) {
				FORM[qGetMostRecentCBC.cbcFamID[i] & "_cbcDateCompliance"] = qGetMostRecentCBC.dateCompliance[i];
			}
			
			// Param Compliance History FORM Variables
			for ( i=1; i LTE qGetComplianceHistory.recordCount; i=i+1 ) {
				FORM[qGetComplianceHistory.ID[i] & "_complianceLogisResolved"] = qGetComplianceHistory.isResolved[i];
			}

			// Double Placement Paperwork
			for ( i=1; i LTE qGetDoublePlacementPaperworkHistory.recordCount; i=i+1 ) {
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_isDoublePlacementPaperworkRequired"] = qGetDoublePlacementPaperworkHistory.isDoublePlacementPaperworkRequired[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementParentsDateSigned"] = qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateSigned[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementParentsDateCompliance"] = qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateCompliance[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementStudentDateSigned"] = qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateSigned[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementStudentDateCompliance"] = qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateCompliance[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementHostFamilyDateSigned"] = qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateSigned[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementHostFamilyDateCompliance"] = qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateCompliance[i];
			}

		}
		
		/***************************************
			Set Compliance Notifications
		***************************************/

		// Set 2nd Visit Variables
		vComplianceWindow = '';
		vDateStartWindowCompliance = '';
		vDateEndWindowCompliance = '';

		if ( isDate(qGetPlacementHistoryByID.datePlaced) ) {
			
			// 2nd Confidential Host Family Visit Form ( Welcome Family - 30 days / Permanent Family 60 days )
			if ( isDate(qGetSecondVisitReport.dateOfVisit) ) {
	
				if ( VAL(qGetPlacementHistoryByID.isWelcomeFamily) ) {
					vComplianceWindow = 30;
				} else {
					vComplianceWindow = 60;
				}
	
				if ( VAL(qGetPlacementHistoryByID.isRelocation) ) {
					vDateStartWindowCompliance = qGetPlacementHistoryByID.dateRelocated;
				} else {
					vDateStartWindowCompliance = qGetArrival.dep_date;
				}
				
				if ( isDate(vDateStartWindowCompliance) ) {
					
					vDateEndWindowCompliance = DateAdd('d', vComplianceWindow, vDateStartWindowCompliance);
					/*
					if ( qGetSecondVisitReport.dateOfVisit GT vDateEndWindowCompliance ) {
						SESSION.formErrors.Add("2nd Confidential Host Family Date of Visit is out of compliance");
					}
					*/
				}
				
			} 
			
		}
	</cfscript>
    
   
    <!---Regional Manager  ---->
    <cfquery name ="RegionalManager" datasource="#application.dsn#">
    	SELECT firstname, lastname, email
    	FROM smg_users
    	LEFT JOIN user_access_rights uar on uar.userid = smg_users.userid
    	WHERE uar.usertype = 5
    	AND uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.regionassigned)#">
    </cfquery>

</cfsilent>


<script type="text/javascript">
<!-- Begin
	var todaysDate = new Date();
	var prettyDate =(todaysDate.getMonth()+1) + '/' + todaysDate.getDate() + '/' + todaysDate.getFullYear();

	$(document).ready(function() {
		
		// Office users are able to update this page
		<cfif APPLICATION.CFC.USER.isOfficeUser()>
			showEditPage();
		<cfelse>
			readOnlyPage();
		</cfif>
		
		loopNonCompliant();		
		
		<cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="studentComplianceCheckList")>
			// Enable Compliance Check 
			$(".complianceCheck").removeAttr('disabled'); 
		<cfelse>
			// Disable Compliance Check 
			$(".complianceCheck").attr("disabled","disabled");
		</cfif>


		// Set Todays Date When Clicking on any of the compliance check boxes
		$(".complianceCheck").click(function () {
			// Get Field ID from CheckBox ID - Remove the string check_
			vInputTextID = $(this).attr("id").replace("check_","");	
			
			if ( $(this).is(':checked') ) {
				$("#" + vInputTextID).val(prettyDate);
			} else {
				$("#" + vInputTextID).val("");
			}
			
		});


		// Check/Uncheck Paperwork Checkboxes
		$("#ckCheckAllPaperwork").click(function () {
			var vStatus = $(this).attr("checked");	
			if ( vStatus == undefined ) {
				vStatus = false;
				$("#labelCheckAllPaperwork").text('[ Check All Paperwork ]');
			} else {
				$("#labelCheckAllPaperwork").text('[ Uncheck All Paperwork ]'); 
			}
			
			// Loop Checkboxes
			$(".paperworkCheckAll").each(function () {
				// Get CheckBox ID
				vCheckBoxID = $(this).attr("id");
				// Get Field ID from CheckBox ID - Remove the string check_
				vInputTextID = vCheckBoxID.replace("check_","");				
				// Get Field Value from Field ID 
				vInputTextValue = $("#" + vInputTextID).val(); 
				
				// Set Today's date - if date is empty 
				if ( vInputTextValue == "" || vInputTextValue == prettyDate ) { 					
					$(this).attr("checked",vStatus);
					if ( vStatus ) {
						$("#" + vInputTextID).val(prettyDate);
					} else {
						$("#" + vInputTextID).val("");
					}
				}
			});
			
		});
		// End of Check/Uncheck Paperwork Checkboxes


		// Check/Uncheck Compliance Checkboxes
		$("#ckCheckAllCompliance").click(function () {
			var vStatus = $(this).attr("checked");	
			if ( vStatus == undefined ) {
				vStatus = false;
				$("#labelCheckAllCompliance").text('[ Check All Compliant ]');
			} else {
				$("#labelCheckAllCompliance").text('[ Uncheck All Compliant ]'); 
			}
			
			// Loop Checkboxes
			$(".complianceCheckAll").each(function () {
				// Get CheckBox ID
				vCheckBoxID = $(this).attr("id");
				// Get Field ID from CheckBox ID - Remove the string check_
				vInputTextID = vCheckBoxID.replace("check_","");				
				// Get Field Value from Field ID 
				vInputTextValue = $("#" + vInputTextID).val(); 
				
				// Set Today's date - if date is empty 
				if ( vInputTextValue == "" || vInputTextValue == prettyDate ) {						
					$(this).attr("checked",vStatus);
					if ( vStatus ) {
						$("#" + vInputTextID).val(prettyDate);
					} else {
						$("#" + vInputTextID).val("");
					}
				}
			});
			
		});
		// End of Check/Uncheck Compliance Checkboxes
		
	});

	var readOnlyPage = function() {
		// Hide editPage and display readOnly
		$(".readOnly").fadeIn("fast");
	}

	var showEditPage = function() {
		// Hide read only and display editPage
		$(".editPage").fadeIn("fast");
		// Hide Non-Compliant Fields
		$(".hideField").fadeOut("fast");
	}

	var displayHiddenFormFields = function() {
		
		if( $(".hideField").css("display") == "none" ) {
			$(".hideField").fadeIn("fast");
			$("#displayFormFieldLink").text('[ Hide Fields ]');
		} else {
			$(".hideField").fadeOut("fast");
			$("#displayFormFieldLink").text('[ Display Fields ]');
		}
		
	}

	var setTodayDate = function(checkFieldID, formFieldID) { 		

		if ( $("#" + checkFieldID).is(':checked') ) {
			$("#" + formFieldID).val(prettyDate);
		} else {
			$("#" + formFieldID).val("");
		}
		
	}
	
	var displayDoublePlacementPaperwork = function(paperworkID) {
		// Get Value 
		vGetSelectedOption = $("#" + paperworkID + "_isDoublePlacementPaperworkRequired").val();
		
		if ( vGetSelectedOption == 1 ) {
			// Display Paperwork
			$("." + paperworkID + "_classDoublePlacementPaperwork").fadeIn("fast");
		} else {
			// Erase Data			
			$("#" + paperworkID + "_doublePlacementParentsDateSigned").val("");
			$("#" + paperworkID + "_doublePlacementStudentDateSigned").val("");
			$("#" + paperworkID + "_doublePlacementHostFamilyDateSigned").val("");
			// Hide Paperwork
			$("." + paperworkID + "_classDoublePlacementPaperwork").fadeOut("fast");
		}
	}
	
	var loopNonCompliant = function(fieldID) {
		
		$(".compliantField").each(function(){
			// Display Notification
			displayNonCompliant(this.id);
		});
		
		// Check 2nd Visit Compliance
		vDateOf2ndVisit = $("#dateOf2ndVisit").val();
		vDateEndWindowCompliance = $("#dateEndWindowCompliance").val();
		
		// Check if 2nd Visit is out of compliance
		if ( new Date(vDateOf2ndVisit).getTime() > new Date(vDateEndWindowCompliance).getTime() ) {
			$("#dateOfVisit").css('border','1px solid #C00');
			$("#dateOfVisit").css({'background-color' : '#FFC'});
			$("#dateOfVisit").after('<span id="nonCompliantNotification' + fieldID + '" class="errors">Non-Compliant - Due Date ' + vDateEndWindowCompliance + '</span>');
		} else {
			$("#dateOfVisit").css('border','1px solid #999');
			$("#dateOfVisit").css({'background-color' : '#EBEBE4'});	
		}
		
	}
	
	var displayNonCompliant = function(fieldID) {
		
		vGetPlacementDate = $("#datePlaced").val();
		vGetPaperworkDate = $("#" + fieldID).val();
		
		// Remove element if exists | Avoid displaying more than one per row at a time
		$("#nonCompliantNotification" + fieldID).remove();
		
		// Check if it's ouf of compliance
		if ( new Date(vGetPaperworkDate).getTime() > new Date(vGetPlacementDate).getTime() ) {
			$("#" + fieldID).css('border','1px solid #C00');
			$("#" + fieldID).css({'background-color' : '#FFC'});
			$("#" + fieldID).after('<span id="nonCompliantNotification' + fieldID + '" class="errors">Non-Compliant - Date Placed ' + vGetPlacementDate + '</span>');
		} else {
			$("#" + fieldID).css('border','1px solid #999');
			$("#" + fieldID).css({'background-color' : '#FFFFFF'});	
		}
		
	}

	// Change Row Color
	$(function() {
		
        $('.mouseOverColor').hover(function() {
            $(this).css('background-color', '#EDEFF4');
        },
        function() {
            $(this).css('background-color', '#FFFFFF');
        });
		
    });	
//  End -->
</script>

<cfoutput>

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="90%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="90%"
        />
      

    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">            
        <tr class="reportCenterTitle">
            <th>
            	<cfif VAL(FORM.historyID)>
                	PLACEMENT PAPERWORK HISTORY
                <cfelse>
                	CURRENT PAPERWORK 
				</cfif>
            </th>
        </tr>
    </table>

	<form name="placementPaperwork" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
		<input type="hidden" name="submitted" value="1"> 
        <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="doublePlacementIDList" value="#ValueList(qGetDoublePlacementPaperworkHistory.ID)#">
        <input type="hidden" name="cbcDateComplianceIDList" value="#ValueList(qGetMostRecentCBC.cbcFamID)#">
        <input type="hidden" name="compliandeLogIDList" value="#ValueList(qGetComplianceHistory.ID)#">
        <input type="hidden" name="dateOf2ndVisit" id="dateOf2ndVisit" value="#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#">
        <input type="hidden" name="dateEndWindowCompliance" id="dateEndWindowCompliance" value="#DateFormat(vDateEndWindowCompliance, 'mm/dd/yyyy')#">
        <input type="hidden" name="studentArrivalDate" id="studentArrivalDate" value="#DateFormat(qGetArrival.dep_date, 'mm/dd/yyyy')#">
        <input type="hidden" name="hostFamConfVisit" id="hostFamConfVisit" value="#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#">
        
        
        <cfswitch expression="#vPlacementStatus#">
            
            <cfcase value="unplaced">
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center" style="padding:10px 0px 10px 0px;">   
                    <tr>
                        <td align="center" style="color:##3b5998;">
                            Student is unplaced, please place the student first in order to have access to the paperwork section.
                        </td>
                    </tr> 
                </table>                    
            </cfcase>
            
            <cfdefaultcase>

                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr>
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="45%">Host Family: #qGetHostInfo.familyLastName# (###qGetHostInfo.hostID#)</td>
                        <td class="reportTitleLeftClean" width="35%">
                        	<cfif APPLICATION.CFC.USER.isOfficeUser()>
                            	<label for="ckCheckAllPaperwork" id="labelCheckAllPaperwork" style="cursor:pointer;">[ Check All Paperwork ]</label> <input type="checkbox" name="ckCheckAllPaperwork" id="ckCheckAllPaperwork" class="displayNone">
                                &nbsp; | &nbsp;
                                <a href="javascript:displayHiddenFormFields();" id="displayFormFieldLink"title="display/hide fields">[ Display Fields ]</a>
                            </cfif>
                        </td>
                        <td class="reportTitleLeftClean" width="15%">
                        	<label for="ckCheckAllCompliance" id="labelCheckAllCompliance" style="cursor:pointer;">[ Check All Compliant ]</label> <input type="checkbox" name="ckCheckAllCompliance" id="ckCheckAllCompliance" class="displayNone complianceCheck">
                        </td>
                    </tr>
                </table>
                
				<!--- Single Placement Paperwork --->
                <cfif vTotalFamilyMembers EQ 1 AND qGetProgramInfo.seasonid GT 7>
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr>
                            <td>
                                <div class="singlePlacementAlert">
                                    <h1>Single Person Placement - Additional screening will be required.</h1>
                                    <em>2 additional references and single person placement authorization form required</em> 
                                </div>
                            </td>
                        </tr>
					</table>
                    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="##edeff4">
                            <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <td class="reportTitleLeftClean" width="45%">Single Placement Paperwork</td>
                            <td class="reportTitleLeftClean" width="35%">Date</td>
                            <td class="reportTitleLeftClean" width="15%">Compliant</td>
                        </tr>
					</table>
                    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <!--- Single Person Placement Verification --->
                        <tr class="mouseOverColor"> 
                            <td width="5%" class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_place_auth" id="check_doc_single_place_auth" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_place_auth');" <cfif isDate(FORM.doc_single_place_auth)>checked</cfif> >
                            </td>
                            <td width="45%"><label for="check_doc_single_place_auth">Single Person Placement Verification</label></td>
                            <td width="35%">
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_place_auth" id="doc_single_place_auth" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#">
                            </td>
                            <td width="15%">
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_place_auth, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_compliance_single_place_auth" id="check_compliance_single_place_auth" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_place_auth)>checked</cfif> >
                                <input type="hidden" name="compliance_single_place_auth" id="compliance_single_place_auth" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_place_auth, 'mm/dd/yyyy')#">
                            </td>
                        </tr>

						<!--- Natural Family Date Signed --->
                        <tr class="mouseOverColor"> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_parents_sign_date">Natural Family Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_parents_sign_date, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_parents_sign_date" id="doc_single_parents_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_parents_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_parents_sign_date');">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_parents_sign_date, 'mm/dd/yyyy')#</span>
                            	<input type="checkbox" name="check_compliance_single_parents_sign_date" id="check_compliance_single_parents_sign_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_parents_sign_date)>checked</cfif> >
                                <input type="hidden" name="compliance_single_parents_sign_date" id="compliance_single_parents_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_parents_sign_date, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Student Date Signed --->
                        <tr class="mouseOverColor"> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_student_sign_date">Student Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_student_sign_date, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_student_sign_date" id="doc_single_student_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_student_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_student_sign_date');">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_student_sign_date, 'mm/dd/yyyy')#</span>
                            	<input type="checkbox" name="check_compliance_single_student_sign_date" id="check_compliance_single_student_sign_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_student_sign_date)>checked</cfif> >
                                <input type="hidden" name="compliance_single_student_sign_date" id="compliance_single_student_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_student_sign_date, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                    
                        <!--- Single Person Placement Reference 1 --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_ref_form_1" id="check_doc_single_ref_form_1" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_ref_form_1');" <cfif isDate(FORM.doc_single_ref_form_1)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_single_ref_form_1">Single Person Placement Reference 1</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_form_1, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_form_1" id="doc_single_ref_form_1" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_single_ref_form_1, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_ref_form_1, 'mm/dd/yyyy')#</span>
                            	<input type="checkbox" name="check_compliance_single_ref_form_1" id="check_compliance_single_ref_form_1" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_ref_form_1)>checked</cfif> >
                                <input type="hidden" name="compliance_single_ref_form_1" id="compliance_single_ref_form_1" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_ref_form_1, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Date of Single Placement Reference Check 1 --->
                        <tr class="mouseOverColor"> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_ref_check1">Date of Single Placement Reference Check 1</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_check1" id="doc_single_ref_check1" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_ref_check1');">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_ref_check1, 'mm/dd/yyyy')#</span>
                            	<input type="checkbox" name="check_compliance_single_ref_check1" id="check_compliance_single_ref_check1" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_ref_check1)>checked</cfif> >
                                <input type="hidden" name="compliance_single_ref_check1" id="compliance_single_ref_check1" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_ref_check1, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Single Person Placement Reference 2 --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_ref_form_2" id="check_doc_single_ref_form_2" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_ref_form_2');" <cfif isDate(FORM.doc_single_ref_form_2)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_single_ref_form_2">Single Person Placement Reference 2</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_form_2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_form_2" id="doc_single_ref_form_2" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_single_ref_form_2, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_ref_form_2, 'mm/dd/yyyy')#</span>
                            	<input type="checkbox" name="check_compliance_single_ref_form_2" id="check_compliance_single_ref_form_2" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_ref_form_2)>checked</cfif> >
                                <input type="hidden" name="compliance_single_ref_form_2" id="compliance_single_ref_form_2" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_ref_form_2, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Date of Single Placement Reference Check 2 --->
                        <tr class="mouseOverColor"> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_ref_check2">Date of Single Placement Reference Check 2</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_check2" id="doc_single_ref_check2" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_ref_check2');">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_single_ref_check2, 'mm/dd/yyyy')#</span>
                            	<input type="checkbox" name="check_compliance_single_ref_check2" id="check_compliance_single_ref_check2" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_single_ref_check2)>checked</cfif> >
                                <input type="hidden" name="compliance_single_ref_check2" id="compliance_single_ref_check2" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_single_ref_check2, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                    </table>
                </cfif> 
                <!--- End of Single Placement Paperwork --->


				<table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="45%">Paperwork</td>
                        <td class="reportTitleLeftClean" width="35%">Date</td>
                        <td class="reportTitleLeftClean" width="15%">Compliant</td>
                    </tr>
                </table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
				
					<!--- Host  Received --->
                    <tr class="mouseOverColor"> 
                        <td width="5%" class="paperworkLeftColumn"></td>
                        <td width="40%"><label>Host App Received ( HQ Received App )</label></td>
                        <td width="45%">
                            #DateFormat(qGetPlacementHistoryByID.dateReceived, 'mm/dd/yyyy')#
                          
                        </td>
                        <td width="10%">&nbsp;</td>
                    </tr>
                   
                    <!--- PIS Approved --->
                    <tr class="mouseOverColor"> 
                        <td width="5%" class="paperworkLeftColumn">
                        	<input type="checkbox" name="datePlacedCheckBox" id="datePlacedCheckBox" class="editPage displayNone" <cfif isDate(qGetPlacementHistoryByID.datePlaced)>checked</cfif> <cfif NOT isDate(FORM.datePlaced) OR NOT APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="datePlacedEdit")>disabled="disabled"</cfif> >
						</td>
                        <td width="45%"><label>Date Placed ( HQ Approval Date )</label></td>
                        <td width="35%">
                        	<span class="readOnly displayNone">#DateFormat(qGetPlacementHistoryByID.datePlaced, 'mm/dd/yyyy')#</span>
							<cfif isDate(FORM.datePlaced) AND APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="datePlacedEdit")>
                                <input type="text" name="datePlaced" id="datePlaced" class="datePicker editPage displayNone" value="#DateFormat(FORM.datePlaced, 'mm/dd/yyyy')#">
                            <cfelse>
                                <input type="text" name="datePlacedReadOnly" id="datePlacedReadOnly" class="datePicker editPage displayNone" value="#DateFormat(FORM.datePlaced, 'mm/dd/yyyy')#" disabled="disabled">
                                <input type="hidden" name="datePlaced" id="datePlaced" class="datePicker editPage displayNone" value="#DateFormat(FORM.datePlaced, 'mm/dd/yyyy')#">
                            </cfif>
                        </td>
                        <td width="15%">&nbsp;</td>
                    </tr>

                    <!--- Date Relocated --->
					<cfif VAL(qGetPlacementHistoryByID.isRelocation)>
                        <tr class="mouseOverColor">
                            <td class="paperworkLeftColumn">                                
                                <input type="checkbox" name="dateRelocatedCheckBox" id="dateRelocatedCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'dateRelocated');" <cfif isDate(FORM.dateRelocated)>checked</cfif> <cfif NOT APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="dateRelocatedEdit")>disabled="disabled"</cfif> >
                            </td>
                            <td><label for="dateRelocatedCheckBox">Date Relocated</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#</span>
                                <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="dateRelocatedEdit")>
	                                <input type="text" name="dateRelocated" id="dateRelocated" class="datePicker editPage displayNone" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#">
                                <cfelse>
	                                <input type="text" name="dateRelocatedReadOnly" id="dateRelocatedReadOnly" class="datePicker editPage displayNone" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#" disabled="disabled">
	                                <input type="hidden" name="dateRelocated" id="dateRelocated" class="datePicker editPage displayNone" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#">
                                </cfif>
                            </td>
                        </tr>
                    </cfif>
                    
                    <!--- PIS Sent to Intl. Representative --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn"><input type="checkbox" name="datePISEmailedCheckBox" id="datePISEmailed" class="editPage displayNone" <cfif isDate(qGetPlacementHistoryByID.datePISEmailed)>checked</cfif> disabled="disabled"></td>
                        <td><label>PIS Emailed to International Representative</label></td>
                        <td colspan="2">
                        	<span class="readOnly displayNone">#DateFormat(qGetPlacementHistoryByID.datePISEmailed, 'mm/dd/yyyy')#</span>
                        	<input type="text" name="datePISEmailed" id="datePISEmailed" class="datePicker editPage displayNone" value="#DateFormat(qGetPlacementHistoryByID.datePISEmailed, 'mm/dd/yyyy')#" disabled="disabled">
                        </td>
                    </tr>
                    
                    <!--- Page 1 --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_host_app_page1_date" id="check_doc_host_app_page1_date" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_host_app_page1_date');" <cfif isDate(FORM.doc_host_app_page1_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_host_app_page1_date">Host Family Application p.1</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_host_app_page1_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_host_app_page1_date" id="doc_host_app_page1_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_host_app_page1_date, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_host_app_page1_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_host_app_page1_date" id="check_compliance_host_app_page1_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_host_app_page1_date)>checked</cfif> >
                            <input type="hidden" name="compliance_host_app_page1_date" id="compliance_host_app_page1_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_host_app_page1_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>

                    <!--- Page 2 --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_host_app_page2_date" id="check_doc_host_app_page2_date" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_host_app_page2_date');" <cfif isDate(FORM.doc_host_app_page2_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_host_app_page2_date">Host Family Application p.2</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_host_app_page2_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_host_app_page2_date" id="doc_host_app_page2_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_host_app_page2_date, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_host_app_page2_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_host_app_page2_date" id="check_compliance_host_app_page2_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_host_app_page2_date)>checked</cfif> >
                            <input type="hidden" name="compliance_host_app_page2_date" id="compliance_host_app_page2_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_host_app_page2_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Page 3 - Letter --->
                    <tr class="mouseOverColor">
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_letter_rec_date" id="check_doc_letter_rec_date" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_letter_rec_date');" <cfif isDate(FORM.doc_letter_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_letter_rec_date">Host Family Letter p.3</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_letter_rec_date" id="doc_letter_rec_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_letter_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_letter_rec_date" id="check_compliance_letter_rec_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_letter_rec_date)>checked</cfif> >
                            <input type="hidden" name="compliance_letter_rec_date" id="compliance_letter_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_letter_rec_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Page 4,5,6 - Photos --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_photos_rec_date" id="check_doc_photos_rec_date" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_photos_rec_date');" <cfif isDate(FORM.doc_photos_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_photos_rec_date">Family Photo</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_photos_rec_date" id="doc_photos_rec_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_photos_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_photos_rec_date" id="check_compliance_photos_rec_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_photos_rec_date)>checked</cfif> >
                            <input type="hidden" name="compliance_photos_rec_date" id="compliance_photos_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_photos_rec_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Required Starting Aug 12 --->
                    <cfif qGetProgramInfo.seasonID GTE 9>
                    
						<!--- Student Bedroom Photo --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_bedroom_photo" id="check_doc_bedroom_photo" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_bedroom_photo');" <cfif isDate(FORM.doc_bedroom_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_bedroom_photo">Student Bedroom Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_bedroom_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_bedroom_photo" id="doc_bedroom_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_bedroom_photo, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_bedroom_photo, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_compliance_bedroom_photo" id="check_compliance_bedroom_photo" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_bedroom_photo)>checked</cfif> >
                                <input type="hidden" name="compliance_bedroom_photo" id="compliance_bedroom_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_bedroom_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Student Bathroom Photo --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_bathroom_photo" id="check_doc_bathroom_photo" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_bathroom_photo');" <cfif isDate(FORM.doc_bathroom_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_bathroom_photo">Student Bathroom Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_bathroom_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_bathroom_photo" id="doc_bathroom_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_bathroom_photo, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_bathroom_photo, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_compliance_bathroom_photo" id="check_compliance_bathroom_photo" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_bathroom_photo)>checked</cfif> >
                                <input type="hidden" name="compliance_bathroom_photo" id="compliance_bathroom_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_bathroom_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Kitchen Photo --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_kitchen_photo" id="check_doc_kitchen_photo" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_kitchen_photo');" <cfif isDate(FORM.doc_kitchen_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_kitchen_photo">Kitchen Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_kitchen_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_kitchen_photo" id="doc_kitchen_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_kitchen_photo, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_kitchen_photo, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_compliance_kitchen_photo" id="check_compliance_kitchen_photo" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_kitchen_photo)>checked</cfif> >
                                <input type="hidden" name="compliance_kitchen_photo" id="compliance_kitchen_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_kitchen_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
    
                        <!--- Living Room Photo --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_living_room_photo" id="check_doc_living_room_photo" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_living_room_photo');" <cfif isDate(FORM.doc_living_room_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_living_room_photo">Living Room Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_living_room_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_living_room_photo" id="doc_living_room_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_living_room_photo, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_living_room_photo, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_compliance_living_room_photo" id="check_compliance_living_room_photo" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_living_room_photo)>checked</cfif> >
                                <input type="hidden" name="compliance_living_room_photo" id="compliance_living_room_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_living_room_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
    
                        <!--- Outside Photo --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_outside_photo" id="check_doc_outside_photo" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_outside_photo');" <cfif isDate(FORM.doc_outside_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_outside_photo">Outside Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_outside_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_outside_photo" id="doc_outside_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_outside_photo, 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(FORM.compliance_outside_photo, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_compliance_outside_photo" id="check_compliance_outside_photo" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_outside_photo)>checked</cfif> >
                                <input type="hidden" name="compliance_outside_photo" id="compliance_outside_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_outside_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
					
                    </cfif>
                    
                    <!--- Page 7 - HF Rules --->
                    <tr class="mouseOverColor">
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_rules_rec_date" id="check_doc_rules_rec_date" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_rules_rec_date');" <cfif isDate(FORM.doc_rules_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_rules_rec_date">Host Family Rules Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_rules_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_rules_rec_date" id="doc_rules_rec_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_rules_rec_date, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_rules_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_rules_rec_date" id="check_compliance_rules_rec_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_rules_rec_date)>checked</cfif> >
                            <input type="hidden" name="compliance_rules_rec_date" id="compliance_rules_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_rules_rec_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>

                    <!--- Date Signed --->
                    <tr class="mouseOverColor"> 
                        <td>&nbsp;</td>
                        <td><label for="doc_rules_sign_date">Date Signed</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_rules_sign_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_rules_sign_date" id="doc_rules_sign_date" class="datePicker editPage displayNone compliantField paperworkCheckAll" value="#DateFormat(FORM.doc_rules_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_rules_sign_date');">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_rules_sign_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_rules_sign_date" id="check_compliance_rules_sign_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_rules_sign_date)>checked</cfif> >
                            <input type="hidden" name="compliance_rules_sign_date" id="compliance_rules_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_rules_sign_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Page 8 - School & Community Profile --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_school_profile_rec" id="check_doc_school_profile_rec" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_school_profile_rec');" <cfif isDate(FORM.doc_school_profile_rec)>checked</cfif> >
						</td>
                        <td><label for="check_doc_school_profile_rec">School & Community Profile Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_profile_rec" id="doc_school_profile_rec" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_school_profile_rec, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_school_profile_rec" id="check_compliance_school_profile_rec" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_school_profile_rec)>checked</cfif> >
                            <input type="hidden" name="compliance_school_profile_rec" id="compliance_school_profile_rec" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_school_profile_rec, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!---- Page 9 - Income Verification --->	
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_income_ver_date" id="check_doc_income_ver_date" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_income_ver_date');" <cfif isDate(FORM.doc_income_ver_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_income_ver_date">Income Verification Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_income_ver_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_income_ver_date" id="doc_income_ver_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_income_ver_date, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_income_ver_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_income_ver_date" id="check_compliance_income_ver_date" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_income_ver_date)>checked</cfif> >
                            <input type="hidden" name="compliance_income_ver_date" id="compliance_income_ver_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_income_ver_date, 'mm/dd/yyyy')#">
                        </td>                        
                    </tr>
                    
                    <!--- Page 10 - Confidential HF Visit --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_conf_host_rec" id="check_doc_conf_host_rec" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_conf_host_rec');" <cfif isDate(FORM.doc_conf_host_rec)>checked</cfif> >
						</td>
                        <td><label for="check_doc_conf_host_rec">Confidential Host Family Visit Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_conf_host_rec, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_conf_host_rec" id="doc_conf_host_rec" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_conf_host_rec, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_conf_host_rec, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_conf_host_rec" id="check_compliance_conf_host_rec" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_conf_host_rec)>checked</cfif> >
                            <input type="hidden" name="compliance_conf_host_rec" id="compliance_conf_host_rec" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_conf_host_rec, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Date of Visit --->
                    <tr class="mouseOverColor"> 
                        <td>&nbsp;</td>
                        <td><label for="doc_date_of_visit">Date of Visit</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_date_of_visit" id="doc_date_of_visit" class="datePicker editPage displayNone compliantField paperworkCheckAll" value="#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_date_of_visit');">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_date_of_visit, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_date_of_visit" id="check_compliance_date_of_visit" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_date_of_visit)>checked</cfif> >
                            <input type="hidden" name="compliance_date_of_visit" id="compliance_date_of_visit" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_date_of_visit, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Second Host Family Visit Report - Get Dates from Progress Report Section --->
                    <cfif qGetProgramInfo.seasonid GT 7>
                    
                        <!--- 2nd Confidential Host Family Visit Form --->
                        <tr class="mouseOverColor"> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="pr_ny_approved_dateCheckBox" id="pr_ny_approved_date" class="editPage displayNone" <cfif isDate(qGetSecondVisitReport.pr_ny_approved_date)>checked</cfif> disabled="disabled">
                            </td>
                            <td><label>2<sup>nd</sup> Confidential Host Family Visit Form ( HQ Approval )</label></td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetSecondVisitReport.pr_ny_approved_date, 'mm/dd/yyyy')#</span>
                                <input type="text" name="pr_ny_approved_date" id="pr_ny_approved_date" class="datePicker editPage displayNone hideField" value="#DateFormat(qGetSecondVisitReport.pr_ny_approved_date, 'mm/dd/yyyy')#" disabled="disabled">
                            </td>
                            <td>&nbsp;</td>
                        </tr>

						<!--- Date of 2nd Visit --->
                        <tr class="mouseOverColor"> 
                            <td>&nbsp;</td>
                            <td><label>Date of 2<sup>nd</sup> Visit</label></td>
                            <td>
                            	<!--- Only display date of visit if report is approved by NY --->
                            	<cfif NOT isDate(qGetSecondVisitReport.pr_ny_approved_date)>
                                    <span class="readOnly displayNone">&nbsp;</span>
                                    <input type="text" name="dateOfVisit" id="dateOfVisit" class="datePicker editPage displayNone" value="" disabled="disabled">
                                <cfelse>
                                    <span class="readOnly displayNone">#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#</span>
                                    <input type="text" name="dateOfVisit" id="dateOfVisit" class="datePicker editPage displayNone" value="#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#" disabled="disabled">
                                </cfif>
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetSecondVisitReport.dateCompliance, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_secondVisitDateCompliance" id="check_secondVisitDateCompliance" class="editPage displayNone complianceCheck" <cfif isDate(FORM.secondVisitDateCompliance)>checked</cfif> <cfif NOT qGetSecondVisitReport.recordCount>disabled="disabled"</cfif> >
                                <input type="hidden" name="secondVisitDateCompliance" id="secondVisitDateCompliance" class="datePicker editPage displayNone" value="#DateFormat(FORM.secondVisitDateCompliance, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                    </cfif>
                    
                    <!--- Page 11 - Reference 1 --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_ref_form_1" id="check_doc_ref_form_1" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_ref_form_1');" <cfif isDate(FORM.doc_ref_form_1)>checked</cfif> >
						</td>
                        <td><label for="check_doc_ref_form_1">Reference Form 1</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_form_1, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_form_1" id="doc_ref_form_1" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_ref_form_1, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_ref_form_1, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_ref_form_1" id="check_compliance_ref_form_1" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_ref_form_1)>checked</cfif> >
                            <input type="hidden" name="compliance_ref_form_1" id="compliance_ref_form_1" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_ref_form_1, 'mm/dd/yyyy')#">
                        </td>
                    </tr>

                    <!--- Date of Reference Check 1 --->   
                    <tr class="mouseOverColor">
                        <td>&nbsp;</td>
                        <td><label for="doc_ref_check1">Date of Reference Check 1</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_check1" id="doc_ref_check1" class="datePicker editPage displayNone compliantField paperworkCheckAll" value="#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_ref_check1');">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_ref_check1, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_ref_check1" id="check_compliance_ref_check1" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_ref_check1)>checked</cfif> >
                            <input type="hidden" name="compliance_ref_check1" id="compliance_ref_check1" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_ref_check1, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                     
                    <!--- Page 12 - Reference 2 --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_ref_form_2" id="check_doc_ref_form_2" class="editPage displayNone paperworkCheckAll" onclick="setTodayDate(this.id, 'doc_ref_form_2');" <cfif isDate(FORM.doc_ref_form_2)>checked</cfif> >
						</td>
                        <td><label for="check_doc_ref_form_2">Reference Form 2</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_form_2, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_form_2" id="doc_ref_form_2" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_ref_form_2, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_ref_form_2, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_ref_form_2" id="check_compliance_ref_form_2" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_ref_form_2)>checked</cfif> >
                            <input type="hidden" name="compliance_ref_form_2" id="compliance_ref_form_2" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_ref_form_2, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Date of Reference Check 2 --->
                    <tr class="mouseOverColor">
                        <td>&nbsp;</td>
                        <td><label for="doc_ref_check2">Date of Reference Check 2</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_check2" id="doc_ref_check2" class="datePicker editPage displayNone compliantField paperworkCheckAll" value="#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_ref_check2');">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_ref_check2, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_ref_check2" id="check_compliance_ref_check2" class="editPage displayNone complianceCheck complianceCheckAll" <cfif isDate(FORM.compliance_ref_check2)>checked</cfif> >
                            <input type="hidden" name="compliance_ref_check2" id="compliance_ref_check2" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_ref_check2, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
				</table>
				
                
                <!--- Arrival Date Compliance --->
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">                 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="75%">
                            Arrival Date Compliance
                            &nbsp; - &nbsp;
                            <cfif VAL(vHasStudentArrived)>
                                Student arrived on: #DateFormat(qGetArrival.dep_date, 'mm/dd/yyyy')#
                            <cfelseif isDate(qGetArrival.dep_date) AND qGetArrival.dep_date GTE now()>
                                Student is going to arrive on: #DateFormat(qGetArrival.dep_date, 'mm/dd/yyyy')#
                            <cfelse>
                                Flight information has not been received
                            </cfif>
                        </td>
                        <td class="reportTitleLeftClean" width="15%">Compliant</td>
                    </tr>
                </table>
                
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">     
                    <!--- School Acceptance Form --->
                    <tr class="mouseOverColor"> 
                        <td width="5%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_school_accept_date" id="check_doc_school_accept_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_school_accept_date');" <cfif isDate(FORM.doc_school_accept_date)>checked</cfif> >
						</td>
                        <td width="45%"><label for="check_doc_school_accept_date">School Acceptance Form</label></td>
                        <td width="35%">
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_accept_date" id="doc_school_accept_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#">
                        </td>
                        <td width="15%">
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_school_accept_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_school_accept_date" id="check_compliance_school_accept_date" class="editPage displayNone complianceCheck" <cfif isDate(FORM.compliance_school_accept_date)>checked</cfif> >
                            <input type="hidden" name="compliance_school_accept_date" id="compliance_school_accept_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_school_accept_date, 'mm/dd/yyyy')#">
                        </td>                        
                    </tr>
                    
                    <!--- School Acceptance Form - Date of Signature --->
                    <tr class="mouseOverColor"> 
                        <td>&nbsp;</td>
                        <td><label for="doc_school_sign_date">Date of Signature</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#</span>
                            
                            <!--- Display Compliance for 12/13 --->
                            <cfif qGetProgramInfo.seasonid GTE 9>
	                            <input type="text" name="doc_school_sign_date" id="doc_school_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_school_sign_date');">
                            <cfelse>
	                            <input type="text" name="doc_school_sign_date" id="doc_school_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#">
    						</cfif>
                        </td>
                        <td width="15%">
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_school_sign_date, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_school_sign_date" id="check_compliance_school_sign_date" class="editPage displayNone complianceCheck" <cfif isDate(FORM.compliance_school_sign_date)>checked</cfif> >
                            <input type="hidden" name="compliance_school_sign_date" id="compliance_school_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_school_sign_date, 'mm/dd/yyyy')#">
                        </td>                        
                    </tr>				
				</table>
                
                
                <!--- CBC - Most Recent Reports --->
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="45%">CBC - Most Recent Reports</td>
                        <td class="reportTitleLeftClean" width="35%">Date</td>
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                    </tr>
    			</table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
					<cfloop query="qGetMostRecentCBC">
                        <tr class="mouseOverColor"> 
                            <td width="5%" class="paperworkLeftColumn">&nbsp;</td>
                            <td width="45%"><label for="#qGetMostRecentCBC.currentRow#-CBC">#qGetMostRecentCBC.fullName#</label></td>
                            <td width="35%">
                                <span class="readOnly displayNone">#DateFormat(qGetMostRecentCBC.date_sent, 'mm/dd/yyyy')# to #DateFormat(qGetMostRecentCBC.date_expired, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetMostRecentCBC.currentRow#-CBC" id="#qGetMostRecentCBC.currentRow#-CBC" class="datePicker editPage displayNone" value="#DateFormat(qGetMostRecentCBC.date_sent, 'mm/dd/yyyy')#" disabled="disabled">
                                <span class="editPage displayNone">to</span>
                                <input type="text" name="#qGetMostRecentCBC.currentRow#-CBC" id="#qGetMostRecentCBC.currentRow#-CBC" class="datePicker editPage displayNone" value="#DateFormat(qGetMostRecentCBC.date_expired, 'mm/dd/yyyy')#" disabled="disabled">
                            </td>
                            <td width="15%">
                            	<span class="readOnly displayNone">#DateFormat(qGetMostRecentCBC.dateCompliance, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_#qGetMostRecentCBC.cbcFamID#_cbcDateCompliance" id="check_#qGetMostRecentCBC.cbcFamID#_cbcDateCompliance" class="editPage displayNone complianceCheck" <cfif isDate(FORM[qGetMostRecentCBC.cbcFamID & '_cbcDateCompliance'])>checked</cfif> >
                                <input type="hidden" name="#qGetMostRecentCBC.cbcFamID#_cbcDateCompliance" id="#qGetMostRecentCBC.cbcFamID#_cbcDateCompliance" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetMostRecentCBC.cbcFamID & '_cbcDateCompliance'], 'mm/dd/yyyy')#">
                            </td>
                        </tr>
					</cfloop>
				</table>   


				<!--- Arrival Orientation --->
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="45%">Arrival Orientation</td>
                        <td class="reportTitleLeftClean" width="35%">Date</td>
                        <td class="reportTitleLeftClean" width="15%">Compliant</td>
                    </tr>
               	</table>
               
               	<table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                    
                    <!--- Student Orientation --->
                    <tr class="mouseOverColor"> 
                        <td width="5%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_stu_arrival_orientation" id="check_stu_arrival_orientation" class="editPage displayNone" onclick="setTodayDate(this.id, 'stu_arrival_orientation');" <cfif isDate(FORM.stu_arrival_orientation)>checked</cfif> >
						</td>
                        <td width="45%"><label for="check_stu_arrival_orientation">Student Orientation</label></td>
                        <td width="35%">
                            <span class="readOnly displayNone">#DateFormat(FORM.stu_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="text" name="stu_arrival_orientation" id="stu_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.stu_arrival_orientation, 'mm/dd/yyyy')#">
                        </td>
                        <td width="15%">
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_stu_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_stu_arrival_orientation" id="check_compliance_stu_arrival_orientation" class="editPage displayNone complianceCheck" <cfif isDate(FORM.compliance_stu_arrival_orientation)>checked</cfif> >
                            <input type="hidden" name="compliance_stu_arrival_orientation" id="compliance_stu_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_stu_arrival_orientation, 'mm/dd/yyyy')#">
                        </td>                        
                    </tr>
                    
                    <!--- Host Family Orientation --->
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_host_arrival_orientation" id="check_host_arrival_orientation" class="editPage displayNone" onclick="setTodayDate(this.id, 'host_arrival_orientation');" <cfif isDate(FORM.host_arrival_orientation)>checked</cfif> >
						</td>
                        <td><label for="check_host_arrival_orientation">Host Family Orientation</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.host_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="text" name="host_arrival_orientation" id="host_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.host_arrival_orientation, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_host_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_host_arrival_orientation" id="check_compliance_host_arrival_orientation" class="editPage displayNone complianceCheck" <cfif isDate(FORM.compliance_host_arrival_orientation)>checked</cfif> >
                            <input type="hidden" name="compliance_host_arrival_orientation" id="compliance_host_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_host_arrival_orientation, 'mm/dd/yyyy')#">
                        </td>                        
                    </tr>
                    
                    <!--- Class Schedule --->
                    <!----We only need this for kids prior to Jan 2013---->
                    <!---<cfif DateCompare(qGetStudentInfo.startDate, '2013-01-01') lt 0>
                    <tr class="mouseOverColor"> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_class_schedule" id="check_doc_class_schedule" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_class_schedule');" <cfif isDate(FORM.doc_class_schedule)>checked</cfif> >
						</td>
                        <td><label for="check_doc_class_schedule">Class Schedule</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_class_schedule, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_class_schedule" id="doc_class_schedule" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_class_schedule, 'mm/dd/yyyy')#">
                        </td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(FORM.compliance_class_schedule, 'mm/dd/yyyy')#</span>
                            <input type="checkbox" name="check_compliance_class_schedule" id="check_compliance_class_schedule" class="editPage displayNone complianceCheck" <cfif isDate(FORM.compliance_class_schedule)>checked</cfif> >
                            <input type="hidden" name="compliance_class_schedule" id="compliance_class_schedule" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_class_schedule, 'mm/dd/yyyy')#">
                        </td>                        
                    </tr>
                    <Cfelse>--->
                    <input type="hidden" name="doc_class_schedule" id="doc_class_schedule" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_class_schedule, 'mm/dd/yyyy')#">
                    <input type="hidden" name="compliance_class_schedule" id="compliance_class_schedule" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_class_schedule, 'mm/dd/yyyy')#">
                    <!---</cfif>--->
                </table>
    
				<!--- Double Placement --->
                <cfloop query="qGetDoublePlacementPaperworkHistory">
                    
                    <cfscript>
                        // Decide if we display or do not display double placement paperwork
                        vDoublePlacementPaperworkClass = '';
                        
                        if ( NOT VAL(FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired']) ) {
                            vDoublePlacementPaperworkClass = "displayNone";	
                        }						
                    </cfscript>
                    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="##edeff4">
                            <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <td class="reportTitleLeftClean" width="45%">
                                Double Placement Paperwork 
                                <br />
                                <cfif qGetDoublePlacementPaperworkHistory.doublePlacementID EQ qGetPlacementHistoryByID.doublePlacementID>
                                    Current Student 
                                <cfelse>
                                    Previous Student 
                                </cfif>
                                &nbsp; - &nbsp; 
                                #qGetDoublePlacementPaperworkHistory.doublePlacementStudent# 
                                &nbsp; - &nbsp; 
                                Assigned on #DateFormat(qGetDoublePlacementPaperworkHistory.dateCreated, 'mm/dd/yyyy')#
                            </td>
                            <td class="reportTitleLeftClean" width="35%">Date</td>
                            <td class="reportTitleLeftClean" width="15%">Compliant</td>
                        </tr>
                    </table>

                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <!--- Is Double Placement Paperwork Required? --->
                        <tr class="mouseOverColor"> 
                            <td width="5%">&nbsp;</td>
                            <td width="45%"><label for="#qGetDoublePlacementPaperworkHistory.ID#_isDoublePlacementPaperworkRequired">Is Paperwork Required?</label></td>
                            <td width="35%">
                                <span class="readOnly displayNone">#YesNoFormat(VAL(qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateSigned))#</span>
                                <select name="#qGetDoublePlacementPaperworkHistory.ID#_isDoublePlacementPaperworkRequired" id="#qGetDoublePlacementPaperworkHistory.ID#_isDoublePlacementPaperworkRequired" class="editPage displayNone smallField" onchange="displayDoublePlacementPaperwork(#qGetDoublePlacementPaperworkHistory.ID#);">
                                    <option value="" <cfif NOT LEN(FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired'])> selected="selected" </cfif> ></option>
                                    <option value="1" <cfif FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired'] EQ 1> selected="selected" </cfif> >Yes</option>
                                    <option value="0" <cfif FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired'] EQ 0> selected="selected" </cfif> >No</option>
                                </select>
                            </td>
                            <td width="15%">&nbsp;</td>
                        </tr>

                        <!--- Natural Family Date Signed --->
                        <tr class="mouseOverColor #qGetDoublePlacementPaperworkHistory.ID#_classDoublePlacementPaperwork #vDoublePlacementPaperworkClass#"> 
                            <td>&nbsp;</td>
                            <td><label for="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned">Natural Family Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateSigned, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementParentsDateSigned'], 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateCompliance, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateCompliance" id="check_#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateCompliance" class="editPage displayNone complianceCheck" <cfif isDate(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementParentsDateCompliance'])>checked</cfif> >
                                <input type="hidden" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateCompliance" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateCompliance" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementParentsDateCompliance'], 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Student Date Signed --->
                        <tr class="mouseOverColor #qGetDoublePlacementPaperworkHistory.ID#_classDoublePlacementPaperwork #vDoublePlacementPaperworkClass#"> 
                            <td>&nbsp;</td>
                            <td><label for="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned">Student Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateSigned, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementStudentDateSigned'], 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateCompliance, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateCompliance" id="check_#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateCompliance" class="editPage displayNone complianceCheck" <cfif isDate(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementStudentDateCompliance'])>checked</cfif> >
                                <input type="hidden" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateCompliance" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateCompliance" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementStudentDateCompliance'], 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Host Family Date Signed --->
                        <tr class="mouseOverColor #qGetDoublePlacementPaperworkHistory.ID#_classDoublePlacementPaperwork #vDoublePlacementPaperworkClass#"> 
                            <td>&nbsp;</td>
                            <td><label for="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned">Host Family Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateSigned, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementHostFamilyDateSigned'], 'mm/dd/yyyy')#">
                            </td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateCompliance, 'mm/dd/yyyy')#</span>
                                <input type="checkbox" name="check_#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateCompliance" id="check_#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateCompliance" class="editPage displayNone complianceCheck" <cfif isDate(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementHostFamilyDateCompliance'])>checked</cfif> >
                                <input type="hidden" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateCompliance" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateCompliance" class="datePicker editPage displayNone" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementHostFamilyDateCompliance'], 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                    </table>
                
                </cfloop>                        
				
                <!--- Only Display for Compliance Users --->
                <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="studentComplianceCheckList")>
				
					<!--- Compliance overall approval section --->
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="##edeff4">
                            <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <td class="reportTitleLeftClean" width="85%">Compliance</td>
                            <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        </tr>
                    </table>
					
					<table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">
                        <tr class="mouseOverColor"> 
	                        <td class="paperworkLeftColumn" width="5%">
	                            <input type="checkbox" name="check_compliance_review" id="check_compliance_review" class="editPage displayNone" onclick="setTodayDate(this.id, 'compliance_review');" <cfif isDate(FORM.compliance_review)>checked</cfif> >
							</td>
	                        <td width="45%"><label for="check_compliance_review">Compliance Review</label></td>
	                        <td width="35%">
	                            <span class="readOnly displayNone">#DateFormat(FORM.compliance_review, 'mm/dd/yyyy')#</span>
	                            <input type="text" name="compliance_review" id="compliance_review" class="datePicker editPage displayNone" value="#DateFormat(FORM.compliance_review, 'mm/dd/yyyy')#">
	                        </td>
	                        <td width="15%">&nbsp;</td>                   
	                    </tr>
                    </table>	
				
					<!--- Compliance Notes and History Section --->
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="##edeff4">
                            <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <td class="reportTitleLeftClean" width="85%">Compliance Notes</td>
                            <td class="reportTitleLeftClean" width="15%">
                            	<cfif qGetComplianceHistory.recordCount>
	                                <a href="printcomplianceHistory.cfm?uniqueID=#qGetStudentInfo.uniqueID#&historyID=#qGetPlacementHistoryByID.historyID#" target="_blank" title="Click to Print Compliance Notes">[ Print ]</a>
                            	</cfif>
                            </td>
                        </tr>
                    </table>
    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <!--- Compliance Notes --->
                        <tr class="mouseOverColor"> 
                            <td width="5%">&nbsp;</td>
                            <td width="45%" valign="top"><label for="complianceLogNotes">Notes</label></td>
                            <td width="35%"><textarea name="complianceLogNotes" id="complianceLogNotes" class="xLargeTextArea">#FORM.complianceLogNotes#</textarea></td>
                            <td width="15%">&nbsp;</td>
                        </tr>
                        <!--- Compliance Resolved --->
                        <tr class="mouseOverColor"> 
                            <td>&nbsp;</td>
                            <td valign="top"><label for="complianceLogIsResolved">Is this an issue that needs attention?</label></td>
                            <td>
                            	<!--- That's an opposite question so we must change Yes/No value to store the correct data in isResolved? field --->
                                <select name="complianceLogIsResolved" id="complianceLogIsResolved" class="xSmallField">
                                    <option value="0" <cfif FORM.complianceLogIsResolved EQ 0> selected="selected" </cfif> >Yes</option>
                                    <option value="1" <cfif FORM.complianceLogIsResolved EQ 1> selected="selected" </cfif> >No</option>
                                </select>
							</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
    			
                </cfif>
                
                <!--- Check if we have a compliance history --->                
                <cfif APPLICATION.CFC.USER.isOfficeUser() AND qGetComplianceHistory.recordCount>
                
					<!--- Compliance Log ---> 
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="##edeff4">
                            <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <td class="reportTitleLeftClean" width="20%">Date</td>
                            <td class="reportTitleLeftClean" width="50%">Compliance History</td>
                            <td class="reportTitleLeftClean" width="15%">Entered By</td>
                            <td class="reportTitleLeftClean" width="15%">Resolved?</td>
                        </tr>
                    </table>
                  <!----Send Email---->
                  <cfif qGetComplianceHistory.recordcount gt 0>
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    	<Tr class="<cfif FORM[qGetComplianceHistory.ID & '_complianceLogIsResolved'] EQ 1>mouseOverColor<cfelse>attention</cfif>">
                        	<td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <Td colspan=2>Send Compliance Log as Email</Td>
                            <td align="center">
                            <input type="hidden" name="stuNameID" value="#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentid#)" />
       						
                            <input type="radio" name="sendEmail" value="1" id="sendEmail"
                                    onclick="document.getElementById('showList').style.display='table-row';" 
                                     />
                                    Yes
                                    </label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label>
                                    <input type="radio" name="sendEmail" value="0" id="sendEmail"
                                  checked='1' onclick="document.getElementById('showList').style.display='none';" 
                                   />
            No</td>
                            
                        </Tr>
                        <tr id="showList" style="display: none;">
                        	<td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                            <td colspan=2><input name='rmEmail' type="checkbox" value='#RegionalManager.email#' id='rmEmail' checked="checked" />#RegionalManager.firstname# #RegionalManager.lastname# (#RegionalManager.email#) <br />
                            	<input name='prEmail' type="checkbox" value='#qGetStudentInfo.placeRepEmail#' id='prEmail' checked="checked" />#qGetStudentInfo.placeRepFirstName# #qGetStudentInfo.placeRepLastName# (#qGetStudentInfo.placeRepEmail#) </td>
                            <td>
                            <input name='ccEmail' type="checkbox" value='#client.email#' id='ccEmail' />#client.name# (#client.email#)<br />
                            Add'l Email(s):<input type="text" name='otherEmail' id='otherEmail' size=10/>
                            
                        </tr>
                    </table>
                  </cfif>
                  <!----End Send Email---->
                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <cfloop query="qGetComplianceHistory">                    
                            <tr class="<cfif FORM[qGetComplianceHistory.ID & '_complianceLogIsResolved'] EQ 1>mouseOverColor<cfelse>attention</cfif>"> 
                                <td width="5%">&nbsp;</td>
                                <td width="20%">#DateFormat(qGetComplianceHistory.dateCreated, 'mm/dd/yy')# at #TimeFormat(qGetComplianceHistory.dateCreated, 'hh:mm tt')# EST</td>
                                <td width="50%">#qGetComplianceHistory.actions#</td>
                                <td width="15%">#qGetComplianceHistory.enteredBy#</td>
                                <td width="15%">
                                    <select name="#qGetComplianceHistory.ID#_complianceLogIsResolved" id="#qGetComplianceHistory.ID#_complianceLogIsResolved" class="xSmallField">
                                        <option value="1" <cfif FORM[qGetComplianceHistory.ID & '_complianceLogIsResolved'] EQ 1> selected="selected" </cfif> >Yes</option>
                                        <option value="0" <cfif FORM[qGetComplianceHistory.ID & '_complianceLogIsResolved'] EQ 0> selected="selected" </cfif> >No</option>
                                    </select>
								</td>
                            </tr>
                        </cfloop>                        
                    </table>
                
				</cfif>
                                
                <!--- Form Buttons --->  
                <table width="90%" id="tableDisplaySaveButton" border="0" cellpadding="2" cellspacing="0" class="section editPage displayNone" align="center" style="padding:5px;">
                    <tr>
                        <td align="center"><input name="Submit" type="image" src="../../student_app/pics/save.gif" border="0" alt="Save"/></td>
                    </tr>                
                </table>   
    
            </cfdefaultcase>
            
        </cfswitch>            

	</form>
        
</cfoutput>