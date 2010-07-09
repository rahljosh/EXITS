<!--- ------------------------------------------------------------------------- ----
	
	File:		_section5.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
    
    <cfscript>		
		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section5');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section5', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section5' ) {
			
			// FORM Validation
			for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
				if (qGetQuestions.isRequired[i] AND NOT LEN(FORM[qGetQuestions.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestions.requiredMessage[i]);
				}
			}
			
			if (ListLen(FORM[qGetQuestions.fieldKey[1]], " #Chr(13)##Chr(10)#") LT 250) {
				SESSION.formErrors.Add("Your essay must contain at least 250 words.");
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestions.ID[i],
						foreignID=FORM.studentID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				// Reload page with updated information
				//location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");

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

<!--- Application Body --->
<div class="form-container">
    
    <!--- Only Display Messages if Current tab is updated --->
  	<cfif FORM.submittedType EQ 'section5'>
    
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

    <form action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedType" value="section5" />
    <input type="hidden" name="currentTabID" value="4" />
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    <!--- Student Essay --->    
    <fieldset>
    
        <legend>Student Essay</legend>
        
        <!--- Student Essay --->
        <!--- custom bar created for this text area and stored in CFIDE/scripts/ajax/FCKEditor/fckconfig.js file // richtext="yes" toolbar="Basic" --->         
        <div class="field">
            <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printFieldEssay">#FORM[qGetQuestions.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <textarea name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" class="#qGetQuestions.classType[1]# textAreaEssayCount">#FORM[qGetQuestions.fieldKey[1]]#</textarea>            
                <p class="note">(In 250 words or more) <span id="#qGetQuestions.fieldKey[1]#Count" class="spanEssayCount"> </span> </p>  
            </cfif>
        </div>
        
		<!--- Attest --->
        <div class="field controlset">
			<span class="label"><cfif qGetQuestions.isRequired[2]><em>*</em></cfif> &nbsp;</span>
            <cfif printApplication>
            	<div class="printField">
                    <span class="printFieldCheck#YesNoFormat(FORM[qGetQuestions.fieldKey[2]])#"> #qGetQuestions.displayField[2]# &nbsp; </span>
                </div>
        	<cfelse>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestions.fieldKey[2]#" id="#qGetQuestions.fieldKey[2]#" value="1" <cfif FORM[qGetQuestions.fieldKey[2]] EQ 1> checked="checked" </cfif> /> &nbsp; <label for="#qGetQuestions.fieldKey[2]#">#qGetQuestions.displayField[2]#</label>
                </div>
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

<script type="text/javascript">
	// Word Count
	$(document).ready(function() {
	
		$('.textAreaEssayCount').each(function() {
			var input = '.textAreaEssayCount';
			var displayCount = '.spanEssayCount';
			$(displayCount).show();
			countWord(input, displayCount);
			$(this).keyup(function() { countWord(input, displayCount) });
		});
	
	});
</script>