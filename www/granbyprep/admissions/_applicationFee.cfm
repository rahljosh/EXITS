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

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <!--- Student ID --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
    <cfparam name="FORM.paymentAgreement" default="">
	<!--- Credit Card Information --->
    <cfparam name="FORM.paymentMethodID" default="">
    <cfparam name="FORM.nameOnCreditCard" default="">
	<cfparam name="FORM.creditCardType" default="">
	<cfparam name="FORM.creditCardNumber" default="">
	<cfparam name="FORM.expirationMonth" default="">
    <cfparam name="FORM.expirationYear" default="">
    <cfparam name="FORM.ccvCode" default="">
	<!--- Billing Address --->
    <cfparam name="FORM.billingFirstName" default="">    
    <cfparam name="FORM.billingLastName" default="">    
    <cfparam name="FORM.billingCompany" default="">    
    <cfparam name="FORM.billingAddress" default="">    
    <cfparam name="FORM.billingAddress2" default="">
    <cfparam name="FORM.billingApt" default="">
    <cfparam name="FORM.billingCity" default="">
    <cfparam name="FORM.billingState" default="">
    <cfparam name="FORM.billingZipCode" default="">
    <cfparam name="FORM.billingCountryID" default="">
       
    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();
		
		// Get Application Fee
		getApplicationFee = APPLICATION.CFC.ONLINEAPP.getApplicationFee(studentID=FORM.studentID);
		
		// Get Policy
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="applicationFeePolicy");

		// Declare Application Fee Policy
		savecontent variable="applicationFeePolicy" {
			WriteOutput(qGetContent.content);
		}    
		
		// Replace Variables 
		applicationFeePolicy = ReplaceNoCase(applicationFeePolicy,"{applicationFee}",dollarFormat(getApplicationFee),"all");

		if ( NOT VAL(getApplicationFee) ) {
			SESSION.formErrors.Add(getApplicationFee);
		}
		
		// FORM Submitted
		if ( FORM.submitted ) {

			// FORM Validation
			if ( NOT LEN(FORM.paymentMethodID) ) {
				SESSION.formErrors.Add("Please select a payment method");
			}

			if ( NOT LEN(FORM.nameOnCreditCard) ) {
				SESSION.formErrors.Add("Please enter name on credit card");
			}

			if ( NOT LEN(FORM.creditCardType) ) {
				SESSION.formErrors.Add("Please select a credit card type");
			}

			if ( NOT LEN(FORM.creditCardNumber) ) {
				SESSION.formErrors.Add("Please enter a credit card number");
			}

			if ( NOT LEN(FORM.expirationMonth) ) {
				SESSION.formErrors.Add("Please select an expiration month");
			}

			if ( NOT LEN(FORM.expirationYear) ) {
				SESSION.formErrors.Add("Please select an expiration year");
			}

			if ( NOT LEN(FORM.ccvCode) ) {
				SESSION.formErrors.Add("Please enter a CCV code");
			}
			
			if ( NOT LEN(FORM.billingFirstName) ) {
				SESSION.formErrors.Add("Please enter a first name");
			}

			if ( NOT LEN(FORM.billingLastName) ) {
				SESSION.formErrors.Add("lease enter a last name");
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
				SESSION.formErrors.Add("Please enter a zip/postal code code");
			}

			if ( NOT LEN(FORM.billingCountryID) ) {
				SESSION.formErrors.Add("Please select a country");
			}

			if ( NOT LEN(FORM.paymentAgreement) ) {
				SESSION.formErrors.Add("You must agree with the Terms and Conditions");
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Submit Payment
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				// Reload page with updated information
				// location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");
				
			}
			
		}
    </cfscript>
    
</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="application"
/>
    
    <!--- Side Bar --->
    <div class="rightSideContent ui-corner-all">
        
        <div class="insideBar">

			<!--- Application Body --->
            <div class="form-container">
                
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
                
                
                <cfif VAL(getApplicationFee)>  
                    <form action="#CGI.SCRIPT_NAME#?action=applicationFee" method="post">
                    <input type="hidden" name="submitted" value="1" />
                    
                    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>

                    <!--- Application Fee --->
                    <fieldset>
                       
                        <legend>Application Fee</legend>

                        <div class="field controlset">
                            <span class="label">Application Fee <em>*</em></span>
							<strong>#dollarFormat(getApplicationFee)#</strong>
                        </div>

                    </fieldset>                

                    
                    <!--- Payment Information --->
                    <fieldset>
                       
                        <legend>Payment Method</legend>

                        <div class="field controlset">
                            <span class="label">Payment Method <em>*</em></span>
                            <cfloop index="i" from="1" to="#ArrayLen(APPLICATION.CONSTANTS.paymentType)#">
                                <input type="radio" name="paymentMethodID" id="#APPLICATION.CONSTANTS.paymentType[i]#" value="#APPLICATION.CONSTANTS.paymentType[i]#" <cfif APPLICATION.CONSTANTS.paymentType[i] EQ FORM.paymentMethodID> checked="checked" </cfif> /> <label for="#APPLICATION.CONSTANTS.paymentType[i]#">#APPLICATION.CONSTANTS.paymentType[i]#</label>
                            </cfloop>
                        </div>
                
                    </fieldset>                
                    
                    <!--- Credit Card Information --->
                    <fieldset>
                       
                        <legend>Credit Card Information</legend>
    
                        <p class="note">Enter information for a Credit Card. Your session is <a href="#cgi.SCRIPT_NAME#?action=privacy" target="_blank">secure</a>.</p>
                            
                        <div class="field">
                            <label for="nameOnCreditCard">Name on Credit Card <em>*</em></label> 
                            <input type="text" name="nameOnCreditCard" id="nameOnCreditCard" value="#FORM.nameOnCreditCard#" class="largeField" maxlength="100" />
                        </div>
  
  

                        <div class="field controlset">
                            <span class="label">&nbsp;</span>
                            <div class="creditCardAccepted">&nbsp;</div>
                        </div>


                
                        <div class="field controlset">
                            <span class="label">Credit Card Type <em>*</em></span>
                            <select name="creditCardType" id="creditCardType" class="mediumField" onchange="displayCreditCard(this.value);">
                                <option value=""></option>
                                <cfloop index="i" from="1" to="#ArrayLen(APPLICATION.CONSTANTS.creditCardType)#">
                                    <option value="#i#" <cfif APPLICATION.CONSTANTS.creditCardType[i] EQ FORM.creditCardType> selected="selected" </cfif> >#APPLICATION.CONSTANTS.creditCardType[i]#</option>
                                </cfloop>
                            </select>
                        </div>
                
                        <div class="field">
                            <label for="creditCardNumber">Credit Card Number <em>*</em></label> 
                            <input type="text" name="creditCardNumber" id="creditCardNumber" value="#FORM.creditCardNumber#" class="largeField" maxlength="100" />
                            <p class="note">no spaces or dashes</p>
                        </div>
                
                        <div class="field">
                            <label for="expirationMonth">Expiration Date <em>*</em></label> 
                            <select name="expirationMonth" id="expirationMonth" class="smallField">
                                <option value=""></option>
                                <cfloop from="1" to="12" index="i">
                                    <option value="#i#" <cfif FORM.expirationMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                                </cfloop>
                            </select>
                            /
                            <select name="expirationYear" id="expirationYear" class="xSmallField">
                                <option value=""></option>
                                <cfloop from="#Year(now())#" to="#Year(now()) + 8#" index="i">
                                    <option value="#i#" <cfif FORM.expirationYear EQ i> selected="selected" </cfif> >#i#</option>
                                </cfloop>
                            </select>
                        </div>
                
                        <div class="field">
                            <label for="ccvCode">CCV/CID Code <em>*</em></label> 
                            <input type="text" name="ccvCode" id="ccvCode" value="#FORM.ccvCode#" class="xSmallField" maxlength="4" />
                            <p class="note">See credit card image</p>
                        </div>
                      
                        <div class="creditCardImageDiv">
                            <div id="displayCardImage" class="card1"></div>
                        </div>
                        
                    </fieldset>
                    
                    <!--- Billing Address --->
                    <fieldset>
                       
                        <legend>Billing Address</legend>
                            
                        <div class="field">
                            <label for="billingFirstName">First Name <em>*</em></label> 
                            <input type="text" name="billingFirstName" id="billingFirstName" value="#FORM.billingFirstName#" class="largeField" maxlength="100" />
                        </div>
                
                        <div class="field">
                            <label for="billingLastName">Last Name <em>*</em></label> 
                            <input type="text" name="billingLastName" id="billingLastName" value="#FORM.billingLastName#" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingCompany">Company Name </label> 
                            <input type="text" name="billingCompany" id="billingCompany" value="#FORM.billingCompany#" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingAddress">Address <em>*</em></label> 
                            <input type="text" name="billingAddress" id="billingAddress" value="#FORM.billingAddress#" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingAddress2">Address 2</label> 
                            <input type="text" name="billingAddress2" id="billingAddress2" value="#FORM.billingAddress2#" class="largeField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingApt">Apt/Suite</label> 
                            <input type="text" name="billingApt" id="billingApt" value="#FORM.billingApt#" class="smallField" maxlength="20" />
                        </div>
    
                        <div class="field">
                            <label for="billingCity">City <em>*</em></label> 
                            <input type="text" name="billingCity" id="billingCity" value="#FORM.billingCity#" class="mediumField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingState">State/Province <em>*</em></label> 
                            <input type="text" name="billingState" id="billingState" value="#FORM.billingState#" class="mediumField" maxlength="100" />
                        </div>
    
                        <div class="field">
                            <label for="billingZipCode">Zip/Postal Code <em>*</em></label> 
                            <input type="text" name="billingZipCode" id="billingZipCode" value="#FORM.billingZipCode#" class="smallField" maxlength="20" />
                        </div>
    
                        <div class="field">
                            <label for="billingCountryID">Country <em>*</em></label> 
                            <select name="billingCountryID" id="billingCountryID" class="mediumField">
                                <option value=""></option> <!--- [select a country] ---->
                                <cfloop query="qGetCountry">
                                    <option value="#qGetCountry.ID#" <cfif FORM.billingCountryID EQ qGetCountry.ID> selected="selected" </cfif> >#qGetCountry.name#</option>
                                </cfloop>
                            </select>
                        </div>
    
                    </fieldset>
    
                    <fieldset>
                                           
                        <div class="controlset">
                            <span class="label"><em>*</em></span>
                            <div class="field">
                                <input type="checkbox" name="paymentAgreement" id="paymentAgreement" value="1" /> 
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

                    <div class="buttonrow">
                        <input type="submit" value="Submit" class="button ui-corner-top" />
                    </div>
                
                    </form>
				
                </cfif>                    
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>

<script type="text/javascript">
	// Display Credit Card
	$(document).ready(function() {
		// Get Current Value
		getSelected = $("#creditCardType").val();
		//getSelected = $("input[@name='creditCardType']:checked").val(); // CheckBox
		displayCreditCard(getSelected);
	});
</script>


<!---



The fee to process your application is $40 per campus choice. The
fee is non-refundable and is independent of an admission decision
or decision to withdraw or decline an offer of acceptance. Your
application will not be processed until full payment or authorized
fee waiver request is received.
Payment options are as follows:
Credit or Debit card: To pay by MasterCard or VISA, complete the
bottom of page A6.
Check (or Money Order): To pay by check, send a single check
for the total amount due to the Application Services Center (ASC).
Checks must be made payable to SUNY ASC and must be drawn
on a U.S. bank. Returned checks will be subject to an additional
processing fee of $20.
All appeals for refunds of overpayments must be put in writing to
the Director of the Application Services Center.

APPLICATION FEE PAYMENT � A $40 non-refundable application fee is required for each campus choice (please read instructions on page 3). You may pay either
by credit or debit card or by check (please do not send cash). Your credit or debit card will be charged $40 for each campus choice ($40 for one campus choice; $80 for two
campus choices, etc.). If paying by check, please send one check for total amount due ($40 for one campus choice; $80 for two campus choices, etc.). Checks
from international applicants must be in U.S. dollars and be drawn on a U.S. bank. Make checks payable to SUNY ASC. Please include the applicant�s name on your check.
Your application will not be processed until full payment or authorized fee waiver request is received. For information regarding an application fee waiver, see page 3.
--->