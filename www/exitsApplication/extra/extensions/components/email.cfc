<!--- ------------------------------------------------------------------------- ----
	
	File:		email.cfc
	Author:		Marcus Melo
	Date:		August 27, 2010
	Desc:		This holds the functions needed to sent out email

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="email"
	output="false" 
	hint="A collection of functions for the email module">


	<!--- Return the initialized OnlineApp object --->
	<cffunction name="Init" access="public" returntype="email" output="No" hint="Returns the initialized Email object">

		<cfscript>
			// Return this initialized instance
			return(this);
		</cfscript>

	</cffunction>


	<cffunction name="getEmailTemplate" access="private" returntype="struct" hint="This is a private function called by sendEmail. It returns the email text according to the type">
		<cfargument name="emailTemplate" type="string" default="" hint="newAccount/forgotPassword/loginUpdated/ - If passed gets the email text accordingly">
		<cfargument name="candidateID" type="numeric" default="0" hint="Used with the emailTemplate to get the student information">
        <cfargument name="branchID" type="numeric" default="0" hint="Used with the emailTemplate to get the Branch Information">
        <cfargument name="intlRepID" type="numeric" default="0" hint="Used with the emailTemplate to get the Intl. Rep. Information">
        <cfargument name="companyID" type="numeric" default="0" hint="7=Trainee / 8=WAT">
        <cfargument name="userID" type="numeric" default="0" hint="User ID is not required">
        <cfargument name="businessName" type="string" default="" hint="Intl. Rep. Business Name">
               
        <cfscript>
			var csbEmailSubject = '';
			
			var stEmailStructure = StructNew();
			stEmailStructure.subject = '';
			stEmailStructure.message = '';
			
			// Get Student Information	
			qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=ARGUMENTS.candidateID);
			
			// Get Intl. Rep. Information
			qGetIntlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetCandidateInfo.intRep);

			// Get Branch Information
			
			// Get Application History
			qGetApplicationHistory = APPLICATION.CFC.ONLINEAPP.getApplicationHistory(foreignTable=APPLICATION.foreignTable, foreignID=ARGUMENTS.candidateID);
			
			// Get User Information
			qGetUser =  APPLICATION.CFC.USER.getUserByID(userID=ARGUMENTS.userID); 
			
			/*** Email Templates
				loginUpdated - ok
				forgotPassword - ok
				newAccount - ok
				activateAccount - ok
				submittedByCandidate - ok
				approvedByBranch
				deniedByBranch - ok
				approvedByIntlRep
				deniedByIntlRep - ok
				receivedByOffice
				onHoldByOffice
				approvedByOffice - ok
				deniedByOffice - ok
			***/
		</cfscript>
		
        <cfoutput>
		
			<!--- Set Up Email Subject and CSB Footer Information According to Program --->
            <cfswitch expression="#ARGUMENTS.companyID#">
                
                <!--- Trainee Program --->
                <cfcase value="7">
                    
                    <cfscript>
                        csbEmailSubject = APPLICATION.CSB.Trainee.programName;
                        
                        accountCreatedMessage = 'An account has been successfully created for your organization at #APPLICATION.CSB.Trainee.name# - #APPLICATION.CSB.TraineeprogramName#. <br /><br />';
                    </cfscript>
                    
                </cfcase>
                
                <!--- WAT Program --->
                <cfcase value="8">
                
                    <cfscript>
                        csbEmailSubject = APPLICATION.CSB.WAT.programName;
                        
                        accountCreatedMessage = 'An account has been successfully created for your organization at #APPLICATION.CSB.WAT.name# - #APPLICATION.CSB.WAT.programName#. The account will grant you access to the CSB Online Database, formally known as EXTRA.<br /><br />';
                    </cfscript>
                    
                </cfcase>
                
                <!--- Default CSB Information --->
                <cfdefaultcase>
    
                    <cfscript>
                        csbEmailSubject = 'EXTRA';
                        
                        accountCreatedMessage = 'An account has been successfully created for your organization at #APPLICATION.CSB.name#. The account will grant you access to the CSB Online Database, formally known as EXTRA.<br /><br />';
                    </cfscript>
                    
                </cfdefaultcase>
            
            </cfswitch>                        
    
    
            <!--- Email Templates --->
            <cfswitch expression="#ARGUMENTS.emailTemplate#">
    
                <!--- 
                    /*********** USER TEMPLATES ***********/ 
                --->
                            
                <!--- Forgot Password User --->
                <cfcase value="userForgotPassword">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Password Reminder';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetUser.firstName# #qGetUser.lastName#-</p>
    
                        Please find your login information below: <br /><br />
                        Username: #qGetUser.username# <br />
                        Password: #qGetUser.password# <br /><br />
    
                        Please visit  
                        <a href="#APPLICATION.SITE.URL.main#?" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.main#
                        </a> to log in into your account. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- Grant Access --->
                <cfcase value="userGrantAccess">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Account Created';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetUser.firstName# #qGetUser.lastName# at #qGetUser.businessName#-</p>
                        
                        #accountCreatedMessage#                        
    
                        Please find your login information below: <br /><br />
                        Username: #qGetUser.username# <br />
                        Password: #qGetUser.password# <br /><br />
    
                        Please visit  
                        <a href="#APPLICATION.SITE.URL.main#?" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.main#
                        </a> to log in into your account. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
    
                
                <!--- 
                    /*********** CANDIDATE TEMPLATES ***********/ 
                --->
                
                <!--- Login Updated --->
                <cfcase value="loginUpdated">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Login Updated';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
    
                        You have successfully updated your login information. Please see below: <br /><br />
    
                        Username: #qGetCandidateInfo.email# <br />
                        Password: #qGetCandidateInfo.password# <br /><br />
                        
                        Please visit  
                        <a href="#APPLICATION.SITE.URL.main#?" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.main#
                        </a> to log in into your account. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- Forgot Password Candidate --->
                <cfcase value="forgotPassword">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Password Reminder';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
    
                        Please find your login information below: <br /><br />
                        Username: #qGetCandidateInfo.email# <br />
                        Password: #qGetCandidateInfo.password# <br /><br />
    
                        Please visit  
                        <a href="#APPLICATION.SITE.URL.main#?" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.main#
                        </a> to log in into your account. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- statusID=1 - New Account - Send Activation Email--->
                <cfcase value="newAccount">
                    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Account Created | Activation Required';
                    </cfscript>
                    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
    
                        #accountCreatedMessage#                        
    
                        Please click on 
                        <a href="#APPLICATION.SITE.URL.activation#?uniqueID=#qGetCandidateInfo.uniqueID#" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.activation#?uniqueID=#qGetCandidateInfo.uniqueID#
                        </a> to activate your account. <br /><br />
                        
                        Once your account is active, you are going to receive an email with your username and password. <br /><br />
                    </cfsavecontent>
                
                </cfcase>

                <cfcase value="newAccountOffice">
                    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Account Created | Activation Required';
                    </cfscript>
                    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
    
                        #accountCreatedMessage#                        
    
                        Please click on 
                        <a href="#APPLICATION.SITE.URL.activation#?uniqueID=#qGetCandidateInfo.uniqueID#" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.activation#?uniqueID=#qGetCandidateInfo.uniqueID#
                        </a> to activate your account. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
                
                <!--- statusID=2 - Account Activated --->
                <cfcase value="activateAccount">
                    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Account Activated';
                    </cfscript>
                    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
    
                        Your account has been activated. <br /><br />
    
                        Please click on 
                        <a href="#APPLICATION.SITE.URL.main#" style="text-decoration:none; color:##0069aa;">
                            #APPLICATION.SITE.URL.main#
                        </a> to log in into your account. <br /><br />
                        
                        Please find your login information below: <br /><br />
                        Username: #qGetCandidateInfo.email#<br />
                        Password: #qGetCandidateInfo.password# <br /><br />
                        
                        You can start your online application at any time and do not need to complete it all at once. <br /><br />    
                                    
                        Once submitted, the application can no longer be edited. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
                
                <!--- statusID=3/5 - Application Submitted by Candidate --->
                <cfcase value="submittedByCandidate">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application Submitted';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
                        
                        Your application has been submitted to #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#. <br /><br />
                        
                        #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName# is going to review your application soon. <br /><br />
                        
                        Please note from this point on, you no longer are able to edit the application.
                        If you need to make any changes please contact #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
                
                <!--- statusID=4/6 - Application Denied by Branch/Intl. Rep. --->
                <cfcase value="deniedByBranch,deniedByIntlRep">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application Denied';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
                        
                        Your application has been denied by #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#. <br /><br />
                        
                        <!--- Comments --->
                        <cfif LEN(qGetApplicationHistory.comments)>
                            See comments below: <br /><br />
                                               
                            <strong> #qGetApplicationHistory.comments# </strong> <br /><br />
                        </cfif>
                        
                        Please login to your application and make the necessary changes and re-submit the application. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
            
                <!--- statusID=7 - Application Submitted to CSB --->
                <cfcase value="approvedByIntlRep">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application Submitted to CSB';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetIntlRep.businessName#-</p>
                        
                        Application for #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# has been submitted to CSB. <br /><br />
                         
                        Please note from this point on, you no longer are able to edit the application.
                        If you need to make any changes please contact #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- statusID=8 - Application Received by CSB --->
                <cfcase value="receivedByOffice">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application has been received by CSB';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetIntlRep.businessName#-</p>
                        
                        Application for #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# has been received and it's being reviewed by CSB. <br /><br />
                        
                        <!--- Comments --->
                        <cfif LEN(qGetApplicationHistory.comments)>
                            See comments below: <br /><br />
                                               
                            <strong> #qGetApplicationHistory.comments# </strong> <br /><br />
                        </cfif>
                        
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- statusID=9 - Application Denied by CSB --->
                <cfcase value="deniedByOffice">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application Denied by CSB';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetIntlRep.businessName#-</p>
                        
                        Application for #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# has been denied by CSB. <br /><br />
                        
                        <!--- Comments --->
                        <cfif LEN(qGetApplicationHistory.comments)>
                            See comments below: <br /><br />
                                               
                            <strong> #qGetApplicationHistory.comments# </strong> <br /><br />
                        </cfif>
                        
                        Please login to your application and make the necessary changes and re-submit the application. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- statusID=10 - Application On Hold by CSB --->
                <cfcase value="onHoldByOffice">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application On Hold by CSB';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetIntlRep.businessName#-</p>
                        
                        Application for #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# has been placed on hold by CSB. <br /><br />
                        
                        <!--- Comments --->
                        <cfif LEN(qGetApplicationHistory.comments)>
                            See comments below: <br /><br />
                                               
                            <strong> #qGetApplicationHistory.comments# </strong> <br /><br />
                        </cfif>
                        
                    </cfsavecontent>
                
                </cfcase>
    
                <!--- statusID=11 - Application Approved by CSB --->
                <cfcase value="approvedByOffice">
    
                    <cfscript>
                        stEmailStructure.subject = csbEmailSubject & ' - Application Approved by CSB';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #qGetIntlRep.businessName#-</p>
                        
                        Application for #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# has been approved by CSB. <br /><br />
                    </cfsavecontent>
                
                </cfcase>
                
                
                <!--- WAT - Missing Documents --->
                <cfcase value="watMissingDocuments">
    
                    <cfscript>
                        stEmailStructure.subject = 'SWT CSB Participants – Missing Documents Report';
                    </cfscript>
    
                    <cfsavecontent variable="stEmailStructure.message">
                        <p>Dear #ARGUMENTS.businessName#-</p>
                        
                        <p>
							This is a notice that additional information is needed in order to adhere to United States Department of State regulations and to ensure that 
                            the student will have a complete application on file. 
                            <font color="##FF0000">
                            	Please send the requested missing information within 5 (five) business days of this notice. 
                                The document(s) must be uploaded in EXTRA system (online application) for each participant listed below. 
                            </font>
                            It is crucial that we receive it on time.
                            <br/>
                            <br/>
                            Note: If meanwhile you have submitted the requested information, thank you and please disregard this notice.
							<br/>
                            <br/>
                            Clarification of exceptions: 
                            <br/>
                             - The Housing Arrangements Form, if included in this report, must be submitted with 15 days before arrival.
                            <br/>
                             - The Orientation Sign Off Form, if included in this report, must be submitted only after the participants received the
                             visa documents from CSB and after they passed the orientation session organized by your organization, in preparation for
                             their departure from the home country to the United States.
                        </p>
                    </cfsavecontent>
                
                </cfcase>
            
            </cfswitch>
        
        </cfoutput>
        
        <cfscript>
			return stEmailStructure;
		</cfscript>			        
	</cffunction>

	
	<cffunction name="sendEmail" access="public" returntype="void" hint="Sends email from the system with the CSB header/footer">
        <cfargument name="emailFrom" type="string" default="#APPLICATION.EMAIL.contactUs# (CSB International, Inc.)" hint="Email From Address">
		<cfargument name="emailTo" type="string" required="true" hint="Email To is required">
		<cfargument name="emailReplyTo" type="string" default="" hint="Email Address to reply">
        <cfargument name="emailCC" type="string" default="" hint="Email CC Field">
        <cfargument name="emailBCC" type="string" default="" hint="Email BCC Field">
        <cfargument name="emailSubject" type="string" default="" hint="Email Subject">
        <cfargument name="emailMessage" type="string" default="" hint="Email Message">
        <cfargument name="emailFilePath" type="string" default="" hint="Optional attachment file">
        <cfargument name="emailPriority" type="numeric" default="3" hint="An integer in the range 1-5; 1 represents the highest priority.">
        <cfargument name="emailTemplate" type="string" default="" hint="newAccount/forgotPassword/ - If passed gets the email text accordingly">
        <cfargument name="candidateID" type="numeric" default="0" hint="Used with the emailTemplate to get the student information">  
        <cfargument name="companyID" type="numeric" default="0" hint="Company ID to get the correct subject/footer information">   
        <cfargument name="userID" type="numeric" default="0" hint="user ID in case we are emailing a user">    
        <cfargument name="footerType" type="string" default="email" hint="email / emailRegular">
        <cfargument name="businessName" type="string" default="" hint="Intl. Rep. Business Name">
        <cfargument name="displayEmailLogoHeader" type="numeric" default="1" hint="Set to 1 to include logo header">
        <cfargument name="attachmentMessage" type="string" default="" hint="Not required">
        <cfargument name="attachmentMessageName" type="string" default="" hint="Not required">
		
		<!--- Import CustomTag --->
		<cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

		<cfscript>
			var vEmailTemplate = '';			
			var vConfidentialityMessage = '';
			
			// If we have a valid emailTemplate we'll get the email subject and message from the function above
			if ( LEN(ARGUMENTS.emailTemplate) ) {
				
				stGetEmailTemplate = getEmailTemplate(
					emailTemplate=ARGUMENTS.emailTemplate, 
					candidateID=ARGUMENTS.candidateID,
					companyID=ARGUMENTS.companyID,
					userID=ARGUMENTS.userID,
					businessName=ARGUMENTS.businessName
				);
				
				ARGUMENTS.emailSubject = stGetEmailTemplate.subject;
				vEmailTemplate = stGetEmailTemplate.message;
				//ARGUMENTS.emailMessage = stGetEmailTemplate.message;
			}
			
			// This is used to store email information when system sends an email on a development environment
			var emailIntendedTo = '';
			
			// Development Environment - If under development email current user so no emails are sent by mistake to field or Intl. Representative
			if ( APPLICATION.isServerLocal ) {
				
				emailIntendedTo = emailIntendedTo & "<p>Email To: #ARGUMENTS.emailTo#</p>";

				// IT / Office
				if ( ListFind("1,2,3", CLIENT.userType) ) {
					ARGUMENTS.emailTo = CLIENT.email;	  
				} else {
					//ARGUMENTS.emailTo = APPLICATION.EMAIL.support;
                    ARGUMENTS.emailTo = "bruno@brunolopes.com";
				}
				
				if ( LEN(ARGUMENTS.emailCC) ) {
					emailIntendedTo = emailIntendedTo & "<p>Email CC: #ARGUMENTS.emailCC#</p>";
					ARGUMENTS.emailCC = '';
				}
				
				if ( LEN(ARGUMENTS.emailBCC) ) {
					emailIntendedTo = emailIntendedTo & "<p>Email BCC: #ARGUMENTS.emailBCC#</p>";
					ARGUMENTS.emailBCC = '';
					
				}
				
			} else {

				// Stores Emails Sent at sentEmail@csb-usa.com
				if ( NOT LEN(ARGUMENTS.emailBCC) ) {				
					ARGUMENTS.emailBCC = APPLICATION.EMAIL.sentEmail;                      
				}
				
			}
		</cfscript>
		
		<cfmail 
            from="#ARGUMENTS.emailFrom#" 
            to="#ARGUMENTS.emailTo#" 
            replyto="#ARGUMENTS.emailReplyTo#" 
            cc="#ARGUMENTS.emailCC#"
            bcc="#ARGUMENTS.emailBCC#" 
            subject="#ARGUMENTS.emailSubject#" 
            type="html"
            priority="#ARGUMENTS.emailPriority#">

            <!--- Attach File --->
			<cfif LEN(ARGUMENTS.emailFilePath) AND APPLICATION.CFC.DOCUMENT.checkFileExists(filePath=ARGUMENTS.emailFilePath)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.emailFilePath#">                
            </cfif>

            <!--- Attach Message --->
            <cfif LEN(ARGUMENTS.attachmentMessage)>
                <cfmailparam file="#attachmentMessageName#" content="#ARGUMENTS.attachmentMessage#" type="html">                
            </cfif>

			<!--- Page Header --->
            <gui:pageHeader
                headerType="email"
                companyID="#ARGUMENTS.companyID#"
                displayEmailLogoHeader="#ARGUMENTS.displayEmailLogoHeader#"
            />

				<!--- Email Template --->
                #vEmailTemplate#
                
                <!--- Email Body --->
                #ARGUMENTS.emailMessage#
                
                <!--- Display Email Recipients when sending from development environment --->
                <cfif APPLICATION.isServerLocal>
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                        ********************************** DEVELOPMENT SITE **********************************
                    </div>
                    
                    <p>
                        You received this email insted of the original recipient(s) 
                        because you are logged in the development environment.
                    </p>
                    
                    <p>Please see below the original recipient(s) for this message</p>
                    
                    #emailIntendedTo#
                    
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                        ********************************** DEVELOPMENT SITE **********************************
                    </div>
                </cfif>

			<!--- Page Footer --->
            <gui:pageFooter
                footerType="#ARGUMENTS.footerType#"
                companyID="#ARGUMENTS.companyID#"
            />
                  
        </cfmail>
        	
	</cffunction>

</cfcomponent>
