<!--- ------------------------------------------------------------------------- ----
	
	File:		_section2.cfm
	Author:		Marcus Melo
	Date:		August 09, 2010
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
    <cfparam name="FORM.currentTabID" default="0">
    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">

    <cfscript>
		// Get Current Candidate Information
		// qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);

		// Gets Application Fee Policy Text
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="applicationAgreement");

		// 
		savecontent variable="applicationAgreement" {
			writeOutput(qGetContent.content);
		}    
		
		// Replace Variables 
		applicationAgreement = ReplaceNoCase(applicationAgreement,"{firstName}",qGetCandidateInfo.firstName,"all");
		applicationAgreement = ReplaceNoCase(applicationAgreement,"{lastName}",qGetCandidateInfo.lastName,"all");
		applicationAgreement = ReplaceNoCase(applicationAgreement,"{csbName}",APPLICATION.CSB.name,"all");
		applicationAgreement = ReplaceNoCase(applicationAgreement,"{csbMainSite}",APPLICATION.SITE.URL.main,"all");
		applicationAgreement = ReplaceNoCase(applicationAgreement,"{csbTollFree}",APPLICATION.CSB.toolFreePhone,"all");
		applicationAgreement = ReplaceNoCase(applicationAgreement,"{date}",DateFormat(now(), 'mmmm dd, yyyy'),"all");

		// Get Questions for this section
		qGetQuestions = APPLICATION.CFC.ONLINEAPP.getQuestionByFilter(sectionName='section2');
		
		// Get Answers for this section
		qGetAnswers = APPLICATION.CFC.ONLINEAPP.getAnswerByFilter(sectionName='section2', foreignTable='candidate', foreignID=FORM.candidateID);

		// Param Online Application Form Variables 
		for ( i=1; i LTE qGetQuestions.recordCount; i=i+1 ) {
			param name="FORM[qGetQuestions.fieldKey[i]]" default="";
		}

		// FORM Submitted
		if ( FORM.submittedType EQ 'section2' ) {

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
			
			// Set the default values of the FORM 
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
		var validator = $("#section2Form").validate({
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
		<li><label for="lastName" class="error">Please enter your last name</label></li>  

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
  	<cfif currentTabID EQ 0>
    
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
       
    <form id="section2Form" action="#CGI.SCRIPT_NAME#?action=initial" method="post">
    <input type="hidden" name="submittedType" value="section2" />
    <input type="hidden" name="currentTabID" value="0" />
    <input type="hidden" name="candidateID" id="candidateID" value="#FORM.candidateID#" />
    
    <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
    
    
    <!--- Personal Data --->
    <fieldset>
       
        <legend>Agreement</legend>
		
        <!--- Agreement --->
        #APPLICATION.CFC.UDF.RichTextOutput(applicationAgreement)#
			
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