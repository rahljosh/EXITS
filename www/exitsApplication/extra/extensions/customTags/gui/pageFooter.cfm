<!--- ------------------------------------------------------------------------- ----
	
	File:		pageFooter.cfm
	Author:		Marcus Melo
	Date:		June 15, 2010
	Desc:		This Tag displays the page footer used in the login and student
				application.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
		<!--- Page Footer --->
		<gui:pageFooter
			footerType="login/application/print/email"
		/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
	<cfparam 
		name="ATTRIBUTES.footerType"
		type="string"
        default=""
		/>

	<cfparam 
		name="ATTRIBUTES.companyID"
		type="integer"
        default="0"
		/>

	<cfscript>
		if ( NOT VAL(ATTRIBUTES.companyID) ) {
		
			// Get what company candidate/user is logged in
			if ( StructKeyExists(SESSION.CANDIDATE, "companyID") AND VAL(SESSION.CANDIDATE.companyID) ) {
				ATTRIBUTES.companyID = SESSION.CANDIDATE.companyID;
			} else if ( StructKeyExists(CLIENT, "companyID") AND VAL(CLIENT.companyID) ) {
				ATTRIBUTES.companyID = CLIENT.companyID;
			}
		
		}
	</cfscript>
        
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>

        <!--- Set Up Footer Information According to Program --->
        <cfswitch expression="#ATTRIBUTES.companyID#">
    
			<!--- Trainee --->
            <cfcase value="7">
            
                <cfsavecontent variable="csbEmailFooter">
                	<b>Questions?</b>
                    <br/>
					For all new users, there is a brief tutorial available once EXTRA is accessed. If you have any questions about filling out the online application please contact us at
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    For technical issues please email support at support@student-management.com
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                
                    #APPLICATION.CSB.Trainee.name# <br />
                    #APPLICATION.CSB.Trainee.programName# <br />
                    #APPLICATION.CSB.Trainee.address# <br />
                    #APPLICATION.CSB.Trainee.city#, #APPLICATION.CSB.Trainee.state# #APPLICATION.CSB.Trainee.zipCode# <br />
                    Phone: #APPLICATION.CSB.Trainee.phone# <br />
                    Toll Free: #APPLICATION.CSB.Trainee.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
                             
            </cfcase>
            
            <!--- WAT --->
            <cfcase value="8">
        
                <cfsavecontent variable="csbEmailFooter">
                    <b>Questions?</b>
                    <br/>
					For all new users, there is a brief tutorial available once EXTRA is accessed. If you have any questions about filling out the online application please contact us at
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    For technical issues please email support at 
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />
                
                    #APPLICATION.CSB.WAT.name# <br />
                    #APPLICATION.CSB.WAT.programName# <br />
                    #APPLICATION.CSB.WAT.address# <br />
                    #APPLICATION.CSB.WAT.city#, #APPLICATION.CSB.WAT.state# #APPLICATION.CSB.WAT.zipCode# <br />
                    Phone: #APPLICATION.CSB.WAT.phone# <br />
                    Toll Free: #APPLICATION.CSB.WAT.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>
    
            </cfcase>
            
            <!--- Default Footer --->
            <cfdefaultcase>
            
                <cfsavecontent variable="csbEmailFooter">
                    <b>Questions?</b>
                    <br/>
					For all new users, there is a brief tutorial available once EXTRA is accessed. If you have any questions about filling out the online application please contact us at
                    <a href="mailto:#APPLICATION.EMAIL.contactUs#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.contactUs#</a> <br /><br />
                    For technical issues please email support at
                    <a href="mailto:#APPLICATION.EMAIL.support#" style="text-decoration:none; color:##0069aa;">#APPLICATION.EMAIL.support#</a> <br /><br />

                    #APPLICATION.CSB.name# <br />
                    #APPLICATION.CSB.address# <br />
                    #APPLICATION.CSB.city#, #APPLICATION.CSB.state# #APPLICATION.CSB.zipCode# <br />
                    Phone: #APPLICATION.CSB.phone# <br />
                    Toll Free: #APPLICATION.CSB.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 
                </cfsavecontent>   
                               
            </cfdefaultcase>
        
        </cfswitch>                            
    	
        <!--- Footer Type --->
        <cfswitch expression="#ATTRIBUTES.footerType#">

            <!--- Login Footer --->
            <cfcase value="login">
            
            </cfcase>

        
            <!--- Application Footer --->
            <cfcase value="application,extra">
    			
                <!--- End of <div class="wrapper"> placed on the header --->
                </div> <!-- End of <div class="wrapper"> placed on the header -->   
                
                <div class="pageFooter">
                    <div class="footerText">Copyright &copy; #Year(now())# #APPLICATION.CSB.name#. ALL RIGHTS RESERVED.</div>
                </div>
                
            </cfcase>


            <!--- Print Footer --->
            <cfcase value="print">
            
                <div class="pageFooter">
                    <div class="footerText">Copyright &copy; #Year(now())# #APPLICATION.CSB.name#. ALL RIGHTS RESERVED.</div>
                </div>
                
            </cfcase>

    		
            <!--- Email Footer --->
            <cfcase value="email">

                    #csbEmailFooter#

                </div>  <!--- End of class="form-container" --->
				
                <!--- Trainee - Display CSB Footer --->
                <cfif ATTRIBUTES.companyID EQ 7>

                    <div style="width:100%; height:20px; background-color:##0054A0;">
                        <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                            Copyright &copy; #Year(now())# #APPLICATION.CSB.Trainee.name#. ALL RIGHTS RESERVED.
                        </div>
                    </div>
                
                <!--- Work and Travel - Display CSB Footer --->
                <cfelse>
                
                    <div style="width:100%; height:20px; background-color:##FF7E0D;">
                        <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                            Copyright &copy; #Year(now())# #APPLICATION.CSB.name#. ALL RIGHTS RESERVED.
                        </div>
                    </div>
				
				</cfif>
                
            </cfcase>


            <!--- Email Regular Footer / It does not include the technical support information --->
            <cfcase value="emailRegular">

                    #APPLICATION.CSB.WAT.name# <br />
                    #APPLICATION.CSB.WAT.programName# <br />
                    #APPLICATION.CSB.WAT.address# <br />
                    #APPLICATION.CSB.WAT.city#, #APPLICATION.CSB.WAT.state# #APPLICATION.CSB.WAT.zipCode# <br />
                    Phone: #APPLICATION.CSB.WAT.phone# <br />
                    Toll Free: #APPLICATION.CSB.WAT.toolFreePhone# <br /> 
                    <a href="#APPLICATION.SITE.URL.main#">#APPLICATION.SITE.URL.main#</a> <br /> 

                    <p style="font-size:11px; color:##666;">
                        CONFIDENTIALITY NOTE: The information contained in this message and the attached files are restricted to the use of addressee, and may contain privileged 
                        or commercial information, copyright, or other confidential information protected by law. If the reader of this message is not the intended recipient, 
                        please notify the sender immediately and delete it from your system at once, since any disclosure, distribution,  and copy of this communication 
                        is strictly prohibited and not authorized. Thank you.                
                    </p>

                </div>  <!--- End of class="form-container" --->

                <!--- Trainee - Display CSB Footer --->
                <cfif ATTRIBUTES.companyID EQ 7>

                    <div style="width:100%; height:20px; background-color:##0054A0;">
                        <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                            Copyright &copy; #Year(now())# #APPLICATION.CSB.Trainee.name#. ALL RIGHTS RESERVED.
                        </div>
                    </div>
                
                <!--- Work and Travel - Display CSB Footer --->
                <cfelse>
                
                    <div style="width:100%; height:20px; background-color:##FF7E0D;">
                        <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                            Copyright &copy; #Year(now())# #APPLICATION.CSB.name#. ALL RIGHTS RESERVED.
                        </div>
                    </div>
				
				</cfif>

            </cfcase>

            <!--- emailNoInfo / It does not include additional information --->
            <cfcase value="emailNoInfo">

                    <p style="font-size:11px; color:##666;">
                        CONFIDENTIALITY NOTE: The information contained in this message and the attached files are restricted to the use of addressee, and may contain privileged 
                        or commercial information, copyright, or other confidential information protected by law. If the reader of this message is not the intended recipient, 
                        please notify the sender immediately and delete it from your system at once, since any disclosure, distribution,  and copy of this communication 
                        is strictly prohibited and not authorized. Thank you.                
                    </p>

                </div>  <!--- End of class="form-container" --->

                <!--- Trainee - Display CSB Footer --->
                <cfif ATTRIBUTES.companyID EQ 7>

                    <div style="width:100%; height:20px; background-color:##0054A0;">
                        <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                            Copyright &copy; #Year(now())# #APPLICATION.CSB.Trainee.name#. ALL RIGHTS RESERVED.
                        </div>
                    </div>
                
                <!--- Work and Travel - Display CSB Footer --->
                <cfelse>
                
                    <div style="width:100%; height:20px; background-color:##FF7E0D;">
                        <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                            Copyright &copy; #Year(now())# #APPLICATION.CSB.name#. ALL RIGHTS RESERVED.
                        </div>
                    </div>
				
				</cfif>

            </cfcase>
            
        </cfswitch>
    
    </body>
    </html>
    
    </cfoutput>
            
</cfif>
