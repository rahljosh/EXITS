<!--- ------------------------------------------------------------------------- ----
	
	File:		displayPageMessages.cfm
	Author:		Marcus Melo
	Date:		June 28, 2010
	Desc:		This tag is used to output page messages

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
		
		<!--- Page Messages --->
		<gui:displayPageMessages 
			pageMessages="pageMessages"
			messageType="login/section"
			/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param tag attributes --->
    <cfparam 
    	name="ATTRIBUTES.pageMessages" 
        type="array" />

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
	<cfif ArrayLen(ATTRIBUTES.pageMessages)>
	
		<cfoutput>
            
            <cfswitch expression="#ATTRIBUTES.messageType#">
			
				<!--- Error displayed on login --->
                <cfcase value="login">
                
                    <table border="0" cellspacing="0" cellpadding="0" class="pageMessages">
                    <tr>
                        <td>
                        
                            <!--- Loop over the messages --->
                            <ul class="list">
                                
                                <!--- Loop over the message --->
                                <cfloop from="1" to="#ArrayLen(ATTRIBUTES.pageMessages)#" index="i">
                                   <li>#ATTRIBUTES.pageMessages[i]#</li>        	
                                </cfloop>
        
                            </ul>
                            
                        </td>
                    </tr>
                    </table>

                    <script type="text/javascript">
						// FadeIn and FadeOut Message
                    	$(".pageMessages").fadeIn().fadeOut(5000);
                    </script>

					<cfscript>
                        // Check to see if we are supposed to clear the queue 
                        if ( ATTRIBUTES.Clear ) {
							ATTRIBUTES.pageMessages.Clear();
							SESSION.pageMessages.clear();
                        }
                    </cfscript>
                
                </cfcase>
            
				<!--- Error displayed on sections --->
                <cfcase value="section">
                    
                    <div class="pageMessages">
    
						<!--- Loop over the message --->
                        <cfloop from="1" to="#ArrayLen(ATTRIBUTES.pageMessages)#" index="i">
                           <p><em>#ATTRIBUTES.pageMessages[i]#</em></p>    
                        </cfloop>

                    </div>
					
                    <script type="text/javascript">
						// FadeIn and FadeOut Message
                    	$(".pageMessages").fadeIn().fadeOut(5000);
                    </script>
                    
					<cfscript>
                        // Check to see if we are supposed to clear the queue 
                        if ( ATTRIBUTES.Clear ) {
							ATTRIBUTES.pageMessages.Clear();
							SESSION.pageMessages.clear();
                        }
                    </cfscript>
                
                </cfcase>
             
             </cfswitch>
                       
		</cfoutput>
    	
	</cfif>
			
</cfif>