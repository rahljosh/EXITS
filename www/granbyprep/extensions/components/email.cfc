<!--- ------------------------------------------------------------------------- ----
	
	File:		email.cfc
	Author:		Marcus Melo
	Date:		June 16, 2010
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
		<cfargument name="studentID" type="numeric" default="0" hint="Used with the emailType to get the student information">
        
        <cfscript>
			var stEmailStructure = StructNew();
			stEmailStructure.subject = '';
			stEmailStructure.message = '';
			
			// Get Student Information	
			qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=ARGUMENTS.studentID);
		</cfscript>
		
        <cfoutput>
        
		<cfswitch expression="#ARGUMENTS.emailType#">
        	
            <!--- New Account --->
            <cfcase value="newAccount">
            	
                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - New Account Created';
				</cfscript>
                
                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>

                    You have successfully created an account at #APPLICATION.SCHOOL.name#. <br /><br />

                    You can start your application at any time and do not need to complete it all at once. <br />                
                    Once submitted, the application can no longer be edited. <br /><br />

                    Please visit <a href="#APPLICATION.SITE.URL.admissions#" style="text-decoration:none; color:##0069aa;">#APPLICATION.SITE.URL.admissions#</a> to login into your application account. <br /><br />

                    Please see below your login information: <br /><br />
                    Email Address: #qGetStudentInfo.email#<br />
                    Password: #qGetStudentInfo.password# <br /><br />

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->                   
                </cfsavecontent>
            
            </cfcase>
        
        
        	<!--- Forgot Password --->
        	<cfcase value="forgotPassword">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - Password Reminder';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>

                    Please visit <a href="#APPLICATION.SITE.URL.admissions#" style="text-decoration:none; color:##0069aa;">#APPLICATION.SITE.URL.admissions#</a> to login into your application account. <br /><br />

                    Please see below your login information: <br /><br />
                    Email Address: #qGetStudentInfo.email# <br />
                    Password: #qGetStudentInfo.password# <br /><br />
                    
                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->                   
                </cfsavecontent>
            
            </cfcase>


        	<!--- Login Updated --->
        	<cfcase value="loginUpdated">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - Login Updated';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>

                    You have successfully updated your login information. Please see below: <br /><br />

                    Please visit <a href="#APPLICATION.SITE.URL.admissions#" style="text-decoration:none; color:##0069aa;">#APPLICATION.SITE.URL.admissions#</a> to login into your application account. <br /><br />

                    Email Address: #qGetStudentInfo.email# <br />
                    Password: #qGetStudentInfo.password# <br /><br />
					
                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->                   
                </cfsavecontent>
            
            </cfcase>


            <!--- Payment Submitted --->
        	<cfcase value="paymentSubmitted">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - Application Fee Received';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>

                    You have successfully submitted an application payment of <br /><br />
					
                    Reference Number {referenceNumber} <br /><br />
                    
                    If you have any questions please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br />  --->                  
                </cfsavecontent>
            
            </cfcase>
        
        
        	<!--- Application Submitted --->
        	<cfcase value="applicationSubmitted">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - Application for Admission submitted';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>
					
                    Thank you for applying to The MacDuffie School. You have successfully submitted your online application for admission. <br /><br />
					
                    Please contact our Admissions Office to set up an interview. <br /><br />

                    Admissions Department  <br />
                    #APPLICATION.SCHOOL.admissions# <br />
                    <a href="mailto:#APPLICATION.EMAIL.admissions#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.admissions#</a> <br />
                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br /><br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /><br /> --->
                    
                    If you have any questions please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->                   
                </cfsavecontent>
            
            </cfcase>


        	<!--- Application Submitted Admissions --->
        	<cfcase value="applicationSubmittedAdmissions">

                <cfscript>
					stEmailStructure.subject = 'Application for student ' & qGetStudentInfo.firstName & ' ' & qGetStudentInfo.lastName & ' - has been submitted';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>Admissions Department,</p>

                    Application for student #qGetStudentInfo.firstName# #qGetStudentInfo.lastName# ###qGetStudentInfo.ID# has been submitted. <br /><br />
					
                    Please find a copy of the application attached. <br /><br />
                    
                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->
                </cfsavecontent>
            
            </cfcase>
            
        </cfswitch>
        
        </cfoutput>
        
        <cfscript>
			return stEmailStructure;
		</cfscript>			        
	</cffunction>

	
    <!--- AdminTool Templates --->
	<cffunction name="getAdminEmailTemplate" access="private" returntype="struct" hint="This is a private function called by sendEmail. It returns the email text according to the type">
		<cfargument name="emailType" type="string" default="" hint="newAccount/forgotPassword/loginUpdated/ - If passed gets the email text accordingly">
		<cfargument name="userID" type="numeric" default="0" hint="Used with the emailType to get the user information">
        
        <cfscript>
			var stEmailStructure = StructNew();
			stEmailStructure.subject = '';
			stEmailStructure.message = '';
			
			// Get Student Information	
			qGetUserInfo = APPLICATION.CFC.USER.getUserByID(ID=ARGUMENTS.userID);
		</cfscript>
		
        <cfoutput>
        
		<cfswitch expression="#ARGUMENTS.emailType#">
        	
            <!--- New Account --->
            <cfcase value="newAccount">
            	
                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - AdminTool - New Account Created';
				</cfscript>
                
                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetUserInfo.firstName# #qGetUserInfo.lastName#-</p>

                    An account has been created at #APPLICATION.SCHOOL.name# AdminTool. <br /><br />

                    Please visit <a href="#APPLICATION.SITE.URL.adminTool#" style="text-decoration:none; color:##0069aa;">#APPLICATION.SITE.URL.adminTool#</a> to login into the AdminTool. <br /><br />

                    Please see below your login information: <br /><br />
                    Email Address: #qGetUserInfo.email#<br />
                    Password: #qGetUserInfo.password# <br /><br />

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!---  Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->                    
                </cfsavecontent>
            
            </cfcase>
        
        
        	<!--- Forgot Password --->
        	<cfcase value="forgotPassword">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - AdminTool - Password Reminder';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetUserInfo.firstName# #qGetUserInfo.lastName#-</p>

                    Please see below your login information: <br /><br />
                    Email Address: #qGetUserInfo.email# <br />
                    Password: #qGetUserInfo.password# <br /><br />

                    Please visit <a href="#APPLICATION.SITE.URL.adminTool#" style="text-decoration:none; color:##0069aa;">#APPLICATION.SITE.URL.adminTool#</a> to login into the AdminTool. <br /><br />

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->
                </cfsavecontent>
            
            </cfcase>


        	<!--- Login Updated --->
        	<cfcase value="loginUpdated">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - AdminTool - Login Updated';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetUserInfo.firstName# #qGetUserInfo.lastName#-</p>

                    You have successfully updated your login information. Please see below: <br /><br />

                    Please visit <a href="#APPLICATION.SITE.URL.adminTool#" style="text-decoration:none; color:##0069aa;">#APPLICATION.SITE.URL.adminTool#</a> to login into the AdminTool. <br /><br />

                    Email Address: #qGetUserInfo.email# <br />
                    Password: #qGetUserInfo.password# <br /><br />

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    
                    <!--- For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br /> --->

                    #APPLICATION.SCHOOL.name# <br />
                    #APPLICATION.SCHOOL.address# <br />
                    #APPLICATION.SCHOOL.city#, #APPLICATION.SCHOOL.state# #APPLICATION.SCHOOL.zipCode# <br />
                    Phone: #APPLICATION.SCHOOL.phone# <br />
                    <!--- Toll Free: #APPLICATION.SCHOOL.tollFree# <br /> --->
                </cfsavecontent>
            
            </cfcase>

        </cfswitch>
        
        </cfoutput>
        
        <cfscript>
			return stEmailStructure;
		</cfscript>			        
	</cffunction>

	
	<cffunction name="sendEmail" access="public" returntype="void" hint="Sends email from the system with the MacDuffie header/footer">
        <cfargument name="emailFrom" type="string" default="#APPLICATION.EMAIL.support#" hint="Email From Address">
		<cfargument name="emailTo" type="string" required="true" hint="Email To is required">
		<cfargument name="emailReplyTo" type="string" default="" hint="Email Address to reply">
        <cfargument name="emailCC" type="string" default="" hint="Email CC Field">
        <cfargument name="emailSubject" type="string" default="" hint="Email Subject">
        <cfargument name="emailMessage" type="string" default="" hint="Email Message">
        <cfargument name="emailFilePath" type="string" default="" hint="Optional attachment file">
        <cfargument name="emailType" type="string" default="" hint="newAccount/forgotPassword/ - If passed gets the email text accordingly">
        <cfargument name="studentID" type="numeric" default="0" hint="Used with the emailType to get the student information">  
        <cfargument name="userID" type="numeric" default="0" hint="Used with the emailType to get the user information">        

		<!--- Import CustomTag --->
		<cfimport taglib="/extensions/customTags/gui/" prefix="gui" />	

		<cfscript>
			// Set Template Type - Application / AdminTool
			if ( VAL(ARGUMENTS.studentID) ) {
				pageHeader = 'email';
			} else if ( VAL(ARGUMENTS.userID) ) {
				pageHeader = 'AdminToolEmail';				
			}
			
			// If we have a valid studentID and emailType we'll get the email subject and message from  the function above
			if ( LEN(ARGUMENTS.emailType) AND VAL(ARGUMENTS.studentID) ) {
				stGetEmailTemplate = getEmailTemplate(emailType=ARGUMENTS.emailType, studentID=ARGUMENTS.studentID);
				ARGUMENTS.emailSubject = stGetEmailTemplate.subject;
				ARGUMENTS.emailMessage = stGetEmailTemplate.message;
			// Admin Tool Email Templates
			} else if ( LEN(ARGUMENTS.emailType) AND VAL(ARGUMENTS.userID) ) {
				stGetEmailTemplate = getAdminEmailTemplate(emailType=ARGUMENTS.emailType, userID=ARGUMENTS.userID);
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
                headerType="#pageHeader#"
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