<!--- ------------------------------------------------------------------------- ----
	
	File:		pageFooter.cfm
	Author:		Marcus Melo
	Date:		June 15, 2010
	Desc:		This Tag displays the page footer used in the login and student
				application.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
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
        
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>
    
        <cfswitch expression="#ATTRIBUTES.footerType#">

            <!--- Login Footer --->
            <cfcase value="login">
            
            </cfcase>

        
            <!--- Application Footer --->
            <cfcase value="application">
    			
                </div> <!--- End of <div class="wrapper"> placed on the header --->
                
                <div class="pageFooter">
                    <div class="footerText">Copyright &copy; #Year(now())# #APPLICATION.SCHOOL.name#. ALL RIGHTS RESERVED.</div>
                </div>
                
            </cfcase>


            <!--- Print Footer --->
            <cfcase value="print">
            
            </cfcase>

    		
            <!--- Email Footer --->
            <cfcase value="email">
					
                </div>  <!--- End of class="form-container" --->

                <div style="width:100%; height:20px; background-color:##0069aa;">
                    <div style="color:##FFF; text-align:center; font-size:0.7em; font-weight:bold; padding-top:0.3em;">
                    	Copyright &copy; #Year(now())# #APPLICATION.SCHOOL.name#. ALL RIGHTS RESERVED.
                    </div>
                </div>

            </cfcase>
            
        </cfswitch>
    
    </body>
    </html>
    
    </cfoutput>
            
</cfif>