<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		June 22, 2011
	Desc:		Index file of the placement management section
				
				#CGI.SCRIPT_NAME#?curdoc=student/placementMgmt/index
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
	<!--- Param local Variables --->
	<cfparam name="URL.action" default="initial">
    <cfparam name="URL.uniqueID" default="" />
    <cfparam name="URL.historyID" default="" />
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0" />
    <cfparam name="FORM.action" default="" />
    <cfparam name="FORM.SubAction" default="" />
    <cfparam name="FORM.validationErrors" default="0" />
    <!--- Student --->
    <cfparam name="FORM.studentID" default="0" />
    <cfparam name="FORM.uniqueID" default="" />
    <cfparam name="FORM.historyID" default="" />

    <cfscript>
		// Store Section on FORM Variable
		if ( LEN(URL.action) ) {
			FORM.action = URL.action;	
		}
	
		if ( VAL(URL.historyID) ) {
			FORM.historyID = URL.historyID;	
		}
		
		// Get Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.uniqueID);

		// Set a list of current reps assigned to student
		vCurrentUsersAssigned = '';
		vCurrentUsersAssigned = ListAppend(vCurrentUsersAssigned, qGetStudentInfo.areaRepID);
		vCurrentUsersAssigned = ListAppend(vCurrentUsersAssigned, qGetStudentInfo.placeRepID);
		
		// Get list of states that USERS and HOST FAMILIES are assigned to
		vListOfStates = APPLICATION.CFC.HOST.getHostStateListByRegionID(regionID=qGetStudentInfo.regionassigned);
		vListOfUserStates = APPLICATION.CFC.USER.getUserStateListByRegionID(regionID=qGetStudentInfo.regionassigned);

		// Loop through user state list and insert the ones that are not duplicate
		For ( i=1; i LTE ListLen(vListOfUserStates); i=i+1 ) {
			if ( NOT ListContainsNoCase(vListOfStates, ListGetAt(vListOfUserStates, i)) ) {
				vListOfStates = ListAppend(vListOfStates, ListGetAt(vListOfUserStates, i));
			}
		}
		
		// Get Student Arrival
		qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentInfo.studentID, flightType='arrival', flightLegOption='lastLeg');
		
		// Check if Student has arrived
		vLockIsRelocationField = 0;
		vHasStudentArrived = 0;
		
		if ( isDate(qGetArrival.dep_date) ) {
			
			// Returns -1, if date1 is earlier than date2 | Returns 0, if date1 is equal to date2 | Returns 1, if date1 is later than date2
			vDateDifference = DateCompare(now(), qGetArrival.dep_date, "d"); 

			if ( vDateDifference GTE 0 ) {
				// Student Has Arrived - Set Relocation to YES
				vHasStudentArrived = 1;
				vLockIsRelocationField = 1;
				FORM.isRelocation = 1;
			} else {
				// Student Has Not Arrived - Set Relocation to NO
				vLockIsRelocationField = 1;
				FORM.isRelocation = 0;			
			}
			
		}
		
		// Get Program Information
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programID);
		
		// Get Region Assigned - Used in the hostFamily
		qGetRegionAssigned = APPLICATION.CFC.REGION.getRegions(qGetStudentInfo.regionAssigned);
			
		// Get Host Family Information
		qGetHostInfo = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentInfo.hostID);
		
		// Get Host Kids at Home
		qGetHostKidsAtHome = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetStudentInfo.hostID,liveAtHome='yes');
		
		// Get Available Schools based on area reps state
		qGetAvailableSchools = APPLICATION.CFC.SCHOOL.getSchools(stateList=vListOfStates);
		
		// Get Available Reps
		qGetAvailableReps = APPLICATION.CFC.USER.getSupervisedUsers(
			userType=CLIENT.userType, 
			userID=CLIENT.userID, 
			regionID=qGetStudentInfo.regionAssigned,
			includeUserIDs=vCurrentUsersAssigned);

		// Get Available 2nd Visit Reps
		qGetAvailable2ndVisitReps = APPLICATION.CFC.USER.getSupervisedUsers(
			userType=CLIENT.userType, 
			userID=CLIENT.userID, 
			regionID=qGetStudentInfo.regionAssigned, 
			is2ndVisitIncluded=1, 
			includeUserIDs=qGetStudentInfo.secondVisitRepID);
			
		// Get Area Rep
		qGetAreaRepInfo = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.areaRepID);

		// Get Place Rep
		qGetPlaceRepInfo = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.placeRepID);

		// Get 2nd Visit Rep Info
		qGetSecondVisitRepInfo = APPLICATION.CFC.USER.getUserByID(userID=qGetStudentInfo.secondVisitRepID);
		
		// Get Available Double Placement
		qGetAvailableDoublePlacement = APPLICATION.CFC.STUDENT.getAvailableDoublePlacement(regionID=qGetStudentInfo.regionassigned, studentID=qGetStudentInfo.studentID);
		
		// Get Double Placement Info
		qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=qGetStudentInfo.doublePlace);	
		
		// Get Placement History
		qGetPlacementHistory = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID);
		
		// Get Second Host Family Visit
		qGetSecondVisitReport = APPLICATION.CFC.PROGRESSREPORT.getSecondHostFamilyVisitReport(studentID=qGetStudentInfo.studentID, hostID=qGetStudentInfo.hostID);
		
		// Calculate total of family members
		vTotalFamilyMembers = 0;
		
		if ( LEN(qGetHostInfo.fatherFirstName) ) {
			vTotalFamilyMembers = vTotalFamilyMembers + 1;
		}
		
		if ( LEN(qGetHostInfo.motherFirstName) ) {
			vTotalFamilyMembers = vTotalFamilyMembers + 1;
		}
		
		vTotalFamilyMembers = vTotalFamilyMembers + VAL(qGetHostKidsAtHome.recordCount);
		// End of Calculate total of family members
		
		
		// Set Placement Status (Unplaced / Rejected / Approved / Pending / Incomplete)
		vPlacementStatus = '';
		
		if ( NOT VAL(qGetStudentInfo.hostid) AND NOT VAL(qGetStudentInfo.schoolid) AND NOT VAL(qGetStudentInfo.arearepid) AND NOT VAL(qGetStudentInfo.placerepid) ) {
			
			vPlacementStatus = 'Unplaced';
		
		} else if ( VAL(qGetStudentInfo.hostid) AND VAL(qGetStudentInfo.schoolID) AND VAL(qGetStudentInfo.placeRepID) AND VAL(qGetStudentInfo.areaRepID) ) {			
			
			if ( qGetStudentInfo.host_fam_approved EQ 99 ) {
				
				// Placement Rejected
				vPlacementStatus = 'Rejected';
				
			} else if ( ListFind("1,2,3,4", qGetStudentInfo.host_fam_Approved) ) {
				
				// Placement Approved
				vPlacementStatus = 'Approved';
				
			} else {
				
				// Pending Approval
				vPlacementStatus = 'Pending';
				
			}
		
		} else {
			
			vPlacementStatus = 'Incomplete';
			
		}
		
		// Set Default Images
        vHostImage = 'host_1';
        vSchoolImage = 'school_1';
        vPlaceRepImage = 'place_1';
        vSuperRepImage = 'super_1';
        vDoublePlaceImage = 'double_1';
        vPaperworkImage = 'paperwork_1';
        vNotesImage = 'notes_1';
        vSecondVisitImage = 'secondVisit_1';
		
		// Placement Buttons - Placement Not Complete
        if ( NOT VAL(qGetStudentInfo.hostid) AND ( VAL(qGetStudentInfo.schoolid) OR VAL(qGetStudentInfo.arearepid) OR VAL(qGetStudentInfo.placerepid) ) ) {
        	vHostImage = 'host_2';
		}
		if ( NOT VAL(qGetStudentInfo.schoolid) AND ( VAL(qGetStudentInfo.hostid) OR VAL(qGetStudentInfo.arearepid) OR VAL(qGetStudentInfo.placerepid) ) ) {
        	vSchoolImage = 'school_2';
		}
		if ( NOT VAL(qGetStudentInfo.placerepid) AND ( VAL(qGetStudentInfo.hostid) OR VAL(qGetStudentInfo.schoolid) OR VAL(qGetStudentInfo.arearepid) ) ) {
        	vPlaceRepImage = 'place_2';
       	}
		if ( NOT VAL(qGetStudentInfo.arearepid) AND ( VAL(qGetStudentInfo.hostid) OR VAL(qGetStudentInfo.schoolid) OR VAL(qGetStudentInfo.placerepid) ) ) {
        	vSuperRepImage = 'super_2';
        }
		if ( NOT VAL(qGetStudentInfo.secondVisitRepid) AND ( VAL(qGetStudentInfo.hostid) OR VAL(qGetStudentInfo.schoolid) OR VAL(qGetStudentInfo.placerepid) ) ) {
        	vSecondVisitImage = 'secondVisit_2';
		}
		
		// Placement Buttons 
        if ( VAL(qGetStudentInfo.hostid) ) {
			vHostImage = 'host_3';
		}
        if ( VAL(qGetStudentInfo.schoolid) ) {
			vSchoolImage = 'school_3';
        }
		if ( VAL(qGetStudentInfo.placerepid) ) {
			vPlaceRepImage = 'place_3';
        }
		if ( VAL(qGetStudentInfo.arearepid) ) {
			vSuperRepImage = 'super_3';
        }
		if ( VAL(qGetStudentInfo.doubleplace) ) {
			vDoublePlaceImage = 'double_3';
        }
		if ( VAL(qGetStudentInfo.secondVisitRepID) ) {
			vSecondVisitImage = 'secondVisit_3';
		}
		// End of Set Default Images
		
		
		// Placement Notes
        if ( NOT LEN(qGetStudentInfo.placement_notes) ) {
			vNotesImage = 'notes_1';		 
		} else {
			vNotesImage = 'notes_3';
		}
		// End of Placement Notes

		// Get Eligible CBC Host Kids
		qGetEligibleCBCHostMembers = APPLICATION.CFC.CBC.getEligibleHostMember(hostID=qGetStudentInfo.hostID, studentID=qGetPlacementHistory.studentID);

		// Paperwork
        if ( VAL(qGetStudentInfo.hostID) ) {
			
			vParentsMissingAuthorization = 0;
			
			if ( LEN(qGetHostInfo.fatherFirstName) AND NOT isDate(qGetHostInfo.fathercbc_form) ) {
				vParentsMissingAuthorization = 1;
			}
			
			if ( LEN(qGetHostInfo.motherFirstName) AND NOT isDate(qGetHostInfo.mothercbc_form) ) {
				vParentsMissingAuthorization = 1;
			}

			// Check for Host Kids missing CBC Authorizations
			vHostMemberMissingCBCAuthorization = 0;
			
			// Loop through eligible member query
            For ( i=1; i LTE qGetEligibleCBCHostMembers.recordCount; i=i+1 ) {

				if ( NOT IsDate(qGetEligibleCBCHostMembers.cbc_form_received[i]) ) {
					// Store Missing CBC Message
					vHostMemberMissingCBCAuthorization = vHostMemberMissingCBCAuthorization + 1;
				}
				
            }
			
			// Check for Placement Paperwork
			if ( 				
					isDate(qGetPlacementHistory.doc_full_host_app_date) 
				AND 
					isDate(qGetPlacementHistory.doc_letter_rec_date)
				AND 
					isDate(qGetPlacementHistory.doc_rules_rec_date) 
				AND 
					isDate(qGetPlacementHistory.doc_rules_sign_date) 
				AND 
					isDate(qGetPlacementHistory.doc_photos_rec_date) 
				AND 
					isDate(qGetPlacementHistory.doc_school_accept_date)
				AND 
					isDate(qGetPlacementHistory.doc_school_profile_rec) 
				AND 
					isDate(qGetPlacementHistory.doc_conf_host_rec) 
				AND 
					isDate(qGetPlacementHistory.doc_ref_form_1) 
				AND 
					isDate(qGetPlacementHistory.doc_ref_form_2) 
				AND 
					NOT VAL(vParentsMissingAuthorization)
				AND 
					NOT VAL(vHostMemberMissingCBCAuthorization)
				) {
							
					// Paperwork Complete
					vPaperworkImage = 'paperwork_4';
			
			} else {
				
				// Paperwork Incomplete
				vPaperworkImage = 'paperwork_2';
				
			}
			
			// Host Family Application Photos - Check only starting August 12/13
			if ( 
					qGetProgramInfo.seasonID GTE 9 
				AND
				(
						NOT isDate(qGetPlacementHistory.doc_bedroom_photo) 
					OR 
						NOT isDate(qGetPlacementHistory.doc_bathroom_photo) 
					OR 
						NOT isDate(qGetPlacementHistory.doc_kitchen_photo) 
					OR 
						NOT isDate(qGetPlacementHistory.doc_living_room_photo) 
					OR 
						NOT isDate(qGetPlacementHistory.doc_outside_photo) 
				)
			) {
					// Paperwork Incomplete
					vPaperworkImage = 'paperwork_2';
			}
			// End of Host Family Application Photos - Check only starting August 12/13
			
			// Single Person Placement - Check for Extra Paperwork
			if ( 
					vTotalFamilyMembers EQ 1 
				AND 
					(
					 	NOT isDate(qGetPlacementHistory.doc_single_ref_form_1) 
					OR 
						NOT isDate(qGetPlacementHistory.doc_single_ref_form_2) 
					)
				) {
					// Paperwork Incomplete
					vPaperworkImage = 'paperwork_2';
			}
			
			// Check Orientations if Paperwork is complete
			if ( vPaperworkImage EQ 'paperwork_4' 
					AND 
					( 
					 	NOT isDate(qGetPlacementHistory.stu_arrival_orientation) 
					OR 
						NOT isDate(qGetPlacementHistory.host_arrival_orientation) 
					OR
						NOT isDate(qGetPlacementHistory.doc_class_schedule)
					) 
				) {
				  // Paperwork docs are complete but orientations are missing
				  vPaperworkImage = 'paperwork_3';
			}
			
        }
	</cfscript>

</cfsilent>
	
<cfoutput>
	
	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
        filePath="../../"
    />	
    
		<!--- Table Header --->
        <gui:tableHeader
			tableTitle="Placement Management"
            <!--- tableRightTitle="#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)" --->
            width="90%"
            imagePath="../../"
        />    

        <table width="90%" cellpadding="4" cellspacing="0" class="section" align="center">      
            <tr class="reportCenterTitle">
                <th align="center" class="placementTopLinks">
                	<a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                    	#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)
                    </a>
                    
                    <!---
                    [ 
                        &nbsp;
                        <a href="#CGI.SCRIPT_NAME#?curdoc=student/placementMgmt/index&uniqueID=#qGetStudentInfo.uniqueID#">Main Menu</a>
                        &nbsp; | &nbsp;
                        <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork">Paperwork</a>                    
                        &nbsp; | &nbsp;
                        <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=placementNotes">Placement Notes</a>
                        &nbsp; 
                    ]
					--->
                </th>
            </tr>
		</table>
        
        <table width="90%" cellpadding="4" cellspacing="0" class="section" align="center" style="background-color:##edeff4; padding:5px 0px 5px 0px;">  
            <tr>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vHostImage#.gif" alt="Host Family" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vSchoolImage#.gif" alt="High School" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vPlaceRepImage#.gif" alt="Placing Representative" border="0">
                   </a> 
                </td>		
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vSuperRepImage#.gif" alt="Supervising Representative" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vSecondVisitImage#.gif" alt="Second Vist Representative" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vDoublePlaceImage#.gif" alt="Double Placement" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork">
                        <img src="../../pics/place_menu/#vPaperworkImage#.gif" alt="Placement Paperwork" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=placementNotes">
                        <img src="../../pics/place_menu/#vNotesImage#.gif" alt="Placement Notes" border="0">
                    </a>
                </td>
            </tr>
        </table>
		
        <cfif URL.action EQ 'initial'>
            <table width="90%" cellpadding="4" cellspacing="0" class="section" align="center">            
                <tr class="reportCenterTitle">
                    <th>
                        PLACEMENT STATUS &nbsp;
                        <span style="font-weight:bold; text-decoration:underline; text-transform:uppercase; letter-spacing:2px;">#vPlacementStatus#</span>
                    </th>
                </tr>
            </table>
		</cfif>
        
		<!--- 
			Check to see which action we are taking. 
		--->

        <!--- Include Template --->
        <cfswitch expression="#FORM.action#">
        
            <cfcase value="initial,paperwork,paperworkHistory,placementNotes" delimiters=",">
        
                <!--- Include template --->
                <cfinclude template="_#FORM.action#.cfm" />
        
            </cfcase>
        
            <!--- The default case is the initial page --->
            <cfdefaultcase>
                
                <!--- Include template --->
                <cfinclude template="_initial.cfm" />
        
            </cfdefaultcase>
        
        </cfswitch>
		
		<!--- History --->
        <cfif URL.action EQ 'initial' AND VAL(qGetPlacementHistory.recordCount)>
            
            <!--- Current Placement --->
            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">                            				
                <tr class="reportCenterTitle"> 
                    <th>
                    	<cfif vPlacementStatus EQ 'unplaced'>
                        	PLACEMENT HISTORY
                        <cfelse>
                        	#APPLICATION.CFC.UDF.convertToOrdinal(qGetPlacementHistory.recordCount)# PLACEMENT ( CURRENT )
                        </cfif>
                        
                        &nbsp; -  &nbsp;
                         
                        Period: From 
                        <cfif isDate(qGetPlacementHistory.dateRelocated)>
                            #DateFormat(qGetPlacementHistory.dateRelocated, 'mm/dd/yyyy')#
                        <cfelse>
                            #DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')#
                        </cfif>
                        
                        <cfif isDate(qGetPlacementHistory.datePlacedEnded)>
                            to #DateFormat(qGetPlacementHistory.datePlacedEnded, 'mm/dd/yyyy')#
                        <cfelse>
                            to present 
                        </cfif>
                        
                        <div style="float:right; padding-right:5px; width:170px;">
                            <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork">[ View Paperwork ]</a>
                        </div>
                    </th>
                </tr>
            </table>
            
            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center"> 
                <tr bgcolor="##edeff4">
                    <td class="reportTitleLeftClean" width="15%">Host Family</td>
                    <td class="reportTitleLeftClean" width="17%">School</td>
                    <td class="reportTitleLeftClean" width="17%">Placing Rep.</td>
                    <td class="reportTitleLeftClean" width="17%">Supervising Rep.</td>
                    <td class="reportTitleLeftClean" width="17%">2<sup>nd</sup> Rep.</td>
                    <td class="reportTitleLeftClean" width="17%">Double Placement</td>
                </tr>
			</table>
            
            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center"> 
                <cfscript>
                    // Get Actions History
                    qGetActionsHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
                        applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
                        foreignTable='smg_hostHistory',
                        foreignID=qGetPlacementHistory.historyID,
                        sortBy='dateCreated',
                        sortOrder='DESC'
                    );
                </cfscript>

                <tr bgcolor="##FFFFFF">
                    <td width="15%" <cfif qGetPlacementHistory.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.hostID)>
                            <a href="../../index.cfm?curdoc=host_fam_info&hostid=#qGetPlacementHistory.hostID#" target="_blank" title="More Information">
                            	#qGetPlacementHistory.familyLastName# (###qGetPlacementHistory.hostID#)
                            </a>
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasSchoolIDChanged> class="placementMgmtChanged" </cfif> >
						<cfif VAL(qGetPlacementHistory.schoolID)>                            
                            <a href="../../index.cfm?curdoc=school_info&schoolID=#qGetPlacementHistory.schoolID#" target="_blank" title="More Information">
                            	#qGetPlacementHistory.schoolName# (###qGetPlacementHistory.schoolID#)
                            </a>
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasPlaceRepIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.placeRepID)>
                            <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistory.placeRepID#" target="_blank" title="More Information">
                            	#qGetPlacementHistory.placeFirstName# #qGetPlacementHistory.placeLastName# (###qGetPlacementHistory.placeRepID#)
                            </a>
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasAreaRepIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.areaRepID)>
                            <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistory.areaRepID#" target="_blank" title="More Information">
	                            #qGetPlacementHistory.areaFirstName# #qGetPlacementHistory.areaLastName# (###qGetPlacementHistory.areaRepID#)
    						</a>
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasSecondVisitRepIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.secondVisitRepID)>
                            <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistory.secondVisitRepID#" target="_blank" title="More Information">
                            	#qGetPlacementHistory.secondRepFirstName# #qGetPlacementHistory.secondRepLastName# (###qGetPlacementHistory.secondVisitRepID#)
                            </a>
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasDoublePlacementIDChanged> class="placementMgmtChanged" </cfif> >
						<cfif VAL(qGetPlacementHistory.doublePlacementID)>
                        	<a href="../../index.cfm?curdoc=student_info&studentID=#qGetPlacementHistory.doublePlacementID#" target="_blank" title="More Information">
                            	#qGetPlacementHistory.doublePlacementFirstName# #qGetPlacementHistory.doublePlacementLastName# (###qGetPlacementHistory.doublePlacementID#)
                            </a>
                        </cfif>
                    </td>
                </tr>
                
                <!--- Display Action History --->
                <cfif qGetActionsHistory.recordCount>
                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                        <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("edeff4") ,DE("FFFFFF") )#">
                            <td class="reportTitleLeftClean" width="25%">Date</td>
                            <td class="reportTitleLeftClean" width="75%">Actions</td>
                        </tr>
                    </table>
                    
                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center">
                        <cfloop query="qGetActionsHistory">
                            <tr>
                                <td valign="top" width="25%">#DateFormat(qGetActionsHistory.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetActionsHistory.dateCreated, 'hh:mm tt')# <!--- EST ---></td>
                                <td width="75%">#qGetActionsHistory.actions#</td>
                            </tr>                        
                        </cfloop>
					</table>                        
                </cfif>
                 
            </table> 
            
        	<!--- Previous Set of Placements --->
            <cfif VAL(qGetPlacementHistory.recordCount) GT 1> 
                
                <cfscript>
					// Display Cardinal Placement Information
					vCardinalCount = qGetPlacementHistory.recordCount;
				</cfscript>
                
                <cfloop query="qGetPlacementHistory" startrow="2" endrow="#VAL(qGetPlacementHistory.recordCount)#">

					<cfscript>
                        vCardinalCount = vCardinalCount - 1;
                    </cfscript>

                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="border:1px solid ##ccc;">                            				
                        <tr class="reportCenterTitle"> 
                            <th align="center">
                            	<cfif qGetPlacementHistory.currentRow EQ qGetPlacementHistory.recordCount>
                                	ORIGINAL PLACEMENT
                                <cfelse>
                                	#APPLICATION.CFC.UDF.convertToOrdinal(vCardinalCount)# PLACEMENT
                                </cfif>
								
                                &nbsp; -  &nbsp;
                                
                                <cfif isDate(qGetPlacementHistory.datePlacedEnded)>
                                 
                                    Period: From 
                                    <cfif isDate(qGetPlacementHistory.dateRelocated)>
                                        #DateFormat(qGetPlacementHistory.dateRelocated, 'mm/dd/yyyy')#
                                    <cfelse>
                                        #DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')#
                                    </cfif>
                                    to #DateFormat(qGetPlacementHistory.datePlacedEnded, 'mm/dd/yyyy')#
								
                                <cfelse>
                                
                                	#DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')#
                                
                                </cfif>
                                
                                <div style="float:right; padding-right:5px; width:170px;">
									<cfif VAL(qGetPlacementHistory.hostID)>
                                    	<a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperworkHistory&historyID=#qGetPlacementHistory.historyID#">[ View Paperwork History ]</a>
                                    <cfelse>
                                        &nbsp;                            
                                    </cfif>
                                </div>
                            </th>
                        </tr>
                    </table>
                
                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("FFFFFF") ,DE("edeff4") )#">
                            <td class="reportTitleLeftClean" width="15%">Host Family</td>
                            <td class="reportTitleLeftClean" width="17%">School</td>
                            <td class="reportTitleLeftClean" width="17%">Placing Rep.</td>
                            <td class="reportTitleLeftClean" width="17%">Supervising Rep.</td>
                            <td class="reportTitleLeftClean" width="17%">2<sup>nd</sup> Rep.</td>
                            <td class="reportTitleLeftClean" width="17%">Double Placement</td>
                        </tr>
    				</table>
                    
                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center"> 
                        <cfscript>
                            // Get Actions History
                            qGetActionsHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
                                applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
                                foreignTable='smg_hostHistory',
                                foreignID=qGetPlacementHistory.historyID,
                                sortBy='dateCreated',
                                sortOrder='DESC'
                            );
                        </cfscript>
    
                        <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("edeff4") ,DE("FFFFFF") )#">
                            <td width="15%" <cfif qGetPlacementHistory.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.hostID)>
                                	<a href="../../index.cfm?curdoc=host_fam_info&hostid=#qGetPlacementHistory.hostID#" target="_blank" title="More Information">
                                        #qGetPlacementHistory.familyLastName# (###qGetPlacementHistory.hostID#)
                                    </a>
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasSchoolIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.schoolID)>                            
                                    <a href="../../index.cfm?curdoc=school_info&schoolID=#qGetPlacementHistory.schoolID#" target="_blank" title="More Information">
                                        #qGetPlacementHistory.schoolName# (###qGetPlacementHistory.schoolID#)
                                    </a>
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasPlaceRepIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.placeRepID)>
                                    <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistory.placeRepID#" target="_blank" title="More Information">
                                    	#qGetPlacementHistory.placeFirstName# #qGetPlacementHistory.placeLastName# (###qGetPlacementHistory.placeRepID#)
                                    </a>    
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasAreaRepIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.areaRepID)>
                                    <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistory.areaRepID#" target="_blank" title="More Information">
	                                    #qGetPlacementHistory.areaFirstName# #qGetPlacementHistory.areaLastName# (###qGetPlacementHistory.areaRepID#)
    								</a>
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasSecondVisitRepIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.secondVisitRepID)>
                                	<a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistory.secondVisitRepID#" target="_blank" title="More Information">    
                                    	#qGetPlacementHistory.secondRepFirstName# #qGetPlacementHistory.secondRepLastName# (###qGetPlacementHistory.secondVisitRepID#)
                                	</a>
								</cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasDoublePlacementIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.doublePlacementID)>
                                	<a href="../../index.cfm?curdoc=student_info&studentID=#qGetPlacementHistory.doublePlacementID#" target="_blank" title="More Information">
                                    	#qGetPlacementHistory.doublePlacementFirstName# #qGetPlacementHistory.doublePlacementLastName# (###qGetPlacementHistory.doublePlacementID#)
                                    </a>
                                </cfif>
                            </td>
                        </tr>
                        
                        <!--- Display Action History --->
                        <cfif qGetActionsHistory.recordCount>
                            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                                <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("FFFFFF") ,DE("edeff4") )#">
                                    <td class="reportTitleLeftClean" width="25%">Date</td>
                                    <td class="reportTitleLeftClean" width="75%">Actions</td>
                                </tr>
							</table>
                            
                            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center">
                                <cfloop query="qGetActionsHistory">
                                    <tr>
                                        <td valign="top" width="25%">#DateFormat(qGetActionsHistory.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetActionsHistory.dateCreated, 'hh:mm tt')# <!--- EST ---></td>
                                        <td width="75%">#qGetActionsHistory.actions#</td>
                                    </tr>                        
                                </cfloop>
							</table>
                        </cfif>
                         
                    </table> 
                     
                </cfloop> 
        
			</cfif>
            
		</cfif>        
    
		<!--- Table Footer --->
        <gui:tableFooter 
            width="90%"
            imagePath="../../"
        />
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
        filePath="../../"
    />

</cfoutput>