<!--- ------------------------------------------------------------------------- ----
	
	File:		toDoList.cfm
	Author:		Marcus Melo
	Date:		12/18/2012
	Desc:		Break down of host family application

	Updated:	
	
	PS:
	/hostApplication calls a virtual folder for (Host Family Application)
	hostApplication calls a local folder
					
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.seasonID" default="0">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.repNotes" default="">
    
    <!----Delete the school acceptance letter---->
	<cfif isDefined('url.deleteSchoolAccept')>
		<cfquery name="deleteSchoolAccept" datasource="#application.dsn#">
            UPDATE document
            SET isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
            AND hashID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.key#">
        </cfquery>
        <cflocation url="index.cfm?curdoc=hostApplication/toDoList&hostID=#url.hostid#">
	</cfif>
    
    <cfscript>	
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		// Get seasons that this host has records for
		qGetSeasonsForHost = APPLICATION.CFC.HOST.getSeasonsForHost(hostID=FORM.hostID);
		
		// Variable for the most recent season
		vSelectedSeason = ListLast(ValueList(qGetSeasonsForHost.seasonID));
		
		// Check if a selected season has been passed in
		if (VAL(URL.seasonID)) {
			vSelectedSeason = URL.seasonID;	
		}
		
		// Get Host Application Information
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID,seasonID=vSelectedSeason);
		
		// Get all seasons that this host has records for
		qGetAllSeasonsForHost = APPLICATION.CFC.HOST.getSeasonsForHost(hostID=FORM.hostID);
		
		// Get Application Approval History
		qGetApprovalHistory = APPLICATION.CFC.HOST.getApplicationApprovalHistory(hostID=qGetHostInfo.hostID, whoViews=CLIENT.userType,seasonID=vSelectedSeason);
		
		// Get Students associated with this host
		qGetCurrentStudents = APPLICATION.CFC.STUDENT.getCurrentStudentsByHost(hostID=qGetHostInfo.hostID,seasonID=vSelectedSeason);
		
		// Get References
		qGetReferences = APPLICATION.CFC.HOST.getReferences(hostID=qGetHostInfo.hostID,seasonID=vSelectedSeason);

		// Get Confidential Visit Form
		qGetConfidentialVisitForm = APPLICATION.CFC.PROGRESSREPORT.getVisitInformation(hostID=FORM.hostID,reportType=5,seasonID=vSelectedSeason);
		
		// Get Host Family Orientation
		qGetHostFamilyOrientation = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",
			foreignID=FORM.hostID,
			documentGroup="hostOrientation",
			seasonID=vSelectedSeason
		);

		// This returns the approval fields for the logged in user
		stCurrentUserFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames();
		
		if ( qGetHostInfo.totalFamilyMembers GT 1 ) {
			vRequiredApprovedReferences = 2;
		} else {
			vRequiredApprovedReferences = 4;
		}
		
		// Store if App has been denied
		vHasAppBeenDeniedByOneLevelUpUser = false;
		
		// This Returns who is the next user approving / denying the report
		stUserOneLevelUpInfo = APPLICATION.CFC.USER.getUserOneLevelUpInfo(currentUserType=qGetHostInfo.applicationStatusID,regionalAdvisorID=qGetHostInfo.regionalAdvisorID);
		
		// This returns the fields that need to be checked
		stOneLevelUpFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames(userType=stUserOneLevelUpInfo.userType);
		
		// Store the non-required sections of the app (they do not effect approval or denial of the entire app)
		vNonRequiredSections = "15,19,20";

		// Param Form Variables - Approval History
		For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
			param name="FORM.sectionStatus#qGetApprovalHistory.ID[i]#_#qGetApprovalHistory.studentID[i]#" default="";
			param name="FORM.sectionNotes#qGetApprovalHistory.ID[i]#_#qGetApprovalHistory.studentID[i]#" default="";
			
			// Check if level app has denied any of the sections
			if ( qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][i] EQ 'denied' AND NOT ListFind(vNonRequiredSections,qGetApprovalHistory.ID[i]) ) {
				vHasAppBeenDeniedByOneLevelUpUser = true;
			}
		}
		
		// Param Form Variables - Reference Approval History
		For ( i=1; i LTE qGetReferences.recordCount; i++ ) {
			param name="FORM.referenceStatus#qGetReferences.ID[i]#" default="";
			param name="FORM.referenceNotes#qGetReferences.ID[i]#" default="";
		}
		
		// FORM Submitted
		if ( VAL(FORM.submitted) ) {
			
			// Initialize variables
			vApproveApp = true;
			vSendAppBack = false;
			vAppStatus = qGetHostInfo.applicationStatusID;
			
			// Check if any section was denied and no reason was given
			For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
				if ( 
					FORM["sectionStatus" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]] EQ 'denied' 
					AND NOT LEN(FORM["sectionNotes" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]]) ) {
						SESSION.formErrors.Add("#qGetApprovalHistory.description[i]# - Please enter a reason for denying this section");
				}
			}
			
			// Check if any references were denied and no reason was given
			For ( i=1; i LTE qGetReferences.recordCount; i++ ) {
				if ( VAL(qGetReferences.ID[i]) ) {
					if ( FORM["referenceStatus" & qGetReferences.ID[i]] EQ 'denied' AND NOT LEN(FORM["referenceNotes" & qGetReferences.ID[i]]) ) {
						SESSION.formErrors.Add("Reference for #qGetReferences.firstname[i]# #qGetReferences.lastname[i]# - Please enter a reason for denying this report");
					}
				}
			}
			
			// Only continue if there are no errors
			if (NOT SESSION.formErrors.length()) {
				
				// Update Representative Notes
				APPLICATION.CFC.HOST.updateRepNotes(hostID=qGetHostInfo.hostID,seasonID=vSelectedSeason,repNotes=FORM.repNotes);
				
				// Update all sections of the app - Do not approve app if any of the non-required sections are denied
				For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
					vAction = FORM["sectionStatus" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]];
					vID = qGetApprovalHistory.ID[i];
					APPLICATION.CFC.HOST.updateSectionStatus(
						hostID=FORM.hostID,
						studentID=qGetApprovalHistory.studentID[i],
						itemID=vID,
						seasonID=vSelectedSeason,
                        action=vAction,
                        notes=FORM["sectionNotes" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]],
						areaRepID=qGetHostInfo.areaRepresentativeID,
						regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
						regionalManagerID=qGetHostInfo.regionalManagerID
					);
					if (vAction EQ "denied" AND NOT ListFind(vNonRequiredSections,qGetApprovalHistory.ID[i])) {
						vApproveApp = false;
						vSendAppBack = true;
					}
					// Get the history records for updating old fields (the first returned record is the current record)
					qGetPlacementHistory = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetApprovalHistory.studentID[i]);
					vHasComplianceAccess = APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="studentComplianceCheckList");
					// Update old fields if neccessary
					if (FORM["sectionStatus" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]] EQ 'approved') {
						if (vID EQ 15) {
							if (NOT VAL(qGetPlacementHistory.doc_school_accept_date) AND NOT VAL(qGetPlacementHistory.compliance_school_accept_date) AND vHasComplianceAccess) {
								APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),doc_school_accept_date=NOW(),compliance_school_accept_date=NOW());
							} else if (NOT VAL(qGetPlacementHistory.doc_school_accept_date)) {
								APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),doc_school_accept_date=NOW());
							}
						} else if (vID EQ 20) {
							if (NOT VAL(qGetPlacementHistory.stu_arrival_orientation) AND NOT VAL(qGetPlacementHistory.compliance_stu_arrival_orientation) AND vHasComplianceAccess) {
								APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),stu_arrival_orientation=NOW(),compliance_stu_arrival_orientation=NOW());
							} else if (NOT VAL(qGetPlacementHistory.stu_arrival_orientation)) {
								APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),stu_arrival_orientation=NOW());
							}
						} else if (vID EQ 14 OR vID EQ 19) {
							For ( j=1; j LTE qGetCurrentStudents.recordCount; j++ ) {
								qGetPlacementHistory = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetCurrentStudents.studentID[j]);
								if (vID EQ 14) {
									if (NOT VAL(qGetPlacementHistory.doc_conf_host_rec) AND NOT VAL(qGetPlacementHistory.compliance_conf_host_rec) AND vHasComplianceAccess) {
										APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),doc_conf_host_rec=NOW(),compliance_conf_host_rec=NOW());
									} else if (NOT VAL(qGetPlacementHistory.doc_conf_host_rec)) {
										APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),doc_conf_host_rec=NOW());
									}
								} else {
									if (NOT VAL(qGetPlacementHistory.host_arrival_orientation) AND NOT VAL(qGetPlacementHistory.compliance_host_arrival_orientation) AND vHasComplianceAccess) {
										APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),host_arrival_orientation=NOW(),compliance_host_arrival_orientation=NOW());
									} else if (NOT VAL(qGetPlacementHistory.host_arrival_orientation)) {
										APPLICATION.CFC.STUDENT.updateOldHostHistoryFields(historyID=VAL(qGetPlacementHistory.historyID),host_arrival_orientation=NOW());
									}
								}
							}
						}
					}
				}
				
				// Update all references in the app - Do not approve if any of the references are denied
				For ( i=1; i LTE qGetReferences.recordCount; i++ ) {
					vAction = FORM["referenceStatus" & qGetReferences.ID[i]];
					APPLICATION.CFC.HOST.updateReferenceStatus(
						ID=qGetReferences.ID[i],
						hostID=FORM.hostID,
						fk_referencesID=qGetReferences.fk_referencesID[i],
                        action=vAction,
                        notes=FORM["referenceNotes" & qGetReferences.ID[i]],
						areaRepID=qGetHostInfo.areaRepID,
						regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
						regionalManagerID=qGetHostInfo.regionalManagerID,
						seasonID=vSelectedSeason
					);
					if (vAction EQ "denied") {
						vApproveApp = false;
						vSendAppBack = true;
					}
				}
				
				// Make sure there are at least the required number of references - Do not approve the app otherwise
				qGetApprovedReferences = APPLICATION.CFC.HOST.getReferences(hostID=qGetHostInfo.hostID, getCurrentUserApprovedReferences=CLIENT.userType);
				if (vRequiredApprovedReferences GT qGetApprovedReferences.recordCount) {
					vApproveApp = false;	
				}
				
				// Check if the confidential host family visit form is submitted - Do not approve the app if it is missing
				if ( NOT qGetConfidentialVisitForm.recordCount ) {
					vApproveApp = false;
				}
				
				// Approve / deny the application
				if (vApproveApp AND CLIENT.userType LTE vAppStatus AND vAppStatus GT 3) {
					For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
						vID = qGetApprovalHistory.ID[i];
						if (NOT ListFind(vNonRequiredSections,vID)) {
							APPLICATION.CFC.HOST.updateSectionDateFields(
								hostID=FORM.hostID,
								seasonID=vSelectedSeason,
								itemID=vID
							);
						}
					}
					For ( i=1; i LTE qGetReferences.recordCount; i++ ) {
						APPLICATION.CFC.HOST.updateSectionDateFields(
							hostID=FORM.hostID,
							seasonID=vSelectedSeason,
							ID=qGetReferences.ID[i]
						);
					}
					stReturnMessage = APPLICATION.CFC.HOST.submitApplication(
						hostID=qGetHostInfo.hostID,
						seasonID=vSelectedSeason,
						action="approved"
					);
					SESSION.pageMessages.Add(stReturnMessage.pageMessages);
					if ( LEN(stReturnMessage.formErrors) ) {
						SESSION.formErrors.Add(stReturnMessage.formErrors);	
					}
					location("#CGI.SCRIPT_NAME#?curdoc=hostApplication/listOfApps&status=#qGetHostInfo.applicationStatusID#", "no");
				} else if (vSendAppBack AND CLIENT.userType LTE vAppStatus) {
					stReturnMessage = APPLICATION.CFC.HOST.submitApplication(
						hostID=qGetHostInfo.hostID,
						seasonID=vSelectedSeason,
						action="denied"
					);
					SESSION.pageMessages.Add(stReturnMessage.pageMessages);
					if ( LEN(stReturnMessage.formErrors) ) {
						SESSION.formErrors.Add(stReturnMessage.formErrors);	
					}
					location("#CGI.SCRIPT_NAME#?curdoc=hostApplication/listOfApps&status=#qGetHostInfo.applicationStatusID#", "no");
				} else {
					location("#CGI.SCRIPT_NAME#?curdoc=hostApplication/toDoList&hostID=#qGetHostInfo.hostID#", "no");	
				}
				
			}
		
		// FORM Not Submitted
		} else {
			
			// Set the repNotes Form value
			FORM.repNotes = qGetHostInfo.repNotes;
			
			// Set Default Form Values Based on Current User
			For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
				
				// Set Default Form Name
				FORM["sectionStatus" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]] = qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][i];
				FORM["sectionNotes" & qGetApprovalHistory.ID[i] & "_" & qGetApprovalHistory.studentID[i]] = qGetApprovalHistory[stCurrentUserFieldSet.notesFieldName][i];
			}

			// Set Default Form Values - Reference Approval History
			For ( i=1; i LTE qGetReferences.recordCount; i++ ) {
				FORM["referenceStatus" & qGetReferences.ID[i]] = qGetReferences[stCurrentUserFieldSet.statusFieldName][i];
				FORM["referenceNotes" & qGetReferences.ID[i]] = qGetReferences[stCurrentUserFieldSet.notesFieldName][i];
			}

		}
    </cfscript>
    
</cfsilent>

<script type="text/javascript">
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		$(".jQueryModal").colorbox( {
			width:"80%", 
			height:"95%", 
			iframe:true,
			overlayClose:false,
			escKey:false			
		});	
		
		//Examples of how to assign the ColorBox event to elements
		$(".jQueryModalRefresh").colorbox( {
			width:"80%", 
			height:"95%", 
			iframe:true, 
			overlayClose:false,
			escKey:false, 
			onClosed:function(){ window.location.reload(); } 
		});

	});
	
	var toggleReason = function(selectedStatus,sectionID) { 
		// Check if denied is checked
		if ( selectedStatus == "denied" ) {
			// Display Field
			$(".reasonForDenial" + sectionID).fadeIn();
		} else {
			// Clear Field and Hide Reason
			$("#sectionNotes" + sectionID).val("");
			$(".reasonForDenial" + sectionID).fadeOut();
		}
	}
	
	var toggleReferenceReason = function(selectedStatus,referenceID) { 
		// Check if denied is checked
		if ( selectedStatus == "denied" ) {
			// Display Field
			$(".referenceReasonForDenial" + referenceID).fadeIn();
		} else {
			// Clear Field and Hide Reason
			$("#referenceNotes" + referenceID).val("");
			$(".referenceReasonForDenial" + referenceID).fadeOut();
		}
	}
	
	// Check All Approve / Deny Options
	var jsCheckAll = function(className) { 
		$("." + className).attr('checked',true).trigger("click");;
	}
	
	function reloadWithSelectedSeason() {
		var newURL = document.URL.toString();
		if (newURL.indexOf("&seasonID=") > 0) {
			newURL = newURL.substring(0,newURL.indexOf("&seasonID="));
		}
		newURL = newURL + "&seasonID=" + $("#seasonID").val();
		window.location.href = newURL;
	}
</script>

<cfoutput>

	<!--- Host Family Summary --->
    <div class="rdholder"> 
    
        <div class="rdtop"> 
            <span class="rdtitle">Summary</span> 
        </div> <!-- end top --> 
        
        <div class="rdbox">
            <table width="100%" cellpadding="2" cellspacing="0" align="center">
            	<tr>
            		<th width="18%" align="left">Host Family</th>
                    <th width="13%" align="left">Area Representative</th>
                    <th width="13%" align="left">Regional Advisor</th>
                    <th width="13%" align="left">Regional Manager</th>
                    <th width="13%" align="left">Facilitator</th>
                    <th width="16%" align="left">Status</th>
            		<th width="14%" align="center">Actions</th>
            	</tr>
                <tr>
                    <td valign="top">
                    	<cfscript>
							vDisplayName = "";
							if (qGetHostInfo.otherHostParent EQ "none") {
								vDisplayName = APPLICATION.CFC.HOST.displayHostFamilyName(
									fatherFirstName="",
									fatherLastName="",
									motherFirstName=qGetHostInfo.motherFirstName,
									motherLastName=qGetHostInfo.motherLastName);
							} else {
								vDisplayName = APPLICATION.CFC.HOST.displayHostFamilyName(
									fatherFirstName=qGetHostInfo.fatherFirstName,
									fatherLastName=qGetHostInfo.fatherLastName,
									motherFirstName=qGetHostInfo.motherFirstName,
									motherLastName=qGetHostInfo.motherLastName);
							}
						</cfscript>
                    	#vDisplayName# (###qGetHostInfo.hostid#) <br />
                        #qGetHostInfo.city#, #qGetHostInfo.state# #qGetHostInfo.zip# <br />  
                        #qGetHostInfo.email#
                    </td>
                    <td valign="top">
                    	#qGetHostInfo.areaRepresentative# <br />
						<a href="mailto:#qGetHostInfo.areaRepresentativeEmail#">#qGetHostInfo.areaRepresentativeEmail#</a>
                    </td>
                    <td valign="top">
                    	#qGetHostInfo.regionalAdvisor# <br />
                        <a href="mailto:#qGetHostInfo.regionalAdvisorEmail#">#qGetHostInfo.regionalAdvisorEmail#</a>
                    </td>
                    <td valign="top">
                    	#qGetHostInfo.regionalManager# <br />
                        <a href="mailto:#qGetHostInfo.regionalManagerEmail#">#qGetHostInfo.regionalManagerEmail#</a>
                    </td>
                    <td valign="top">
                    	#qGetHostInfo.facilitator# <br />
                        <a href="mailto:#qGetHostInfo.facilitatorEmail#">#qGetHostInfo.facilitatorEmail#</a>
                    </td>
                    <td valign="top">
						<cfif isDate(qGetHostInfo.dateSent)>
                        	Date Created: #DateFormat(qGetHostInfo.dateSent, 'mm/dd/yyyy')# <br />
                        </cfif>

                    	<!--- App has been denied, display message --->
                    	<cfif vHasAppBeenDeniedByOneLevelUpUser>
                        	#stUserOneLevelUpInfo.description# has denied one or more sections.
                        <cfelse>

                            <cfswitch expression="#qGetHostInfo.applicationStatusID#">
                                
                                <cfcase value="9">
                                    Application Created
                                </cfcase>
                            
                                <cfcase value="8">
                                    Host Family Filling it out
                                </cfcase>
    
                                <cfcase value="7">
                                    Submitted to Area Representative - Pending Approval
                                </cfcase>
    
                                <cfcase value="6">
                                    Submitted to Regional Advisor - Pending Approval
                                </cfcase>
    
                                <cfcase value="5">
                                    Submitted to Regional Manager - Pending Approval
                                </cfcase>
    
                                <cfcase value="4">
                                    Submitted to Headquarters - Pending Approval
                                </cfcase>
                                
                                <cfcase value="1,2,3">
                                    Approved by Headquarters
                                </cfcase>
                            
                            </cfswitch>
                        
                        </cfif>
                    </td>                    
                    <td valign="top" align="center">
                        <a class="jQueryModal" href="/hostApplication/index.cfm?uniqueID=#qGetHostInfo.uniqueID#&season=#vSelectedSeason#&userID=#CLIENT.userID#" title="View Complete Application"><img src="pics/buttons/openApplication.png" border="0"></a>
                        <br/>
                        <cfif CLIENT.userType LTE 4> 
                            <a class="jQueryModal" href="hostApplication/viewPDF.cfm?hostID=#qGetHostInfo.hostID#&pdf&reportType=office&seasonID=#vSelectedSeason#" title="Print Application">
                                <img src="pics/buttons/printOffice.png">
                            </a>
                            <br/>
                        </cfif>
                        <a class="jQueryModal" href="hostApplication/viewPDF.cfm?hostID=#qGetHostInfo.hostID#&pdf&reportType=agent&seasonID=#vSelectedSeason#" title="Print Application">
                            <img src="pics/buttons/printAgent.png">
                        </a>
                    </td>
            	</tr>
            </table>
        </div>
        
        <div class="rdbottom"></div> <!-- end bottom --> 
        
	</div>
	
    <form name="approveApplication" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
    	<input type="hidden" name="submitted" value="1" />
    	<input type="hidden" name="hostID" value="#qGetHostInfo.hostID#" />
    
		<!--- To Do List---->
        <div class="rdholder"> 
        
            <div class="rdtop"> 
                <span class="rdtitle">Host Family Application</span>
                <b>SEASON: </b>
                <select name="seasonID" id="seasonID" onchange="reloadWithSelectedSeason()">
                	<cfloop query="qGetAllSeasonsForHost">
                    	<option value="#seasonID#" <cfif seasonID EQ vSelectedSeason>selected="selected"</cfif>>#season#</option>
                    </cfloop>
                </select>
                <a href="?curdoc=hostApplication/listOfApps&status=#qGetHostInfo.applicationStatusID#" class="floatRight"><img src="pics/buttons/back.png" border="0" /></a>
            </div> <!-- end top --> 
    
            <div class="rdbox">
            
				<!--- Page Messages --->
                <gui:displayPageMessages 
                    pageMessages="#SESSION.pageMessages.GetCollection()#"
                    messageType="divOnly"
                    width="90%"
                    />
                
                <!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="divOnly"
                    width="90%"
                    />
                
                <table cellpadding="4" cellspacing="0" align="center">
                    <tr>
                        <td valign="center"><img src="pics/information.png" width="16" heigh="16"> No Action Required</td>
                        <td valign="center"><img src="pics/warning.png" width="16" heigh="16"> Approval Required</td>
                        <td valign="center"><img src="pics/valid.png" width="16" heigh="16"> Section Approved</td> 
                        <td valign="center"><img src="pics/error.gif" width="16" heigh="16"> Section Denied</td>
                    </tr>
                 </table>
            
                <table width=100% cellpadding="4" cellspacing="0" align="center">
                    <tr bgcolor="##1b99da">
                        <td width="5%"><h2 style="color:##FFFFFF;">Status</h2></td>
                        <td width="14%"><h2 style="color:##FFFFFF;">Section</h2></td>
                        <td width="25%">
                            <h2 style="color:##FFFFFF;">Actions</h2>
                            <span style="color:##FFFFFF;"> 
                                [ <a href="##" onclick="jsCheckAll('approveOption')" style="color:##FFFFFF;">Approve All</a> 
                                &nbsp; | &nbsp;
                                <a href="##" onclick="jsCheckAll('denyOption')" style="color:##FFFFFF;">Deny All</a> ] 
                            </span>
                        </td>
                        <td width="14%"><h2 style="color:##FFFFFF;">Area Representative</h2></td>
                        <td width="14%"><h2 style="color:##FFFFFF;">Regional Advisor</h2></td>
                        <td width="14%"><h2 style="color:##FFFFFF;">Regional Manager</h2></td>
                        <td width="14%"><h2 style="color:##FFFFFF;">Compliance</h2></td>
                        <td></td>
                    </tr>
                                       
                    <cfloop query="qGetApprovalHistory">
                    
                        <cfscript>
                            // Set Links
							
							// Host Visit Report / Second Visit Report - No link, text only
                            if ( ListFind("14,15,19,20", qGetApprovalHistory.ID) ) {
								vSetDescLink = '#qGetApprovalHistory.description#';
							// Set Up Link for HF section
							} else { 
                                vSetDescLink = '<a href="/hostApplication/index.cfm?uniqueID=#qGetHostInfo.uniqueID#&season=#vSelectedSeason#&section=#qGetApprovalHistory.section#&userID=#CLIENT.userID#" title="Click to view item" class="jQueryModal">#qGetApprovalHistory.description#</a>';
                            }
							
							// Block approval of forms that require a student
							if ( qGetApprovalHistory.isStudentRequired ) {							
								vIsSectionBlocked = true;
							} else {
								vIsSectionBlocked = false;
							}
                        </cfscript>
                        
                        <tr <cfif qGetApprovalHistory.currentRow MOD 2> bgcolor="##F7F7F7"</cfif>>
                            <td>
                            	
                                <cfif ListFind(qGetApprovalHistory.isRequiredForApproval, CLIENT.userType)>
                                    
                                    <cfif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'approved'>
                                        <!--- Approved --->
                                        <img src="pics/valid.png" width="16" heigh="16">
                                    <cfelseif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'denied'>
                                        <!--- Denied --->
                                        <img src="pics/error.gif" width="16" heigh="16">
									<cfelse>
                                        <!--- Pending --->
                                        <img src="pics/warning.png" width="16" heigh="16">
                                    </cfif>
                                    
                                <cfelse>
                                
                                    <img src="pics/information.png" width="16" heigh="16">
                                    
                                </cfif>
                                
                            </td>
                            <td>#vSetDescLink#</td>
                            <td>
                            	<cfscript>
									// Holds the student ID if there is one for this approval field
									vCurrentStudent = qGetApprovalHistory.studentID;
									
									qGetSchoolAcceptance = APPLICATION.CFC.UDF.getVirtualFolderDocuments(
										documentType=47,
										studentID=vCurrentStudent,
										hostID=FORM.hostID
									);
									
									qGetStudentOrientation = APPLICATION.CFC.UDF.getVirtualFolderDocuments(
										documentType=49,
										studentID=vCurrentStudent			
									);
								</cfscript>
                            	
                            	<!--- Host Family still filling out --->
								<cfif ListFind("9,8", qGetHostInfo.applicationStatusID) AND NOT listFind("14,15", qGetApprovalHistory.ID)>
                                    
                                    <font color="##CCCCCC"><em>Application has NOT been submitted</em></font>
                                
                                <!--- Previously approved sections --->    
								<cfelseif qGetHostInfo.applicationStatusID LT CLIENT.userType>
									
                                    <font color="##CCCCCC"><em>Previously Approved</em></font>
                                    <!--- This will automatically approve items in case upper lever has approved them | In the future we can give the approval/deny option --->
									<input type="hidden" name="sectionStatus#qGetApprovalHistory.ID#" value="approved" /> 
                                    
                                <!--- Approve/Deny Options --->      
								<cfelseif qGetHostInfo.applicationStatusID GTE CLIENT.userType>
                                    
                                    <cfscript>
										// Only Display approval option if there is a school acceptance and a confidential host visit report
										vDisplayApprovalButtons = true;
										
										// Confidential Host Family Visit Form
										if ( qGetApprovalHistory.ID EQ 14 AND NOT qGetConfidentialVisitForm.recordCount ) {
											vDisplayApprovalButtons = false;
										}

										// Host Family Orientation
										if ( qGetApprovalHistory.ID EQ 19 AND NOT qGetHostFamilyOrientation.recordCount ) {
											vDisplayApprovalButtons = false;
										}
										
										// School Acceptance
										if ( qGetApprovalHistory.ID EQ 15 AND NOT qGetSchoolAcceptance.recordCount ) {
											vDisplayApprovalButtons = false;
										}
										
										// Student Orientation
										if ( qGetApprovalHistory.ID EQ 20 AND NOT qGetStudentOrientation.recordCount ) {
											vDisplayApprovalButtons = false;
										}
									</cfscript>
									
									<cfif vDisplayApprovalButtons>
                                    
                                        <input 
                                        	type="radio" 
                                            name="sectionStatus#qGetApprovalHistory.ID#_#vCurrentStudent#" 
                                            id="approve#qGetApprovalHistory.ID#_#vCurrentStudent#" 
                                            class="approveOption" 
                                            value="approved" 
                                            onclick="toggleReason('approved', '#qGetApprovalHistory.ID#_#vCurrentStudent#');" 
											<cfif FORM["sectionStatus" & qGetApprovalHistory.ID & "_" & vCurrentStudent] EQ 'approved'> checked="checked" </cfif> 
                                      	/> 
                                        <label for="approve#qGetApprovalHistory.ID#_#vCurrentStudent#">Approve</label>
                                        &nbsp; &nbsp;
                                        <input 
                                        	type="radio" 
                                            name="sectionStatus#qGetApprovalHistory.ID#_#vCurrentStudent#" 
                                            id="deny#qGetApprovalHistory.ID#_#vCurrentStudent#" 
                                            class="denyOption" 
                                            value="denied" 
                                            onclick="toggleReason('denied', '#qGetApprovalHistory.ID#_#vCurrentStudent#');" 
											<cfif FORM["sectionStatus" & qGetApprovalHistory.ID & "_" & vCurrentStudent] EQ 'denied'> checked="checked" </cfif>
                                        /> 
                                        <label for="deny#qGetApprovalHistory.ID#_#vCurrentStudent#">Deny</label> 
                                        
                                        <!--- Reason for denial --->
                                        <div class="reasonForDenial#qGetApprovalHistory.ID#_#vCurrentStudent# <cfif FORM["sectionStatus" & qGetApprovalHistory.ID & "_" & vCurrentStudent] NEQ 'denied'> displayNone </cfif>">
                                            <p class="formNote">Please enter a reason for denying this section <span class="required">*</span></p>
                                            <textarea name="sectionNotes#qGetApprovalHistory.ID#_#vCurrentStudent#" id="sectionNotes#qGetApprovalHistory.ID##vCurrentStudent#" class="smallTextArea">#FORM["sectionNotes" & qGetApprovalHistory.ID & "_" & vCurrentStudent]#</textarea>
                                        </div>
                                    
                                    </cfif>
                                    
                                    <!--- Run CBC Link for Office users - Display if it has been approved by any of the field --->
									<cfif qGetApprovalHistory.ID EQ 1 AND APPLICATION.CFC.USER.isOfficeUser() AND ( qGetApprovalHistory.areaRepStatus EQ 'approved' OR qGetApprovalHistory.regionalAdvisorStatus EQ 'approved' OR qGetApprovalHistory.regionalManagerStatus EQ 'approved' )>
                                        <a href="index.cfm?curdoc=cbc/hosts_cbc&hostID=#qGetHostInfo.hostID#" title="Click to view item" class="jQueryModal" style="display:block;">[ Run CBC ]</a> 
									</cfif>
                                    
								<cfelse>
                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
                                    
                                </cfif>
							  	
                                <!--- Confidential HF Visit --->
                              	<cfif qGetApprovalHistory.ID EQ 14>
                                
                                    <!--- Report Never Submitted --->
                                    <cfif NOT qGetConfidentialVisitForm.recordCount> 
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#" title="Click to view item" class="jQueryModalRefresh" style="display:block;">[ Submit Visit Form ]</a>
                                    <!--- Report Denied by up level user - Edit Report --->
                                    <cfelseif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] NEQ 'approved' OR qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'denied'>
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#" title="Click to view item" class="jQueryModalRefresh" style="display:block;">[ Edit Visit Form ]</a>
									<!--- Print View Default --->
                                    <cfelseif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'approved' OR qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] NEQ 'denied'>
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#" target="_blank" style="display:block;">[ View Visit Form ]</a>
                                    </cfif>
                                    
                              	<!--- Host Family Orientation --->
                              	<cfelseif qGetApprovalHistory.ID EQ 19>
                                    <cfif NOT qGetHostFamilyOrientation.recordCount>
                                    	<cfif qGetHostInfo.applicationStatusID GTE 4>
                                        	This section can be uploaded after the application has been approved by Headquarters.
                                        <cfelse>
                                            <a href="hostApplication/hostOrientation.cfm?hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#" class="jQueryModalRefresh" style="display:block;">
                                                [ Upload ]
                                            </a>
                                       	</cfif>
                                    <cfelse>
                                    	<div>
                                            <a href="hostApplication/hostOrientation.cfm?hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#&view=1" class="jQueryModalRefresh">
                                                [ View ]
                                            </a>
                                            <cfif CLIENT.userType LTE 4 OR qGetApprovalHistory.facilitatorStatus NEQ "approved">
                                                <a href="hostApplication/hostOrientation.cfm?hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#&delete=1" class="jQueryModalRefresh">
                                                    [ Delete ]
                                                </a>
                                            </cfif>
                                        </div>
                                    </cfif>  

							  	<!--- School Acceptance --->
                              	<cfelseif qGetApprovalHistory.ID EQ 15>
                                    <cfif NOT qGetSchoolAcceptance.recordCount>
                                        <a href="hostApplication/virtualFolderDocuments.cfm?studentID=#studentID#&hostID=#qGetHostInfo.hostID#&documentType=47" title="Click to view item" class="jQueryModalRefresh" style="display:block;">
                                        	[ Upload ]
                                     	</a>
                                    <!--- Print View Default --->
                                    <cfelse>
                                    	<div>
                                            <a href="hostApplication/virtualFolderDocuments.cfm?studentID=#studentID#&hostID=#qGetHostInfo.hostID#&documentType=47&view=1" class="jQueryModalRefresh">
                                                [ View ]
                                            </a>
                                            <cfif CLIENT.userType LTE 4>
                                                <a href="hostApplication/virtualFolderDocuments.cfm?studentID=#studentID#&hostID=#qGetHostInfo.hostID#&documentType=47&delete=1" class="jQueryModalRefresh">
                                                    [ Delete ]
                                                </a>
                                          	</cfif>
                                      	</div>
                                    </cfif>
                                
                                <!--- Student Orientation --->
                              	<cfelseif qGetApprovalHistory.ID EQ 20>
                                	<cfif NOT qGetStudentOrientation.recordCount>
                                        <a href="hostApplication/virtualFolderDocuments.cfm?studentID=#studentID#&documentType=49" class="jQueryModalRefresh" style="display:block;">
                                            [ Upload ]
                                        </a>
                                    <cfelse>
                                    	<div>
                                            <a href="hostApplication/virtualFolderDocuments.cfm?studentID=#studentID#&documentType=49&view=1" class="jQueryModalRefresh">
                                                [ View ]
                                            </a>
                                            <cfif CLIENT.userType LTE 4 OR qGetApprovalHistory.facilitatorStatus NEQ "approved">
                                                <a href="hostApplication/virtualFolderDocuments.cfm?studentID=#studentID#&documentType=49&delete=1" class="jQueryModalRefresh">
                                                    [ Delete ]
                                                </a>
                                          	</cfif>
                                      	</div>
                                    </cfif>
                                    
                              	</cfif>
                                
                            </td> 
                            <!--- Area Representative --->
                            <td>
                            
                                <cfif isDate(qGetApprovalHistory.areaRepDateStatus)>
                                	
                                    <cfif qGetApprovalHistory.areaRepStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetApprovalHistory.areaRepDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetApprovalHistory.areaRepNotes)>
                                    	<span style="display:block;">
                                        	Reason: #qGetApprovalHistory.areaRepNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                                
                            </td>
                            <!--- Regional Advisor --->
                            <td>
                            
                                <cfif isDate(qGetApprovalHistory.regionalAdvisorDateStatus)>
                                	
                                    <cfif qGetApprovalHistory.regionalAdvisorStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetApprovalHistory.regionalAdvisorDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetApprovalHistory.regionalAdvisorNotes)>
                                    	<span style="display:block;">
                                        	Reason: #qGetApprovalHistory.regionalAdvisorNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                                                                  
                            </td>
                            <!--- Regional Manager --->
                            <td>
                            
                                <cfif isDate(qGetApprovalHistory.regionalManagerDateStatus)>
                                	
                                    <cfif qGetApprovalHistory.regionalManagerStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetApprovalHistory.regionalManagerDateStatus, 'MM/DD/YYYY')#
                                    
                                    <cfif LEN(qGetApprovalHistory.regionalManagerNotes)>
                                    	<span style="display:block;">
                                        	Reason: #qGetApprovalHistory.regionalManagerNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                                                                  
                            </td>
                            <!--- Facilitator --->
                            <td>
                            
                                <cfif isDate(qGetApprovalHistory.facilitatorDateStatus)>
                                	
                                    <cfif qGetApprovalHistory.facilitatorStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetApprovalHistory.facilitatorDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetApprovalHistory.facilitatorNotes)>
                                    	<span style="display:block;">
                                        	Reason: #qGetApprovalHistory.facilitatorNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                                
                            </td>
                            <TD>
                            </TD>
                        </tr>

                        <cfif qGetApprovalHistory.listOrder EQ 12>
                            <tr bgcolor="##1b99da">
                                <td colspan="8" align="center"><h2 style="color:##FFFFFF;">FORMS</h2></td>
                            </tr>
                        </cfif>
                        
                    </cfloop>   
                    
                    <!--- References: Everyone Sees these ---->
                    <tr bgcolor="##1b99da">
                        <td colspan="8" align="center">
                        	<h2 style="color:##FFFFFF;">REFERENCE QUESTIONNAIRE</h2>
						
                        	<span style="color:##FFFFFF; font-weight:bold;">
								<cfif qGetHostInfo.totalFamilyMembers GT 1>
                                    This is a traditional host family - 2 reference questionnaires are required
                                <cfelse>
                                    This is a single host family - 4 reference questionnaires are required
                                </cfif>
                            </span>
                        </td>
                    </tr>    
                    <cfloop query="qGetReferences">
                        
                        <tr <cfif qGetReferences.currentrow MOD 2> bgcolor="##F7F7F7"</cfif>>
                            <td>
                                <cfif qGetReferences[stCurrentUserFieldSet.statusFieldName][qGetReferences.currentrow] EQ 'approved'>
                                    <img src="pics/valid.png" width="16" heigh="16">
                                <cfelse>
                                    <img src="pics/warning.png" width="16" heigh="16">
                                </cfif>
                            </td>
                            <td>#qGetReferences.firstname# #qGetReferences.lastname# - #qGetReferences.phone#</td>
                            <td>
								
								<!--- There is an approved report, display link --->
                                <cfif VAL(qGetReferences.ID)>	

									<!--- Previously approved reports --->    
                                    <cfif qGetHostInfo.applicationStatusID LT CLIENT.userType>
                                        
                                        <font color="##CCCCCC"><em>Previously Approved</em></font>
                                        <!--- This will automatically approve items in case upper lever has approved them | In the future we can give the approval/deny option --->
                                        <input type="hidden" name="referenceStatus#qGetReferences.ID#" value="approved" /> 
                                        <!--- <input type="hidden" name="referenceStatus#qGetReferences.ID#" value="#FORM['referenceStatus' & qGetReferences.ID]#" /> --->
                                        
									<!--- Approve/Deny Options --->      
                                    <cfelseif qGetHostInfo.applicationStatusID GTE CLIENT.userType>
                                        
                                        <input type="radio" name="referenceStatus#qGetReferences.ID#" id="referenceApprove#qGetReferences.ID#" class="approveOption" value="approved" onclick="toggleReferenceReason('approved', '#qGetReferences.ID#');" <cfif FORM["referenceStatus" & qGetReferences.ID] EQ 'approved'> checked="checked" </cfif> /> 
                                        <label for="referenceApprove#qGetReferences.ID#">Approve</label>
                                        &nbsp; &nbsp;
                                        <input type="radio" name="referenceStatus#qGetReferences.ID#" id="referenceDeny#qGetReferences.ID#" class="denyOption" value="denied" onclick="toggleReferenceReason('denied', '#qGetReferences.ID#');" <cfif FORM["referenceStatus" & qGetReferences.ID] EQ 'denied'> checked="checked" </cfif> /> 
                                        <label for="referenceDeny#qGetReferences.ID#">Deny</label> 
                                        
										<!--- Reason for denial --->
                                        <div class="referenceReasonForDenial#qGetReferences.ID# <cfif FORM["referenceStatus" & qGetReferences.ID] NEQ 'denied'> displayNone </cfif>">
                                            <p class="formNote">Please enter a reason for denying this report <span class="required">*</span></p>
                                            <textarea name="referenceNotes#qGetReferences.ID#" id="referenceNotes#qGetReferences.ID#" class="smallTextArea">#FORM["referenceNotes" & qGetReferences.ID]#</textarea>
                                        </div>
                                        
                                    </cfif>
                                    
                                    <!--- Report Does not exist or has not been approved by current level or has not been denied by upper level - Edit Report --->
                                    <cfif qGetReferences[stCurrentUserFieldSet.statusFieldName][qGetReferences.currentrow] NEQ 'approved' OR qGetReferences[stOneLevelUpFieldSet.statusFieldName][qGetReferences.currentrow] EQ 'denied'>
                                        <a class="jQueryModalRefresh" href="hostApplication/referenceQuestionnaire.cfm?refID=#qGetReferences.refID#&hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#" style="display:block;">[ Edit Reference Questionnaire ]</a>
                                    <!--- Print View Default --->
									<cfelse>
                                        <a href="hostApplication/referenceQuestionnaire.cfm?refID=#qGetReferences.refID#&hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#" target="_blank" style="display:block;">[ View Reference Questionnaire ]</a>
                                    </cfif>
                                    
                                    <span style="display:block; color:##CCCCCC;"><em>Submitted on #DateFormat(qGetReferences.dateInterview,'mm/dd/yyyy')# by #qGetReferences.submittedBy#</em></span>   
                                    
                                <cfelse>
                                
                                    <a class="jQueryModalRefresh" href="hostApplication/referenceQuestionnaire.cfm?refID=#qGetReferences.refID#&hostID=#qGetHostInfo.hostID#&seasonID=#vSelectedSeason#">
                                   		[ Submit Reference Questionnaire ]
                                    </a>
                                    
                                </cfif>
                                
                                
                            </td>
                            <td>
                                <cfif isDate(qGetReferences.areaRepDateStatus)>
                                	
                                    <cfif qGetReferences.areaRepStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetReferences.areaRepDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetReferences.areaRepNotes) AND CLIENT.userID NEQ qGetHostInfo.areaRepID>
                                    	<span style="display:block;">
                                        	Reason: #qGetReferences.areaRepNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                            </td>
                            <td>
                                <cfif isDate(qGetReferences.regionalAdvisorDateStatus)>
                                	
                                    <cfif qGetReferences.regionalAdvisorStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetReferences.regionalAdvisorDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetReferences.regionalAdvisorNotes) AND CLIENT.userID NEQ qGetHostInfo.regionalAdvisorID>
                                    	<span style="display:block;">
                                        	Reason: #qGetReferences.regionalAdvisorNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                            </td>
                            <td>
                                <cfif isDate(qGetReferences.regionalManagerDateStatus)>
                                	
                                    <cfif qGetReferences.regionalManagerStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetReferences.regionalManagerDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetReferences.regionalManagerNotes) AND CLIENT.userID NEQ qGetHostInfo.regionalManagerID>
                                    	<span style="display:block;">
                                        	Reason: #qGetReferences.regionalManagerNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                            </td>
                            <td>
                                <cfif isDate(qGetReferences.facilitatorDateStatus)>
                                	
                                    <cfif qGetReferences.facilitatorStatus EQ 'approved'>
                                    	<img src="pics/valid.png" width="16" heigh="16">
                                    <cfelse>
                                    	<img src="pics/error.gif" width="16" heigh="16">
                                    </cfif>
                                    
                                    #DateFormat(qGetReferences.facilitatorDateStatus, 'MM/DD/YYYY')#

                                    <cfif LEN(qGetReferences.facilitatorNotes) AND NOT APPLICATION.CFC.USER.isOfficeUser()>
                                    	<span style="display:block;">
                                        	Reason: #qGetReferences.facilitatorNotes#
                                        </span>
                                    </cfif>
                                    
                            	<cfelse>                                
                                	<font color="##CCCCCC"><em>N/A</em></font>
								</cfif>  
                            </td>
                            <td></td>
                        </tr>
                    </cfloop>
                    
                    <!--- Representative Notes --->
                    <tr bgcolor="##1b99da">
                        <td colspan="8" align="center">
                        	<h2 style="color:##FFFFFF;">REPRESENTATIVE NOTES</h2>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="7">
                        	<input type="hidden" name="repNotes" id="repNotes" value="#FORM.repNotes#" />
                        	<div 
                            	id="repNotesDiv" 
                                onkeyup="$('##repNotes').val($('##repNotesDiv').html());" 
                                style="margin:auto; width:80%; height:120px; border:thin solid gray; overflow:scroll;" 
                                contenteditable="true">
                            	#FORM.repNotes#
                            </div>
                        </td>
                    </tr>
                    
                </table>
                
                <!--- Update Button --->
                <cfif qGetHostInfo.applicationStatusID GTE CLIENT.userType>
                    <table cellpadding="4" align="center">
                        <tr>
                            <td><input type="image" src="pics/buttons/update.png" /></td>
                        </tr>
                    </table> 
                </cfif>
                
            </div>
            
    	    <div class="rdbottom"></div> <!-- end bottom --> 	            
            
        </div>
        
	</form>        

</cfoutput>