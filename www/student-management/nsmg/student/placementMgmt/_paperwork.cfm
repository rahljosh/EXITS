<!--- ------------------------------------------------------------------------- ----
	
	File:		_paperwork.cfm
	Author:		Marcus Melo
	Date:		June 15, 2011
	Desc:		Placement Paperwork Management

	Updated:																
				
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
    <!--- Placement Paperwork --->
    <cfparam name="FORM.date_pis_received" default="">
    <cfparam name="FORM.doc_full_host_app_date" default="">
    <cfparam name="FORM.doc_letter_rec_date" default="">
    <cfparam name="FORM.doc_rules_rec_date" default="">
    <cfparam name="FORM.doc_photos_rec_date" default="">
    <cfparam name="FORM.doc_school_profile_rec" default="">
    <cfparam name="FORM.doc_conf_host_rec" default="">
    <cfparam name="FORM.doc_date_of_visit" default="">
    <cfparam name="FORM.doc_conf_host_rec2" default="">
    <cfparam name="FORM.doc_date_of_visit2" default="">
    <cfparam name="FORM.doc_ref_form_1" default="">
    <cfparam name="FORM.doc_ref_check1" default="">
    <cfparam name="FORM.doc_ref_form_2" default="">
    <cfparam name="FORM.doc_ref_check2" default="">
    <cfparam name="FORM.doc_income_ver_date" default="">
    <!--- Arrival Compliance --->
    <cfparam name="FORM.doc_school_accept_date" default="">
    <cfparam name="FORM.doc_school_sign_date" default="">
    <!--- CBC Forms --->
    <cfparam name="FORM.fathercbc_form" default="">
    <cfparam name="FORM.mothercbc_form" default="">
    <cfparam name="FORM.childIDList" default="">
    <!--- Original Student --->
    <cfparam name="FORM.orig_app_sent_host" default="">
    <cfparam name="FORM.copy_app_school" default="">
    <cfparam name="FORM.copy_app_super" default="">
    <!--- Arrival Orientation --->
    <cfparam name="FORM.stu_arrival_orientation" default="">
    <cfparam name="FORM.host_arrival_orientation" default="">
    <cfparam name="FORM.doc_class_schedule" default="">    
    
    <cfscript>
		// Get Eligible Host Family Members
		qGetEligibleCBCFamilyMembers = APPLICATION.CFC.CBC.getEligibleHostMember(hostID=qGetStudentInfo.hostID,studentID=qGetStudentInfo.studentID);
	</cfscript>
    
    <!--- Param CBC Member --->
    <cfloop query="qGetEligibleCBCFamilyMembers">
    	<cfparam name="FORM.cbc_form_received#qGetEligibleCBCFamilyMembers.childID#" default="">
    </cfloop>
    
    <cfscript>
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {
			
			// Update fields on the student table
			APPLICATION.CFC.STUDENT.updatePlacementPaperwork(
				studentID = FORM.studentID,
				historyID = qGetPlacementHistory.historyID,
				// Single Person Placement Paperwork
				doc_single_place_auth = FORM.doc_single_place_auth,
				doc_single_ref_form_1 = FORM.doc_single_ref_form_1,
				doc_single_ref_check1 = FORM.doc_single_ref_check1,
				doc_single_ref_form_2 = FORM.doc_single_ref_form_2,
				doc_single_ref_check2 = FORM.doc_single_ref_check2,
				// Placement Paperwork
				date_pis_received = FORM.date_pis_received,
				doc_full_host_app_date = FORM.doc_full_host_app_date,
				doc_letter_rec_date = FORM.doc_letter_rec_date,
				doc_rules_rec_date = FORM.doc_rules_rec_date,
				doc_photos_rec_date = FORM.doc_photos_rec_date,
				doc_school_profile_rec = FORM.doc_school_profile_rec,
				doc_conf_host_rec = FORM.doc_conf_host_rec,
				doc_date_of_visit = FORM.doc_date_of_visit,
				doc_conf_host_rec2 = qGetSecondVisitReport.pr_sr_approved_date,
				doc_date_of_visit2 = qGetSecondVisitReport.dateOfVisit,
				// doc_conf_host_rec2 = FORM.doc_conf_host_rec2,
				// doc_date_of_visit2 = FORM.doc_date_of_visit2,
				doc_ref_form_1 = FORM.doc_ref_form_1,
				doc_ref_check1 = FORM.doc_ref_check1,
				doc_ref_form_2 = FORM.doc_ref_form_2,
				doc_ref_check2 = FORM.doc_ref_check2,
				doc_income_ver_date = FORM.doc_income_ver_date,
				// Arrival Compliance
				doc_school_accept_date = FORM.doc_school_accept_date,
				doc_school_sign_date = FORM.doc_school_sign_date,
				// Original Student
				orig_app_sent_host = FORM.orig_app_sent_host,
				copy_app_school = FORM.copy_app_school,
				copy_app_super = FORM.copy_app_super,
				// Arrival Orientation
				stu_arrival_orientation = FORM.stu_arrival_orientation,
				host_arrival_orientation = FORM.host_arrival_orientation,
				doc_class_schedule = FORM.doc_class_schedule
			);
			
			// Update Host Family CBC
			APPLICATION.CFC.HOST.updateHostPlacementPaperwork(
				hostID = qGetStudentInfo.hostID,
				fathercbc_form = FORM.fathercbc_form,
				mothercbc_form = FORM.mothercbc_form	
			);			
			
			// Update Host Member CBC
			for (i=1;i LTE ListLen(FORM.childIDList); i=i+1) {
				APPLICATION.CFC.HOST.updateMemberPlacementPaperwork(
					hostID = qGetStudentInfo.hostID,
					childID = ListGetAt(FORM.childIDList, i),
					cbc_form_received = FORM["cbc_form_received" & ListGetAt(FORM.childIDList, i)]
				);			
			}
			
		  // Set Page Message
		  SESSION.pageMessages.Add("Form successfully submitted.");
		  
		  // Reload page
		  location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetStudentInfo.studentID;
			// Single Person Placement Paperwork
			FORM.doc_single_place_auth = qGetStudentInfo.doc_single_place_auth;
			FORM.doc_single_ref_form_1 = qGetStudentInfo.doc_single_ref_form_1;
			FORM.doc_single_ref_check1 = qGetStudentInfo.doc_single_ref_check1;
			FORM.doc_single_ref_form_2 = qGetStudentInfo.doc_single_ref_form_2;
			FORM.doc_single_ref_check2 = qGetStudentInfo.doc_single_ref_check2;
			// Placement Paperwork
			FORM.date_pis_received = qGetStudentInfo.date_pis_received;
			FORM.doc_full_host_app_date = qGetStudentInfo.doc_full_host_app_date;
			FORM.doc_letter_rec_date = qGetStudentInfo.doc_letter_rec_date;
			FORM.doc_rules_rec_date = qGetStudentInfo.doc_rules_rec_date;
			FORM.doc_photos_rec_date = qGetStudentInfo.doc_photos_rec_date;
			FORM.doc_school_profile_rec = qGetStudentInfo.doc_school_profile_rec;
			FORM.doc_conf_host_rec = qGetStudentInfo.doc_conf_host_rec;
			FORM.doc_date_of_visit = qGetStudentInfo.doc_date_of_visit;
			// FORM.doc_conf_host_rec2 = qGetStudentInfo.doc_conf_host_rec2;
			// FORM.doc_date_of_visit2 = qGetStudentInfo.doc_date_of_visit2;
			FORM.doc_ref_form_1 = qGetStudentInfo.doc_ref_form_1;
			FORM.doc_ref_check1 = qGetStudentInfo.doc_ref_check1;
			FORM.doc_ref_form_2 = qGetStudentInfo.doc_ref_form_2;
			FORM.doc_ref_check2 = qGetStudentInfo.doc_ref_check2;
			FORM.doc_income_ver_date = qGetStudentInfo.doc_income_ver_date;
			// Arrival Compliance
			FORM.doc_school_accept_date = qGetStudentInfo.doc_school_accept_date;
			FORM.doc_school_sign_date = qGetStudentInfo.doc_school_sign_date;
			// CBC Forms - Host Family Table
			FORM.fathercbc_form = qGetHostInfo.fathercbc_form;
			FORM.mothercbc_form = qGetHostInfo.mothercbc_form;
			// CBC Host Members 
			FORM.childIDList = ValueList(qGetEligibleCBCFamilyMembers.childID);
			for ( i=1; i LTE qGetEligibleCBCFamilyMembers.recordCount; i=i+1 ) {
				FORM["cbc_form_received" & qGetEligibleCBCFamilyMembers.childID[i]] = qGetEligibleCBCFamilyMembers.cbc_form_received[i];
			}
			// Original Student
			FORM.orig_app_sent_host = qGetStudentInfo.orig_app_sent_host;
			FORM.copy_app_school = qGetStudentInfo.copy_app_school;
			FORM.copy_app_super = qGetStudentInfo.copy_app_super;
			// Arrival Orientation
			FORM.stu_arrival_orientation = qGetStudentInfo.stu_arrival_orientation;
			FORM.host_arrival_orientation = qGetStudentInfo.host_arrival_orientation;
			FORM.doc_class_schedule = qGetStudentInfo.doc_class_schedule;
		}
		
		/***************************************
			Set Compliance Notifications
		***************************************/
		
		// Single Placement Paperwork
		if ( vTotalFamilyMembers EQ 1 AND qGetProgramInfo.seasonid GT 7 ) {

			if ( isDate(FORM.doc_single_ref_check1) AND FORM.doc_single_ref_check1 GT qGetStudentInfo.datePlaced ) {
				SESSION.formErrors.Add("Date of Single Placement Reference Check 1 is out of compliance");
			}
	
			if ( isDate(FORM.doc_single_ref_check2) AND FORM.doc_single_ref_check2 GT qGetStudentInfo.datePlaced ) {
				SESSION.formErrors.Add("Date of Single Placement Reference Check 2 is out of compliance");
			}

		}
		
		if ( isDate(FORM.doc_date_of_visit) AND FORM.doc_date_of_visit GT qGetStudentInfo.datePlaced ) {
			SESSION.formErrors.Add("Confidential Host Family Date of Visit is out of compliance");
		}

		if ( isDate(FORM.doc_date_of_visit2) AND FORM.doc_date_of_visit2 GT qGetStudentInfo.datePlaced ) {
			SESSION.formErrors.Add("2nd Confidential Host Family Date of Visit is out of compliance");
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
		
	});

	var readOnlyPage = function() {
		// Hide editPage and display readOnly
		$(".readOnly").fadeIn("fast");
	}

	var showEditPage = function() {
		// Hide read only and display editPage
		$(".editPage").fadeIn("fast");
	}

	var setTodayDate = function(checkFieldID, formFieldID) { 		

		if ( $("#" + checkFieldID).is(':checked') ) {
			$("#" + formFieldID).val(prettyDate);
		} else {
			$("#" + formFieldID).val("");
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
            <th>PLACEMENT PAPERWORK</th>
        </tr>
    </table>

	<form name="placementPaperwork" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
		<input type="hidden" name="submitted" value="1"> 
        <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="childIDList" value="#FORM.childIDList#">
    		
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
                
				<!--- Single Placement Paperwork --->
                <cfif vTotalFamilyMembers EQ 1 AND qGetProgramInfo.seasonid GT 7>
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr>
                            <td colspan="3" class="singlePlacementAlert">
                                <h1>Single Person Placement - Additional screening will be required.</h1>
                                <em>2 additional references and single person placement authorization form required</em> 
                            </td>
                        </tr>
                    </table>
                    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                        <tr bgcolor="##edeff4">
                            <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                            <td class="reportTitleLeftClean" width="55%">Single Placement Paperwork</td>
                            <td class="reportTitleLeftClean" width="30%">Date</td>
                        </tr>
					</table>
                    
                    <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                         
                        <!--- Single Person Placement Verification --->
                        <tr> 
                            <td width="15%" class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_single_place_auth" id="check_doc_single_place_auth" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_single_place_auth');" <cfif isDate(FORM.doc_single_place_auth)>checked</cfif> >
                            </td>
                            <td width="55%"><label for="check_doc_single_place_auth">Single Person Placement Verification</label></td>
                            <td width="30%">
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_place_auth" id="doc_single_place_auth" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#" maxlength="10">
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
                                <input type="text" name="doc_single_ref_form_1" id="doc_single_ref_form_1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_form_1, 'mm/dd/yyyy')#" maxlength="10">
                            </td>
                        </tr>
                        
                        <!--- Date of Single Placement Reference Check 1 --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_ref_check1">Date of Single Placement Reference Check 1</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_check1" id="doc_single_ref_check1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#" maxlength="10">
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
                                <input type="text" name="doc_single_ref_form_2" id="doc_single_ref_form_2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_form_2, 'mm/dd/yyyy')#" maxlength="10">
                            </td>
                        </tr>
                        
                        <!--- Date of Single Placement Reference Check 2 --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_single_ref_check2">Date of Single Placement Reference Check 2</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_single_ref_check2" id="doc_single_ref_check2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#" maxlength="10">
                            </td>
                        </tr>
                    </table>
                </cfif> 
                <!--- End of Single Placement Paperwork --->

				<table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="55%">Paperwork</td>
                        <td class="reportTitleLeftClean" width="30%">Date</td>
                    </tr>
                </table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 

                    <!--- PIS Approved --->
                    <tr> 
                        <td width="15%">&nbsp;</td>
                        <td width="55%"><label for="check_date_pis_received">Date Placed ( Headquarters Office Approval Date )</label></td>
                        <td width="30%">#DateFormat(qGetStudentInfo.datePlaced, 'mm/dd/yyyy')#</td>
                    </tr>

                    <!--- PIS Sent to Intl. Representative --->
                    <tr> 
                        <td>&nbsp;</td>
                        <td><label for="check_date_pis_received">PIS Emailed to International Representative</label></td>
                        <td>#DateFormat(qGetStudentInfo.datePISEmailed, 'mm/dd/yyyy')#</td>
                    </tr>
                
                    <!--- Placement Information Sheet --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_date_pis_received" id="check_date_pis_received" class="editPage displayNone" onclick="setTodayDate(this.id, 'date_pis_received');" <cfif isDate(FORM.date_pis_received)>checked</cfif> >
						</td>
                        <td><label for="check_date_pis_received">Placement Information Sheet</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.date_pis_received, 'mm/dd/yyyy')#</span>
                            <input type="text" name="date_pis_received" id="date_pis_received" class="datePicker editPage displayNone" value="#DateFormat(FORM.date_pis_received, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- Host Family Application Received --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_full_host_app_date" id="check_doc_full_host_app_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_full_host_app_date');" <cfif isDate(FORM.doc_full_host_app_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_full_host_app_date">Host Family Application Received</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_full_host_app_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_full_host_app_date" id="doc_full_host_app_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_full_host_app_date, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="doc_letter_rec_date" id="doc_letter_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="doc_rules_rec_date" id="doc_rules_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_rules_rec_date, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>

                    <!--- Host Family Photos --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_photos_rec_date" id="check_doc_photos_rec_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_photos_rec_date');" <cfif isDate(FORM.doc_photos_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_photos_rec_date">Host Family Photos</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_photos_rec_date" id="doc_photos_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- School & Community Profile Form --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_school_profile_rec" id="check_doc_school_profile_rec" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_school_profile_rec');" <cfif isDate(FORM.doc_school_profile_rec)>checked</cfif> >
						</td>
                        <td><label for="check_doc_school_profile_rec">School & Community Profile Form</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_profile_rec" id="doc_school_profile_rec" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="doc_conf_host_rec" id="doc_conf_host_rec" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_conf_host_rec, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- Date of Visit --->
                    <tr> 
                        <td>&nbsp;</td>
                        <td><label for="doc_date_of_visit">Date of Visit</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_date_of_visit" id="doc_date_of_visit" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- Second Host Family Visit Report - Get Dates from Progress Report Section --->
                    <cfif qGetProgramInfo.seasonid GT 7>
                    
                        <!--- 2nd Confidential Host Family Visit Form --->
                        <tr> 
                            <td class="paperworkLeftColumn">
                                <input type="checkbox" name="check_doc_conf_host_rec2" id="check_doc_conf_host_rec2" class="editPage displayNone" <cfif isDate(FORM.doc_conf_host_rec2)>checked</cfif> disabled="disabled">
                            </td>
                            <td><label for="check_doc_conf_host_rec2">2nd Confidential Host Family Visit Form</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_conf_host_rec2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_conf_host_rec2" id="doc_conf_host_rec2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_conf_host_rec2, 'mm/dd/yyyy')#" maxlength="10" disabled="disabled">
                            </td>
                        </tr>

						<!--- Date of 2nd Visit --->
                        <tr> 
                            <td>&nbsp;</td>
                            <td><label for="doc_date_of_visit2">Date of 2nd Visit</label></td>
                            <td>
                                <span class="readOnly displayNone">#DateFormat(FORM.doc_date_of_visit2, 'mm/dd/yyyy')#</span>
                                <input type="text" name="doc_date_of_visit2" id="doc_date_of_visit2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_date_of_visit2, 'mm/dd/yyyy')#" maxlength="10" disabled="disabled">
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
                            <input type="text" name="doc_ref_form_1" id="doc_ref_form_1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_form_1, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>

                    <!--- Date of Reference Check 1 --->   
                    <tr>
                        <td>&nbsp;</td>
                        <td><label for="doc_ref_check1">Date of Reference Check 1</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_check1" id="doc_ref_check1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="doc_ref_form_2" id="doc_ref_form_2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_form_2, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- Date of Reference Check 2 --->
                    <tr>
                        <td>&nbsp;</td>
                        <td><label for="doc_ref_check2">Date of Reference Check 2</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_ref_check2" id="doc_ref_check2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="doc_income_ver_date" id="doc_income_ver_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_income_ver_date, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
				</table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">                 
                    <!--- Arrival Date Compliance --->
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
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
                        <td width="15%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_school_accept_date" id="check_doc_school_accept_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_school_accept_date');" <cfif isDate(FORM.doc_school_accept_date)>checked</cfif> >
						</td>
                        <td width="55%"><label for="check_doc_school_accept_date">School Acceptance Form</label></td>
                        <td width="30%">
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_accept_date" id="doc_school_accept_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- School Acceptance Form - Date of Signature --->
                    <tr> 
                        <td>&nbsp;</td>
                        <td><label for="doc_school_sign_date">Date of Signature</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_school_sign_date" id="doc_school_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>				
				</table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <!--- CBC Forms --->
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="55%">CBC Forms</td>
                        <td class="reportTitleLeftClean" width="30%">Date</td>
                    </tr>
    			</table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
                    <!--- Host Father --->
                    <tr> 
                        <td width="15%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_fathercbc_form" id="check_fathercbc_form" class="editPage displayNone" onclick="setTodayDate(this.id, 'fathercbc_form');" <cfif isDate(FORM.fathercbc_form)>checked</cfif> >
						</td>
                        <td width="55%"><label for="check_fathercbc_form">Host Father</label></td>
                        <td width="30%">
                            <span class="readOnly displayNone">#DateFormat(FORM.fathercbc_form, 'mm/dd/yyyy')#</span>
                            <input type="text" name="fathercbc_form" id="fathercbc_form" class="datePicker editPage displayNone" value="#DateFormat(FORM.fathercbc_form, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                    
                    <!--- Host Mother --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_mothercbc_form" id="check_mothercbc_form" class="editPage displayNone" onclick="setTodayDate(this.id, 'mothercbc_form');" <cfif isDate(FORM.mothercbc_form)>checked</cfif> >
						</td>
                        <td><label for="check_mothercbc_form">Host Mother</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.mothercbc_form, 'mm/dd/yyyy')#</span>
                            <input type="text" name="mothercbc_form" id="mothercbc_form" class="datePicker editPage displayNone" value="#DateFormat(FORM.mothercbc_form, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
				</table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">                    
                    <!--- Host Members --->
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="55%">CBC Host Members 18+</td>
                        <td class="reportTitleLeftClean" width="30%">Date</td>
                    </tr>
                </table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">
                    <cfloop query="qGetEligibleCBCFamilyMembers">
                        <tr> 
                            <td width="15%" class="paperworkLeftColumn">
                                <input type="checkbox" name="member#qGetEligibleCBCFamilyMembers.currentRow#check" id="member#qGetEligibleCBCFamilyMembers.currentRow#check" class="editPage displayNone" onclick="setTodayDate(this.id, 'cbc_form_received#qGetEligibleCBCFamilyMembers.childID#');" <cfif isDate(FORM['cbc_form_received' & qGetEligibleCBCFamilyMembers.childID])>checked</cfif> >
                            </td>
                            <td width="55%"><label for="member#qGetEligibleCBCFamilyMembers.currentRow#check">#qGetEligibleCBCFamilyMembers.name# #qGetEligibleCBCFamilyMembers.lastname# - #qGetEligibleCBCFamilyMembers.age# years old</label></td>
                            <td width="30%">
                                <span class="readOnly displayNone">#DateFormat(qGetEligibleCBCFamilyMembers.cbc_form_received, 'mm/dd/yyyy')#</span>
                                <input type="text" name="cbc_form_received#qGetEligibleCBCFamilyMembers.childID#" id="cbc_form_received#qGetEligibleCBCFamilyMembers.childID#" class="datePicker editPage displayNone" value="#DateFormat(FORM['cbc_form_received' & qGetEligibleCBCFamilyMembers.childID], 'mm/dd/yyyy')#" maxlength="10">
                            </td>
                        </tr>
                    </cfloop>
                    
					<cfif NOT VAL(qGetEligibleCBCFamilyMembers.recordcount)>
                        <tr><td colspan="3" align="center">No eligible host family members found.</td></tr>
                    </cfif>
               </table>
               
               <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="85%">Student Application</td>
                    </tr>
               </table>
               
              <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">  	
                    <!--- Original Student Application to Host Family ---->
                    <tr>
                    	<td width="15%" class="paperworkLeftColumn">
                        	<input type="checkbox" name="orig_app_sent_host" id="orig_app_sent_host" value="1" class="editPage displayNone" <cfif FORM.orig_app_sent_host EQ 'yes'>checked="checked"</cfif> >
                        </td>
                        <td width="85%">    
                            <label for="orig_app_sent_host">Original Student Application to Host Family</label>
                        </td>
                        
                    </tr>
                    
                    <!--- Copy to School ---->
                    <tr>
                    	<td class="paperworkLeftColumn">
	                        <input type="checkbox" name="copy_app_school" id="copy_app_school" value="1" class="editPage displayNone" <cfif FORM.copy_app_school EQ 'yes'>checked="checked"</cfif> >
                       </td>
                       <td>     
                            <label for="copy_app_school">Copy to School</label>
                        </td>
                    </tr>

                    <!--- Copy to Supervising Representative ---->
                    <tr>
                    	<td class="paperworkLeftColumn">
	                        <input type="checkbox" name="copy_app_super" id="copy_app_super" value="1" class="editPage displayNone" <cfif FORM.copy_app_super EQ 'yes'>checked="checked"</cfif> >
                       </td>
                       <td>     
                            <label for="copy_app_super">Copy to Supervising Representative</label>
                        </td>
                    </tr>
				</table>   
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="55%">Arrival Orientation</td>
                        <td class="reportTitleLeftClean" width="30%">Date</td>
                    </tr>
               </table>
               
               <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">                    
                    <!--- Student Orientation --->
                    <tr> 
                        <td width="15%" class="paperworkLeftColumn">
                            <input type="checkbox" name="check_stu_arrival_orientation" id="check_stu_arrival_orientation" class="editPage displayNone" onclick="setTodayDate(this.id, 'stu_arrival_orientation');" <cfif isDate(FORM.stu_arrival_orientation)>checked</cfif> >
						</td>
                        <td width="55%"><label for="check_stu_arrival_orientation">Student Orientation</label></td>
                        <td width="30%">
                            <span class="readOnly displayNone">#DateFormat(FORM.stu_arrival_orientation, 'mm/dd/yyyy')#</span>
                            <input type="text" name="stu_arrival_orientation" id="stu_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.stu_arrival_orientation, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="host_arrival_orientation" id="host_arrival_orientation" class="datePicker editPage displayNone" value="#DateFormat(FORM.host_arrival_orientation, 'mm/dd/yyyy')#" maxlength="10">
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
                            <input type="text" name="doc_class_schedule" id="doc_class_schedule" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_class_schedule, 'mm/dd/yyyy')#" maxlength="10">
                        </td>
                    </tr>
                </table>
    
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