<!--- ------------------------------------------------------------------------- ----
	
	File:		_reference.cfm
	Author:		Marcus Melo
	Date:		July 31, 2012
	Desc:		References - 4 references are required

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL Variables --->
    <cfparam name="URL.userID" default="0">
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.refID" default="0">
    <cfparam name="FORM.userID" default="#CLIENT.userID#">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.relationship" default="">
    <cfparam name="FORM.howLong" default="">

    <!--- Param URL Variables --->
    <cfparam name="URL.refID" default="0">
    
    <cfscript>
		if ( VAL(URL.userID) ) {
			FORM.userID = URL.userID;	
		}
	
		// Get References
		qGetReferences = APPLICATION.CFC.USER.getReferencesByID(userID=FORM.userID);	

		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Minimum of 4 references
		vMinReferences = 4;
		vRemainingReferences = vMinReferences - qGetReferences.recordcount;
		
		// Check if we are editing information
		if ( VAL(URL.refID) ) {
			FORM.refID = URL.refID;	
		}
	</cfscript>	

    <!--- Insert/Update --->
    <cfif VAL(FORM.submitted)>

        <cfscript>
			// Data Validation
			
			// First Name
			if ( NOT LEN(TRIM(FORM.firstName)) ) {
				SESSION.formErrors.Add("Please enter the first name.");
			}			
			
			// Last Name
			if ( NOT LEN(TRIM(FORM.lastName)) ) {
				SESSION.formErrors.Add("Please enter the last name.");
			}	
			
			// Address
			if ( NOT LEN(TRIM(FORM.address)) ) {
				SESSION.formErrors.Add("Please enter the address.");
			}			
			
			// City
			if ( NOT LEN(TRIM(FORM.city)) ) {
				SESSION.formErrors.Add("Please enter the city.");
			}		
			
			// State
			if ( NOT LEN(TRIM(FORM.state)) ) {
				SESSION.formErrors.Add("Please select the state.");
			}		
			
			// Zip
			if ( NOT LEN(TRIM(FORM.zip)) )  {
				SESSION.formErrors.Add("Please enter a zip code.");
			}			
			
			// Phone Number
			if ( NOT LEN(TRIM(FORM.phone)) ) {
				SESSION.formErrors.Add("Please enter the phone number.");
			}		
			
			// Relationship
			if ( NOT LEN(TRIM(FORM.relationship)) ) {
				SESSION.formErrors.Add("Please indicate your relationship to this person.");
			}	
			
			// How long have you known this person
			if ( NOT LEN(TRIM(FORM.howLong)) ) {
				SESSION.formErrors.Add("Please indicate how long you've known this person.");
			}	
        </cfscript>

    	<!--- No Errros Found --->
		<cfif NOT SESSION.formErrors.length()>
			
            <!--- Update --->
			<cfif VAL(FORM.refID)>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                    	smg_user_references 
                    SET 
                    	firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
                        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        relationship = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.relationship#">,
                        howLong = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.howLong#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
                    WHERE 
                    	refID = <cfqueryparam cfsqltype="cf_sql_interger" value="#FORM.refID#">
                    AND	
	                    referenceFor = <cfqueryparam cfsqltype="cf_sql_interger" value="#FORM.userID#">
                </cfquery>
    		
            <!--- Insert --->
    		<cfelse>        
            
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO
                        smg_user_references
                    (
                        referenceFor,
                        firstName,
                        lastName,
                        address,
                        address2,
                        city,
                        state,
                        zip,
                        phone,
                        relationship,
                        howLong,
                        email
                    )
                    VALUES
                    (
                    	<cfqueryparam cfsqltype="cf_sql_interger" value="#FORM.userID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.relationship#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.howLong#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
                    )
                </cfquery>
            
            </cfif>
			            
            <cfscript>
				// Update User Session Paperwork
				APPLICATION.CFC.USER.setUserSessionPaperwork();
			
				//Check if we need to send out a notification to the program manager - Only accounts that needs review / depending on the order of people submitting things, we have to check
				APPLICATION.CFC.USER.paperworkReceivedNotification(userID=FORM.userID);
			
				// Add Page Message
				SESSION.pageMessages.Add("Form successfully submitted");
			</cfscript>
		
        </cfif> <!--- NOT SESSION.formErrors.length() --->            
    
	</cfif>
    
    <cfscript>
		// Populate Fields when editing
		if ( VAL(FORM.refID) ) {

			// Get Employment History
			qGetReferenceDetails = APPLICATION.CFC.USER.getReferencesByID(userID=FORM.userID,refID=FORM.refID);		
			
			FORM.firstName = qGetReferenceDetails.firstName;
			FORM.lastName = qGetReferenceDetails.lastName;
			FORM.address = qGetReferenceDetails.address;
			FORM.address2 = qGetReferenceDetails.address2;
			FORM.city = qGetReferenceDetails.city;
			FORM.state = qGetReferenceDetails.state;
			FORM.zip = qGetReferenceDetails.zip;
			FORM.phone = qGetReferenceDetails.phone;
			FORM.relationship = qGetReferenceDetails.relationship;
			FORM.howLong = qGetReferenceDetails.howLong;
			FORM.email = qGetReferenceDetails.email;
		}
	</cfscript>    
        
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
		
		<cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        	
			<script type="text/javascript">
				// Close Window After 1.5 Seconds
				setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
        
        </cfif>
        
		<script type="text/javascript">
            $(document).ready(function() {
									   
				// Fomat Phone Number
				jQuery(function($){
				   $("##phone").mask("(999)999-9999");
				});	
				
            });
        </script>
        
        <style type="text/css">
            .wrapper {
                padding: 8px;
                width: 80%;
                margin-right: auto;
                margin-left: auto;
                border: thin solid ##CCC;
            }
            .clearfix {
                display: block;
                clear: both;
                height: 10px;
            }
			.label {
				text-align:right;
				padding-right:10px;
			}
		</style>

        <div class="wrapper">
        
            <table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>
                    	<cfif VAL(FORM.refID)>
                        	Edit Reference
                        <cfelse>
                        	Add Reference
                        </cfif>
                    </th>
                </tr>
                <cfif NOT VAL(FORM.refID)>
                    <tr>
                        <td>
							<cfif vRemainingReferences LTE 0>
                                No additional references are required.
                            <cfelseif vRemainingReferences EQ 1>
                                #vRemainingReferences# additional reference is required. Reference can <strong>not</strong> be relatives.
                            <cfelse>
                                #vRemainingReferences# additional references are required. References can <strong>not</strong> be relatives.
                            </cfif>
                        </td>
                    </tr>    
				</cfif>                                    
            </table> <br />

			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />
            
            <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="userID" value="#FORM.userID#" />
                <input type="hidden" name="refID" value="#FORM.refID#" />

                <table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr class="on">
                        <td class="label"><label for="firstName">First Name</label> <span class="required">*</span> </td>
                        <td colspan="3"><input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                    <tr class="off">
                        <td class="label"><label for="lastName">Last Name</label> <span class="required">*</span> </td>
                        <td colspan="3"><input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="address">Address</label> <span class="required">*</span></td>
                        <td colspan="3">
                            <input type="text" name="address" id="address" value="#FORM.address#" class="largeField" maxlength="100">
                            <font size="1">NO PO BOXES</font> 
                        </td>
                    </tr>
                    
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="3"><input type="text" name="address2" id="" value="#FORM.address2#" class="largeField" maxlength="255"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="city">City</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="city" id="city" value="#FORM.city#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                    <tr>
                        <td class="label"><label for="state">State</label> <span class="required">*</span></td>
                        <td>
                            <select name="state" id="state" class="mediumField">
                                <option value=""></option>
                                <cfloop query="qGetStateList">
                                <option value="#qGetStateList.state#" <cfif qGetStateList.state EQ FORM.state>selected</cfif>>#qGetStateList.statename#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td class="zip"><label for="zip">Zip</label> <span class="required">*</span></td>
                        <td><input type="text" name="zip" id="zip" value="#FORM.zip#" class="smallField" maxlength="5"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="phone">Phone</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="phone" id="phone" value="#FORM.phone#" class="mediumField" maxlength="14"></td>
                    </tr>
                    
                    <tr>
                        <td class="label"><label for="email">Email</label></td>
                        <td colspan="3"><input type="text" name="email" id="email" value="#FORM.email#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="relationship">Relationship</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="relationship" id="relationship" value="#FORM.relationship#" class="largeField" maxlength="100"></td>
                    </tr>

                    <tr>
                        <td class="label"><label for="howLong">How long have you known them?</label></label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="howLong" id="howLong" value="#FORM.howLong#" class="largeField" maxlength="100"></td>
                    </tr>

                   <tr class="on">
                        <td class="label"><span class="required">* Required Fields</span></td>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </table>
                
                <div class="clearfix"></div>
                
                <table width="100%" align="center">
                    <tr>
                        <td align="center">
                            <cfif VAL(FORM.refID)>
                                <input name="Submit" type="image" src="../pics/buttons/update_44.png" border="0">
                            <cfelse>
                                <input name="Submit" type="image" src="../pics/buttons/addReference.png" border="0">
                            </cfif>                            
                        </td>
                    </tr>
                </table>

                <div class="clearfix"></div>

            </form>
        
    	</div> <!--- <div class="wrapper"> --->
 
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
    />

</cfoutput>
















<!--- Field --->
<cfif NOT APPLICATION.CFC.USER.isOfficeUser()>

	<cfscript>
		// Get Regional Manager
		qGetRegionalManager = APPLICATION.CFC.user.getRegionalManager(regionID=CLIENT.regionID);
    </cfscript>

<cfelse>

    <cfset qGetRegionalManager.email = CLIENT.programmanager_email>

</Cfif>
    
<cfquery name="qGetRegionalAdvisor" datasource="#APPLICATION.dsn#">
    SELECT 
        uar.advisorid, 
        u.email
    FROM 
        user_access_rights uar
    LEFT JOIN 
        smg_users u on u.userid = uar.advisorid
    WHERE 
        uar.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
</cfquery>	

<cfif qGetRegionalAdvisor.recordcount eq 0>
    <cfset qGetRegionalAdvisor.email = ''>
</cfif>
    
<cfif vRemainingReferences LTE 0>
    
    <cfsavecontent variable="programEmailMessage">
		<cfoutput>				
        References and work experience have been submitted for #client.name# (#url.userid#)
        <br /><br />
        <a href="#client.exits_url#/nsmg/index.cfm?curdoc=user_info&userid=#userid#">View and Submit</a>
        </cfoutput>
    </cfsavecontent>
    
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
        <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#"> 
        <cfif qGetRegionalAdvisor.email is not ''>
            <cfinvokeargument name="email_cc" value="#qGetRegionalAdvisor.email#"> 
		</cfif>    
	    <cfinvokeargument name="email_from" value="""#client.companyshort# Support"" <#client.emailfrom#>">
    	<cfinvokeargument name="email_subject" value="References">
	    <cfinvokeargument name="email_message" value="#programEmailMessage#">
    </cfinvoke>       
</cfif>