<cfcomponent>

	<cffunction name="send_mail" access="public" returntype="void">
        <cfargument name="emailFrom" default="#SESSION.COMPANY.EMAIL.support#" required="true">
		<cfargument name="emailTo" type="string" required="true">
		<cfargument name="email_subject" type="string" required="true">
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="email_replyto" type="string" required="false" default="#SESSION.COMPANY.EMAIL.support#">
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
        <cfargument name="email_file4" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="email_file5" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="email_file6" type="string" required="false" default="" hint="optional attachment">

    	<cfscript>
			var vEmailTemplate = '';
			var get_user = '';
			
			// This is used to store email information when system sends an email on a development environment
			var emailIntendedTo = '';
			
			qGetCompanyInfo = APPLICATION.CFC.COMPANY.getCompanies(companyID=SESSION.COMPANY.ID);
			
			// Development Environment - If under development email current user so no emails are sent by mistake to field or Intl. Representative
			if ( APPLICATION.isServerLocal ) {
				
				emailIntendedTo = emailIntendedTo & "<p>Email To: #ARGUMENTS.emailTo#</p>";
				
				ARGUMENTS.emailTo = SESSION.COMPANY.EMAIL.support;
				
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
		<cfsavecontent variable="vEmailTemplate">
			
			<!--- Email Header --->
			<style type="text/css">
                <!--
                table,tr,td				{font-family:Arial, Helvetica, sans-serif;}
                .thin-border			{border: 4px solid #000000;}
                -->
            </style>
            
            <cfoutput>
            
                <div class="thin-border">
                    <table background="#SESSION.COMPANY.exitsURL#nsmg/pics/email_textured_background.png" width="700px">
                        <tr>
                            <td width="94"><img src="#SESSION.COMPANY.exitsURL#nsmg/pics/logos/#SESSION.COMPANY.ID#_header_logo.png"></td>
                            <td><strong><font size=+2>#SESSION.COMPANY.name#</font></strong></td>
                        </tr>	
                        <tr>
                            <td colspan="2"><img src="#SESSION.COMPANY.exitsURL#nsmg/pics/logos/#SESSION.COMPANY.ID#_px.png" height="12" width="100%"></td>
                        </tr>
                    </table>
                    
                    <!--- Email Body --->
                    <table width="700px">
                        <tr>
                            <td>
    
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
                                
                                <!--- Email Message --->
                               #ARGUMENTS.email_message#
                
                            </td>
                        </tr>
                	</table>    
                	
                    <!--- Email Footer --->
                    <table width="700px">
                    	<tr>
                        	<td>
                            	<a href="#SESSION.COMPANY.siteURL#">#SESSION.COMPANY.siteURL#</a>
                            </td>
                        </tr>
                        <tr>
                        	<td bgcolor="#SESSION.COMPANY.color#" align="center">
                            	<font color="##FFFFFF" size=-2>
									<cfif LEN(qGetCompanyInfo.toll_free)>Toll-free: #qGetCompanyInfo.toll_free# &middot;</cfif>
                                    <cfif LEN(qGetCompanyInfo.phone)>Local: #qGetCompanyInfo.phone# &middot;</cfif> 
                                    <cfif LEN(qGetCompanyInfo.fax)>Fax: #qGetCompanyInfo.fax#</cfif> 
                               	</font>
                            </td>
                        </tr>
                    </table>
            	</div>

			</cfoutput>                
                                                    
        </cfsavecontent>
                
		<cfmail to="#ARGUMENTS.emailTo#" from="#ARGUMENTS.emailFrom#" replyto="#ARGUMENTS.email_replyto#" cc="#ARGUMENTS.email_cc#" bcc="#ARGUMENTS.email_bcc#" subject="#ARGUMENTS.email_subject#" type="html">

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

            <cfif LEN(ARGUMENTS.email_file4)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file4#">                
            </cfif>
            
            <cfif LEN(ARGUMENTS.email_file5)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file5#">                
            </cfif>
            
            <cfif LEN(ARGUMENTS.email_file6)>
				<cfmailparam disposition="attachment" file="#ARGUMENTS.email_file6#">                
            </cfif>

            <!--- Email Template --->
            #vEmailTemplate#

        </cfmail>

	</cffunction>

</cfcomponent>