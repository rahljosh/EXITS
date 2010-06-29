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
			// There is nothing really to initiate, so just return this
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

                    You have successfully created an account at #APPLICATION.SCHOOL.name#. <br><br>

                    You can start your application at any time and do not need to complete it all at once. <br>                
                    Once submitted, the application can no longer be edited. <br><br>

                    Please visit <a href="#APPLICATION.SITE.URL.admissions#">#APPLICATION.SITE.URL.main#</a> to login into your application account. <br><br>

                    Please see below your login information: <br><br>
                    Email: #qGetStudentInfo.email#<br>
                    Password: #qGetStudentInfo.password# <br><br>

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#">#APPLICATION.EMAIL.contactUs#</a> <br><br>
                    
                    For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#">#APPLICATION.EMAIL.support#</a> <br><br>

                    #APPLICATION.SCHOOL.name# <br>
                    #APPLICATION.SCHOOL.address# <br>
                    Phone: #APPLICATION.SCHOOL.phone# <br>
                    Toll Free: #APPLICATION.SCHOOL.tollFree# <br>                    
                </cfsavecontent>
            
            </cfcase>
        
        	<!--- Forgot Password --->
        	<cfcase value="forgotPassword">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - Password Reminder';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>

                    Please see below your login information: <br><br>
                    Email Address: #qGetStudentInfo.email# <br>
                    Password: #qGetStudentInfo.password# <br><br>

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#">#APPLICATION.EMAIL.contactUs#</a> <br><br>
                    
                    For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#">#APPLICATION.EMAIL.support#</a> <br><br>

                    #APPLICATION.SCHOOL.name# <br>
                    #APPLICATION.SCHOOL.address# <br>
                    Phone: #APPLICATION.SCHOOL.phone# <br>
                    Toll Free: #APPLICATION.SCHOOL.tollFree# <br>                    
                </cfsavecontent>
            
            </cfcase>

        	<!--- Login Updated --->
        	<cfcase value="loginUpdated">

                <cfscript>
					stEmailStructure.subject = APPLICATION.SCHOOL.name & ' - Login Updated';
				</cfscript>

                <cfsavecontent variable="stEmailStructure.message">
                	<p>#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#-</p>

                    You have successfully updated your login information. Please see below: <br><br>

                    Email Address: #qGetStudentInfo.email# <br>
                    Password: #qGetStudentInfo.password# <br><br>

                    If you have any questions about the application please contact us at <a href="mailto:#APPLICATION.EMAIL.contactUs#">#APPLICATION.EMAIL.contactUs#</a> <br><br>
                    
                    For technical issues please email support at <a href="mailto:#APPLICATION.EMAIL.support#">#APPLICATION.EMAIL.support#</a> <br><br>

                    #APPLICATION.SCHOOL.name# <br>
                    #APPLICATION.SCHOOL.address# <br>
                    Phone: #APPLICATION.SCHOOL.phone# <br>
                    Toll Free: #APPLICATION.SCHOOL.tollFree# <br>                    
                </cfsavecontent>
            
            </cfcase>
        
        	<!--- Application Submitted --->
            
            
            <!--- Payment Processed --->
        
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
        <cfargument name="emailFile" type="string" default="" hint="Optional attachment file">
        <cfargument name="emailType" type="string" default="" hint="newAccount/forgotPassword/ - If passed gets the email text accordingly">
        <cfargument name="studentID" type="numeric" default="0" hint="Used with the emailType to get the student information">        

		<!--- Import CustomTag --->
		<cfimport taglib="/extensions/customtags/gui/" prefix="gui" />	

		<cfscript>
			// If we have a valid studentID and emailType we'll get the email subject and message from  the function above
			if ( LEN(ARGUMENTS.emailType) AND VAL(ARGUMENTS.studentID) ) {
				stGetEmailTemplate = getEmailTemplate(emailType=ARGUMENTS.emailType, studentID=ARGUMENTS.studentID);
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
			<cfif LEN(ARGUMENTS.emailFile)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile#">                
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