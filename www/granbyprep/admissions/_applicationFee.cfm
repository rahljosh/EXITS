<!--- ------------------------------------------------------------------------- ----
	
	File:		_applicationFee.cfm
	Author:		Marcus Melo
	Date:		July 07, 2010
	Desc:		Process Application Fee

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">
    <cfparam name="includeHeader" default="1">
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <!--- Student ID --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
	<!--- Credit Card Information --->
    <cfparam name="FORM.paymentMethodID" default="1">
    <cfparam name="FORM.nameOnCard" default="">
	<cfparam name="FORM.creditCardTypeID" default="">
	<cfparam name="FORM.creditCardNumber" default="">
	<cfparam name="FORM.expirationMonth" default="">
    <cfparam name="FORM.expirationYear" default="">
    <cfparam name="FORM.ccvCode" default="">
	<!--- Billing Address --->
    <cfparam name="FORM.billingFirstName" default="">    
    <cfparam name="FORM.billingLastName" default="">    
    <cfparam name="FORM.billingCompany" default="">    
    <cfparam name="FORM.billingAddress" default="">    
    <cfparam name="FORM.billingCity" default="">
    <cfparam name="FORM.billingState" default="">
    <cfparam name="FORM.billingZipCode" default="">
    <cfparam name="FORM.billingCountryID" default="">
    <!--- Payment Agreement --->
    <cfparam name="FORM.paymentAgreement" default="">
    <!--- Authorize.net --->
	<cfparam name="authIsSuccess" default="0" />
    
    <cfscript>
		// Gets Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Gets payment information
		qGetPaymentInfo = APPLICATION.CFC.paymentGateway.getApplicationPaymentByID(ID=qGetStudentInfo.applicationPaymentID);

		// Check if Application Fee has been paid
		if ( VAL(qGetStudentInfo.applicationPaymentID) ) {	
			// Application fee has been paid - display print page
			printApplication = 1;
		}

		// Gets a List of States
		qGetStates = APPLICATION.CFC.LOOKUPTABLES.getState();
		
		// Gets a List of Countries
		qGetCountries = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Gets Application Fee
		getApplicationFee = VAL(APPLICATION.CFC.ONLINEAPP.getApplicationFee(studentID=FORM.studentID));
		
		// Gets Application Fee Policy Text
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="applicationFeePolicy");

		// Declare Application Fee Policy
		savecontent variable="applicationFeePolicy" {
			writeOutput(qGetContent.content);
		}    
		
		// Replace Variables 
		applicationFeePolicy = ReplaceNoCase(applicationFeePolicy,"{applicationFee}",dollarFormat(getApplicationFee),"all");
		
		// There is not a valid application fee.
		if ( NOT VAL(getApplicationFee) ) {
			SESSION.formErrors.Add('Your application is incomplete. Please complete your application first before submitting your application fee payment');
		}
		
		// FORM Submitted
		if ( FORM.submitted ) {

			// FORM Validation
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

			if ( NOT LEN(FORM.paymentAgreement) ) {
				SESSION.formErrors.Add("Please accept our Terms and Conditions");
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert Payment Information
				paymentID = APPLICATION.CFC.PAYMENTGATEWAY.insertApplicationPayment( 
					applicationID=1,
					sessionInformationID=SESSION.informationID,
					foreignTable='student',
					foreignID=FORM.studentID,
					amount=getApplicationFee,
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
					amount=getApplicationFee,
					cardNumber=FORM.creditCardNumber,
					expirationDate=FORM.expirationMonth & FORM.expirationYear,
					invoiceNumber='PaymentID-' & paymentID,
                    description='Application fee for ' & qGetStudentInfo.firstName & ' ' & qGetStudentInfo.lastName & ' ' & '##' & Year(now()) & '-' & FORM.studentID,
					studentID=FORM.studentID,
					email=qGetStudentInfo.email,
					billingFirstName=FORM.billingFirstName,
					billingLastName=FORM.billingLastName,
					billingCompany=FORM.billingCompany,
					billingAddress=FORM.billingAddress,
					billingCity=FORM.billingCity,
					billingState=FORM.billingState,
					billingZip=FORM.billingZipCode,
					billingCountry=APPLICATION.CFC.lookUpTables.getCountryByID(ID=FORM.billingCountryID).name
				);
				
				// Payment Successfully Submitted
				if (stAuthorizeAndCapture.responseCode.response EQ "Approved") {
					
					// Payment Approved
					authIsSuccess = true;
					
					// Payment Successfully Submitted - Update Student Table
					APPLICATION.CFC.STUDENT.updateApplicationPaymentID(ID=FORM.studentID, applicationPaymentID=paymentID);
					
					// Set Page Message
					SESSION.pageMessages.Add("Payment successfully submitted. " & stAuthorizeAndCapture.responseReasonText.response);
					
				// There was a problem processing the payment
				} else {
					
					// Payment Not Approved
					authIsSuccess = false;

					// Set Error Message
					SESSION.formErrors.Add(stAuthorizeAndCapture.responseReasonText.response);
				}

				// Update Authorize.net fields on the payment table
				APPLICATION.CFC.paymentGateway.updateApplicationPayment(
					ID=paymentID,						   
					authTransactionID=stAuthorizeAndCapture.transactionID.response,						   
					authApprovalCode=stAuthorizeAndCapture.approvalCode.response,
					authResponseCode=stAuthorizeAndCapture.responseCode.response,
					authResponseReason=stAuthorizeAndCapture.responseReasonText.response,
					authIsSuccess=authIsSuccess
				);

				// Email Receipt to Student
				// Using Authorize.net Receipt
				
				// Check if Payment Approved
				if ( authIsSuccess ) {
					// Reload page with updated information
					location("#CGI.SCRIPT_NAME#?action=applicationFee", "no");
				}

			}
			
		}
    </cfscript>
    
</cfsilent>


<cfoutput>

<!--- Page Header --->
<cfif includeHeader>
    <gui:pageHeader
        headerType="application"
    />
</cfif>
	
	<script type="text/javascript">
        // JQuery Validator
        $().ready(function() {
        
            var container = $('div.errorContainer');
            // validate the form when it is submitted
            var validator = $("##applicationFeeForm").validate({
                errorContainer: container,
                errorLabelContainer: $("ol", container),
                wrapper: 'li',
                meta: "validate"
            });
        
        });
    </script>
    
    <cfif includeHeader>
		<!--- Side Bar --->
        <div class="rightSideContent ui-corner-all">
    <cfelse>
		<!--- Print Version There is no Float - Application Body --->
        <div class="form-container">
	</cfif>
        
        <div class="insideBar">

			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="section"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="section"
                />

            <!---  Our jQuery error container --->
            <div class="errorContainer">
                <p><em>Oops... the following errors were encountered:</em></p>
                
                <ol>
                    <li><label for="paymentMethodID" class="error">Please select a payment method</label></li>
                    <li><label for="nameOnCard" class="error">Please enter name on credit card</label></li>  
                    <li><label for="creditCardTypeID" class="error">Please select a credit card type</label></li>
                    <li><label for="creditCardNumber" class="error">Please enter a valid credit card number</label></li> 
                    <li><label for="expirationMonth" class="error">Please select an expiration month</label></li>
                    <li><label for="expirationYear" class="error">Please select an expiration year</label></li>
                    <li><label for="ccvCode" class="error">Please enter a CCV code</label></li>
                    <li><label for="billingFirstName" class="error">Please enter a first name</label></li>
                    <li><label for="billingLastName" class="error">Please enter a last name</label></li> 
                    <li><label for="billingAddress" class="error">Please enter an address</label></li>
                    <li><label for="billingCity" class="error">Please enter a city</label></li>
                    <li><label for="billingState" class="error">Please enter a state</label></li>
                    <li><label for="billingZipCode" class="error">Please enter a zip/postal code</label></li>
                    <li><label for="billingCountryID" class="error">Please select a country</label></li>
                    <li><label for="paymentAgreement" class="error">Please accept our Terms and Conditions</label></li>
                </ol>
                
                <p>Data has <strong>not</strong> been saved.</p>
            </div>

			<!--- Application Body --->
            <div class="form-container">

                <cfif VAL(getApplicationFee)>  
                    <form id="applicationFeeForm" action="#CGI.SCRIPT_NAME#?action=applicationFee" method="post">
                    <input type="hidden" name="submitted" value="1" />
					
                    <cfif printApplication>
                    	<p class="legend"><strong>Note:</strong> Application Fee has been paid. Please see your payment information below.</p>
					<cfelse>
                        <p class="legend"><strong>Note:</strong> fields are marked with an asterisk (<em>*</em>)</p>
					</cfif>
                    
                    <!--- Application Fee --->
                    <fieldset>
                       
                        <legend>Application Fee</legend>
						
                        <!--- Application Fee --->
                        <div class="field controlset">
                            <span class="label">Application Fee <em>*</em></span>
							<cfif printApplication>
                                <div class="printField">#dollarFormat(getApplicationFee)# &nbsp;</div>
                            <cfelse>
                                <strong>#dollarFormat(getApplicationFee)#</strong>
                            </cfif>
                        </div>
						
                        <!--- Payment Information --->
                        <cfif printApplication>
                            <div class="field controlset">
                                <span class="label">Payment Submitted <em>*</em></span>
                                <div class="printField">#DateFormat(qGetPaymentInfo.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetPaymentInfo.dateCreated, 'hh:mm:ss tt')# EST</div>
                            </div>
                            
                            <div class="field controlset">
                                <span class="label">Transaction ID <em>*</em></span>
                                <div class="printField">#qGetPaymentInfo.authTransactionID# &nbsp;</div>
                            </div>

                            <div class="field controlset">
                                <span class="label">Authorization Code <em>*</em></span>
                                <div class="printField">#qGetPaymentInfo.authApprovalCode# &nbsp;</div>
                            </div>
                        </cfif>
                        
                    </fieldset>                

                    
                    <!--- Payment Information --->
                    <fieldset>
                       
                        <legend>Payment Method</legend>
						
                        <!--- Payment Information --->
                        <div class="field controlset">
                            <span class="label">Payment Method <em>*</em></span>
							<cfif printApplication>
                                <div class="printField">#APPLICATION.CONSTANTS.paymentMethod[qGetPaymentInfo.paymentMethodID]# &nbsp;</div>
                            <cfelse>
                                <cfloop index="i" from="1" to="#ArrayLen(APPLICATION.CONSTANTS.paymentMethod)#">
                                    <input type="radio" name="paymentMethodID" id="#APPLICATION.CONSTANTS.paymentMethod[i]#" value="#i#" class="{validate:{required:true}}" <cfif i EQ FORM.paymentMethodID> checked="checked" </cfif> /> 
                                    <label for="#APPLICATION.CONSTANTS.paymentMethod[i]#">#APPLICATION.CONSTANTS.paymentMethod[i]#</label>
                                </cfloop>
                            </cfif>
                        </div>
                
                    </fieldset>                
                    
                    <!--- Credit Card Information --->
                    <fieldset>
                       
                        <legend>Credit Card Information</legend>
    					
                        <cfif NOT printApplication>
	                        <p class="note">Enter information for a Credit Card. Your session is <a href="#cgi.SCRIPT_NAME#?action=privacy" target="_blank">secure</a>.</p>
                        </cfif>

                        <!--- Name on Credit Card --->    
                        <div class="field">
                            <label for="nameOnCard">Name on Credit Card <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.nameOnCard# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="nameOnCard" id="nameOnCard" value="#FORM.nameOnCard#" class="largeField {validate:{required:true}}" maxlength="100" />
                            </cfif>
                        </div>
  						                        
                        <!--- Accepted Credit Card Logos --->
                        <cfif NOT printApplication>
                            <div class="field controlset">
                                <span class="label">&nbsp;</span>
                                <div class="creditCardAccepted">&nbsp;</div>
                            </div>
                		</cfif>
                        
                        <!--- Credit Card Type --->
                        <div class="field controlset">
                            <span class="label">Credit Card Type <em>*</em></span>
							<cfif printApplication>
                                <div class="printField">#APPLICATION.CONSTANTS.creditCardType[qGetPaymentInfo.creditCardTypeID]# &nbsp;</div>
                            <cfelse>
                                <select name="creditCardTypeID" id="creditCardTypeID" class="mediumField {validate:{required:true}}" onchange="displayCreditCard(this.value);">
                                    <option value=""></option>
                                    <cfloop index="i" from="1" to="#ArrayLen(APPLICATION.CONSTANTS.creditCardType)#">
                                        <option value="#i#" <cfif i EQ FORM.creditCardTypeID> selected="selected" </cfif> >#APPLICATION.CONSTANTS.creditCardType[i]#</option>
                                    </cfloop>
                                </select>
                            </cfif>
                        </div>
                
                		<!--- Credit Card Number --->
                        <div class="field">
                            <label for="creditCardNumber">Credit Card Number <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">XXXX#qGetPaymentInfo.lastDigits# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="creditCardNumber" id="creditCardNumber" value="#FORM.creditCardNumber#" class="largeField {validate:{required:true,creditcard:true}}" maxlength="20" />
                                <p class="note">no spaces or dashes</p>
                            </cfif>
                        </div>
                
                		<!--- Credit Card Expiration Date --->
                        <div class="field">
                            <label for="expirationMonth">Expiration Date <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#MonthAsString(qGetPaymentInfo.expirationMonth)# / #qGetPaymentInfo.expirationYear# &nbsp;</div>
                            <cfelse>
                                <select name="expirationMonth" id="expirationMonth" class="smallField {validate:{required:true}}">
                                    <option value=""></option>
                                    <cfloop from="1" to="12" index="i">
                                        <option value="#i#" <cfif FORM.expirationMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                                    </cfloop>
                                </select>
                                /
                                <select name="expirationYear" id="expirationYear" class="xSmallField {validate:{required:true}}">
                                    <option value=""></option>
                                    <cfloop from="#Year(now())#" to="#Year(now()) + 8#" index="i">
                                        <option value="#i#" <cfif FORM.expirationYear EQ i> selected="selected" </cfif> >#i#</option>
                                    </cfloop>
                                </select>
                            </cfif>
                        </div>
                		
                        <!--- Credit Card CCV/CID Code --->
                        <cfif NOT printApplication>
                            <div class="field">
                                <label for="ccvCode">CCV/CID Code <em>*</em></label> 
                                <input type="text" name="ccvCode" id="ccvCode" value="#FORM.ccvCode#" class="xSmallField {validate:{required:true}}" maxlength="4" />
                                <p class="note">See credit card image</p>
                            </div>
                      	</cfif>
                        
                        <cfif NOT printApplication>
                            <div class="creditCardImageDiv">
                                <div id="displayCardImage" class="card1"></div>
                            </div>
						</cfif>
                                                
                    </fieldset>
                    
                    <!--- Billing Address --->
                    <fieldset>
                       
                        <legend>Billing Address</legend>
                        
                        <!--- First Name --->    
                        <div class="field">
                            <label for="billingFirstName">First Name <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.billingFirstName# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="billingFirstName" id="billingFirstName" value="#FORM.billingFirstName#" class="largeField {validate:{required:true}}" maxlength="100" />
                            </cfif>
                        </div>
                		
                        <!--- Last Name --->
                        <div class="field">
                            <label for="billingLastName">Last Name <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.billingLastName# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="billingLastName" id="billingLastName" value="#FORM.billingLastName#" class="largeField {validate:{required:true}}" maxlength="100" />
                            </cfif>
                        </div>
    					
                        <!--- Company Name --->
                        <div class="field">
                            <label for="billingCompany">Company Name </label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.billingCompany# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="billingCompany" id="billingCompany" value="#FORM.billingCompany#" class="largeField" maxlength="100" />
                            </cfif>
                        </div>
						
                        <!--- Country --->
                        <div class="field">
                            <label for="billingCountryID">Country <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#APPLICATION.CFC.LOOKUPTABLES.getCountryByID(ID=qGetPaymentInfo.billingCountryID).name# &nbsp;</div>
                            <cfelse>
                                <select name="billingCountryID" id="billingCountryID" class="mediumField {validate:{required:true}}" onchange="displayStateField(this.value, 'usStateField', 'nonUsStateField', 'usBillingState', 'nonUsBillingState');">
                                    <option value=""></option> <!--- [select a country] ---->
                                    <cfloop query="qGetCountries">
                                        <option value="#qGetCountries.ID#" <cfif FORM.billingCountryID EQ qGetCountries.ID> selected="selected" </cfif> >#qGetCountries.name#</option>
                                    </cfloop>
                                </select>
                            </cfif>
                        </div>
    					
                        <!--- Address --->
                        <div class="field">
                            <label for="billingAddress">Address <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.billingAddress# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="billingAddress" id="billingAddress" value="#FORM.billingAddress#" class="largeField {validate:{required:true}}" maxlength="100" />
                            </cfif>
                        </div>
    					
                    	<!--- City --->
                        <div class="field">
                            <label for="billingCity">City <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.billingCity# &nbsp;</div>
                            <cfelse>
	                            <input type="text" name="billingCity" id="billingCity" value="#FORM.billingCity#" class="mediumField {validate:{required:true}}" maxlength="100" />
                            </cfif>
                        </div>
						
                        <cfif printApplication>
							<!--- State/Province --->
                            <div class="field">
                                <label for="billingState">State/Province <em>*</em></label> 
                        		<div class="printField">#qGetPaymentInfo.billingState# &nbsp;</div>
                            </div>
						<cfelse>
							<!--- Non US State --->
                            <div class="field hiddenField" id="nonUsStateField">
                                <label for="billingState">State/Province <em>*</em></label> 
                                <input type="text" name="billingState" id="billingState" value="#FORM.billingState#" class="mediumField nonUsBillingState" maxlength="100" />
                            </div>
    
                            <!--- US State --->
                            <div class="field hiddenField" id="usStateField">
                                <label for="billingState">State/Province <em>*</em></label> 
                                <select name="billingState" id="billingState" class="mediumField usBillingState">
                                    <option value=""></option> <!--- [select a state] ---->
                                    <cfloop query="qGetStates">
                                        <option value="#qGetStates.code#" <cfif FORM.billingState EQ qGetStates.code> selected="selected" </cfif> >#qGetStates.name#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </cfif>
                        
                        <!--- Zip/Postal Code --->
                        <div class="field">
                            <label for="billingZipCode">Zip/Postal Code <em>*</em></label> 
							<cfif printApplication>
                                <div class="printField">#qGetPaymentInfo.billingZipCode# &nbsp;</div>
                            <cfelse>
                                <input type="text" name="billingZipCode" id="billingZipCode" value="#FORM.billingZipCode#" class="smallField {validate:{required:true}}" maxlength="20" />
                            </cfif>
                        </div>
    			
                    </fieldset>
    				                    
                    <cfif NOT printApplication>
                        <fieldset>
                                               
                            <div class="controlset">
                                <span class="label"><em>*</em></span>
                                <div class="field">
                                    <input type="checkbox" name="paymentAgreement" id="paymentAgreement" value="1" class="{validate:{required:true}}" /> 
                                    &nbsp; 
                                    <label for="paymentAgreement">
                                        I Agree with the Terms and Conditions listed below.
                                    </label>
                                </div>
                            </div>
    
                            <!--- Policy --->
                            <div class="field">
                                <span class="label">&nbsp;</span>  
                                <textarea name="granbyPolicy" id="granbyPolicy" class="largeTextFieldPolicy" readonly="readonly">#applicationFeePolicy#</textarea>                                    	
                            </div>
    
                        </fieldset>

						<!--- Save Button --->
                        <div class="buttonrow">
                            <input type="submit" value="Submit" class="button ui-corner-top" />
                        </div>
					</cfif>

                    </form>
				
                </cfif>                    
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<cfif includeHeader>
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
</cfif>

</cfoutput>

<script type="text/javascript">
	// Display Credit Card and State Fields
	$(document).ready(function() {
		
		// Get Current Credit Card Value
		//getSelected = $("input[@name='creditCardTypeID']:checked").val(); // CheckBox
		getCCSelected = $("#creditCardTypeID").val();		
		displayCreditCard(getCCSelected);
		
		// Get Current Country Value
		getCountrySelected = $("#billingCountryID").val();
		displayStateField(getCountrySelected, 'usStateField', 'nonUsStateField', 'usBillingState', 'nonUsBillingState');
	});
</script>
