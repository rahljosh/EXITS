<!--- ------------------------------------------------------------------------- ----
	
	File:		checkList.cfm
	Author:		Marcus Melo
	Date:		December 5, 2012
	Desc:		Check List Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Status
		stApplicationStatus = APPLICATION.CFC.HOST.getApplicationProcess();
	</cfscript>

</cfsilent>

<script type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		$(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
			onClosed:function(){ location.reload(false); } });
	});
//]]>
</script>

<cfoutput>

    <h2 align="center">Application Checklist</h2>

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />

    <p>Please use the menu on the left or the section title to navigate to the section that is missing information.</p>
    
    <p>
        This is a preliminary check list to make sure certain information that is required is submitted. An indication of all sections complete does not indicate that you have been approved 
        as a host family, it simpliy indicates that your application is ready to submit.
	</p>
    
    <p>Once your application is submitted, you will be contacted be your local area representative so that they can conducte a tour of your home and to help you select an exchange student.</p>


    <h2><p>Name & Contact Information</p></h2>
    
    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.contactInfo.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.contactInfo.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.contactInfo.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>
    
    
    <h2><p>Family Members</p></h2>
    
    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.familyMembers.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete. #stApplicationStatus.familyMembers.message#
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.familyMembers.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.familyMembers.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>
    
    
    <h2><p>Background Checks</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.backgroundChecks.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.backgroundChecks.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.backgroundChecks.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>
    
    
    <h2><p>Personal Description</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.personalDescription.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.personalDescription.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.personalDescription.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>
    
        
    <h2><p>Hosting Environment</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.hostingEnvironment.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.hostingEnvironment.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.hostingEnvironment.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>Religious Preference</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.religiousPreference.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.religiousPreference.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.religiousPreference.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>Family Rules</p></h2>
    
    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.familyRules.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.familyRules.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.familyRules.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>Family Album</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.familyAlbum.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.familyAlbum.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.familyAlbum.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>School Info</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.schoolInfo.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.schoolInfo.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.schoolInfo.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>Community Profile</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.communityProfile.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.communityProfile.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.communityProfile.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>Confidential Data</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.confidentialData.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.confidentialData.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.confidentialData.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>


    <h2><p>References</p></h2>

    <p style="margin-top:-15px;">
		<cfif stApplicationStatus.references.isComplete>
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.references.message); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.references.message[x]);
				}
			</cfscript>
            
			<!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="checklist"
                />
        </cfif>
    </p>

	
    <!--- Submit Application --->
    <table class="greenBackground" cellpadding="8">
        <tr>
            <cfif stApplicationStatus.isComplete>
                <td>
                    Happy with how everything looks?  Click the button to the right to submit your application.
                </td>
                <td>
                    <a href="disclaimer.cfm" class="iframe"><img src="images/buttons/#SESSION.COMPANY.submitImage#"/></a>
                </td>
            <cfelse>
                <td>
                    Looks like your still missing some information, please review the sections listed above. 
                    The botton to the right will not be active (the arrow will turn red) until all the required information above has been filled out. 
                </td>
                <td>
                    <img src="images/buttons/#SESSION.COMPANY.submitGreyImage#" />
                </td>
            </cfif>
        </tr>
    </table>

</cfoutput>