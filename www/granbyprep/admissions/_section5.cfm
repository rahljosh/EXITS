<!--- ------------------------------------------------------------------------- ----
	
	File:		_section5.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
    
    <cfscript>		
		// Get Questions for this section
		qGetQuestionsSection5 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section5');
		
		// Get Answers for this section
		qGetAnswersSection5 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section5', foreignTable='student', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection5.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection5.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section5' ) {
			
			// FORM Validation
			for ( i=1; i LTE qGetQuestionsSection5.recordCount; i=i+1 ) {
				if (qGetQuestionsSection5.isRequired[i] AND NOT LEN(FORM[qGetQuestionsSection5.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestionsSection5.requiredMessage[i]);
				}
			}
			
			if (ListLen(FORM[qGetQuestionsSection5.fieldKey[1]], " #Chr(13)##Chr(10)#") LT 250) {
				SESSION.formErrors.Add("Your essay must contain at least 250 words.");
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				

				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestionsSection5.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestionsSection5.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestionsSection5.fieldKey[i],
						answer=FORM[qGetQuestionsSection5.fieldKey[i]]						
					);	
				}

				// Update Student Session Variables
				APPLICATION.CFC.STUDENT.setStudentSession(ID=FORM.studentID);

				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");

			}
		
		} else {
			
			// Online Application Fields 
			for ( i=1; i LTE qGetAnswersSection5.recordCount; i=i+1 ) {
				FORM[qGetAnswersSection5.fieldKey[i]] = qGetAnswersSection5.answer[i];
			}
			
		}
	</cfscript>
    
</cfsilent>

<script type="text/javascript">
	// JQuery Validator
	$().ready(function() {
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#section5Form").validate({
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
		<cfloop query="qGetQuestionsSection5">
        	<cfif qGetQuestionsSection5.isRequired>
				<li><label for="#qGetQuestionsSection5.fieldKey#" class="error">#qGetQuestionsSection5.requiredMessage#</label></li>
            </cfif>
		</cfloop>
	</ol>
	
	<p>Data has <strong>not</strong> been saved.</p>
</div>

<!--- Application Body --->
<div class="form-container">
    
    <!--- Only Display Messages if Current tab is updated --->
  	<cfif currentTabID EQ 4>
    
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

    <form id="section5Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedType" value="section5" />
    <input type="hidden" name="currentTabID" value="4" />
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    <!--- Student Essay --->    
    <fieldset>
    
        <legend>Student Essay</legend>
        
        <!--- Student Essay --->
        <!--- custom bar created for this text area and stored in CFIDE/scripts/ajax/FCKEditor/fckconfig.js file // richtext="yes" toolbar="Basic" --->         
        <div class="field">
            <label for="#qGetQuestionsSection5.fieldKey[1]#">#qGetQuestionsSection5.displayField[1]# <cfif qGetQuestionsSection5.isRequired[1]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printFieldEssay">#FORM[qGetQuestionsSection5.fieldKey[1]]# &nbsp;</div>
        	<cfelse>
                <textarea name="#qGetQuestionsSection5.fieldKey[1]#" id="#qGetQuestionsSection5.fieldKey[1]#" class="#qGetQuestionsSection5.classType[1]# textAreaEssayCount">#FORM[qGetQuestionsSection5.fieldKey[1]]#</textarea>            
                <p class="note">(In 250 words or more) <span id="#qGetQuestionsSection5.fieldKey[1]#Count" class="spanEssayCount"> </span> </p>  
            </cfif>
        </div>
        
		<!--- Attest --->
        <div class="field controlset">
			<span class="label"><cfif qGetQuestionsSection5.isRequired[2]><em>*</em></cfif> &nbsp;</span>
            <cfif printApplication>
            	<div class="printField">
                    <span class="printFieldCheck#YesNoFormat(FORM[qGetQuestionsSection5.fieldKey[2]])#"> #qGetQuestionsSection5.displayField[2]# &nbsp; </span>
                </div>
        	<cfelse>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection5.fieldKey[2]#" id="#qGetQuestionsSection5.fieldKey[2]#" value="1" class="#qGetQuestionsSection5.classType[2]#" <cfif FORM[qGetQuestionsSection5.fieldKey[2]] EQ 1> checked="checked" </cfif> /> &nbsp; <label for="#qGetQuestionsSection5.fieldKey[2]#">#qGetQuestionsSection5.displayField[2]#</label>
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