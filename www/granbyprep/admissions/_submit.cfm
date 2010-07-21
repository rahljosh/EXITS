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

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <!--- Student ID --->
    <cfparam name="FORM.studentID" default="#APPLICATION.CFC.STUDENT.getStudentID()#">
       
    <cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=FORM.studentID);

		// Get Current Student Information
		qGetCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// FORM Submitted
		if ( FORM.submitted ) {

			// FORM Validation

			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Submit Payment
				
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");
				// Reload page with updated information
				// location("#CGI.SCRIPT_NAME#?action=initial&currentTabID=#FORM.currentTabID#", "no");
				
			}
			
		}
		
		// Check if Application is complete
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
		
		// Check if Application Fee has been paid
		if ( NOT VAL(qGetStudentInfo.applicationPaymentID) ) {	
			// Application fee has not been paid - go to the application fee page
			location("#CGI.SCRIPT_NAME#?action=applicationFee", "no");
		}
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="application"
/>
    
    <!--- Side Bar --->
    <div class="rightSideContent ui-corner-all">
        
        <div class="insideBar">

			<!--- Application Body --->
            <div class="form-container">
                
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
                                
                <form action="#CGI.SCRIPT_NAME#?action=submit" method="post">
                <input type="hidden" name="submitted" value="1" />
                
                <p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
                
                                
                <div class="buttonrow">
                    <input type="submit" value="Submit" class="button ui-corner-top" />
                </div>
            
                </form>
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>