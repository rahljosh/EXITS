<!--- ------------------------------------------------------------------------- ----
	
	File:		displayFormErrors.cfm
	Author:		Marcus Melo
	Date:		february 23, 2011
	Desc:		This tag is used to output form error messages

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
		
		<!--- Form Errors --->
		<gui:displayFormErrors 
			formErrors="formErrors"
			message="Please review the following:" 
			messageType="login/section"
			/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param tag attributes --->
    <cfparam 
    	name="ATTRIBUTES.formErrors" 
        type="array" />
        
    <cfparam 
    	name="ATTRIBUTES.Message" 
        type="string" 
        default="Please review the following:" />

    <cfparam 
    	name="ATTRIBUTES.messageType" 
        type="string" 
        default="section" />

	<cfparam name="ATTRIBUTES.width" 
    	type="string" 
        default="100%" />

	<cfparam name="ATTRIBUTES.Clear" 
    	type="boolean" 
        default="1" />
    
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(thistag.ExecutionMode, "Start")>

	
	<!--- Check to see if there are any messages to display --->
	<cfif ArrayLen(ATTRIBUTES.formErrors)>
	
		<cfoutput>
            
            <cfswitch expression="#ATTRIBUTES.messageType#">
			
				<!--- Error displayed on login --->
                <cfcase value="login">
                
                
                </cfcase>
            
            
				<!--- Error displayed on tableSection --->
                <cfcase value="tableSection">

					<table width="#ATTRIBUTES.width#" border="0" cellpadding="4" cellspacing="0" class="section formErrors" align="center">
                        <tr>
                            <td align="center">
                                <div class="errors">
                                    <p><em>Oops... the following errors were encountered:</em></p>
                            
                                    <ol>

                                        <!--- Loop over the message --->
                                        <cfloop from="1" to="#ArrayLen(ATTRIBUTES.formErrors)#" index="i">
                                           <li>#i#. &nbsp; #ATTRIBUTES.formErrors[i]#</li>        	
                                        </cfloop>
                
                                    </ol>
                                    
                                    <p>Data has <strong>NOT</strong> been saved.</p>
                                </div>
                            </td>
                        </tr>                        
					</table>

					<cfscript>
                        // Check to see if we are supposed to clear the queue 
                        if ( ATTRIBUTES.Clear ) {
							ATTRIBUTES.formErrors.Clear();
							SESSION.formErrors.Clear();
                        }
                    </cfscript>
                
                </cfcase>


				<!--- Error displayed on divOnly --->
                <cfcase value="divOnly">

                      <div class="errors">
                          <p><em>Oops... the following errors were encountered:</em></p>
                  
                          <ol>

                              <!--- Loop over the message --->
                              <cfloop from="1" to="#ArrayLen(ATTRIBUTES.formErrors)#" index="i">
                                 <li>#i#. &nbsp; #ATTRIBUTES.formErrors[i]#</li>        	
                              </cfloop>
      
                          </ol>
                          
                          <p>Data has <strong>NOT</strong> been saved.</p>
                      </div>

					<cfscript>
                        // Check to see if we are supposed to clear the queue 
                        if ( ATTRIBUTES.Clear ) {
							ATTRIBUTES.formErrors.Clear();
							SESSION.formErrors.Clear();
                        }
                    </cfscript>
                
                </cfcase>


				<!--- Online Application --->
                <cfcase value="onlineApplication">
					
                    
                    <div class="errors" style="width:#ATTRIBUTES.width#;">
                        <p><em>Oops... the following errors were encountered:</em></p>
                
                        <ol>

                            <!--- Loop over the message --->
                            <cfloop from="1" to="#ArrayLen(ATTRIBUTES.formErrors)#" index="i">
                               <li>#i#. &nbsp; #ATTRIBUTES.formErrors[i]#</li>        	
                            </cfloop>
    
                        </ol>
                        
                        <p>Data has <strong>NOT</strong> been saved.</p>
                    </div>
                    
					<cfscript>
                        // Check to see if we are supposed to clear the queue 
                        if ( ATTRIBUTES.Clear ) {
							ATTRIBUTES.formErrors.Clear();
							SESSION.formErrors.Clear();
                        }
                    </cfscript>
                
                </cfcase>
             
             </cfswitch>
                       
		</cfoutput>
    	
	</cfif>
			
</cfif>