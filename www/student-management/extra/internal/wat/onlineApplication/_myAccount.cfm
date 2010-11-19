<!--- ------------------------------------------------------------------------- ----
	
	File:		_myAccount.cfm
	Author:		Marcus Melo
	Date:		August 9, 2010
	Desc:		My Account - Username / Password

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">
	<cfparam name="FORM.email" default="">
    <cfparam name="FORM.newEmail" default="">
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.newPassword" default="">
    <cfparam name="FORM.confirmNewPassword" default="">
    
    <cfscript>	
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);

		// FORM Submitted
		if (FORM.submitted) {
			// Data Validation

			// Email
			if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
				SESSION.formErrors.Add("Enter a valid email address.");			
			}

			// Check if Email has been registered
			if ( IsValid("email", FORM.email) AND APPLICATION.CFC.CANDIDATE.doesAccountExist(email=FORM.email,candidateID=FORM.candidateID) ) {
				SESSION.formErrors.Add("Email address already registered.");		
			}

			// Check if we are updating password
			if ( LEN(FORM.newPassword) ) {
			
				// Current Password
				if ( FORM.password NEQ qGetCandidateInfo.password ) {
					SESSION.formErrors.Add("Current password does not match.");	
				}
				
				// Password
				if ( NOT LEN(FORM.newPassword) ) {
					SESSION.formErrors.Add("Enter a new password.");			
				}
	
				// Password
				if ( LEN(FORM.newPassword) AND LEN(FORM.newPassword) NEQ LEN(FORM.confirmNewPassword) ) {
					SESSION.formErrors.Add("Confirm new password does not match.");			
				}
				
				// Validate Password
				stValPassword = APPLICATION.CFC.ONLINEAPP.isValidPassword(password=FORM.newPassword);
				if ( LEN(FORM.newPassword) AND NOT stValPassword.isValidPassword ) {
					SESSION.formErrors.Add(stValPassword.Errors);
				}
			
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				infoUpdated = 0;
				
				if ( FORM.email NEQ qGetCandidateInfo.email ) {
					infoUpdated = 1;
					// update Email Address
					APPLICATION.CFC.CANDIDATE.updateEmail(
						candidateID=FORM.candidateID, 
						email=FORM.email
					);					
				}
				
				if ( LEN(FORM.newPassword) ) {
					infoUpdated = 1;
					// update Password
					APPLICATION.CFC.CANDIDATE.updatePassword(
						candidateID=FORM.candidateID, 
						password=FORM.newPassword
					);
				}
				
				// If we updated email and/or password, send out confirmation email
				if (infoUpdated) {
					// Send out Email Confirmation
					APPLICATION.CFC.EMAIL.sendEmail(
						emailTo=FORM.email,
						emailTemplate='loginUpdated',
						candidateID=FORM.candidateID,
						companyID=APPLICATION.CFC.CANDIDATE.getCandidateSession().companyID
					);
				}

				// Update Candidate Session Variables
				APPLICATION.CFC.CANDIDATE.setCandidateSession(candidateID=FORM.candidateID);

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");

			}

		} else {
			
		  // Set the default values of the FORM 
		  FORM.email = qGetCandidateInfo.email;
		  FORM.password = qGetCandidateInfo.password;
		  
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
			<div class="form-container-noBorder">
            
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
                    
                <form action="#CGI.SCRIPT_NAME#?#cgi.QUERY_STRING#" method="post">
                <input type="hidden" name="submitted" value="1" />
            
				<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>            
            
                <fieldset>
                   
                    <legend>My Account</legend>
                        
                    <div class="field">
                        <label for="email">Email Address <em>*</em></label> 
                        <input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="password">Current Password <em>*</em></label> 
                        <input type="password" name="password" id="password" value="#FORM.password#" class="largeField" maxlength="100" />
                        <p class="note">If you wish to change your password, please fill out all the password fields.</p>
                    </div>

                    <div class="field">
                        <label for="newPassword">New Password <em>*</em></label> 
                        <input type="password" name="newPassword" id="newPassword" value="#FORM.newPassword#" class="largeField" maxlength="100" />
                    </div>

                    <div class="field">
                        <label for="confirmNewPassword">Confirm New Password <em>*</em></label> 
                        <input type="password" name="confirmNewPassword" id="confirmNewPassword" value="#FORM.confirmNewPassword#" class="largeField" maxlength="100" />
                    </div>
    
                </fieldset>
                            
                <div class="buttonrow">
                    <input type="submit" value="Save" class="button ui-corner-top" />
                </div>
                
                </form>
                
            </div>
            
		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
