<cfcomponent>
	
    <!--- Email Header --->
    <cfsavecontent variable="emailHeader">
    
        <style type="text/css">
        	<!--
			table,tr,td				{font-family:Arial, Helvetica, sans-serif;}
			.smlink         		{font-size: 10px;}
			.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6; border-left: 2px solid #c6c6c6; border-bottom: 0px; background: #ffffff;}
			.sideborders			{border-right: 2px solid #c6c6c6; border-left: 2px solid #c6c6c6; background: #ffffff;}
			.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
			.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
			.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
			.sectionSubHead			{font-size:11px; font-weight:bold;}
			.thin-border			{border: 4px solid ##000000;}
			.thin-border-bottom		{border-bottom: 1px solid #000000;}
        	-->
        </style>
        
        <cfoutput>
        
        <div class="thin-border">
        
            <table background="#SESSION.COMPANY.exitsURL#/nsmg/pics/email_textured_background.png" width="600">
        		<tr>        
        			<td width=94>
                    	<img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/logos/#SESSION.COMPANY.ID#_header_logo.png">
                    </td>
					<td align="center" style="font-weight:bold;">
						<cfif SESSION.COMPANY.ID EQ 10>
                            <font size="+2">
                            	CULTURAL ACADEMIC <br /> 
                                <font color="###SESSION.COMPANY.color#">STUDENT EXCHANGE</font>                            
                            </font>
                        <cfelse>
                            <font size="+2">
                            	INTERNATIONAL 
                                <font color="###SESSION.COMPANY.color#">STUDENT EXCHANGE</font>
                             </font>
                        </cfif>
					</td>
                </tr>	        
        		<tr>
                	<td colspan="2"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/logos/#SESSION.COMPANY.ID#_px.png" height="12" width="100%"></td>	
	        	</tr>
                
        	</table>
        	
            <!----Email message goes here---->
        	<table width="600">
        		<tr>
			        <td>
        			
                    
		</cfoutput>

    </cfsavecontent>
    

    <!--- Email Footer --->
    <cfsavecontent variable="emailFooter">
		
        <cfoutput>
    
                    </td>
                </tr>
            </table>
            <!---- End of Email message goes here---->

            <table width="600">
            	<tr>
                	<td bgcolor="###SESSION.COMPANY.color#" align="center" style="font-weight:bold; padding:3px;">
                    	<font color="##FFFFFF" size=-2>
                            <cfif LEN(SESSION.COMPANY.tollFree)>Toll-free: #SESSION.COMPANY.tollFree# &middot;</cfif>
                            <cfif LEN(SESSION.COMPANY.phone)> Local: #SESSION.COMPANY.phone# &middot;</cfif> 
                            <cfif LEN(SESSION.COMPANY.fax)>Fax: #SESSION.COMPANY.fax#</cfif>
                        </font>
                    </td>
                </tr>
            </table>
    
        </div>
        
        </cfoutput>
        
    </cfsavecontent>

    
	<cffunction name="sendEmail" access="public" returntype="void">
        <cfargument name="email_from" default="#SESSION.COMPANY.supportEmail#" required="true">
		<cfargument name="email_to" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="#SESSION.COMPANY.supportEmail#">
        <cfargument name="email_cc" type="string" required="false" default="">
        <cfargument name="email_bcc" type="string" required="false" default=""  hint="optional bcc">
		<!--- message is optional because include_content may be used instead. --->
		<cfargument name="email_message" type="string" required="false" default="">
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

            <cfoutput>
			
				<!--- Include Email Header --->
                #emailHeader#
                
                <!--- Email Message --->
                <p>#ARGUMENTS.email_message#</p>
    
                <!--- Display Email Recipients when sending from development environment --->
                <cfif APPLICATION.isServerLocal>
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
                </cfif>
            
                <!--- Include Email Footer --->
                #emailFooter#
			
            </cfoutput>
        </cfmail>

	</cffunction>

</cfcomponent>