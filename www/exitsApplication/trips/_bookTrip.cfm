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

    <!--- Authorize.net --->
	<cfparam name="authIsSuccess" default="0" />
	
    <cfquery name="qGetCountryList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	countryID,
            countryName 
        FROM 
        	smg_countrylist 
        ORDER BY
        	countryName
    </cfquery>
    
    <cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	ID,
            state,
            stateName
        FROM 
        	smg_states 
        ORDER BY
        	stateName
    </cfquery>

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
    
    <cfparam name="SESSION.TOUR.declinedTransactions" default="0">
    <cfset session.tour.declinedTransactions = 0>
    <cfscript>	
		// Credit Card Denied Multiple Times
		if ( SESSION.TOUR.declinedTransactions GT 1 ) {
			
			SESSION.formErrors.Add("Unfortunately your credit card has been declined multiple times, please contact your credit card issuer (number on the back) and try again in 2 hours");
			SESSION.formErrors.Add('Please refer to our <a href="/frequently-asked-questions.cfm##question23" target="_blank">FAQ</a> to understand why this transaction has been declined');
			
		}	
	
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
    
		// Set Total Cost	
		vTotalCost = qGetTourDetails.tour_price * vTotalRegistrations;
		
		// Set Total Due
		if ( qGetTourDetails.chargeType EQ 'deposit' ) {
			vTotalDue = 100;
		} else {
			vTotalDue = vTotalCost;
		}
		
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
			
			if ( NOT LEN(FORM.paymentMethodID) ) {
				SESSION.formErrors.Add("Please select a payment method");
			}

			if ( NOT LEN(FORM.nameOnCard) ) {
				SESSION.formErrors.Add("Please enter name on credit card");
			}

			if ( NOT LEN(FORM.creditCardTypeID) ) {
				SESSION.formErrors.Add("Please select a credit card type");
			}

			if ( NOT LEN(FORM.creditCardNumber) ) {
				SESSION.formErrors.Add("Please enter a valid credit card number");
			}

			if ( NOT LEN(FORM.expirationMonth) ) {
				SESSION.formErrors.Add("Please select an expiration month");
			}

			if ( NOT LEN(FORM.expirationYear) ) {
				SESSION.formErrors.Add("Please select an expiration year");
			}

			if ( LEN(FORM.expirationMonth) AND LEN(FORM.expirationYear) AND FORM.expirationMonth & '/' & FORM.expirationYear LT DateAdd('m', -1, now()) ) {
				SESSION.formErrors.Add("Credit card has expired");
			}
			
			if ( NOT LEN(FORM.ccvCode) ) {
				SESSION.formErrors.Add("Please enter a CCV code");
			}
			
			if ( NOT LEN(FORM.billingFirstName) ) {
				SESSION.formErrors.Add("Please enter a first name");
			}

			if ( NOT LEN(FORM.billingLastName) ) {
				SESSION.formErrors.Add("Please enter a last name");
			}

			if ( NOT LEN(FORM.billingAddress) ) {
				SESSION.formErrors.Add("Please enter an address");
			}

			if ( NOT LEN(FORM.billingCity) ) {
				SESSION.formErrors.Add("Please enter a city");
			}

			if ( NOT LEN(FORM.billingState) ) {
				SESSION.formErrors.Add("Please enter a state");
			}

			if ( NOT LEN(FORM.billingZipCode) ) {
				SESSION.formErrors.Add("Please enter a zip/postal code");
			}

			if ( NOT LEN(FORM.billingCountryID) ) {
				SESSION.formErrors.Add("Please select a country");
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
            
            <cfquery name="qGetSelectedCountry" datasource="#APPLICATION.DSN.Source#">
                SELECT 
                    countryID,
                    countryName 
                FROM 
                    smg_countrylist 
                WHERE
                	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.billingCountryID)#">
            </cfquery>
			
            <cfscript>
				// Remove Foreign Accent
				FORM.nameOnCard = APPLICATION.CFC.UDF.removeAccent(FORM.nameOnCard);
				// Billing Address
				FORM.billingFirstName = APPLICATION.CFC.UDF.removeAccent(FORM.billingFirstName);
				FORM.billingLastName  = APPLICATION.CFC.UDF.removeAccent(FORM.billingLastName);   
				FORM.billingCompany = APPLICATION.CFC.UDF.removeAccent(FORM.billingCompany);    
				FORM.billingAddress  = APPLICATION.CFC.UDF.removeAccent(FORM.billingAddress);   
				FORM.billingCity = APPLICATION.CFC.UDF.removeAccent(FORM.billingCity);
				FORM.billingState = APPLICATION.CFC.UDF.removeAccent(FORM.billingState);
				FORM.billingZipCode = APPLICATION.CFC.UDF.removeAccent(FORM.billingZipCode);

				// Set Receipt Description
				vReceiptDescription = "Registration for #APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)# - Student #qGetStudentInfo.firstName# #qGetStudentInfo.familyLastName# ###qGetStudentInfo.studentID#";
				// Include Number of Siblings
				if ( VAL(qGetSiblingsPendingRegistration.recordCount) ) {
					vReceiptDescription = vReceiptDescription & " and #VAL(qGetSiblingsPendingRegistration.recordCount)# host sibling(s)";
				}
				
				// Insert Payment Information (applicationPayment Table)
				getApplicationPaymentID = APPLICATION.CFC.PAYMENTGATEWAY.insertApplicationPayment( 
					applicationID=8,
					sessionInformationID=SESSION.informationID,
					foreignTable='student_tours',
					foreignID=qGetStudentPendingRegistration.ID,
					amount=FORM.totalDue,
					paymentMethodID=FORM.paymentMethodID,
					paymentMethodType=APPLICATION.CONSTANTS.paymentMethod[FORM.paymentMethodID],
					creditCardTypeID=FORM.creditCardTypeID,
					creditCardType=APPLICATION.CONSTANTS.creditCardType[FORM.creditCardTypeID],
					nameOnCard=FORM.nameOnCard,
					lastDigits=Right(FORM.creditCardNumber, 4),
					expirationMonth=FORM.expirationMonth,
					expirationYear=FORM.expirationYear,
					billingFirstName=FORM.billingFirstName,
					billingLastName=FORM.billingLastName,
					billingCompany=FORM.billingCompany,
					billingAddress=FORM.billingAddress,
					billingCity=FORM.billingCity,
					billingState=FORM.billingState,
					billingZipCode=FORM.billingZipCode,
					billingCountryID=FORM.billingCountryID
				);

				// Submit Payment - Authorize.Net
				stAuthorizeAndCapture = APPLICATION.CFC.PAYMENTGATEWAY.authorizeAndCapture(
					amount=FORM.totalDue,
					cardNumber=FORM.creditCardNumber,
					expirationDate=FORM.expirationMonth & FORM.expirationYear,
					invoiceNumber='##' & Year(now()) & '-' & qGetStudentPendingRegistration.ID,
                    description=vReceiptDescription,
					studentID='##' & qGetStudentInfo.studentID,
					email=FORM.emailAddress,
					billingFirstName=FORM.billingFirstName,
					billingLastName=FORM.billingLastName,
					billingCompany=FORM.billingCompany,
					billingAddress=FORM.billingAddress,
					billingCity=FORM.billingCity,
					billingState=FORM.billingState,
					billingZip=FORM.billingZipCode,
					billingCountry=qGetSelectedCountry.countryName
				);

				// Payment Successfully Submitted
				if (stAuthorizeAndCapture.responseCode.response EQ "Approved") {
					
					// Payment Approved
					authIsSuccess = true;
					
					vGetCustomerProfileID = 0;
					
					// Get/Create Customer Profile
					try {
					
						// get Authorize.net Customer Profile ID
						vGetCustomerProfileID = APPLICATION.CFC.PAYMENTGATEWAY.getCustomerProfileID(customerID=qGetStudentInfo.studentID, companyID=qGetStudentInfo.companyID);
					
					} catch(Any excpt) {
						// Dev Account does not create a customer profile
					}
					
					
					// expiration month must be in the MM format
					if (LEN(FORM.expirationMonth) EQ 1) {
						vExpirationDate = FORM.expirationYear&'-0'&FORM.expirationMonth;
					} else {
						vExpirationDate = FORM.expirationYear&'-'&FORM.expirationMonth;
					}

					// Check if we have a registered authorizeNetProfilePaymentID
					getAuthorizeNetPaymentID = APPLICATION.CFC.PAYMENTGATEWAY.getApplicationPaymentInfo(
						applicationID=8,
						foreignTable='student_tours',
						foreignID=qGetStudentPendingRegistration.ID,
						creditCardTypeID=FORM.creditCardTypeID,
						nameOnCard=FORM.nameOnCard,
						lastDigits=Right(FORM.creditCardNumber, 4),
						expirationMonth=FORM.expirationMonth,
						expirationYear=FORM.expirationYear					
					).authorizeNetPaymentID;

					// insert Payment Profile (Authorize.net) / insert customer_payment
					try {

						// Create a Payment Profile for a registered customer
						APPLICATION.CFC.PAYMENTGATEWAY.createCustomerPaymentProfile(
							customerID = qGetStudentInfo.studentID, 												   
							customerProfileID = vGetCustomerProfileID,											   
							firstName = FORM.billingFirstName,												   
							lastName = FORM.billingLastName,	
							company = FORM.billingCompany,
							address = FORM.billingAddress,
							city = FORM.billingCity,
							state = FORM.billingState,
							zip = FORM.billingZipCode,
							country = qGetSelectedCountry.countryName,
							cardNumber = FORM.creditCardNumber,
							expirationDate = vExpirationDate,
							cardCode = FORM.ccvCode,
							// ApplicationPayment Table
							applicationPaymentID=getApplicationPaymentID,
							authorizeNetPaymentID=VAL(getAuthorizeNetPaymentID)
						);				

					} catch(Any excpt) {
						// Credit card might be already registered
					}
					// End CC authorized -  insert Payment Profile (Authorize.net) / insert customer_payment
					
					// Set Page Message
					SESSION.pageMessages.Add("Payment successfully submitted. " & stAuthorizeAndCapture.responseReasonText.response);
					
				// There was a problem processing the payment
				} else {
					
					// Payment Not Approved
					authIsSuccess = false;

					// Count Declined Transactions
					APPLICATION.CFC.SESSION.setDeclinedTransactions();					

					// Set Error Message
					SESSION.formErrors.Add(stAuthorizeAndCapture.responseReasonText.response);
					
					// Credit Card Declined Message
					SESSION.formErrors.Add("If you are using an International Credit Card please make sure you call your credit card issuer in advance to let them know about this charge");
				}

				// Update Authorize.net fields on the payment table
				APPLICATION.CFC.paymentGateway.updateApplicationPayment(
					ID=getApplicationPaymentID,						   
					authTransactionID=stAuthorizeAndCapture.transactionID.response,						   
					authApprovalCode=stAuthorizeAndCapture.approvalCode.response,
					authResponseCode=stAuthorizeAndCapture.responseCode.response,
					authResponseReason=stAuthorizeAndCapture.responseReasonText.response,
					authIsSuccess=authIsSuccess
				);
				
				// Store Application Payment ID in the SESSION
				APPLICATION.CFC.SESSION.setTripSessionVariables(applicationPaymentID=getApplicationPaymentID);
			</cfscript>
			
            <!--- Payment Approved --->
            <cfif authIsSuccess>		
                
                <!--- Student - Record Payment as Received / Activate Record --->
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE
                    	student_tours
					SET
                    	paid = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						<cfif qGetTourDetails.chargeType EQ 'deposit'>
                            dateDepositPaid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfelse>
                            dateFullyPaid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        </cfif>
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
                            studentTourID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentPendingRegistration.ID#">,
                            paid = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
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
                    location("#CGI.SCRIPT_NAME#?action=confirmation", "no");
                </cfscript>			
                
            </cfif> <!--- Payment Approved --->
            
		</cfif> <!--- NOT SESSION.formErrors.length() --->
	
    <cfelse>
    	
        <cfscript>
			// Set Total Due
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

<script type="text/javascript">
	// Display Credit Card and State Fields
	$(document).ready(function() {
		
		// Display Current Credit Image		
		displayCreditCard();
		
		// Display Correct State Field	
		displayStateField();
		
	});

	// Display Credit Card Image
	var displayCreditCard = function() {
	
		getCCSelected = $("#creditCardTypeID").val();	
		
		$("#displayCardImage").removeClass();
		$("#displayCardImage").addClass("card" + getCCSelected); 
	
	}

	// Slide down steateform field div
	var displayStateField = function(  usFieldClass, nonUsFieldClass) { 
		
		// Get Current Country Value
		getCountrySelected = $("#billingCountryID").val();
	
		if ( getCountrySelected == 232 ) {
			// US Selected	
			$("#nonUsStateField").slideUp("fast");
			$("#usStateField").slideDown("slow");
			// clear the other value
			$(".nonUsBillingState").val("");
		} else {
			// Non Us Selected
			$("#usStateField").slideUp("fast");
			$("#nonUsStateField").slideDown("slow");	
			// clear the other value
			$(".usBillingState").val("");
		}
	
	}
	
	// JQuery Modal
	var confirmPayment = function() { 
			
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
	
		$( "#dialog-paymentConfirmation-confirm" ).dialog({
			resizable: false,
			height:350,
			width:400,
			modal: true,
			buttons: {
				"Submit Payment": function() {
					$( this ).dialog( "close" );
					// Submit Form
					$("#processPaymentForm").submit();
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});
			
	}
</script>

<cfoutput>

	<!--- Modal Dialogs --->
    
    <!--- Payment Confirmation - Modal Dialog Box --->
    <div id="dialog-paymentConfirmation-confirm" title="Submit Payment" class="displayNone" style="font-size:1em;"> 
        <p>
        	<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 0 0;"></span>
        	Your credit card will be charged a total of <strong>#LSCurrencyFormat(FORM.totalDue)#</strong> for this trip
        </p> 
        <p>
        	<strong>Processing your credit card might take up to a minute, please DO NOT resubmit this page</strong>
		</p>
    </div> 
    
	<!--- End of Modal Dialogs --->

	<!--- Include Trip Header --->
    <cfinclude template="_breadCrumb.cfm">
    
    <form name="processPaymentForm" id="processPaymentForm" action="#CGI.SCRIPT_NAME#?action=bookTrip" method="post">
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
                <td class="tripFormTitle">Dates:</td>
                <td class="tripFormField">#qGetTourDetails.tour_date# - #qGetTourDetails.tour_length#</td>
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
            <cfif qGetTourDetails.chargeType EQ 'deposit'>
                <tr>
                    <td class="tripFormTitle">Total Cost:</td>
                    <td class="tripFormField">
                        #LSCurrencyFormat(vTotalCost)#
                        <em class="tripNotesRight">#LSCurrencyFormat(qGetTourDetails.tour_price)# Per person - Does not include your round trip airline ticket</em>
                    </td>
                </tr>
                <tr class="blueRow">
                    <td class="tripFormTitle">Total Due Now:</td>
                    <td class="tripFormField">
                        <cfif qGetTourDetails.chargeType EQ 'deposit'>
                            <span class="totalDue">#LSCurrencyFormat(FORM.totalDue)#</span>
                            <em class="tripNotesRight">*** Deposit Only ***</em>
                        <cfelse>
                            <span class="totalDue">#LSCurrencyFormat(FORM.totalDue)#</span>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td class="tripFormTitle">Remaining Balance:</td>
                    <td class="tripFormField">
                        #LSCurrencyFormat(vTotalCost - FORM.totalDue)#
                        <em class="tripNotesRight">
                            Remaining balance will be charged to the same credit card 60 days prior to the trip. If credit card used changes please notify MPD Tours America with new information
                        </em>
                    </td>
                </tr>
			<cfelse>
                <tr>
                    <td class="tripFormTitle">Total Cost:</td>
                    <td class="tripFormField">
                        <span class="totalDue">#LSCurrencyFormat(vTotalCost)#</span>
                        <em class="tripNotesRight">#LSCurrencyFormat(qGetTourDetails.tour_price)# Per person - Does not include your round trip airline ticket</em>
                    </td>
                </tr>
            </cfif>
        </table>                
        
        <!--- Trip Not Full --->
        <cfif NOT VAL(vIsTripFull) AND SESSION.TOUR.declinedTransactions LT 2>
             
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
             
                
            <!--- Credit Card Information --->
            <h3 class="tripSectionTitle">Credit Card Information</h3>
            <em class="tripTitleNotes">Enter information for a Credit Card. Your session is <a href="frequently-asked-questions.cfm" target="_blank">secure</a>.</em>
    
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">    
                <tr class="blueRow">
                    <td class="tripFormTitle" width="30%">Credit Cards Accepted:</td>
                    <td class="tripFormField" width="70%"><div class="creditCardAccepted">&nbsp;</div></td>
                </tr>  
                <tr>
                    <td class="tripFormTitle">Name on Credit Card <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="nameOnCard" id="nameOnCard" value="#FORM.nameOnCard#" class="largeField" maxlength="100" /></td>
                </tr>
                <tr class="blueRow">
                    <td class="tripFormTitle">Credit Card Type <span class="required">*</span></td>
                    <td class="tripFormField">
                        <select name="creditCardTypeID" id="creditCardTypeID" class="mediumField" onchange="displayCreditCard();">
                            <option value=""></option>
                            <cfloop index="i" from="1" to="#ArrayLen(APPLICATION.CONSTANTS.creditCardType)#">
                                <option value="#i#" <cfif i EQ FORM.creditCardTypeID> selected="selected" </cfif> >#APPLICATION.CONSTANTS.creditCardType[i]#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="tripFormTitle">Credit Card Number <span class="required">*</span></td>
                    <td class="tripFormField">
                        <input type="text" name="creditCardNumber" id="creditCardNumber" value="#FORM.creditCardNumber#" class="mediumField" maxlength="16" />
                        <em class="tripNotesRight">This will be a 15 or 16 digit number on the front of the card. No spaces or dashes</em>
                    </td>
                </tr>
                <tr class="blueRow">
                    <td class="tripFormTitle">Expiration Date <span class="required">*</span></td>
                    <td class="tripFormField">
                        <select name="expirationMonth" id="expirationMonth" class="smallFieldNoBlock">
                            <option value=""></option>
                            <cfloop from="1" to="12" index="i">
                                <option value="#i#" <cfif FORM.expirationMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                            </cfloop>
                        </select>
                        /
                        <select name="expirationYear" id="expirationYear" class="smallFieldNoBlock">
                            <option value=""></option>
                            <cfloop from="#Year(now())#" to="#Year(now()) + 16#" index="i">
                                <option value="#i#" <cfif FORM.expirationYear EQ i> selected="selected" </cfif> >#i#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="tripFormTitle">CCV/CID Code <span class="required">*</span></td>
                    <td class="tripFormField">
                        <input type="text" name="ccvCode" id="ccvCode" value="#FORM.ccvCode#" class="xSmallField" maxlength="4" />
                        <div class="creditCardImageDiv">
                            <div id="displayCardImage" class="card1"></div>
                        </div>
                        <em class="tripNotesRight">3 or 4 digit code - see credit card image</em>
                    </td>
                </tr>
                <tr class="blueRow">
                    <td>&nbsp;</td>
                    <td><span class="required">* Required Fields</span></td>
                </tr>  
            </table>	
            
            
            <!--- Billing Address --->    
            <h3 class="tripSectionTitle">Billing Address</h3>                
            
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">                    
                <tr class="blueRow">
                    <td class="tripFormTitle" width="30%">First Name <span class="required">*</span></td>
                    <td class="tripFormField" width="70%"><input type="text" name="billingFirstName" id="billingFirstName" value="#FORM.billingFirstName#" class="largeField" maxlength="100" /></td>
                </tr>
                <tr>
                    <td class="tripFormTitle">Last Name <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="billingLastName" id="billingLastName" value="#FORM.billingLastName#" class="largeField" maxlength="100" /></td>
                </tr>
                <tr class="blueRow">
                    <td class="tripFormTitle">Company Name</td>
                    <td class="tripFormField"><input type="text" name="billingCompany" id="billingCompany" value="#FORM.billingCompany#" class="largeField" maxlength="100" /></td>
                </tr>
                <tr>
                    <td class="tripFormTitle">Country <span class="required">*</span></td>
                    <td class="tripFormField">
                        <select name="billingCountryID" id="billingCountryID" class="largeField" onchange="displayStateField();">
                            <option value=""></option>
                            <cfloop query="qGetCountryList">
                                <option value="#qGetCountryList.countryID#" <cfif FORM.billingCountryID EQ qGetCountryList.countryID> selected="selected" </cfif> >#qGetCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr class="blueRow">
                    <td class="tripFormTitle">Address <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="billingAddress" id="billingAddress" value="#FORM.billingAddress#" class="largeField" maxlength="100" /></td>
                </tr>
                <tr>
                    <td class="tripFormTitle">City <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="billingCity" id="billingCity" value="#FORM.billingCity#" class="largeField" maxlength="100" /></td>
                </tr>
                <!--- US State --->
                <tr id="usStateField" class="blueRow field displayNone">
                    <td class="tripFormTitle">State/Province <span class="required">*</span></td>
                    <td class="tripFormField">
                        <select name="billingState" id="billingState" class="mediumField usBillingState">
                            <option value=""></option>
                            <cfloop query="qGetStateList">
                                <option value="#qGetStateList.state#" <cfif FORM.billingState EQ qGetStateList.state> selected="selected" </cfif> >#qGetStateList.stateName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <!--- Non US State --->
                <tr id="nonUsStateField" class="blueRow field displayNone">
                    <td class="tripFormTitle">State/Province <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="billingState" id="billingState" value="#FORM.billingState#" class="largeField nonUsBillingState" maxlength="100" /></td>
                </tr>
                <tr>
                    <td class="tripFormTitle">Zip/Postal Code <span class="required">*</span></td>
                    <td class="tripFormField"><input type="text" name="billingZipCode" id="billingZipCode" value="#FORM.billingZipCode#" class="smallField" maxlength="20" /></td>
                </tr>
                <tr class="blueRow">
                    <td>&nbsp;</td>
                    <td><span class="required">* Required Fields</span></td>
                </tr>  
            </table>    
            
            
            <!--- Terms and Conditions --->    
            <h3 class="tripSectionTitle">Terms and Conditions</h3>                
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="tripTableBorder">                    
                <tr>
                    <td align="center" colspan="2">
                        <h3> 
                            Please carefully read the steps below explaining the enrollment process.
                            <hr width=80% />
                        </h3>
                    </td>
                </tr>	
                <tr>
                    <td colspan="2">
                        <ol style="margin-top:0px;">
                            <li>
                            	REFUND POLICY
                                <ul class="paragraphRules">
                                	<li>There is a $100 cancellation fee and a $25 refund processing fee up to 30 days prior to your chosen trip. After 30 days, there are <strong>NO REFUNDS</strong>.</li>
                                </ul>
                            </li>
                            
                            <li>
                                Submit permission form with all signatures to MPD Tours.
                                <ul class="paragraphRules">
                                    <li>#APPLICATION.MPD.email#</li>
                                    <li>fax: +1 718 439 8565</li>
                                    <li>mail: 9101 Shore Road, ##203 - Brooklyn, NY 11209</li>
                                </ul>
                            </li>
                            
                            <li>
                                MPD will contact you once your permission form have been received to book your flights. Do NOT book your own flights. 
                            </li>
                        </ol>
                        
                        <ul class="paragraphRules"><li><font size=-1>PS: If you want to go on other tours, you will need to do this process for <em><strong>each</strong></em> tour you want to go on.</font></li></ul>
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
                    <td colspan="2" align="center"><a href="javascript:confirmPayment();"><img src="extensions/images/Next.png" border="0" /></a></td>
                </tr>
            </table>

		</cfif>
    
    </form>

</cfoutput>