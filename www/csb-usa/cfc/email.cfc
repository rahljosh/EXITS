<cfcomponent>

    <cfparam name="CLIENT.name" default="Support">
    <cfparam name="CLIENT.companyname" default="MEMA">
    <cfparam name="CLIENT.email" default="Faith Mayer <Faith.E.Mayer@maine.gov>">
    <cfparam name="CLIENT.site_url" default="">
    <cfparam name="CLIENT.companyid" default="0">
    <cfparam name="CLIENT.support_email" default="Faith Mayer <Faith.E.Mayer@maine.gov>">

	<cffunction name="send_mail" access="public" returntype="void">
        <cfargument name="email_from" default="Faith Mayer <Faith.E.Mayer@maine.gov>" required="true">
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
        
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="Faith Mayer <Faith.E.Mayer@maine.gov>">
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
            
             <cfoutput>#ARGUMENTS.email_message#</cfoutput>
        	<cfinclude template="../email/email_bottom.cfm">
        
        </cfsavecontent>
                
                
		<cfmail to="#email_to#" from="#email_from#" replyto="#email_replyto#" cc="#email_cc#" subject="#email_subject#" type="html">

            <!--- Attach File --->
			<cfif LEN(ARGUMENTS.email_file)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file#">                
            </cfif>
			
            <!--- Email Body --->
            #template_file#

        </cfmail>

	</cffunction>

</cfcomponent>