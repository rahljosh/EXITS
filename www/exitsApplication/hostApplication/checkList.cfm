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

	<!--- Check if disclaimer has been signed --->
    <cfquery name="checkSig" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	*
        FROM 
        	smg_documents
        WHERE 
        	shortDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="Host App Terms">
        AND 
        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
    </cfquery>

	<cfif checkSig.recordcount gt 0 AND Right(cgi.HTTP_REFERER, '9') EQ 'checklist'>
    
        <cfquery datasource="#APPLICATION.DSN.Source#">
            UPDATE 
            	smg_hosts
            SET 
            	hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
            WHERE
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
        </cfquery>
        
        <cfquery name="emailAddy" datasource="#APPLICATION.DSN.Source#">
            SELECT 
            	u.email 
            FROM 
            	smg_users u
            LEFT OUTER JOIN 
            	smg_hosts h ON h.areaRepID = u.userID
            WHERE 
            	h.hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
        </cfquery>
        
        <cfsavecontent variable="nextLevel">                      
			<cfoutput>
                The #qGetHostFamilyInfo.familylastname# application has been submitted for your review.
                <br /><br />  
                You can review the app <a href="http://ise.exitsapplication.com/">here</a>.
            </cfoutput>
        </cfsavecontent>
    
        <cfinvoke component="extensions.components.email" method="send_mail">
            <cfinvokeargument name="emailTo" value="#mailTo#">
            <cfinvokeargument name="email_subject" value="#qGetHostFamilyInfo.familylastname# App Needs your Approval">
            <cfinvokeargument name="email_message" value="#nextLevel#">
        </cfinvoke>
        
    	<cflocation url="?curdoc=overview" addtoken="no">
    
    </cfif>


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
				for( x=1; x LTE ArrayLen(stApplicationStatus.contactInfo.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.contactInfo.errorMessage[x]);
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
            <font color="##00CC00">&##10004;</font> This section is complete.
        <cfelse>
            <cfscript>
				// Loop Through Array and Populate Errors
				for( x=1; x LTE ArrayLen(stApplicationStatus.familyMembers.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.familyMembers.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.backgroundChecks.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.backgroundChecks.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.personalDescription.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.personalDescription.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.hostingEnvironment.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.hostingEnvironment.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.religiousPreference.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.religiousPreference.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.familyRules.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.familyRules.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.familyAlbum.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.familyAlbum.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.communityProfile.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.communityProfile.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.confidentialData.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.confidentialData.errorMessage[x]);
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
				for( x=1; x LTE ArrayLen(stApplicationStatus.references.errorMessage); x++ ) {
					SESSION.formErrors.Add(stApplicationStatus.references.errorMessage[x]);
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