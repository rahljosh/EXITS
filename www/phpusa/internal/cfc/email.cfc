<cfcomponent>

	<!--- called by: forms/pr_reject.cfm, forms/pr_email.cfm --->
	<cffunction name="send_mail" access="public" returntype="void">
        <cfargument name="email_from" default="#APPLICATION.EMAIL.support#" required="true">
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
        
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="#CLIENT.email#">
        <cfargument name="email_cc" type="string" required="false" default="">
                
		<!--- message is optional because include_content may be used instead. --->
		<cfargument name="email_message" type="string" required="false" default="">
        
		<!--- the following are used for specific emails in email_template.cfm. --->
		<cfargument name="include_content" type="string" required="false" default="">
		<cfargument name="userid" type="string" required="false" default="">

		<!--- optional attachment. --->
		<cfargument name="email_file" type="string" required="false" default="">

		<cfset var template_file = ''>
        <cfset var get_user = ''>

		<!--- Create Email Body --->
		<cfsavecontent variable="template_file">
			
            <cfinclude template="../email/email_top.cfm">
            
            <cfinclude template="../email/email_template.cfm">
		
        	<cfinclude template="../email/email_bottom.cfm">
        
        </cfsavecontent>
	
                
		<cfmail to="#ARGUMENTS.email_to#" from="#ARGUMENTS.email_from#" replyto="#ARGUMENTS.email_replyto#" cc="#ARGUMENTS.email_cc#" subject="#ARGUMENTS.email_subject#" type="html">

            <!--- Attach File --->
			<cfif LEN(ARGUMENTS.email_file)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file#">                
            </cfif>
			
            <!--- Email Body --->
            #template_file#
            
        </cfmail>

	</cffunction>

</cfcomponent>