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
    <cfparam name="FORM.changePlacementExplanation" default="" />
    <cfparam name="FORM.dateSetHostPermanent" default="#DateFormat(now(), 'mm/dd/yyyy')#" />
    <cfparam name="FORM.isWelcomeFamily" default="" />
    <cfparam name="FORM.isRelocation" default="" />
    <cfparam name="FORM.dateRelocated" default="" />
    <!--- School --->
    <cfparam name="FORM.schoolID" default="0" />  
    <cfparam name="FORM.schoolIDReason" default="" />
    <!--- Placing Representative --->
    <cfparam name="FORM.placeRepID" default="#CLIENT.userID#" />
    <cfparam name="FORM.placeRepIDReason" default="" />
    <!--- Area Representative --->
    <cfparam name="FORM.areaRepID" default="#CLIENT.userID#" />    
    <cfparam name="FORM.areaRepIDReason" default="" />
    <!--- Double Placement --->
    <cfparam name="FORM.doublePlace" default="0" /> 
    <cfparam name="FORM.doublePlaceReason" default="" /> 
    <!--- Reject / Unplacing --->
    <cfparam name="FORM.reason" default="" /> 

    <cfscript>
	
		// Check if Student has arrived
		vHasStudentArrived = 0;
		vDisableRelocation = '';
		
		if ( isDate(qGetArrival.dep_date) AND qGetArrival.dep_date LT now() ) {
			vHasStudentArrived = 1;
			vDisableRelocation = 'readonly="readonly"';
		} 
		
		// Get Training Options
		qGetRelocationReason = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='changePlacementReason');

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

				if ( NOT LEN(FORM.isRelocation) ) {
					SESSION.formErrors.Add("You must answer whether is a relocation or not");
				}	
				
				if ( VAL(FORM.isRelocation) AND NOT isDate(FORM.dateRelocated) ) {
					SESSION.formErrors.Add("You must enter a relocation date");
				}
			
				if ( NOT LEN(FORM.changePlacementExplanation) ) {
					SESSION.formErrors.Add("You must indidcate why you are changing the host family");
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
					assignedID = FORM.assignedID,
					hostID = FORM.hostID,
					isWelcomeFamily = FORM.isWelcomeFamily,
					isRelocation = FORM.isRelocation,
					dateRelocated = FORM.dateRelocated,
					datePlaced = FORM.dateRelocated,
					changePlacementExplanation = FORM.changePlacementExplanation,
					schoolID = FORM.schoolID,
					schoolIDReason = FORM.schoolIDReason,
					placeRepID = FORM.placeRepID,
					placeRepIDReason = FORM.placeRepIDReason,
					areaRepID = FORM.areaRepID,
					areaRepIDReason = FORM.areaRepIDReason,
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
			/*
			if ( NOT VAL(FORM.hostID) ) {
				SESSION.formErrors.Add("You must select a host family, if you do not see it on the list, please close this window and add a host family");
			}			

			if ( NOT LEN(FORM.isWelcomeFamily) ) {
				SESSION.formErrors.Add("You must answer whether is a welcome family or not");
			}			
			*/			
			
			if ( NOT VAL(FORM.schoolID) ) {
				SESSION.formErrors.Add("You must select a school from the list");
			}			
			
			/*
			if ( NOT VAL(FORM.placeRepID) ) {
				SESSION.formErrors.Add("You must select a placing representative from the list");
			}			

			if ( NOT VAL(FORM.areaRepID) ) { 
				SESSION.formErrors.Add("You must select a supervising representative from the list");
			}	
			*/ 
			
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
					assignedID = FORM.assignedID,
					hostID = FORM.hostID,
					isWelcomeFamily = FORM.isWelcomeFamily,
					schoolID = FORM.schoolID,
					placeRepID = FORM.placeRepID,
					areaRepID = FORM.areaRepID,
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
		
		// UNPLACE STUDENT
		} else if ( FORM.subAction EQ 'unplace' ) {
			
			if ( NOT LEN(FORM.reason) ) { 
				// Get all the missing items in a list
				SESSION.formErrors.Add("You must enter a reason for unplacing this student");
			}	

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Unplace Student - Insert into history
				APPLICATION.CFC.STUDENT.unplaceStudent(
					studentID = FORM.studentID,
					assignedID = FORM.assignedID,
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					reason = FORM.reason
				 );
				
				// Set Page Message
				SESSION.pageMessages.Add("Student has been unplaced.");
				
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
					assignedID = FORM.assignedID,
					changedBy = CLIENT.userID,								 
					userType = CLIENT.userType,
					dateSetHostPermanent=FORM.dateSetHostPermanent
				 );
	
				// Set Page Message
				SESSION.pageMessages.Add("Host Family has been set as permanent.");
				
				// Reload page
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
			}

		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetStudentInfo.studentID;
			FORM.assignedID = qGetStudentInfo.assignedID;
			FORM.uniqueID = qGetStudentInfo.uniqueID;
			FORM.hostID = qGetStudentInfo.hostID;		
			FORM.isWelcomeFamily = qGetStudentInfo.isWelcomeFamily;		
			FORM.schoolID = qGetStudentInfo.schoolID;
			FORM.placeRepID = qGetStudentInfo.placeRepID;
			FORM.areaRepID = qGetStudentInfo.areaRepID;
			FORM.doublePlace = qGetStudentInfo.doublePlace;		
			
			// Set subAction to placementInformation if any information is missing
			if ( vPlacementStatus EQ 'Incomplete' ) {
				FORM.subAction = 'placementInformation';	
			}
			
			// Set Relocation Value
			if ( VAL(vHasStudentArrived) ) {
				FORM.isRelocation = 1;
			}
			
		}
		
		// Set number of errors
		FORM.validationErrors = SESSION.formErrors.length();
	</cfscript>
    
    <!--- Get School Info --->
    <cfquery name="qGetSchoolInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	ps.schoolID,
            ps.schoolname, 
            ps.city,
            ps.state,
            ps.zip,
            ps.hostFamilyRate,
            psd.year_begins, 
            psd.semester_begins, 
            psd.semester_ends, 
            psd.year_ends
        FROM 
        	php_schools ps
        LEFT JOIN 
        	php_school_dates psd on psd.schoolID = ps.schoolID
            AND 
                psd.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetProgramInfo.seasonID)#">
        WHERE 
        	ps.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.schoolID)#">
    </cfquery>

</cfsilent>

<script type="text/javascript">
	// Display warning when page is ready
	$(document).ready(function() {
							   
		// opener.location.reload();
		// Display Form Fields
		displayFormFields();
	});
	
	var sendPIS = function() {
		alert("HELLO");
	}
	
	var displayFormFields = function() { 			
		
		var vDisplaySaveButton = 0;
		
		<cfif FORM.subAction EQ 'placementInformation' OR vPlacementStatus EQ 'unplaced'>
			
			// Display Only if entering placement information
			if ( $("#hostID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				$("#divHostID").slideDown();
				displayRelocationDate();
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

		// Display only if unplacing a student
		<cfelseif FORM.subAction EQ 'unplace'>
		
			displayHiddenForm('unplaceStudentForm');
			
		// Display only if setting family as permanent
		<cfelseif FORM.subAction EQ 'setFamilyAsPermanent'>

			displayHiddenForm('setAsPermanentForm');

		</cfif>
			
		// Always show the double placement if student is not assigned and not submitting a rejection form
		if ( $("#doublePlace").val() == 0 || $("#validationErrors").val() != 0 ) { 
			vDisplaySaveButton = 1;
			$("#divDoublePlaceInfo").slideUp();
			$("#divDoublePlace").slideDown();
		}

		<cfif ListFindNoCase(FORM.subAction, "updatehostID")>
			
			if ( $("#hostID").val() == 0 || $("#validationErrors").val() != 0 ) {
				vDisplaySaveButton = 1;
				// Hide Information
				$("#divHostIDInfo").slideUp();
				$("#divHostID").slideDown();
				displayRelocationDate();
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
	
	// Display Relocation Date Form
	var displayRelocationDate = function() {
		
		// Check if relocation is checked 		
		if ( $("#isRelocation1").attr('checked') ) {
			// Fade In
			$("#divRelocationDate").fadeIn("slow");
		} else {
			// Fade Out
			$("#divRelocationDate").fadeOut("slow");
		}
		
	}	
</script>

<cfoutput>

	<cfscript>
		SESSION.pageMessages.Add("Student has been unplaced.");
	</cfscript>
    
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
            
            <cfcase value="Pending,Approved">
                <tr>
                    <td align="center" style="padding-bottom:10px; color:##3b5998;">
                        Last status updated on #DateFormat(qGetStudentInfo.dateApproved, 'mm/dd/yyyy')# at #TimeFormat(qGetStudentInfo.dateApproved, 'hh:mm tt')#.
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <a href="javascript:openPopUp('../../reports/PlacementInfoSheet.cfm?uniqueID=#FORM.uniqueID#', 900, 600);"><img src="../../pics/previewpis.gif" border="0"></a>
                    </td>
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

        <tr>
            <td align="center">
                
                <!--- Unplace Student ---->
                <form name="unplaceStudentForm" id="unplaceStudentForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="displayNone" style="margin-top:10px; margin-bottom:10px;">
                    <input type="hidden" name="subAction" id="subAction" value="unplace" />
                    <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
                    <input type="hidden" name="assignedID" id="assignedID" value="#FORM.assignedID#" />

                    <table width="680px" border="0" cellpadding="4" cellspacing="0" class="" align="center">                            				
                        <tr class="reportCenterTitle"> 
                            <th>UNPLACE STUDENT</th>
                        </tr>
                        <tr>
                            <td class="placementMgmtInfo" align="center">
                                <label class="reportTitleLeftClean" for="unplaceReason">Please provide details as to why you are unplacing this student:</label>
                                <textarea name="reason" id="reason" class="xLargeTextArea">#FORM.reason#</textarea>
                                <input type="image" name="submit" src="../../pics/save.gif" alt="Unplace Student" style="display:block;" />    
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
                                <input type="image" name="submit" src="../../pics/save.gif" alt="Set Family As Permanent" style="display:block;" />    
                            </td>
                        </tr>
                    </table>

                </form> 
                
            </td>
        </tr>    
    </table>                                                

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
        <input type="hidden" name="assignedID" id="assignedID" value="#FORM.assignedID#" />
        <input type="hidden" name="validationErrors" id="validationErrors" value="#FORM.validationErrors#" />

		<!--- School Information / Host Family --->
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
                <td width="50%">
                    <label for="schoolID">School <em>*</em> </label>

                    <cfif VAL(qGetStudentInfo.schoolID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=forms/view_school&sc=#qGetStudentInfo.schoolID#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divSchoolID','schoolID');">Update</a> 
                            
                            <!--- Display only if student has not arrived --->
                            <cfif NOT VAL(vHasStudentArrived)>
                            	| 
                                <a href="javascript:displayHiddenForm('unplaceStudentForm');">Unplace Student</a> 
                            </cfif>
                            
                            ]                        
                        </div>
					</cfif> 
                </td>
                <td width="50%">
                    <label for="hostID">Host Family </label>
                    
                    <cfif VAL(qGetStudentInfo.hostID)>
                        <div class="placementMgmtLinks">
                            [ 
                            <a href="../../index.cfm?curdoc=host_fam_info&hostid=#qGetStudentInfo.hostID#" target="_blank">More Information</a>  
                            |
                            <a href="javascript:displayUpdateField('divHostID','hostID'); displayRelocationDate();">Update</a> 							
                            
							<cfif qGetStudentInfo.isWelcomeFamily EQ 1 AND ListFind("1,2,3,4,5", CLIENT.userType)>
                                |
                                <a href="javascript:displayHiddenForm('setAsPermanentForm');">Set as Permanent</a> 
                            </cfif>
                            ]                                
                        </div>
                    </cfif>
                </td>
            </tr>
            <tr style="margin:10px;">
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
                                autosuggest="cfc:internal.extensions.components.host.lookupHostFamily({cfautosuggestvalue},true)" 
                                class="xLargeField"
                                maxResultsDisplay="10"
                                showautosuggestloadingicon="true"
                                tooltip="Type host family name">
                                
							<cfinput type="hidden" name="hostID" id="hostID" value="#FORM.hostID#" bind="cfc:internal.extensions.components.host.getHostByName({hostIDSuggest})" />
                            
                            <p class="formNote">
                            	Type in host family last name and select it from the list.
                            	<br/>
                                NOTE: If you do not see the family you are looking for listed check their CBCs.
                          	</p>

                            <!--- Welcome Family --->
                            <span>Is this a Welcome Family? <em>*</em></span>
                            <input type="radio" name="isWelcomeFamily" id="isWelcomeFamily0" value="0" <cfif FORM.isWelcomeFamily EQ 0> checked="checked" </cfif> >
                            <label for="isWelcomeFamily0">No</label>
                            &nbsp;
                            <input type="radio" name="isWelcomeFamily" id="isWelcomeFamily1" value="1" <cfif FORM.isWelcomeFamily EQ 1> checked="checked" </cfif> >
                            <label for="isWelcomeFamily1">Yes</label>
                        	
                            <!--- Display only if it's an update --->
                            <cfif VAL(qGetStudentInfo.hostID)>
                            
								<!--- Relocation - Display only if student has arrived --->
                                <span>Is this a Relocation? <em>*</em></span>
                                <input type="radio" name="isRelocation" id="isRelocation0" value="0" onclick="displayRelocationDate();" #vDisableRelocation# <cfif FORM.isRelocation EQ 0> checked="checked" </cfif> >
                                <label for="isRelocation0">No</label>                            
                                &nbsp;                            
                                <input type="radio" name="isRelocation" id="isRelocation1" value="1" onclick="displayRelocationDate();" #vDisableRelocation# <cfif FORM.isRelocation EQ 1> checked="checked" </cfif> > 
                                <label for="isRelocation1">Yes</label>
                                
                                <!--- Relocation Date --->
                                <div id="divRelocationDate" class="displayNone">
                                    <span>Relocation Date <em>*</em></span>  
                                    <input type="text" name="dateRelocated" id="dateRelocated" class="datePicker" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#">
                                </div>
                                
								<!--- Explain --->
                                <span>Please indicate why you are changing the host family <em>*</em></span>                             
                                <textarea name="changePlacementExplanation" id="changePlacementExplanation" class="largeTextArea">#FORM.changePlacementExplanation#</textarea>
                                                                
                        	</cfif>
                                                    
                        </div>
                        
                        <!--- Display Host Info --->
                        <div id="divHostIDInfo">
                        
							<!--- HF Deleted / Not Found  --->
                            <cfif VAL(qGetStudentInfo.hostID) AND NOT VAL(qGetHostInfo.recordCount)>
                            
                                <font color="##CC3300">Host Family (###qGetStudentInfo.hostid#) was not found in the system.</font>	
                             
                            <!--- HF Information --->   
                            <cfelseif VAL(qGetStudentInfo.hostID)>
                                
                                <cfif qGetStudentInfo.isWelcomeFamily EQ 1>
                                    *** This is a Welcome Family ***<br />
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
            </tr>            
        </table>
        
        
        <!--- Placing Representative | Supervising Representative --->      
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
                <td width="50%">
                    <label for="placeRepID">Placing Representative </label>
                    
                    <cfif VAL(qGetStudentInfo.placeRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=users/user_info&userID=#qGetStudentInfo.placeRepID#" target="_blank">More Information</a> 
                            | 
                            <a href="javascript:displayUpdateField('divPlaceRepID','placeRepID');">Update</a> ] 
                        </div>
                    </cfif>
                </td>
                <td width="50%" style="padding-left:10px;">
                    <label for="areaRepID">Supervising Representative </label>
                    
                    <cfif VAL(qGetStudentInfo.areaRepID)>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=users/user_info&userID=#qGetStudentInfo.areaRepID#" target="_blank">More Information</a> 
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
    
    
        <!--- Double Placement --->      
        <table width="90%" border="0" cellpadding="2" cellspacing="0" class="sectionBorderOnly" align="center">                            				
            <tr class="reportTitleLeftClean">
                <td width="50%">
                	<label for="doublePlacementID">Double Placement &nbsp; (optional)</label>
                    
                    <cfif VAL(qGetStudentInfo.doublePlace)>
                    <cfquery name="doubleUniqueID" datasource="smg">
                    select uniqueid
                    from smg_students
                    where studentid = #qGetStudentInfo.doublePlace#
                    </cfquery>
                        <div class="placementMgmtLinks">
                            [ <a href="../../index.cfm?curdoc=student/student_info&unqid=#doubleUniqueID.uniqueid#" target="_blank">More Information</a> 
                            |
                            <a href="javascript:displayUpdateField('divDoublePlace','doublePlace');">Update</a> ] 
                        </div>
					</cfif>                    
                </td>
                <td width="50%">&nbsp;</td>
            </tr>
            <tr>
                <!--- Double Placement ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top; border-right:1px solid ##edeff4;">
                               
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
                                        #qGetAvailableDoublePlacement.firstname# #qGetAvailableDoublePlacement.familyLastName# (###qGetAvailableDoublePlacement.studentID#) - #qGetAvailableDoublePlacement.programName#
                                    </option>
                                </cfloop>
                            </select>

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
                <!---  ---> 
                <td width="50%" style="padding:0px 0px 10px 10px;vertical-align:top;">

                    <div class="placementMgmtInfo">
						
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
                <td align="center"><input name="Submit" type="image" src="../../pics/save.gif" border="0" alt="Save"/></td>
            </tr>                
        </table>    

	</cfform>
	
</cfoutput>