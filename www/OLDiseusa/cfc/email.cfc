<cfcomponent>

    <cfparam name="CLIENT.name" default="Support">
    <cfparam name="CLIENT.companyname" default="International Student Exchange">
    <cfparam name="CLIENT.email" default="support@iseusa.com">
    <cfparam name="CLIENT.site_url" default="http://www.iseusa.com">
    <cfparam name="CLIENT.companyid" default="0">
    <cfparam name="CLIENT.support_email" default="support@iseusa.com">

	<!--- called by: forms/user_form.cfm, user_info.cfm, flash/login.cfm (forget password form), forms/pr_reject.cfm, forms/pr_email.cfm app_process/finalize_transfer.cfm, student_app/resend_elcome_student.cfm, student_app/querys/resend_welcome_student.cfm
        student_app/querys/start_student.cfm
        student_app/querys/qr_deny_application.cfm
        student_app/querys/help_desk
        student_app/student_assign_pass
        student_app/error_message.cfm
        student_app/email_form.cfm
        student_app_app_recived
    --->

	<cffunction name="send_mail" access="public" returntype="void">
        <cfargument name="email_from" default="#CLIENT.support_email#" required="true">
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="#CLIENT.email#">
        <cfargument name="email_cc" type="string" required="false" default="">
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

    	<cfscript>
			var template_file = '';
			var get_user = '';
			
			// This is used to store email information when system sends an email on a development environment
			var emailIntendedTo = '';
			
			// Development Environment - If under development email current user so no emails are sent by mistake to field or Intl. Representative
			if ( APPLICATION.isServerLocal ) {
				
				emailIntendedTo = emailIntendedTo & "<p>Email To: #ARGUMENTS.email_to#</p>";
				
				ARGUMENTS.email_to = APPLICATION.EMAIL.support;
				
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
			
            <cfinclude template="../email/email_top.cfm">
            
            <cfinclude template="../email_template.cfm">

			<!--- Display Email Recipients when sending from development environment --->
            <cfif APPLICATION.isServerLocal>
                <cfoutput>
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                        ******************************* DEVELOPMENT SITE *******************************
                    </div>
                    
                    <p>
                        You received this email insted of the original recipient(s) 
                        because you are logged in the development environment.
                    </p>
                    
                    <p>Please see below the original recipient(s) for this message</p>
                    
                    #emailIntendedTo#
                    
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                        ******************************* DEVELOPMENT SITE *******************************
                    </div>
				</cfoutput>                    
            </cfif>
		
        	<cfinclude template="../email/email_bottom.cfm">
        
        </cfsavecontent>
                
		<cfmail to="#ARGUMENTS.email_to#" from="#ARGUMENTS.email_from#" replyto="#ARGUMENTS.email_replyto#" cc="#ARGUMENTS.email_cc#" bcc="#ARGUMENTS.email_bcc#" subject="#ARGUMENTS.email_subject#" type="html">

            <!--- Attach File --->
			<cfif LEN(ARGUMENTS.email_file)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file#">                
            </cfif>
            <cfif LEN(ARGUMENTS.email_file2)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file2#">                
            </cfif>
            <cfif LEN(ARGUMENTS.email_file3)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file3#">                
            </cfif>
			
            <!--- Email Body --->
            #template_file#

        </cfmail>

	</cffunction>

</cfcomponent>