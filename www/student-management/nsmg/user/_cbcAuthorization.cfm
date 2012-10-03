<!--- ------------------------------------------------------------------------- ----
	
	File:		_cbcAuthorization.cfm
	Author:		Marcus Melo
	Date:		July 25, 2012
	Desc:		CBC Authorization Page

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userID" default="#CLIENT.userID#">
	<cfparam name="FORM.seasonID" default="#APPLICATION.CFC.LOOKUPtableS.getCurrentPaperworkSeason().seasonID#">
	<cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.previous_address" default="">
    <cfparam name="FORM.previous_address2" default="">
    <cfparam name="FORM.previous_city" default="">
    <cfparam name="FORM.previous_state" default="">
    <cfparam name="FORM.previous_zip" default="">
	<cfparam name="FORM.dob" default="">
    <cfparam name="FORM.ssn" default="">
    <cfparam name="FORM.termsAgree" default="">
    <cfparam name="FORM.signature" default="">

	<cfscript>
		// Get Season Info
		qGetSeason = APPLICATION.CFC.LOOKUPTABLES.getSeason(seasonID=FORM.seasonID);
	
		// Get User Info
		qGetUser = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);

		// Get Paperwork Info
		qGetSeasonPaperwork = APPLICATION.CFC.USER.getSeasonPaperwork(userID=FORM.userID, seasonID=FORM.seasonID);

		// Set SSN
		vOriginalSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUser.SSN, displayType='user');
		
		// This will set if SSN needs to be updated
		vUpdateUserSSN = 0;
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPtableS.getState();
	</cfscript>
	
    <!--- FORM SUBMITTED --->
	<cfif VAL(FORM.submitted)>

        <cfscript>
			// Check Signature
			vDoesSignatureMatch = 0;
			
			vUserSignature = TRIM(qGetUser.firstName) & " " & TRIM(qGetUser.lastName);
			
			if ( LEN(TRIM(FORM.Signature)) AND TRIM(FORM.Signature) EQ TRIM(vUserSignature) ) {
				vDoesSignatureMatch = 1;
			}

			/**********************
				Data Validation
			**********************/
			
			// Address
			if ( NOT LEN(FORM.address) ) {
				SESSION.formErrors.Add("Please enter your current address");
			}
			
			// City
			if ( NOT LEN(FORM.city) ) {
				SESSION.formErrors.Add("Please enter your current city");
			}
			
			// State
			if ( NOT LEN(FORM.state) ) {
				SESSION.formErrors.Add("Please enter your current state");
			}
			
			// ZIP
			if ( NOT LEN(FORM.zip) ) {
				SESSION.formErrors.Add("Please enter your current zip");
			}
			
			// DOB
			if ( LEN(FORM.DOB) AND NOT IsDate(FORM.DOB) ) {
				FORM.DOB = '';
				SESSION.formErrors.Add("Please enter a valid Date of Birth");				
			}    
			
			// SSN
			if ( LEN(FORM.SSN) AND Left(FORM.SSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.SSN)) ) {
				SESSION.formErrors.Add("Please enter a valid SSN");
			}    

			// Signature Is Required
			if ( NOT LEN(TRIM(FORM.signature)) )  {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please sign your name");
			}

			// Signature does not match
			if ( LEN(TRIM(FORM.signature)) AND NOT VAL(vDoesSignatureMatch) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Your signed name #FORM.signature# does not match the name on file #CLIENT.name#");
			}
			
			// Agreement
			if ( NOT VAL(FORM.termsAgree) )  {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please check the box indicating you agree to the terms");
			}
		</cfscript>
    
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
		
			<cfscript>
				// User SSN - Will update if it's blank or there is a new number
				if ( isValid("social_security_number", Trim(FORM.SSN)) ) {
					// Encrypt Social
					FORM.SSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
					// Update
					vUpdateUserSSN = 1;
				} else if ( NOT LEN(FORM.SSN) ) {
					// Update - Erase SSN
					// vUpdateUserSSN = 1;
				}
				
				// Add Page Message
				SESSION.pageMessages.Add("Form successfully submitted");				
            </cfscript>
        
        	<!--- Update User Information --->
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_users
                SET 
                	address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                    previous_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previous_address#">,
                    previous_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previous_address2#">,
                    previous_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previous_city#">,
                    previous_state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previous_state#">,
                    previous_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.previous_zip#">,
                    <cfif VAL(vUpdateUserSSN)>
                    	SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SSN#">,
                    </cfif>
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
            </cfquery>
    
            <!--- Generate PDF File --->
            <cfdocument format="PDF" filename="#APPLICATION.CFC.USER.getUserSession().myUploadFolder#Season#FORM.seasonID#cbcAuthorization.pdf" overwrite="yes">
            
            	<cfinclude template="agreementCBC.cfm">
            
                <cfoutput>
                	<br />
                    <p>
                        Electronically Signed <br />
                        #FORM.signature# <br />
                        #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')# <br />
                        IP Address: #CGI.REMOTE_ADDR# 
                    </p>
                </cfoutput>
                
            </cfdocument>

			<!--- Email to User --->    
            <cfsavecontent variable="repEmailMessage">
                <p>
                	Attached is a copy of the Criminal Background Check Authorization you electronically signed. 
                    A copy is also available at any time in the paperwork section under "Users -> My Information" when logged into EXITS.
                </p> <br />
                Regards-<br />
                EXITS Support
            </cfsavecontent>
            
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#CLIENT.email#">   
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_subject" value="CBC Authorization">
                <cfinvokeargument name="email_message" value="#repEmailMessage#">
                <cfinvokeargument name="email_file" value="#APPLICATION.CFC.USER.getUserSession().myUploadFolder#Season#FORM.seasonID#cbcAuthorization.pdf">
            </cfinvoke>	
			
			<cfif qGetSeasonPaperwork.recordcount> 
            	
                <!--- Update Paperwork --->
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                    	smg_users_paperwork
                    SET 
                    	ar_cbc_auth_form = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        ar_info_sheet = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	                    cbcSig = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.signature#"> 
                    WHERE
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#"> 
                    AND 
                    	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                </cfquery>
              
            <cfelse>
            	
                <!--- Insert Paperwork --->  
                <cfquery datasource="#APPLICATION.DSN#">
                	INSERT INTO 
                    	smg_users_paperwork 
                    (
                    	ar_cbc_auth_form, 
                        userID, 
                        seasonID,
                        fk_companyID, 
                        cbcSig,
                        ar_info_sheet
                     )
                	VALUES	
                    (
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.signature#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">                        
					)
                </cfquery>
                
            </cfif>
            
            <cfscript>
				// Update User Session Paperwork
				APPLICATION.CFC.USER.setUserSessionPaperwork();
				
				// Check if we need to send out a notification to the regional manager
				APPLICATION.CFC.USER.paperworkSubmittedRMNotification(userID=FORM.userID);
			</cfscript>
        	
		</cfif>  <!--- NOT SESSION.formErrors.length() --->

	<cfelse> <!--- FORM SUBMITTED --->
    	
        <cfscript>
			// Set Default Values
            FORM.address = qGetUser.address;
            FORM.address2 = qGetUser.address2;
            FORM.city = qGetUser.city;
            FORM.state = qGetUser.state;
            FORM.zip = qGetUser.zip;
            FORM.previous_address = qGetUser.previous_address;
            FORM.previous_address2 = qGetUser.previous_address2;
            FORM.previous_city = qGetUser.previous_city;
            FORM.previous_state = qGetUser.previous_state;
            FORM.previous_zip = qGetUser.previous_zip;
            FORM.dob = qGetUser.dob;
            FORM.ssn = vOriginalSSN;
		</cfscript>
	
	</cfif> <!--- FORM SUBMITTED --->
    
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        
            <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 2000);
            </script>
        
        </cfif>
            
        <style type="text/css">
            div.scroll {
                height: 500px;
                width:auto;
                overflow:auto;
                left:auto;
                padding: 8px;
                border-top-width: thin;
                border-right-width: 2px;
                border-bottom-width: thin;
                border-left-width: 2px;
                border-top-style: inset;
                border-right-style: solid;
                border-bottom-style: outset;
                border-left-style: solid;
                border-top-color: ##efefef;
                border-right-color: ##c6c6c6;
                border-bottom-color: ##efefef;
                border-left-color: ##c6c6c6;
            }
            .greyHeader{
                width:590px;
                background-color:##CCC;
                padding:5px;
                text-align: center;
            }
            .lightGrey{
                width:590px;
                background-color:##EFEFEF;
                padding:5px;
                text-align: left;
            }
            .wrapper {
                padding: 8px;
                width: 600px;
                margin-right: auto;
                margin-left: auto;
                border: thin solid ##CCC;
            }
            body {
                font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
                font-size: 12px;
                color: ##000;
            }
            .clearfix {
                display: block;
                height: 12px;
            }
            .italic {
                font-size: 11px;
            }
        </style>

        <div class="wrapper">
        
            <div class="greyHeader">
                <h1>CBC Authorization - AYP #qGetSeason.years#</h1>
            </div> <br />
        
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
 
            <p>
				<cfif CLIENT.companyID NEQ 14>As mandated by the Department of State, a<cfelse> A</cfif> Criminal Background Check on all Office Staff, Regional Directors/
            	Managers, Regional Advisors, Area Representatives and all members of the host family aged 18 and above is required for involvement with the
                <cfif CLIENT.companyID NEQ 14>J-1 Secondary School</cfif> Exchange <cfif CLIENT.companyID NEQ 14>Visitor</cfif> Program.
			</p>

            <cfform method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="userID" value="#FORM.userID#" />
                <input type="hidden" name="seasonID" value="#FORM.seasonID#" />

                <div class="scroll">
             
                    <p>
                        I, <strong>#qGetUser.firstName# #qGetUser.middlename# #qGetUser.lastname#</strong> do hereby authorize verification of all information in my application 
                        for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. 
                        to obtain the said records and any such disclosures.
                    </p>
                    
                    <p>
                        Information appearing on this Authorization will be used exclusively by General Information Services, Inc. for identification
                        purposes and for the release of information that will be considered in determining any suitability for participation in the
                        Exchange Program.
                    </p>
                    
                    <p>
                        Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to
                        request from General Information Services, Inc. information about the nature and substance of all records on file about me
                        at the time of my request. This may include the type of information requested as well as those who requested reports from
                        General Information Services, Inc. within the two-year period preceding my request.  
                    </p>
            
                    <table width="100%">
                        <tr>
                            <td>
                                 <table width="100%">
                                    <tr>
                                        <td>Current Address <span class="required">*</span></td>
                                        <td><input type="text" value="#FORM.address#" name="address" class="largeField" /></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><input type="text" value="#FORM.address2#" name="address2" class="largeField" /></td>
                                    </tr>    
                                    <tr>
                                        <td>City <span class="required">*</span></td>
                                        <td><input type="text" value="#FORM.city#" name="city" class="largeField" /></td>
                                    </tr>    
                                    <tr>
                                        <td>State <span class="required">*</span></td>
                                        <td>
                                            <select name="state" id="state" class="largeField">
                                                <option value=""></option>
                                                <cfloop query="qGetStateList">
                                                    <option value="#qGetStateList.state#" <cfif FORM.state EQ qGetStateList.state> selected </cfif> >#qGetStateList.stateName#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                    </tr>  
                                    <tr>
                                        <td>Zip <span class="required">*</span></td>
                                        <td><input type="text" value="#FORM.zip#" name="zip" class="smallField" maxlength="10" /></td>
                                    </tr>  
                                 </table>   
                              </td>
                              <td>
                                  <table width="100%">
                                    <tr>
                                        <td>Previous Address</td>
                                        <td><input type="text" value="#FORM.previous_address#" name="previous_address" class="largeField" /></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><input type="text" value="#FORM.previous_address2#" name="previous_address2" class="largeField" /></td>
                                    </tr>    
                                    <tr>
                                        <td>City</td>
                                        <td><input type="text" value="#FORM.previous_city#" name="previous_city" class="largeField" /></td>
                                    </tr>    
                                    <tr>
                                        <td>State</td>
                                        <td>
                                            <select name="previous_state" id="previous_state" class="largeField">
                                                <option value=""></option>
                                                <cfloop query="qGetStateList">
                                                    <option value="#qGetStateList.state#" <cfif FORM.previous_state EQ qGetStateList.state> selected </cfif> >#qGetStateList.stateName#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                    </tr>  
                                    <tr>
                                        <td>Zip</td>
                                        <td><input type="text" value="#FORM.previous_zip#" name="previous_zip" class="smallField" maxlength="10" /></td>
                                    </tr>  
                                 </table>     
                            </td>
                        </tr>
                    </table> 

                    <hr width=50% align="center" />
                    
                    <table width="100%">
                        <tr>
                            <td>Date of Birth <span class="required">*</span></td>
                            <td><cfinput type="text" name="dob" value="#DateFormat(FORM.dob, 'mm/dd/yyyy')#" class="smallField" mask="99/99/9999"/></td>
                        </tr>
                        <tr>
                            <td>Social Security Number <span class="required">*</span></td>
                            <td><input type="text" name="ssn" value="#FORM.ssn#" class="mediumField" /></td>
                        </tr>
                        <tr><td colspan="2"><span class="required">* Required Fields</span></td></tr>
                    </table>

				</div> <!--- <div class="scroll"> --->
              
				<div class="clearfix"></div>
               
                <div class="lightGrey">
            
                    <cfif isDate(qGetSeasonPaperwork.ar_cbc_auth_form)>
        
                        <div align="center">
                           Signed by #qGetSeasonPaperwork.cbcSig# on #DateFormat(qGetSeasonPaperwork.ar_cbc_auth_form, 'mmmm d, yyyy')#
                        </div>
        
                    <cfelse>
                    
                        <table width="100%" align="center">
                            <tr>
                                <td valign="top"><input type="checkbox" name="termsAgree" id="termsAgree" value="1" /></td>
                                <td>
                                    <label for="termsAgree">I agree to the terms and conditions set above.</label> <br />
                                    <i class="italic">(Typing your name below replaces your signature on this document)</i> <br />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <input type="text" name="signature" id="signature" class="largeField" /><br />#CLIENT.name#
                                </td>
                            </tr>
                            <tr>                                  
                                <td colspan="2" align="center"><br /><input type="image" src="../pics/buttons_SUBMIT.png" /></td>
                            </tr>
                        </table>
                              
                    </cfif>
               
                </div> <!--- <div class="lightGrey"> --->
    
            </div> <!--- <div class="wrapper"> --->

		</cfform>
                
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
    />

</cfoutput>