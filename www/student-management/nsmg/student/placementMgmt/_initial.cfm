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
    
    <!--- Host --->
    <cfparam name="FORM.hostIDSuggest" default="" />
    <cfparam name="FORM.hostID" default="0" />
    <cfparam name="FORM.hostIDReason" default="" />
    <cfparam name="FORM.isWelcomeFamily" default="" />
    <cfparam name="FORM.isRelocation" default="" />
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

    <cfscript>
		// Check if Host Family is in compliance
		vHostInCompliance = APPLICATION.CFC.CBC.checkHostFamilyCompliance(hostID=qGetStudentInfo.hostID, studentID=qGetStudentInfo.studentID);
	</cfscript>
    
    <cfscript>
		// FORM Submitted - Update Info
		if ( listLen(FORM.subAction) GT 1 ) {
			
			// Update hostID
			if ( ListFindNoCase(FORM.subAction, "updatehostID") ) {
				
				// Data Validation
				if ( NOT VAL(FORM.hostID) ) {
					SESSION.formErrors.Add("You must select a host family, if you do not see it on the list, please close this window and add a host family");
				}			
	
				if ( NOT LEN(FORM.isWelcomeFamily) ) {
					SESSION.formErrors.Add("You must answer whether is a welcome family or not");
				}			
	
				if ( NOT LEN(FORM.hostIDReason) ) {
					SESSION.formErrors.Add("You must select a reason for changing host family");
				}			
	
				if ( NOT LEN(FORM.isRelocation) ) {
					SESSION.formErrors.Add("You must answer whether is a relocation or not");
				}			
			
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
			
			}
			
			// Update Double Placement
			if ( ListFindNoCase(FORM.subAction, "updateDoublePlace") ) {
			
				if ( VAL(qGetStudentInfo.doublePlace) AND NOT LEN(FORM.doublePlaceReason) ) {
					SESSION.formErrors.Add("You must enter a reason for changing double placement");
				}	

				// Check if double placement is not assigned to a different student
				qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(FORM.doublePlace));
				
				if ( VAL(FORM.doublePlace) AND VAL(qGetDoublePlacementInfo.doublePlace) AND qGetDoublePlacementInfo.doublePlace NEQ FORM.doublePlace ) {
					SESSION.formErrors.Add("Student #qGetDoublePlacementInfo.firstName# #qGetDoublePlacementInfo.familyLastName# ###qGetDoublePlacementInfo.studentID# is already assigned as double placement with student ###qGetDoublePlacementInfo.doublePlace#");
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
					hostIDReason = FORM.hostIDReason,
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
			
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
			
			}

		// FORM SUBMITTED - Placement Information
		} else if ( FORM.subAction EQ "placementInformation" ) {
			
			// Data Validation
			if ( NOT VAL(FORM.hostID) ) {
				SESSION.formErrors.Add("You must select a host family, if you do not see it on the list, please close this window and add a host family");
			}			

			if ( NOT LEN(FORM.isWelcomeFamily) ) {
				SESSION.formErrors.Add("You must answer whether is a welcome family or not");
			}			
			
			if ( NOT VAL(FORM.schoolID) ) {
				SESSION.formErrors.Add("You must select a school from the list");
			}			

			if ( NOT VAL(FORM.placeRepID) ) {
				SESSION.formErrors.Add("You must select a placing representative from the list");
			}			

			if ( NOT VAL(FORM.areaRepID) ) { 
				SESSION.formErrors.Add("You must select a supervising representative from the list");
			}	
			
			if ( VAL(FORM.doublePlace) AND qGetStudentInfo.DoublePlace NEQ FORM.doublePlace ) { 
			
				// Check if double placement is not assigned to a different student
				qGetDoublePlacementInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(FORM.doublePlace));
				
				if ( VAL(qGetDoublePlacementInfo.doublePlace) AND qGetDoublePlacementInfo.doublePlace NEQ FORM.studentID ) {
					SESSION.formErrors.Add("Student #qGetDoublePlacementInfo.firstName# #qGetDoublePlacementInfo.familyLastName# ###qGetDoublePlacementInfo.studentID# is already assigned as double placement with student ###qGetDoublePlacementInfo.doublePlace#");
				}
				
				FORM.subAction = FORM.subAction & ',updateDoublePlace';
				
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
			
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
			
			}
		
		// APPROVE PLACEMENT
		} else if ( FORM.subAction EQ 'approve' ) {
		
			// Approve Placement - Insert into history
			APPLICATION.CFC.STUDENT.approvePlacement(
				studentID = FORM.studentID,								 
				changedBy = CLIENT.userID,								 
				userType = CLIENT.userType
			 );

			// Set Page Message
			SESSION.pageMessages.Add("Placement has been approved.");
			
			// Reload page
			location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
		// SET FAMILY AS PERMANENT
		} else if ( FORM.subAction EQ 'setFamilyAsPermanent' ) {
			
			// Set Family As Permanent - Insert into history
			APPLICATION.CFC.STUDENT.setFamilyAsPermanent(
				studentID = FORM.studentID,								 
				changedBy = CLIENT.userID,								 
				userType = CLIENT.userType
			 );

			// Set Page Message
			SESSION.pageMessages.Add("Host Family has been set as permanent.");
			
			// Reload page
			location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		

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

			if ( LEN(FORM.reason) AND LEN(FORM.reason) LT 10 ) { 
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
					placeRepID = qGetStudentInfo.placeRepID,
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

			if ( LEN(FORM.reason) AND LEN(FORM.reason) LT 10 ) { 
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

		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetStudentInfo.studentID;
			FORM.uniqueID = qGetStudentInfo.uniqueID;
			FORM.hostID = qGetStudentInfo.hostID;		
			FORM.isWelcomeFamily = qGetStudentInfo.welcome_family;		
			FORM.schoolID = qGetStudentInfo.schoolID;
			FORM.placeRepID = qGetStudentInfo.placeRepID;
			FORM.areaRepID = qGetStudentInfo.areaRepID;
			FORM.secondVisitRepID = qGetStudentInfo.secondVisitRepID;
			FORM.doublePlace = qGetStudentInfo.doublePlace;

		}
		
		// Set number of errors
		FORM.validationErrors = SESSION.formErrors.length();
	</cfscript>
    
    <!--- Get School Info --->
    <cfquery name="qGetSchoolInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	sc.schoolID,
            sc.schoolname, 
            sc.city,
            sc.state,
            sc.zip, 
            sd.year_begins, 
            sd.semester_begins, 
            sd.semester_ends, 
            sd.year_ends
        FROM 
        	smg_schools sc
        LEFT JOIN 
        	smg_school_dates sd on sd.schoolID = sc.schoolID
            AND 
                sd.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetProgramInfo.seasonID)#">
        WHERE 
        	sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.schoolID)#">
    </cfquery>

</cfsilent>

<!--- DELETE THIS --->
<cfset vHostInCompliance = ''>
<!--- DELETE THIS --->

<script language="javascript">
	// Display warning when page is ready
	$(document).ready(function() {
							   
		// opener.location.reload();
		// Display Form Fields
		displayFormFields();
		
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
			
		// Display only if rejecting a placement
		<cfelseif FORM.subAction EQ 'reject'>
		
			displayHiddenForm('rejectPlacementForm','actionButtons');

		// Display only if resubmitting a placement
		<cfelseif FORM.subAction EQ 'resubmit'>
		
			displayHiddenForm('resubmitPlacementForm','resubmitPlacementButton');

		// Display only if unplacing a student
		<cfelseif FORM.subAction EQ 'unplace'>
		
			displayHiddenForm('unplaceStudentForm');

		</cfif>
		
		<cfif NOT ListFindNoCase(FORM.subAction, "reject") AND CLIENT.userType NEQ 7>
		
			// Always show the 2nd Visit Rep if it's not assigned and not submitting a rejection form
			if ( $("#secondVisitRepID").val() == 0 || $("#validationErrors").val() != 0 ) { 
				vDisplaySaveButton = 1;
				$("#divSecondVisitRepIDInfo").slideUp();
				$("#divSecondVisitRepID").slideDown();
			}
			
		<cfelse>
		
			// Display 2nd Representative information
			$("#divSecondVisitRepIDInfo").slideUp();
			$("#divSecondVisitRepIDInfo").slideDown();

		</cfif>

		<cfif NOT ListFindNoCase(FORM.subAction, "reject")>
			
			// Always show the double placement if student is not assigned and not submitting a rejection form
			if ( $("#doublePlace").val() == 0 || $("#validationErrors").val() != 0 ) { 
				vDisplaySaveButton = 1;
				$("#divDoublePlaceInfo").slideUp();
				$("#divDoublePlace").slideDown();
			}

		</cfif>

		<cfif ListFindNoCase(FORM.subAction, "updatehostID")>
			
			if ( $("#hostID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				// Hide Information
				$("#divHostIDInfo").slideUp();
				$("#divHostID").slideDown();			
			}
		
		</cfif>
		
		<cfif ListFindNoCase(FORM.subAction, "updateSchoolID")>		
			
			if ( $("#schoolID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divSchoolIDInfo").slideUp();
				$("#divSchoolID").slideDown();
			}
		
		</cfif>
		
		<cfif ListFindNoCase(FORM.subAction, "updatePlaceRepID")>
			
			if ( $("#placeRepID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divPlaceRepIDInfo").slideUp();
				$("#divPlaceRepID").slideDown();
			}
		
		</cfif>
		
		<cfif ListFindNoCase(FORM.subAction, "updateAreaRepID")>
			
			if ( $("#areaRepID").val() == 0 || $("#validationErrors").val() != 0 ) { 
				vDisplaySaveButton = 1;
				$("#divAreaRepIDInfo").slideUp();
				$("#divAreaRepID").slideDown();
			}
		
		</cfif>

		<cfif ListFindNoCase(FORM.subAction, "updateSecondRepID")>
			
			if ( $("#secondVisitRepID").val() == 0 || $("#validationErrors").val() != 0 ) { 
				vDisplaySaveButton = 1;
				$("#divSecondRepIDInfo").slideUp();
				$("#divSecondRepID").slideDown();
			}
		
		</cfif>

		// Display Save Button
		if ( vDisplaySaveButton == 1 ) {
			$("#tableDisplaySaveButton").slideDown();
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
	
	// Modal Confirmation - Set Host Family As Permanent
	var setFamilyAsPermanent = function(divID) { 	
	
		$(function() {
			// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
			$( "#dialog:ui-dialog" ).dialog( "destroy" );
		
			$( "#dialog-setFamilyPermanent-confirm" ).dialog({
				resizable: false,
				height:160,
				modal: true,
				buttons: {
					"Confirm": function() {
						$( this ).dialog( "close" );
						// Submit Form
						$("#setPermanentForm").submit();
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
    
    <!--- Set as Permanent - Modal Dialog Box --->
    <div id="dialog-setFamilyPermanent-confirm" title="Set Host Family as Permanent?" class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Please confirm below you would like to set this host family as permanent.</p> 
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
                            <a href="javascript:openPopUp('../../reports/PlacementInfoSheet.cfm?uniqueID=#FORM.uniqueID#&approve', 900, 600);"><img src="../../pics/previewpis.gif" border="0"></a><br />
                        </td>
                    </tr>
                    <tr>
                        <td align="center" style="color:##3b5998; padding-top:10px;">
                            To approve this placement, please review the placement letter clicking on the link above, <br /> then click on "continue" at the bottom of the placement letter.
                        </td>
                    </tr>
                <cfelse>
                    <tr>
                        <td align="center">
                            <a href="javascript:openPopUp('../../reports/PlacementInfoSheet.cfm?uniqueID=#FORM.uniqueID#', 900, 600);"><img src="../../pics/previewpis.gif" border="0"></a>
                        </td>
                    </tr>
                </cfif>
            
                <tr>
                    <td align="center" style="padding-top:10px;">
                        
						<!--- Check if CBCs are in compliance with DOS --->											
                        <cfif LEN(vHostInCompliance) AND ListFind("1,2,3,4", CLIENT.userType)>
                            
                            <!--- Display Compliance --->
                            #vHostInCompliance#

                        <cfelseif CLIENT.usertype LT qGetStudentInfo.host_fam_Approved>
                            
                            <span id="actionButtons" class="displayNone">
                            
                                <a href="javascript:approvePlacement();"><img src="../../pics/approve.gif" border="0" alt="Approve Placement" /></a>
                                &nbsp; &nbsp;
                                <a href="javascript:displayHiddenForm('rejectPlacementForm','actionButtons');"><img src="../../pics/reject.gif" border="0" alt="Reject Placement" /></a>
                       
                       		</span>

							<!--- Approve Placement ---->
                            <form name="approvePlacementForm" id="approvePlacementForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone">
                                <input type="hidden" name="subAction" id="subAction" value="approve" />
                                <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
                                <input type="image" name="submit" src="../../pics/approve.gif" alt="Approve Placement" />
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
                            
                        </cfif>

                    </td>
                </tr>
            </cfcase>
        
            <cfcase value="Approved">
                <tr>
                    <td align="center">
                        <a href="" onClick="javascript: win=window.open('../../reports/PlacementInfoSheet.cfm?uniqueID=#FORM.uniqueid#&approve', 'Settings', 'height=450, width=850, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
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

		<!--- Unplace Student ---->
        <tr>
            <td align="center">
                
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

            </td>
        </tr>                                                                                                
    </table>                                                

	<!--- Set Family as Permanent --->
    <form name="setPermanent" id="setPermanentForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone">
    	<input type="hidden" name="subAction" id="subAction" value="setFamilyAsPermanent" />
        <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
	</form>            

	<!--- Placement Form --->   
    <cfform name="placementMgmt" id="placementMgmt" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
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
                    
                    <cfif VAL(qGetStudentInfo.hostID)>
                        <div class="placementMgmtLinks">
                            [ 
                            <a href="../../index.cfm?curdoc=host_fam_info&hostid=#qGetStudentInfo.hostID#" target="_blank">More Information</a>  
                            |
                            <a href="javascript:displayUpdateField('divHostID','hostID');">Update</a> 							
                            
                            <!--- Display only if student has not arrived --->
                            <cfif NOT VAL(vHasStudentArrived)>
                            	| 
                                <a href="javascript:displayHiddenForm('unplaceStudentForm');">Unplace Student</a> 
                            </cfif>
                            
							<cfif qGetStudentInfo.welcome_family EQ 1 AND ListFind("1,2,3,4,5", CLIENT.userType)>
                                |
                                <a href="javascript:setFamilyAsPermanent();">Set as Permanent</a> 
                            </cfif>
                            ]                                
                        </div>
                    </cfif>
                </td>
                <td width="50%">
                    <label for="schoolID">School <em>*</em> </label>

                    <cfif VAL(qGetStudentInfo.schoolID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=school_info&schoolID=#qGetStudentInfo.schoolID#" target="_blank">More Information</a> 
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
                                autosuggest="cfc:nsmg.extensions.components.host.lookupHostFamily({cfautosuggestvalue}, #qGetStudentInfo.regionAssigned#)" 
                                class="xLargeField"
                                maxResultsDisplay="10"
                                showautosuggestloadingicon="true"
                                tooltip="Type host family name">
                                
							<cfinput type="hidden" name="hostID" id="hostID" value="#FORM.hostID#" bind="cfc:nsmg.extensions.components.host.getHostByName({hostIDSuggest})" />
                            
                            <p class="formNote">Type in host family last name and select it from the list. <br /> Only families assigned to the #qGetRegionAssigned.regionname# region will be listed.</p>

                            <!--- Welcome Family --->
                            <span>Is this a Welcome Family? <em>*</em></span>
                            <input type="radio" value="0" name="isWelcomeFamily" id="isWelcomeFamily0" <cfif FORM.isWelcomeFamily EQ 0> checked="checked" </cfif> >
                            <label for="isWelcomeFamily0">No</label>
                            &nbsp;
                            <input type="radio" value="1" name="isWelcomeFamily" id="isWelcomeFamily1" <cfif FORM.isWelcomeFamily EQ 1> checked="checked" </cfif> >
                            <label for="isWelcomeFamily1">Yes</label>
                        	
                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetStudentInfo.hostID)>
                            
								<!--- Relocation - Display only if student has arrived --->
                                <span>Is this a Relocation? <em>*</em></span>
                                <input type="radio" value="0" name="isRelocation" id="isRelocation0" checked="checked" #vDisableRelocation# <cfif FORM.isRelocation EQ 0> checked="checked" </cfif> >
                                <label for="isRelocation0">No</label>                            
                                &nbsp;                            
                                <input type="radio" value="1" name="isRelocation" id="isRelocation1" #vDisableRelocation# <cfif FORM.isRelocation EQ 1> checked="checked" </cfif> >
                                <label for="isRelocation1">Yes</label>
                        
								<!--- Reason --->
                                <span>Please indicate why you are changing the host family: <em>*</em></span>
                                <select name="hostIDReason" id="hostIDReason" class="xLargeField">
                                    <option value="" <cfif NOT LEN(FORM.hostIDReason)> checked="checked" </cfif> >Select a Reason</option>
                                    <option value="Incompatibility with host family" <cfif FORM.hostIDReason EQ 'Incompatibility with host family'> checked="checked" </cfif> >Incompatibility with host family</option>
                                    <option value="Conflict with host sibling" <cfif FORM.hostIDReason EQ 'Conflict with host sibling'> checked="checked" </cfif> >Conflict with host sibling</option>
                                    <option value="Incompatibility with school" <cfif FORM.hostIDReason EQ 'Incompatibility with school'> checked="checked" </cfif> >Incompatibility with school</option>
                                    <option value="Host family change of situation (e.g., move, illness, etc.)" <cfif FORM.hostIDReason EQ 'Host family change of situation (e.g., move, illness, etc.)'> checked="checked" </cfif> >Host family change of situation (e.g., move, illness, etc.)</option>
                                    <option value="Move from welcome family to permanent family" <cfif FORM.hostIDReason EQ 'Move from welcome family to permanent family'> checked="checked" </cfif> >Move from welcome family to permanent family</option>
                                    <option value="Paperwork was not submitted in a timely fashion" <cfif FORM.hostIDReason EQ 'Paperwork was not submitted in a timely fashion'> checked="checked" </cfif> >Paperwork was not submitted in a timely fashion</option>
                                    <option value="Other" <cfif FORM.hostIDReason EQ 'Other'> checked="checked" </cfif> >Other</option>				
                                </select>
    							
                        	</cfif>
                                                    
                        </div>
                        
                        <!--- Display Host Info --->
                        <div id="divHostIDInfo">
                        
							<!--- HF Deleted / Not Found  --->
                            <cfif VAL(qGetStudentInfo.hostID) AND NOT VAL(qGetHostInfo.recordCount)>
                            
                                <font color="##CC3300">Host Family (###qGetStudentInfo.hostid#) was not found in the system.</font>	
                             
                            <!--- HF Information --->   
                            <cfelseif VAL(qGetStudentInfo.hostID)>
                                
                                <cfif qGetStudentInfo.welcome_family EQ 1>
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
                            <cfif VAL(qGetStudentInfo.schoolID)>
								
                                <span>Please indicate why you are changing the school: <em>*</em></span>
                                <textarea name="schoolIDReason" id="schoolIDReason" class="largeTextArea">#FORM.schoolIDReason#</textarea>

                            </cfif>
                        
                        </div>
                        
                        <!--- Display School Info --->
                        <div id="divSchoolIDInfo">
                        
							<!--- School Deleted / Not Found --->    
                            <cfif VAL(qGetStudentInfo.schoolID) AND NOT VAL(qGetSchoolInfo.recordCount)>
                            
                                <font color="##CC3300">School (###qGetSchoolInfo.schoolID#) was not found in the system.</font>
                            
                            <!--- School Information --->       
                            <cfelseif VAL(qGetStudentInfo.schoolID)>
        
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
                    <label for="placeRepID">Placing Representative <em>*</em> </label>
                    
                    <cfif VAL(qGetStudentInfo.placeRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=user_info&userID=#qGetStudentInfo.placeRepID#" target="_blank">More Information</a> 
                            | 
                            <a href="javascript:displayUpdateField('divPlaceRepID','placeRepID');">Update</a> ] 
                        </div>
                    </cfif>
                </td>
                <td width="50%" style="padding-left:10px;">
                    <label for="areaRepID">Supervising Representative <em>*</em> </label>
                    
                    <cfif VAL(qGetStudentInfo.areaRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=user_info&userID=#qGetStudentInfo.areaRepID#" target="_blank">More Information</a> 
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
                            <cfif VAL(qGetStudentInfo.placeRepID)>
								
                                <span>Please indicate why you are changing the placing representative: <em>*</em></span>
                                <textarea name="placeRepIDReason" id="placeRepIDReason" class="largeTextArea">#FORM.placeRepIDReason#</textarea>

                            </cfif>
                        
                        </div>
                        
                        <!--- Display Placing Representative Info --->
                        <div id="divPlaceRepIDInfo">
                        
							<!--- Placing Representative Deleted / Not Found  --->
                            <cfif VAL(qGetStudentInfo.placeRepID) AND NOT VAL(qGetPlaceRepInfo.recordCount)>
                                
                                <font color="##CC3300">Placing Representative (###qGetStudentInfo.placeRepID#) was not found in the system.</font>
                                
                            <!--- Placing Representative Information ---> 
                            <cfelseif VAL(qGetStudentInfo.placeRepID)>
                            
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
                            <cfif VAL(qGetStudentInfo.areaRepID)>
								
                                <span>Please indicate why you are changing the supervising representative: <em>*</em></span>
                                <textarea name="areaRepIDReason" id="areaRepIDReason" class="largeTextArea">#FORM.areaRepIDReason#</textarea>                                

                            </cfif>
                        
                        </div>

                        <!--- Display Supervising Representative Info --->
                        <div id="divAreaRepIDInfo">
                        
							<!--- Supervising Representative Deleted / Not Found  --->
                            <cfif VAL(qGetStudentInfo.areaRepID) AND NOT VAL(qGetAreaRepInfo.recordCount)>
                                
                                <font color="##CC3300">Supervising Representative (###qGetStudentInfo.areaRepID#) was not found in the system.</font>
                                
                            <!--- Supervising Representative Information ---> 
                            <cfelseif VAL(qGetStudentInfo.areaRepID)>
                            
                                #qGetAreaRepInfo.firstName# #qGetAreaRepInfo.lastName# (###qGetAreaRepInfo.userID#) <br />
                                #qGetAreaRepInfo.city#, #qGetAreaRepInfo.state# #qGetAreaRepInfo.zip#
        
                            </cfif>
						
                        </div>
                                        
                    </div>
                        
                </td>
            </tr>
        </table>                        
    
    
        <!--- 2nd Representative Visit | Double Placement --->      
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
                <td width="50%">
                    <label for="secondVisitRepID">2<sup>nd</sup> Representative Visit</label>
                    
                    <cfif VAL(qGetStudentInfo.secondVisitRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=user_info&userID=#qGetStudentInfo.secondVisitRepID#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divSecondVisitRepID','secondVisitRepID');">Update</a> ] 
                        </div>
					</cfif>                    
                </td>
                <td width="50%">
                	<label for="doublePlacementID">Double Placement &nbsp; (Optional)</label>
                    
                    <cfif VAL(qGetStudentInfo.doublePlace)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=student_info&studentID=#qGetStudentInfo.doublePlace#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divDoublePlace','doublePlace');">Update</a> ] 
                        </div>
					</cfif>                    
                </td>
            </tr>
            <tr>
                <!--- 2nd Representative Visit ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top; border-right:1px solid ##edeff4;">
                	
                    <div class="placementMgmtInfo">
						
						<!--- Choose 2nd Representative Visit --->
                        <div id="divSecondVisitRepID" class="displayNone">
                            
                            <select name="secondVisitRepID" id="secondVisitRepID" class="xLargeField">
                                <option value="0">Select a 2nd Representative Visit</option>
                                <cfloop query="qGetAvailableReps">
                                    <option value="#qGetAvailableReps.userid#" <cfif qGetAvailableReps.userID EQ FORM.secondVisitRepID> selected="selected" </cfif> >
                                        #qGetAvailableReps.firstname# #qGetAvailableReps.lastname# (###qGetAvailableReps.userid#)
                                    </option>
                                </cfloop>
                            </select>

                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetStudentInfo.secondVisitRepID)>
                                
                                <span>Please indicate why you are changing the second visit representative: <em>*</em></span>
                                <textarea name="secondVisitRepIDReason" id="secondVisitRepIDReason" class="largeTextArea">#FORM.secondVisitRepIDReason#</textarea>  
                                                              
                            </cfif>
                        
                        </div>
                        
                        <!--- Display 2nd Representative Visit Info --->
                        <div id="divSecondVisitRepIDInfo">
							
							<!--- 2nd Representative Deleted / Not Found  --->
                            <cfif VAL(qGetStudentInfo.secondVisitRepID) AND NOT VAL(qGetSecondVisitRepID.recordCount)>
                                
                                <font color="##CC3300">2<sup>nd</sup> Representative (###qGetStudentInfo.secondVisitRepID#) was not found in the system.</font>
                                
                            <!--- 2nd Representative Information ---> 
                            <cfelseif VAL(qGetStudentInfo.secondVisitRepID)>
                            
                                #qGetSecondVisitRepID.firstName# #qGetSecondVisitRepID.lastName# (###qGetSecondVisitRepID.userID#) <br />
                                #qGetSecondVisitRepID.city#, #qGetSecondVisitRepID.state# #qGetSecondVisitRepID.zip#
        					
                            <cfelseif CLIENT.userType EQ 7>
                            	
                                2<sup>nd</sup> Representative will be assigned by your Regional Advisor/Manager.
                            
                            </cfif>
                        
                        </div>
                           
                    </div>
                                        
                </td>
                
                <!--- Double Placement ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top;">
                    
                    <div class="placementMgmtInfo">
                    
						<!--- Choose Double Placement --->
                        <div id="divDoublePlace" class="displayNone">
                            
                            <select name="doublePlace" id="doublePlace" class="xLargeField">
                                <cfif NOT VAL(qGetStudentInfo.doublePlace)>
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
                            
                            <p class="formNote">List of placed students assigned to the #qGetRegionAssigned.regionname# region</p>

                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetStudentInfo.doublePlace)>
                                
                                <span>Please indicate why you are changing the double placement: <em>*</em></span>
                                <textarea name="doublePlaceReason" id="doublePlaceReason" class="largeTextArea">#FORM.doublePlaceReason#</textarea>  
                                                              
                            </cfif>
                        
                        </div>
                        
                        <!--- Display Double Placement Info --->
                        <div id="divDoublePlaceInfo">
							
							<!--- Double Placement Deleted / Not Found  --->
                            <cfif VAL(qGetStudentInfo.doublePlace) AND NOT VAL(qGetDoublePlacementInfo.recordCount)>
                                
                                <font color="##CC3300">Double Placement (###qGetStudentInfo.doublePlace#) was not found in the system.</font>
                                
                            <!--- Double Placement Information ---> 
                            <cfelseif VAL(qGetStudentInfo.doublePlace)>
                            
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
                <td align="center"><input name="Submit" type="image" src="../../student_app/pics/save.gif" border="0" alt="Save"/></td>
            </tr>                
        </table>    

	</cfform>
	
</cfoutput>