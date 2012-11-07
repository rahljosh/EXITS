<cfcomponent>

    <cfparam name="CLIENT.name" default="Support">
    <cfparam name="CLIENT.companyname" default="EXITS Application">
    <cfparam name="CLIENT.email" default="support@exitsapplication.com">
    <cfparam name="CLIENT.site_url" default="http://www.exitsapplication.com">
    <cfparam name="CLIENT.companyid" default="0">
    <cfparam name="CLIENT.support_email" default="support@exitsapplication.com">

	<!--- called by: 
		forms/user_form.cfm, 
		user_info.cfm, 
		flash/login.cfm (forget password form), 
		forms/pr_reject.cfm, 
		forms/pr_email.cfm app_process/finalize_transfer.cfm, 		
		student_app/resendEmail.cfm
        student_app/querys/start_student.cfm
        student_app/querys/qr_deny_application.cfm
        student_app/querys/help_desk
        student_app/student_assign_pass
        student_app/error_message.cfm
        student_app/email_form.cfm
        student_app_received
    --->

	<cffunction name="send_mail" access="public" returntype="void">
        <cfargument name="email_from" default="#CLIENT.support_email#" required="true">
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked. use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="#CLIENT.email#">
        <cfargument name="email_cc" type="string" required="false" default=""  hint="optional cc">
        <cfargument name="email_bcc" type="string" required="false" default=""  hint="optional bcc">
		<!--- message is optional because include_content may be used instead. --->
		<cfargument name="email_message" type="string" required="false" default="">
		<!--- the following are used for specific emails in email_template.cfm. --->
		<cfargument name="include_content" type="string" required="false" default="">
		<cfargument name="userid" type="string" required="false" default="">
		<!--- optional attachment. --->
		<cfargument name="email_file" type="string" required="false" default="" hint="optional attachment">
		<cfargument name="email_file2" type="string" required="false" default="" hint="optional attachment">        
		<cfargument name="email_file3" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="email_file4" type="string" required="false" default="" hint="optional attachment">        
		<cfargument name="email_file5" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="email_file6" type="string" required="false" default="" hint="optional attachment">        
		<cfargument name="email_file7" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="email_file8" type="string" required="false" default="" hint="optional attachment">        
		<cfargument name="email_file9" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="email_file10" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="includeTemplate" type="numeric" default="1" hint="Set to 0 to not include header/footer">

    	<cfscript>
			var template_file = '';
			var get_user = '';
			
			// This is used to store email information when system sends an email on a development environment
			var emailIntendedTo = '';
			
			// Development Environment - If under development email current user so no emails are sent by mistake to field or Intl. Representative
			if ( APPLICATION.isServerLocal ) {
				
				emailIntendedTo = emailIntendedTo & "<p>Email To: #ARGUMENTS.email_to#</p>";
				
				// IT / Office
				if ( ListFind("1,2,3", CLIENT.userType) ) {
					ARGUMENTS.email_to = CLIENT.email;	  
				} else {
					ARGUMENTS.email_to = 'support@case-usa.org';
				}
				
				if ( LEN(ARGUMENTS.email_cc) ) {
					emailIntendedTo = emailIntendedTo & "<p>Email CC: #ARGUMENTS.email_cc#</p>";
					ARGUMENTS.email_cc = '';
				}
				
				if ( LEN(ARGUMENTS.email_bcc) ) {
					emailIntendedTo = emailIntendedTo & "<p>Email BCC: #ARGUMENTS.email_bcc#</p>";
					ARGUMENTS.email_bcc = '';
					
				}
				
			}
		</cfscript>

		<!--- Create Email Body --->
        <cfsavecontent variable="template_file">
          	<cfoutput>

				<!--- Email Header --->
                <cfif VAL(ARGUMENTS.includeTemplate)>
                    <cfinclude template="../email/email_top.cfm">
                </cfif>
                
                <!--- Include Email Message --->            
                <cfif LEN(ARGUMENTS.email_message)>
                    #ARGUMENTS.email_message# <br/ > <br />
                </cfif>
    
                <!--- Display Email Recipients when sending from development environment --->
                <cfif APPLICATION.isServerLocal>
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                    	****************************************** DEVELOPMENT SITE ******************************************
                    </div>
                    
                    <p>
                    	You received this email insted of the original recipient(s) 
                    	because you are logged in the development environment.
                    </p>
                    
                    <p>Please see below the original recipient(s) for this message</p>
                    
                    #emailIntendedTo#
                    
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                    	****************************************** DEVELOPMENT SITE ******************************************
                    </div>
                </cfif>
                
                <!--- Email Template --->       
                <cfinclude template="../email/email_template.cfm">
                
                <!--- Email Footer --->
                <cfif VAL(ARGUMENTS.includeTemplate)>
                    <cfinclude template="../email/email_bottom.cfm">
                </cfif>
            
			</cfoutput>
        </cfsavecontent>
          
            
		<cfmail to="#ARGUMENTS.email_to#" from="#ARGUMENTS.email_from#" replyto="#ARGUMENTS.email_replyto#" cc="#ARGUMENTS.email_cc#" bcc="#ARGUMENTS.email_bcc#" subject="#ARGUMENTS.email_subject#" type="html">
			
            
            <!--- Attach File --->
			<cfif LEN(ARGUMENTS.email_file)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file#">                
            </cfif>

            <!--- Attach File 2 --->
			<cfif LEN(ARGUMENTS.email_file2)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file2#">                
            </cfif>

            <!--- Attach File 3 --->
			<cfif LEN(ARGUMENTS.email_file3)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file3#">                
            </cfif>
			  <!--- Attach File 4 --->
			<cfif LEN(ARGUMENTS.email_file4)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file4#">                
            </cfif>
			  <!--- Attach File 5 --->
			<cfif LEN(ARGUMENTS.email_file5)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file5#">                
            </cfif>
 		    <!--- Attach File 6 --->
			<cfif LEN(ARGUMENTS.email_file6)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file6#">                
            </cfif>
            <!--- Attach File 7 --->
			<cfif LEN(ARGUMENTS.email_file7)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file7#">                
            </cfif>
            <!--- Attach File 8 --->
			<cfif LEN(ARGUMENTS.email_file8)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file8#">                
            </cfif>
            <!--- Attach File 9 --->
			<cfif LEN(ARGUMENTS.email_file9)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file9#">                
            </cfif>
            <!--- Attach File 10 --->
			<cfif LEN(ARGUMENTS.email_file10)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file10#">                
            </cfif>
            <!--- Email Body --->
            #template_file#

        </cfmail>

	</cffunction>

</cfcomponent>