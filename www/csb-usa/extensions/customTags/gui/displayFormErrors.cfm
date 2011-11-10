<!--- ------------------------------------------------------------------------- ----
	
	File:		displayFormErrors.cfm
	Author:		Marcus Melo
	Date:		June 16, 2010
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
 <link rel="stylesheet" media="all" type="text/css"href="../../../internal/linked/css/baseStyle.css" />
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
                
                    <table border="0" cellspacing="0" cellpadding="0" class="formErrors">
                    <tr>
                        <td class="errors">
                        
                            <!--- <div class="header">#ATTRIBUTES.Message#</div> --->
                            #ATTRIBUTES.Message#
                            <!--- <h4 style="color:red;">#ATTRIBUTES.Message#</h4> --->
                            
                            <!--- Loop over the messages --->
                            <ul class="list">
                                
                                <!--- Loop over the message --->
                                <cfloop from="1" to="#ArrayLen(ATTRIBUTES.formErrors)#" index="i">
                                   <li>#ATTRIBUTES.formErrors[i]#</li>        	
                                </cfloop>
        
                            </ul>
                            
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
            
				<!--- Error displayed on sections --->
                <cfcase value="section">
                    
                    <div class="errors">
                        <p><em>Oops... the following errors were encountered:</em></p>
                
                        <ul>
    
                            <!--- Loop over the message --->
                            <cfloop from="1" to="#ArrayLen(ATTRIBUTES.formErrors)#" index="i">
                               <li>#i#. &nbsp; #ATTRIBUTES.formErrors[i]#</li>        	
                            </cfloop>
    
                        </ul>
                        
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