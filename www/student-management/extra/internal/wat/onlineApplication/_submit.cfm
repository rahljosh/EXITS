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
	<cfparam name="printApplication" default="#APPLICATION.CFC.CANDIDATE.getCandidateSession().isReadOnly#">
    <cfparam name="includeHeader" default="1">
    <cfparam name="displaySubmit" default="0">
	
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.submissionType" default="">
    <cfparam name="FORM.forcePrintApplication" default="0">
    
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
		if ( CLIENT.loginType NEQ 'user' AND NOT VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().isApplicationComplete) ) {
			// Application is not complete - go to checkList page
			location("#CGI.SCRIPT_NAME#?action=checkList", "no");
		// Intl. Reps should be able to deny/approve application.
		} else if ( 
				CLIENT.loginType EQ 'user' 
			AND 
				CLIENT.userType GT 4 
			AND 
				VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().isOfficeApplication)
			AND 
				NOT VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().isApplicationComplete) 
		) {
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
				
			} else {
				
				// Reset print application
				printApplication = APPLICATION.CFC.CANDIDATE.getCandidateSession().isReadOnly;
	
			}
			
		} else {
		
			// Online Application Fields 
			/*
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}
			*/
		
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
							
							<!--- Candidate --->
							<cfif CLIENT.loginType NEQ 'user'> 

                                <cfif ListFind("2,4,6", APPLICATION.CFC.CANDIDATE.getCandidateSession().applicationStatusID)>

                                    <cfscript>
										// Display submit button
										displaySubmit = 1;
									</cfscript>
                                	
                                    <select name="submissionType" id="submissionType" class="mediumField">
                                        <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Submit Application</option>
                                    </select>
                            
                            	<cfelse>
                                
                                    <p><strong>Note:</strong> 
                                    	Application has been submitted. <br />
                                	</p>

                                </cfif>
                            
							<!--- Branch ---> 
							<cfelseif qGetCandidateInfo.branchID EQ CLIENT.userID>
                            	   
                                <cfif ListFind("3,6", APPLICATION.CFC.CANDIDATE.getCandidateSession().applicationStatusID)>

                                    <cfscript>
										// Display submit button
										displaySubmit = 1;
									</cfscript>
                                	
									<!--- Branch / Intl. Rep - Deny / Approve Button --->
                                    <select name="submissionType" id="submissionType" class="mediumField">
                                        <option value=""></option> <!--- [select an action] --->
                                        <!--- Only display approve if section 3 is complete --->
                                        <cfif APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection3Complete>
                                            <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Approve Application</option>
                                        </cfif>                                        
                                        <option value="denied" <cfif FORM.submissionType EQ 'denied'> selected="selected" </cfif> >Deny Application</option>
                                    </select>
                            
                            	<cfelse>
                                
                                    <p><strong>Note:</strong> 
                                    	Application has NOT been submitted for your approval. #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# must submit this application first. <br />
                                	</p>

                                </cfif>
							
                            <!--- Intl. Rep --->
							<cfelseif qGetCandidateInfo.intRep EQ CLIENT.userID>
									
                                <cfif ListFind("5,9", APPLICATION.CFC.CANDIDATE.getCandidateSession().applicationStatusID)>

                                    <cfscript>
										// Display submit button
										displaySubmit = 1;
									</cfscript>
                                	
									<!--- Branch / Intl. Rep - Deny / Approve Button --->
                                    <select name="submissionType" id="submissionType" class="mediumField">
                                        <option value=""></option> <!--- [select an action] --->
                                        <!--- Only display approve if application is fully complete --->
                                        <cfif VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().isApplicationComplete)>
                                            <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Approve Application</option>
                                        </cfif>
                                        <cfif NOT VAL(APPLICATION.CFC.CANDIDATE.getCandidateSession().isOfficeApplication)>
                                        	<option value="denied" <cfif FORM.submissionType EQ 'denied'> selected="selected" </cfif> >Deny Application</option>
                                        </cfif>
                                    </select>
                            
                            	<cfelse>
                                
                                    <p><strong>Note:</strong> 
                                    	Application has NOT been submitted for your approval. #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName# must submit this application first. <br />
                                	</p>

                                </cfif>
                            
                            <!--- NY Office --->                           
                            <cfelseif CLIENT.userType LTE 4>
                                
                                <cfif ListFind("7,8,9,10", APPLICATION.CFC.CANDIDATE.getCandidateSession().applicationStatusID)>

                                    <cfscript>
										// Display submit button
										displaySubmit = 1;
									</cfscript>
                                    
									<!--- NY Office - Received / On Hold / Deny / Approve Button --->
                                    <select name="submissionType" id="submissionType" class="mediumField">
                                        <option value=""></option> <!--- [select an action] --->
                                        <!--- 
										<option value="received" <cfif FORM.submissionType EQ 'received'> selected="selected" </cfif> >Application Received</option>
										<option value="onhold" <cfif FORM.submissionType EQ 'onhold'> selected="selected" </cfif> >Application On Hold</option>
										 --->
                                        <option value="approved" <cfif FORM.submissionType EQ 'approved'> selected="selected" </cfif> >Approve Application</option>
                                        <option value="denied" <cfif FORM.submissionType EQ 'denied'> selected="selected" </cfif> >Deny Application</option>
                                    </select>
								
                                <cfelse>
                                	
                                    <p><strong>Note:</strong> 
                                    	Application has NOT been submitted to NY Office. <br />
                                        You can only approve/deny this application once it's been submitted by #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#.
                                	</p>
                                    
                                </cfif>
                                	                                
                            </cfif>  
							
                            <!--- Deny Only Note --->
							<cfif NOT APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection3Complete AND displaySubmit>
                                <p class="note"><strong>Note:</strong> 
                                You can only deny an application at this moment. <br />
                                There are still some missing items. Click on <a href="#CGI.SCRIPT_NAME#?action=checkList">Checklist</a> to view them. </p>
                            </cfif>
                        </div>
                        
					</cfif>                    
                    
					<!--- Comments --->
                    <cfif displaySubmit>
                        <div class="field">
                            <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label>  
                            <cfif printApplication>
                                <div class="printFieldText">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
                            <cfelse>
                                <textarea name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" class="#qGetQuestions.classType[1]#">#FORM[qGetQuestions.fieldKey[1]]#</textarea>                                    	
                            </cfif>            
                        </div>
					</cfif>
                    
                </fieldset>                

				<!--- Submission History --->
                <fieldset>
                   
                    <legend>Application Submission History</legend>

                    <div class="table">
                        <div class="th">
                            <div class="tdXLarge">Date</div>
                            <div class="tdXXLarge">Status</div>
                            <div class="tdXXLarge">Comments</div>
                            <div class="clearBoth"></div>
						</div>                            
                        <cfloop query="qGetApplicationHistory">      
                            <div <cfif qGetApplicationHistory.currentRow MOD 2> class="tr" <cfelse> class="trOdd" </cfif> >
                                <div class="tdXLarge">
                                	#DateFormat(qGetApplicationHistory.dateCreated, 'mm/dd/yy')#
                                    #TimeFormat(qGetApplicationHistory.dateCreated, 'hh-mm-ss tt')# EST
                                </div>
                                <div class="tdXXLarge">#qGetApplicationHistory.description#</div>
                                <div class="tdXXLarge">
                                	<cfif LEN(qGetApplicationHistory.comments)>
                                    	#qGetApplicationHistory.comments# 
                                    <cfelse>
                                    	n/a
                                    </cfif>
                                </div>
                                <div class="clearBoth"></div>
                            </div>                            
                        </cfloop>
                	</div>

                </fieldset>
				
				<cfif NOT printApplication AND displaySubmit>                                                    
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
