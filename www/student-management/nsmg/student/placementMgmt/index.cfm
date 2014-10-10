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

	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.student" jsclassname="studentCFC">

    <cfscript>
		// Users allowed to delete placement history - Marcus Melo | 
		vDeleteHistoryAllowed = '510,1';
	
		// Store Section on FORM Variable
		if ( LEN(URL.action) ) {
			FORM.action = URL.action;	
		}
	
		if ( VAL(URL.historyID) ) {
			FORM.historyID = URL.historyID;	
		}
		
		// Get Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.uniqueID);

		// Get Placement History List
		qGetPlacementHistoryList = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID);
		
		// Get Placement History By ID - First record of qGetPlacementHistoryList is the current record
		if ( VAL(FORM.historyID) ) {
			// Get Previous History from FORM
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=FORM.historyID);
		} else if ( VAL(qGetPlacementHistoryList.isActive) ) {
			// Get Current History
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=qGetPlacementHistoryList.historyID);
		} else {
			// Student is unplaced 
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=0);
		};
		
		// Get Double Placement History Paperwork
		qGetDoublePlacementPaperworkHistory = APPLICATION.CFC.STUDENT.getDoublePlacementPaperworkHistory(historyID=qGetPlacementHistoryByID.historyID, studentID=qGetStudentInfo.studentID);
    
		// Set a list of current reps assigned to student
		vCurrentUsersAssigned = '';
		vCurrentUsersAssigned = ListAppend(vCurrentUsersAssigned, qGetPlacementHistoryByID.areaRepID);
		vCurrentUsersAssigned = ListAppend(vCurrentUsersAssigned, qGetPlacementHistoryByID.placeRepID);
		
		vExcludeUsers = '';
		vExcludeUsers = vExcludeUsers = ListAppend(vExcludeUsers, qGetPlacementHistoryByID.placeRepID);
			
	
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
			excludeUserIDs = vExcludeUsers);

		// Get Program Information
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programID);
		
		// Get Region Assigned - Used in the hostFamily
		qGetRegionAssigned = APPLICATION.CFC.REGION.getRegions(qGetStudentInfo.regionAssigned);
		
		
		if ( VAL(qGetPlacementHistoryByID.hostID) ) {
			// Get Host Family Information
			qGetHostInfo = APPLICATION.CFC.HOST.getHosts(hostID=qGetPlacementHistoryByID.hostID, active="all");
				
			// Get Host Kids at Home
			qGetHostKidsAtHome = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetPlacementHistoryByID.hostID,liveAtHome='yes');
		}
		// Get Area Rep
		qGetAreaRepInfo = APPLICATION.CFC.USER.getUserByID(userID=qGetPlacementHistoryByID.areaRepID);

		// Get Place Rep
		qGetPlaceRepInfo = APPLICATION.CFC.USER.getUserByID(userID=qGetPlacementHistoryByID.placeRepID);

		// Get 2nd Visit Rep Info
		qGetSecondVisitRepInfo = APPLICATION.CFC.USER.getUserByID(userID=qGetPlacementHistoryByID.secondVisitRepID);

		// Get Available Double Placement
		qGetAvailableDoublePlacement = APPLICATION.CFC.STUDENT.getAvailableDoublePlacement(regionID=qGetStudentInfo.regionassigned, studentID=qGetStudentInfo.studentID, hostID=qGetPlacementHistoryByID.hostID);

		// Get Double Placement Info
		qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(qGetPlacementHistoryByID.doublePlacementID));	

		// Get Second Host Family Visit
		qGetSecondVisitReport = APPLICATION.CFC.PROGRESSREPORT.getSecondHostFamilyVisitReport(studentID=qGetStudentInfo.studentID, hostID=qGetPlacementHistoryByID.hostID);

		// Calculate total of family members
		vTotalFamilyMembers = 0;
		
		if ( VAL(qGetPlacementHistoryByID.hostID) ) {
			if ( LEN(qGetHostInfo.fatherFirstName) ) {
				vTotalFamilyMembers = vTotalFamilyMembers + 1;
			}
			
			if ( LEN(qGetHostInfo.motherFirstName) ) {
				vTotalFamilyMembers = vTotalFamilyMembers + 1;
			}
			
			vTotalFamilyMembers = vTotalFamilyMembers + VAL(qGetHostKidsAtHome.recordCount);
			// End of Calculate total of family members
		}
		
		// Set Placement Status (Unplaced / Rejected / Approved / Pending / Incomplete)
		vPlacementStatus = '';
		
		if ( NOT VAL(qGetPlacementHistoryByID.hostID) AND NOT VAL(qGetPlacementHistoryByID.schoolID) AND NOT VAL(qGetPlacementHistoryByID.placeRepID) AND NOT VAL(qGetPlacementHistoryByID.areaRepID) ) {
			
			vPlacementStatus = 'Unplaced';
		
		} else if ( VAL(qGetPlacementHistoryByID.hostID) AND VAL(qGetPlacementHistoryByID.schoolID) AND VAL(qGetPlacementHistoryByID.placeRepID) AND VAL(qGetPlacementHistoryByID.areaRepID) ) {			
			
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
		
		if (qGetPlacementHistoryByID.recordCount) {
		
			// Placement Buttons - Placement Not Complete
			if ( NOT VAL(qGetPlacementHistoryByID.hostID) AND ( VAL(qGetPlacementHistoryByID.schoolID) OR VAL(qGetPlacementHistoryByID.placeRepID) OR VAL(qGetPlacementHistoryByID.areaRepID) ) ) {
				vHostImage = 'host_2';
			}
			if ( NOT VAL(qGetPlacementHistoryByID.schoolID) AND ( VAL(qGetPlacementHistoryByID.hostID) OR VAL(qGetPlacementHistoryByID.placeRepID) OR VAL(qGetPlacementHistoryByID.areaRepID) ) ) {
				vSchoolImage = 'school_2';
			}
			if ( NOT VAL(qGetPlacementHistoryByID.placeRepID) AND ( VAL(qGetPlacementHistoryByID.hostID) OR VAL(qGetPlacementHistoryByID.schoolID OR VAL(qGetPlacementHistoryByID.areaRepID)) ) ) {
				vPlaceRepImage = 'place_2';
			}
			if ( NOT VAL(qGetPlacementHistoryByID.areaRepID) AND ( VAL(qGetPlacementHistoryByID.hostID) OR VAL(qGetPlacementHistoryByID.schoolID) OR VAL(qGetPlacementHistoryByID.placeRepID) ) ) {
				vSuperRepImage = 'super_2';
			}
			if ( NOT VAL(qGetPlacementHistoryByID.secondVisitRepID) AND ( VAL(qGetPlacementHistoryByID.hostID) OR VAL(qGetPlacementHistoryByID.schoolID) OR VAL(qGetPlacementHistoryByID.placeRepID) ) ) {
				vSecondVisitImage = 'secondVisit_2';
			}
			
			// Placement Buttons 
			if ( VAL(qGetPlacementHistoryByID.hostID) ) {
				vHostImage = 'host_3';
			}
			if ( VAL(qGetPlacementHistoryByID.schoolID) ) {
				vSchoolImage = 'school_3';
			}
			if ( VAL(qGetPlacementHistoryByID.placeRepID) ) {
				vPlaceRepImage = 'place_3';
			}
			if ( VAL(qGetPlacementHistoryByID.areaRepID) ) {
				vSuperRepImage = 'super_3';
			}
			if ( VAL(qGetPlacementHistoryByID.doublePlacementID) ) {
				vDoublePlaceImage = 'double_3';
			}
			if ( VAL(qGetPlacementHistoryByID.secondVisitRepID) ) {
				vSecondVisitImage = 'secondVisit_3';
			}
			// End of Set Default Images
		
		}
		
		// Placement Notes
        if ( NOT LEN(qGetStudentInfo.placement_notes) ) {
			vNotesImage = 'notes_1';		 
		} else {
			vNotesImage = 'notes_3';
		}
		// End of Placement Notes

		// Paperwork
        if ( VAL(qGetPlacementHistoryByID.hostID) ) {
			
			// Check for Placement Paperwork
			if ( 				
					isDate(qGetPlacementHistoryList.doc_host_app_page1_date) 
				AND 
					isDate(qGetPlacementHistoryList.doc_host_app_page2_date) 
				AND 
					isDate(qGetPlacementHistoryList.doc_letter_rec_date)
				AND 
					isDate(qGetPlacementHistoryList.doc_rules_rec_date) 
				AND 
					isDate(qGetPlacementHistoryList.doc_rules_sign_date) 
				AND 
					isDate(qGetPlacementHistoryList.doc_photos_rec_date) 
				AND 
					isDate(qGetPlacementHistoryList.doc_school_accept_date)
				AND 
					isDate(qGetPlacementHistoryList.doc_school_profile_rec) 
				AND 
					isDate(qGetPlacementHistoryList.doc_conf_host_rec) 
				AND 
					isDate(qGetPlacementHistoryList.doc_ref_form_1) 
				AND 
					isDate(qGetPlacementHistoryList.doc_ref_form_2) 
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
						NOT isDate(qGetPlacementHistoryList.doc_bedroom_photo) 
					OR 
						NOT isDate(qGetPlacementHistoryList.doc_bathroom_photo) 
					OR 
						NOT isDate(qGetPlacementHistoryList.doc_kitchen_photo) 
					OR 
						NOT isDate(qGetPlacementHistoryList.doc_living_room_photo) 
					OR 
						NOT isDate(qGetPlacementHistoryList.doc_outside_photo) 
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
					 	NOT isDate(qGetPlacementHistoryList.doc_single_ref_form_1) 
					OR 
						NOT isDate(qGetPlacementHistoryList.doc_single_ref_form_2) 
					)
				) {
					// Paperwork Incomplete
					vPaperworkImage = 'paperwork_2';
			}
			
			// Check Orientations if Paperwork is complete
			if ( vPaperworkImage EQ 'paperwork_4' 
					AND 
					( 
					 	NOT isDate(qGetPlacementHistoryList.stu_arrival_orientation) 
					OR 
						NOT isDate(qGetPlacementHistoryList.host_arrival_orientation) 
					OR
						NOT isDate(qGetPlacementHistoryList.doc_class_schedule)
					) 
				) {
				  // Paperwork docs are complete but orientations are missing
				  vPaperworkImage = 'paperwork_4';
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

		<script language="javascript">
            // Create an instance of the proxy. 
            var stuCFC = new studentCFC();
        
            // --- START OF DELETE PLACEMENT HISTORY --- //
            var confirmDeletePlacementHistory = function(historyID) {
                var answer = confirm("Are you sure would you like to delete this placement history?")
                if (answer){
                    deletePlacementHistory(historyID);
                } 
            }	
        
            var deletePlacementHistory = function(historyID) {
                // Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
                stuCFC.setCallbackHandler(placementHistoryDeleted(historyID)); 
                stuCFC.setErrorHandler(myErrorHandler); 
                stuCFC.deletePlacementHistoryRemote(historyID);
            }
            
            var placementHistoryDeleted = function(historyID) {
                // Reload page
                location.reload();
            }
            // --- END OF DELETE PLACEMENT HISTORY --- //
        
            // Error handler for the asynchronous functions. 
            var myErrorHandler = function(statusCode, statusMsg) { 
                alert('Status: ' + statusCode + ', ' + statusMsg); 
            } 
        </script>
    
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
                <cfif client.companyid neq 13>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vSecondVisitImage#.gif" alt="Second Vist Representative" border="0">
                    </a>
                </td>
                </cfif>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#">
                        <img src="../../pics/place_menu/#vDoublePlaceImage#.gif" alt="Double Placement" border="0">
                    </a>
                </td>
                 <cfif client.companyid neq 13>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork">
                        <img src="../../pics/place_menu/#vPaperworkImage#.gif" alt="Placement Paperwork" border="0">
                    </a>
                </td>
                </cfif>
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
        
            <cfcase value="initial,paperwork,placementNotes" delimiters=",">
        
                <!--- Include template --->
                <cfinclude template="_#FORM.action#.cfm" />
        
            </cfcase>
        
            <!--- The default case is the initial page --->
            <cfdefaultcase>
                
                <!--- Include template --->
                <cfinclude template="_initial.cfm" />
        
            </cfdefaultcase>
        
        </cfswitch>
		
        
        <!--- Placement History --->
        <cfif FORM.action EQ 'initial'>
        
			<cfscript>
                // Display Cardinal Placement Information
                vCardinalCount = qGetPlacementHistoryList.recordCount;
            </cfscript>
            
            <cfloop query="qGetPlacementHistoryList">
    
                <cfscript>
                    vCardinalCount = vCardinalCount - 1;
                </cfscript>
    
                <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center" style="border:1px solid ##ccc;">                            				
                    <tr class="reportCenterTitle"> 
                        <th align="center">
                            
                            <cfif qGetPlacementHistoryList.currentRow EQ qGetPlacementHistoryList.recordCount>
                                ORIGINAL PLACEMENT
                            <cfelseif VAL(qGetPlacementHistoryList.isActive)>
                                #APPLICATION.CFC.UDF.convertToOrdinal(vCardinalCount)# PLACEMENT ( CURRENT )
                            <cfelse>
                                #APPLICATION.CFC.UDF.convertToOrdinal(vCardinalCount)# PLACEMENT
                            </cfif>
                            
                            &nbsp; -  &nbsp;
                            
                            <cfif isDate(qGetPlacementHistoryList.datePlacedEnded)>
                             
                                Period: From 
                                <cfif isDate(qGetPlacementHistoryList.dateRelocated)>
                                    #DateFormat(qGetPlacementHistoryList.dateRelocated, 'mm/dd/yyyy')#
                                <cfelse>
                                    #DateFormat(qGetPlacementHistoryList.datePlaced, 'mm/dd/yyyy')#
                                </cfif>
                                to #DateFormat(qGetPlacementHistoryList.datePlacedEnded, 'mm/dd/yyyy')#
                            
                            <cfelse>
                            
                                #DateFormat(qGetPlacementHistoryList.datePlaced, 'mm/dd/yyyy')#
                            
                            </cfif>
                            
                            <div style="float:right; padding-right:5px; width:300px; text-align:right;">
                                <cfif VAL(qGetPlacementHistoryList.isActive)>
                                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork">[View Paperwork]</a>
                                    
									<cfif listFind("1,2,3,4", CLIENT.userType)>
                                        |
                                        <a href="" onClick="javascript: win=window.open('../../reports/placementInfoSheet.cfm?uniqueID=#FORM.uniqueid#', 'Settings', 'height=450, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
                                            [View PIS]
                                        </a>
                                    </cfif>
                                    
                                <cfelse>
                                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#qGetStudentInfo.uniqueID#&action=paperwork&historyID=#qGetPlacementHistoryList.historyID#">[View Paperwork History]</a>
                                	
    								<cfif listFind("1,2,3,4", CLIENT.userType)>                                
	                                    |
                                        <a href="" onClick="javascript: win=window.open('../../reports/placementInfoSheet.cfm?uniqueID=#FORM.uniqueid#&historyID=#qGetPlacementHistoryList.historyID#', 'Settings', 'height=450, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
                                            [View PIS]
                                        </a>
                                    </cfif>
                                    
                                    <!--- Delete Placement History --->
                                    <cfif NOT VAL(qGetPlacementHistoryList.isActive) AND ListFind(vDeleteHistoryAllowed, CLIENT.userID)>
                                        |
                                        <a href="javascript:confirmDeletePlacementHistory(#qGetPlacementHistoryList.historyID#);">[Delete]</a>
                                    </cfif>
                                </cfif>
                            </div>
                        </th>
                    </tr>
                </table>
            
                <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="###iif(qGetPlacementHistoryList.currentrow MOD 2 ,DE("FFFFFF") ,DE("edeff4") )#">
                        <td class="reportTitleLeftClean" width="15%">Host Family</td>
                        <td class="reportTitleLeftClean" width="17%">School</td>
                        <td class="reportTitleLeftClean" width="17%">Placing Rep.</td>
                        <td class="reportTitleLeftClean" width="17%">Supervising Rep.</td>
                       <cfif CLIENT.companyID neq 13>
                        <td class="reportTitleLeftClean" width="17%">2<sup>nd</sup> Rep.</td>
                       </cfif>
                        <td class="reportTitleLeftClean" width="17%">Double Placement</td>
                    </tr>
                </table>
                
                <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center"> 
                    <cfscript>
                        // Get Actions History
                        qGetActionsHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
							applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
                            foreignTable='smg_hostHistory',
                            foreignID=qGetPlacementHistoryList.historyID,
                            sortBy='dateCreated',
                            sortOrder='DESC'
                        );
                    </cfscript>
    
                    <tr bgcolor="###iif(qGetPlacementHistoryList.currentrow MOD 2 ,DE("edeff4") ,DE("FFFFFF") )#">
                        <td width="15%" <cfif qGetPlacementHistoryList.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                            <cfif VAL(qGetPlacementHistoryList.hostID)>
                                <a href="../../index.cfm?curdoc=host_fam_info&hostID=#qGetPlacementHistoryList.hostID#" target="_blank" title="More Information">
                                    #qGetPlacementHistoryList.familyLastName# (###qGetPlacementHistoryList.hostID#)
                                </a>
                            </cfif>
                        </td>
                        <td width="17%" <cfif qGetPlacementHistoryList.hasSchoolIDChanged> class="placementMgmtChanged" </cfif> >
                            <cfif VAL(qGetPlacementHistoryList.schoolID)>                            
                                <a href="../../index.cfm?curdoc=school_info&schoolID=#qGetPlacementHistoryList.schoolID#" target="_blank" title="More Information">
                                    #qGetPlacementHistoryList.schoolName# (###qGetPlacementHistoryList.schoolID#)
                                </a>
                            </cfif>
                        </td>
                        <td width="17%" <cfif qGetPlacementHistoryList.hasPlaceRepIDChanged> class="placementMgmtChanged" </cfif> >
                            <cfif VAL(qGetPlacementHistoryList.placeRepID)>
                                <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistoryList.placeRepID#" target="_blank" title="More Information">
                                    #qGetPlacementHistoryList.placeFirstName# #qGetPlacementHistoryList.placeLastName# (###qGetPlacementHistoryList.placeRepID#)
                                </a>    
                            </cfif>
                        </td>
                        
                        <td width="17%" <cfif qGetPlacementHistoryList.hasAreaRepIDChanged> class="placementMgmtChanged" </cfif> >
                            <cfif VAL(qGetPlacementHistoryList.areaRepID)>
                                <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistoryList.areaRepID#" target="_blank" title="More Information">
                                    #qGetPlacementHistoryList.areaFirstName# #qGetPlacementHistoryList.areaLastName# (###qGetPlacementHistoryList.areaRepID#)
                                </a>
                            </cfif>
                        </td>
                        <cfif CLIENT.companyID neq 13>
                            <td width="17%" <cfif qGetPlacementHistoryList.hassecondVisitRepIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistoryList.secondVisitRepID)>
                                    <a href="../../index.cfm?curdoc=user_info&userID=#qGetPlacementHistoryList.secondVisitRepID#" target="_blank" title="More Information">    
                                        #qGetPlacementHistoryList.secondRepFirstName# #qGetPlacementHistoryList.secondRepLastName# (###qGetPlacementHistoryList.secondVisitRepID#)
                                    </a>
                                </cfif>
                            </td>
                        </cfif>
                        <td width="17%" <cfif qGetPlacementHistoryList.hasDoublePlacementIDChanged> class="placementMgmtChanged" </cfif> >
                            <cfif VAL(qGetPlacementHistoryList.doublePlacementID)>
                                <a href="../../index.cfm?curdoc=student_info&studentID=#qGetPlacementHistoryList.doublePlacementID#" target="_blank" title="More Information">
                                    #qGetPlacementHistoryList.doublePlacementFirstName# #qGetPlacementHistoryList.doublePlacementLastName# (###qGetPlacementHistoryList.doublePlacementID#)
                                </a>
                            </cfif>
                        </td>
                    </tr>
                    
                    <!--- Display Action History --->
                    <cfif qGetActionsHistory.recordCount>
                        <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                            <tr bgcolor="###iif(qGetPlacementHistoryList.currentrow MOD 2 ,DE("FFFFFF") ,DE("edeff4") )#">
                                <td class="reportTitleLeftClean" width="25%">Date</td>
                                <td class="reportTitleLeftClean" width="75%">Actions</td>
                            </tr>
                        </table>
                        
                        <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center">
                            <cfloop query="qGetActionsHistory">
                                <tr bgcolor="###iif(qGetActionsHistory.currentrow MOD 2 ,DE("edeff4") ,DE("FFFFFF") )#">
                                    <td valign="top" width="25%">#DateFormat(qGetActionsHistory.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetActionsHistory.dateCreated, 'hh:mm tt')# <!--- EST ---></td>
                                    <td width="75%">#qGetActionsHistory.actions#</td>
                                </tr>                        
                            </cfloop>
                        </table>
                    </cfif>
                     
                </table> 
                 
            </cfloop> 
    
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