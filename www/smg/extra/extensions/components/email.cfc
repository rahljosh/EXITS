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
		<cfargument name="emailType" type="string" default="" hint="newAccount/forgotPassword/loginUpdated/ - If passed gets the email text accordingly">
		<cfargument name="candidateID" type="numeric" default="0" hint="Used with the emailType to get the student information">
        
        <cfscript>
			var stEmailStructure = StructNew();
			stEmailStructure.subject = '';
			stEmailStructure.message = '';
			
			// Get Student Information	
			qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=ARGUMENTS.candidateID);
		</cfscript>
		
        <cfoutput>
        
		<cfswitch expression="#ARGUMENTS.emailType#">
        	
            <!--- New Account - Send Activation Email--->
            <cfcase value="newAccount">
            	
                <cfscript>
					stEmailStructure.subject = APPLICATION.CSB.name & ' - ' & APPLICATION.CSB.programName & ' - Account Created - Activation Required';
				</cfscript>
                
                <cfsavecontent variable="stEmailStructure.message">
                	<p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>

                    An account has been successfully created at #APPLICATION.CSB.name# - #APPLICATION.CSB.programName#. <br /><br />

                    Please click on 
                    <a href="#APPLICATION.SITE.URL.activation#?uniqueID=#qGetCandidateInfo.uniqueID#" style="text-decoration:none; color:##0069aa;">
                    	#APPLICATION.SITE.URL.activation#?#qGetCandidateInfo.uniqueID#
                    </a> to activate your account. <br /><br />
                    
                    Once your account is active, you are going to receive an email with your username and password. <br /><br />
                    
                    If you have any questions about filling out the online application please contact us at 
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                                        
                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.programName# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
            
            </cfcase>
        	
            
            <!--- Account Activated --->
            <cfcase value="activateAccount">
            	
                <cfscript>
					stEmailStructure.subject = APPLICATION.CSB.name & ' - ' & APPLICATION.CSB.programName & ' - Account Activated';
				</cfscript>
                
                <cfsavecontent variable="stEmailStructure.message">
                	<p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>

                    Your account has been activated. <br /><br />

                    Please click on 
                    <a href="#APPLICATION.SITE.URL.main#" style="text-decoration:none; color:##0069aa;">
                    	#APPLICATION.SITE.URL.main#
                    </a> to log in into your account. <br /><br />
                    
                    Your login information: <br /><br />
					Email: #qGetCandidateInfo.email#<br />
					Password: #qGetCandidateInfo.password# <br /><br />
                    
                    You can start your online application at any time and do not need to complete it all at once. <br /><br />    
                                
                    Once submitted, the application can no longer be edited. <br /><br />
                    
                    If you have any questions about filling out the online application please contact us at 
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                                        
                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.programName# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
            
            </cfcase>

        
        	<!--- Forgot Password --->
        	<cfcase value="forgotPassword">

                <cfscript>
					stEmailStructure.subject = APPLICATION.CSB.name & ' - Password Reminder';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>

                    Please see below your login information: <br /><br />
                    Email Address: #qGetCandidateInfo.email# <br />
                    Password: #qGetCandidateInfo.password# <br /><br />

                    If you have any questions about filling out the online application please contact us at 
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                                        
                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.programName# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
            
            </cfcase>


        	<!--- Login Updated --->
        	<cfcase value="loginUpdated">

                <cfscript>
					stEmailStructure.subject = APPLICATION.CSB.name & ' - Login Updated';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>Dear #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>

                    You have successfully updated your login information. Please see below: <br /><br />

                    Email Address: #qGetCandidateInfo.email# <br />
                    Password: #qGetCandidateInfo.password# <br /><br />

                    If you have any questions about filling out the online application please contact us at 
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                                        
                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.programName# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
            
            </cfcase>


        	<!--- Application Submitted --->
        	<cfcase value="applicationSubmitted">

                <cfscript>
					stEmailStructure.subject = APPLICATION.CSB.name & ' - Application for Admission submitted';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#-</p>
					
                    Thank you for applying to GPA. You have successfully submitted your online application for admission. <br /><br />
					
                    Please contact our Admissions Office to set up an interview. <br /><br />

                    Admissions Department  <br />
                    
                    If you have any questions about filling out the online application please contact us at 
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                                        
                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.programName# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
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
                    
                    If you have any questions about filling out the online application please contact us at 
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                                        
                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.programName# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
            
            </cfcase>
            
        </cfswitch>
        
        </cfoutput>
        
        <cfscript>
			return stEmailStructure;
		</cfscript>			        
	</cffunction>

	
	<cffunction name="sendEmail" access="public" returntype="void" hint="Sends email from the system with the Granby header/footer">
        <cfargument name="emailFrom" type="string" default="#APPLICATION.EMAIL.support#" hint="Email From Address">
		<cfargument name="emailTo" type="string" required="true" hint="Email To is required">
		<cfargument name="emailReplyTo" type="string" default="" hint="Email Address to reply">
        <cfargument name="emailCC" type="string" default="" hint="Email CC Field">
        <cfargument name="emailSubject" type="string" default="" hint="Email Subject">
        <cfargument name="emailMessage" type="string" default="" hint="Email Message">
        <cfargument name="emailFilePath" type="string" default="" hint="Optional attachment file">
        <cfargument name="emailType" type="string" default="" hint="newAccount/forgotPassword/ - If passed gets the email text accordingly">
        <cfargument name="candidateID" type="numeric" default="0" hint="Used with the emailType to get the student information">        

		<!--- Import CustomTag --->
		<cfimport taglib="../../extensions/customtags/gui/" prefix="gui" />	

		<cfscript>
			// If we have a valid candidateID and emailType we'll get the email subject and message from  the function above
			if ( LEN(ARGUMENTS.emailType) AND VAL(ARGUMENTS.candidateID) ) {
				stGetEmailTemplate = getEmailTemplate(emailType=ARGUMENTS.emailType, candidateID=ARGUMENTS.candidateID);
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