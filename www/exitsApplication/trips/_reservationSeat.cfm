<!--- ------------------------------------------------------------------------- ----
	
	File:		_reservationSeat.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Trip Registration - No Credit Card Involved
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<!--- Get Total Registrations --->
    <cfquery name="qGetTripTotalRegisteredStudents" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            tour_ID,
            tour_name,
            totalSpots,
            SUM(total) AS total
        FROM
        (
        
            SELECT 
                t.tour_ID,
                t.tour_name,
                t.totalSpots,
                COUNT(st.studentID) AS total
            FROM 
                smg_tours t
            LEFT OUTER JOIN
                student_tours st ON st.tripID = t.tour_ID
                    AND
                        st.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    AND
                        st.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            WHERE
                t.tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.tourID)#">
                
            UNION
    
            SELECT 
                t.tour_ID,
                t.tour_name,
                t.totalSpots,
                COUNT(sts.siblingID) AS total
            FROM 
                smg_tours t
            INNER JOIN	
                student_tours_siblings sts ON sts.tripID = t.tour_ID
                    AND
                        sts.paid IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
            WHERE
                t.tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.tourID)#">
        
        ) AS deviredTable
        
        GROUP BY
        	tour_ID
        
        ORDER BY
        	tour_name
	</cfquery>

    <cfquery name="qGetTotalPendingMaleSiblings" dbtype="query">
        SELECT 
            count(sex) AS total
        FROM 
        	qGetSiblingsPendingRegistration
        WHERE 
        	sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="male">            
    </cfquery>

    <cfquery name="qGetTotalPendingFemaleSiblings" dbtype="query">
        SELECT 
            count(sex) AS total
        FROM 
        	qGetSiblingsPendingRegistration
        WHERE 
        	sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="female">            
    </cfquery>
    
    <cfscript>	
		// Get total of siblings
		vTotalMaleRegistering = VAL(qGetTotalPendingMaleSiblings.total);
		
		vTotalFemaleRegistering = VAL(qGetTotalPendingFemaleSiblings.total);
		
		// Add student to totals
		if ( qGetStudentInfo.sex EQ 'male' ) {
			
			vTotalMaleRegistering = vTotalMaleRegistering + 1;
			
		} else if ( qGetStudentInfo.sex EQ 'female' ) {
			
			vTotalFemaleRegistering = vTotalFemaleRegistering + 1;
			
		}
		
		// Total Students and siblings
		vTotalRegistrations = VAL(vTotalMaleRegistering) + VAL(vTotalFemaleRegistering);
    
		// Set Total Price	
		vTotalDue = qGetTourDetails.tour_price * vTotalRegistrations;
		
		// Check trip availability
		vIsTripFull = 0;
		
		// Check if trip is full
		if ( qGetTripTotalRegisteredStudents.total EQ qGetTourDetails.totalSpots ) {
			
			vIsTripFull = 1;
			SESSION.formErrors.Add("Unfortunately this trip is FULL and you can no longer register");
			
		// Check if trip has reached the registration limit
		} else if ( qGetTripTotalRegisteredStudents.total EQ qGetTourDetails.spotLimit ) {
			
			// Check Male Registration
			if ( vTotalMaleRegistering GT qGetTourDetails.extraMaleSpot ) {
				
				vIsTripFull = 1;
				
				if ( VAL(qGetTourDetails.extraMaleSpot) ) {
					SESSION.formErrors.Add("Unfortunately there is only #qGetTourDetails.extraMaleSpot# male seat available");
				} else {
					SESSION.formErrors.Add("Unfortunately this trip is FULL and you can no longer register, #qGetTourDetails.extraFemaleSpot# female seat(s) available");
				}
				
			// Check Female Registration
			} else if ( vTotalFemaleRegistering GT qGetTourDetails.extraFemaleSpot ) {
				
				vIsTripFull = 1;

				if ( VAL(qGetTourDetails.extraMaleSpot) ) {
					SESSION.formErrors.Add("Unfortunately there is only #qGetTourDetails.extraFemaleSpot# female seat available");
				} else {
					SESSION.formErrors.Add("Unfortunately this trip is FULL and you can no longer register, #qGetTourDetails.extraMaleSpot# male seat(s) available");
				}

			}

		}
	</cfscript>
    
    <!--- FORM SUBMITTED --->
	<cfif VAL(FORM.submitted)>
		
        <cfscript>
			// FORM Validation
			if ( NOT LEN(FORM.emailAddress) ) {
				SESSION.formErrors.Add("Please enter an email address");
			}

			if ( LEN(FORM.emailAddress) AND NOT IsValid("email", FORM.emailAddress) ) {
				SESSION.formErrors.Add("Please enter a valid email address");
			}

			if ( NOT LEN(FORM.confirmEmailAddress) ) {
				SESSION.formErrors.Add("Please confirm your email address");
			}
	
			if ( LEN(FORM.confirmEmailAddress) AND NOT IsValid("email", FORM.confirmEmailAddress) ) {
				SESSION.formErrors.Add("Please enter a valid confirm email address");
			}

			if ( LEN(FORM.emailAddress) AND LEN(FORM.confirmEmailAddress) AND FORM.emailAddress NEQ FORM.confirmEmailAddress ) {
				SESSION.formErrors.Add("Email addresses do not match");
			}

			if ( NOT VAL(FORM.registeringAgreement) OR NOT VAL(FORM.airfareAgreement) ) {
				SESSION.formErrors.Add("Please accept our Terms and Conditions");
			}
		</cfscript>
        
        <cfif NOT SESSION.formErrors.length()>

			<!--- Update Email Address --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE
                    student_tours
                SET
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emailAddress#"> 
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentPendingRegistration.ID)#"> 
            </cfquery>
            
            <cfscript>
				// Set Receipt Description
				vReceiptDescription = "Reservation for #APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)# - Student #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# ###qGetStudentInfo.studentID#";
				// Include Number of Siblings
				if ( VAL(qGetSiblingsPendingRegistration.recordCount) ) {
					vReceiptDescription = vReceiptDescription & " and #VAL(qGetSiblingsPendingRegistration.recordCount)# host sibling(s)";
				}
				
				// Insert Payment Information (applicationPayment Table)
				getApplicationPaymentID = APPLICATION.CFC.PAYMENTGATEWAY.insertPaymentReservation( 
					applicationID=8,
					sessionInformationID=SESSION.informationID,
					foreignTable='student_tours',
					foreignID=qGetStudentPendingRegistration.ID,
					amount=FORM.totalDue,
					paymentMethodID=2, // Personal Check
					paymentMethodType=APPLICATION.CONSTANTS.paymentMethod[2]
				);
			</cfscript>
			
			<!--- Student - Record Payment as Received / Activate Record --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE
                    student_tours
                SET
                    active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                WHERE
                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentPendingRegistration.ID)#"> 
            </cfquery>
            
            <!--- Host Siblings - Record Payment as Received / Activate Record --->
            <cfif VAL(qGetSiblingsPendingRegistration.recordCount)>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                        student_tours_siblings
                    SET
                        studentTourID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentPendingRegistration.ID#">
                    WHERE
                        ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(qGetSiblingsPendingRegistration.ID)#" list="yes"> )
                </cfquery>
                
            </cfif>
            
            <!--- Update Extra Male|Female Limits --->
            <cfif qGetTripTotalRegisteredStudents.total EQ qGetTourDetails.spotLimit>
                
                <!--- Male/Female Limit --->
                <cftransaction> 
                
                    <cfquery datasource="#APPLICATION.DSN.Source#">
                        UPDATE
                            smg_tours
                        SET
                            extraMaleSpot = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.extraMaleSpot - vTotalMaleRegistering)#">,
                            extraFemaleSpot = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetTourDetails.extraFemaleSpot - vTotalFemaleRegistering)#">
                        WHERE
                            tour_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(SESSION.TOUR.tourID)#">
                    </cfquery>
                    
                </cftransaction>
                
            </cfif>

            <cfscript>
                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?action=reservationConfirmed", "no");
            </cfscript>			
                
		</cfif> <!--- NOT SESSION.formErrors.length() --->
	
    <cfelse>
    	
        <cfscript>
			FORM.totalDue = vTotalDue;
			
			// Pre Populate Field 
			if ( LEN(qGetStudentInfo.med_allergies) ) {
				FORM.medicalInformation = "Medical Allergies: #qGetStudentInfo.med_allergies#";	
			}
			
			if ( LEN(qGetStudentInfo.other_Allergies) ) {
				FORM.medicalInformation = "Other Allergies: #qGetStudentInfo.other_Allergies#";	
			}
		</cfscript>
    
	</cfif> <!--- FORM SUBMITTED --->
	
</cfsilent>

<cfoutput>

	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">
    
    <form name="reservationSeat" id="reservationSeat" action="#CGI.SCRIPT_NAME#?action=reservationSeat" method="post">
        <input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="totalDue" value="#FORM.totalDue#" />
        
        <!--- Display Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tripSection"
        />

        <!--- Trip Information --->
        <h3 class="tripSectionTitle">Trip Information</h3>
        
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
            <tr class="blueRow">
                <td class="tripFormTitle" width="30%">Trip:</td>
                <td class="tripFormField" width="70%">#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</td>
            </tr>
            <tr>
                <td class="tripFormTitle">Total Amount Due:</td>
                <td class="tripFormField">
                    <span class="totalDue">#LSCurrencyFormat(FORM.totalDue)#</span>
                    <em class="tripNotesRight">#LSCurrencyFormat(qGetTourDetails.tour_price)# Per person - Does not include your round trip airline ticket</em>
                </td>
            </tr>
            <tr class="blueRow">
                <td class="tripFormTitle">Number of Registrations:</td>
                <td class="tripFormField">
                    #vTotalRegistrations#
                    <cfif VAL(qGetSiblingsPendingRegistration.recordCount)>
                        <em class="tripNotesRight">You and #qGetSiblingsPendingRegistration.recordCount# host sibling(s)</em>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td class="tripFormTitle">Dates:</td>
                <td class="tripFormField">#qGetTourDetails.tour_date# - #qGetTourDetails.tour_length#</td>
            </tr>
        </table>                
        
        <!--- Trip Not Full --->
        <cfif NOT VAL(vIsTripFull)>
             
			<!--- Student Information --->     
            <h3 class="tripSectionTitle">Student Information</h3>     
    
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
                <tr class="blueRow">
                    <td class="tripFormTitle" width="30%">Student:</td>
                    <td class="tripFormField" width="70%">#qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# (###qGetStudentInfo.studentID#)</td>
                </tr>
                <tr>
                    <td class="tripFormTitle">Country Of Birth:</td>
                    <td class="tripFormField">#qGetStudentInfo.countryname#</td>
                </tr> 
                <tr class="blueRow">
                    <td class="tripFormTitle">Email Address: <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="emailAddress" id="emailAddress" value="#FORM.emailAddress#" class="largeField" maxlength="100" /></td>
                </tr> 
                <tr>
                    <td class="tripFormTitle">Confirm Email Address: <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="confirmEmailAddress" id="confirmEmailAddress" value="#FORM.confirmEmailAddress#" class="largeField" maxlength="100" /></td>
                </tr> 
                <tr class="blueRow">
                    <td>&nbsp;</td>
                    <td><span class="required">* Required Fields</span></td>
                </tr>  
            </table>
                
            <!--- Host Sibling Information ---> 
            <cfif VAL(qGetSiblingsPendingRegistration.recordCount)>
                <h3 class="tripSectionTitle">Host Siblings Going Along</h3>
            
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">
                    <cfloop query="qGetSiblingsPendingRegistration">
                        <tr class="#iif(qGetSiblingsPendingRegistration.currentrow MOD 2 ,DE("blueRow") ,DE("") )#">
                            <td class="tripFormTitle" width="30%">Name:</td>
                            <td class="tripFormField" width="70%">#qGetSiblingsPendingRegistration.name# #qGetSiblingsPendingRegistration.lastName# - #DateFormat(qGetSiblingsPendingRegistration.birthDate, 'mm/dd/yyyy')#</td>
                        </tr>
                    </cfloop>
                </table>
            </cfif>
             
            <!--- Terms and Conditions --->    
            <h3 class="tripSectionTitle">Terms and Conditions</h3>                
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">                    
                <tr>
                    <td colspan="2" style="padding-right:15px;">

                        <h3 style="text-align:center;">Please carefully read the steps below explaining the enrollment process.</h3>
                        
                        <hr width="90%" />
                    
                        <ol style="margin-top:20px; font-weight:bold; color:##F00;">
                            *** 
                            	Before signing up for a trip please confirm with verbal permission (ask) your host family, area representative, 
                                and school (about missing school days) if they will allow you to attend an MPD tours trip.
                            ***
						</ol>
						
                        <!---
                        <ol style="margin-top:0px; font-weight:bold;">
                            Unfortunately we are not able to accept credit cards at this moment, please submit your payment by mail using one of the following options:
                        </ol>
						--->
						
                        <ol class="termsConditions">
                            
                            <!---
                            <li>
                            	To reserve your spot on a trip please sign in using your name, birth date, and student ID number.
                            </li>

                            <li>
                            	Once you have signed in reserve your spot by confirming you want to go on your specified trip.
                            </li>
                            --->
                            
                            <li>
                            	When confirmed you will automatically be sent a confirmation of registration containing a trip information packet pdf and a permission forms pdf
                            </li>

                            <li>
                            	Your spot on the trip is then pending until you mail a:
								<ul class="paragraphRules">
                                	<li>Business Check</li>
                                    <li>Personal Check</li>
                                    <li>Money Order</li>
                                </ul>
                                
                                <p style="padding-left:25px;">
                                	Payable out to <strong>MPD Tour Company</strong>, for the specified cost of your trip found in your confirmation email and sent to:
                                </p>

                                <p style="font-weight:bold; padding-left:25px;">
                                    #APPLICATION.MPD.name# <br />
                                    #APPLICATION.MPD.address# <br />
                                    #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#
                                </p>
                                
                            </li>

                            <li>
                            	Once the payment of the specified trip has been collected your spot is reserved.
                            </li>

                            <li>
                            	If payment is not collected within 60 days of the trip your spot is vacated.
                            </li>

                            <li>
                            	To be fully registered for your trip please return the permission forms, emailed to you when you originally signed up, 
                                back to MPD Tours signed by your host family, school, and area representative. 
                            </li>

                            <li>
                            	Once the permission forms are returned signed send an email out to MPD explaining this and you will be contacted to book your flights. 
                                Do <strong>NOT</strong>  book your own flights.
                            </li>
                            
                            <li>
                            	REFUND POLICY
                                <ul class="paragraphRules">
                                	<li>
                                    	There is a <strong>$100 cancellation fee</strong> and a <strong>$25 refund processing fee</strong> up to 30 days prior to your chosen trip. 
                                    	After 30 days, there are <strong>NO REFUNDS</strong>.
                                    </li>
                                </ul>
                            </li>

                            <li>
                                Submit permission form with all signatures to MPD Tours.
                                <ul class="paragraphRules">
                                    <li><a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a></li>
                                    <li>fax: #APPLICATION.MPD.fax#</li>
                                    <li>mail: #APPLICATION.MPD.address# - #APPLICATION.MPD.city#, #APPLICATION.MPD.state# #APPLICATION.MPD.zipCode#</li>
                                </ul>
                            </li>
                        
                		</ol> 
                    	
                        <hr width="90%" />
                        
                    	<h3 style="text-align:center;">To Book Your Airfare</h3>
                        
                        <hr width="90%" />

                        <ol class="termsConditions">

                            <li>
                            	To book your airfare, first reserve a spot on your chosen trip.
                            </li>

                            <li>
                            	Once you have reserved a confirmation email will automatically be sent containing a trip information packet pdf and a permission forms pdf
                            </li>

                            <li>
                            	Please return the signed permission form to MPD tours via scanned and emailed or through the mail. Also pay for the trip via money order or check.
                            </li>

                            <li>
                            	Please email the tour company at <a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a> explaining you have returned all of 
                                your material and include your full name, student ID number, and a phone number to best reach you.
                            </li>

                            <li>
                            	A representative from MPD will call you soon after to book your flight information.
                            </li>

                            <li>
                            	Please understand a working credit card is required at the time of the call to pay for your trip.
                            </li>
	
    					</ol>

                        <hr width="90%" />

                        <div style="padding-left:40px;">
                        	
                            <p>PS: If you want to go on other tours, you will need to do this process for <strong>each</strong> tour you want to go on.</p>

						</div>
                        
                    </td>
                </tr>
                <tr class="blueRow">
                    <td width="5%" class="tripFormTitle"><input type="checkbox" name="registeringAgreement" id="registeringAgreement" value="1" /></Td>
                    <td width="95%" class="tripFormField"><label for="registeringAgreement" style="font-weight:bold;">I've read and understand the process of registering for a tour and refund policy.</label></td>
                </tr>
                <tr>
                    <td class="tripFormTitle">
                    <input type="checkbox" name="airfareAgreement" id="airfareAgreement" value="1"/></Td>
                    <td class="tripFormField"><label for="airfareAgreement" style="font-weight:bold;">I understand that I should not book my airline ticket and that MPD will contact me to book my airfare.</label></td>
                </tr>
            </table>
                            
            <!--- Button --->
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableButton">                                       
                <tr class="blueRow">
                    <td colspan="2" align="center"><input type="image" name="submit" src="extensions/images/Next.png" /></a></td>
                </tr>
            </table>

		</cfif>
    
    </form>

</cfoutput>