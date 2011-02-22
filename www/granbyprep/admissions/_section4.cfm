<!--- ------------------------------------------------------------------------- ----
	
	File:		_section4.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 4 of the Online Application - Other Information

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
		qGetQuestionsSection4 = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section4');
		
		// Get Answers for this section
		qGetAnswersSection4 = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section4', foreignTable='student', foreignID=FORM.studentID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestionsSection4.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestionsSection4.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section4' ) {

			// FORM Validation
			for ( i=1; i LTE qGetQuestionsSection4.recordCount; i=i+1 ) {
				if (qGetQuestionsSection4.isRequired[i] AND NOT LEN(FORM[qGetQuestionsSection4.fieldKey[i]]) ) {
					SESSION.formErrors.Add(qGetQuestionsSection4.requiredMessage[i]);
				}
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Insert/Update Application Fields 
				for ( i=1; i LTE qGetQuestionsSection4.recordCount; i=i+1 ) {
					APPLICATION.CFC.ONLINEAPP.insertAnswer(	
						applicationQuestionID=qGetQuestionsSection4.ID[i],
						foreignTable='student',
						foreignID=FORM.studentID,
						fieldKey=qGetQuestionsSection4.fieldKey[i],
						answer=FORM[qGetQuestionsSection4.fieldKey[i]]						
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
			for ( i=1; i LTE qGetAnswersSection4.recordCount; i=i+1 ) {
				FORM[qGetAnswersSection4.fieldKey[i]] = qGetAnswersSection4.answer[i];
			}
		}
	</cfscript>
    
</cfsilent>

<script type="text/javascript">
	// JQuery Validator
	$().ready(function() {
		var container = $('div.errorContainer');
		// validate the form when it is submitted
		var validator = $("#section4Form").validate({
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
		<cfloop query="qGetQuestionsSection4">
        	<cfif qGetQuestionsSection4.isRequired>
				<li><label for="#qGetQuestionsSection4.fieldKey#" class="error">#qGetQuestionsSection4.requiredMessage#</label></li>
            </cfif>
		</cfloop>
	</ol>
	
	<p>Data has <strong>not</strong> been saved.</p>
</div>

<!--- Application Body --->
<div class="form-container">
	
    <!--- Only Display Messages if Current tab is updated --->
  	<cfif currentTabID EQ 3>
    
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

	<form id="section4Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
	<input type="hidden" name="submittedType" value="section4" />
    <input type="hidden" name="currentTabID" value="3" />
	
	<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
	
	<!--- Other Information --->
	<fieldset>
	   
		<legend>Other Information</legend>
		
		<!--- Applicant Lives --->
		<div class="field controlset">
			<span class="label">#qGetQuestionsSection4.displayField[1]# <cfif qGetQuestionsSection4.isRequired[1]><em>*</em></cfif></span>
            <cfif printApplication>
            	<div class="printFieldOption">
                	<span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Father'))#"> Father </span>
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Mother'))#"> Mother </span>
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Guardian'))#"> Guardian </span>
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Other'))#"> Other </span>
                </div>
        	<cfelse>
                <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[1]#" id="livesFather" value="Father" class="#qGetQuestionsSection4.classType[1]#" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Father')> checked="checked" </cfif> /> <label for="livesFather">Father</label>
                <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[1]#" id="livesMother" value="Mother" class="#qGetQuestionsSection4.classType[1]#" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Mother')> checked="checked" </cfif> /> <label for="livesMother">Mother</label>
                <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[1]#" id="livesGuardian" value="Guardian" class="#qGetQuestionsSection4.classType[1]#" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Guardian')> checked="checked" </cfif> /> <label for="livesGuardian">Guardian</label>
                <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[1]#" id="livesOther" value="Other" class="#qGetQuestionsSection4.classType[1]#" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[1]], 'Other')> checked="checked" </cfif> /> <label for="livesOther">Other</label>
                <p class="note">(Mark all that apply)</p>
            </cfif>
		</div>			

		<!--- Admission Materials --->
		<div class="field controlset">
			<span class="label">#qGetQuestionsSection4.displayField[2]# <cfif qGetQuestionsSection4.isRequired[2]><em>*</em></cfif></span>
            <cfif printApplication>
            	<div class="printFieldOption">
                    <span class="printFieldRadio#YesNoFormat(FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Father')#"> Father </span> 
                    <span class="printFieldRadio#YesNoFormat(FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Mother')#"> Mother </span> 
                    <span class="printFieldRadio#YesNoFormat(FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Guardian')#"> Guardian </span>  
                    <span class="printFieldRadio#YesNoFormat(FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Other')#"> Other </span>  
                </div>
        	<cfelse>
                <div class="field">
                    <input type="radio" name="#qGetQuestionsSection4.fieldKey[2]#" id="materialFather" value="Father" class="#qGetQuestionsSection4.classType[2]#" <cfif FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Father'> checked="checked" </cfif> /> <label for="materialFather">Father</label>
                    <input type="radio" name="#qGetQuestionsSection4.fieldKey[2]#" id="materialMother" value="Mother" class="#qGetQuestionsSection4.classType[2]#" <cfif FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Mother'> checked="checked" </cfif> /> <label for="materialMother">Mother</label>
                    <input type="radio" name="#qGetQuestionsSection4.fieldKey[2]#" id="materialGuardian" value="Guardian" class="#qGetQuestionsSection4.classType[2]#" <cfif FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Guardian'> checked="checked" </cfif> /> <label for="materialGuardian">Guardian</label>
                    <input type="radio" name="#qGetQuestionsSection4.fieldKey[2]#" id="materialOther" value="Other" class="#qGetQuestionsSection4.classType[2]#" <cfif FORM[qGetQuestionsSection4.fieldKey[2]] EQ 'Other'> checked="checked" </cfif> /> <label for="materialOther">Other</label>
                </div>
            </cfif>
        </div>
		
        <div style="clear:both;"></div>
        	
		<!--- Parent Lives --->
        <div class="field controlset">
			<span class="label">#qGetQuestionsSection4.displayField[3]# <cfif qGetQuestionsSection4.isRequired[3]><em>*</em></cfif></span>
            <cfif printApplication>
            	<div class="printFieldOption"> 
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'fatherDeceased'))#"> Father Deceased </span>   
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'motherDeceased'))#"> Mother Deceased </span>    
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'parentsDivorced'))#"> Parents Divorced </span>    
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'parentsSeparated'))#"> Parents Separated </span>    
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'fatherRemarried'))#"> Father Remarried </span>    
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'motherRemarried'))#"> Mother Remarried </span>    
                    <span class="printFieldCheck#YesNoFormat(ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'livingOutside'))#"> Living Outside U.S. </span>    
                </div>
        	<cfelse>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="fatherDeceased" value="fatherDeceased" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'fatherDeceased')> checked="checked" </cfif> /> <label for="fatherDeceased">Father Deceased</label> <br />  
                </div>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="motherDeceased" value="motherDeceased" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'motherDeceased')> checked="checked" </cfif> /> <label for="motherDeceased">Mother Deceased</label> <br />  
                </div>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="parentsDivorced" value="parentsDivorced" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'parentsDivorced')> checked="checked" </cfif> /> <label for="parentsDivorced">Parents Divorced</label> <br />  
                </div>
                <div class="field">            
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="parentsSeparated" value="parentsSeparated" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'parentsSeparated')> checked="checked" </cfif> /> <label for="parentsSeparated">Parents Separated</label>  <br />                        	
                </div>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="fatherRemarried" value="fatherRemarried" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'fatherRemarried')> checked="checked" </cfif> /> <label for="fatherRemarried">Father Remarried</label> <br />  
                </div>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="motherRemarried" value="motherRemarried" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'motherRemarried')> checked="checked" </cfif> /> <label for="motherRemarried">Mother Remarried</label> <br />  
                </div>
                <div class="field">
                    <input type="checkbox" name="#qGetQuestionsSection4.fieldKey[3]#" id="livingOutside" value="livingOutside" <cfif ListFind(FORM[qGetQuestionsSection4.fieldKey[3]], 'livingOutside')> checked="checked" </cfif> /> <label for="livingOutside">Living Outside U.S.</label> <br />  
                </div>
            </cfif>
        </div>

		<!--- Parent Custody --->
        <div class="field">
			<label for="#qGetQuestionsSection4.fieldKey[4]#">#qGetQuestionsSection4.displayField[4]# <cfif qGetQuestionsSection4.isRequired[4]><em>*</em></cfif></label> 
            <cfif printApplication>
            	<div class="printField">#FORM[qGetQuestionsSection4.fieldKey[4]]# &nbsp;</div>
        	<cfelse>
                <input type="text" name="#qGetQuestionsSection4.fieldKey[4]#" id="#qGetQuestionsSection4.fieldKey[4]#" value="#FORM[qGetQuestionsSection4.fieldKey[4]]#" class="#qGetQuestionsSection4.classType[4]#" maxlength="50" />
            </cfif>
		</div>

		<div style="clear:both;"></div>
		
		<!--- Financial Aid --->
        <div class="field controlset">
			<span class="label">#qGetQuestionsSection4.displayField[5]# <cfif qGetQuestionsSection4.isRequired[5]><em>*</em></cfif></span>
            <cfif printApplication>
            	<div class="printField"><cfif VAL(FORM[qGetQuestionsSection4.fieldKey[5]])> Yes <cfelseif FORM[qGetQuestionsSection4.fieldKey[5]] EQ 0> No </cfif> &nbsp;</div>
        	<cfelse>
                <input type="radio" name="#qGetQuestionsSection4.fieldKey[5]#" id="financialYes" value="1" class="#qGetQuestionsSection4.classType[5]#" <cfif FORM[qGetQuestionsSection4.fieldKey[5]] EQ 1> checked="checked" </cfif> /> <label for="financialYes">Yes</label>
                <input type="radio" name="#qGetQuestionsSection4.fieldKey[5]#" id="financialNo" value="0" class="#qGetQuestionsSection4.classType[5]#" <cfif FORM[qGetQuestionsSection4.fieldKey[5]] EQ 0> checked="checked" </cfif> /> <label for="financialNo">No</label>
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