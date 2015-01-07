<!--- ------------------------------------------------------------------------- ----
	
	File:		_BookTrip.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Book Trip
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Check if student is already registered to this trip --->
    
    <cfquery name="qCheckStudentRegistration" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	st.ID
        FROM 
        	student_tours st
		INNER JOIN
        	applicationpayment ap ON ap.foreignID = st.ID
            	AND
                	ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND
                	authIsSuccess = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        WHERE 
     		st.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
            st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_id)#">
        AND
        	st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
    </cfquery>
    
    <cfquery name="qCheckStudentReservation" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	st.ID
        FROM 
        	student_tours st
		INNER JOIN
        	applicationpayment ap ON ap.foreignID = st.ID
            	AND
                	ap.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="student_tours">
                AND
                	paymentMethodID = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
        WHERE 
     		st.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#"> 
        AND
            st.tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_id)#">
    </cfquery>
    
    <cfscript>
		if ( VAL(qCheckStudentRegistration.recordCount) ) {
			
			Location("#CGI.SCRIPT_NAME#?action=myTripDetails", "no");
			
		} else if ( VAL(qCheckStudentReservation.recordCount) ) {
			
			Location("#CGI.SCRIPT_NAME#?action=reservationDetails", "no");
			
		}
	</cfscript>
       
    <cfquery name="qGetHostChildren" datasource="#APPLICATION.DSN.Source#">
    	SELECT
        	childID,
            hostID,
            name,
            middleName,
            lastName,
            sex,
            birthDate
    	FROM
        	smg_host_children
    	WHERE
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.hostID)#"> 
        AND	
        	liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
        AND
        	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">       
    </cfquery>

	<!--- Param Form Variables --->
   	<cfparam name="FORM.hostChildSelectedList" default="">
    
    <cfloop query="qGetHostChildren">
    	
		<cfparam name="FORM.#qGetHostChildren.childID#_hostChildFirstName" default="">
        <cfparam name="FORM.#qGetHostChildren.childID#_hostChildLastName" default="">
        <cfparam name="FORM.#qGetHostChildren.childID#_hostChildSex" default="">
        <cfparam name="FORM.#qGetHostChildren.childID#_hostChildBirthDate" default="">
        
	</cfloop>                
                            	
    <!--- FORM SUBMITTED --->
	<cfif VAL(FORM.submitted)>
        
		<cfscript>
			// FORM Validation
			if ( NOT LEN(FORM.otherTravelers) ) {
				SESSION.formErrors.Add("Please answer will any of your host siblings be going along?");
			}
			
			if ( NOT LEN(FORM.shareRoomNationality) ) {
				SESSION.formErrors.Add("Please answer would you prefer roommates of the same nationality as yourself?");
			}
			
			if ( VAL(FORM.otherTravelers) AND NOT LEN(FORM.hostChildSelectedList) ) {
				SESSION.formErrors.Add("You must select at least one host sibling");
			}
			
			// Check Host Child Validation
			For (i=1;i LTE ListLen(hostChildSelectedList); i=i+1) {
				
				getCurrentID = ListGetAt(hostChildSelectedList, i);

				if ( NOT LEN(FORM[getCurrentID & '_hostChildFirstName']) ) {
					SESSION.formErrors.Add("Please enter first name for host sibling #i#");
				}

				if ( NOT LEN(FORM[getCurrentID & '_hostChildLastName']) ) {
					SESSION.formErrors.Add("Please enter last name for host sibling #i#");
				}

				if ( NOT LEN(FORM[getCurrentID & '_hostChildSex']) ) {
					SESSION.formErrors.Add("Please select gender for host sibling #i#");
				}

				if ( NOT IsDate(FORM[getCurrentID & '_hostChildBirthDate']) ) {
					SESSION.formErrors.Add("Please enter a valid DOB for host sibling #i#");
				}

			}
			
			if ( NOT LEN(FORM.emergencyContactName) ) {
				SESSION.formErrors.Add("Please indicate an emergency contact name. This can be a host parent.");
			}
			
			if ( NOT LEN(FORM.emergencyContactPhone) ) {
				SESSION.formErrors.Add("Please indicate an emergency contact.");
			}
		</cfscript>
        
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
        	
            <cfscript>
				// Calculate Total Cost
				vTotalRegistrations = 1 + listLen(hostChildSelectedList);
			
				vTotalCost = qGetTourDetails.tour_price * vTotalRegistrations;
			</cfscript>
            
			<!--- Check if we need to update/insert record --->
            <cfif VAL(qGetStudentPendingRegistration.ID)>
            
				<!--- Update Trip Preferences --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                        student_tours
                    SET
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_ID)#">,
                        totalCost = <cfqueryparam cfsqltype="cf_sql_float" value="#vTotalCost#">,
                        nationality = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomNationality#">,
                        stunationality = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudentInfo.countryName#">,
                        person1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomPerson1#">, 
                        person2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomPerson2#">, 
                        person3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomPerson3#">,
                        med = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.medicalInformation#">,
                        date = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                	WHERE
                    	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentPendingRegistration.ID#">
                </cfquery>
            
            <cfelse>
            
				<!--- Record Trip Preferences --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO
                        student_tours
                    (
                        studentID, 
                        tripID,
                        companyID,
                        totalCost,
                        nationality,
                        stunationality,
                        person1, 
                        person2, 
                        person3,
                        med,
                        date,
                        dateCreated,
                        active,
                        emergencyContactName,
                        emergencyContactPhone
                        
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_ID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.companyID)#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#vTotalCost#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomNationality#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetStudentInfo.countryName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomPerson1#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomPerson2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.shareRoomPerson3#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.medicalInformation#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergencyContactName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergencyContactPhone#">
                    )
                </cfquery>
           
			</cfif> 
            
            <!--- Host Children --->
            <cfloop list="#hostChildSelectedList#" index="childID">
				
                <!--- Update Host Children Information --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                    	smg_host_children
                    SET
                        name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[childID & '_hostChildFirstName']#">,
                        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[childID & '_hostChildLastName']#">,
                        sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM[childID & '_hostChildSex']#">,
                        birthDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM[childID & '_hostChildBirthDate']#" null="#NOT IsDate(FORM[childID & '_hostChildBirthDate'])#">
                    WHERE
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(childID)#"> 
                </cfquery>
				
                <!--- Check if Sibling is already registered --->
                <cfquery name="qCheckSiblingRegistration" datasource="#APPLICATION.DSN.Source#">
                	SELECT
                    	siblingID
                    FROM
                    	student_tours_siblings
                    WHERE
                    	fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
                    AND
                    	siblingID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(childID)#">
                    AND
                    	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_ID)#">                       
                	AND
                    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				</cfquery>
                
                <cfif NOT VAL(qCheckSiblingRegistration.recordCount)>
                                      
					<!--- Register Host Sibling --->
                    <cfquery datasource="#APPLICATION.DSN.Source#">
                        INSERT INTO
                            student_tours_siblings
                        (
                            studentTourID,
                            fk_studentID, 
                            siblingID,
                            tripID,
                            dateCreated                  
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentPendingRegistration.ID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(childID)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_ID)#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                        )
                    </cfquery>
            		
                </cfif>
                
			</cfloop>
            
			<!--- Remove Previous Selected Host Sibling --->
            <cfloop query="qGetHostChildren">
            	
                <cfif NOT ListFind(hostChildSelectedList, qGetHostChildren.childID)>
                	
                    <cfquery datasource="#APPLICATION.DSN.Source#" result="test">
                        UPDATE
                            student_tours_siblings
                        SET
                        	studentTourID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentPendingRegistration.ID)#">,
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        WHERE
                            fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.studentID)#">
                        AND
                            tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.tour_ID)#">
                        AND                        
                            siblingID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetHostChildren.childID)#"> 
                        AND
                            PAID IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    </cfquery>
                    
                </cfif>
            
            </cfloop>
            
            <cfscript>
				// Go to Book Trip - CC Processing
				Location('#CGI.SCRIPT_NAME#?action=bookTrip', 'no');
				
				// No Credit Card Involved
				//Location('#CGI.SCRIPT_NAME#?action=reservationSeat', 'no');
	        </cfscript>
            
		</cfif> <!--- NOT SESSION.formErrors.length() --->
	
    <!--- FORM NOT SUBMITTED --->
    <cfelse>
    	
        <cfscript>
			// Populate Form Fields
			FORM.shareRoomNationality = qGetStudentPendingRegistration.nationality;
			FORM.shareRoomPerson1 = qGetStudentPendingRegistration.person1;
			FORM.shareRoomPerson2 = qGetStudentPendingRegistration.person2;
			FORM.shareRoomPerson3 = qGetStudentPendingRegistration.person3;
			FORM.medicalInformation = qGetStudentPendingRegistration.med;
			
			// Host Siblings
			if ( qGetSiblingsPendingRegistration.recordCount) {
				FORM.otherTravelers = 1;
			} else {
				FORM.otherTravelers = 0;
			}
			
			if ( NOT VAL(qGetStudentPendingRegistration.recordCount) ) {
			
				// Populate Form Fields
				if ( LEN(qGetStudentInfo.med_allergies) ) {
					FORM.medicalInformation = "Medical Allergies: #qGetStudentInfo.med_allergies#";	
				}
				
				if ( LEN(qGetStudentInfo.other_Allergies) ) {
					FORM.medicalInformation = FORM.medicalInformation & " Other Allergies: #qGetStudentInfo.other_Allergies#";	
				}
				
			}
		</cfscript>
        
	</cfif> <!--- FORM SUBMITTED --->

	<cfscript>
        // Populate Disabled Fields
        For (i=1;i LTE qGetHostChildren.recordCount; i=i+1) {
			
			// ListFind(FORM.hostChildSelectedList, qGetHostChildren.childID)>
			
            if ( NOT ListFind(FORM.hostChildSelectedList, qGetHostChildren.childID) ) {
			  // Populate Form Variables
				FORM[qGetHostChildren.childID[i] & '_hostChildFirstName'] = qGetHostChildren.name[i];
                FORM[qGetHostChildren.childID[i] & '_hostChildLastName'] = qGetHostChildren.lastName[i];
                FORM[qGetHostChildren.childID[i] & '_hostChildSex'] = qGetHostChildren.sex[i];
                FORM[qGetHostChildren.childID[i] & '_hostChildBirthDate'] = qGetHostChildren.birthDate[i];
			}

        }

		// Host Siblings
		if ( qGetSiblingsPendingRegistration.recordCount ) {
			FORM.hostChildSelectedList = ValueList(qGetSiblingsPendingRegistration.siblingID);
		}
	</cfscript>

</cfsilent>

<script type="text/javascript">
	// When page is ready run the displayExtraField function
	$(document).ready(function() {
		displayHostChildInformation();
		enableFormFields();
	});

	// Display Host Child Information
	var displayHostChildInformation = function() { 
		
		selectedOption = $("#otherTravelers").val();
		
		// Host Siblings
		if( selectedOption == 1 ) {
			$("#trHostChildInformation").fadeIn("slow");
		} else {
			$("#trHostChildInformation").fadeOut("slow");
			// unselect options
			$('input[name=hostChildSelectedList]').each(function(){
				$(this).attr('checked', false);										 
			});
		}
	
	}

	// Enable Form Fields
	var enableFormFields = function() { 

		 $('input[name=hostChildSelectedList]').each(function(){
			
			getChildID = this.value;
			
			if (this.checked) {
				$('#' + getChildID + "_hostChildFirstName").attr('disabled', false);
				$('#' + getChildID + "_hostChildLastName").attr('disabled', false);
				$('#' + getChildID + "_hostChildSex").attr('disabled', false);
				$('#' + getChildID + "_hostChildBirthDate").attr('disabled', false);
			} else {
				$('#' + getChildID + "_hostChildFirstName").attr('disabled', true);
				$('#' + getChildID + "_hostChildLastName").attr('disabled', true);
				$('#' + getChildID + "_hostChildSex").attr('disabled', true);
				$('#' + getChildID + "_hostChildBirthDate").attr('disabled', true);
			}
			
		});

	}
	
	// Date of Birth Mask
	jQuery(function($){
					
		$('input[name=hostChildSelectedList]').each(function(){
		   $("#" + this.value + "_hostChildBirthDate").mask("99/99/9999");
		});
		
	});		
</script>

<cfoutput>

	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">
                
    <cfform action="#CGI.SCRIPT_NAME#?action=preferences" method="post">
        <input type="hidden" name="submitted" value="1" />
        
        <!--- Display Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tripSection"
        />
        
        
        <!--- Tour Information --->
        <h3 class="tripSectionTitle">Tour Information</h3>
                                                    
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
            <tr class="blueRow">
                <td class="tripFormTitle" width="30%">Trip:</td>
                <td class="tripFormField" width="70%">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)# <a href="#CGI.SCRIPT_NAME#" style="float:right; padding-right:15px;">[ Change Trip ] </a></td>
            </tr>
            <tr>
                <td class="tripFormTitle">Dates:</td>
                <td class="tripFormField">#qGetTourDetails.tour_date# - #qGetTourDetails.tour_length#</td>
            </tr>
            <tr class="blueRow">
                <td class="tripFormTitle">Cost:</td>
                <td class="tripFormField">
                    #LSCurrencyFormat(APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_price))# 
                    <em class="tripNotesRight">Per person - Does not include your round trip airline ticket</em>
                </td>
            </tr>
            <cfif qGetTourDetails.chargeType EQ 'deposit'>
                <tr>
                    <td class="tripFormTitle">Deposit:</td>
                    <td class="tripFormField">
                        #LSCurrencyFormat(100)# 
                        <em class="tripNotesRight">*** Deposit Due Immediately ***</em>
                        <em class="tripNotesRight">
                            Remaining balance will be charged to the same credit card 60 days prior to the trip. If credit card used changes please notify MPD Tours America with new information
                        </em>
                    </td>
                </tr>
            </cfif>
        </table>
        
                            
        <!--- Host Siblings --->
        <h3 class="tripSectionTitle">Host Siblings</h3>        
                    
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
            <tr class="blueRow">
                <td class="tripFormTitle" width="30%">Will any of your host siblings be going along? <span class="required">*</span></td>
                <td class="tripFormField" width="70%">
                    <select name="otherTravelers" id="otherTravelers" class="smallField" onchange="displayHostChildInformation();">
                        <option value=""></option>
                        <option value="1" <cfif VAL(FORM.otherTravelers)> selected="selected" </cfif> >Yes</option>
                        <option value="0" <cfif FORM.otherTravelers EQ 0> selected="selected" </cfif> >No</option>
                    </select>
                </td>
            </tr>
            <tr id="trHostChildInformation" class="displayNone">
                <td class="tripFormTitle">Who will be going?<span class="required">*</span></td>
                <td class="tripFormField">
                    
                    <table border="0" align="center" cellpadding="2" cellspacing="0" style="width:100%">
                        <tr style="font-weight:bold;">
                            <td></td>
                            <td>First Name <span class="required">*</span></td>
                            <td>Last Name <span class="required">*</span></td>
                            <td>Gender <span class="required">*</span></td>
                            <td>DOB <span class="required">*</span></td>                                    
                        </tr>                                    	
                        <cfloop query="qGetHostChildren">
                            <tr>
                                <td><input type="checkbox" name="hostChildSelectedList" id="#qGetHostChildren.childID & '_hostChildID'#" value="#qGetHostChildren.childID#" onclick="enableFormFields();" <cfif ListFind(FORM.hostChildSelectedList, qGetHostChildren.childID)> checked="checked" </cfif> /></td>
                                <td><input type="text" name="#qGetHostChildren.childID & '_hostChildFirstName'#" id="#qGetHostChildren.childID & '_hostChildFirstName'#" value="#FORM[qGetHostChildren.childID & '_hostChildFirstName']#" class="smallField" maxlength="100" disabled="disabled" /></td>
                                <td><input type="text" name="#qGetHostChildren.childID & '_hostChildLastName'#" id="#qGetHostChildren.childID & '_hostChildLastName'#" value="#FORM[qGetHostChildren.childID & '_hostChildLastName']#" class="smallField" maxlength="100" disabled="disabled" /></td>
                                <td>
                                    <select name="#qGetHostChildren.childID & '_hostChildSex'#" id="#qGetHostChildren.childID & '_hostChildSex'#" class="smallField" disabled="disabled">
                                        <option value=""></option>
                                        <option value="Male" <cfif FORM[qGetHostChildren.childID & '_hostChildSex'] EQ 'male'> selected="selected" </cfif> >Male</option>
                                        <option value="Female" <cfif FORM[qGetHostChildren.childID & '_hostChildSex'] EQ 'Female'> selected="selected" </cfif> >Female</option>
                                    </select>
                                </td>
                                <td><input type="text" name="#qGetHostChildren.childID & '_hostChildBirthDate'#" id="#qGetHostChildren.childID & '_hostChildBirthDate'#" value="#DateFormat(FORM[qGetHostChildren.childID & '_hostChildBirthDate'], 'mm/dd/yyyy')#" class="smallField" disabled="disabled" /></td>                                    
                            </tr>                                                                        	
                        </cfloop>
                    </table>
                    <cfif NOT VAL(qGetHostChildren.recordCount)>
                        <em class="tripNotesRight">There are no host siblings living with you at home.</em>
                    <cfelse>
                        <em class="tripNotesRight">Check who is going and verify ther information</em>     
                    </cfif>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><span class="required">* Required Fields</span></td>
            </tr>  
       </table>  
            
            
        <!--- Preferences --->
        <h3 class="tripSectionTitle">Preferences</h3> 
        <em class="tripTitleNotes">Couple of things to help make your trip better</em> 
                          
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
            <tr class="blueRow">
                <td class="tripFormTitle" width="30%">Would you prefer roommates of the same nationality as yourself? <span class="required">*</span></td>
                <td class="tripFormField" width="70%">
                    <input type="radio" name="shareRoomNationality" id="nationalitySame"  value='Same' <cfif FORM.shareRoomNationality EQ 'Same'>checked</cfif> /> 
                    <label for="nationalitySame"> Same </label>
                    &nbsp;
                    <input type="radio" name="shareRoomNationality" id="nationalityDifferent" value='Different' <cfif FORM.shareRoomNationality EQ 'Different'>checked</cfif> /> 
                    <label for="nationalityDifferent"> Different  </label>
                    &nbsp;
                    <input type="radio" name="shareRoomNationality" id="nationalityNoPreference" value='No Preference' <cfif FORM.shareRoomNationality EQ 'No Preference'>checked</cfif>/> 
                    <label for="nationalityNoPreference"> No Preference </label>                        
                </td>
            </tr>
            <tr>
                <td class="tripFormTitle">Would you like to share a room with anyone in particular?</td>
                <td class="tripFormField">
                    <label for="shareRoomPerson1">Person ##1</label> &nbsp; <input type="Text" name="shareRoomPerson1" id="shareRoomPerson1" value="#FORM.shareRoomPerson1#" class="largeField"> 
                    <label for="shareRoomPerson2">Person ##2</label>  &nbsp; <input type="text" name="shareRoomPerson2" id="shareRoomPerson2" value="#FORM.shareRoomPerson2#" class="largeField"> 
                    <label for="shareRoomPerson3">Person ##3</label>  &nbsp; <input type="text" name="shareRoomPerson3" id="shareRoomPerson3" value="#FORM.shareRoomPerson3#" class="largeField"> 
                    <em class="tripNotesRight">Please list their names above.</em>                            
                </td>
            </tr>
              <tr class="blueRow">
                <td class="tripFormTitle">Emergency Contact Name:</td>
                <td class="tripFormField">
                    <input type="text" name="EmergencyContactName" size=25/>
                </td>
            </tr>
             <tr class="blueRow">
                <td class="tripFormTitle">Emergency Contact Phone:</td>
                <td class="tripFormField">
                    <cfinput type="text" name="EmergencyContactPhone" size=25 mask="(999) 999-9999"/>
                </td>
            </tr>
            <tr >
                <td class="tripFormTitle">Medical Information:</td>
                <td class="tripFormField">
                    <textarea name="medicalInformation" class="largeTextArea" placeholder=""></textarea>
                    <em class="tripNotesRight">
                        List allergies, medical conditions or limitations (vegitarian, etc), and any prescription medications. <br />
                        If you are currently being treated for a medical condition, include your physicians name and phone number. <br>
                        Please remember you must cary your insurance card while on tour.
                    </em>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><span class="required">* Required Fields</span></td>
            </tr>  
        </table>   
        
        <!--- Button --->
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableButton">                                       
            <tr class="blueRow">
                <td colspan="2" align="center"><input type="image" src="extensions/images/Next.png" width="89" height="33" /></td>
            </tr>
        </table>
    </cfform>

</cfoutput>