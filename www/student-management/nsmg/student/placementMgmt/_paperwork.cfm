<!--- ------------------------------------------------------------------------- ----
	
	File:		_paperwork.cfm
	Author:		Marcus Melo
	Date:		June 15, 2011
	Desc:		Placement Paperwork Management

	Updated:	04/03/2012 - Displaying non-compliant message in line instead of gui
				03/30/2012 - Displaying when records are out of compliance on the fly
				03/09/2012 - Adding double placement docs to the compliance check
				03/02/2012 - Combining _paperworkHistory and _paperwork
				03/02/2012 - Added 3 documents for double placement paperwork
				03/01/2012 - Added 2 documents for single placement paperwork														
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    
	<!--- Single Person Placement --->
    <cfparam name="FORM.doc_single_place_auth" default="">
    <cfparam name="FORM.doc_single_ref_form_1" default="">
    <cfparam name="FORM.doc_single_ref_check1" default="">
    <cfparam name="FORM.doc_single_ref_form_2" default="">
    <cfparam name="FORM.doc_single_ref_check2" default="">
    <cfparam name="FORM.doc_single_parents_sign_date" default="">
    <cfparam name="FORM.doc_single_student_sign_date" default="">
    <!--- Placement Paperwork --->
    <cfparam name="FORM.dateRelocated" default="">
    <cfparam name="FORM.doc_full_host_app_date" default="">
    <cfparam name="FORM.doc_letter_rec_date" default="">
    <cfparam name="FORM.doc_rules_rec_date" default="">
    <cfparam name="FORM.doc_rules_sign_date" default="">
    <cfparam name="FORM.doc_photos_rec_date" default="">
    <cfparam name="FORM.doc_bedroom_photo" default="">
    <cfparam name="FORM.doc_bathroom_photo" default="">
    <cfparam name="FORM.doc_kitchen_photo" default="">
    <cfparam name="FORM.doc_living_room_photo" default="">
    <cfparam name="FORM.doc_outside_photo" default="">
    <cfparam name="FORM.doc_school_profile_rec" default="">
    <cfparam name="FORM.doc_conf_host_rec" default="">
    <cfparam name="FORM.doc_date_of_visit" default="">
    <cfparam name="FORM.doc_ref_form_1" default="">
    <cfparam name="FORM.doc_ref_check1" default="">
    <cfparam name="FORM.doc_ref_form_2" default="">
    <cfparam name="FORM.doc_ref_check2" default="">
    <cfparam name="FORM.doc_income_ver_date" default="">    
    <!--- Arrival Compliance --->
    <cfparam name="FORM.doc_school_accept_date" default="">
    <cfparam name="FORM.doc_school_sign_date" default="">
    <!--- Arrival Orientation --->
    <cfparam name="FORM.stu_arrival_orientation" default="">
    <cfparam name="FORM.host_arrival_orientation" default="">
    <cfparam name="FORM.doc_class_schedule" default=""> 
    <!--- Double Placement Paperwork --->
    <cfparam name="FORM.doublePlacementIDList" default="">
    
    <cfscript>
		// Get Most Recent CBCs
		qGetMostRecentCBC = APPLICATION.CFC.CBC.getLastHostCBC(hostID=qGetPlacementHistoryByID.hostID);
		
		// Get Double Placement History Paperwork
		qGetDoublePlacementPaperworkHistory = APPLICATION.CFC.STUDENT.getDoublePlacementPaperworkHistory(historyID=qGetPlacementHistoryByID.historyID, studentID=qGetStudentInfo.studentID);

		// Param Double Placement Paperwork FORM Variables 
		for ( i=1; i LTE qGetDoublePlacementPaperworkHistory.recordCount; i=i+1 ) {
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_isDoublePlacementPaperworkRequired" default="1";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementParentsDateSigned" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementStudentDateSigned" default="";
			param name="FORM.#qGetDoublePlacementPaperworkHistory.ID[i]#_doublePlacementHostFamilyDateSigned" default="";
		}
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {
			
			// Update fields on the student table
			APPLICATION.CFC.STUDENT.updatePlacementPaperworkHistory(
				studentID = FORM.studentID,
				historyID = qGetPlacementHistoryByID.historyID,
				// Single Person Placement Paperwork
				doc_single_place_auth = FORM.doc_single_place_auth,
				doc_single_ref_form_1 = FORM.doc_single_ref_form_1,
				doc_single_ref_check1 = FORM.doc_single_ref_check1,
				doc_single_ref_form_2 = FORM.doc_single_ref_form_2,
				doc_single_ref_check2 = FORM.doc_single_ref_check2,
				doc_single_parents_sign_date = FORM.doc_single_parents_sign_date,
				doc_single_student_sign_date = FORM.doc_single_student_sign_date,
				// Placement Paperwork
				dateRelocated = FORM.dateRelocated,
				doc_full_host_app_date = FORM.doc_full_host_app_date,
				doc_letter_rec_date = FORM.doc_letter_rec_date,
				doc_rules_rec_date = FORM.doc_rules_rec_date,
				doc_rules_sign_date = FORM.doc_rules_sign_date,
				doc_photos_rec_date = FORM.doc_photos_rec_date,
				doc_bedroom_photo = FORM.doc_bedroom_photo,
				doc_bathroom_photo = FORM.doc_bathroom_photo,
				doc_kitchen_photo = FORM.doc_kitchen_photo,
				doc_living_room_photo = FORM.doc_living_room_photo,
				doc_outside_photo = FORM.doc_outside_photo,
				doc_school_profile_rec = FORM.doc_school_profile_rec,
				doc_conf_host_rec = FORM.doc_conf_host_rec,
				doc_date_of_visit = FORM.doc_date_of_visit,
				doc_ref_form_1 = FORM.doc_ref_form_1,
				doc_ref_check1 = FORM.doc_ref_check1,
				doc_ref_form_2 = FORM.doc_ref_form_2,
				doc_ref_check2 = FORM.doc_ref_check2,
				doc_income_ver_date = FORM.doc_income_ver_date,
				// Arrival Compliance
				doc_school_accept_date = FORM.doc_school_accept_date,
				doc_school_sign_date = FORM.doc_school_sign_date,
				// Arrival Orientation
				stu_arrival_orientation = FORM.stu_arrival_orientation,
				host_arrival_orientation = FORM.host_arrival_orientation,
				doc_class_schedule = FORM.doc_class_schedule
			);

			// Update Double Placement Paperwork
			for (i=1;i LTE ListLen(FORM.doublePlacementIDList); i=i+1) {
				
				APPLICATION.CFC.STUDENT.updateDoublePlacementTrackingHistory(
					ID = ListGetAt(FORM.doublePlacementIDList, i),
					isDoublePlacementPaperworkRequired = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_isDoublePlacementPaperworkRequired"],
					doublePlacementParentsDateSigned = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementParentsDateSigned"],
					doublePlacementStudentDateSigned = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementStudentDateSigned"],
					doublePlacementHostFamilyDateSigned = FORM[ListGetAt(FORM.doublePlacementIDList, i) & "_doublePlacementHostFamilyDateSigned"]
				);		
				
			}

		  // Set Page Message
		  SESSION.pageMessages.Add("Form successfully submitted.");
		  
		  // Reload page
		  location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetPlacementHistoryByID.studentID;
			
			// Single Person Placement Paperwork
			FORM.doc_single_place_auth = qGetPlacementHistoryByID.doc_single_place_auth;
			FORM.doc_single_ref_form_1 = qGetPlacementHistoryByID.doc_single_ref_form_1;
			FORM.doc_single_ref_check1 = qGetPlacementHistoryByID.doc_single_ref_check1;
			FORM.doc_single_ref_form_2 = qGetPlacementHistoryByID.doc_single_ref_form_2;
			FORM.doc_single_ref_check2 = qGetPlacementHistoryByID.doc_single_ref_check2;
			FORM.doc_single_parents_sign_date = qGetPlacementHistoryByID.doc_single_parents_sign_date;
			FORM.doc_single_student_sign_date = qGetPlacementHistoryByID.doc_single_student_sign_date;
			
			// Placement Paperwork
			FORM.dateRelocated = qGetPlacementHistoryByID.dateRelocated;
			FORM.doc_full_host_app_date = qGetPlacementHistoryByID.doc_full_host_app_date;
			FORM.doc_letter_rec_date = qGetPlacementHistoryByID.doc_letter_rec_date;
			FORM.doc_rules_rec_date = qGetPlacementHistoryByID.doc_rules_rec_date;
			FORM.doc_rules_sign_date = qGetPlacementHistoryByID.doc_rules_sign_date;
			FORM.doc_photos_rec_date = qGetPlacementHistoryByID.doc_photos_rec_date;
			FORM.doc_bedroom_photo = qGetPlacementHistoryByID.doc_bedroom_photo;
			FORM.doc_bathroom_photo = qGetPlacementHistoryByID.doc_bathroom_photo;
			FORM.doc_kitchen_photo = qGetPlacementHistoryByID.doc_kitchen_photo;
			FORM.doc_living_room_photo = qGetPlacementHistoryByID.doc_living_room_photo;
			FORM.doc_outside_photo = qGetPlacementHistoryByID.doc_outside_photo;
			FORM.doc_school_profile_rec = qGetPlacementHistoryByID.doc_school_profile_rec;
			FORM.doc_conf_host_rec = qGetPlacementHistoryByID.doc_conf_host_rec;
			FORM.doc_date_of_visit = qGetPlacementHistoryByID.doc_date_of_visit;
			FORM.doc_ref_form_1 = qGetPlacementHistoryByID.doc_ref_form_1;
			FORM.doc_ref_check1 = qGetPlacementHistoryByID.doc_ref_check1;
			FORM.doc_ref_form_2 = qGetPlacementHistoryByID.doc_ref_form_2;
			FORM.doc_ref_check2 = qGetPlacementHistoryByID.doc_ref_check2;
			FORM.doc_income_ver_date = qGetPlacementHistoryByID.doc_income_ver_date;
			
			// Arrival Compliance
			FORM.doc_school_accept_date = qGetPlacementHistoryByID.doc_school_accept_date;
			FORM.doc_school_sign_date = qGetPlacementHistoryByID.doc_school_sign_date;
			
			// Arrival Orientation
			FORM.stu_arrival_orientation = qGetPlacementHistoryByID.stu_arrival_orientation;
			FORM.host_arrival_orientation = qGetPlacementHistoryByID.host_arrival_orientation;
			FORM.doc_class_schedule = qGetPlacementHistoryByID.doc_class_schedule;
			
			// Double Placement Paperwork
			FORM.doublePlacementIDList = ValueList(qGetDoublePlacementPaperworkHistory.ID);
			for ( i=1; i LTE qGetDoublePlacementPaperworkHistory.recordCount; i=i+1 ) {
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_isDoublePlacementPaperworkRequired"] = qGetDoublePlacementPaperworkHistory.isDoublePlacementPaperworkRequired[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementParentsDateSigned"] = qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateSigned[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementStudentDateSigned"] = qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateSigned[i];
				FORM[qGetDoublePlacementPaperworkHistory.ID[i] & "_doublePlacementHostFamilyDateSigned"] = qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateSigned[i];
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
					vDateStartWindowCompliance = qGetPlacementHistoryByID.datePlaced;
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
            
</cfsilent>

<script language="javascript">
<!-- Begin
	var todaysDate = new Date();
	var prettyDate =(todaysDate.getMonth()+1) + '/' + todaysDate.getDate() + '/' + todaysDate.getFullYear();

	$(document).ready(function() {
	
		// Office users are able to update this page
		<cfif ListFind("1,2,3,4", CLIENT.userType)>
			showEditPage();
		<cfelse>
			readOnlyPage();
		</cfif>
		
		loopNonCompliant();
		
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
			$("#dateOfVisit").css({'background-color' : '#FFFFFF'});	
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
        <input type="hidden" name="doublePlacementIDList" value="#FORM.doublePlacementIDList#">
        <input type="hidden" name="dateOf2ndVisit" id="dateOf2ndVisit" value="#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#">
        <input type="hidden" name="dateEndWindowCompliance" id="dateEndWindowCompliance" value="#DateFormat(vDateEndWindowCompliance, 'mm/dd/yyyy')#">

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
                        <td class="reportTitleLeftClean" width="50%">Host Family: #qGetHostInfo.familyLastName# (###qGetHostInfo.hostID#)</td>
                        <td class="reportTitleLeftClean" width="45%">
                        	<cfif ListFind("1,2,3,4", CLIENT.userType)>
                                <a href="javascript:displayHiddenFormFields();" id="displayFormFieldLink"title="display/hide fields" style="float:right; padding-right:10px;">[ Display Fields ]</a>
                            <cfelse>
                            	&nbsp;
                            </cfif>
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
                            <td class="reportTitleLeftClean" width="50%">Single Placement Paperwork</td>
                            <td class="reportTitleLeftClean" width="45%">Date</td>
                        </tr>
					</table>
                    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <!--- Single Person Placement Verification --->
                        <tr> 
                            <td width="5%" class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_place_auth" id="check_doc_single_place_auth" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_place_auth');" <cfif isDate(FORM.doc_single_place_auth)>checked</cfif> >
                            </td>
                            <td width="50%"><label for="check_doc_single_place_auth">Single Person Placement Verification</label></td>
                            <td width="45%">
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_place_auth" id="doc_single_place_auth" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#">
                            </td>
                        </tr>

						<!--- Natural Family Date Signed --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_parents_sign_date">Natural Family Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_parents_sign_date, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_parents_sign_date" id="doc_single_parents_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_parents_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_parents_sign_date');">
                            </td>
                        </tr>
                        
                        <!--- Student Date Signed --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_student_sign_date">Student Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_student_sign_date, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_student_sign_date" id="doc_single_student_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_student_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_student_sign_date');">
                            </td>
                        </tr>
                    
                        <!--- Single Person Placement Reference 1 --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_ref_form_1" id="check_doc_single_ref_form_1" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_ref_form_1');" <cfif isDate(FORM.doc_single_ref_form_1)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_single_ref_form_1">Single Person Placement Reference 1</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_form_1, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_form_1" id="doc_single_ref_form_1" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_single_ref_form_1, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Date of Single Placement Reference Check 1 --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_ref_check1">Date of Single Placement Reference Check 1</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_check1" id="doc_single_ref_check1" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_ref_check1');">
                            </td>
                        </tr>
                        
                        <!--- Single Person Placement Reference 2 --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_ref_form_2" id="check_doc_single_ref_form_2" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_ref_form_2');" <cfif isDate(FORM.doc_single_ref_form_2)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_single_ref_form_2">Single Person Placement Reference 2</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_form_2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_form_2" id="doc_single_ref_form_2" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_single_ref_form_2, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Date of Single Placement Reference Check 2 --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_ref_check2">Date of Single Placement Reference Check 2</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_check2" id="doc_single_ref_check2" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_single_ref_check2');">
                            </td>
                        </tr>
                    </table>
                </cfif> 
                <!--- End of Single Placement Paperwork --->

				<table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="50%">Paperwork</td>
                        <td class="reportTitleLeftClean" width="45%">Date</td>
                    </tr>
                </table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 

                    <!--- PIS Approved --->
                    <tr> 
                        <td width="5%" class="paperworkLeftColumn"><input type="checkbox" name="datePlacedCheckBox" id="datePlacedCheckBox" class="editPage displayNone" <cfif isDate(qGetPlacementHistoryByID.datePlaced)>checked</cfif> disabled="disabled"></td>
                        <td width="50%"><label>Date Placed ( Headquarters Approval Date )</label></td>
                        <td width="45%">
                        	<span class="readOnly displayNone">#DateFormat(qGetPlacementHistoryByID.datePlaced, 'mm/dd/yyyy')#</span>
                            <input type="text" name="datePlaced" id="datePlaced" class="datePicker editPage displayNone" value="#DateFormat(qGetPlacementHistoryByID.datePlaced, 'mm/dd/yyyy')#" disabled="disabled">
                        </td>
                    </tr>

                    <!--- PIS Sent to Intl. Representative --->
                    <tr> 
                        <td class="paperworkLeftColumn"><input type="checkbox" name="datePISEmailedCheckBox" id="datePISEmailed" class="editPage displayNone" <cfif isDate(qGetPlacementHistoryByID.datePISEmailed)>checked</cfif> disabled="disabled"></td>
                        <td><label>PIS Emailed to International Representative</label></td>
                        <td>
                        	<span class="readOnly displayNone">#DateFormat(qGetPlacementHistoryByID.datePISEmailed, 'mm/dd/yyyy')#</span>
                        	<input type="text" name="datePISEmailed" id="datePISEmailed" class="datePicker editPage displayNone" value="#DateFormat(qGetPlacementHistoryByID.datePISEmailed, 'mm/dd/yyyy')#" disabled="disabled">
                        </td>
                    </tr>
                    
                    <!--- Date Relocated --->
                    <!--- Waiting to be Pushed Live - 04/11/2012 - Marcus Melo
                    <cfif VAL(qGetPlacementHistoryByID.isRelocation)>
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="dateRelocatedCheckBox" id="dateRelocatedCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'dateRelocated');" <cfif isDate(FORM.dateRelocated)>checked</cfif> >
                            </td>
                            <td><label for="dateRelocatedCheckBox">Date Relocated</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#</span>
                                <input type="text" name="dateRelocated" id="dateRelocated" class="datePicker editPage displayNone" value="#DateFormat(FORM.dateRelocated, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                    </cfif>
					--->
                    
                    <!--- Host Family Application Received --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_full_host_app_date" id="check_doc_full_host_app_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_full_host_app_date');" <cfif isDate(FORM.doc_full_host_app_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_full_host_app_date">Host Family Application Received</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_full_host_app_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_full_host_app_date" id="doc_full_host_app_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_full_host_app_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>

                    <!--- Host Family Letter Received --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_letter_rec_date" id="check_doc_letter_rec_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_letter_rec_date');" <cfif isDate(FORM.doc_letter_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_letter_rec_date">Host Family Letter Received</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_letter_rec_date" id="doc_letter_rec_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Host Family Rules Form --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_rules_rec_date" id="check_doc_rules_rec_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_rules_rec_date');" <cfif isDate(FORM.doc_rules_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_rules_rec_date">Host Family Rules Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_rules_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_rules_rec_date" id="doc_rules_rec_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_rules_rec_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>

                    <!--- Date Signed --->
                    <tr> 
                        <td>&nbsp;</td>
                        <td><label for="doc_rules_sign_date">Date Signed</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_rules_sign_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_rules_sign_date" id="doc_rules_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_rules_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_rules_sign_date');">
                        </td>
                    </tr>

                    <!--- Family Photo --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_photos_rec_date" id="check_doc_photos_rec_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_photos_rec_date');" <cfif isDate(FORM.doc_photos_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_photos_rec_date">Family Photo</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_photos_rec_date" id="doc_photos_rec_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Required Starting Aug 12 --->
                    <cfif qGetProgramInfo.seasonID GTE 9>
                    
						<!--- Student Bedroom Photo --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_bedroom_photo" id="check_doc_bedroom_photo" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_bedroom_photo');" <cfif isDate(FORM.doc_bedroom_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_bedroom_photo">Student Bedroom Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_bedroom_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_bedroom_photo" id="doc_bedroom_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_bedroom_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Student Bathroom Photo --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_bathroom_photo" id="check_doc_bathroom_photo" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_bathroom_photo');" <cfif isDate(FORM.doc_bathroom_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_bathroom_photo">Student Bathroom Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_bathroom_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_bathroom_photo" id="doc_bathroom_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_bathroom_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
                        
                        <!--- Kitchen Photo --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_kitchen_photo" id="check_doc_kitchen_photo" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_kitchen_photo');" <cfif isDate(FORM.doc_kitchen_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_kitchen_photo">Kitchen Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_kitchen_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_kitchen_photo" id="doc_kitchen_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_kitchen_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
    
                        <!--- Living Room Photo --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_living_room_photo" id="check_doc_living_room_photo" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_living_room_photo');" <cfif isDate(FORM.doc_living_room_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_living_room_photo">Living Room Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_living_room_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_living_room_photo" id="doc_living_room_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_living_room_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
    
                        <!--- Outside Photo --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_outside_photo" id="check_doc_outside_photo" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_outside_photo');" <cfif isDate(FORM.doc_outside_photo)>checked</cfif> >
                            </td>
                            <td><label for="check_doc_outside_photo">Outside Photo</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_outside_photo, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_outside_photo" id="doc_outside_photo" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_outside_photo, 'mm/dd/yyyy')#">
                            </td>
                        </tr>
					
                    </cfif>
                    
                    <!--- School & Community Profile Form --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_school_profile_rec" id="check_doc_school_profile_rec" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_school_profile_rec');" <cfif isDate(FORM.doc_school_profile_rec)>checked</cfif> >
						</td>
                        <td><label for="check_doc_school_profile_rec">School & Community Profile Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_profile_rec" id="doc_school_profile_rec" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Confidential Host Family Visit Form --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_conf_host_rec" id="check_doc_conf_host_rec" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_conf_host_rec');" <cfif isDate(FORM.doc_conf_host_rec)>checked</cfif> >
						</td>
                        <td><label for="check_doc_conf_host_rec">Confidential Host Family Visit Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_conf_host_rec, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_conf_host_rec" id="doc_conf_host_rec" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_conf_host_rec, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Date of Visit --->
                    <tr> 
                        <td>&nbsp;</td>
                        <td><label for="doc_date_of_visit">Date of Visit</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_date_of_visit" id="doc_date_of_visit" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_date_of_visit');">
                        </td>
                    </tr>
                    
                    <!--- Second Host Family Visit Report - Get Dates from Progress Report Section --->
                    <cfif qGetProgramInfo.seasonid GT 7>
                    
                        <!--- 2nd Confidential Host Family Visit Form --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="pr_ny_approved_dateCheckBox" id="pr_ny_approved_date" class="editPage displayNone" <cfif isDate(qGetSecondVisitReport.pr_ny_approved_date)>checked</cfif> disabled="disabled">
                            </td>
                            <td><label>2nd Confidential Host Family Visit Form ( Headquarters Approval )</label></td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetSecondVisitReport.pr_ny_approved_date, 'mm/dd/yyyy')#</span>
                                <input type="text" name="pr_ny_approved_date" id="pr_ny_approved_date" class="datePicker editPage displayNone hideField" value="#DateFormat(qGetSecondVisitReport.pr_ny_approved_date, 'mm/dd/yyyy')#" disabled="disabled">
                            </td>
                        </tr>

						<!--- Date of 2nd Visit --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label>Date of 2nd Visit</label></td>
                            <td>
                            	<span class="readOnly displayNone">#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#</span>
                            	<input type="text" name="dateOfVisit" id="dateOfVisit" class="datePicker editPage displayNone" value="#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#" disabled="disabled">
                            </td>
                        </tr>
                        
                    </cfif>
                    
                    <!--- Reference Form 1 --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_ref_form_1" id="check_doc_ref_form_1" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_ref_form_1');" <cfif isDate(FORM.doc_ref_form_1)>checked</cfif> >
						</td>
                        <td><label for="check_doc_ref_form_1">Reference Form 1</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_form_1, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_form_1" id="doc_ref_form_1" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_ref_form_1, 'mm/dd/yyyy')#">
                        </td>
                    </tr>

                    <!--- Date of Reference Check 1 --->   
                    <tr>
                        <td>&nbsp;</td>
                        <td><label for="doc_ref_check1">Date of Reference Check 1</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_check1" id="doc_ref_check1" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_ref_check1');">
                        </td>
                    </tr>
                     
                    <!--- Reference Form 2 --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_ref_form_2" id="check_doc_ref_form_2" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_ref_form_2');" <cfif isDate(FORM.doc_ref_form_2)>checked</cfif> >
						</td>
                        <td><label for="check_doc_ref_form_2">Reference Form 2</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_form_2, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_form_2" id="doc_ref_form_2" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_ref_form_2, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Date of Reference Check 2 --->
                    <tr>
                        <td>&nbsp;</td>
                        <td><label for="doc_ref_check2">Date of Reference Check 2</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_check2" id="doc_ref_check2" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_ref_check2');">
                        </td>
                    </tr>
                    
                    <!---- Income Verification Form --->	
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_income_ver_date" id="check_doc_income_ver_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_income_ver_date');" <cfif isDate(FORM.doc_income_ver_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_income_ver_date">Income Verification Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_income_ver_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_income_ver_date" id="doc_income_ver_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_income_ver_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
				</table>
				
                
                <!--- Arrival Date Compliance --->
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">                 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" colspan="2">
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
                    </tr>
                </table>
                
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">     
                    <!--- School Acceptance Form --->
                    <tr> 
                        <td width="5%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_school_accept_date" id="check_doc_school_accept_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_school_accept_date');" <cfif isDate(FORM.doc_school_accept_date)>checked</cfif> >
						</td>
                        <td width="50%"><label for="check_doc_school_accept_date">School Acceptance Form</label></td>
                        <td width="45%">
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_accept_date" id="doc_school_accept_date" class="datePicker editPage displayNone hideField" value="#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- School Acceptance Form - Date of Signature --->
                    <tr> 
                        <td>&nbsp;</td>
                        <td><label for="doc_school_sign_date">Date of Signature</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_sign_date" id="doc_school_sign_date" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#" onchange="displayNonCompliant('doc_school_sign_date');">
                        </td>
                    </tr>				
				</table>
                
                
                <!--- CBC - Most Recent Reports --->
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="50%">CBC - Most Recent Reports</td>
                        <td class="reportTitleLeftClean" width="45%">Date</td>
                    </tr>
    			</table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
					<cfloop query="qGetMostRecentCBC">
                        <tr> 
                            <td width="5%" class="paperworkLeftColumn">&nbsp;</td>
                            <td width="50%"><label for="#qGetMostRecentCBC.currentRow#-CBC">#qGetMostRecentCBC.fullName#</label></td>
                            <td width="45%">
                                <span class="readOnly displayNone">#DateFormat(qGetMostRecentCBC.date_sent, 'mm/dd/yyyy')# to #DateFormat(qGetMostRecentCBC.date_expired, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetMostRecentCBC.currentRow#-CBC" id="#qGetMostRecentCBC.currentRow#-CBC" class="datePicker editPage displayNone" value="#DateFormat(qGetMostRecentCBC.date_sent, 'mm/dd/yyyy')#" disabled="disabled">
                                <span class="editPage displayNone">to</span>
                                <input type="text" name="#qGetMostRecentCBC.currentRow#-CBC" id="#qGetMostRecentCBC.currentRow#-CBC" class="datePicker editPage displayNone" value="#DateFormat(qGetMostRecentCBC.date_expired, 'mm/dd/yyyy')#" disabled="disabled">
                            </td>
                        </tr>
					</cfloop>
				</table>   

                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="5%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="50%">Arrival Orientation</td>
                        <td class="reportTitleLeftClean" width="45%">Date</td>
                    </tr>
               	</table>
               
               	<table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                    
                    <!--- Student Orientation --->
                    <tr> 
                        <td width="5%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_stu_arrival_orientation" id="check_stu_arrival_orientation" class="editPage displayNone" onclick="setTodayDate(this.id, 'stu_arrival_orientation');" <cfif isDate(FORM.stu_arrival_orientation)>checked</cfif> >
						</td>
                        <td width="50%"><label for="check_stu_arrival_orientation">Student Orientation</label></td>
                        <td width="45%">
                            <span class="readOnly displayNone">#DateFormat(FORM.stu_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="text" name="stu_arrival_orientation" id="stu_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.stu_arrival_orientation, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Host Family Orientation --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_host_arrival_orientation" id="check_host_arrival_orientation" class="editPage displayNone" onclick="setTodayDate(this.id, 'host_arrival_orientation');" <cfif isDate(FORM.host_arrival_orientation)>checked</cfif> >
						</td>
                        <td><label for="check_host_arrival_orientation">Host Family Orientation</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.host_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="text" name="host_arrival_orientation" id="host_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.host_arrival_orientation, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Class Schedule --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_class_schedule" id="check_doc_class_schedule" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_class_schedule');" <cfif isDate(FORM.doc_class_schedule)>checked</cfif> >
						</td>
                        <td><label for="check_doc_class_schedule">Class Schedule</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_class_schedule, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_class_schedule" id="doc_class_schedule" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_class_schedule, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
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
                            <td class="reportTitleLeftClean" width="50%">
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
                            <td class="reportTitleLeftClean" width="45%">Date</td>
                        </tr>
                    </table>

                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <!--- Is Double Placement Paperwork Required? --->
                        <tr> 
                            <td width="5%">&nbsp;</td>
                            <td width="50%"><label for="#qGetDoublePlacementPaperworkHistory.ID#_isDoublePlacementPaperworkRequired">Is Paperwork Required?</label></td>
                            <td width="45%">
                                <span class="readOnly displayNone">#YesNoFormat(VAL(qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateSigned))#</span>
                                <select name="#qGetDoublePlacementPaperworkHistory.ID#_isDoublePlacementPaperworkRequired" id="#qGetDoublePlacementPaperworkHistory.ID#_isDoublePlacementPaperworkRequired" class="editPage displayNone smallField" onchange="displayDoublePlacementPaperwork(#qGetDoublePlacementPaperworkHistory.ID#);">
                                    <option value="" <cfif NOT LEN(FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired'])> selected="selected" </cfif> ></option>
                                    <option value="1" <cfif FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired'] EQ 1> selected="selected" </cfif> >Yes</option>
                                    <option value="0" <cfif FORM[qGetDoublePlacementPaperworkHistory.ID & '_isDoublePlacementPaperworkRequired'] EQ 0> selected="selected" </cfif> >No</option>
                                </select>
                            </td>
                        </tr>
                        
                        <!--- Natural Family Date Signed --->
                        <tr class="#qGetDoublePlacementPaperworkHistory.ID#_classDoublePlacementPaperwork #vDoublePlacementPaperworkClass#"> 
                            <td width="5%">&nbsp;</td>
                            <td width="50%"><label for="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned">Natural Family Date Signed</label></td>
                            <td width="45%">
                                <span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementParentsDateSigned, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementParentsDateSigned'], 'mm/dd/yyyy')#" onchange="displayNonCompliant('#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementParentsDateSigned');">
                            </td>
                        </tr>
                        
                        <!--- Student Date Signed --->
                        <tr class="#qGetDoublePlacementPaperworkHistory.ID#_classDoublePlacementPaperwork #vDoublePlacementPaperworkClass#"> 
                            <td>&nbsp;</td>
                            <td><label for="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned">Student Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementStudentDateSigned, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementStudentDateSigned'], 'mm/dd/yyyy')#" onchange="displayNonCompliant('#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementStudentDateSigned');">
                            </td>
                        </tr>
                        
                        <!--- Host Family Date Signed --->
                        <tr class="#qGetDoublePlacementPaperworkHistory.ID#_classDoublePlacementPaperwork #vDoublePlacementPaperworkClass#"> 
                            <td>&nbsp;</td>
                            <td><label for="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned">Host Family Date Signed</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(qGetDoublePlacementPaperworkHistory.doublePlacementHostFamilyDateSigned, 'mm/dd/yyyy')#</span>
                                <input type="text" name="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned" id="#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned" class="datePicker editPage displayNone compliantField" value="#DateFormat(FORM[qGetDoublePlacementPaperworkHistory.ID & '_doublePlacementHostFamilyDateSigned'], 'mm/dd/yyyy')#" onchange="displayNonCompliant('#qGetDoublePlacementPaperworkHistory.ID#_doublePlacementHostFamilyDateSigned');">
                            </td>
                        </tr>
                    </table>
                
                </cfloop>                        
    
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