<!--- ------------------------------------------------------------------------- ----
	
	File:		_section3.cfm
	Author:		Marcus Melo
	Date:		August 10, 2010
	Desc:		Section 3 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
    
	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="#APPLICATION.CFC.CANDIDATE.getCandidateSession().isReadOnly#">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="2">
    <!--- Interview Date --->
    <cfparam name="FORM.dateInterview" default="">
    <cfparam name="FORM.dateInterviewMonth" default="">
    <cfparam name="FORM.dateInterviewDay" default="">
    <cfparam name="FORM.dateInterviewYear" default="">
    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">

    <cfscript>
		// Get Current Candidate Information
		// qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);
		
		if ( CLIENT.loginType NEQ 'user' ) {
			printApplication = 1;
		}
		
		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section3');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section3', foreignTable=APPLICATION.foreignTable, foreignID=FORM.candidateID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// FORM Submitted
		if ( FORM.submittedType EQ 'section3' ) {

			// Date Interview
			FORM[qGetQuestions.fieldKey[4]] = FORM.dateInterviewMonth & '/' & FORM.dateInterviewDay & '/' & FORM.dateInterviewYear;

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

				// Update Candidate Session Variables
				APPLICATION.CFC.CANDIDATE.setCandidateSession(candidateID=FORM.candidateID);
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");
				
			}
			
		} else {
			
			// Online Application Fields 
			for ( i=1; i LTE qGetAnswers.recordCount; i=i+1 ) {
				FORM[qGetAnswers.fieldKey[i]] = qGetAnswers.answer[i];
			}
			
			if ( qGetAnswers.recordCount GTE 5 ) {
				
				FORM.dateInterview = FORM[qGetAnswers.fieldKey[4]];
				// Break down interview date						
				if ( IsDate(FORM[qGetAnswers.fieldKey[4]]) ) {
					FORM.dateInterviewMonth = Month(FORM[qGetAnswers.fieldKey[4]]);
					FORM.dateInterviewDay = Day(FORM[qGetAnswers.fieldKey[4]]);
					FORM.dateInterviewYear = Year(FORM[qGetAnswers.fieldKey[4]]);
				} 
				
			}
		}
	</cfscript>
    
</cfsilent>

<script type="text/javascript">
	// Date picker
	$(function() {
		$(".datepicker").datepicker();
	});	
</script>

<cfoutput>

<!--- Application Body --->
<div class="form-container">
  
  	<!--- Only Display Messages if Current tab is updated --->
  	<cfif currentTabID EQ 2>
    
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
		
	</cfif>
       
    <form id="section3Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedType" value="section3" />
    <input type="hidden" name="currentTabID" value="2" />
    <input type="hidden" name="candidateID" id="candidateID" value="#FORM.candidateID#" />
    
    <p class="legend">
    	<strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)
	    <cfif NOT printApplication>
	        <a href="#CGI.SCRIPT_NAME#?action=printApplication&sectionName=section3"><img src="../../pics/onlineApp/printhispage.gif" border="0"/></a> 
        </cfif>
    </p>
    
    <!--- Personal Data --->
    <fieldset>
       
        <legend>English Assessment</legend>
		
        <cfif CLIENT.loginType NEQ 'user'>
       		<h3 class="h2Message">This page must be completed by #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#.</h3>
        </cfif>
        
        <!--- Notes --->
        <div class="field">
        	<label>CSB Scale Score (1 to 10):</label> 
            
                <p class="paddingNote">1 to 4 - Poor</p>
                <p class="paddingNote">5 to 6 - Fair</p>
                <p class="paddingNote">7 to 8 - Good</p>
                <p class="paddingNote">9 to 10 - Excellent</p>
            
        </div>
        
        <div class="field">
            <label>CSB International Representative <em>*</em></label> 
            <div class="printField">#APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName# &nbsp;</div>
        </div>

        <div class="field">
            <label>Participant's Name <em>*</em></label> 
            <div class="printField">#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastname# &nbsp;</div>
        </div>

		<!--- English Level --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[1]#"><strong>#qGetQuestions.displayField[1]#</strong> <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" class="#qGetQuestions.classType[1]#">
                    <option value=""></option>
                    <cfloop from="1" to="10" index="i">
                        <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[1]] EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
			</cfif>
		</div>
        
        <br />
        
        <!--- English Reading Level --->
        <div style="margin-left:5px;">
            <strong><u>Reading</u></strong>
            <br />
            <font size="-3">
                1 to 4 – Poor: Reads and understands simple words and can explain little or none of the text’s meaning.<br />
                5 to 6 – Fair: Reads some of the vocabulary and explains basic ideas.<br />
                7 to 8 – Good: Reads well and can explain most of the ideas.<br />
                9 to 10 – Excellent: Reads with few errors and easily explains the meaning.<br />
            </font>
            <br />
            &nbsp;When asked to read aloud in English from a book, magazine, or newspaper, the participant scored:
		</div>
		<div class="field">
			<label for="#qGetQuestions.fieldKey[6]#">&nbsp;<cfif qGetQuestions.isRequired[6]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[6]]# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestions.fieldKey[6]#" id="#qGetQuestions.fieldKey[6]#" class="#qGetQuestions.classType[6]#">
                    <option value=""></option>
                    <cfloop from="1" to="10" index="i">
                        <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[6]] EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
			</cfif>
		</div>
        
        <!--- English Writing Level --->
        <div style="margin-left:5px;">
            <strong><u>Writing</u></strong>
            <br />
            <font size="-3">
                1 to 4 – Poor: Uses a limited vocabulary and is difficult to understand.<br />
                5 to 6 – Fair: Writes only simple sentences, grammar is irregular and hardly understandable.<br />
                7 to 8 – Good: May use irregular grammar, but uses fair vocabulary and is understandable.<br />
                9 to 10 – Excellent: Writes fluently with a great vocabulary and sentence structure.<br />
            </font>
            <br />
            &nbsp;When asked to write a short essay in English stating what he or she hopes to gain from the SWT experience, the participant scored:
		</div>
		<div class="field">
			<label for="#qGetQuestions.fieldKey[7]#">&nbsp;<cfif qGetQuestions.isRequired[7]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[7]]# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestions.fieldKey[7]#" id="#qGetQuestions.fieldKey[7]#" class="#qGetQuestions.classType[7]#">
                    <option value=""></option>
                    <cfloop from="1" to="10" index="i">
                        <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[7]] EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
			</cfif>
		</div>
        
        <!--- English Verbal Level --->
        <div style="margin-left:5px;">
            <strong><u>Verbal</u></strong>
            <br />
            <font size="-3">
                1 to 4 – Poor: Understands solely Basic English and is translating.<br />
                5 to 6 – Fair: The speaking ability is limited and easily reverts to native language.<br />
                7 to 8 – Good: Understands most conversation, slow at times, but with appropriate answers and is able to pose necessary questions correctly.<br />
                9 to 10 – Excellent: Understands and responds to difficult questions by being nearly fluent.<br />
            </font>
            <br />
            &nbsp;Estimate the participant’s ability to understand and speak English after engaging him/her in English-only conversation about current events:
       	</div>
		<div class="field">
			<label for="#qGetQuestions.fieldKey[8]#">&nbsp;<cfif qGetQuestions.isRequired[8]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[8]]# &nbsp;</div>
        	<cfelse>
                <select name="#qGetQuestions.fieldKey[8]#" id="#qGetQuestions.fieldKey[8]#" class="#qGetQuestions.classType[8]#">
                    <option value=""></option>
                    <cfloop from="1" to="10" index="i">
                        <option value="#i#" <cfif FORM[qGetQuestions.fieldKey[8]] EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
			</cfif>
		</div>
        
        <!--- English Success Potential --->
        <div style="margin-left:5px;">
            <strong>
                Please briefly comment below about the participant's potential for success and any other information you think will assist in the evaluation of this participant:
            </strong>
            <br />
     		&nbsp;<font color="red"><b>Attention:</b> This is an official record.</font>
		</div>
		<div class="field">
        	<label for="#qGetQuestions.fieldKey[9]#">&nbsp;<cfif qGetQuestions.isRequired[9]><em>*</em></cfif></label>
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[9]]# &nbsp;</div>
        	<cfelse>
            	<textarea name="#qGetQuestions.fieldKey[9]#" id="#qGetQuestions.fieldKey[9]#" class="#qGetQuestions.classType[9]#" rows="4" cols="50">#FORM[qGetQuestions.fieldKey[9]]#</textarea>
			</cfif>
		</div>

		<!--- Slep Score --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# (if any) <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[2]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Interviewer Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[3]#">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[3]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[3]#" id="#qGetQuestions.fieldKey[3]#" value="#FORM[qGetQuestions.fieldKey[3]]#" class="#qGetQuestions.classType[3]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Interviewer Signature --->
        <div class="field">
            <label>Interviewer Signature <em>*</em></label> 
            <div class="printField"> &nbsp; </div>
        </div>
       
        <!--- Date --->
        <div class="field">
			<label for="dateInterviewMonth">#qGetQuestions.displayField[4]# <cfif qGetQuestions.isRequired[4]><em>*</em></cfif></label>            
            <cfif printApplication>
				<div class="printField">
                	<cfif IsDate(FORM.dateInterview)>	
                        #MonthAsString(FORM.dateInterviewMonth)#/#FORM.dateInterviewDay#/#FORM.dateInterviewYear# 
                    </cfif>    
					&nbsp;
				</div>
        	<cfelse>
                <select name="dateInterviewMonth" id="dateInterviewMonth" class="smallField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop from="1" to="12" index="i">
                        <option value="#i#" <cfif FORM.dateInterviewMonth EQ i> selected="selected" </cfif> >#MonthAsString(i)#</option>
                    </cfloop>
                </select>
                /
                <select name="dateInterviewDay" id="dateInterviewDay" class="xxSmallField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop from="1" to="31" index="i">
                        <option value="#i#" <cfif FORM.dateInterviewDay EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select>
                / 
                <select name="dateInterviewYear" id="dateInterviewYear" class="xSmallField {validate:{required:true}}">
                    <option value=""></option>
                    <cfloop from="#Year(now())#" to="#Year(now())-1#" index="i" step="-1">
                        <option value="#i#" <cfif FORM.dateInterviewYear EQ i> selected="selected" </cfif> >#i#</option>
                    </cfloop>
                </select> 
                <p class="note">(mm/dd/yyyy)</p>               
            </cfif>            
		</div>

        <!--- Place --->
        <div class="field">
			<label for="#qGetQuestions.fieldKey[5]#">#qGetQuestions.displayField[5]# <cfif qGetQuestions.isRequired[5]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[5]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[5]#" id="#qGetQuestions.fieldKey[5]#" value="#FORM[qGetQuestions.fieldKey[5]]#" class="#qGetQuestions.classType[5]#" maxlength="100" />
            </cfif>
		</div>
        
    </fieldset>    
    	
        
    <!--- Save Button --->
    <cfif NOT printApplication>
        <div class="buttonrow">
            <input type="submit" value="Save" class="button ui-corner-top" />
        </div>
	</cfif>
    
    </form>

</div><!-- /form-container -->

</cfoutput>