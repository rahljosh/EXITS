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
    <cfparam name="URL.assignedID" default="" />
    <cfparam name="URL.historyID" default="" />
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0" />
    <cfparam name="FORM.action" default="" />
    <cfparam name="FORM.SubAction" default="" />
    <cfparam name="FORM.validationErrors" default="0" />
    <!--- Student --->
    <cfparam name="FORM.studentID" default="0" />
    <cfparam name="FORM.uniqueID" default="" />
    <cfparam name="FORM.assignedID" default="0" />
    <cfparam name="FORM.historyID" default="" />

    <cfscript>
		// Store Section on FORM Variable
		if ( LEN(URL.action) ) {
			FORM.action = URL.action;	
		}
	
		if ( VAL(URL.historyID) ) {
			FORM.historyID = URL.historyID;	
		}

		if ( LEN(URL.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;	
		}

		if ( LEN(URL.assignedID) ) {
			FORM.assignedID = URL.assignedID;	
		}
		
		// Get Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=FORM.uniqueID,assignedID=FORM.assignedID);
		
		// Get Student Arrival
		qGetArrival = APPLICATION.CFC.FLIGHTINFORMATION.getFlightInformation(studentID=qGetStudentInfo.studentID, programID=qGetStudentInfo.programID, flightType='arrival', flightLegOption='lastLeg');

		// Set a list of current reps assigned to student
		vCurrentUsersAssigned = '';
		vCurrentUsersAssigned = ListAppend(vCurrentUsersAssigned, qGetStudentInfo.areaRepID);
		vCurrentUsersAssigned = ListAppend(vCurrentUsersAssigned, qGetStudentInfo.placeRepID);
		
		// Get Program Information
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programID=qGetStudentInfo.programID);

		// Get Host Family Information
		qGetHostInfo = APPLICATION.CFC.HOST.getHosts(hostID=qGetStudentInfo.hostID);

		// Get Host Kids at Home
		qGetHostKidsAtHome = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetStudentInfo.hostID,liveAtHome='yes');

		// Get Available Schools based on area reps state
		qGetAvailableSchools = APPLICATION.CFC.SCHOOL.getSchools();
		
		// Get Available Reps
		qGetAvailableReps = APPLICATION.CFC.USER.getFieldUsers(
			userType=CLIENT.userType, 
			userID=CLIENT.userID, 
			includeUserIDs=vCurrentUsersAssigned);

		// Get Place Rep
		qGetPlaceRepInfo = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.placeRepID);
		
		// Get Area Rep
		qGetAreaRepInfo = APPLICATION.CFC.USER.getUsers(userID=qGetStudentInfo.areaRepID);

		// Get Available Double Placement
		qGetAvailableDoublePlacement = APPLICATION.CFC.STUDENT.getAvailableDoublePlacement(studentID=qGetStudentInfo.studentID);
		
		// Get Double Placement Info
		qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=qGetStudentInfo.doublePlace);	
		
		// Get Placement History
		qGetPlacementHistory = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID, assignedID=qGetStudentInfo.assignedID);
		
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
		
		if ( NOT VAL(qGetStudentInfo.schoolID) AND NOT VAL(qGetStudentInfo.areaRepID) AND NOT VAL(qGetStudentInfo.placeRepID) ) {
			
			vPlacementStatus = 'Unplaced';
		
		} else if ( VAL(qGetStudentInfo.schoolID) AND VAL(qGetStudentInfo.hostID) AND VAL(qGetStudentInfo.areaRepID) AND VAL(qGetStudentInfo.placeRepID) ) {

			vPlacementStatus = 'Complete';
			
		} else {

			vPlacementStatus = 'Incomplete';
			
		}
		
		// Set Default Images        
        vSchoolImage = 'school_1';
        vHostImage = 'host_1';
		vPlaceRepImage = 'place_1';
        vSuperRepImage = 'super_1';
        vDoublePlaceImage = 'double_1';
        vPaperworkImage = 'paperwork_1';
        vNotesImage = 'notes_1';
		
		// Placement Buttons - Placement Not Complete
		if ( NOT VAL(qGetStudentInfo.schoolID) AND ( VAL(qGetStudentInfo.hostID) OR VAL(qGetStudentInfo.areaRepID) OR VAL(qGetStudentInfo.placeRepID) ) ) {
        	vSchoolImage = 'school_2';
		}
		if ( NOT VAL(qGetStudentInfo.hostID) AND ( VAL(qGetStudentInfo.schoolID) OR VAL(qGetStudentInfo.areaRepID) OR VAL(qGetStudentInfo.placeRepID) ) ) {
        	vHostImage = 'host_2';
		}
		if ( NOT VAL(qGetStudentInfo.placeRepID) AND ( VAL(qGetStudentInfo.hostID) OR VAL(qGetStudentInfo.schoolID) OR VAL(qGetStudentInfo.areaRepID) ) ) {
        	vPlaceRepImage = 'place_2';
       	}
		if ( NOT VAL(qGetStudentInfo.areaRepID) AND ( VAL(qGetStudentInfo.hostID) OR VAL(qGetStudentInfo.schoolID) OR VAL(qGetStudentInfo.placeRepID) ) ) {
        	vSuperRepImage = 'super_2';
        }
		
		// Placement Buttons 
        if ( VAL(qGetStudentInfo.schoolID) ) {
			vSchoolImage = 'school_3';
        }
		if ( VAL(qGetStudentInfo.hostID) ) {
			vHostImage = 'host_3';
		}
		if ( VAL(qGetStudentInfo.placeRepID) ) {
			vPlaceRepImage = 'place_3';
        }
		if ( VAL(qGetStudentInfo.areaRepID) ) {
			vSuperRepImage = 'super_3';
        }
		if ( VAL(qGetStudentInfo.doubleplace) ) {
			vDoublePlaceImage = 'double_3';
        }
		// End of Set Default Images
		
		
		// Placement Notes
        if ( NOT LEN(qGetStudentInfo.placementNotes) ) {
			vNotesImage = 'notes_1';		 
		} else {
			vNotesImage = 'notes_3';
		}
		// End of Placement Notes

		// Paperwork
        if ( VAL(qGetStudentInfo.hostID) ) {
			
		
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
            width="90%"
            filePath="../../"
        />    

        <table width="90%" cellpadding="4" cellspacing="0" class="section" align="center">      
            <tr class="reportCenterTitle">
                <th align="center" class="placementTopLinks">
                	<a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#">
                    	#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)
                    </a>
                </th>
            </tr>
		</table>
        
        <table width="90%" cellpadding="4" cellspacing="0" class="section" align="center" style="background-color:##edeff4; padding:5px 0px 5px 0px;">  
            <tr>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#">
                        <img src="../../pics/place_menu/#vSchoolImage#.gif" alt="High School" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#">
                        <img src="../../pics/place_menu/#vHostImage#.gif" alt="Host Family" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#">
                        <img src="../../pics/place_menu/#vPlaceRepImage#.gif" alt="Placing Representative" border="0">
                   </a> 
                </td>		
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#">
                        <img src="../../pics/place_menu/#vSuperRepImage#.gif" alt="Supervising Representative" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#">
                        <img src="../../pics/place_menu/#vDoublePlaceImage#.gif" alt="Double Placement" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#&action=paperwork">
                        <img src="../../pics/place_menu/#vPaperworkImage#.gif" alt="Placement Paperwork" border="0">
                    </a>
                </td>
                <td width="12.5%" align="center">
                    <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#&action=placementNotes">
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
                        	PLACEMENT HISTORY - #DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')#
                        <cfelse>
                        	#APPLICATION.CFC.UDF.convertToOrdinal(qGetPlacementHistory.recordCount)# PLACEMENT - #DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')# (CURRENT)
                        </cfif>

                        <div style="float:right; padding-right:5px; width:170px;">
                            <a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#&action=paperwork">[ View Paperwork ]</a>
                        </div>
                    </th>
                </tr>
            </table>
            
            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center"> 
                <tr bgcolor="##edeff4">
                    <td class="reportTitleLeftClean" width="17%">School</td>
                    <td class="reportTitleLeftClean" width="17%">Host Family</td>
                    <td class="reportTitleLeftClean" width="17%">Placing Rep.</td>
                    <td class="reportTitleLeftClean" width="17%">Supervising Rep.</td>
                    <td class="reportTitleLeftClean" width="17%">Double Placement</td>
                  	<cfif ListFind("1,2,3",CLIENT.userType)>
                        <td class="reportTitleLeftClean" width="15%">Amount Owed</td>
                   	<cfelse>
						<td class="reportTitleLeftClean" width="15%"></td>
					</cfif>
                </tr>
			</table>
            
            <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center"> 
                <cfscript>
                    // Get Actions History
                    qGetActionsHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
                        applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
                        foreignTable='smg_hosthistory',
                        foreignID=qGetPlacementHistory.historyID,
                        sortBy='dateCreated',
                        sortOrder='DESC'
                    );
                </cfscript>

                <tr bgcolor="##FFFFFF">
                    <td width="17%" <cfif qGetPlacementHistory.hasSchoolIDChanged> class="placementMgmtChanged" </cfif> >
						<cfif VAL(qGetPlacementHistory.schoolID)>                            
                            #qGetPlacementHistory.schoolName# (###qGetPlacementHistory.schoolID#)
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.hostID)>
                            #qGetPlacementHistory.fatherFirstName#
                            <cfif LEN(qGetPlacementHistory.fatherFirstName) AND LEN(qGetPlacementHistory.motherFirstName)>
                            	&
                          	</cfif>
                            #qGetPlacementHistory.motherFirstName#
                            #qGetPlacementHistory.familyLastName# (###qGetPlacementHistory.hostID#)
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasPlaceRepIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.placeRepID)>
                            #qGetPlacementHistory.placeFirstName# #qGetPlacementHistory.placeLastName# (###qGetPlacementHistory.placeRepID#)
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasAreaRepIDChanged> class="placementMgmtChanged" </cfif> >
                        <cfif VAL(qGetPlacementHistory.areaRepID)>
                            #qGetPlacementHistory.areaFirstName# #qGetPlacementHistory.areaLastName# (###qGetPlacementHistory.areaRepID#)
                        </cfif>
                    </td>
                    <td width="17%" <cfif qGetPlacementHistory.hasDoublePlacementIDChanged> class="placementMgmtChanged" </cfif> >
						<cfif VAL(qGetPlacementHistory.doublePlacementID)>
                            #qGetPlacementHistory.doublePlacementFirstName# #qGetPlacementHistory.doublePlacementLastName# (###qGetPlacementHistory.doublePlacementID#)
                        </cfif>
                    </td>
                    <td width="15%" <cfif qGetPlacementHistory.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                    	<cfif ListFind("1,2,3",CLIENT.userType)>
							<cfif qGetPlacementHistory.isRelocation EQ 1>
                                <cfscript>
									if (isDate(qGetPlacementHistory.datePlaced)) {
										if (DatePart('d',NOW()) GTE 15) {
											date = CreateDate(DatePart('yyyy',NOW()),DatePart('m',NOW()),15);
										} else {
											if (DatePart('m',NOW()) EQ 1) {
												date = CreateDate(DatePart('yyyy',NOW())-1,12,15);
											} else {
												date = CreateDate(DatePart('yyyy',NOW()),DatePart('m',NOW())-1,15);
											}
										}
										days = DateDiff('d',date,qGetPlacementHistory.datePlaced);
										if (days GTE 0) {
											amountOwed = "$" & DecimalFormat(qGetPlacementHistory.hostFamilyRate - ((days/30)*qGetPlacementHistory.hostFamilyRate));
										} else {
											amountOwed = "$" & qGetPlacementHistory.hostFamilyRate;
										}
									} else {
										amountOwed = "Missing placement date.";	
									}
                                </cfscript>
                                #amountOwed#
                            </cfif>
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
                                	ORIGINAL PLACEMENT - #DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')#
                                <cfelse>
                                	#APPLICATION.CFC.UDF.convertToOrdinal(vCardinalCount)# PLACEMENT - #DateFormat(qGetPlacementHistory.datePlaced, 'mm/dd/yyyy')#
                                </cfif>
                                
                                <div style="float:right; padding-right:5px; width:170px;">
									<cfif VAL(qGetPlacementHistory.hostID)>
                                    	<a href="#CGI.SCRIPT_NAME#?uniqueID=#FORM.uniqueID#&assignedID=#FORM.assignedID#&action=paperworkHistory&historyID=#qGetPlacementHistory.historyID#">[ View Paperwork History ]</a>
                                    <cfelse>
                                        &nbsp;                            
                                    </cfif>
                                </div>
                            </th>
                        </tr>
                    </table>
                    
                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("FFFFFF") ,DE("edeff4") )#">
                            <td class="reportTitleLeftClean" width="17%">School</td>
                            <td class="reportTitleLeftClean" width="17%">Host Family</td>
                            <td class="reportTitleLeftClean" width="17%">Placing Rep.</td>
                            <td class="reportTitleLeftClean" width="17%">Supervising Rep.</td>
                            <td class="reportTitleLeftClean" width="17%">Double Placement</td>
                            <cfif ListFind("1,2,3",CLIENT.userType)>
                                <td class="reportTitleLeftClean" width="15%">Amount Owed</td>
                            <cfelse>
                                <td class="reportTitleLeftClean" width="15%"></td>
                            </cfif>
                        </tr>
    				</table>
                    
                    <table width="90%" border="0" cellpadding="4" cellspacing="0" class="section paperwork" align="center"> 
                        <cfscript>
                            // Get Actions History
                            qGetActionsHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
                                applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
                                foreignTable='smg_hosthistory',
                                foreignID=qGetPlacementHistory.historyID,
                                sortBy='dateCreated',
                                sortOrder='DESC'
                            );
                        </cfscript>
    
                        <tr bgcolor="###iif(qGetPlacementHistory.currentrow MOD 2 ,DE("edeff4") ,DE("FFFFFF") )#">
                            <td width="17%" <cfif qGetPlacementHistory.hasSchoolIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.schoolID)>                            
                                    #qGetPlacementHistory.schoolName# (###qGetPlacementHistory.schoolID#)
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.hostID)>
                                	#qGetPlacementHistory.fatherFirstName#
									<cfif LEN(qGetPlacementHistory.fatherFirstName) AND LEN(qGetPlacementHistory.motherFirstName)>
                                        &
                                    </cfif>
                                    #qGetPlacementHistory.motherFirstName#
                                    #qGetPlacementHistory.familyLastName# (###qGetPlacementHistory.hostID#)
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasPlaceRepIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.placeRepID)>
                                    #qGetPlacementHistory.placeFirstName# #qGetPlacementHistory.placeLastName# (###qGetPlacementHistory.placeRepID#)
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasAreaRepIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.areaRepID)>
                                    #qGetPlacementHistory.areaFirstName# #qGetPlacementHistory.areaLastName# (###qGetPlacementHistory.areaRepID#)
                                </cfif>
                            </td>
                            <td width="17%" <cfif qGetPlacementHistory.hasDoublePlacementIDChanged> class="placementMgmtChanged" </cfif> >
                                <cfif VAL(qGetPlacementHistory.doublePlacementID)>
                                    #qGetPlacementHistory.doublePlacementFirstName# #qGetPlacementHistory.doublePlacementLastName# (###qGetPlacementHistory.doublePlacementID#)
                                </cfif>
                            </td>
                            <td width="15%" <cfif qGetPlacementHistory.hasHostIDChanged> class="placementMgmtChanged" </cfif> >
                            	<cfif ListFind("1,2,3",CLIENT.userType)>
									<cfif qGetPlacementHistory.isRelocation[1] EQ 1>
                                        <cfscript>
											if (isDate(qGetPlacementHistory.datePlaced[currentrow-1]) AND isDate(qGetPlacementHistory.datePlaced) ) {
												if (DatePart('d',NOW()) GTE 15) {
													date = CreateDate(DatePart('yyyy',NOW()),DatePart('m',NOW()),15);
												} else {
													if (DatePart('m',NOW()) EQ 1) {
														date = CreateDate(DatePart('yyyy',NOW())-1,12,15);
													} else {
														date = CreateDate(DatePart('yyyy',NOW()),DatePart('m',NOW())-1,15);
													}
												}
												days = DateDiff('d',date,qGetPlacementHistory.datePlaced[currentrow-1]);
												if (days GTE 0) {
													daysNotHere = DateDiff('d',date,qGetPlacementHistory.datePlaced);
													if (daysNotHere GTE 0) {
														amountOwed = "$" & DecimalFormat(((days-daysNotHere)/30)*qGetPlacementHistory.hostFamilyRate);
													} else {
														amountOwed = "$" & DecimalFormat((days/30)*qGetPlacementHistory.hostFamilyRate);
													}
												} else {
													amountOwed = 0;
												}
											} else {
												amountOwed = "Missing placement date.";
											}
                                        </cfscript>
                                        <cfif amountOwed NEQ 0>
                                            #amountOwed#
                                        </cfif>                                    
                                    </cfif>
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
                                        <td valign="top" width="25%">#DateFormat(qGetActionsHistory.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetActionsHistory.dateCreated, 'hh:mm tt')#</td>
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
            filePath="../../"
        />
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
        filePath="../../"
    />

</cfoutput>