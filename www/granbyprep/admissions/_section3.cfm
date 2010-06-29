<!--- ------------------------------------------------------------------------- ----
	
	File:		_section3.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submittedSec3" default="0">
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Student Details --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
	<cfparam name="FORM.firstName" default="">
	<cfparam name="FORM.middleName" default="">
	<cfparam name="FORM.lastName" default="">
	<cfparam name="FORM.preferredName" default="">
    <cfparam name="FORM.gender" default="">
    <cfparam name="FORM.dobMonth" default="">
    <cfparam name="FORM.dobDay" default="">
    <cfparam name="FORM.dobYear" default="">
    <cfparam name="FORM.countryBirthID" default="">
    <cfparam name="FORM.countryCitizenID" default="">
	<!--- Login Information --->
	<cfparam name="FORM.email" default="">
    <cfparam name="FORM.password" default="">
	<!--- Complete Home Address --->
	<cfparam name="FORM.address" default="">
	<cfparam name="FORM.address2" default="">
	<cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zipCode" default="">
    <cfparam name="FORM.countryID" default="">    
	<!--- Contact Information ---> 
    <cfparam name="FORM.homePhoneCountry" default="">
    <cfparam name="FORM.homePhoneArea" default="">
    <cfparam name="FORM.homePhonePrefix" default="">
    <cfparam name="FORM.homePhoneNumber" default="">
    <cfparam name="FORM.faxCountry" default="">
    <cfparam name="FORM.faxArea" default="">
    <cfparam name="FORM.faxPrefix" default="">
    <cfparam name="FORM.faxNumber" default="">
    <cfparam name="FORM.firstLanguage" default="">
    
    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section3');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section3', foreignID=FORM.studentID);

		// Param Online Application Fields 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}
	
		// FORM Submitted
		if ( FORM.submittedSec3 ) {
			
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

    <form action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedSec3" value="1" />
    <input type="hidden" name="currentTabID" value="2" />
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    <!--- Student Essay --->    
    <fieldset>
    
        <legend>Student Essay</legend>
        
        <!--- Student Essay --->
        <!--- custom bar created for this text area and stored in CFIDE/scripts/ajax/FCKEditor/fckconfig.js file --->
        <div>
            <label for="#qGetQuestions.fieldKey[1]#">#qGetQuestions.displayField[1]# <cfif qGetQuestions.isRequired[1]><em>*</em></cfif></label> 
            <textarea name="#qGetQuestions.fieldKey[1]#" id="#qGetQuestions.fieldKey[1]#" class="#qGetQuestions.classType[1]#">#FORM[qGetQuestions.fieldKey[1]]#</textarea>            
            <p class="note">(In 200 words or more)</p> <!--- richtext="yes" toolbar="Basic" --->           
        </div>
        
		<!--- Attest --->
        <div class="controlset">
			<span class="label"><cfif qGetQuestions.isRequired[2]><em>*</em></cfif> &nbsp;</span>
            <div>
                <input type="checkbox" name="#qGetQuestions.fieldKey[2]#" id="essayAttest" value="1" <cfif FORM[qGetQuestions.fieldKey[2]] EQ 1> checked="checked" </cfif> /> <label for="essayAttest">#qGetQuestions.displayField[2]#</label>
            </div>
        </div>
        
    </fieldset>

    <div class="buttonrow">
        <input type="submit" value="Save" class="button ui-corner-top" />
    </div>

    </form>

</div><!-- /form-container -->

</cfoutput>
