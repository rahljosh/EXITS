<!--- ------------------------------------------------------------------------- ----
	
	File:		_submit.cfm
	Author:		Marcus Melo
	Date:		September 22, 2010
	Desc:		Submit Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="#SESSION.CANDIDATE.isReadOnly#">
    <cfparam name="includeHeader" default="1">
	
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.submissionType" default="">
    
	<!--- Candidate ID --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">
	
    <cfscript>
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='submit');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='submit', foreignTable=APPLICATION.foreignTable, foreignID=FORM.candidateID);
 		
		// Get Application History
		qGetApplicationHistory = APPLICATION.CFC.ONLINEAPP.getApplicationHistory(foreignTable=APPLICATION.foreignTable, foreignID=FORM.candidateID);
		
		// Check if Application is complete, if not redirect to check list page.
		
		if ( 
			CLIENT.loginType NEQ 'user' 
		AND (
				NOT VAL(SESSION.CANDIDATE.isSection1Complete)
			OR
				NOT VAL(SESSION.CANDIDATE.isSection2Complete)
			OR
				NOT VAL(SESSION.CANDIDATE.isSection3Complete) 
			) ) {
				// Application is not complete - go to checkList page
				location("#CGI.SCRIPT_NAME#?action=checkList", "no");
		}
	
		
		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// FORM Submitted
		if ( FORM.submitted ) {

			// FORM Validation

			// Submission Type
			if ( NOT LEN(FORM.submissionType) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select an action in order to submit your application');
			}
			
			// Comments
			if ( FORM.submissionType EQ 'denied' AND NOT LEN(FORM[qGetQuestions.fieldKey[1]]) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must enter a reason in the comments box for denying this application.');
			}

			for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
				if (qGetQuestions.isRequired[i] AND NOT LEN(FORM[qGetQuestions.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestions.requiredMessage[i]);
				}
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestions.ID[i],
						foreignTable=APPLICATION.foreignTable,
						foreignID=FORM.candidateID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}

				// Submit Application & Email Candidate/Branch/Intl. Rep/NY Office			
				APPLICATION.CFC.ONLINEAPP.submitApplication(
					candidateID=FORM.candidateID,
					submissionType=FORM.submissionType,
					comments=FORM[qGetQuestions.fieldKey[1]]
				);
				
				// Update Candidate Session Variables
				APPLICATION.CFC.CANDIDATE.setCandidateSession(candidateID=FORM.candidateID);
							
				// Set Page Message
				SESSION.pageMessages.Add("Your application has been successfully submitted.");
				
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?action=submit", "no");
				
			}
			
		} else {
		
			// Online Application Fields 
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}
		
		}
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Page Header --->
<cfif includeHeader>
    <gui:pageHeader
        headerType="application"
    />
</cfif>

	<script type="text/javascript">
        // JQuery Validator
        $().ready(function() {
        
            var container = $('div.errorContainer');
            // validate the form when it is submitted
            var validator = $("##submitApp").validate({
                errorContainer: container,
                errorLabelContainer: $("ol", container),
                wrapper: 'li',
                meta: "validate"
            });
        
        });
    </script>
    
    <cfif includeHeader>
		<!--- Side Bar --->
        <div class="rightSideContent ui-corner-all">
    <cfelse>
		<!--- Print Version There is no Float - Application Body --->
        <div class="form-container">
	</cfif>

        <div class="insideBar">

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

            <!---  Our jQuery error container --->
            <div class="errorContainer">
                <p><em>Oops... the following errors were encountered:</em></p>
                                
                <ol>
                    <cfloop query="qGetQuestions">
                        <cfif qGetQuestions.isRequired>
                            <li><label for="#qGetQuestions.fieldKey#" class="error">#qGetQuestions.requiredMessage#</label></li>
                        </cfif>
                    </cfloop>
                </ol>
                
                <p>Data has <strong>not</strong> been saved.</p>
            </div>

			<!--- Application Body --->
            <div class="form-container">
                
                <form id="submitApp" action="#CGI.SCRIPT_NAME#?action=submit" method="post">
                <input type="hidden" name="submitted" value="1" />
				
				<cfif printApplication>
                    <p class="legend"><strong>Note:</strong> Your application has been submitted. </p>
				<cfelse>
                    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>). Once you submit your application you will no longer be able to make any changes. </p>
                </cfif>
                
				<!--- Submit Application --->
                <fieldset>
                   
                    <legend>Submit Application</legend>

					<!--- Submitted Information --->
                    <cfif printApplication>
                        <div class="field controlset">
                            <span class="label">Candidate </span>
                            <div class="printField">#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#</div>
                        </div>
                        
                        <div class="field controlset">
                            <span class="label">Application Submitted </span>
                            <div class="printField">#DateFormat(qGetApplicationHistory.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetApplicationHistory.dateCreated, 'hh:mm:ss tt')# EST</div>
                        </div>
                    </cfif>
                    
                    
                    <!--- Action --->
                    <cfif NOT printApplication>
                        <div class="field">
                            <label for="sex">Action <em>*</em></label> 
							<cfif CLIENT.loginType NEQ 'user'> 
                                <!--- Candidate - Submit Button --->                      
                                <select name="submissionType" id="submissionType" class="mediumField">
                                    <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Submit Application</option>
                                </select>
                            <cfelseif CLIENT.userID EQ qGetCandidateInfo.branchID>
                                <!--- Branch - Deny / Approve Button --->
                                <select name="submissionType" id="submissionType" class="mediumField">
                                    <option value=""></option> <!--- [select an action] --->
                                    <!--- Only display approve if section 3 is complete --->
									<cfif SESSION.CANDIDATE.isSection3Complete>
	                                    <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Approve Application</option>
                                    </cfif>
                                    <option value="denied" <cfif FORM.submissionType EQ 'denied'> selected="selected" </cfif> >Deny Application</option>
                                </select>
                            <cfelseif CLIENT.userID EQ qGetCandidateInfo.intRep>
                                <!--- Intl. Rep. - Deny / Approve Button --->
                                <select name="submissionType" id="submissionType" class="mediumField">
                                    <option value=""></option> <!--- [select an action] --->
									<!--- Only display approve if section 3 is complete --->
									<cfif SESSION.CANDIDATE.isSection3Complete>
    	                                <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Approve Application</option>
                                    </cfif>
                                    <option value="denied" <cfif FORM.submissionType EQ 'denied'> selected="selected" </cfif> >Deny Application</option>
                                </select>
                            <cfelseif CLIENT.userType LTE 4>
                                <!--- NY Office - Received / On Hold / Deny / Approve Button --->
                                <select name="submissionType" id="submissionType" class="mediumField">
                                    <option value=""></option> <!--- [select an action] --->
                                    <!--- <option value="received" <cfif FORM.submissionType EQ 'received'> selected="selected" </cfif> >Application Received</option> --->
                                    <option value="onhold" <cfif FORM.submissionType EQ 'onhold'> selected="selected" </cfif> >Application On Hold</option>
                                    <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Approve Application</option>
                                    <option value="denied" <cfif FORM.submissionType EQ 'denied'> selected="selected" </cfif> >Deny Application</option>
                                </select>
                            </cfif>  

							<cfif NOT SESSION.CANDIDATE.isSection3Complete>
                                <p class="note"><strong>Note:</strong> 
                                You can only deny an application at this moment. <br />
                                There are still some items missing. Click on <a href="#CGI.SCRIPT_NAME#?action=checkList">Checklist</a> to view them. </p>
                            </cfif>
                        </div>
                        
					</cfif>                    
                        
					<!--- Comments --->
                    <div class="field">
                        <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label>  
                        <cfif printApplication>
                            <div class="printFieldText">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
                        <cfelse>
                            <textarea name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" class="#qGetQuestions.classType[1]#">#FORM[qGetQuestions.fieldKey[1]]#</textarea>                                    	
                        </cfif>            
                    </div>

                </fieldset>                

				<cfif printApplication>
					<!--- Interview Instructions --->
                    <fieldset>
                       
                        <legend>Application Submission History</legend>
						
                        <cfloop query="qGetApplicationHistory">                        
                        	#DateFormat(qGetApplicationHistory.dateCreated, 'mm/dd/yyyy')# 
                            #TimeFormat(qGetApplicationHistory.dateCreated, 'hh-mm-ss tt')# EST 
                            &nbsp; - &nbsp;
                            #qGetApplicationHistory.description# <br />                        
                        </cfloop>
					</fieldset>
                </cfif>
					
				<cfif NOT printApplication>                                                    
                    <div class="buttonrow">
                        <input type="submit" value="Submit" class="button ui-corner-top" />
                    </div>
                </cfif>
            
                </form>
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<cfif includeHeader>
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
</cfif>

</cfoutput>
