<!--- ------------------------------------------------------------------------- ----
	
	File:		_submit.cfm
	Author:		Marcus Melo
	Date:		July 07, 2010
	Desc:		Submit Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">
    <cfparam name="includeHeader" default="1">
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <!--- Student ID --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
	<!--- Semester Information --->
    <cfparam name="FORM.semesterID" default="">
    <cfparam name="FORM.academicYear" default="">
       
    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='submit');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='submit', foreignTable='student', foreignID=FORM.studentID);
 
		// Get Semester Options
		qGetSemesters = APPLICATION.CFC.LOOKUPTABLES.getApplicationLoopUp(fieldKey='semester');
		
		qGetApplicationHistory = APPLICATION.CFC.ONLINEAPP.getApplicationHistory(applicationStatusID=3, foreignTable='student', foreignID=FORM.studentID);
		
		// Check if Application is complete, if not redirect to check list page.
		if ( 
			NOT VAL(SESSION.STUDENT.isSection1Complete)
		OR
			NOT VAL(SESSION.STUDENT.isSection2Complete)
		OR
			( VAL(SESSION.STUDENT.hasAddFamInfo) AND NOT VAL(SESSION.STUDENT.isSection3Complete) )
		OR
			NOT VAL(SESSION.STUDENT.isSection4Complete)
		OR
			NOT VAL(SESSION.STUDENT.isSection5Complete) ) {
				// Application is not complete - go to checkList page
				location("#CGI.SCRIPT_NAME#?action=checkList", "no");
		}
		
		// Check if Application Fee has been paid, if not redirect to application fee page.
		if ( NOT VAL(qGetStudentInfo.applicationPaymentID) ) {	
			// Application fee has not been paid - go to the application fee page
			location("#CGI.SCRIPT_NAME#?action=applicationFee", "no");
		}

		// Set Application Read Only
		if ( APPLICATION.CFC.STUDENT.getStudentSession().isApplicationSubmitted )  {
			printApplication = 1;
		}
		
		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// FORM Submitted
		if ( FORM.submitted ) {

			// FORM Validation
			for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
				if (qGetQuestions.isRequired[i] AND NOT LEN(FORM[qGetQuestions.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestions.requiredMessage[i]);
				}
			}
			
			// Please Specify
			if ( FORM[qGetQuestions.fieldKey[1]] EQ 3 AND NOT LEN(FORM[qGetQuestions.fieldKey[2]]) ) {
				SESSION.formErrors.Add("Please specify other time during the school year");
			}

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Reset Value
				FORM[qGetQuestions.fieldKey[1]] = qGetSemesters.name[FORM[qGetQuestions.fieldKey[1]]];
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestions.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}

				// Submit Application				
				APPLICATION.CFC.STUDENT.updateApplicationStatusID(
					ID=FORM.studentID,
					applicationStatusID=3
				);

				// Update Student Session Variables
				APPLICATION.CFC.STUDENT.setStudentSession(ID=FORM.studentID);

				// Insert Application History
				APPLICATION.CFC.ONLINEAPP.insertApplicationHistory(
					applicationStatusID=3,
					foreignTable='student',
					foreignID=FORM.studentID,
					description='Application Submitted'
				);

				// Email Student 
				APPLICATION.CFC.EMAIL.sendEmail(
					emailTo=qGetStudentInfo.email,						
					emailType='applicationSubmitted',
					studentID=FORM.studentID
				);

				// Create Zip file and include application documents
				applicationZipFile = APPLICATION.CFC.onlineApp.saveApplicationToZip(studentID=FORM.studentID);
				
				// Email Admissions Office
				APPLICATION.CFC.EMAIL.sendEmail(
					emailTo=APPLICATION.EMAIL.admissions,						
					emailType='applicationSubmittedAdmissions',
					emailFilePath=applicationZipFile,
					studentID=FORM.studentID
				);
				
				// Set Page Message
				SESSION.pageMessages.Add("Your application has successfully been submitted.");
				
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
                    <p class="legend"><strong>Note:</strong> Application has been submitted.</p>
                <cfelse>
                    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>). Once you submit your application you will no longer be able to make any changes. </p>
                </cfif>
                
				<!--- Submit Application --->
                <fieldset>
                   
                    <legend>Application Options</legend>

					<!--- Submitted Information --->
                    <cfif printApplication>
                        <div class="field controlset">
                            <span class="label">Student </span>
                            <div class="printField">#qGetStudentInfo.firstName# #qGetStudentInfo.lastName#</div>
                        </div>
                        
                        <div class="field controlset">
                            <span class="label">Application Submitted </span>
                            <div class="printField">#DateFormat(qGetApplicationHistory.dateCreated, 'mm/dd/yyyy')# at #TimeFormat(qGetApplicationHistory.dateCreated, 'hh:mm:ss tt')# EST</div>
                        </div>
                    </cfif>
                    
                    <!--- Semester Option --->
                    <div class="field">
                        <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
                        <cfif printApplication>
                            <div class="printField">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
                        <cfelse>
                            <select name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" class="#qGetQuestions.classType[1]#" onchange="displaySemesterDetail(this.value)">
                            	<option value=""></option>
                            	<cfloop query="qGetSemesters">
                            		<option value="#qGetSemesters.ID#" <cfif FORM[qGetQuestions.fieldKey[1]] EQ qGetSemesters.name> selected="selected" </cfif> >#qGetSemesters.name#</option>
                                </cfloop>
							</select>                                
						</cfif>
                    </div>

					<cfif printApplication>
						<!--- Semester Option Detail - Print Application --->
                        <div class="field">
                            <label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <em>*</em></label> 
                            <div class="printField">#FORM[qGetQuestions.fieldKey[2]]# &nbsp;</div>
                        </div>
                    <cfelse>
						<!--- Semester Option Detail --->
                        <div id="semesterDetailDiv" class="field hiddenField">
                            <label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <em>*</em></label> 
                            <input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="100" />
                        </div>
                    </cfif>

                    <!--- Academic Year --->            
                    <div class="field">
                        <label for="#qGetQuestions.fieldKey[3]#">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></label> 
                        <cfif printApplication>
                            <div class="printField">#FORM[qGetQuestions.fieldKey[3]]# &nbsp;</div>
                        <cfelse>
                            <select name="#qGetQuestions.fieldKey[3]#" id="#qGetQuestions.fieldKey[3]#" class="#qGetQuestions.classType[3]#">
                            	<option value=""></option>
                            	<cfloop from="#Year(now())#" to="#Year(now()) + 3#" index="i">
                            		<!--- Remove this IF in 2011 --->
									<cfif i NEQ 2010>
	                                    <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[3]] EQ i> selected="selected" </cfif> >#i#</option>
                                    </cfif>    
                                </cfloop>
							</select>                                
						</cfif>
                    </div>

                </fieldset>                
					
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

<script type="text/javascript">
	// Display State Fields
	$(document).ready(function() {
		// Get Current Selected Semester
		selectedSemester = $("###qGetQuestions.fieldKey[1]#").val();
		displaySemesterDetail(selectedSemester);
	});
</script>

</cfoutput>

