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
    
    <!--- Placement Paperwork --->
    <cfparam name="FORM.school_acceptance" default="">
    <cfparam name="FORM.sevis_fee_paid" default="">
    <cfparam name="FORM.i20received" default="">
    <cfparam name="FORM.hf_placement" default="">
    <cfparam name="FORM.hf_application" default="">
    <cfparam name="FORM.doc_letter_rec_date" default="">
    <cfparam name="FORM.doc_rules_rec_date" default="">
    <cfparam name="FORM.doc_photos_rec_date" default="">
    <cfparam name="FORM.doc_school_profile_rec" default="">
    <cfparam name="FORM.doc_conf_host_rec" default="">
    <cfparam name="FORM.doc_ref_form_1" default="">
    <cfparam name="FORM.doc_ref_form_2" default="">
    
    <cfscript>
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {
			
			// Update fields on the student table
			APPLICATION.CFC.STUDENT.updatePlacementPaperwork(
				studentID = FORM.studentID,
				historyID = qGetPlacementHistory.historyID,
				// Placement Paperwork
				school_acceptance = FORM.school_acceptance,
				sevis_fee_paid = FORM.sevis_fee_paid,
				i20received = FORM.i20received,
				hf_placement = FORM.hf_placement,
				hf_application = FORM.hf_application,
				doc_letter_rec_date = FORM.doc_letter_rec_date,
				doc_rules_rec_date = FORM.doc_rules_rec_date,
				doc_photos_rec_date = FORM.doc_photos_rec_date,
				doc_school_profile_rec = FORM.doc_school_profile_rec,
				doc_conf_host_rec = FORM.doc_conf_host_rec,
				doc_ref_form_1 = FORM.doc_ref_form_1,
				doc_ref_form_2 = FORM.doc_ref_form_2
			);
			
			// Set Page Message
			SESSION.pageMessages.Add("Form successfully submitted.");
			
			// Reload page
			location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetStudentInfo.studentID;
			// Placement Paperwork
			FORM.school_acceptance = qGetStudentInfo.school_acceptance;
			FORM.sevis_fee_paid = qGetStudentInfo.sevis_fee_paid;
			FORM.i20received = qGetStudentInfo.i20received;
			FORM.hf_placement = qGetStudentInfo.hf_placement;
			FORM.hf_application = qGetStudentInfo.hf_application;
			FORM.doc_letter_rec_date = qGetStudentInfo.doc_letter_rec_date;
			FORM.doc_rules_rec_date = qGetStudentInfo.doc_rules_rec_date;
			FORM.doc_photos_rec_date = qGetStudentInfo.doc_photos_rec_date;
			FORM.doc_school_profile_rec = qGetStudentInfo.doc_school_profile_rec;
			FORM.doc_conf_host_rec = qGetStudentInfo.doc_conf_host_rec;
			FORM.doc_ref_form_1 = qGetStudentInfo.doc_ref_form_1;
			FORM.doc_ref_form_2 = qGetStudentInfo.doc_ref_form_2;
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
                    <tr bgcolor="##edeff4">
                        <td class="reportTitleLeftClean" width="15%">&nbsp;</td>
                        <td class="reportTitleLeftClean" width="55%">Paperwork</td>
                        <td class="reportTitleLeftClean" width="30%">Date</td>
                    </tr>
                </table>
                
                <table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 

                    <!--- PIS Approved --->
                    <tr> 
                        <td class="paperworkLeftColumn" width="15%"><input type="checkbox" name="datePlacedCheckBox" id="datePlacedCheckBox" disabled="disabled" <cfif isDate(qGetStudentInfo.datePlaced)>checked</cfif> ></td>
                        <td width="55%"><label for="datePlaced">Date Placed ( Headquarters Office Approval Date )</label></td>
                        <td width="30%"><input type="text" name="datePlaced" id="datePlaced" class="datePicker" value="#DateFormat(qGetStudentInfo.datePlaced, 'mm/dd/yyyy')#" disabled="disabled"></td>
                    </tr>

                    <!--- PIS Sent to Intl. Representative --->
                    <tr> 
                        <td class="paperworkLeftColumn"><input type="checkbox" name="datePISEmailedCheckBox" id="datePISEmailedCheckBox" disabled="disabled" <cfif isDate(qGetStudentInfo.datePISEmailed)>checked</cfif> ></td>
                        <td><label for="datePISEmailed">PIS Emailed to International Representative</label></td>
                        <td><input type="text" name="datePISEmailed" id="datePISEmailed" class="datePicker" value="#DateFormat(qGetStudentInfo.datePISEmailed, 'mm/dd/yyyy')#" disabled="disabled"></td>
                    </tr>

                    <!--- School Acceptance --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="schoolAcceptanceCheckBox" id="schoolAcceptanceCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'school_acceptance');" <cfif isDate(FORM.school_acceptance)>checked</cfif> >
						</td>
                        <td><label for="schoolAcceptanceCheckBox">School Acceptance</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_letter_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="school_acceptance" id="school_acceptance" class="datePicker editPage displayNone" value="#DateFormat(FORM.school_acceptance, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Sevis Fee Paid --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="sevisFeePaidCheckBox" id="sevisFeePaidCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'sevis_fee_paid');" <cfif isDate(FORM.sevis_fee_paid)>checked</cfif> >
						</td>
                        <td><label for="sevisFeePaidCheckBox">Sevis Fee Paid</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.sevis_fee_paid, 'mm/dd/yyyy')#</span>
                            <input type="text" name="sevis_fee_paid" id="sevis_fee_paid" class="datePicker editPage displayNone" value="#DateFormat(FORM.sevis_fee_paid, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- I-20 Received --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="i20receivedCheckBox" id="i20receivedCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'i20received');" <cfif isDate(FORM.i20received)>checked</cfif> >
						</td>
                        <td><label for="i20receivedCheckBox">I-20 Received</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.i20received, 'mm/dd/yyyy')#</span>
                            <input type="text" name="i20received" id="i20received" class="datePicker editPage displayNone" value="#DateFormat(FORM.i20received, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
                    
                    <!--- Host Family Placement --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="hfPlacementCheckBox" id="hfPlacementCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'hf_placement');" <cfif isDate(FORM.hf_placement)>checked</cfif> >
						</td>
                        <td><label for="hfPlacementCheckBox">Host Family Placement</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.hf_placement, 'mm/dd/yyyy')#</span>
                            <input type="text" name="hf_placement" id="hf_placement" class="datePicker editPage displayNone" value="#DateFormat(FORM.hf_placement, 'mm/dd/yyyy')#">
                        </td>
                    </tr>
					
                    <!--- Host Family Application --->
                    <tr>
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="hfApplicationCheckBox" id="hfApplicationCheckBox" class="editPage displayNone" onclick="setTodayDate(this.id, 'hf_application');" <cfif isDate(FORM.hf_application)>checked</cfif> >
						</td>
                        <td><label for="hfApplicationCheckBox">Host Family Application</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.hf_application, 'mm/dd/yyyy')#</span>
                            <input type="text" name="hf_application" id="hf_application" class="datePicker editPage displayNone" value="#DateFormat(FORM.hf_application, 'mm/dd/yyyy')#">
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

                    <!--- Host Family Photos --->
                    <tr> 
                        <td class="paperworkLeftColumn">
                            <input type="checkbox" name="check_doc_photos_rec_date" id="check_doc_photos_rec_date" class="editPage displayNone" onclick="setTodayDate(this.id, 'doc_photos_rec_date');" <cfif isDate(FORM.doc_photos_rec_date)>checked</cfif> >
						</td>
                        <td><label for="check_doc_photos_rec_date">Host Family Photos</label></td>
                        <td>
                            <span class="readOnly displayNone">#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#</span>
                            <input type="text" name="doc_photos_rec_date" id="doc_photos_rec_date" class="datePicker editPage displayNone" value="#DateFormat(FORM.doc_photos_rec_date, 'mm/dd/yyyy')#">
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
				</table>
                
                <!--- Form Buttons --->  
                <table width="90%" id="tableDisplaySaveButton" border="0" cellpadding="2" cellspacing="0" class="section editPage displayNone" align="center" style="padding:5px;">
                    <tr>
                        <td align="center"><input name="Submit" type="image" src="../../pics/save.gif" border="0" alt="Save"/></td>
                    </tr>                
                </table>    
    
            </cfdefaultcase>
            
        </cfswitch>            

	</form>
        
</cfoutput>