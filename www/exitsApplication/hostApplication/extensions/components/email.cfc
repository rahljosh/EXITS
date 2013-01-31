<cfcomponent>

	<cffunction name="sendEmail" access="public" returntype="void">
        <cfargument name="emailFrom" default="#SESSION.COMPANY.EMAIL.support#" required="true">
		<cfargument name="emailTo" type="string" required="true">
		<cfargument name="emailSubject" type="string" required="true">
		<!--- the from address in the cfmail tag below is always the support address because emails from other domains are blocked.  use replyto if needed. --->
		<cfargument name="emailReplyTo" type="string" required="false" default="#SESSION.COMPANY.EMAIL.support#">
        <cfargument name="emailCC" type="string" required="false" default="">
        <cfargument name="emailBCC" type="string" required="false" default=""  hint="optional bcc">
		<!--- message is optional because include_content may be used instead. --->
		<cfargument name="emailMessage" type="string" required="false" default="">
		<!--- optional attachment. --->
		<cfargument name="emailFile1" type="string" required="false" default="" hint="optional attachment">
		<cfargument name="emailFile2" type="string" required="false" default="" hint="optional attachment">        
		<cfargument name="emailFile3" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile4" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile5" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile6" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile7" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile8" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile9" type="string" required="false" default="" hint="optional attachment">
        <cfargument name="emailFile10" type="string" required="false" default="" hint="optional attachment">

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
				
				if ( LEN(ARGUMENTS.emailCC) ) {
					emailIntendedTo = emailIntendedTo & "<p>Email CC: #ARGUMENTS.emailCC#</p>";
					ARGUMENTS.emailCC = '';
				}
				
				if ( LEN(ARGUMENTS.emailBCC) ) {
					emailIntendedTo = emailIntendedTo & "<p>Email BCC: #ARGUMENTS.emailBCC#</p>";
					ARGUMENTS.emailBCC = '';
					
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
                    <table background="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='exitsURL')#nsmg/pics/email_textured_background.png" width="700px">
                        <tr>
                            <td width="94"><img src="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='headerLogo')#" border="0"></td>
                            <td><strong><font size=+2>#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='name')#</font></strong></td>
                        </tr>	
                        <tr>
                            <td colspan="2"><img src="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='pxImage')#" height="12" width="100%" border="0"></td>
                        </tr>
                    </table>
                    
                    <!--- Email Body --->
                    <table width="700px">
                        <tr>
                            <td>
    
                                <!--- Email Message --->
                               #ARGUMENTS.emailMessage#
                               
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
                
                            </td>
                        </tr>
                	</table>    
                	
                    <!--- Email Footer --->
                    <table width="700px">
                    	<tr>
                        	<td>
                            	<a href="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='siteURL')#">#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='siteURL')#</a>
                            </td>
                        </tr>
                        <tr>
                        	<td bgcolor="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='color')#" align="center">
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
                
		<cfmail 
        	to="#ARGUMENTS.emailTo#" 
            from="#ARGUMENTS.emailFrom#" 
            replyto="#ARGUMENTS.emailReplyTo#" 
            cc="#ARGUMENTS.emailCC#" 
            bcc="#ARGUMENTS.emailBCC#" 
            subject="#ARGUMENTS.emailSubject#" 
            type="html">

				<!--- Attach File --->
                <cfif LEN(ARGUMENTS.emailFile1)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile1#">                
                </cfif>
                
                <cfif LEN(ARGUMENTS.emailFile2)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile2#">                
                </cfif>
                
                <cfif LEN(ARGUMENTS.emailFile3)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile3#">                
                </cfif>
    
                <cfif LEN(ARGUMENTS.emailFile4)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile4#">                
                </cfif>
                
                <cfif LEN(ARGUMENTS.emailFile5)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile5#">                
                </cfif>
                
                <cfif LEN(ARGUMENTS.emailFile6)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile6#">                
                </cfif>
                
                <cfif LEN(ARGUMENTS.emailFile7)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile7#">                
                </cfif>
    
                <cfif LEN(ARGUMENTS.emailFile8)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile8#">                
                </cfif>
    
                <cfif LEN(ARGUMENTS.emailFile9)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile8#">                
                </cfif>
    
                <cfif LEN(ARGUMENTS.emailFile10)>
                    <cfmailparam disposition="attachment" file="#ARGUMENTS.emailFile8#">                
                </cfif>
    
                <!--- Email Template --->
                #vEmailTemplate#

        </cfmail>

	</cffunction>

</cfcomponent>