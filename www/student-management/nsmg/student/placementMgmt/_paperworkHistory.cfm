<!--- ------------------------------------------------------------------------- ----
	
	File:		_paperworkHistory.cfm
	Author:		Marcus Melo
	Date:		November 17, 2011
	Desc:		Placement Paperwork History Management

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
    <cfparam name="FORM.copy_app_school" default="">
    <!--- Arrival Orientation --->
    <cfparam name="FORM.stu_arrival_orientation" default="">
    <cfparam name="FORM.host_arrival_orientation" default="">
    <cfparam name="FORM.doc_class_schedule" default="">    
    
    <cfscript>
		// Get History Details
		qGetHostHistory = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=FORM.historyID);

		// Get Host Family Information
		qGetHostHistoryInfo = APPLICATION.CFC.HOST.getHosts(hostID=qGetHostHistory.hostID);

		// Get Second Host Family Visit
		qGetHistorySecondVisitReport = APPLICATION.CFC.PROGRESSREPORT.getSecondHostFamilyVisitReport(studentID=qGetStudentInfo.studentID, hostID=qGetHostHistory.hostID);

		// Get Host Kids at Home
		qGetHostHistoryKidsAtHome = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetHostHistory.hostID,liveAtHome='yes');

		// Calculate total of family members
		vTotalHistoryFamilyMembers = 0;
		
		if ( LEN(qGetHostHistoryInfo.fatherFirstName) ) {
			vTotalHistoryFamilyMembers = vTotalHistoryFamilyMembers + 1;
		}
		
		if ( LEN(qGetHostHistoryInfo.motherFirstName) ) {
			vTotalHistoryFamilyMembers = vTotalHistoryFamilyMembers + 1;
		}
		
		vTotalHistoryFamilyMembers = vTotalHistoryFamilyMembers + VAL(qGetHostHistoryKidsAtHome.recordCount);
		// End of Calculate total of family members
		
		// Get Host Mother CBC
		qGetCBCHistoryMother = APPLICATION.CFC.CBC.getCBCHostByID(hostID=qGetHostHistory.hostID, cbcType='mother', sortBy="date_sent", sortOrder="DESC", getOneRecord=1);

		// Get Host Father CBC
		qGetCBCHistoryFather = APPLICATION.CFC.CBC.getCBCHostByID(hostID=qGetHostHistory.hostID, cbcType='father', sortBy="date_sent", sortOrder="DESC", getOneRecord=1);

		// Get Eligible Host Family Members
		qGetEligibleCBCFamilyHistoryMembers = APPLICATION.CFC.CBC.getEligibleHostMember(hostID=qGetHostHistory.hostID,studentID=qGetStudentInfo.studentID);
	</cfscript>
    
    <!--- Param CBC Member --->
    <cfloop query="qGetEligibleCBCFamilyHistoryMembers">
    	<cfparam name="FORM.cbc_form_received#qGetEligibleCBCFamilyHistoryMembers.childID#" default="">
    </cfloop>
    
    <cfscript>
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {
			
			// Update fields on the student table
			APPLICATION.CFC.STUDENT.updatePlacementPaperworkHistory(
				studentID = FORM.studentID,
				historyID = FORM.historyID,
				// Single Person Placement Paperwork
				doc_single_place_auth = FORM.doc_single_place_auth,
				doc_single_ref_form_1 = FORM.doc_single_ref_form_1,
				doc_single_ref_check1 = FORM.doc_single_ref_check1,
				doc_single_ref_form_2 = FORM.doc_single_ref_form_2,
				doc_single_ref_check2 = FORM.doc_single_ref_check2,
				// Placement Paperwork
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
				// Original Student
				copy_app_school = FORM.copy_app_school,
				// Arrival Orientation
				stu_arrival_orientation = FORM.stu_arrival_orientation,
				host_arrival_orientation = FORM.host_arrival_orientation,
				doc_class_schedule = FORM.doc_class_schedule
			);
			
			// Update Host Family CBC
			APPLICATION.CFC.HOST.updateHostPlacementPaperwork(
				hostID = qGetHostHistory.hostID,
				fathercbc_form = FORM.fathercbc_form,
				mothercbc_form = FORM.mothercbc_form	
			);			
			
			// Update Host Member CBC
			for (i=1;i LTE ListLen(FORM.childIDList); i=i+1) {
				APPLICATION.CFC.HOST.updateMemberPlacementPaperwork(
					hostID = qGetHostHistory.hostID,
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
			FORM.historyID = qGetHostHistory.historyID;
			// Single Person Placement Paperwork
			FORM.doc_single_place_auth = qGetHostHistory.doc_single_place_auth;
			FORM.doc_single_ref_form_1 = qGetHostHistory.doc_single_ref_form_1;
			FORM.doc_single_ref_check1 = qGetHostHistory.doc_single_ref_check1;
			FORM.doc_single_ref_form_2 = qGetHostHistory.doc_single_ref_form_2;
			FORM.doc_single_ref_check2 = qGetHostHistory.doc_single_ref_check2;
			// Placement Paperwork
			FORM.doc_full_host_app_date = qGetHostHistory.doc_full_host_app_date;
			FORM.doc_letter_rec_date = qGetHostHistory.doc_letter_rec_date;
			FORM.doc_rules_rec_date = qGetHostHistory.doc_rules_rec_date;
			FORM.doc_rules_sign_date = qGetHostHistory.doc_rules_sign_date;
			FORM.doc_photos_rec_date = qGetHostHistory.doc_photos_rec_date;
			FORM.doc_bedroom_photo = qGetHostHistory.doc_bedroom_photo;
			FORM.doc_bathroom_photo = qGetHostHistory.doc_bathroom_photo;
			FORM.doc_kitchen_photo = qGetHostHistory.doc_kitchen_photo;
			FORM.doc_living_room_photo = qGetHostHistory.doc_living_room_photo;
			FORM.doc_outside_photo = qGetHostHistory.doc_outside_photo;
			FORM.doc_school_profile_rec = qGetHostHistory.doc_school_profile_rec;
			FORM.doc_conf_host_rec = qGetHostHistory.doc_conf_host_rec;
			FORM.doc_date_of_visit = qGetHostHistory.doc_date_of_visit;
			// FORM.doc_conf_host_rec2 = qGetHostHistory.doc_conf_host_rec2;
			// FORM.doc_date_of_visit2 = qGetHostHistory.doc_date_of_visit2;
			FORM.doc_ref_form_1 = qGetHostHistory.doc_ref_form_1;
			FORM.doc_ref_check1 = qGetHostHistory.doc_ref_check1;
			FORM.doc_ref_form_2 = qGetHostHistory.doc_ref_form_2;
			FORM.doc_ref_check2 = qGetHostHistory.doc_ref_check2;
			FORM.doc_income_ver_date = qGetHostHistory.doc_income_ver_date;
			// Arrival Compliance
			FORM.doc_school_accept_date = qGetHostHistory.doc_school_accept_date;
			FORM.doc_school_sign_date = qGetHostHistory.doc_school_sign_date;
			// CBC Forms - Host Family Table
			FORM.fathercbc_form = qGetHostHistoryInfo.fathercbc_form;
			FORM.mothercbc_form = qGetHostHistoryInfo.mothercbc_form;
			// CBC Host Members 
			FORM.childIDList = ValueList(qGetEligibleCBCFamilyHistoryMembers.childID);
			for ( i=1; i LTE qGetEligibleCBCFamilyHistoryMembers.recordCount; i=i+1 ) {
				FORM["cbc_form_received" & qGetEligibleCBCFamilyHistoryMembers.childID[i]] = qGetEligibleCBCFamilyHistoryMembers.cbc_form_received[i];
			}
			// Original Student
			FORM.copy_app_school = qGetHostHistory.copy_app_school;
			// Arrival Orientation
			FORM.stu_arrival_orientation = qGetHostHistory.stu_arrival_orientation;
			FORM.host_arrival_orientation = qGetHostHistory.host_arrival_orientation;
			FORM.doc_class_schedule = qGetHostHistory.doc_class_schedule;
		}
		
		/***************************************
			Set Compliance Notifications
		***************************************/
		
		if ( isDate(qGetHostHistory.datePlaced)  ) {
		
			// Single Placement Paperwork
			if ( vTotalHistoryFamilyMembers EQ 1 AND qGetProgramInfo.seasonid GT 7 ) {
	
				if ( isDate(FORM.doc_single_ref_check1) AND FORM.doc_single_ref_check1 GT qGetHostHistory.datePlaced ) {
					SESSION.formErrors.Add("Date of Single Placement Reference Check 1 is out of compliance");
				}
		
				if ( isDate(FORM.doc_single_ref_check2) AND FORM.doc_single_ref_check2 GT qGetHostHistory.datePlaced ) {
					SESSION.formErrors.Add("Date of Single Placement Reference Check 2 is out of compliance");
				}
	
			}
			
			if ( isDate(FORM.doc_date_of_visit) AND FORM.doc_date_of_visit GT qGetHostHistory.datePlaced ) {
				SESSION.formErrors.Add("Confidential Host Family Date of Visit is out of compliance");
			}
	
			if ( isDate(FORM.doc_date_of_visit2) AND FORM.doc_date_of_visit2 GT qGetHostHistory.datePlaced ) {
				SESSION.formErrors.Add("2nd Confidential Host Family Date of Visit is out of compliance");
			}
			
		}


		/***************************************
			Set Compliance Notifications
		***************************************/
		
		if ( isDate(qGetHostHistory.datePlaced) ) {
		
			// Single Placement Paperwork
			if ( vTotalHistoryFamilyMembers EQ 1 AND qGetProgramInfo.seasonid GT 7 ) {
	
				// 
				if ( isDate(FORM.doc_single_ref_check1) AND FORM.doc_single_ref_check1 GT qGetHostHistory.datePlaced ) {
					SESSION.formErrors.Add("Date of Single Placement Reference Check 1 is out of compliance");
				}
				
				//
				if ( isDate(FORM.doc_single_ref_check2) AND FORM.doc_single_ref_check2 GT qGetHostHistory.datePlaced ) {
					SESSION.formErrors.Add("Date of Single Placement Reference Check 2 is out of compliance");
				}
	
			}
			
			// Confidential Host Family Visit Form
			if ( isDate(FORM.doc_date_of_visit) AND FORM.doc_date_of_visit GT qGetHostHistory.datePlaced ) {
				SESSION.formErrors.Add("Confidential Host Family Date of Visit is out of compliance");
			}
			
			// 2nd Confidential Host Family Visit Form ( Welcome Family - 30 days / Permanent Family 60 days )
			if ( isDate(qGetSecondVisitReport.dateOfVisit) ) {
	
				vComplianceWindow = '';
				vDateStartWindowCompliance = '';
				vDateEndWindowCompliance = '';

				if ( VAL(qGetHostHistory.isWelcomeFamily) ) {
					vComplianceWindow = 30;
				} else {
					vComplianceWindow = 60;
				}
	
				if ( VAL(qGetHostHistory.isRelocation) ) {
					vDateStartWindowCompliance = qGetHostHistory.datePlaced;
				} else {
					vDateStartWindowCompliance = qGetArrival.dep_date;
				}
				
				if ( isDate(vDateStartWindowCompliance) ) {
					vDateEndWindowCompliance = DateAdd('d', vComplianceWindow, vDateStartWindowCompliance);
					
					if ( qGetSecondVisitReport.dateOfVisit GT vDateEndWindowCompliance ) {
						SESSION.formErrors.Add("2nd Confidential Host Family Date of Visit is out of compliance");
					}
					
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
            <th>PLACEMENT PAPERWORK HISTORY</th>
        </tr>
    </table>

	<form name="placementPaperwork" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
		<input type="hidden" name="submitted" value="1"> 
        <input type="hidden" name="historyID" value="#FORM.historyID#" />
        <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
        <input type="hidden" name="childIDList" value="#FORM.childIDList#">

        <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
            <tr bgcolor="##edeff4">
                <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                <td class="reportTitleLeftClean" width="55%">Host Family: #qGetHostHistoryInfo.familyLastName# (###qGetHostHistoryInfo.hostID#)</td>
                <td class="reportTitleLeftClean" width="30%">&nbsp;</td>
            </tr>
        </table>
    		
		<!--- Single Placement Paperwork --->
        <cfif vTotalHistoryFamilyMembers EQ 1 AND qGetProgramInfo.seasonid GT 7>
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
                        <input type="text" name="doc_single_place_auth" id="doc_single_place_auth" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_place_auth, 'mm/dd/yyyy')#">
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
                        <input type="text" name="doc_single_ref_form_1" id="doc_single_ref_form_1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_form_1, 'mm/dd/yyyy')#">
                    </td>
                </tr>
                
                <!--- Date of Single Placement Reference Check 1 --->
                <tr> 
                    <td>&nbsp;</td>
                    <td><label for="doc_single_ref_check1">Date of Single Placement Reference Check 1</label></td>
                    <td>
                        <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#</span>
                        <input type="text" name="doc_single_ref_check1" id="doc_single_ref_check1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_check1, 'mm/dd/yyyy')#">
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
                        <input type="text" name="doc_single_ref_form_2" id="doc_single_ref_form_2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_form_2, 'mm/dd/yyyy')#">
                    </td>
                </tr>
                
                <!--- Date of Single Placement Reference Check 2 --->
                <tr> 
                    <td>&nbsp;</td>
                    <td><label for="doc_single_ref_check2">Date of Single Placement Reference Check 2</label></td>
                    <td>
                        <span class="readOnly displayNone">#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#</span>
                        <input type="text" name="doc_single_ref_check2" id="doc_single_ref_check2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_single_ref_check2, 'mm/dd/yyyy')#">
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
                <td width="15%" class="paperworkLeftColumn"><input type="checkbox" name="datePlacedCheckBox" id="datePlaced" class="editPage" <cfif isDate(qGetHostHistory.datePlaced)>checked</cfif> disabled="disabled"></td>
                <td width="55%"><label>Date Placed ( Headquarters Approval Date )</label></td>
                <td width="30%"><input type="text" name="datePlaced" id="datePlaced" class="datePicker" value="#DateFormat(qGetHostHistory.datePlaced, 'mm/dd/yyyy')#" disabled="disabled"></td>
            </tr>

            <!--- PIS Sent to Intl. Representative --->
            <tr> 
                <td class="paperworkLeftColumn"><input type="checkbox" name="datePISEmailedCheckBox" id="datePISEmailed" class="editPage" <cfif isDate(qGetHostHistory.datePISEmailed)>checked</cfif> disabled="disabled"></td>
                <td><label>PIS Emailed to International Representative</label></td>
                <td><input type="text" name="datePISEmailed" id="datePISEmailed" class="datePicker" value="#DateFormat(qGetHostHistory.datePISEmailed, 'mm/dd/yyyy')#" disabled="disabled"></td>
            </tr>

            <!--- Host Family Application Received --->
            <tr> 
                <td class="paperworkLeftColumn">
                    <input type="checkbox" name="check_doc_full_host_app_date" id="check_doc_full_host_app_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_full_host_app_date');" <cfif isDate(FORM.doc_full_host_app_date)>checked</cfif> >
                </td>
                <td><label for="check_doc_full_host_app_date">Host Family Application Received</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_full_host_app_date, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_full_host_app_date" id="doc_full_host_app_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_full_host_app_date, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_letter_rec_date" id="doc_letter_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_rules_rec_date" id="doc_rules_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_rules_rec_date, 'mm/dd/yyyy')#">
                </td>
            </tr>

			<!--- Date Signed --->
            <tr> 
                <td>&nbsp;</td>
                <td><label for="doc_rules_sign_date">Date Signed</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_rules_sign_date, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_rules_sign_date" id="doc_rules_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_rules_sign_date, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_photos_rec_date" id="doc_photos_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#">
                </td>
            </tr>
            
            <!--- Student Bedroom Photo --->
            <tr> 
                <td class="paperworkLeftColumn">
                    <input type="checkbox" name="check_doc_bedroom_photo" id="check_doc_bedroom_photo" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_bedroom_photo');" <cfif isDate(FORM.doc_bedroom_photo)>checked</cfif> >
                </td>
                <td><label for="check_doc_bedroom_photo">Student Bedroom Photo</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_bedroom_photo, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_bedroom_photo" id="doc_bedroom_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_bedroom_photo, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_bathroom_photo" id="doc_bathroom_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_bathroom_photo, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_kitchen_photo" id="doc_kitchen_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_kitchen_photo, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_living_room_photo" id="doc_living_room_photo" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_living_room_photo, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_school_profile_rec" id="doc_school_profile_rec" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_profile_rec, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_conf_host_rec" id="doc_conf_host_rec" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_conf_host_rec, 'mm/dd/yyyy')#">
                </td>
            </tr>
            
            <!--- Date of Visit --->
            <tr> 
                <td>&nbsp;</td>
                <td><label for="doc_date_of_visit">Date of Visit</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_date_of_visit" id="doc_date_of_visit" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_date_of_visit, 'mm/dd/yyyy')#">
                </td>
            </tr>
            
            <!--- Second Host Family Visit Report - Get Dates from Progress Report Section --->
            <cfif qGetProgramInfo.seasonid GT 7>

				<!--- 2nd Confidential Host Family Visit Form --->
                <tr> 
                    <td class="paperworkLeftColumn">
                        <input type="checkbox" name="pr_ny_approved_dateCheckBox" id="pr_ny_approved_date" class="editPage" <cfif isDate(qGetHistorySecondVisitReport.pr_ny_approved_date)>checked</cfif> disabled="disabled">
                    </td>
                    <td><label>2nd Confidential Host Family Visit Form ( Headquarters Approval )</label></td>
                    <td><input type="text" name="pr_ny_approved_date" id="pr_ny_approved_date" class="datePicker" value="#DateFormat(qGetHistorySecondVisitReport.pr_ny_approved_date, 'mm/dd/yyyy')#" disabled="disabled"></td>
                </tr>
    
                <!--- Date of 2nd Visit --->
                <tr> 
                    <td>&nbsp;</td>
                    <td><label>Date of 2nd Visit</label></td>
                    <td><input type="text" name="dateOfVisit" id="dateOfVisit" class="datePicker" value="#DateFormat(qGetHistorySecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#" disabled="disabled"></td>
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
                    <input type="text" name="doc_ref_form_1" id="doc_ref_form_1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_form_1, 'mm/dd/yyyy')#">
                </td>
            </tr>

            <!--- Date of Reference Check 1 --->   
            <tr>
                <td>&nbsp;</td>
                <td><label for="doc_ref_check1">Date of Reference Check 1</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_ref_check1" id="doc_ref_check1" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_check1, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_ref_form_2" id="doc_ref_form_2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_form_2, 'mm/dd/yyyy')#">
                </td>
            </tr>
            
            <!--- Date of Reference Check 2 --->
            <tr>
                <td>&nbsp;</td>
                <td><label for="doc_ref_check2">Date of Reference Check 2</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_ref_check2" id="doc_ref_check2" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_ref_check2, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_income_ver_date" id="doc_income_ver_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_income_ver_date, 'mm/dd/yyyy')#">
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
                    <input type="text" name="doc_school_accept_date" id="doc_school_accept_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_accept_date, 'mm/dd/yyyy')#">
                </td>
            </tr>
            
            <!--- School Acceptance Form - Date of Signature --->
            <tr> 
                <td>&nbsp;</td>
                <td><label for="doc_school_sign_date">Date of Signature</label></td>
                <td>
                    <span class="readOnly displayNone">#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#</span>
                    <input type="text" name="doc_school_sign_date" id="doc_school_sign_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_school_sign_date, 'mm/dd/yyyy')#">
                </td>
            </tr>				
        </table>
        
		<!--- CBC Forms --->
        <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
            <tr bgcolor="##edeff4">
                <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                <td class="reportTitleLeftClean" width="55%">CBC Authorization Forms</td>
                <td class="reportTitleLeftClean" width="30%">Date</td>
            </tr>
        </table>
        
        <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
            <!--- Host Father --->
            <cfif LEN(qGetHostHistoryInfo.fatherFirstName)>						
                <tr> 
                    <td width="15%" class="paperworkLeftColumn">
                        <input type="checkbox" name="check_fathercbc_form" id="check_fathercbc_form" class="editPage displayNone" onclick="setTodayDate(this.id, 'fathercbc_form');" <cfif isDate(FORM.fathercbc_form)>checked</cfif> >
                    </td>
                    <td width="55%"><label for="check_fathercbc_form">Host Father</label></td>
                    <td width="30%">
                        <span class="readOnly displayNone">#DateFormat(FORM.fathercbc_form, 'mm/dd/yyyy')#</span>
                        <input type="text" name="fathercbc_form" id="fathercbc_form" class="datePicker editPage displayNone" value="#DateFormat(FORM.fathercbc_form, 'mm/dd/yyyy')#">
                    </td>
                </tr>
            </cfif>
            
            <!--- Host Mother --->
            <cfif LEN(qGetHostHistoryInfo.motherFirstName)>
                <tr> 
                    <td width="15%" class="paperworkLeftColumn">
                        <input type="checkbox" name="check_mothercbc_form" id="check_mothercbc_form" class="editPage displayNone" onclick="setTodayDate(this.id, 'mothercbc_form');" <cfif isDate(FORM.mothercbc_form)>checked</cfif> >
                    </td>
                    <td width="55%"><label for="check_mothercbc_form">Host Mother</label></td>
                    <td width="30%">
                        <span class="readOnly displayNone">#DateFormat(FORM.mothercbc_form, 'mm/dd/yyyy')#</span>
                        <input type="text" name="mothercbc_form" id="mothercbc_form" class="datePicker editPage displayNone" value="#DateFormat(FORM.mothercbc_form, 'mm/dd/yyyy')#">
                    </td>
                </tr>
            </cfif>
        </table>

        <!--- CBC Forms Host Members 18+ --->
        <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">                    
            <tr bgcolor="##edeff4">
                <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                <td class="reportTitleLeftClean" width="55%">CBC Authorization Forms - Host Members 18+</td>
                <td class="reportTitleLeftClean" width="30%">Date</td>
            </tr>
        </table>
        
        <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">
            <cfloop query="qGetEligibleCBCFamilyHistoryMembers">
                <tr> 
                    <td width="15%" class="paperworkLeftColumn">
                        <input type="checkbox" name="member#qGetEligibleCBCFamilyHistoryMembers.currentRow#check" id="member#qGetEligibleCBCFamilyHistoryMembers.currentRow#check" class="editPage displayNone" onclick="setTodayDate(this.id, 'cbc_form_received#qGetEligibleCBCFamilyHistoryMembers.childID#');" <cfif isDate(FORM['cbc_form_received' & qGetEligibleCBCFamilyHistoryMembers.childID])>checked</cfif> >
                    </td>
                    <td width="55%"><label for="member#qGetEligibleCBCFamilyHistoryMembers.currentRow#check">#qGetEligibleCBCFamilyHistoryMembers.name# #qGetEligibleCBCFamilyHistoryMembers.lastname# - #qGetEligibleCBCFamilyHistoryMembers.age# years old</label></td>
                    <td width="30%">
                        <span class="readOnly displayNone">#DateFormat(qGetEligibleCBCFamilyHistoryMembers.cbc_form_received, 'mm/dd/yyyy')#</span>
                        <input type="text" name="cbc_form_received#qGetEligibleCBCFamilyHistoryMembers.childID#" id="cbc_form_received#qGetEligibleCBCFamilyHistoryMembers.childID#" class="datePicker editPage displayNone" value="#DateFormat(FORM['cbc_form_received' & qGetEligibleCBCFamilyHistoryMembers.childID], 'mm/dd/yyyy')#">
                    </td>
                </tr>
            </cfloop>
            
            <cfif NOT VAL(qGetEligibleCBCFamilyHistoryMembers.recordcount)>
                <tr><td colspan="3" align="center">No eligible host family members found.</td></tr>
            </cfif>
       </table>
       
        <!--- CBC - Most Recent Reports --->
        <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
            <tr bgcolor="##edeff4">
                <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                <td class="reportTitleLeftClean" width="55%">CBC - Most Recent Reports</td>
                <td class="reportTitleLeftClean" width="30%">Date</td>
            </tr>
        </table>
        
        <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
            <!--- Host Father --->
            <cfif VAL(qGetCBCHistoryFather.recordCount)>
                <tr> 
                    <td width="15%" class="paperworkLeftColumn">&nbsp;</td>
                    <td width="55%"><label for="">Host Father</label></td>
                    <td width="30%">
                        <span class="readOnly displayNone">#DateFormat(qGetCBCHistoryFather.date_sent, 'mm/dd/yyyy')# to #DateFormat(qGetCBCHistoryFather.date_expired, 'mm/dd/yyyy')#</span>
                        <input type="text" name="fatherCBC" id="fatherCBC" class="datePicker editPage displayNone" value="#DateFormat(qGetCBCHistoryFather.date_sent, 'mm/dd/yyyy')#" disabled="disabled">
                        to
                        <input type="text" name="fatherCBC" id="fatherCBC" class="datePicker editPage displayNone" value="#DateFormat(qGetCBCHistoryFather.date_expired, 'mm/dd/yyyy')#" disabled="disabled">
                    </td>
                </tr>
            </cfif>
                                    
            <!--- Host Mother --->
            <cfif VAL(qGetCBCHistoryMother.recordCount)>
                <tr> 
                    <td width="15%" class="paperworkLeftColumn">&nbsp;</td>
                    <td width="55%"><label for="motherCBC">Host Mother</label></td>
                    <td width="30%">
                        <span class="readOnly displayNone">#DateFormat(qGetCBCHistoryMother.date_sent, 'mm/dd/yyyy')# to #DateFormat(qGetCBCHistoryMother.date_expired, 'mm/dd/yyyy')#</span>
                        <input type="text" name="motherCBC" id="motherCBC" class="datePicker editPage displayNone" value="#DateFormat(qGetCBCHistoryMother.date_sent, 'mm/dd/yyyy')#" disabled="disabled">
                        to
                        <input type="text" name="motherCBC" id="motherCBC" class="datePicker editPage displayNone" value="#DateFormat(qGetCBCHistoryMother.date_expired, 'mm/dd/yyyy')#" disabled="disabled">
                    </td>
                </tr>
            </cfif>
            
            <!--- Host Members --->
            <cfloop query="qGetEligibleCBCFamilyHistoryMembers">
                <cfscript>
                    // Get CBC Member
                    qGetCBCMember = APPLICATION.CFC.CBC.getCBCHostByID(hostID=qGetHostHistory.hostID, familyMemberID=qGetEligibleCBCFamilyHistoryMembers.childID, cbcType='member', sortBy="date_sent", sortOrder="DESC", getOneRecord=1);
                </cfscript>
                <tr> 
                    <td width="15%" class="paperworkLeftColumn">&nbsp;</td>
                    <td width="55%"><label for="memberCBC#qGetEligibleCBCFamilyHistoryMembers.currentRow#">#qGetEligibleCBCFamilyHistoryMembers.name# #qGetEligibleCBCFamilyHistoryMembers.lastname# - #qGetEligibleCBCFamilyHistoryMembers.age# years old</label></td>
                    <td width="30%">
                        <span class="readOnly displayNone">#DateFormat(qGetCBCMember.date_sent, 'mm/dd/yyyy')# to #DateFormat(qGetCBCMember.date_expired, 'mm/dd/yyyy')#</span>
                        <input type="text" name="memberCBC#qGetEligibleCBCFamilyHistoryMembers.currentRow#" id="memberCBC#qGetEligibleCBCFamilyHistoryMembers.currentRow#" class="datePicker editPage displayNone" value="#DateFormat(qGetCBCMember.date_sent, 'mm/dd/yyyy')#" disabled="disabled">
                        to
                        <input type="text" name="memberCBC#qGetEligibleCBCFamilyHistoryMembers.currentRow#" id="memberCBC#qGetEligibleCBCFamilyHistoryMembers.currentRow#" class="datePicker editPage displayNone" value="#DateFormat(qGetCBCMember.date_expired, 'mm/dd/yyyy')#" disabled="disabled">
                    </td>
                </tr>
            </cfloop>
                
        </table>   

		<table width="90%" cellpadding="2" cellspacing="0" class="section" align="center"> 
			<tr bgcolor="##edeff4">
                <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                <td class="reportTitleLeftClean" width="85%">Student Application</td>
            </tr>
       	</table>
       
      	<table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center">  	
            <!--- Copy to School ---->
            <tr>
                <td width="15%" class="paperworkLeftColumn">
                    <input type="checkbox" name="copy_app_school" id="copy_app_school" value="1" class="editPage displayNone" <cfif FORM.copy_app_school EQ 'yes'>checked="checked"</cfif> >
               	</td>
               	<td width="85%"><label for="copy_app_school">Copy to School</label></td>
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

        <!--- Form Buttons --->  
        <table width="90%" id="tableDisplaySaveButton" border="0" cellpadding="2" cellspacing="0" class="section editPage displayNone" align="center" style="padding:5px;">
            <tr>
                <td align="center"><input name="Submit" type="image" src="../../student_app/pics/save.gif" border="0" alt="Save"/></td>
            </tr>                
        </table>    

	</form>
        
</cfoutput>