<!--- ------------------------------------------------------------------------- ----
	
	File:		_employmentHistory.cfm
	Author:		Marcus Melo
	Date:		July 26, 2012
	Desc:		Services Agreement Contract

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.employmentID" default="0">
    <cfparam name="FORM.userID" default="#CLIENT.userID#">
    <cfparam name="FORM.noAdditional" default="0">
    <cfparam name="FORM.occupation" default="">
    <cfparam name="FORM.employer" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.daysWorked" default="">
    <cfparam name="FORM.hoursDay" default="">
    <cfparam name="FORM.startDate" default="">
    <cfparam name="FORM.endDate" default="">
    <cfparam name="FORM.current" default="0">
    <cfparam name="FORM.datesEmployed" default="">
    <!--- Prior Student Exchange Experience --->
    <cfparam name="FORM.prevOrgAffiliation" default="">
    <cfparam name="FORM.prevAffiliationName" default="">
    <cfparam name="FORM.prevAffiliationProblem" default="">
    
    <!--- Param URL Variables --->
    <cfparam name="URL.employmentID" default="0">

    <cfscript>
		// Get User
		qGetUser = APPLICATION.CFC.USER.getUserByID(userID=FORM.userID);
		
		// Get Employment History
		qGetEmployment = APPLICATION.CFC.USER.getEmploymentByID(userID=FORM.userID);		
		
		// Minimum of 1 employer
		vMinEmployers = 1;
		vRemainingEmployers = vMinEmployers - qGetEmployment.recordcount;

		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
		
		// Check if we are editing information
		if ( VAL(URL.employmentID) ) {
			FORM.employmentID = URL.employmentID;	
		}
	</cfscript>
    
    <!--- Insert/Update --->
	<cfif VAL(FORM.submitted)>
    
		<cfscript>
			// Set Default Values If No Additional Information is checked
			if ( VAL(FORM.noAdditional) ) {
				FORM.current = 1;
				FORM.employer = 'None Provided';
				FORM.occupation = 'None Provided';
				FORM.address = 'None Provided';
				FORM.address2 = 'None Provided';
				FORM.city = 'None Provided';
				FORM.state = 'N/A';
				FORM.zip = 'N/A';
				FORM.phone = 'None Provided';
				FORM.daysWorked = 'None Provided';
				FORM.hoursDay = 'None Provided';
				FORM.datesEmployed = 'None Provided';
			}
		
			// Data Validation
			
			// Employer
			if ( NOT LEN(TRIM(FORM.employer)) ) {
				SESSION.formErrors.Add("Please enter the name of your employer.");
			}			
			
			// Occupation
			if ( NOT LEN(TRIM(FORM.occupation)) ) {
				SESSION.formErrors.Add("Please enter your occupation.");
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
			
			// Days Worked
			if ( NOT LEN(TRIM(FORM.daysWorked)) ) {
				SESSION.formErrors.Add("Please enter the days you worked.");
			}	
			
			// Hours Worked
			if ( NOT LEN(TRIM(FORM.hoursDay)) ) {
				SESSION.formErrors.Add("Please enter the numbers of hours worked per day.");
			}	
			
			// Dates Employed
			if ( NOT LEN(TRIM(FORM.datesEmployed)) ) {
				SESSION.formErrors.Add("Please enter the dates you were employed.");
			}	
			
			// Affiliation
			if ( NOT LEN(TRIM(FORM.prevOrgAffiliation)) ) {
				SESSION.formErrors.Add("Please answer the question: Have you ever had an affiliation with...");
			}	
			
			// Affiliation Details
			if ( (TRIM(FORM.prevOrgAffiliation) EQ 1 ) AND NOT LEN(TRIM(FORM.prevAffiliationName)) ) {
				SESSION.formErrors.Add("You have indicated you had a previous affiliation with an exchange organization, but did not provide any details.");
			}						
        </cfscript>
    
    	<!--- No Errros Found --->
		<cfif NOT SESSION.formErrors.length()>
        
			<cfif VAL(FORM.employmentID)>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                    	smg_users_employment_history 
                    SET 
                    	occupation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.occupation#">,
                        employer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.employer#">,
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        daysWorked = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.daysWorked#">,
                        hoursDay = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hoursDay#">,
                        current = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.current#">,
                        datesEmployed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.datesEmployed#">
                    WHERE 
                    	employmentID = <cfqueryparam cfsqltype="cf_sql_interger" value="#FORM.employmentID#">
                    AND	
	                    fk_userID = <cfqueryparam cfsqltype="cf_sql_interger" value="#FORM.userID#">
                </cfquery>
    
    		<cfelse>
            
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO
                        smg_users_employment_history
                    (
                    	fk_userID,
                        occupation,
                        employer,
                        address,
                        address2,
                        city,
                        state,
                        zip,
                        phone,
                        daysWorked,
                        hoursDay,
                        current,
                        datesEmployed
                    )
                    VALUES
                    (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.occupation#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.employer#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.daysWorked#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hoursDay#">,
                        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#FORM.current#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#datesEmployed#">
                    )
                </cfquery>
                                
			</cfif>
            
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_users
                SET
                	prevOrgAffiliation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.prevOrgAffiliation#">,
	                prevAffiliationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.prevAffiliationName#">,
    	            prevAffiliationProblem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.prevAffiliationProblem#">
                WHERE
                	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">
            </cfquery>            
    
            <cfscript>
				// Update User Session Paperwork
				APPLICATION.CFC.USER.setUserSessionPaperwork();				
				
				//Check if we need to send out a notification to the program manager - Only accounts that needs review / depending on the order of people submitting things, we have to check
				APPLICATION.CFC.USER.paperworkReceivedNotification(userID=FORM.userID);

				// Add Page Message
				SESSION.pageMessages.Add("Form successfully submitted");
			</cfscript>
    
    	</cfif>
        
    </cfif>
    
    <cfscript>
		// Populate Fields when editing
		if ( VAL(FORM.employmentID) ) {

			// Get Employment History
			qGetEmploymentDetails = APPLICATION.CFC.USER.getEmploymentByID(userID=FORM.userID,employmentID=FORM.employmentID);		
			
			FORM.occupation = qGetEmploymentDetails.occupation;
			FORM.employer = qGetEmploymentDetails.employer;
			FORM.address = qGetEmploymentDetails.address;
			FORM.address2 = qGetEmploymentDetails.address2;
			FORM.city = qGetEmploymentDetails.city;
			FORM.state = qGetEmploymentDetails.state;
			FORM.zip = qGetEmploymentDetails.zip;
			FORM.phone = qGetEmploymentDetails.phone;
			FORM.daysWorked = qGetEmploymentDetails.daysWorked;
			FORM.hoursDay = qGetEmploymentDetails.hoursDay;
			FORM.datesEmployed = qGetEmploymentDetails.datesEmployed;
			FORM.current = qGetEmploymentDetails.current;
		}
		
		FORM.prevOrgAffiliation = qGetUser.prevOrgAffiliation;
		FORM.prevAffiliationName = qGetUser.prevAffiliationName;
		FORM.prevAffiliationProblem = qGetUser.prevAffiliationProblem;
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
                    	<cfif VAL(FORM.employmentID)>
                        	Edit Employer
                        <cfelse>
                        	Add Employer
                        </cfif>
					</th>
                </tr>
                <cfif NOT VAL(FORM.employmentID)>
                    <tr>
                        <td>
							<cfif vRemainingEmployers LTE 0>
                                No additional employers are required.
                            <cfelseif vRemainingEmployers EQ 1>
                                #vRemainingEmployers# additional employer is required.
                            <cfelse>
                                #vRemainingEmployers# additional employers are required.
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
                <input type="hidden" name="employmentID" value="#FORM.employmentID#" />
                
                <table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                   <tr class="on">
                        <td width="30"><input type="checkBox" name="noAdditional" id="noAdditional" value="1" ></td>
                        <td><label for="noAdditional">I don't need / want to provide previous employment information.</label></td>
                    </tr>
                </table> <br />
                
                <table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                   <tr class="on">
                        <td class="label"><label for="current">Current Employer</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="checkBox" name="current" id="current" value="1" <cfif FORM.current EQ 1>checked</cfif>></td>
                    </tr>
                    
                    <tr>
                        <td class="label"><label for="occupation">Occupation</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="occupation" id="occupation" value="#FORM.occupation#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="employer">Employer</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="employer" id="employer" value="#FORM.employer#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                    <tr>
                        <td class="label"><label for="address">Address</label> <span class="required">*</span></td>
                        <td colspan="3">
                            <input type="text" name="address" id="address" value="#FORM.address#" class="largeField" maxlength="100">
                            <font size="1">NO PO BOXES</font> 
                        </td>
                    </tr>
                    
                   <tr class="on">
                        <td>&nbsp;</td>
                        <td colspan="3"><input type="text" name="address2" id="address2" value="#FORM.address2#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                    <tr>			 
                        <td class="label"><label for="city">City</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="city" id="city" value="#FORM.city#" class="largeField" maxlength="100"></td>
                    </tr>
                    
                   <tr class="on">
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
                    
                    <tr>
                        <td class="label"><label for="phone">Phone</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="phone" id="phone" value="#FORM.phone#" class="mediumField" maxlength="14"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="daysWorked">Days Worked</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="daysWorked" id="daysWorked" value="#FORM.daysWorked#" class="mediumField" maxlength="100"></td>
                    </tr>
                    
                    <tr>
                        <td class="label"><label for="hoursDay">Hours per Day</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="hoursDay" id="hoursDay" value="#FORM.hoursDay#" class="mediumField" maxlength="100"></td>
                    </tr>
                    
                   <tr class="on">
                        <td class="label"><label for="datesEmployed">Dates Employed</label> <span class="required">*</span></td>
                        <td colspan="3"><input type="text" name="datesEmployed" id="datesEmployed" value="#FORM.datesEmployed#" class="mediumField" maxlength="100"></td>
                    </tr>

                    <tr>
                        <td class="label"><span class="required">* Required Fields</span></td>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </table>
                
  				<div class="clearfix"></div>
        
                <div class="greybox">
            
                    <h2>Prior Student Exchange Experience</h2>
                    
                    Have you had a previous affiliation in any way with international exchange student programs (i.e., hosting, placing, or monitoring exchange students) or with Department of State Secondary School Student programs?<br />
                
                    <div align="center">
                        <input type="radio" name="prevOrgAffiliation" id="prevOrgAffiliationYes" value="1" onclick="document.getElementById('showQs').style.display='table-row';" <cfif FORM.prevOrgAffiliation EQ 1> checked="checked"</cfif> />
                        <label for="prevOrgAffiliationYes">Yes</label>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="radio" name="prevOrgAffiliation" id="prevOrgAffiliationNo" value="0" onclick="document.getElementById('showQs').style.display='none';" <cfif FORM.prevOrgAffiliation EQ 0> checked="checked"</cfif> />
                        <label for="prevOrgAffiliationNo">No</label>
                    </div> <br />
                    
                    <table width="100%" cellspacing="0" cellpadding="2" id="showQs" <cfif FORM.prevOrgAffiliation NEQ 1>style="display: none;"</cfif> >
                        <tr>	
                            <td>
                                If Yes, please indicate the name of the sponsor that you were affiliated with and list your dates of affiliation with that organization.<br />
                                <textarea name="prevAffiliationName" class="longTextAreaa">#FORM.prevAffiliationName#</textarea>
                            </td>
                        </tr>
                        <tr>	
                            <td>
                                Were there any issues with the prior organization(s)? If Yes, please explain<br />
                                <textarea name="prevAffiliationProblem" class="longTextAreaa">#FORM.prevAffiliationProblem#</textarea>
                            </td>
						</tr>                        
                    </table>
                    
                </div>
                
                <div class="clearfix"></div>
                
                <table width="100%" align="center">
                    <tr>
                        <td align="center">
                            <cfif VAL(FORM.employmentID)>
                                <input name="Submit" type="image" src="../pics/buttons/update_44.png" border="0">
                            <cfelse>
                                <input name="Submit" type="image" src="../pics/buttons/addEmployer.png" border="0">
                            </cfif>                            
                        </td>
                    </tr>
                </table>
                
            </form>                
        
    	</div> <!--- <div class="wrapper"> --->
 
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
    />

</cfoutput>