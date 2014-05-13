<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		November 10, 2011
	Desc:		Trainee - Evaluation

	Updated:															
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param URL Variables --->
    <cfparam name="URL.uniqueID" default="">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.ds2019" default="">       
    <cfparam name="FORM.lastName" default="">
    <cfparam name="FORM.firstName" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.hasHousingChanged" default="">
    <cfparam name="FORM.housingChangedDetails" default="">
    <cfparam name="FORM.hostCompanyEvaluation" default="">
    <cfparam name="FORM.phaseAssessment" default="">
    <cfparam name="FORM.hasHostCompanyConcern" default="">
    <cfparam name="FORM.hostCompanyConcernDetails" default="">
    <cfparam name="FORM.culturalActivities" default="">
	
    <cfscript>
		// Set Current Month Evaluation
		vCurrentMonth = Month(now());
		
		// Set Month of Evaluation Report
		vMonthEvaluation = '';
		
		switch(vCurrentMonth) {
			// February
			case 2: case 3: case 4: 
				vMonthEvaluation = 2;
				break;
			// May
			case 5: case 6: case 7: 
				vMonthEvaluation = 5;
				break;
			// August
			case 8: case 9: case 10: 
				vMonthEvaluation = 8;
				break;
			// November
			case 11: case 12: case 1: 
				vMonthEvaluation = 11;
				break;
		}
	</cfscript>
    
    <cfquery name="qGetCandidateInfo" datasource="mysql">
		SELECT
        	candidateID,
            firstName,
            lastName,
            email,
            ds2019
        FROM
        	extra_candidates
        WHERE
            <cfif LEN(URL.uniqueID)>
                uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.uniqueID#">
            <cfelse>
            	1 != 1
            </cfif>
    </cfquery>

    <cfquery name="qCheckReportReceived" datasource="mysql">
        SELECT
            candidateID
        FROM
            extra_evaluation
        WHERE
            candidateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(qGetCandidateInfo.candidateID)#">
        AND	
            monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMonthEvaluation#">
    </cfquery>
    
	<!----First check to see if its being submitted---->
    <cfif FORM.submitted>
    
		<cfscript>
            // Data Validation
            
            // SEVIS Number
            if ( NOT LEN(TRIM(FORM.ds2019)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your SEVIS number.");
            }			

            // SEVIS Number
            if ( LEN(TRIM(FORM.ds2019)) AND Left(FORM.ds2019,1) NEQ 'N' ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("SEVIS number starts with an N, please make sure you enter a valid SEVIS number");
            }			
            
            // Last Name
            if ( NOT LEN(TRIM(FORM.lastName)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your Last Name.");
            }

            // First Name
            if ( NOT LEN(TRIM(FORM.firstName)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your First Name.");
            }

            // Email
            if ( NOT LEN(TRIM(FORM.email)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter your email address.");
            }

            // Email
            if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", FORM.email) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a valid email address.");
            }

            // Q5
            if ( NOT LEN(TRIM(FORM.hasHousingChanged)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the Yes/No question: Have you changed your housing address since your last report to ISE?");
            }

            // Q5 Expalin if Yes
            if ( VAL(FORM.hasHousingChanged) and NOT LEN(TRIM(FORM.housingChangedDetails) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You answered Yes to: Have you changed your housing address since your last report to ISE, but did not provide your new address.");
            }

            // Q6
            if ( NOT LEN(TRIM(FORM.hostCompanyEvaluation)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the Yes/No question: Have you changed your employer since your last report to ISE?");
            }
			
			// Q7
            if ( NOT LEN(TRIM(FORM.phaseAssessment)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the question: Please provide a short description/assessment of this phase in training.");
            }
            
            // Q8
            if ( NOT LEN(TRIM(FORM.hasHostCompanyConcern)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the Yes/No question: Do you have any current problems or concerns?");
            }
            
            // Q8 Expalin if Yes
            if ( VAL(FORM.hasHostCompanyConcern) AND NOT LEN(TRIM(FORM.hostCompanyConcernDetails) ) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("You answered Yes to: Do you have any current problems or concerns? but did not provide any details.  Please let us know your concerns.");
            }
			
			// Q9
            if ( NOT LEN(TRIM(FORM.culturalActivities)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer the question: Name/list cultural activities participated in outside of training.");
            }
        </cfscript>
        
		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        
			<!--- Try to Locate the Candidate --->
            <cfquery name="qLookUpCandidate" datasource="mysql">
                SELECT
                    candidateID
                FROM
                    extra_candidates
                WHERE
                    ds2019 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ds2019)#">
                AND
                    lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#TRIM(FORM.lastName)#%">
            </cfquery>
    	
            <cfscript>
                // Data Validation
                
                // SEVIS Number
                if ( NOT VAL(qLookUpCandidate.recordCount) ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("We could not locate your account, please make sure you typed in the correct SEVIS number");
                }			
            </cfscript>
            
            <cfquery name="qCheckReportReceived" datasource="mysql">
                SELECT
                    candidateID
                FROM
                    extra_evaluation
                WHERE
                    candidateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VAL(qLookUpCandidate.candidateID)#">
                AND	
                	monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMonthEvaluation#">
            </cfquery>
            
            <cfscript>
                // Data Validation
                
                // Report Already Submitted
                if ( qCheckReportReceived.recordCount ) {
                    // Get all the missing items in a list
                    SESSION.formErrors.Add("You have already submitted the #MonthAsString(vMonthEvaluation)# Quarterly Questionnaire. No action is required from you at this time. Thank you!");
                }			
            </cfscript>
        
        </cfif>
            
		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>

            <cfquery datasource="mysql">
                INSERT INTO
                	extra_evaluation
                (
                	candidateID,
                    monthEvaluation,
                    hasHousingChanged,
                    housingChangedDetails,
                    hostCompanyEvaluation,
                    hasHostCompanyConcern,
                    hostCompanyConcernDetails,
                    phaseAssessment,
                    culturalActivities,
                    dateCreated
                )
                	VALUES 
              	(
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#qLookUpCandidate.candidateID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#vMonthEvaluation#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.hasHousingChanged)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.housingChangedDetails#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hostCompanyEvaluation#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.hasHostCompanyConcern)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hostCompanyConcernDetails#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phaseAssessment#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.culturalActivities#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )  
            </cfquery>
        	
            <cfsavecontent variable="reportDetails">
            	<cfoutput>
                    <h3>ISE - Mandatory Trainee #MonthAsString(vMonthEvaluation)# Quarterly Questionnaire - #DateFormat(Now(), 'mm/dd/yyyy')#.</h3>
                    
                    <p>1. SEVIS Number: <strong>#FORM.ds2019#</strong> </p>
                    
                    <p>2. Last name: <strong>#FORM.lastName# (###qLookUpCandidate.candidateID#)</strong> </p>
                    
                    <p>3. First name: <strong>#FORM.firstName#</strong> </p>
    
                    <p>4. Email: <strong>#FORM.email#</strong> </p>
                    
                    <p>
                        5. Have you changed your housing address, email and contract phone since your last report to ISE? <br />
                        <strong>#YesNoFormat(VAL(FORM.hasHousingChanged))#</strong> 
                    </p>
                    
                    <p>
                        <i>If Yes and you did not previously inform ISE, please provide your full new housing address:</i> <br />
                        <strong>#FORM.housingChangedDetails#</strong>
                    </p>
                    
                    <p>
                        6. Please write a short evaluation of your host company in the space provided <br />
                        <strong>#FORM.hostCompanyEvaluation#</strong> 
                    </p>
                    
                    <p>
                        7. Please provide a short description/assessment of this phase in training <br />
                        <strong>#FORM.phaseAssessment#</strong> 
                    </p>
                    
                    <p>
                        8. Do you have any current problems or concerns about the program or your host company? <br />
                        <strong>#YesNoFormat(VAL(FORM.hasHostCompanyConcern))#</strong> 
                    </p>
                    
                    <p>
                        <i>If Yes, please list and provide full details (where/what/who/why):</i> <br />
                        <strong>#FORM.hostCompanyConcernDetails# </strong>
                    </p>
                    
                    <p>
                        9. Name/list cultural activities participated in outside of training <br />
                        <strong>#FORM.culturalActivities#</strong> 
                    </p>
                </cfoutput>            
            </cfsavecontent>
            
            <cfmail 
            	to="ryan@iseusa.com" 
                <!--- cc="#FORM.email#"  --->
                from="info@csb-usa.com" 
                subject="#FORM.lastName# #FORM.firstName# (###qLookUpCandidate.candidateID#) - ISE Trainee #MonthAsString(vMonthEvaluation)# Quarterly Questionnaire Submitted" type="html">
                #reportDetails#
			</cfmail>
                
        </cfif>
    
    <!--- FORM NOT SUBMITTED --->
    <cfelse>
    
    	<cfscript>
			// Auto populate these fields
			FORM.ds2019 = qGetCandidateInfo.ds2019;
			FORM.lastName = qGetCandidateInfo.lastName;
			FORM.firstName = qGetCandidateInfo.firstName;
			FORM.email = qGetCandidateInfo.email;
		</cfscript>
        
    </cfif>
    
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>ISE Trainee #MonthAsString(vMonthEvaluation)# Quarterly Questionnaire</cfoutput></title>
<link rel="stylesheet" href="../../linked/css/baseStyle.css" type="text/css">
<style type="text/css">
	body table  {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
		color: #000;
	}
	.bold {
		font-weight: bold;
	}
	.wrapper {
		margin-right: auto;
		margin-left: auto;
		width: 600px;
		border: thin solid #999;
		padding: 5px;
	}
	.grey {
		background-color: #f4f4f4;
		padding: 10px;
	}
	.header {
		background-color: #374c87;
		font-family: Georgia, "Times New Roman", Times, serif;
		font-size: 19px;
		font-weight: bold;
		color: #FFF;
		text-align: center;
		padding-top: 20px;
		padding-right: 10px;
		padding-bottom: 20px;
		padding-left: 10px;
	}
	.footer {
		background-color: #374c87;
		font-family: Georgia, "Times New Roman", Times, serif;
		font-size: 12px;
		font-weight: bold;
		color: #FFF;
		text-align: center;
		padding-top: 10px;
		padding-right: 5px;
		padding-bottom: 10px;
		padding-left: 5px;
	}
	.info {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
		padding-top: 15px;
		padding-right: 10px;
		padding-bottom: 15px;
		padding-left: 10px;
		font-weight:bold;
	}
	a:link {
		color: #FF0;
		text-decoration: none;
	}
	a:visited {
		text-decoration: none;
		color: #FF0;
	}
	a:hover {
		text-decoration: none;
		color: #FFF;
	}
	a:active {
		text-decoration: none;
		color: #FF0;
	}
	.red {
		color: #C00;
	}
	.required {
		padding:0px 5px 0px 5px;
		color: #C00;
	}
	.largeField {
		width:250px;	
	}
	.largeTextArea {
		width:380px;
		height:100px;
	}
</style>
</head>
<body>

<cfoutput>

    <div class="wrapper">
    
        <div class="header">ISE Trainee #MonthAsString(vMonthEvaluation)# Quarterly Questionnaire</div>
        
		<!--- Check if there are no errors --->
        <cfif FORM.submitted AND NOT SESSION.formErrors.length()>

            <div class="info">
                <h3>The following information has been succesfully submitted to ISE.</h3>
            </div>
            
            <div class="grey">
            	
                <table width="90%" align="center">
                    <tr>
                        <td class="text">#reportDetails#</td>
                    </tr>
                </table>
                
            </div>
        
        <!--- Display FORM --->
        <cfelse>

            <div class="info">
                <span class="red">The ISE Quarterly questionnaire is below</span> - there are 7 (seven) questions you must answer. <br /> 
                <span class="red">You must respond in full within 10 (ten) business days</span> of receiving this  questionnaire.
            </div>
        
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="section"
                />

			<!--- Report Received --->
            <cfif qCheckReportReceived.recordCount>
                <div class="errors">
                    <p>You have already submitted the #MonthAsString(vMonthEvaluation)# Quarterly Questionnaire.</p>
                    <p>&nbsp;</p>
                    <p>No action is required from you at this time. Thank you!</p>
                </div>
            </cfif>  
            
            <div class="grey">
            	
                <cfform name="form" id="form" action="#CGI.SCRIPT_NAME#" method="post">
                    <input type="hidden" name="submitted" value="1"/>
                    
                    <table width="560" border="0" cellspacing="0" cellpadding="5">
                        <tr>
                            <td width="150" class="bold"><label for="ds2019">1. SEVIS Number:</label> <span class="required">*</span></td>
                            <td width="400"><input type="text" name="ds2019" id="ds2019" value="#FORM.ds2019#" class="largeField" /></td>
                        </tr>
                        <tr>
                            <td class="bold"><label for="lastName">2. Last Name:</label> <span class="required">*</span></td>
                            <td><input type="text" name="lastName" id="lastName"  value="#FORM.lastName#"  class="largeField" /></td>
                        </tr>
                        <tr>
                            <td class="bold"><label for="firstName">3. First Name:</label> <span class="required">*</span></td>
                            <td><input type="text" name="firstName" id="firstName"  value="#FORM.firstName#" class="largeField" /></td>
                        </tr>
                        <tr>
                            <td class="bold"><label for="email">4. E-mail:</label> <span class="required">*</span></td>
                            <td><input type="text" name="email" id="email" value="#FORM.email#" class="largeField" /></td>
                        </tr>
                        
                        <tr><td colspan="2"><hr /></td></tr>
                        
                        <tr>
                            <td colspan="2" class="bold">5. Have you changed your housing address, email and contract phone since your last report to ISE? <span class="required">*</span></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="radio" name="hasHousingChanged" id="hasHousingChangedYes" value="1" <cfif FORM.hasHousingChanged EQ 1>checked</cfif> />
                                <label for="hasHousingChangedYes">Yes</label>
                                &nbsp; &nbsp;
                                <input type="radio" name="hasHousingChanged" id="hasHousingChangedNo" value="0" <cfif FORM.hasHousingChanged EQ 0>checked</cfif> />
                                <label for="hasHousingChangedNo">No</label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="bold">
                                <label for="housingChangedDetails">If Yes and you did not previously inform ISE, please provide your full new housing address, email and contact phone number</label> 
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><textarea name="housingChangedDetails" id="housingChangedDetails" class="largeTextArea">#FORM.housingChangedDetails#</textarea></td>
                        </tr>
                        
                        <tr><td colspan="2"><hr /></td></tr>
                        
                        <tr>
                            <td colspan="2" class="bold">
                                <label for="hostCompanyEvaluation">6. Please write a short evaluation of your host company in the space provided</label> 
                                <span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><textarea name="hostCompanyEvaluation" id="hostCompanyEvaluation" class="largeTextArea">#FORM.hostCompanyEvaluation#</textarea></td>
                        </tr>
                        
                        <tr><td colspan="2"><hr /></td></tr>
                        
                        <tr>
                            <td colspan="2" class="bold">
                                <label for="phaseAssessment">7. Please provide a short description/assessment of this phase in training</label> 
                                <span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><textarea name="phaseAssessment" id="phaseAssessment" class="largeTextArea">#FORM.phaseAssessment#</textarea></td>
                        </tr>
                        
                        <tr><td colspan="2"><hr /></td></tr>
                        
                        <tr>
                            <td colspan="2" class="bold">
                                8. Do you have any current problems or concerns about the program or your host company?
                                <span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="radio" name="hasHostCompanyConcern" id="hasHostCompanyConcernYes" value="1" <cfif FORM.hasHostCompanyConcern EQ 1>checked</cfif> />
                                <label for="hasHostCompanyConcernYes">Yes</label>
                                &nbsp; &nbsp;
                                <input type="radio" name="hasHostCompanyConcern" id="hasHostCompanyConcernNo" value="0" <cfif FORM.hasHostCompanyConcern EQ 0>checked</cfif> />
                                <label for="hasHostCompanyConcernNo">No</label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"  class="bold"><label for="hostCompanyConcernDetails">If Yes, please list and provide full details (where/what/who/why)</label></td>
                        </tr>
                        
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <textarea name="hostCompanyConcernDetails" id="hostCompanyConcernDetails" class="largeTextArea">#FORM.hostCompanyConcernDetails#</textarea>
                            </td>
                        </tr>
                        
                        <tr><td colspan="2"><hr /></td></tr>
                        
                        <tr>
                            <td colspan="2" class="bold">
                                <label for="culturalActivities">9. Name/list cultural activities participated in outside of training</label> 
                                <span class="required">*</span>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><textarea name="culturalActivities" id="culturalActivities" class="largeTextArea">#FORM.culturalActivities#</textarea></td>
                        </tr>
                        
                        <tr><td colspan="2"><hr /></td></tr>
                        
                        <tr><td colspan="2"><span class="required">*Required Fields</span></td></tr>
                        
                        <cfif NOT VAL(qCheckReportReceived.recordCount)>
                            <tr>
                                <td colspan="2" align="center" valign="middle"><input type="submit" name="submit" id="submit" value="Submit" /></td>
                            </tr>
                        </cfif>
                        
                    </table>
                </cfform>
                
            </div>
            
            <div class="info">
                <span class="red"><strong>NOTE:<i>Failure to respond in a timely manner may negatively affect your program. It is very important that you respond.</i></strong></span>
            </div>
            
            <div class="footer">
                For more information please contact us at <br />
                
                1-877-669-0717
                
                &nbsp;&nbsp;|&nbsp;&nbsp;
                
                <a href="mailto:ryan@iseusa.com" shape="rect" target="_blank">ryan@iseusa.com</a>
                
                &nbsp;&nbsp;|&nbsp;&nbsp;
                
                <a shape="rect" href="http://www.csb-usa.com" target="_blank">www.csb-usa.com</a>
            </div>    
            
        </cfif>
	
    </div>
        
</cfoutput> 
   
</body>
</html>
