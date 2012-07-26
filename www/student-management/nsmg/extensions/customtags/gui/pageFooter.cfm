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
        
	<cfparam 
		name="ATTRIBUTES.width"
		type="string"
        default="100%"
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
            
                <div align="center" style="margin-top:15px;">
                    <img src="#ATTRIBUTES.filePath#pics/logos/#ATTRIBUTES.companyID#_px.png" width="#ATTRIBUTES.width#" height="10">
                    
                    <span style="display:block;">
                    	Copyright &copy; #Year(now())# 
                        &nbsp; :: &nbsp;
                        #CLIENT.companyname# 
                        &nbsp; :: &nbsp; 
                        Printed on #dateformat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:ss:tt')# EST 
                    </span>

	                <img src="#ATTRIBUTES.filePath#pics/logos/#ATTRIBUTES.companyID#_px.png" width="#ATTRIBUTES.width#" height="1">
                </div>
                
            </cfcase>
            
            
            <!--- Print Document Item Footer - Used for PDF or Flash Paper --->
            <cfcase value="printDocumentItem">
            	
                <div class="blueThemeReportDocumentItemFooter">
                	
                    <div class="top" style="width:#ATTRIBUTES.width#;"></div>
                    
                    <span>
                    	Copyright &copy; #Year(now())# 
                        &nbsp; :: &nbsp;
                        #CLIENT.companyname# 
                        &nbsp; :: &nbsp; 
                        Printed on #dateformat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:ss:tt')# EST 
                    </span>
                    
                    <div class="bottom" style="width:#ATTRIBUTES.width#"></div>
                
                </div>
                
            </cfcase>

    		
            <!--- Email Footer --->
            <cfcase value="email">


            </cfcase>
            
            
            <!--- No Footer --->
            <cfcase value="noFooter">

            </cfcase>
            
        </cfswitch>
    
    </body>
    </html>
    
    </cfoutput>
            
</cfif>