<!--- ------------------------------------------------------------------------- ----
	
	File:		_displayLogin.cfm
	Author:		Marcus Melo
	Date:		October 19, 2010
	Desc:		Displays login information

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

    <!--- Candidate Details --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">  
    <cfparam name="FORM.message" default="Please see login information below">
    
    <cfscript>	
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=FORM.candidateID);

		// Set the default values of the FORM 
		FORM.email = qGetCandidateInfo.email;
		FORM.password = qGetCandidateInfo.password;

		if ( NOT LEN(FORM.email) ) {
			FORM.email = 'n/a';	
		}

		if ( NOT LEN(FORM.password) ) {
			FORM.password = 'n/a';	
			FORM.MESSAGE = '<strong>Note:</strong> An account has not been created for this candidate.';
		}
	</cfscript>
    
</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>

    <!--- Side Bar --->
    <div class="fullSideContent ui-corner-all">
        
        <div class="insideBar">
			
            <!--- Application Body --->
			<div class="form-container-noBorder">
				                    
				<p class="legend">#FORM.message#</p>            
            	
                <fieldset>
                   
                    <legend>My Account - #qGetCandidateInfo.firstName# #qGetCandidateInfo.lastName#</legend>
                        
                    <div class="field">
                        <label for="firstName">Email Address <em>*</em></label> 
                        <div class="printFieldSmall">#FORM.email# &nbsp;</div> 
                    </div>

                    <div class="field">
                        <label for="middleName">Password <em>*</em></label> 
                        <div class="printFieldSmall">#FORM.password# &nbsp;</div> 
                    </div>
    
                </fieldset>
                            
                <div class="buttonrow">
                    <input type="submit" onClick="javascript:window.close();" value="Close" class="button ui-corner-top" />
                </div>
                
            </div>
            
		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

</cfoutput>
