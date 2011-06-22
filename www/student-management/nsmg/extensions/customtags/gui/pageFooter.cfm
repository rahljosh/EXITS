<!--- ------------------------------------------------------------------------- ----
	
	File:		pageFooter.cfm
	Author:		Marcus Melo
	Date:		February 23, 2011
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
        default="#CLIENT.companyID#"
		/>

	<cfparam 
		name="ATTRIBUTES.filePath"
		type="string"
        default="../"
		/>
        
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>
   	
        <!--- Footer Type --->
        <cfswitch expression="#ATTRIBUTES.footerType#">

            <!--- Login Footer --->
            <cfcase value="login">
            
            </cfcase>

        
            <!--- Application Footer --->
            <cfcase value="application">
    			
                <cfif ATTRIBUTES.companyID EQ 11>
	                <!--- WEP --->
                    <div align="center" style="margin-top:20px;">
                        <img src="#ATTRIBUTES.filePath#pics/wep-footer.jpg" height=20  />
	                </div>
                <cfelse>
					<!--- Other Companies --->
                    
	                <img src="#ATTRIBUTES.filePath#pics/logos/#ATTRIBUTES.companyID#_px.png" width="100%" height="12"  style="margin-top:20px;">
                
                	<div align="center">
                        Copyright &copy; #Year(now())# &nbsp; :: &nbsp; #CLIENT.companyname# &nbsp; :: &nbsp; Powered by 
                        <font face="Arial" color="##000">
                        	<a href="http://www.exitgroup.org/" target="_blank">
                                E<font color="orange" style="font-weight:bold;">X</font>ITS
                            </a>
                        </font>
                    </div>
                    
                    <img src="#ATTRIBUTES.filePath#pics/logos/#ATTRIBUTES.companyID#_px.png" width="100%" height="1">
                </cfif>
                
            </cfcase>


            <!--- Print Footer --->
            <cfcase value="print">
            
                
            </cfcase>

    		
            <!--- Email Footer --->
            <cfcase value="email">


            </cfcase>
            
        </cfswitch>
    
    </body>
    </html>
    
    </cfoutput>
            
</cfif>