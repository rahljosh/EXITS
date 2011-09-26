<cfcomponent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

	<!--- called by: forms/pr_reject.cfm, forms/pr_email.cfm --->
	<cffunction name="send_mail" access="public" returntype="void">
        <cfargument name="email_from" default="#APPLICATION.EMAIL.support#" required="true">
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked. use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="#CLIENT.email#">
        <cfargument name="email_cc" type="string" required="false" default=""  hint="optional cc">
        <cfargument name="email_bcc" type="string" required="false" default=""  hint="optional bcc">
		<!--- message is optional because include_content may be used instead. --->
		<cfargument name="email_message" type="string" required="false" default="">
		<!--- optional attachment. --->
		<cfargument name="email_file" type="string" required="false" default="" hint="optional attachment">
		<cfargument name="email_file2" type="string" required="false" default="" hint="optional attachment">        
		<cfargument name="email_file3" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="includeTemplate" type="numeric" default="1" hint="Set to 0 to not include header/footer">

    	<cfscript>
			// This is used to store email information when system sends an email on a development environment
			var emailIntendedTo = '';
			
			// Development Environment - If under development email current user so no emails are sent by mistake to field or Intl. Representative
			if ( APPLICATION.isServerLocal ) {
				
				emailIntendedTo = emailIntendedTo & "<p>Email To: #ARGUMENTS.email_to#</p>";
				
				ARGUMENTS.email_to = CLIENT.email;
				
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
			
            <!--- Email Body --->
          	<cfoutput>
            
                <cfif VAL(ARGUMENTS.includeTemplate)>
                    
                    <!--- Email Header --->
                    <gui:pageHeader
                        headerType="email"
                    />	
                    
                </cfif>
                
                <!--- Include Email Message --->            
                <cfif LEN(ARGUMENTS.email_message)>
                    <p>
                    	#ARGUMENTS.email_message# <br/ >
                    </p>
                </cfif>
    
                <!--- Display Email Recipients when sending from development environment --->
                <cfif APPLICATION.isServerLocal>
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                    	*********************************** DEVELOPMENT SITE ***********************************
                    </div>
                    
                    <p>
                    	You received this email insted of the original recipient(s) <br />
                    	because you are logged in the development environment.
                    </p>
                    
                    <p>Please see below original recipient(s) for this message</p>
                    
                    #emailIntendedTo#
                    
                    <div style="color:##F00; display:block; margin:10px 0px 10px 0px;">
                    	*********************************** DEVELOPMENT SITE ***********************************
                    </div>
                </cfif>
                
                <cfif VAL(ARGUMENTS.includeTemplate)>
					
                    <!--- Email Footer --->
                    <gui:pageFooter
                        footerType="email"
                    />
                    
                </cfif>
            
			</cfoutput>

        </cfmail>

	</cffunction>

</cfcomponent>