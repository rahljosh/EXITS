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

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostID" default="0">

    <cfscript>	
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		// Get Host Application Information
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID);	
		
		// Get Application Approval History
		qGetApprovalHistory = APPLICATION.CFC.HOST.getApplicationApprovalHistory(hostID=qGetHostInfo.hostID, whoViews=CLIENT.userType);

		// Get Uploaded Images
		qGetSchoolAcceptance = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",	
			foreignID=FORM.hostID, 			
			documentGroup="schoolAcceptance",
			seasonID=APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID			
		);
		
		// Get References
		qGetReferences = APPLICATION.CFC.HOST.getReferences(hostID=qGetHostInfo.hostID);

		// Get Confidential Visit Form
		qGetConfidentialVisitForm = APPLICATION.CFC.PROGRESSREPORT.getVisitInformation(hostID=FORM.hostID,reportType=5);

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
		stUserOneLevelUpInfo = APPLICATION.CFC.USER.getUserOneLevelUpInfo(currentUserType=qGetHostInfo.hostAppStatus,regionalAdvisorID=qGetHostInfo.regionalAdvisorID);
		
		// This returns the fields that need to be checked
		stOneLevelUpFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames(userType=stUserOneLevelUpInfo.userType);

		// Param Form Variables - Approval History
		For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
			param name="FORM.sectionStatus#qGetApprovalHistory.ID[i]#" default="";
			param name="FORM.sectionNotes#qGetApprovalHistory.ID[i]#" default="";
			
			// Check if level app has denied any of the sections
			if ( qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][i] EQ 'denied' ) {
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
			
			// Sections - Check for Errors
			For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {

				// Only check for approval if there is a school acceptance and a confidential host visit report
				vCheckIfMissing = true;
				
				// Confidential Host Family Visit Form
				if ( qGetApprovalHistory.ID[i] EQ 14 AND NOT qGetConfidentialVisitForm.recordCount ) {
					vCheckIfMissing = false;
				}
				
				// School Acceptance
				if ( qGetApprovalHistory.ID[i] EQ 15 AND NOT qGetSchoolAcceptance.recordCount ) {
					vCheckIfMissing = false;
				}

				// Confidential Host Visit - Require approval when there is a report | School Acceptance - Require approval if there is an uploaded file
				if ( vCheckIfMissing ) {
					
					// Check if all sections have an approval/denial value
					if ( NOT LEN(FORM["sectionStatus" & qGetApprovalHistory.ID[i]]) ) {
						SESSION.formErrors.Add("#qGetApprovalHistory.description[i]# - Please approve or deny this section");
					}
					
					// Check for reason if any section is denied
					if ( FORM["sectionStatus" & qGetApprovalHistory.ID[i]] EQ 'denied' AND NOT LEN(FORM["sectionNotes" & qGetApprovalHistory.ID[i]]) ) {
						SESSION.formErrors.Add("#qGetApprovalHistory.description[i]# - Please enter a reason for denying this section");
					}
				
				}
				
			}
			
			// References - Check for Errors
			For ( i=1; i LTE qGetReferences.recordCount; i++ ) {
				
				if ( VAL(qGetReferences.ID[i]) ) {

					// Check if all sections have an approval/denial value
					if ( NOT LEN(FORM["referenceStatus" & qGetReferences.ID[i]]) ) {
						SESSION.formErrors.Add("Reference for #qGetReferences.firstname[i]# #qGetReferences.lastname[i]# - Please approve or deny this report");
					}
					
					// Check for reason if any section is denied
					if ( FORM["referenceStatus" & qGetReferences.ID[i]] EQ 'denied' AND NOT LEN(FORM["referenceNotes" & qGetReferences.ID[i]]) ) {
						SESSION.formErrors.Add("Reference for #qGetReferences.firstname[i]# #qGetReferences.lastname[i]# - Please enter a reason for denying this report");
					}

				}				
				
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Set Default Action
				vAction = "approved";
				vIssueList = "";

				// Update Each Section (Approve/Deny)
				For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
					
					APPLICATION.CFC.HOST.updateSectionStatus(
						hostID=FORM.hostID,
						itemID=qGetApprovalHistory.ID[i],
                        action=FORM["sectionStatus" & qGetApprovalHistory.ID[i]],
                        notes=FORM["sectionNotes" & qGetApprovalHistory.ID[i]],
						areaRepID=qGetHostInfo.areaRepresentativeID,
						regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
						regionalManagerID=qGetHostInfo.regionalManagerID
					);
					
					// If at least one section is denied we must send the application back one level
					if ( FORM["sectionStatus" & qGetApprovalHistory.ID[i]] EQ 'denied' ) {
						vAction = "denied";
						// Store a list of issues
						vIssueList = ListAppend(vIssueList, '<li>#qGetApprovalHistory.description[i]# Section - #FORM["sectionNotes" & qGetApprovalHistory.ID[i]]#</li>');
					}
					
				}
				
				// Update Each Reference (Approve/Deny)
				For ( i=1; i LTE qGetReferences.recordCount; i++ ) {

					APPLICATION.CFC.HOST.updateReferenceStatus(
						ID=qGetReferences.ID[i],
						hostID=FORM.hostID,
						fk_referencesID=qGetReferences.fk_referencesID[i],
                        action=FORM["referenceStatus" & qGetReferences.ID[i]],
                        notes=FORM["referenceNotes" & qGetReferences.ID[i]],
						areaRepID=qGetHostInfo.areaRepID,
						regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
						regionalManagerID=qGetHostInfo.regionalManagerID
					);
					
					// If at least one section is denied we must send the application back one level
					if ( FORM["referenceStatus" & qGetReferences.ID[i]] EQ 'denied' ) {
						vAction = "denied";
						// Store a list of issues
						vIssueList = ListAppend(vIssueList, '<li>Reference for #qGetReferences.firstname[i]# #qGetReferences.lastname[i]# - #FORM["referenceNotes" & qGetReferences.ID[i]]#</li>');
					}

				}
				
				// Check if Confidential Host Family Visit Form Has Been Submitted
				if ( vAction NEQ 'denied' AND NOT qGetConfidentialVisitForm.recordCount ) {
					SESSION.formErrors.Add("Confidential Host Family Visit Form - Please submit a report");
				}
				
				// Check if references have been approved
				qGetApprovedReferences = APPLICATION.CFC.HOST.getReferences(hostID=qGetHostInfo.hostID, getCurrentUserApprovedReferences=CLIENT.userType);
				
				// Check how many references are missing
				vMissingReferences = VAL(vRequiredApprovedReferences-qGetApprovedReferences.recordCount);
				
				// Only Force References when approving application
				if ( vAction EQ 'approved' AND vMissingReferences GT 0 ) {
					SESSION.formErrors.Add("You must submit/approve a total of #vRequiredApprovedReferences# references. #vMissingReferences# reference(s) missing.");
				}
				
				// Check if there are no errors
				if ( NOT SESSION.formErrors.length() ) {				

					// Approve/Deny Application
					stReturnMessage = APPLICATION.CFC.HOST.submitApplication(
						hostID=qGetHostInfo.hostID,
						action=vAction,
						issueList=vIssueList
					);
				
					// Set Page Message
					SESSION.pageMessages.Add(stReturnMessage.pageMessages);
					
					// Check if there is an error message
					if ( LEN(stReturnMessage.formErrors) ) {
						SESSION.formErrors.Add(stReturnMessage.formErrors);	
					}
					
					// Go back to the list information
					location("#CGI.SCRIPT_NAME#?curdoc=hostApplication/listOfApps&status=#qGetHostInfo.hostAppStatus#", "no");
					
				}
				
			}
						
		} else {
			
			// Set Default Form Values Based on Current User
			For ( i=1; i LTE qGetApprovalHistory.recordCount; i++ ) {
				
				// Set Default Form Name
				FORM["sectionStatus" & qGetApprovalHistory.ID[i]] = qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][i];
				FORM["sectionNotes" & qGetApprovalHistory.ID[i]] = qGetApprovalHistory[stCurrentUserFieldSet.notesFieldName][i];
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
            		<th width="14%" align="left">Actions</th>
            	</tr>
                <tr>
                    <td valign="top">
                    	#APPLICATION.CFC.HOST.displayHostFamilyName(
                        	fatherFirstName=qGetHostInfo.fatherFirstName,
                            fatherLastName=qGetHostInfo.fatherLastName,
                            motherFirstName=qGetHostInfo.motherFirstName,
                            motherLastName=qGetHostInfo.motherLastName)# (###qGetHostInfo.hostid#) <br />
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
						<cfif isDate(qGetHostInfo.applicationSent)>
                        	Date Created: #DateFormat(qGetHostInfo.applicationSent, 'mm/dd/yyyy')# <br />
                        </cfif>
                        
						<!---
						<cfif isDate(qGetHostInfo.applicationStarted)>
							Date HF Started: #DateFormat(qGetHostInfo.applicationStarted, 'mm/dd/yyyy')# <br />
						</cfif>
						--->

                    	<!--- App has been denied, display message --->
                    	<cfif vHasAppBeenDeniedByOneLevelUpUser>
                        	#stUserOneLevelUpInfo.description# has denied one or more sections.
                        <cfelse>

                            <cfswitch expression="#qGetHostInfo.hostAppStatus#">
                                
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
                    <td valign="top">
                        <a class="jQueryModal" href="/hostApplication/index.cfm?uniqueID=#qGetHostInfo.uniqueID#" title="View Complete Application"><img src="pics/buttons/openApplication.png" border="0"></a>
                        <!--- Commented out until the print version is redone 02/26/2013 - Marcus Melo
                        &nbsp; &nbsp; 
                        <a class="jQueryModal" href="hostApplication/viewPDF.cfm?hostID=#hostID#&pdf" title="Print Application"><img src="pics/buttons/print50x50.png" width="40" border="0"></a>
						--->
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
                <a href="?curdoc=hostApplication/listOfApps&status=#qGetHostInfo.hostAppStatus#" class="floatRight"><img src="pics/buttons/back.png" border="0" /></a>
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
                        <td width="14%"><h2 style="color:##FFFFFF;">Facilitator</h2></td>
                    </tr>
                                       
                    <cfloop query="qGetApprovalHistory">
                        
                        <cfscript>
                            // Set Links
							
							// Host Visit Report / Second Visit Report - No link, text only
                            if ( ListFind("14,15", qGetApprovalHistory.ID) ) {
								vSetDescLink = '#qGetApprovalHistory.description#';
							// Set Up Link for HF section
							} else { 
                                vSetDescLink = '<a href="/hostApplication/index.cfm?uniqueID=#qGetHostInfo.uniqueID#&section=#qGetApprovalHistory.section#" title="Click to view item" class="jQueryModal">#qGetApprovalHistory.description#</a>';
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
                            	<!--- Host Family still filling out --->
								<cfif ListFind("9,8", qGetHostInfo.hostAppStatus) AND NOT listFind("14,15", qGetApprovalHistory.ID)>
                                    
                                    <font color="##CCCCCC"><em>Application has NOT been submitted</em></font>
                                
                                <!--- Previously approved sections --->    
								<cfelseif qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'approved' OR ( qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'approved' AND qGetHostInfo.hostAppStatus LT CLIENT.userType )>
									
                                    <font color="##CCCCCC"><em>Previously Approved</em></font>
                                    <!--- This will automatically approve items in case upper lever has approved them | In the future we can give the approval/deny option --->
									<input type="hidden" name="sectionStatus#qGetApprovalHistory.ID#" value="approved" /> 
                                    <!--- input type="hidden" name="sectionStatus#qGetApprovalHistory.ID#" value="#FORM['sectionStatus' & qGetApprovalHistory.ID]#" />  --->
                                    
                                <!--- Approve/Deny Options --->      
								<cfelseif qGetHostInfo.hostAppStatus GTE CLIENT.userType>
                                    
                                    <cfscript>
										// Only Display approval option if there is a school acceptance and a confidential host visit report
										vDisplayApprovalButtons = true;
										
										// Confidential Host Family Visit Form
										if ( qGetApprovalHistory.ID EQ 14 AND NOT qGetConfidentialVisitForm.recordCount ) {
											vDisplayApprovalButtons = false;
										}

										// School Acceptance
										if ( qGetApprovalHistory.ID EQ 15 AND NOT qGetSchoolAcceptance.recordCount ) {
											vDisplayApprovalButtons = false;
										}
									</cfscript>
									
									<cfif vDisplayApprovalButtons>
                                    
                                        <input type="radio" name="sectionStatus#qGetApprovalHistory.ID#" id="approve#qGetApprovalHistory.ID#" class="approveOption" value="approved" onclick="toggleReason('approved', '#qGetApprovalHistory.ID#');" <cfif FORM["sectionStatus" & qGetApprovalHistory.ID] EQ 'approved'> checked="checked" </cfif> /> 
                                        <label for="approve#qGetApprovalHistory.ID#">Approve</label>
                                        &nbsp; &nbsp;
                                        <input type="radio" name="sectionStatus#qGetApprovalHistory.ID#" id="deny#qGetApprovalHistory.ID#" class="denyOption" value="denied" onclick="toggleReason('denied', '#qGetApprovalHistory.ID#');" <cfif FORM["sectionStatus" & qGetApprovalHistory.ID] EQ 'denied'> checked="checked" </cfif> /> 
                                        <label for="deny#qGetApprovalHistory.ID#">Deny</label> 
                                        
                                        <!--- Reason for denial --->
                                        <div class="reasonForDenial#qGetApprovalHistory.ID# <cfif FORM["sectionStatus" & qGetApprovalHistory.ID] NEQ 'denied'> displayNone </cfif>">
                                            <p class="formNote">Please enter a reason for denying this section <span class="required">*</span></p>
                                            <textarea name="sectionNotes#qGetApprovalHistory.ID#" id="sectionNotes#qGetApprovalHistory.ID#" class="smallTextArea">#FORM["sectionNotes" & qGetApprovalHistory.ID]#</textarea>
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
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#" title="Click to view item" class="jQueryModalRefresh" style="display:block;">[ Submit Visit Form ]</a>
                                    <!--- Report Denied by up level user - Edit Report --->
                                    <cfelseif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] NEQ 'approved' OR qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'denied'>
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#" title="Click to view item" class="jQueryModalRefresh" style="display:block;">[ Edit Visit Form ]</a>
									<!--- Print View Default --->
                                    <cfelseif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'approved' OR qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] NEQ 'denied'>
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#" target="_blank" style="display:block;">[ View Visit Form ]</a>
                                    </cfif>   

							  	<!--- School Acceptance --->
                              	<cfelseif qGetApprovalHistory.ID EQ 15>
                                
                                    <cfif NOT qGetSchoolAcceptance.recordCount>
                                        <a href="#qGetApprovalHistory.section#?hostID=#qGetHostInfo.hostID#" title="Click to view item" class="jQueryModalRefresh" style="display:block;">[ Upload School Acceptance Letter ]</a>
                                    <!--- Print View Default --->
                                    <cfelseif qGetApprovalHistory[stCurrentUserFieldSet.statusFieldName][qGetApprovalHistory.currentrow] EQ 'approved' OR qGetApprovalHistory[stOneLevelUpFieldSet.statusFieldName][qGetApprovalHistory.currentrow] NEQ 'denied'>
                                        <a href="publicDocument.cfm?ID=#qGetSchoolAcceptance.ID#&key=#qGetSchoolAcceptance.hashID#" target="_blank" style="display:block;">[ Download School Acceptance Letter ]</a>
                                    	<!--- ADD OPTION TO DELETE A FILE --->
										<!--- Delete --->
                                    <cfelse>
                                    	<!--- ADD OPTION TO DELETE A FILE --->
                                    	<!--- <a href="" title="Click to delete this item" class="jQueryModalRefresh" style="display:block;">[ Delete File ]</a> --->
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
                        </tr>

                        <cfif qGetApprovalHistory.listOrder EQ 12>
                            <tr bgcolor="##1b99da">
                                <td colspan="7" align="center"><h2 style="color:##FFFFFF;">FORMS</h2></td>
                            </tr>
                        </cfif> 
                        
                    </cfloop>   
                    
                    <!--- References: Everyone Sees these ---->
                    <tr bgcolor="##1b99da">
                        <td colspan="7" align="center">
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
                                    <cfif qGetReferences[stOneLevelUpFieldSet.statusFieldName][qGetReferences.currentrow] EQ 'approved' OR ( qGetReferences[stCurrentUserFieldSet.statusFieldName][qGetReferences.currentrow] EQ 'approved' AND qGetHostInfo.hostAppStatus LT CLIENT.userType )>
                                        
                                        <font color="##CCCCCC"><em>Previously Approved</em></font>
                                        <!--- This will automatically approve items in case upper lever has approved them | In the future we can give the approval/deny option --->
                                        <input type="hidden" name="referenceStatus#qGetReferences.ID#" value="approved" /> 
                                        <!--- <input type="hidden" name="referenceStatus#qGetReferences.ID#" value="#FORM['referenceStatus' & qGetReferences.ID]#" /> --->
                                        
									<!--- Approve/Deny Options --->      
                                    <cfelseif qGetHostInfo.hostAppStatus GTE CLIENT.userType>
                                        
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
                                        <a class="jQueryModalRefresh" href="hostApplication/referenceQuestionnaire.cfm?refID=#qGetReferences.refID#&hostID=#qGetHostInfo.hostID#" style="display:block;">[ Edit Reference Questionnaire ]</a>
                                    <!--- Print View Default --->
									<cfelse>
                                        <a href="hostApplication/referenceQuestionnaire.cfm?refID=#qGetReferences.refID#&hostID=#qGetHostInfo.hostID#" target="_blank" style="display:block;">[ View Reference Questionnaire ]</a>
                                    </cfif>
                                    
                                    <span style="display:block; color:##CCCCCC;"><em>Submitted on #DateFormat(qGetReferences.dateInterview,'mm/dd/yyyy')# by #qGetReferences.submittedBy#</em></span>   
                                    
                                <cfelse>
                                
                                    <a class="jQueryModalRefresh" href="hostApplication/referenceQuestionnaire.cfm?refID=#qGetReferences.refID#&hostID=#qGetHostInfo.hostID#">
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
                        </tr>
                    </cfloop>
                </table>
                
                <!--- Update Button --->
                <cfif qGetHostInfo.hostAppStatus GTE CLIENT.userType>
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