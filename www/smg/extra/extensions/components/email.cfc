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
               
        <cfscript>
			var csbEmailSubject = '';
			
			var stEmailStructure = StructNew();
			stEmailStructure.subject = '';
			stEmailStructure.message = '';
			
			// Get Student Information	
			qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=ARGUMENTS.candidateID);
			
			// Get Branch Information
			
			// Get Intl. Rep. Information
			
			// Get Application History
			qGetApplicationHistory = APPLICATION.CFC.ONLINEAPP.getApplicationHistory(foreignTable=APPLICATION.foreignTable, foreignID=ARGUMENTS.candidateID);
	
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
				approvedByOffice
				deniedByOffice
			***/
		</cfscript>
		
        <cfoutput>
		
        <!--- Set Up Email Subject and CSB Footer Information According to Program --->
        <cfswitch expression="#ARGUMENTS.companyID#">
            
            <!--- Trainee Program --->
            <cfcase value="7">
            	
                <cfscript>
					csbEmailSubject = APPLICATION.CSB.Trainee.name & ' - ' & APPLICATION.CSB.Trainee.programName;
					
					accountCreatedMessage = 'An account has been successfully created at #APPLICATION.CSB.Trainee.name# - #APPLICATION.CSB..TraineeprogramName#. <br /><br />';
				</cfscript>
                
            </cfcase>
            
            <!--- WAT Program --->
            <cfcase value="8">
            
                <cfscript>
					csbEmailSubject = APPLICATION.CSB.WAT.name & ' - ' & APPLICATION.CSB.WAT.programName;
					
					accountCreatedMessage = 'An account has been successfully created at #APPLICATION.CSB.WAT.name# - #APPLICATION.CSB.WAT.programName#. <br /><br />';
				</cfscript>
                
            </cfcase>
            
            <!--- Default CSB Information --->
            <cfdefaultcase>

                <cfscript>
					csbEmailSubject = APPLICATION.CSB.Trainee.name;
					
					accountCreatedMessage = 'An account has been successfully created at #APPLICATION.CSB.name#. <br /><br />';
				</cfscript>
                
            </cfdefaultcase>
        
        </cfswitch>                        


        <!--- Email Templates --->
		<cfswitch expression="#ARGUMENTS.emailTemplate#">

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
                </cfsavecontent>
            
            </cfcase>

        	<!--- Forgot Password --->
        	<cfcase value="forgotPassword">

                <cfscript>
					stEmailStructure.subject = csbEmailSubject & ' - Password Reminder';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>

                    Please see below your login information: <br /><br />
                    Username: #qGetCandidateInfo.email# <br />
                    Password: #qGetCandidateInfo.password# <br /><br />
                </cfsavecontent>
            
            </cfcase>

            <!--- New Account - Send Activation Email--->
            <cfcase value="newAccount">
            	
                <cfscript>
					stEmailStructure.subject = csbEmailSubject & ' - Account Created - Activation Required';
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
            
            <!--- Account Activated --->
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
                    
                    Your login information: <br /><br />
					Username: #qGetCandidateInfo.email#<br />
					Password: #qGetCandidateInfo.password# <br /><br />
                    
                    You can start your online application at any time and do not need to complete it all at once. <br /><br />    
                                
                    Once submitted, the application can no longer be edited. <br /><br />
                </cfsavecontent>
            
            </cfcase>
			
			<!--- Application Submitted By Candidate --->
        	<cfcase value="submittedByCandidate">

                <cfscript>
					stEmailStructure.subject = csbEmailSubject & ' - Application Submitted';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
					
                    Your application has been submitted to #SESSION.CANDIDATE.intlRepName#. <br /><br />
                    
                    #SESSION.CANDIDATE.intlRepName# is going to review your application soon. <br /><br />
                    
                    Please note from this point on, you no longer are able to edit the application.
                    If you need to make any changes please contact #SESSION.CANDIDATE.intlRepName#. <br /><br />
                </cfsavecontent>
            
            </cfcase>
            
			<!--- Application Denied By Branch/Intl. Rep. --->
        	<cfcase value="deniedByBranch,deniedByIntlRep">

                <cfscript>
					stEmailStructure.subject = csbEmailSubject & ' - Application Denied';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
					
                    Your application has been denied by #SESSION.CANDIDATE.intlRepName#. <br /><br />
                    
                    <!--- Comments --->
                    <cfif LEN(qGetApplicationHistory.comments)>
                        See comments below: <br /><br />
                                           
                        <strong> #qGetApplicationHistory.comments# </strong> <br /><br />
					</cfif>
                    
                    Please login to your application and make the necessary changes and re-submit the application. <br /><br />
                </cfsavecontent>
            
            </cfcase>




        	<!--- Application Submitted --->
        	<cfcase value="applicationSubmitted">

                <cfscript>
					stEmailStructure.subject = csbEmailSubject & ' - Application for Admission submitted';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
					
                    Thank you for applying to GPA. You have successfully submitted your online application for admission. <br /><br />
					
                    Please contact our Admissions Office to set up an interview. <br /><br />

                    Admissions Department  <br />
                </cfsavecontent>
            
            </cfcase>


        	<!--- Application Submitted Admissions --->
        	<cfcase value="applicationSubmittedAdmissions">

                <cfscript>
					stEmailStructure.subject = 'Application for student ' & qGetCandidateInfo.firstName & ' ' & qGetCandidateInfo.lastName & ' - has been submitted';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>Admissions Department,</p>

                    Application for student #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# ###qGetCandidateInfo.ID# has been submitted. <br /><br />
					
                    Please find a copy of the application attached. <br /><br />
                </cfsavecontent>
            
            </cfcase>
        
        </cfswitch>
        
        </cfoutput>
        
        <cfscript>
			return stEmailStructure;
		</cfscript>			        
	</cffunction>

	
	<cffunction name="sendEmail" access="public" returntype="void" hint="Sends email from the system with the CSB header/footer">
        <cfargument name="emailFrom" type="string" default="#APPLICATION.EMAIL.support#" hint="Email From Address">
		<cfargument name="emailTo" type="string" required="true" hint="Email To is required">
		<cfargument name="emailReplyTo" type="string" default="" hint="Email Address to reply">
        <cfargument name="emailCC" type="string" default="" hint="Email CC Field">
        <cfargument name="emailSubject" type="string" default="" hint="Email Subject">
        <cfargument name="emailMessage" type="string" default="" hint="Email Message">
        <cfargument name="emailFilePath" type="string" default="" hint="Optional attachment file">
        <cfargument name="emailTemplate" type="string" default="" hint="newAccount/forgotPassword/ - If passed gets the email text accordingly">
        <cfargument name="candidateID" type="numeric" default="0" hint="Used with the emailTemplate to get the student information">  
        <cfargument name="companyID" type="numeric" default="0" hint="Company ID to get the correct subject/footer information">      

		<!--- Import CustomTag --->
		<cfimport taglib="../../extensions/customtags/gui/" prefix="gui" />	

		<cfscript>
			// If we have a valid candidateID and emailTemplate we'll get the email subject and message from  the function above
			if ( LEN(ARGUMENTS.emailTemplate) AND VAL(ARGUMENTS.candidateID) ) {
				
				stGetEmailTemplate = getEmailTemplate(
					emailTemplate=ARGUMENTS.emailTemplate, 
					candidateID=ARGUMENTS.candidateID,
					companyID=ARGUMENTS.companyID
				);
				
				ARGUMENTS.emailSubject = stGetEmailTemplate.subject;
				ARGUMENTS.emailMessage = stGetEmailTemplate.message;
			}
		</cfscript>
		
		<cfmail 
            from="#ARGUMENTS.emailFrom#" 
            to="#ARGUMENTS.emailTo#" 
            replyto="#ARGUMENTS.emailReplyTo#" 
            cc="#ARGUMENTS.emailCC#" 
            subject="#ARGUMENTS.emailSubject#" 
            type="html">

            <!--- Attach File --->
			<cfif LEN(ARGUMENTS.emailFilePath) AND APPLICATION.CFC.DOCUMENT.checkFileExists(filePath=ARGUMENTS.emailFilePath)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.emailFilePath#">                
            </cfif>
            
			<!--- Page Header --->
            <gui:pageHeader
                headerType="email"
            />
            
            <!--- Email Body --->
            #ARGUMENTS.emailMessage#
        
			<!--- Page Footer --->
            <gui:pageFooter
                footerType="email"
            />
            
        </cfmail>

	</cffunction>

</cfcomponent>