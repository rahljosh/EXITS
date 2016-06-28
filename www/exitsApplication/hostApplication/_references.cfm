<!--- ------------------------------------------------------------------------- ----
	
	File:		references.cfm
	Author:		Marcus Melo
	Date:		December 12, 2012
	Desc:		References

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- PARAM URL Variables --->
    <cfparam name="URL.refID" default="0">
    <cfparam name="URL.deleteRefID" default="0">
    
    <!--- PARAM FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.refID" default="0">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">

	<cfscript>
		if ( VAL(URL.refID) ) {
			FORM.refID = URL.refID;	
		}
	
		// Get All References
		qGetAllReferences = APPLICATION.CFC.HOST.getHostReferences();
	
		// Get Edit Reference Info
		qGetReferenceInfo = APPLICATION.CFC.HOST.getHostReferences(refID=FORM.refID);
			
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
			
		// Single Parent
		if ( qGetHostFamilyInfo.totalFamilyMembers EQ 1 ) {
			vNumberOfRequiredReferences = 6;
		} else {
			vNumberOfRequiredReferences = 4;
		}
		
		vRemainingReferences = vNumberOfRequiredReferences - qGetAllReferences.recordcount;
	</cfscript>
        
    <!--- Delete Reference --->
    <cfif VAL(URL.deleteRefID)>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            DELETE FROM
                smg_host_reference
            WHERE 
                refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.deleteRefID)#">
            AND
                referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            LIMIT 1
        </cfquery>
        
        <cfscript>
			// Set Page Message
			SESSION.pageMessages.Add("Reference has been deleted");
			
			// Refresh Page
			location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
		</cfscript>
        
    </cfif>

    <!--- Process Form Submission --->
    <cfif VAL(FORM.submitted)>
        
        <cfscript>
        	// Data Validation
		
			// First Name
			if ( NOT LEN(TRIM(FORM.firstName)) ) {
				SESSION.formErrors.Add("Please enter the first name.");
			}			
			
			// Last name
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
				SESSION.formErrors.Add("Please select a state.");
			}	

			// Zip
			if ( NOT LEN(TRIM(FORM.Zip)) ) {
				SESSION.formErrors.Add("Please enter the zip code.");
			}	

			// Phone Number
			if ( NOT LEN(TRIM(FORM.phone)) ) {
				SESSION.formErrors.Add("Please enter the phone number.");
			}	
			
			// Phone Number
			if ( LEN(TRIM(FORM.phone)) AND NOT IsValid("telephone", TRIM(FORM.phone)) ) {
				SESSION.formErrors.Add("Please enter a valid phone number in the following format (xxx) xxx-xx-xx");
			}	
		</cfscript>    
        
        <!--- No Errors Found --->
		<cfif NOT SESSION.formErrors.length()>

			<!--- Update --->
            <cfif VAL(FORM.refID)>
            
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    UPDATE 
                        smg_host_reference 
                    SET
                        firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
                        lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
                    WHERE 
                        refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.refID)#">
                    AND
                        referenceFor = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                </cfquery>
                
				<cfscript>
                    // Set Page Message
                    SESSION.pageMessages.Add("Reference has been updated");
					
					// Refresh Page
					location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
                </cfscript>
                
            <!--- INSERT --->
            <cfelse>
        
                <cfquery datasource="#APPLICATION.DSN.Source#">
                    INSERT INTO 
                    	smg_host_reference 
                    (
                        referenceFor, 
                        firstName, 
                        lastName,
                        address,
                        city, 
                        state, 
                        zip, 
                        phone, 
                        email
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
                    )  
                </cfquery>

				<cfscript>
					// Set Page Message
					SESSION.pageMessages.Add("Reference has been added");
					
					if ( vRemainingReferences - 1 LTE 0 ) {
						// Successfully Updated - Set navigation page
						Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
					} else {
						// Refresh Page
						location("#CGI.SCRIPT_NAME#?section=#URL.section#", "no");
					}
                </cfscript>

            </cfif>
            
		</cfif> <!--- No Errors Found --->
	
	<!--- FORM NOT Submitted --->
    <cfelse>
	
		 <cfscript>
            // Set FORM Values   
            FORM.firstName = qGetReferenceInfo.firstName;
            FORM.lastName = qGetReferenceInfo.lastName;
            FORM.address = qGetReferenceInfo.address;
            FORM.city = qGetReferenceInfo.city;
            FORM.state = qGetReferenceInfo.state;
            FORM.zip = qGetReferenceInfo.zip;
            FORM.phone = qGetReferenceInfo.phone;
            FORM.email = qGetReferenceInfo.email;
        </cfscript>    
    
	</cfif> <!--- FORM. Submitted --->   

</cfsilent>

<cfoutput>

    <h2>References</h2>
    
    <h3>Current References</h3>

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />

	<em><strong>PLEASE NOTE:</strong> The Department of State now requires a second home visit which will be conducted by someone other than your local Area Representative.</em> <br /><br />
    
	Please provide at least <cfif qGetHostFamilyInfo.totalFamilyMembers EQ 1>six (6)&dagger;<cfelse>four (4)&dagger;</cfif> references. References can <strong>not</strong> 
    be relatives, must have visited you <strong>inside</strong> your home, and must live in the same community or general vicinity of the host family. References must be within 60 minutes of the host family home.  <br /><br />

    <table width="100%" cellspacing="0" cellpadding="4" class="border">
        <tr bgcolor="##deeaf3"> 
            <th style="border-bottom:1px solid ##000;">Name</th>
            <th style="border-bottom:1px solid ##000;">Address</th>
            <th style="border-bottom:1px solid ##000;">City</th>
            <th style="border-bottom:1px solid ##000;">State</th>
            <th style="border-bottom:1px solid ##000;">Zip</th>
            <th style="border-bottom:1px solid ##000;">Phone</th>
            <th style="border-bottom:1px solid ##000;" width="50px"></th>
        </tr>
        
        <cfif NOT qGetAllReferences.recordcount>
            <tr>
            	<td colspan="7">Currently, no references are on file for you.</td>
            </tr>
        </cfif>
        
        <cfloop query="qGetAllReferences">
            <tr <cfif qGetAllReferences.currentRow MOD 2 EQ 0> bgcolor="##deeaf3"</cfif>>
                <th>#qGetAllReferences.firstName# #qGetAllReferences.lastName#</th>
                <td>#qGetAllReferences.address# #qGetAllReferences.address2#</td>
                <td>#qGetAllReferences.city#</td>
                <td>#qGetAllReferences.state#</td>
                <td>#qGetAllReferences.zip#</td>
                <td>#qGetAllReferences.phone#</td>
                <td>
					<!--- Check if FORM submission is allowed --->
                    <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
                        <a href="index.cfm?section=references&refID=#qGetAllReferences.refID#" style="padding-right:5px;"><img src="images/buttons/pencilBlue23x29.png" border="0" height="15" title="Click to edit this reference"/></a> 
                        <a href="index.cfm?section=references&deleteRefID=#qGetAllReferences.refID#" title="Click to delete this reference" onClick="return confirm('Are you sure you want to delete this Reference?')"><img src="images/buttons/deleteRedX.png" border="0"/></a>
					</cfif>
                </td>
            </tr>
        </cfloop>
        
    </table> <br />
	
    <h3>Add a Reference</h3>
    
    <div align="center"><strong>References must be from your community or general vicinity.</strong></div>
    <br />
	<cfif NOT VAL(vRemainingReferences) or VAL(vRemainingReferences) lt 0>
        No additional references are required.
    <cfelse>
        #vRemainingReferences# additional references are required based on the information on your application.
    </cfif> <br /><br />

    <span class="required">* Required fields</span>

    <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    	<input type="hidden" name="submitted" value="1" />
        <input type="hidden" name="refID" value="#FORM.refID#" /> 
        
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
            	<td class="label"><h3>First Name <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="firstName" value="#FORM.firstName#" class="largeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3> Last Name <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="lastName" value="#FORM.lastName#" class="largeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td><h3>Phone <span class="required">*</span></h3></td>
                <td colspan="3"><cfinput type="text" name="phone" value="#FORM.phone#" class="mediumField" placeholder="(999) 999-9999" maxlength="14" mask="(999) 999-9999"></td>
            </tr>
            <tr>
                <td class="label"><h3>Address <span class="required">*</span></h3></td>
                <td colspan="2">
            		<input type="text" name="address" value="#FORM.address#" class="xLargeField" maxlength="150">
           			<font size="1">NO PO BOXES</font> 
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3"><input type="text" name="address2" value="#FORM.address2#" class="xLargeField" maxlength="150"></td>
            </tr>
            <tr bgcolor="##deeaf3" >			 
                <td class="label"><h3>City <span class="required">*</span></h3></td>
                <td colspan="3"><input type="text" name="city" value="#FORM.city#" class="largeField" maxlength="150"></td>
            </tr>
            <tr>
                <td class="label"><h3>State <span class="required">*</span></h3></td>
                <td>
                    <select name="state" class="mediumField">
                        <option></option>
                        <cfloop query="qGetStateList">
                            <option value="#qGetStateList.state#" <cfif qGetStateList.state EQ FORM.state>selected</cfif>>#qGetStateList.statename#</option>
                        </cfloop>
                    </select>
                </td>
                <td class="zip"><h3>Zip <span class="required">*</span></h3></td>
                <td><input type="text" name="zip" value="#FORM.zip#" class="smallField" maxlength="10"></td>
            </tr>
            <tr bgcolor="##deeaf3">
                <td><h3>Email</h3></td>
                <td colspan="3"><input type="text" name="email" value="#FORM.email#" class="xLargeField" maxlength="100"></td>
            </tr>
		</table>

        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
            	<td align="right">
					<!--- Finished with this page --->
                    <div style="margin:5px 25px 0 0; float:left;">
						<a href="index.cfm?section=checkList">I am finished entering references.</a>
                    </div>
					
					<!--- Check if FORM submission is allowed --->
                    <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
                                    
						<cfif VAL(URL.refID)>
                            <a href="?section=references"><img src="images/buttons/goBack_44.png" border="0"/></a> 
                            <input name="Submit" type="image" src="images/buttons/update_44.png" border="0">
                        <cfelse>
                            <input name="Submit" type="image" src="images/buttons/addRef.png" border="0" onclick="this.disabled=true; this.form.submit();" >
                        </cfif>
					
                    </cfif>
                </td>
            </tr>
    	</table>
    
    </cfform>
</cfoutput>