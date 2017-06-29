<!--- ------------------------------------------------------------------------- ----
	
	File:		_initial.cfm
	Author:		Marcus Melo
	Date:		June 22, 2011
	Desc:		Placement Mgmt - Summary Information
				
	Updates:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    
    <!--- Used to save files to the internal virtual folder --->
    <cfparam name="URL.approved" default="0" />
    
    <!--- Host --->
    <cfparam name="FORM.hostIDSuggest" default="" />
    <cfparam name="FORM.hostID" default="0" />
    <cfparam name="FORM.changePlacementReasonID" default="" />
    <cfparam name="FORM.changePlacementExplanation" default="" />
    <cfparam name="FORM.isWelcomeFamily" default="" />
    <cfparam name="FORM.isRelocation" default="" />
    <cfparam name="FORM.dateRelocated" default="" />
    <cfparam name="FORM.dateSetHostPermanent" default="#DateFormat(now(), 'mm/dd/yyyy')#" />
    <!--- School --->
    <cfparam name="FORM.schoolID" default="0" />  
    <cfparam name="FORM.schoolIDReason" default="" />
    <!--- Placing Representative --->
    <cfparam name="FORM.placeRepID" default="#CLIENT.userID#" />
    <cfparam name="FORM.placeRepIDReason" default="" />
    <!--- Area Representative --->
    <cfparam name="FORM.areaRepID" default="#CLIENT.userID#" />    
    <cfparam name="FORM.areaRepIDReason" default="" />
    <!--- Second Visit Representative --->
    <cfparam name="FORM.secondVisitRepID" default="0" />  
    <cfparam name="FORM.secondVisitRepIDReason" default="" />
    <!--- Double Placement --->
    <cfparam name="FORM.doublePlace" default="0" /> 
    <cfparam name="FORM.doublePlaceReason" default="" /> 
    <!--- Rejecting / Unplacing / Resubmitting --->
    <cfparam name="FORM.reason" default="" /> 


    <cfparam name="URL.pre_hostID" default="" /> 
    <cfparam name="URL.pre_areaRepID" default="" /> 
    <cfparam name="URL.pre_schoolID" default="" /> 
    
    <cfif CLIENT.companyID eq 15>
    	<cfset host_supervising_distance_max = 250>
        <Cfset alertDistance = 275>
		<cfset attentionDistance = 250>
    <cfelse>
    	<cfset host_supervising_distance_max = 120>
        <Cfset alertDistance = 125>
		<cfset attentionDistance  = 120>
    </cfif>

	<!--- check if the double placement form was uploaded in the student's app --->
	<cfdirectory directory="#AppPath.onlineApp.inserts#page23" name="doublePlacementFile" filter="#qGetStudentInfo.studentID#.*">

    <cfscript>
		// Set default value
		vIsPlacementCompliant = '';
		
		vIsDoublePlacementLanguageCompliant = '';
		
		// Check if placement is compliant - Office users | Display message to managers
		//Compliance not required for CANADA
		if (CLIENT.companyID NEQ 13){
		
		if ( listFind("1,2,3,4", CLIENT.userType) ) {

			// Check if Host Family is in compliance
			vIsPlacementCompliant = APPLICATION.CFC.CBC.checkHostFamilyCompliance(
				hostID=qGetPlacementHistoryByID.hostID, 
				studentID=qGetStudentInfo.studentID,
				doublePlacementID=qGetPlacementHistoryByID.doublePlacementID,
				secondVisitRepID=qGetPlacementHistoryByID.secondVisitRepID,
				schoolAcceptanceDate=qGetPlacementHistoryByID.doc_school_accept_date,
				crossDataUserCBC=1,
				representativeDistanceInMiles=qGetPlacementHistoryByID.hfSupervisingDistance,
				maxDistance = host_supervising_distance_max
			);
			
			// Check if compliance_review is checked
			if (NOT IsDate(qGetPlacementHistoryByID.compliance_review)) {
				vIsPlacementCompliant &= "<p style='color:red;'>Compliance Review must be checked off in paperwork before you can approve this placement.</p>";
			}
		
		};
		// End Bypass for CANADA
		
			// Check if this is a double placement and both the student and the host app have approval for it
			if (VAL(qGetPlacementHistoryByID.doublePlacementID)) {
				vHostAcceptsDoublePlacement = 0;
				if (qGetHostInfo.acceptDoublePlacement) {
					vHostAcceptsDoublePlacement = 1;	
				} else {
					vHostAcceptsDoublePlacement = 1;
					for ( i=1; i LTE qGetDoublePlacementPaperworkHistory.recordCount; i=i+1 ) {
						if (qGetDoublePlacementPaperworkHistory.isdoubleplacementpaperworkrequired[i] EQ 1) {
							if (qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateCompliance[i] EQ "") {
								vHostAcceptsDoublePlacement = 0;
							}
						}
					}
				}
				if (NOT vHostAcceptsDoublePlacement) {
					vIsPlacementCompliant &= "<p style='color:red;'>Missing host family approval for double placement.</p>";
				}
				
				vStudentAcceptsDoublePlacement = 0;
				if (doublePlacementFile.recordcount) {
					vStudentAcceptsDoublePlacement = 1;	
				} else {
					vStudentAcceptsDoublePlacement = 1;
					for ( i=1; i LTE qGetDoublePlacementPaperworkHistory.recordCount; i=i+1 ) {
						if (qGetDoublePlacementPaperworkHistory.isdoubleplacementpaperworkrequired[i] EQ 1) {
							if (qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateCompliance[i] EQ "" OR qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateCompliance[i] EQ "") {
								vStudentAcceptsDoublePlacement = 0;
							}
						}
					}
				}
				if (NOT vStudentAcceptsDoublePlacement) {
					vIsPlacementCompliant &= "<p style='color:red;'>Missing student/natural family approval for double placement.</p>";
				}
			}
			
		}
		
		// Check if Double Placement is compliant - Office users
		if ( APPLICATION.CFC.USER.isOfficeUser() AND VAL(qGetPlacementHistoryByID.doublePlacementID) ) {
			vIsDoublePlacementLanguageCompliant = APPLICATION.CFC.STUDENT.checkDoublePlacementCompliant(studentID=qGetStudentInfo.studentID,doublePlacementID=qGetPlacementHistoryByID.doublePlacementID);	
		}

		// Get Training Options
		qGetRelocationReason = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='changePlacementReason');
		
		// Get School Information
		qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getSchoolAndDatesInfo(schoolID=qGetPlacementHistoryByID.schoolID, seasonID=qGetProgramInfo.seasonID);
		
		// Get Host eligibility
		vHostEligibility = APPLICATION.CFC.HOST.getHostEligibility(hostID=qGetPlacementHistoryByID.hostID);
		
		// FORM Submitted - Update Placement Information
		if ( listLen(FORM.subAction) GT 1 ) {
			
			// Update hostID
			if ( ListFindNoCase(FORM.subAction, "updatehostID") ) {
				
				// Data Validation
				if ( NOT VAL(FORM.hostID) ) {
					SESSION.formErrors.Add("You must select a host family, if you do not see it on the list, please close this window and add a host family");
					// It is possible the hostID did not copy over, erase Host Family Suggest
					FORM.hostIDSuggest = "";
				}			
	
				if ( NOT LEN(FORM.isWelcomeFamily) ) {
					SESSION.formErrors.Add("You must answer whether is a welcome family or not");
				}			
	
				if ( NOT LEN(FORM.isRelocation) ) {
					SESSION.formErrors.Add("You must answer whether is a relocation or not");
				}			
				
				if ( VAL(FORM.isRelocation) AND NOT isDate(FORM.dateRelocated)  ) {
					SESSION.formErrors.Add("Relocation date is required, please enter a date");
				}

				if ( NOT VAL(FORM.changePlacementReasonID) ) {
					SESSION.formErrors.Add("You must select a reason for changing host family");
				}	
				
				if ( ListFind("1,2,3,8,9,10", FORM.changePlacementReasonID) AND NOT LEN(FORM.changePlacementExplanation) ) {
				
					switch(FORM.changePlacementReasonID) {
					
						case 1: {
							SESSION.formErrors.Add("You must list date reported to Department");
							break;
						}
						
						case 2: {
							SESSION.formErrors.Add("You must explain behavior");
							break;
						}
					
						case 3: {
							SESSION.formErrors.Add("You must explain why student changed schools");
							break;
						}
						
						case 8: {
							SESSION.formErrors.Add("You must explain circumstances");
							break;
						}

						case 9: {
							SESSION.formErrors.Add("You must explain incompability");
							break;
						}

						case 10: {
							SESSION.formErrors.Add("Other requires a sufficient narrative description");
							break;
						}
					
					} // switch
					
				} // if
			
			}
			
			// Update updateSchoolID
			if ( ListFindNoCase(FORM.subAction, "updateSchoolID") ) {
			
				if ( NOT VAL(FORM.schoolID) ) {
					SESSION.formErrors.Add("You must select a school from the list");
				}			

				if ( NOT LEN(FORM.schoolIDReason) ) {
					SESSION.formErrors.Add("You must enter a reason for changing school");
				}			
			
			}
			
			// Update PlaceRepID
			if ( ListFindNoCase(FORM.subAction, "updatePlaceRepID") ) {
	
				if ( NOT VAL(FORM.placeRepID) ) {
					SESSION.formErrors.Add("You must select a placing representative from the list");
				}		

				if ( NOT LEN(FORM.placeRepIDReason) ) {
					SESSION.formErrors.Add("You must enter a reason for changing placing representative");
				}	
				
				if ( VAL(FORM.secondVisitRepID) AND VAL(FORM.placeRepID) AND FORM.secondVisitRepID EQ FORM.placeRepID ) { 
					SESSION.formErrors.Add("Placing Representative must be different than Second Visit Representative");
				}	
			
			} 
			
			// Update areaRepID
			if ( ListFindNoCase(FORM.subAction, "updateAreaRepID") ) {
			
				if ( NOT VAL(FORM.areaRepID) ) { 
					SESSION.formErrors.Add("You must select a supervising representative from the list");
				}		

				if ( NOT LEN(FORM.areaRepIDReason) ) {
					SESSION.formErrors.Add("You must enter a reason for changing supervising representative");
				}			
	
			} 
			
			// Update secondVisitRepID
			if ( ListFindNoCase(FORM.subAction, "updateSecondVisitRepID") ) {
			
				if ( NOT VAL(FORM.secondVisitRepID) ) { 
					SESSION.formErrors.Add("You must select a second represetative visit from the list");
				}	

				if ( NOT LEN(FORM.secondVisitRepIDReason) ) {
					SESSION.formErrors.Add("You must enter a reason for changing second representative visit");
				}	
				if (CLIENT.companyID neq 13){
					if ( VAL(FORM.secondVisitRepID) AND VAL(FORM.placeRepID) AND FORM.secondVisitRepID EQ FORM.placeRepID ) { 
						SESSION.formErrors.Add("Second Visit Representative must be different than Placing Representative");
					}	
				}
				/* Commented out as per Brian Hause request - 12/11/2012
				if ( CLIENT.companyID NEQ 10 AND VAL(FORM.secondVisitRepID) AND VAL(FORM.areaRepID) AND FORM.secondVisitRepID EQ FORM.areaRepID ) { 
					SESSION.formErrors.Add("Second Visit Representative must be different than Supervising Representative");
				}	
				*/

			}
		
			// Update Double Placement
			if ( ListFindNoCase(FORM.subAction, "updateDoublePlace") ) {
				
				if ( VAL(qGetPlacementHistoryByID.doublePlacementID) AND NOT LEN(FORM.doublePlaceReason) ) {
					SESSION.formErrors.Add("You must enter a reason for changing double placement");
				}	

				// Check if double placement is not assigned to a different student
				qCheckDoublePlacement = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(FORM.doublePlace));

				if ( VAL(FORM.doublePlace) AND VAL(qCheckDoublePlacement.doublePlace) AND qCheckDoublePlacement.doublePlace NEQ FORM.doublePlace AND qCheckDoublePlacement.doublePlace NEQ FORM.studentID ) {
					SESSION.formErrors.Add("Student #qCheckDoublePlacement.firstName# #qCheckDoublePlacement.familyLastName# ###qCheckDoublePlacement.studentID# is already assigned as double placement with student ###qCheckDoublePlacement.doublePlace#");
				}
				
				// Check if double placement is not assigned to a different host family
				if ( VAL(FORM.doublePlace) AND qCheckDoublePlacement.hostID NEQ FORM.hostID ) {
					SESSION.formErrors.Add("Student #qCheckDoublePlacement.firstName# #qCheckDoublePlacement.familyLastName# ###qCheckDoublePlacement.studentID# is not assigned to the same host family");
				}
				
			} 
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Update Placement Information
				APPLICATION.CFC.STUDENT.updatePlacementInformation(
					studentID = FORM.studentID,
					hostID = FORM.hostID,
					isWelcomeFamily = FORM.isWelcomeFamily,
					isRelocation = FORM.isRelocation,
					dateRelocated = FORM.dateRelocated,
					changePlacementReasonID = FORM.changePlacementReasonID,
					changePlacementExplanation = FORM.changePlacementExplanation,
					schoolID = FORM.schoolID,
					schoolIDReason = FORM.schoolIDReason,
					placeRepID = FORM.placeRepID,
					placeRepIDReason = FORM.placeRepIDReason,
					areaRepID = FORM.areaRepID,
					areaRepIDReason = FORM.areaRepIDReason,
					secondVisitRepID = FORM.secondVisitRepID,
					secondVisitRepIDReason = FORM.secondVisitRepIDReason,
					doublePlace = FORM.doublePlace,
					doublePlaceReason = FORM.doublePlaceReason,
					changedBy = CLIENT.userID,
					userType = CLIENT.userType,
					placementStatus = vPlacementStatus
				);
				
				// Updated double placement
				if (VAL(qGetPlacementHistoryByID.doublePlacementID)) {
					qGetDoublePlacementPaperworkHistory = APPLICATION.CFC.STUDENT.getDoublePlacementPaperworkHistory(historyID=qGetPlacementHistoryByID.historyID, studentID=qGetStudentInfo.studentID);
					if (qGetHostInfo.acceptDoublePlacement AND doublePlacementFile.recordcount) {
						APPLICATION.CFC.STUDENT.updateDoublePlacementTrackingHistory(
							ID = qGetDoublePlacementPaperworkHistory.ID,
							isDoublePlacementPaperworkRequired = 1,
							doublePlacementParentsDateSigned = NOW(),
							doublePlacementParentsDateCompliance = NOW(),
							doublePlacementStudentDateSigned = NOW(),
							doublePlacementStudentDateCompliance = NOW(),
							doublePlacementHostFamilyDateSigned = NOW(),
							doublePlacementHostFamilyDateCompliance = NOW()
						);
					}
				}
			
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
			
			}

		// FORM SUBMITTED - NEW Placement Information
		} else if ( FORM.subAction EQ 'placementInformation' ) {
			
			// Data Validation
			if ( NOT VAL(FORM.hostID) ) {
				SESSION.formErrors.Add("You must select a host family, if you do not see it on the list, please close this window and add a host family");
				// It is possible the hostID did not copy over, erase Host Family Suggest
				FORM.hostIDSuggest = "";
			}					

			if ( NOT LEN(FORM.isWelcomeFamily) ) {
				SESSION.formErrors.Add("You must answer whether is a welcome family or not");
			}			
			
			if ( NOT VAL(FORM.schoolID) ) {
				SESSION.formErrors.Add("You must select a school from the list");
			}			

			if (CLIENT.companyid NEQ 13 and  ( NOT VAL(FORM.placeRepID)) ) {
				SESSION.formErrors.Add("You must select a placing representative from the list");
			}			

			if (CLIENT.companyid NEQ 13 and  ( NOT VAL(FORM.areaRepID) ) ) { 
				SESSION.formErrors.Add("You must select a supervising representative from the list");
			}	
			
			if ( VAL(FORM.secondVisitRepID) AND VAL(FORM.placeRepID) AND FORM.secondVisitRepID EQ FORM.placeRepID ) { 
				SESSION.formErrors.Add("Second Visit Representative must be different than Placing Representative");
			}	
			
			/* Commented out as per Brian Hause request - 12/11/2012
			if ( CLIENT.companyID NEQ 10 AND VAL(FORM.secondVisitRepID) AND VAL(FORM.areaRepID) AND FORM.secondVisitRepID EQ FORM.areaRepID ) { 
				SESSION.formErrors.Add("Second Visit Representative must be different than Supervising Representative");
			}
			*/
			
			if ( VAL(FORM.hostID) AND VAL(FORM.doublePlace) AND qGetPlacementHistoryByID.doublePlacementID NEQ FORM.doublePlace ) { 
			
				// Check if double placement is not assigned to a different student
				qCheckDoublePlacement = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(FORM.doublePlace));
				
				if ( VAL(qCheckDoublePlacement.doublePlace) AND qCheckDoublePlacement.doublePlace NEQ FORM.studentID ) {
					SESSION.formErrors.Add("Student #qCheckDoublePlacement.firstName# #qCheckDoublePlacement.familyLastName# ###qCheckDoublePlacement.studentID# is already assigned as double placement with student ###qCheckDoublePlacement.doublePlace#");
				}

				// Check if double placement is not assigned to a different host family
				if ( VAL(FORM.doublePlace) AND qCheckDoublePlacement.hostID NEQ FORM.hostID ) {
					SESSION.formErrors.Add("Student #qCheckDoublePlacement.firstName# #qCheckDoublePlacement.familyLastName# ###qCheckDoublePlacement.studentID# is not assigned to the same host family");
				}
				
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Update Placement Information
				APPLICATION.CFC.STUDENT.updatePlacementInformation(
					studentID = FORM.studentID,
					hostID = FORM.hostID,
					isWelcomeFamily = FORM.isWelcomeFamily,
					schoolID = FORM.schoolID,
					placeRepID = FORM.placeRepID,
					areaRepID = FORM.areaRepID,
					secondVisitRepID = FORM.secondVisitRepID,
					doublePlace = FORM.doublePlace,
					changedBy = CLIENT.userID,
					userType = CLIENT.userType,
					placementStatus = vPlacementStatus
				);

				//Remove Hold Status
				APPLICATION.CFC.STUDENT.addHoldStatus(
					hold_status_id: 1,
          student_id: FORM.studentID,
          area_rep_id: 0,
          host_family_id: 0,
          school_id: 0,
          create_by: CLIENT.userID
				);
			
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
			
			}
		
		// APPROVE PLACEMENT
		} else if ( FORM.subAction EQ 'approve' ) {
			
			// Data Validation
			if ( APPLICATION.CFC.USER.isOfficeUser() AND VAL(qGetPlacementHistoryByID.isRelocation) AND NOT IsDate(FORM.dateRelocated) ) {
				SESSION.formErrors.Add("You must enter what date the student relocated to this new family");
			}			
			
			if ( APPLICATION.CFC.USER.isOfficeUser() AND VAL(qGetPlacementHistoryByID.isRelocation) AND isDate(FORM.dateRelocated) AND FORM.dateRelocated LT DateFormat(now(), 'mm/dd/yyyy') ) {
				SESSION.formErrors.Add("Relocation date is out of compliance, please enter a new date");
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
	
				// Approve Placement - Insert into history
				APPLICATION.CFC.STUDENT.approvePlacement(
					studentID = FORM.studentID,								 
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					dateRelocated=FORM.dateRelocated
				 );
			if (val(CLIENT.userType) lte 4) {
				APPLICATION.CFC.UDF.createAutoFiles(studentID=FORM.studentID,hostID=FORM.hostID,uniqueID=qGetStudentInfo.uniqueid,documentType=3, category=2,fileDescription='PIS');
			};			
				
				// Set Page Message
				SESSION.pageMessages.Add("Placement has been approved.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
			
			}
			
		// SET FAMILY AS PERMANENT
		} else if ( FORM.subAction EQ 'setFamilyAsPermanent' ) {

			// Data Validation
			if ( NOT IsDate(FORM.dateSetHostPermanent) ) {
				SESSION.formErrors.Add("You must enter what date did this host family become permanent");
			}			

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Set Family As Permanent - Insert into history
				APPLICATION.CFC.STUDENT.setFamilyAsPermanent(
					studentID = FORM.studentID,								 
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					dateSetHostPermanent=FORM.dateSetHostPermanent
				 );
	
				// Set Page Message
				SESSION.pageMessages.Add("Host Family has been set as permanent.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
			}
		
		// RESUBMIT PLACEMENT
		} else if ( FORM.subAction EQ 'resubmit' ) {
			
			if ( NOT LEN(FORM.reason) ) { 
				// Get all the missing items in a list
				SESSION.formErrors.Add("You must enter a comment for resubmitting this placement");
			}	

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Resubmit Placement - Insert into history
				APPLICATION.CFC.STUDENT.resubmitPlacement(
					studentID = FORM.studentID,								 
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					reason = FORM.reason,
					placementStatus = 'Resubmitted'
				 );

				// Set Page Message
				SESSION.pageMessages.Add("Placement has been resubmitted.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
			
			}
			
		// REJECT PLACEMENT
		} else if ( FORM.subAction EQ 'reject' ) {

			if ( NOT LEN(FORM.reason) ) { 
				// Get all the missing items in a list
				SESSION.formErrors.Add("You must enter a reason for rejecting this placement");
			}	

			if ( LEN(FORM.reason) AND NOT LEN(FORM.reason) ) { 
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please provide details for rejecting this placement");
			}	

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Reject Placement - Insert into history
				APPLICATION.CFC.STUDENT.rejectPlacement(
					studentID = FORM.studentID,								 
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					regionID = qGetStudentInfo.regionAssigned,
					placeRepID = qGetPlacementHistoryByID.placeRepID,
					reason = FORM.reason
				 );

				// Set Page Message
				SESSION.pageMessages.Add("Placement has been rejected. An email has been sent to the placing representative and regional manager to let them know.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		

			}
		
		// UNPLACE STUDENT
		} else if ( FORM.subAction EQ 'unplace' ) {
			
			if ( NOT LEN(FORM.reason) ) { 
				// Get all the missing items in a list
				SESSION.formErrors.Add("You must enter a reason for unplacing this student");
			}	

			if ( LEN(FORM.reason) AND NOT LEN(FORM.reason) ) { 
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please provide details for unplacing this student");
			}	

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Unplace Student - Insert into history
				APPLICATION.CFC.STUDENT.unplaceStudent(
					studentID = FORM.studentID,								 
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					reason = FORM.reason
				 );
				
				// Set Page Message
				SESSION.pageMessages.Add("Student has been unplaced.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		

			}

		// RECALCULATE DISTANCE
		} else if ( FORM.subAction EQ 'recalculateDistance' ) {

			// Get Host Family Address
			vHostAddress = APPLICATION.CFC.HOST.getCompleteHostAddress(hostID=qGetPlacementHistoryByID.hostID).completeAddress;

			// Get Supervising Representative Address
			vSupervisingRepAddress = APPLICATION.CFC.USER.getCompleteUserAddress(userID=qGetPlacementHistoryByID.areaRepID).completeAddress;

			// Get Driving Distance From Google
			vGoogleDistance = APPLICATION.CFC.UDF.calculateAddressDistance(origin=vHostAddress,destination=vSupervisingRepAddress);

			// Set to 0 if could not retrieve it successfully
			if ( NOT IsNumeric(vGoogleDistance) ) {
				vGoogleDistance = 0;
				// Set Page Message
				SESSION.formErrors.Add("EXITS could not update the distance from HF to AR, please check if both addresses are correct.");
			} else {
				// Set Page Message
				SESSION.pageMessages.Add("Distance from HF to AR has been updated. New distance is #vGoogleDistance# miles.");
			}
			
			// Update Distance in the database
			APPLICATION.CFC.STUDENT.updateHostSupervisingDistance(
				historyID=qGetPlacementHistoryByID.historyID,
				distanceInMiles=vGoogleDistance
			);

			// Reload page
			location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		

		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetStudentInfo.studentID;
			FORM.uniqueID = qGetStudentInfo.uniqueID;
			FORM.hostID = qGetPlacementHistoryByID.hostID;		
			FORM.isWelcomeFamily = qGetPlacementHistoryByID.isWelcomeFamily;		
			FORM.schoolID = qGetPlacementHistoryByID.schoolID;
			FORM.placeRepID = qGetPlacementHistoryByID.placeRepID;
			FORM.areaRepID = qGetPlacementHistoryByID.areaRepID;
			FORM.secondVisitRepID = qGetPlacementHistoryByID.secondVisitRepID;
			FORM.doublePlace = qGetPlacementHistoryByID.doublePlacementID;		
			
			// Set subAction to placementInformation if any information is missing
			if ( vPlacementStatus EQ 'Incomplete' ) {
				FORM.subAction = 'placementInformation';	
			}
			
		}
		
		// Set number of errors
		FORM.validationErrors = SESSION.formErrors.length();
	</cfscript>
    
</cfsilent>

<script language="javascript">
	// Display warning when page is ready
	$(document).ready(function() {
							   
		// opener.location.reload();
		
		// Display Form Fields
		displayFormFields();
		
		// Display Relocation Date
		displayRelocationDate();
		
		// Display Change Placecement
		displayChangePlacementReason();

		// Prevent double submission - Disable Button after submiting the form
		$('form').submit(function() {
		   $('input[type=image]', this).attr('disabled', 'disabled').css('opacity',0.5);
		});

		<cfif VAL(URL.pre_schoolID)>
			$("#schoolID").val(<cfoutput>#URL.pre_schoolID#</cfoutput>);
		</cfif>

		<cfif VAL(URL.pre_areaRepID)>
			$("#placeRepID").val(<cfoutput>#URL.pre_areaRepID#</cfoutput>);
		</cfif>

		<cfif VAL(URL.pre_hostID)>
			<cfquery name="qGetHF" datasource="#APPLICATION.DSN#">
				SELECT *
				FROM smg_hosts
				WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.pre_hostID)#">
			</cfquery>
			$("#hostIDSuggest").val(<cfoutput>"#qGetHF.familyLastName# - #qGetHF.fatherFirstName# #qGetHF.motherFirstName# (###URL.pre_hostID#)"</cfoutput>);
			$("#hostID").val(<cfoutput>#URL.pre_hostID#</cfoutput>);
		</cfif>

	});


	var displayFormFields = function() { 			
		
		var vDisplaySaveButton = 0;
		
		<cfif FORM.subAction EQ 'placementInformation' OR vPlacementStatus EQ 'unplaced'>
			
			// Display Only if entering placement information
			if ( $("#hostID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divHostID").slideDown();			
			}
			
			if ( $("#schoolID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divSchoolID").slideDown();
			}
	
			if ( $("#placeRepID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divPlaceRepID").slideDown();
			}
	
			if ( $("#areaRepID").val() == 0 || $("#validationErrors").val() != 0 ) { 
				vDisplaySaveButton = 1;
				$("#divAreaRepID").slideDown();
			}

		// Display only if approving a placement
		<cfelseif FORM.subAction EQ	'approve'>
		
			displayHiddenForm('approvePlacementForm','actionButtons');

		// Display only if rejecting a placement
		<cfelseif FORM.subAction EQ 'reject'>
		
			displayHiddenForm('rejectPlacementForm','actionButtons');

		// Display only if resubmitting a placement
		<cfelseif FORM.subAction EQ 'resubmit'>
		
			displayHiddenForm('resubmitPlacementForm','resubmitPlacementButton');

		// Display only if unplacing a student
		<cfelseif FORM.subAction EQ 'unplace'>
		
			displayHiddenForm('unplaceStudentForm');
			
		// Display only if setting family as permanent
		<cfelseif FORM.subAction EQ 'setFamilyAsPermanent'>

			displayHiddenForm('setAsPermanentForm');

		</cfif>	
		
		// Update Host
		<cfif ListFindNoCase(FORM.subAction, "updatehostID")>
			
			if ( $("#hostID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				// Hide Information
				$("#divHostIDInfo").slideUp();
				$("#divHostID").slideDown();			
			}
		
		</cfif>
		
		// Update School
		<cfif ListFindNoCase(FORM.subAction, "updateSchoolID")>		
			
			if ( $("#schoolID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divSchoolIDInfo").slideUp();
				$("#divSchoolID").slideDown();
			}
		
		</cfif>
		
		// Update Place Rep ID
		<cfif ListFindNoCase(FORM.subAction, "updatePlaceRepID")>
			
			if ( $("#placeRepID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divPlaceRepIDInfo").slideUp();
				$("#divPlaceRepID").slideDown();
			}
		
		</cfif>
		
		// Update Area Rep ID
		<cfif ListFindNoCase(FORM.subAction, "updateAreaRepID")>
			
			if ( $("#areaRepID").val() == 0 || $("#validationErrors").val() != 0 ) { 
				vDisplaySaveButton = 1;
				$("#divAreaRepIDInfo").slideUp();
				$("#divAreaRepID").slideDown();
			}
		
		</cfif>
		
		// 2nd Visit Representative - Display if not assigned and not submitting a reject form
		<cfif CLIENT.userType NEQ 7>
		
			<cfif FORM.subAction EQ "placementInformation" OR ListFindNoCase(FORM.subAction, "updateSecondVisitRepID")>
			
				// Display 2nd Representative information
				vDisplaySaveButton = 1;
				$("#divSecondVisitRepIDInfo").slideUp();
				$("#divSecondVisitRepID").slideDown();

			<cfelseif NOT listFind("reject,resubmit,unplace,setFamilyAsPermanent", FORM.subAction)>
			
				// 2nd Visit Representative not assigned
				if ( $("#secondVisitRepID").val() == 0 ) { // && $("#validationErrors").val() != 0 
					vDisplaySaveButton = 1;
					$("#divSecondVisitRepIDInfo").slideUp();
					$("#divSecondVisitRepID").slideDown();
				}
	
			</cfif>
		
		</cfif>
		
		// Double Placement - Display if not assigned and not submitting a reject form
		<cfif FORM.subAction EQ "placementInformation" OR ListFindNoCase(FORM.subAction, "updateDoublePlace")>
			
			// Double Placement Information
			vDisplaySaveButton = 1;
			$("#divDoublePlaceInfo").slideUp();
			$("#divDoublePlace").slideDown();

		<cfelseif NOT listFind("reject,resubmit,unplace,setFamilyAsPermanent", FORM.subAction)>
		
			// Double Placement not assigned
			if ( $("#doublePlace").val() == 0 ) {  // && $("#validationErrors").val() != 0 
				vDisplaySaveButton = 1;
				$("#divDoublePlaceInfo").slideUp();
				$("#divDoublePlace").slideDown();
			}

		</cfif>
		
		// Display Save Button
		if ( vDisplaySaveButton == 1 ) {
			$("#tableDisplaySaveButton").slideDown();
		}
	
	}


	var displayChangePlacementReason = function() {
		
		// These required explanations
		aDetailsRequired = [1, 2, 3, 8, 9, 10];
		
		// Get Change Placement Reason ID Value		
		vGetPlacementReasonID = $("#changePlacementReasonID").val();
		
		// Hide Forms
		$(".changePlacementOptions").fadeOut('fast');
		$("#changePlacementExplanation").val("");
		
		// loop through array
		$.each( aDetailsRequired, function(intIndex, objValue) {

				if ( vGetPlacementReasonID == objValue ) {
					// Display Form
					$("#changePlacementReasonID" + vGetPlacementReasonID).slideDown();
					$("#changePlacementExplanation").slideDown();
				}

			}
			
		);

	}

	
	var displayRelocationDate = function() {
		
		// Get Change Placement Reason ID Value		
		vGetRelocationOption = $("input[name='isRelocation']:checked").val() ;
		
		// Used when relocation is hard coded
		vCheckIsRelocationHiddenField = $("#isRelocation").val();
		
		if ( vGetRelocationOption == 1 || vCheckIsRelocationHiddenField == 1 ) {
			// Show Form
			$(".relocationDateInput").fadeIn('fast');
		} else {
			// Hide Forms
			$(".relocationDateInput").fadeOut('fast');
		}

	}


	var displayHiddenForm = function(formID, buttonID) {
		
		// Hide Button ( Approval/Reject | Resubmit )
		if ( buttonID != '' ) {
			$("#" + buttonID).slideUp();
		}
		
		// Display Form
		$("#" + formID).slideDown();

	}


	var displayUpdateField = function(div, formField) { 
		
		// Get Current SubAction
		var vGetSubAction = $("#subActionPlacement").val();
		
		var vUpdateField = 'update' + formField;
		
		// check if value is not on the list
		if ( ! $.ListFindNoCase(vGetSubAction, vUpdateField) ) {
			// Append Sub Action
			vGetSubAction = vGetSubAction + ',' + vUpdateField;
			
			// Set subAction
			$("#subActionPlacement").val(vGetSubAction);
		}
		
		// Reset field values
		$("#" + formField).val(0);
		
		// Host Fields
		if ( formField == 'hostID' ) {
			
			$("#hostIDSuggest").val("");
			$("#reason").val("");
			
			$("#isRelocation0").attr('checked', false);
			// $("#isRelocation1").attr('checked', false);
			
			$("#isWelcomeFamily0").attr('checked', false);
			$("#isWelcomeFamily1").attr('checked', false);
			
			displayRelocationDate();
		}
		
		// School Field
		if ( formField == 'schoolID' ) {
			$("#schoolIDReason").val("");
		}
		
		// Placing Representative Field
		if ( formField == 'placeRepID' ) {
			$("#placeRepIDReason").val("");
		}

		// Area Representative Field
		if ( formField == 'areaRepID' ) {
			$("#areaRepIDReason").val("");
		}

		// 2nd Visit Representative Field
		if ( formField == 'secondVisitRepID' ) {
			$("#secondVisitRepIDReason").val("");
		}
		
		// Double Placement
		if ( formField == 'doublePlace' ) {
			$("#doublePlaceReason").val("");
		}

		// Hide Information
		$("#" + div + "Info").slideUp();
		
		// Display Information
		$("#" + div).slideDown();	
		
		$("#tableDisplaySaveButton").slideDown();
	
	}
	
	
	// Display Approval Button
	var displayApprovalButton = function(divID) { 
	
		if( $("#" + divID).css("display") == "none" ) {
			
			// Fade In
			$("#" + divID).fadeIn("slow");
			
		} else {
			
			// Fade Out
			$("#" + divID).fadeOut("slow");
			
		}
		
	}	
	
	
	// Modal Confirmation - Approve Placement
	var approvePlacement = function() { 	
	
		$(function() {
			// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
			$( "#dialog:ui-dialog" ).dialog( "destroy" );
		
			$( "#dialog-approvePlacement-confirm" ).dialog({
				resizable: false,
				height:160,
				modal: true,
				buttons: {
					"Approve": function() {
						$( this ).dialog( "close" );
						// Submit Form
						$("#approvePlacementForm").submit();
					},
					Cancel: function() {
						$( this ).dialog( "close" );
					}
				}
			});
		});	
		
	}
</script>

<cfoutput>

	<!--- Modal Dialogs --->
    
	<!--- Approve Placement - Modal Dialog Box --->
    <div id="dialog-approvePlacement-confirm" title="Approve this Placement?" class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Please confirm below you would like to approve this placement.</p> 
    </div> 
    
	<!--- End of Modal Dialogs --->
    
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

    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center" style="padding:10px 0px 10px 0px;">     
    	
        <cfswitch expression="#vPlacementStatus#">
            
            <cfcase value="Rejected">
                <tr>
                    <td align="center" style="color:##3b5998;"> 
                        Placement has been <strong><font color="##CC3300">R E J E C T E D</font></strong> 
                        on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# 
                        at #TimeFormat(qGetStudentInfo.date_host_fam_approved, 'hh:mm tt')# EST
                        see history below
                        <br />
                    </td>
                </tr>
                <tr>
                    <td align="center">
                    	
                        <!--- Resubmit Placement ---->
                        <a href="javascript:displayHiddenForm('resubmitPlacementForm','resubmitPlacementButton');" id="resubmitPlacementButton"><img src="../../pics/resubmit.gif" border="0" /></a>
						
                        <form name="resubmitPlacementForm" id="resubmitPlacementForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone" style="margin-top:10px;">
                            <input type="hidden" name="subAction" id="subAction" value="resubmit" />
                            <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />

                            <table width="680px" border="0" cellpadding="4" cellspacing="0" class="" align="center">                            				
                                <tr class="reportCenterTitle"> 
                                    <th>RESUBMIT PLACEMENT</th>
                                </tr>
                                <tr>
                                    <td class="placementMgmtInfo" align="center">
                                        <label class="reportTitleLeftClean" for="resubmitReason">Please provide details as to why you are resubmitting this placement:</label>
                                        <textarea name="reason" id="resubmitReason" class="xLargeTextArea">#FORM.reason#</textarea>
                                        <input type="image" name="submit" src="../../student_app/pics/submit.gif" alt="Resubmit Placement" style="display:block;" />    
                                    </td>
                                </tr>
                            </table>
                            
                        </form>
                        
                    </td>
                </tr>	
            </cfcase>
        
            <cfcase value="Pending">
                <tr>
                    <td align="center" style="padding-bottom:10px; color:##3b5998;">
                        
                        <cfswitch expression="#qGetStudentInfo.host_fam_approved#">
                        
                            <cfcase value="1,2,3,4">
                                Placement being approved, last approval on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the <strong>HQ</strong>.
                            </cfcase>
                            
                            <cfcase value="5">
                                Placement being approved, last approval on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the <strong>Regional Manager</strong>.
                            </cfcase>
                            
                            <cfcase value="6">
                                Placement being approved, last approval on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the <strong>Regional Advisor</strong>.
                            </cfcase>
                            
                            <cfcase value="7">
                                Placement being approved, last approval on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# by the <strong>Area Representative</strong>.
                            </cfcase>
                            
                            <cfdefaultcase>
                            	Placement is pending approval.
                            </cfdefaultcase>
                            
                        </cfswitch>
                    </td>
                </tr>
            
                <cfif CLIENT.usertype LT qGetStudentInfo.host_fam_Approved>
                    <tr>
                        <td align="center">
                            <a href="javascript:openPopUp('../../reports/placementInfoSheet.cfm?uniqueID=#FORM.uniqueID#&approve', 900, 600);"><img src="../../pics/previewpis.gif" border="0"></a><br />
                        </td>
                    </tr>
                    <tr>
                        <td align="center" style="color:##3b5998; padding-top:10px;">
                            To approve or reject this placement, please review the placement letter clicking on the link above, <br /> then click on "continue" at the bottom of the placement letter.
                        </td>
                    </tr>
                <cfelse>
                    <tr>
                        <td align="center">
                            <a href="javascript:openPopUp('../../reports/placementInfoSheet.cfm?uniqueID=#FORM.uniqueID#', 900, 600);"><img src="../../pics/previewpis.gif" border="0"></a>
                        </td>
                    </tr>
                </cfif>
            
                <tr>
                    <td align="center" style="padding-top:10px;">
                    
						<!--- Check if CBCs are in compliance with DOS  - Display message to office and regional managers --->											
                        <cfif listFind("1,2,3,4,5", CLIENT.userType) AND LEN(vIsPlacementCompliant)>
                            
                            <!--- Display Compliance --->
                            #vIsPlacementCompliant#

							<!--- Display Rejection Button --->
							<cfif CLIENT.usertype LT qGetStudentInfo.host_fam_Approved>
                            
                                <span id="actionButtons">
                                
                                    <a href="javascript:displayHiddenForm('rejectPlacementForm','actionButtons');"><img src="../../pics/reject.gif" border="0" alt="Reject Placement" /></a>
                           
                                </span>
                                
							</cfif>
                            
                        <cfelseif CLIENT.usertype LT qGetStudentInfo.host_fam_Approved>
                            
                            <cfif NOT vHostEligibility>
                                <font color="red">One or more members of this family have been marked ineligible to host</font>
                                <br/>
                          	</cfif>
                            
                            <span id="actionButtons" class="displayNone">
                            
                            	<cfif NOT vHostEligibility>
                                	<img src="../../pics/approve.gif" border="0" alt="Approve Placement" style="opacity:0.4; filter: alpha(opacity=40);" />
                                <cfelse>
									<!--- Relocation date is required for office users --->
                                    <cfif APPLICATION.CFC.USER.isOfficeUser() AND VAL(qGetPlacementHistoryByID.isRelocation)>
                                        <a href="javascript:displayHiddenForm('approvePlacementForm','actionButtons');"><img src="../../pics/approve.gif" border="0" alt="Approve Placement" /></a>    
                                    <cfelse>
                                        <a href="javascript:approvePlacement();"><img src="../../pics/approve.gif" border="0" alt="Approve Placement" /></a>                                
                                    </cfif>
                              	</cfif>

                                &nbsp; &nbsp;
                                <a href="javascript:displayHiddenForm('rejectPlacementForm','actionButtons');"><img src="../../pics/reject.gif" border="0" alt="Reject Placement" /></a>
                       
                       		</span>
                            
                        </cfif>

						<!--- Approve Placement ---->
                        <form name="approvePlacementForm" id="approvePlacementForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone">
                            <input type="hidden" name="subAction" id="subAction" value="approve" />
                            <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
                            
                            <table width="680px" border="0" cellpadding="4" cellspacing="0" class="" align="center">                            				
                                <tr class="reportCenterTitle"> 
                                    <th>APPROVE PLACEMENT</th>
                                </tr>
                                <tr>
                                    <td class="placementMgmtInfo" align="center">
                                        <label class="reportTitleLeftClean" for="dateSetHostPermanent">Please enter a relocation date?</label>
                                        <input type="text" name="dateRelocated" id="dateRelocated" class="datePicker" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#">
                                        <input type="image" name="submit" src="../../student_app/pics/submit.gif" alt="Approve Placement" style="display:block;" />  
                                    </td>
                                </tr>
                            </table>
                            
                        </form>

                        <!--- Reject Placement ---->
                        <form name="rejectPlacementForm" id="rejectPlacementForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone">
                            <input type="hidden" name="subAction" id="subAction" value="reject" />
                            <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />

                            <table width="680px" border="0" cellpadding="4" cellspacing="0" class="" align="center">                            				
                                <tr class="reportCenterTitle"> 
                                    <th>REJECT PLACEMENT</th>
                                </tr>
                                <tr>
                                    <td class="placementMgmtInfo" align="center">
                                        <label class="reportTitleLeftClean" for="rejectReason">Please provide details as to why you are rejecting this placement:</label>
                                        <textarea name="reason" id="rejectReason" class="xLargeTextArea">#FORM.reason#</textarea>
                                        <input type="image" name="submit" src="../../student_app/pics/submit.gif" alt="Reject Placement" style="display:block;" />    
                                    </td>
                                </tr>
                            </table>

                        </form>           

                    </td>
                </tr>
            </cfcase>
        
            <cfcase value="Approved">
                <tr>
                    <td align="center">
                        <a href="" onClick="javascript: win=window.open('../../reports/placementInfoSheet.cfm?uniqueID=#FORM.uniqueid#&approve', 'Settings', 'height=450, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
                            <img src="../../pics/previewpis.gif" border="0">
                        </a>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td align="center">Last status updated on #DateFormat(qGetStudentInfo.date_host_fam_approved, 'mm/dd/yyyy')# at #TimeFormat(qGetStudentInfo.date_host_fam_approved, 'hh:mm tt')#</td>
                </tr>	
            </cfcase>
        
            <cfcase value="unplaced,incomplete">
                <tr>
                    <td align="center">
                         Please use the options below to place #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentID#).
                    </td>
                </tr>
            </cfcase>
            
        </cfswitch>

		<!--- Display Double Placement Language Compliant --->
		<cfif LEN(vIsDoublePlacementLanguageCompliant)>
            <tr>
                <td align="center" style="padding:10px 0px 10px 0px; color:##F00;">
                    #vIsDoublePlacementLanguageCompliant#
                </td>
            </tr>
        </cfif> 

		<!--- Display Distance in Miles --->
        
        	<cfif APPLICATION.CFC.USER.isOfficeUser() AND vPlacementStatus NEQ 'unplaced' AND qGetPlacementHistoryByID.hfSupervisingDistance GTE #host_supervising_distance_max#>
           
			<cfscript>
				vSetColorCode = '';
				
				
				if ( VAL(qGetPlacementHistoryByID.hfSupervisingDistance) GT alertDistance ) {
					vSetColorCode = 'class="alert"';	
				} else if ( VAL(qGetPlacementHistoryByID.hfSupervisingDistance) GTE attentionDistance ) {
					vSetColorCode = 'class="attention"';	
				}
			</cfscript>

            <tr>
                <td align="center" style="padding:10px 0px 10px 0px; color:##3b5998;">
                    <p>Supervising Representative is <span #vSetColorCode#> #qGetPlacementHistoryByID.hfSupervisingDistance# mi </span> away from the Host Family</p>                    
                </td>
            </tr>
            
    	</cfif>
        
		<!--- Recalculate Distance FORM ---->
        <form name="recalculateDistance" id="recalculateDistance" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
            <input type="hidden" name="subAction" id="subAction" value="recalculateDistance" />
            <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" /> 
        </form>
                               
        <tr>
            <td align="center">
                
                <!--- Unplace Student ---->
                <form name="unplaceStudentForm" id="unplaceStudentForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone" style="margin-top:10px; margin-bottom:10px;">
                    <input type="hidden" name="subAction" id="subAction" value="unplace" />
                    <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />

                    <table width="680px" border="0" cellpadding="4" cellspacing="0" class="" align="center">                            				
                        <tr class="reportCenterTitle"> 
                            <th>UNPLACE STUDENT</th>
                        </tr>
                        <tr>
                            <td class="placementMgmtInfo" align="center">
                                <label class="reportTitleLeftClean" for="unplaceReason">Please provide details as to why you are unplacing this student:</label>
                                <textarea name="reason" id="reason" class="xLargeTextArea">#FORM.reason#</textarea>
                                <input type="image" name="submit" src="../../student_app/pics/submit.gif" alt="Unplace Student" style="display:block;" />    
                            </td>
                        </tr>
                    </table>

                </form>    
				
                <!--- Set Family as Permanent --->
                <form name="setAsPermanentForm" id="setAsPermanentForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone"  style="margin-top:10px; margin-bottom:10px;">
                    <input type="hidden" name="subAction" id="subAction" value="setFamilyAsPermanent" />
                    <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />

                    <table width="680px" border="0" cellpadding="4" cellspacing="0" class="" align="center">                            				
                        <tr class="reportCenterTitle"> 
                            <th>SET FAMILY AS PERMANENT</th>
                        </tr>
                        <tr>
                            <td class="placementMgmtInfo" align="center">
                                <label class="reportTitleLeftClean" for="dateSetHostPermanent">What date did this family become permanent?</label>
                                <input type="text" name="dateSetHostPermanent" id="dateSetHostPermanent" class="datePicker" value="#DateFormat(FORM.dateSetHostPermanent, 'mm/dd/yyyy')#">
                                <input type="image" name="submit" src="../../student_app/pics/submit.gif" alt="Set Family As Permanent" style="display:block;" />    
                            </td>
                        </tr>
                    </table>

                </form> 
                   
            </td>
        </tr>    
    </table>                                                

	<!--- Placement Form --->   
    <cfform name="mainForm" id="mainForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
        <!--- Update Information Action --->
		<cfif ListLen(FORM.subAction) GT 1>            
            <input type="hidden" name="subAction" id="subActionPlacement" value="#FORM.subAction#" />
        <!--- Default Action --->
		<cfelse>			
            <input type="hidden" name="subAction" id="subActionPlacement" value="placementInformation" />
        </cfif>
        <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="uniqueID" id="uniqueID" value="#FORM.uniqueID#" />
        <input type="hidden" name="validationErrors" id="validationErrors" value="#FORM.validationErrors#" />

		<!--- Host Family / School Information --->
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
                <td width="50%">
                    <label for="hostID">Host Family <em>*</em> </label>
                    
                    <cfif VAL(qGetPlacementHistoryByID.hostID)>
                        <div class="placementMgmtLinks">
                            [ 
                            <a href="../../index.cfm?curdoc=host_fam_info&hostid=#qGetPlacementHistoryByID.hostID#" target="_blank">More Information</a>  
                            |
                            <a href="javascript:displayUpdateField('divHostID','hostID');">Update</a> 							
                            
                            <!--- Display only if student has not arrived --->
                            <cfif NOT VAL(vHasStudentArrived)>
                            	| 
                                <a href="javascript:displayHiddenForm('unplaceStudentForm');">Unplace Student</a> 
                            </cfif>
                            
							<cfif qGetPlacementHistoryByID.isWelcomeFamily EQ 1 AND ListFind("1,2,3,4,5", CLIENT.userType)>
                                |
                                <a href="javascript:displayHiddenForm('setAsPermanentForm');">Set as Permanent</a> 
                            </cfif>
                            ]                                
                        </div>
                    </cfif>
                </td>
                <td width="50%">
                    <label for="schoolID">School <em>*</em> </label>

                    <cfif VAL(qGetPlacementHistoryByID.schoolID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=school_info&schoolID=#qGetPlacementHistoryByID.schoolID#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divSchoolID','schoolID');">Update</a> 
                            ]                        
                        </div>
					</cfif> 
                </td>
            </tr>
            <tr style="margin:10px;">
                <!--- Host Family ---> 
                <td width="50%" style="padding:0px 0px 10px 10px; vertical-align:top; border-right:1px solid ##edeff4;">
                    
                    <div class="placementMgmtInfo">
                    	
                        <!--- Choose Host --->
						<div id="divHostID" class="displayNone">
                         
                            <cfinput
                            	type="text" 
                                name="hostIDSuggest" 
                                id="hostIDSuggest"
                                value="#FORM.hostIDSuggest#" 
                                autosuggest="cfc:nsmg.extensions.components.host.lookupHostFamily({cfautosuggestvalue},#qGetStudentInfo.regionAssigned#,#qGetStudentInfo.programID#)" 
                                class="xLargeField"
                                maxResultsDisplayed="25"
                                showautosuggestloadingicon="true"
                                tooltip="Type host family name">
                                
							<cfinput type="hidden" name="hostID" id="hostID" value="#FORM.hostID#" bind="cfc:nsmg.extensions.components.host.getHostByName({hostIDSuggest})" />
                            
                            <p class="formNote">Type in host family last name and select it from the list. <br /> Only families assigned to the #qGetRegionAssigned.regionname# region will be listed.</p>

                            <!--- Welcome Family --->
                            <span>Is this a Welcome Family? <em>*</em></span>
                            <input type="radio" name="isWelcomeFamily" id="isWelcomeFamily0" value="0" <cfif FORM.isWelcomeFamily EQ 0> checked="checked" </cfif> >
                            <label for="isWelcomeFamily0">No</label>
                            &nbsp;
                            <input type="radio" name="isWelcomeFamily" id="isWelcomeFamily1" value="1" <cfif FORM.isWelcomeFamily EQ 1> checked="checked" </cfif> >
                            <label for="isWelcomeFamily1">Yes</label>
                        	
                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetPlacementHistoryByID.hostID)>
                            
								<!--- Relocation - Display only if student has arrived --->
                                <span>Is this a Relocation? <em>*</em></span>
                                
                                <cfif VAL(vLockIsRelocationField)>
                                	<input type="hidden" name="isRelocation" id="isRelocation" value="#VAL(FORM.isRelocation)#" />
                                    <label for="isRelocation">#YesNoFormat(VAL(FORM.isRelocation))#</label>  
                                <cfelse>
                                    <input type="radio" name="isRelocation" id="isRelocation0" value="0" <cfif NOT VAL(FORM.isRelocation)> checked="checked" </cfif> onchange="displayRelocationDate();">
                                    <label for="isRelocation0">No</label>                            
                                    &nbsp;                            
                                    <input type="radio" name="isRelocation" id="isRelocation1" value="1" <cfif FORM.isRelocation EQ 1> checked="checked" </cfif> onchange="displayRelocationDate();">
                                    <label for="isRelocation1">Yes</label>
                                </cfif>

								<!--- Relocation Date --->
                                <span class="relocationDateInput" style="display:none">Please enter a relocation date (if known):</span> 
                                <input type="text" name="dateRelocated" id="dateRelocated" class="datePicker relocationDateInput displayNone" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#">
                                
								<!--- Reason --->
                                <span>Please indicate why you are changing the host family: <em>*</em></span> 
                                <select name="changePlacementReasonID" id="changePlacementReasonID" class="xxLargeField" onchange="displayChangePlacementReason();">
                                    <option value="0" <cfif NOT VAL(FORM.changePlacementReasonID)> selected="selected" </cfif> >Select a Reason</option>
                                    <cfloop query="qGetRelocationReason">
                                        <option value="#qGetRelocationReason.fieldID#" <cfif FORM.changePlacementReasonID EQ qGetRelocationReason.fieldID> selected="selected" </cfif> >#qGetRelocationReason.name#</option>
                                    </cfloop>
								</select>
    							
                                <!--- Options 1,2,3,8,9,10 require an explanation --->
								<span id="changePlacementReasonID1" class="changePlacementOptions" style="display:none">List date reported to Department <em>*</em></span>
                                
                                <span id="changePlacementReasonID2" class="changePlacementOptions" style="display:none">Explain behavior <em>*</em></span>
                                
                                <span id="changePlacementReasonID3" class="changePlacementOptions" style="display:none">Explain why student changed schools <em>*</em></span>
                                
                                <span id="changePlacementReasonID8" class="changePlacementOptions" style="display:none">Explain circumstances <em>*</em></span>
                                
                                <span id="changePlacementReasonID9" class="changePlacementOptions" style="display:none">Explain incompability <em>*</em></span>
                                
                                <span id="changePlacementReasonID10" class="changePlacementOptions" style="display:none">Explain <em>*</em></span>
                                
                                <textarea name="changePlacementExplanation" id="changePlacementExplanation" class="xLargeTextArea changePlacementOptions displayNone">#FORM.changePlacementExplanation#</textarea>
                                                                
                        	</cfif>
                                                    
                        </div>
                        
                        <!--- Display Host Info --->
                        <div id="divHostIDInfo">
                        
							<!--- HF Deleted / Not Found  --->
                            <cfif VAL(qGetPlacementHistoryByID.hostID) AND NOT VAL(qGetHostInfo.recordCount)>
                            
                                <font color="##CC3300">Host Family (###qGetPlacementHistoryByID.hostID#) was not found in the system.</font>	
                             
                            <!--- HF Information --->   
                            <cfelseif VAL(qGetPlacementHistoryByID.hostID)>
                                
                                <cfif qGetPlacementHistoryByID.isWelcomeFamily EQ 1>
                                    *** This is a Welcome Family ***<br />
                                </cfif>	                       
                                
                                <cfif vTotalFamilyMembers EQ 1 AND qGetProgramInfo.seasonID GT 8>
                                    <font color="##CC0000">*** Single Person Placement***</font><br />
                                </cfif>
                                
                                #APPLICATION.CFC.HOST.displayHostFamilyName(
                                    hostID=qGetHostInfo.hostid,
                                    fatherFirstName=qGetHostInfo.fatherFirstName,
                                    fatherLastName=qGetHostInfo.fatherLastName,
                                    motherFirstName=qGetHostInfo.motherFirstName,
                                    motherLastName=qGetHostInfo.motherLastName,
                                    familyLastName=qGetHostInfo.familyLastName 
                                )# <br />  
                                       
                                #qGetHostInfo.city#, #qGetHostInfo.State# #qGetHostInfo.zip# 
                            </cfif>	
                		
                        </div>
                        
                    </div>
                
                </td>
                
                <!--- School ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top;">
                    
                    <div class="placementMgmtInfo">
                    
                        <!--- Choose School --->
                        <div id="divSchoolID" class="displayNone">
                        
                            <select name="schoolID" id="schoolID" class="xLargeField">
                                <option value="0">Select a School</option>
                                <cfloop query="qGetAvailableSchools">
                                    <option value="#qGetAvailableSchools.schoolID#" <cfif FORM.schoolID EQ qGetAvailableSchools.schoolID> selected="selected" </cfif> >#qGetAvailableSchools.schoolName#, #qGetAvailableSchools.city# #qGetAvailableSchools.state#</option>                            
                                </cfloop>
                            </select>
                            <p class="formNote">List of schools assigned to the #qGetRegionAssigned.regionname# region</p>

                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetPlacementHistoryByID.schoolID)>
								
                                <span>Please indicate why you are changing the school: <em>*</em></span>
                                <textarea name="schoolIDReason" id="schoolIDReason" class="largeTextArea">#FORM.schoolIDReason#</textarea>

                            </cfif>
                        
                        </div>
                        
                        <!--- Display School Info --->
                        <div id="divSchoolIDInfo">
                        
							<!--- School Deleted / Not Found --->    
                            <cfif VAL(qGetPlacementHistoryByID.schoolID) AND NOT VAL(qGetSchoolInfo.recordCount)>
                            
                                <font color="##CC3300">School (###qGetSchoolInfo.schoolID#) was not found in the system.</font>
                            
                            <!--- School Information --->       
                            <cfelseif VAL(qGetPlacementHistoryByID.schoolID)>
        
                                #qGetSchoolInfo.schoolname# (###qGetSchoolInfo.schoolID#) <br />
                                #qGetSchoolInfo.city#, #qGetSchoolInfo.state# #qGetSchoolInfo.zip# <br /> <br />
                                
                                1<sup>st</sup> semester begins: <cfif IsDate(qGetSchoolInfo.year_begins)> #DateFormat(qGetSchoolInfo.year_begins, 'mm/dd/yy')# <cfelse> n/a </cfif> 
                                &nbsp; | &nbsp;
                                ends: <cfif IsDate(qGetSchoolInfo.semester_ends)> #DateFormat(qGetSchoolInfo.semester_ends, 'mm/dd/yy')# <cfelse> n/a </cfif> <br /> 
                                
                                2<sup>nd</sup> semester begins: <cfif IsDate(qGetSchoolInfo.semester_begins)> #DateFormat(qGetSchoolInfo.semester_begins, 'mm/dd/yy')# <cfelse> n/a </cfif>
                                &nbsp; | &nbsp;
                                ends: <cfif IsDate(qGetSchoolInfo.year_ends)> #DateFormat(qGetSchoolInfo.year_ends, 'mm/dd/yy')# <cfelse> n/a </cfif>
                            </cfif>

						</div>
                    
                    </div>
                    
                </td>            
            </tr>            
        </table>
        
        
        <!--- Placing Representative | Supervising Representative --->      
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
                <td width="50%">
                    <label for="placeRepID">Placing Representative <cfif client.companyid neq 13><em>*</em></cfif> </label>
                    
                    <cfif VAL(qGetPlacementHistoryByID.placeRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistoryByID.placeRepID#" target="_blank">More Information</a> 
                            <!--- Only the facilitator can update the placing representative after the PIS is sent --->
                            <cfif VAL(qGetRegionAssigned.regionFacilitator) EQ CLIENT.userID OR NOT LEN(qGetPlacementHistoryByID.datePISEmailed) OR CLIENT.userID EQ 8743>
                            	|
                                <a href="javascript:displayUpdateField('divPlaceRepID','placeRepID');">Update</a> 
                            </cfif>
                            ] 
                        </div>
                    </cfif>
                </td>
                <td width="50%" style="padding-left:10px;">
                    <label for="areaRepID">Supervising Representative <cfif client.companyid neq 13><em>*</em></cfif> </label>
                    
                    <cfif VAL(qGetPlacementHistoryByID.areaRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistoryByID.areaRepID#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divAreaRepID','areaRepID');">Update</a> ] 
                        </div>
					</cfif>    
                </td>
            </tr>
            <tr>
                <!--- Placing Representative ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top; border-right:1px solid ##edeff4;">
                
                    <div class="placementMgmtInfo">
                
                        <!--- Choose Placing Representative --->
                        <div id="divPlaceRepID" class="displayNone">
                    
                            <select name="placeRepID" id="placeRepID" class="xLargeField">
                                <option value="0">Select a Placing Representative</option>
                                <cfloop query="qGetAvailableReps">
                                    <option value="#qGetAvailableReps.userid#" <cfif qGetAvailableReps.userID EQ FORM.placeRepID> selected="selected" </cfif> >
                                        #qGetAvailableReps.firstname# #qGetAvailableReps.lastname# (###qGetAvailableReps.userid#)
                                    </option>
                                </cfloop>
                            </select>

                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetPlacementHistoryByID.placeRepID)>
								
                                <span>Please indicate why you are changing the placing representative: <em>*</em></span>
                                <textarea name="placeRepIDReason" id="placeRepIDReason" class="largeTextArea">#FORM.placeRepIDReason#</textarea>

                            </cfif>
                        
                        </div>
                        
                        <!--- Display Placing Representative Info --->
                        <div id="divPlaceRepIDInfo">
                        
							<!--- Placing Representative Deleted / Not Found  --->
                            <cfif VAL(qGetPlacementHistoryByID.placeRepID) AND NOT VAL(qGetPlaceRepInfo.recordCount)>
                                
                                <font color="##CC3300">Placing Representative (###qGetPlacementHistoryByID.placeRepID#) was not found in the system.</font>
                                
                            <!--- Placing Representative Information ---> 
                            <cfelseif VAL(qGetPlacementHistoryByID.placeRepID)>
                            
                                #qGetPlaceRepInfo.firstName# #qGetPlaceRepInfo.lastName# (###qGetPlaceRepInfo.userID#) <br />
                                #qGetPlaceRepInfo.city#, #qGetPlaceRepInfo.state# #qGetPlaceRepInfo.zip#
        
                            </cfif>

						</div>
                
                    </div>
                    
                </td>
                
                <!--- Supervising Representative ---> 
                <td width="50%" style="padding:0px 0px 10px 10px; vertical-align:top;">
                    
                    <div class="placementMgmtInfo">
                    
                        <!--- Choose Supervising Representative --->
                        <div id="divAreaRepID" class="displayNone">
    
                            <select name="areaRepID" id="areaRepID" class="xLargeField">
                                <option value="0">Select a Supervising Representative</option>
                                <cfloop query="qGetAvailableReps">
                                    <option value="#qGetAvailableReps.userid#" <cfif qGetAvailableReps.userID EQ FORM.areaRepID> selected="selected" </cfif> >
                                        #qGetAvailableReps.firstname# #qGetAvailableReps.lastname# (###qGetAvailableReps.userid#)
                                    </option>
                                </cfloop>
                            </select>
							
                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetPlacementHistoryByID.areaRepID)>
								
                                <span>Please indicate why you are changing the supervising representative: <em>*</em></span>
                                <textarea name="areaRepIDReason" id="areaRepIDReason" class="largeTextArea">#FORM.areaRepIDReason#</textarea>                                

                            </cfif>
                        
                        </div>

                        <!--- Display Supervising Representative Info --->
                        <div id="divAreaRepIDInfo">
                        
							<!--- Supervising Representative Deleted / Not Found  --->
                            <cfif VAL(qGetPlacementHistoryByID.areaRepID) AND NOT VAL(qGetAreaRepInfo.recordCount)>
                                
                                <font color="##CC3300">Supervising Representative (###qGetPlacementHistoryByID.areaRepID#) was not found in the system.</font>
                                
                            <!--- Supervising Representative Information ---> 
                            <cfelseif VAL(qGetPlacementHistoryByID.areaRepID)>
                            
                                #qGetAreaRepInfo.firstName# #qGetAreaRepInfo.lastName# (###qGetAreaRepInfo.userID#) <br />
                                #qGetAreaRepInfo.city#, #qGetAreaRepInfo.state# #qGetAreaRepInfo.zip# <br />
								Distance to Host Family:
								<cfif VAL(qGetPlacementHistoryByID.hfSupervisingDistance)>
									#qGetPlacementHistoryByID.hfSupervisingDistance# miles
                                <cfelse>
                                	n/a
								</cfif>
                                
                                <div class="placementMgmtLinks">
	                                <a href="javascript:$('##recalculateDistance').submit();" title="Click here to recalculate distance from HF to AR">[ Recalculate Distance ]</a>
								</div>
                            </cfif>
						
                        </div>
                                        
                    </div>
                        
                </td>
            </tr>
        </table>                        
    	
    
        <!--- 2nd Representative Visit | Double Placement --->      
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
            <cfif CLIENT.companyid neq 13>
                <td width="50%">
                    <label for="secondVisitRepID">2<sup>nd</sup> Representative Visit</label>
                    
                    <cfif VAL(qGetPlacementHistoryByID.secondVisitRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistoryByID.secondVisitRepID#" target="_blank">More Information</a> 
                            
                            <!--- Do not allow update if there is a report created --->
                            <cfif NOT VAL(qGetSecondVisitReport.recordCount) AND NOT ListFind(CLIENT.userType, "5,6,7")>
                                |
                                <a href="javascript:displayUpdateField('divSecondVisitRepID','secondVisitRepID');">Update</a> 
                            </cfif>
                            ] 
                        </div>
					</cfif>                    
                </td>
             </cfif>
                <td width="50%">
                	<label for="doublePlacementID">Double Placement &nbsp; (Optional)</label>
                    
                    <cfif VAL(qGetPlacementHistoryByID.doublePlacementID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=student_info&studentID=#qGetPlacementHistoryByID.doublePlacementID#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divDoublePlace','doublePlace');">Update</a> ] 
                        </div>
					</cfif>                    
                </td>
            </tr>
            <tr>
                <!--- 2nd Representative Visit ---> 
                <cfif CLIENT.companyid neq 13>
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top; border-right:1px solid ##edeff4;">
                	
                    <div class="placementMgmtInfo">
						
						<!--- Choose 2nd Representative Visit --->
                        <div id="divSecondVisitRepID" class="displayNone">
                            
                            <select name="secondVisitRepID" id="secondVisitRepID" class="xLargeField">
                                <option value="0">Select a 2nd Representative Visit</option>
                                <cfloop query="qGetAvailable2ndVisitReps">
                                    <option value="#qGetAvailable2ndVisitReps.userid#" <cfif qGetAvailable2ndVisitReps.userID EQ FORM.secondVisitRepID> selected="selected" </cfif> >
                                        #qGetAvailable2ndVisitReps.firstname# #qGetAvailable2ndVisitReps.lastname# (###qGetAvailable2ndVisitReps.userid#)
                                    </option>
                                </cfloop>
                            </select>

                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetPlacementHistoryByID.secondVisitRepID)>
                                
                                <span>Please indicate why you are changing the second visit representative: <em>*</em></span>
                                <textarea name="secondVisitRepIDReason" id="secondVisitRepIDReason" class="largeTextArea">#FORM.secondVisitRepIDReason#</textarea>  
                                                              
                            </cfif>
                        
                        </div>
                        
                        <!--- Display 2nd Representative Visit Info --->
                        <div id="divSecondVisitRepIDInfo">
							
							<!--- 2nd Representative Deleted / Not Found  --->
                            <cfif VAL(qGetPlacementHistoryByID.secondVisitRepID) AND NOT VAL(qGetSecondVisitRepInfo.recordCount)>
                                
                                <font color="##CC3300">2<sup>nd</sup> Representative (###qGetPlacementHistoryByID.secondVisitRepID#) was not found in the system.</font>
                                
                            <!--- 2nd Representative Information ---> 
                            <cfelseif VAL(qGetPlacementHistoryByID.secondVisitRepID)>
                            
                                #qGetSecondVisitRepInfo.firstName# #qGetSecondVisitRepInfo.lastName# (###qGetSecondVisitRepInfo.userID#) <br />
                                #qGetSecondVisitRepInfo.city#, #qGetSecondVisitRepInfo.state# #qGetSecondVisitRepInfo.zip#
        					
                            <cfelseif CLIENT.userType EQ 7>
                            	
                                2<sup>nd</sup> Representative will be assigned by your Regional Manager.
                            
                            </cfif>
                            
                            <!--- Do not allow update if there is a report created --->
                            <cfif VAL(qGetSecondVisitReport.recordCount)>
                                <p class="formNote">
                                    A 2<sup>nd</sup> visit report has been created/submitted by this rep. Update has been disabled.
                                </p>
                            </cfif>
                        
                        </div>
                           
                    </div>
                                        
                </td>
                </cfif>
                <!--- Double Placement ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top;">
                    
                    <div class="placementMgmtInfo">
                    
						<!--- Choose Double Placement --->
                        <div id="divDoublePlace" class="displayNone">
                            
                            <select name="doublePlace" id="doublePlace" class="xLargeField">
                                <cfif NOT VAL(qGetPlacementHistoryByID.doublePlacementID)>
                                	<option value="0">Select a Double Placement</option>
                                <cfelse>
                                	<option value="0">Remove Double Placement</option>
								</cfif>
                                <cfloop query="qGetAvailableDoublePlacement">
                                    <option value="#qGetAvailableDoublePlacement.studentID#" <cfif qGetAvailableDoublePlacement.studentID EQ FORM.doublePlace> selected="selected" </cfif> >
                                        #qGetAvailableDoublePlacement.firstname# #qGetAvailableDoublePlacement.familyLastName# (###qGetAvailableDoublePlacement.studentID#)
                                    </option>
                                </cfloop>
                            </select>
                            
                            <p class="formNote">
                            	List of students assigned to the family
							</p>

                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetPlacementHistoryByID.doublePlacementID)>
                                
                                <span>Please indicate why you are changing the double placement: <em>*</em></span>
                                <textarea name="doublePlaceReason" id="doublePlaceReason" class="largeTextArea">#FORM.doublePlaceReason#</textarea>  
                                                              
                            </cfif>
                        
                        </div>
                        
                        <!--- Display Double Placement Info --->
                        <div id="divDoublePlaceInfo">
							
							<!--- Double Placement Deleted / Not Found  --->
                            <cfif VAL(qGetPlacementHistoryByID.doublePlacementID) AND NOT VAL(qGetDoublePlacementInfo.recordCount)>
                                
                                <font color="##CC3300">Double Placement (###qGetPlacementHistoryByID.doublePlacementID#) was not found in the system.</font>
                                
                            <!--- Double Placement Information ---> 
                            <cfelseif VAL(qGetDoublePlacementInfo.recordCount)>
                            
                                #qGetDoublePlacementInfo.firstName# #qGetDoublePlacementInfo.familyLastName# (###qGetDoublePlacementInfo.studentID#) <br />
        					
                            </cfif>
                        
                        </div>
                    
                    </div>
                    
                </td>
            </tr>
            
            <!--- Required Fields --->
            <tr class="reportTitleLeftClean">
            	<td colspan="2">
                	<p class="formRequiredNote">* Required Fields</p>
                </td>
                
			</tr>
        </table> 
        
		<!--- Form Buttons --->  
        <table width="90%" id="tableDisplaySaveButton" border="0" cellpadding="2" cellspacing="0" class="section displayNone" align="center" style="padding:5px;">
            <tr>
                <td align="center">
                	<input type="image" name="submit" id="submit" src="../../student_app/pics/save.gif" border="0" alt="Save" />
					<!---   
					<input name="submit" id="submit" type="image" src="../../student_app/pics/save.gif" border="0" alt="Save" onclick="this.disabled=true;this.form.submit();" />             
					<img id="mainFormImage" class="submitButton" src="../../student_app/pics/save.gif" alt="Click to Submit this Form" onclick="javascript:submitForm('mainForm', this.id);" border="0" />
					--->
                </td>
            </tr>                
        </table>    

	</cfform>
	
</cfoutput>
