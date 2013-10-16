<!--- ------------------------------------------------------------------------- ----
	
	File:		w9.cfm
	Author:		James Griffiths
	Date:		October 15, 2013
	Desc:		W9 Form

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>
		// Father CBC Authorization
		qGetFatherCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",																		   
			foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
			documentTypeID=APPLICATION.DOCUMENT.hostFatherCBCAuthorization, 
			seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
		);
		
		// Mother CBC Authorization
		qGetMotherCBCAuthorization = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",																   	
			foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
			documentTypeID=APPLICATION.DOCUMENT.hostMotherCBCAuthorization, 
			seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
		);
	
		// W-9
		qGetW9Signature = APPLICATION.CFC.DOCUMENT.getDocuments(
			foreignTable="smg_hosts",																		   
			foreignID=APPLICATION.CFC.SESSION.getHostSession().ID, 
			documentTypeID=35, // W-9
			seasonID=APPLICATION.CFC.SESSION.getHostSession().seasonID
		);
		
		// Defaults to true
		vIsPreviousInfoCompleted = true;	
	</cfscript>

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.w9Signature" default="">
    
    <!--- FORM Submitted --->    
	<cfif VAL(FORM.submitted)>
    
    	<cfscript>
			// Data Validation
			if ( NOT LEN(FORM.w9Signature) AND NOT VAL(qGetW9Signature.recordcount) ) {
				SESSION.formErrors.Add("The W-9 signature is missing");
			}
		</cfscript>
        
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
        
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	UPDATE smg_hosts
                SET 
                	w9_for = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.w9_for#">,
                	w9_exemptionCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.w9_exemptionCode#">,
                    w9_exemptionFATCACode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.w9_exemptionFATCACode#">
              	WHERE hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
            
            <cfscript>
				stResult = APPLICATION.CFC.DOCUMENT.generateW9Signature(
					foreignTable = "smg_hosts",
					foreignID = APPLICATION.CFC.SESSION.getHostSession().ID,
					documentTypeID = 35,
					address = qGetHostFamilyInfo.address,
					city = qGetHostFamilyInfo.city,
					state = qGetHostFamilyInfo.state,
					zip = qGetHostFamilyInfo.zip,
					signature = FORM.w9Signature																		  
				);
				
				if ( NOT stResult.isSuccess ) {
					SESSION.formErrors.Add(stResult.message);
				}
			</cfscript>
        
			<!--- Go to next section --->
            <cfscript>
				if ( NOT SESSION.formErrors.length() ) {
					// Successfully Updated - Set navigation page
					Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
				}
			</cfscript>				
            
		</cfif>

    <!--- FORM Not Submitted --->	
    <cfelse>

		<cfscript>
			// Section 1 Not Complete
			if ( NOT LEN(qGetHostFamilyInfo.fatherFirstName) AND NOT LEN(qGetHostFamilyInfo.fatherLastName) AND NOT LEN(qGetHostFamilyInfo.motherFirstName) AND NOT LEN(qGetHostFamilyInfo.motherLastName) ) {
				SESSION.formErrors.Add("Prior to complete this page, please complete page Name & Contact Info.");
			}
			
			// Father
			if ( LEN(qGetHostFamilyInfo.fatherFirstName) OR LEN(qGetHostFamilyInfo.fatherLastName) ) {
				
				// SSN
				if  ( NOT LEN(qGetHostFamilyInfo.fatherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherLastName# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetFatherCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostFamilyInfo.fatherFirstName# #qGetHostFamilyInfo.fatherLastName# is missing.");
				}	
			
			}

			// Mother
			if ( LEN(qGetHostFamilyInfo.motherFirstName) OR LEN(qGetHostFamilyInfo.motherLastName) ) {
				
				// SSN
				if  ( NOT LEN(qGetHostFamilyInfo.motherSSN) ) {
					SESSION.formErrors.Add("The SSN for #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName# does not appear to be a valid SSN. Please make sure it is entered in the 999-99-9999 format.");
				}	
				
				// Signature
				if ( NOT qGetMotherCBCAuthorization.recordCount ) {
					SESSION.formErrors.Add("The CBC authorization signature for #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName# is missing.");
				}	
			
			}
			
			// No Errors Found
			if ( SESSION.formErrors.length() ) {
				// Previous information is missing, do not allow page submission
				vIsPreviousInfoCompleted = false;
			}
		</cfscript>		
    
	</cfif>    

</cfsilent>

<cfoutput>

	<script type="text/javascript">
        function changeSignatureName() {
            if ($("##w9_for").find(":selected").val() === "father") {
                $("##signatureName").html("#qGetHostFamilyInfo.fatherFirstname# #qGetHostFamilyInfo.fatherLastName#");
            } else {
                $("##signatureName").html("#qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName#");
            }
			$("##signature").html('<input type="text" name="w9Signature" class="largeField"/>');
        }
    </script>
	
    <h2>W-9</h2>
    
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
        
 	<cfif vIsPreviousInfoCompleted>
    	<cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
            <input type="hidden" name="submitted" value="1" />
            
            <h3>Form <a href="http://www.irs.gov/pub/irs-pdf/fw9.pdf" style="font-size:10px;">Instructions</a></h3>
            
            <span class="required">* Required fields</span>
            <table width="100%" cellspacing="0" cellpadding="4" class="border">
                <tr bgcolor="##deeaf3">
                    <th width="50%" colspan="2">
                    	Name <span class="required">*</span>
                        <br/>
                        <p style="color:red; font-size:10px; margin:0px; padding:0px;">**Please note that the individual chosen for this form will be the individual to whom the host family stipend checks are written.</font>
                  	</th>
                    <th width="50%">Address</th>
                </tr>
                <tr>
                	<td colspan="2">
                        <select name="w9_for" id="w9_for" onchange="changeSignatureName()">
                            <cfif ( LEN(qGetHostFamilyInfo.fatherFirstName) OR LEN(qGetHostFamilyInfo.fatherLastName) )>
                                <option value="father" <cfif qGetHostFamilyInfo.w9_for EQ "father">selected="selected"</cfif>>
                                    #qGetHostFamilyInfo.fatherFirstname# #qGetHostFamilyInfo.fatherLastName# 
                                    (XXX-XX-#MID(APPLICATION.CFC.UDF.decryptVariable(qGetHostFamilyInfo.fatherSSN),8,4)#)
                                </option>
                            </cfif>
                            <cfif ( LEN(qGetHostFamilyInfo.motherFirstName) OR LEN(qGetHostFamilyInfo.motherLastName) )>
                                <option value="mother" <cfif qGetHostFamilyInfo.w9_for EQ "mother">selected="selected"</cfif>>
                                    #qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName#
                                    (XXX-XX-#MID(APPLICATION.CFC.UDF.decryptVariable(qGetHostFamilyInfo.motherSSN),8,4)#)
                                </option>
                            </cfif>
                        </select>
                	</td>
                    <td>
                    	#qGetHostFamilyInfo.address#, #qGetHostFamilyInfo.city#, #qGetHostFamilyInfo.state# #qGetHostFamilyInfo.zip#
                    </td>
                </tr>
                <tr bgcolor="##deeaf3">
                    <th width="25%">Federal Tax Classification</th>
                    <th width="25%">Exempt payee code (if any)</th>
                    <th width="30%">Exemption from FATCA reporting code (if any)</th>
                </tr>
                <tr>
                	<td>
                    	Individual/sole proprieter
                    </td>
                    <td><input type="text" name="w9_exemptionCode" value="#qGetHostFamilyInfo.w9_exemptionCode#"/></td>
                    <td><input type="text" name="w9_exemptionFATCACode" value="#qGetHostFamilyInfo.w9_exemptionFATCACode#"/></td>
                </tr>
        	</table>
            
            <br />
            
            <h3>Signature</h3>
            
            <p style="font-size:11px;">
            	Under penalties of perjury, I certify that:
                <br/>
                1. The number shown on this form is my correct taxpayer identification number (or I am waiting for a number to be issued to me), and
                <br/>
                2. I am not subject to backup withholding because: (a) I am exempt from backup withholding, or (b) I have not been notified by the Internal 
             	Revenue Service (IRS) that I am subject to backup withholding as a result of a failure to report all interest or dividends, or (c) the 
              	IRS has notified me that I am no longer subject to backup withholding, and
				<br/>
                3. I am a U.S. citizen or other U.S. person (defined below), and
                <br/>
                4. The FATCA code(s) entered on this form (if any) indicating that I am exempt from FATCA reporting is correct.
             	<br/>
				<b>Certification instructions.</b> You must cross out item 2 above if you have been notified by the IRS that you are currently subject to backup 
                withholding because you have failed to report all interest and dividends on your tax return. For real estate transactions, item 2 does not apply. 
                For mortgage interest paid, acquisition or abandonment of secured property, cancellation of debt, contributions to an individual retirement arrangement 
                (IRA), and generally, payments other than interest and dividends, you are not required to sign the certification, but you must provide your correct TIN. 
                See the <a href="http://www.irs.gov/pub/irs-pdf/fw9.pdf">Instructions</a> on page 3.
            </p>
            
            <table width="100%" cellspacing="0" cellpadding="4" class="border">
            	<tr bgcolor="##deeaf3">
                	<th>Name</th>
                	<th>Signature <span class="required">*</span></th>
                </tr>
                <tr>
                	<td>
                    	<h3 id="signatureName">
                        	<cfif qGetHostFamilyInfo.w9_for EQ "father">
                           		#qGetHostFamilyInfo.fatherFirstname# #qGetHostFamilyInfo.fatherLastName#
                            <cfelseif qGetHostFamilyInfo.w9_for EQ "mother">
                            	#qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName#
                            <cfelse>
                            	<cfif ( LEN(qGetHostFamilyInfo.fatherFirstName) OR LEN(qGetHostFamilyInfo.fatherLastName) )>
                                	#qGetHostFamilyInfo.fatherFirstname# #qGetHostFamilyInfo.fatherLastName#
                                <cfelse>
                                	#qGetHostFamilyInfo.motherFirstName# #qGetHostFamilyInfo.motherLastName#
                                </cfif>
                            </cfif>
                        </h3>
                    </td>
                	<td>
                    	<span id="signature">
							<cfif NOT qGetW9Signature.recordcount>
                                <input type="text" name="w9Signature" value="#FORM.w9Signature#" class="largeField"/>
                            <cfelse>
                                <a href="publicDocument.cfm?ID=#qGetW9Signature.ID#&Key=#APPLICATION.CFC.DOCUMENT.generateHashID(qGetW9Signature.ID)#" target="_blank">
                                    Download Copy of Electronic Signature
                                </a>
                            </cfif>
                      	</span>
                    </td>
                </tr>
            </table>
            
            <!--- Check if FORM submission is allowed --->
            <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
                <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                    <tr>
                        <td align="right">
                            <input name="Submit" type="image" src="images/buttons/BlkSubmit.png" border="0">
                        </td>
                    </tr>
                </table>
			</cfif>
            
     	</cfform>
    </cfif>    
        
</cfoutput>