<!--- ------------------------------------------------------------------------- ----
	
	File:		_section4.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedType" default="">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">

    <cfscript>
		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section4');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section4', foreignID=FORM.studentID);

		// Param Online Application Fields 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedType EQ 'section4' ) {

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
						foreignID=FORM.studentID,
						fieldKey=qGetQuestions.fieldKey[i],
						answer=FORM[qGetQuestions.fieldKey[i]]						
					);	
				}
				
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
		}
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Application Body --->
<div class="form-container">
	
    <!--- Only Display Messages if Current tab is updated --->
  	<cfif FORM.submittedType EQ 'section4'>
    
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
	<input type="hidden" name="submittedType" value="section4" />
    <input type="hidden" name="currentTabID" value="3" />
	
	<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
	
	<!--- Other Information --->
	<fieldset>
	   
		<legend>Other Information</legend>
		
		<!--- Applicant Lives --->
		<div class="field controlset">
			<span class="label">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></span>
            <input type="checkbox" name="#qGetQuestions.fieldKey[1]#" id="livesFather" value="Father" <cfif ListFind(FORM[qGetQuestions.fieldKey[1]], 'Father')> checked="checked" </cfif> /> <label for="livesFather">Father</label>
            <input type="checkbox" name="#qGetQuestions.fieldKey[1]#" id="livesMother" value="Mother" <cfif ListFind(FORM[qGetQuestions.fieldKey[1]], 'Mother')> checked="checked" </cfif> /> <label for="livesMother">Mother</label>
            <input type="checkbox" name="#qGetQuestions.fieldKey[1]#" id="livesGuardian" value="Guardian" <cfif ListFind(FORM[qGetQuestions.fieldKey[1]], 'Guardian')> checked="checked" </cfif> /> <label for="livesGuardian">Guardian</label>
            <input type="checkbox" name="#qGetQuestions.fieldKey[1]#" id="livesOther" value="Other" <cfif ListFind(FORM[qGetQuestions.fieldKey[1]], 'Other')> checked="checked" </cfif> /> <label for="livesOther">Other</label>
            <p class="note">(Mark all that apply)</p>
		</div>			

		<!--- Admission Materials --->
		<div class="field controlset">
			<span class="label">#qGetQuestions.displayField[2]# <cfif qGetQuestions.isRequired[2]><em>*</em></cfif></span>
			<div class="field">
                <input type="radio" name="#qGetQuestions.fieldKey[2]#" id="materialFather" value="Father" <cfif FORM[qGetQuestions.fieldKey[2]] EQ 'Father'> checked="checked" </cfif> /> <label for="materialFather">Father</label>
                <input type="radio" name="#qGetQuestions.fieldKey[2]#" id="materialMother" value="Mother" <cfif FORM[qGetQuestions.fieldKey[2]] EQ 'Mother'> checked="checked" </cfif> /> <label for="materialMother">Mother</label>
                <input type="radio" name="#qGetQuestions.fieldKey[2]#" id="materialGuardian" value="Guardian" <cfif FORM[qGetQuestions.fieldKey[2]] EQ 'Guardian'> checked="checked" </cfif> /> <label for="materialGuardian">Guardian</label>
                <input type="radio" name="#qGetQuestions.fieldKey[2]#" id="materialOther" value="Other" <cfif FORM[qGetQuestions.fieldKey[2]] EQ 'Other'> checked="checked" </cfif> /> <label for="materialOther">Other</label>
			</div>
        </div>
		
        <div style="clear:both;"></div>
        	
		<!--- Parent Lives --->
        <div class="field controlset">
			<span class="label">#qGetQuestions.displayField[3]# <cfif qGetQuestions.isRequired[3]><em>*</em></cfif></span>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="fatherDeceased" value="fatherDeceased" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'fatherDeceased')> checked="checked" </cfif> /> <label for="fatherDeceased">Father Deceased</label> <br />  
            </div>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="motherDeceased" value="motherDeceased" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'motherDeceased')> checked="checked" </cfif> /> <label for="motherDeceased">Mother Deceased</label> <br />  
			</div>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="parentsDivorced" value="parentsDivorced" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'parentsDivorced')> checked="checked" </cfif> /> <label for="parentsDivorced">Parents Divorced</label> <br />  
            </div>
            <div class="field">            
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="parentsSeparated" value="parentsSeparated" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'parentsSeparated')> checked="checked" </cfif> /> <label for="parentsSeparated">Parents Separated</label>  <br />                        	
			</div>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="fatherRemarried" value="fatherRemarried" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'fatherRemarried')> checked="checked" </cfif> /> <label for="fatherRemarried">Father Remarried</label> <br />  
            </div>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="motherRemarried" value="motherRemarried" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'motherRemarried')> checked="checked" </cfif> /> <label for="motherRemarried">Mother Remarried</label> <br />  
            </div>
            <div class="field">
                <input type="checkbox" name="#qGetQuestions.fieldKey[3]#" id="livingOutside" value="livingOutside" <cfif ListFind(FORM[qGetQuestions.fieldKey[3]], 'livingOutside')> checked="checked" </cfif> /> <label for="livingOutside">Living Outside U.S.</label> <br />  
            </div>
        </div>

		<!--- Parent Custody --->
        <div class="field">
			<label for="#qGetQuestions.fieldKey[4]#">#qGetQuestions.displayField[4]# <cfif qGetQuestions.isRequired[4]><em>*</em></cfif></label> 
			<input type="text" name="#qGetQuestions.fieldKey[4]#" id="#qGetQuestions.fieldKey[4]#" value="#FORM[qGetQuestions.fieldKey[4]]#" class="#qGetQuestions.classType[4]#" maxlength="50" />
		</div>

		<div style="clear:both;"></div>

		<!--- Financial Aid --->
        <div class="field controlset">
			<span class="label">#qGetQuestions.displayField[5]# <cfif qGetQuestions.isRequired[5]><em>*</em></cfif></span>
            <input type="radio" name="#qGetQuestions.fieldKey[5]#" id="financialYes" value="1" <cfif FORM[qGetQuestions.fieldKey[5]] EQ 1> checked="checked" </cfif> /> <label for="financialYes">Yes</label>
			<input type="radio" name="#qGetQuestions.fieldKey[5]#" id="financialNo" value="0" <cfif FORM[qGetQuestions.fieldKey[5]] EQ 0> checked="checked" </cfif> /> <label for="financialNo">No</label>
        </div>

	</fieldset>

	<div class="buttonrow">
		<input type="submit" value="Save" class="button ui-corner-top" />
	</div>

	</form>

</div><!-- /form-container -->

</cfoutput>