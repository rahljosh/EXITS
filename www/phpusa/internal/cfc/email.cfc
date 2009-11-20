<cfcomponent>

	<!--- called by: forms/pr_reject.cfm, forms/pr_email.cfm --->
	<cffunction name="send_mail" access="public" returntype="void">
    
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
		<cfargument name="email_message" type="string" required="true">
        
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="">
        
		<!--- optional attachment. --->
		<cfargument name="email_file" type="string" required="false" default="">

		<cfset var template_file = ''>

		<cfsavecontent variable="template_file">
			<cfinclude template="../email_template.cfm">
		</cfsavecontent>
                
		<cfmail to="#email_to#" from="support@phpusa.com" replyto="#email_replyto#" subject="#email_subject#" type="html">
        	<cfif email_file NEQ ''>
            	<cfmailparam file="#email_file#">
            </cfif>
        	#template_file#
        </cfmail>

	</cffunction>

</cfcomponent>