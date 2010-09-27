<!--- ------------------------------------------------------------------------- ----
	
	File:		_section3.cfm
	Author:		Marcus Melo
	Date:		August 10, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	
    
	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="2">
    <!--- Interview Date --->
    <cfparam name="FORM.dateInterviewMonth" default="">
    <cfparam name="FORM.dateInterviewDay" default="">
    <cfparam name="FORM.dateInterviewYear" default="">
    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">
	<!--- Print Application --->
    <cfparam name="FORM.intlRep" default="">

    <cfscript>
		// Get Current Candidate Information
		// qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);
		
		if ( CLIENT.loginType NEQ 'user' ) {
			printApplication = 1;
		}
		
		// Get Intl Rep / Branch Name
		if ( VAL(qGetCandidateInfo.branchID) ) {
			FORM.intlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetCandidateInfo.branchID).businessName;
		} else {
			FORM.intlRep = APPLICATION.CFC.USER.getUserByID(userID=qGetCandidateInfo.intRep).businessName;
		}

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section3');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section3', foreignTable='candidate', foreignID=FORM.candidateID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// FORM Submitted
		if ( FORM.submittedType EQ 'section3' ) {

			// Parent Phone
			FORM[qGetQuestions.fieldKey[5]] = FORM.dateInterviewMonth & '/' & FORM.dateInterviewDay & '/' & FORM.dateInterviewYear;

			// FORM Validation
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
						foreignTable='candidate',
						foreignID=FORM.candidateID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}
				
				// Update Candidate Session Variables
				APPLICATION.CFC.CANDIDATE.setCandidateSession(ID=FORM.candidateID);
				
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

			// Break down interview date						
			if ( IsDate(FORM[qGetAnswers.fieldKey[5]]) ) {
				FORM.dateInterviewMonth = Month(FORM[qGetAnswers.fieldKey[5]]);
				FORM.dateInterviewDay = Day(FORM[qGetAnswers.fieldKey[5]]);
				FORM.dateInterviewYear = Year(FORM[qGetAnswers.fieldKey[5]]);
			}
			
		}
	</cfscript>
    
</cfsilent>

<script type="text/javascript">
	// Date picker
	$(function() {
		$(".datepicker").datepicker();
	});	

	// JQuery Validator
	$().ready(function() {
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#section3Form").validate({
			errorContainer: container,
			errorLabelContainer: $("ol", container),
			wrapper: 'li',
			meta: "validate"
		});
	
	});
</script>

<cfoutput>

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
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    <!--- Personal Data --->
    <fieldset>
       
        <legend>English Assessment</legend>
		
        <cfif CLIENT.loginType NEQ 'user'>
       		<h3 class="h2Message">This page must be completed by #FORM.intlRep#.</h3>
        </cfif>
        
        <div class="field">
            <label>CSB International Representative <em>*</em></label> 
            <div class="printField">#FORM.intlRep# &nbsp;</div>
        </div>

        <div class="field">
            <label>Participant's Name <em>*</em></label> 
            <div class="printField">#qGetCandidateInfo.firstName# #qGetCandidateInfo.lastname# &nbsp;</div>
        </div>

		<!--- English Level --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" value="#FORM[qGetQuestions.fieldKey[1]]#" class="#qGetQuestions.classType[1]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Test Score --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]# <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[2]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="#FORM[qGetQuestions.fieldKey[2]]#" class="#qGetQuestions.classType[2]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Scale Score Information --->
        <div class="field">
            <label>&nbsp;</label> 
            <div class="printField">#FORM.intlRep# &nbsp;</div>
        </div>
        
		<!--- Slep Score --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[3]#">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[3]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[3]#" id="#qGetQuestions.fieldKey[3]#" value="#FORM[qGetQuestions.fieldKey[3]]#" class="#qGetQuestions.classType[3]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Interviewer Name --->
		<div class="field">
			<label for="#qGetQuestions.fieldKey[4]#">#qGetQuestions.displayField[4]# <cfif qGetQuestions.isRequired[4]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[4]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[4]#" id="#qGetQuestions.fieldKey[4]#" value="#FORM[qGetQuestions.fieldKey[4]]#" class="#qGetQuestions.classType[4]#" maxlength="100" />
            </cfif>
		</div>

		<!--- Interviewer Signature --->
        <div class="field">
            <label>Interviewer Signature <em>*</em></label> 
            <div class="printField"> &nbsp;</div>
        </div>
       
        <!--- Date --->
        <div class="field">
			<label for="dateInterviewMonth">#qGetQuestions.displayField[5]# <cfif qGetQuestions.isRequired[5]><em>*</em></cfif></label>            
            <cfif printApplication>
				<div class="printField">#MonthAsString(FORM.dateInterviewMonth)#/#FORM.dateInterviewDay#/#FORM.dateInterviewYear# &nbsp;</div>
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
			<label for="#qGetQuestions.fieldKey[6]#">#qGetQuestions.displayField[6]# <cfif qGetQuestions.isRequired[6]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestions.fieldKey[6]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestions.fieldKey[6]#" id="#qGetQuestions.fieldKey[6]#" value="#FORM[qGetQuestions.fieldKey[6]]#" class="#qGetQuestions.classType[6]#" maxlength="100" />
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