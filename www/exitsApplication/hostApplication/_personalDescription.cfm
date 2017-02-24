<!--- ------------------------------------------------------------------------- ----
	
	File:		personalDescription.cfm
	Author:		Marcus Melo
	Date:		December 12, 2012
	Desc:		Personal Description

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

    <!--- PARAM FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.familyLetter" default="">

    <!--- Process Form Submission --->
    <cfif VAL(FORM.submitted)>

		<cfscript>
            // Data Validation
			
			// No Letter
			if ( NOT LEN(TRIM(FORM.familyLetter)) ) {
            	SESSION.formErrors.Add("The letter is required. If you would like to move onto another portion of the application with out finishing your letter, please use the menu to the left to navigate past this page.");
			}
			
			// Letter to Short
			if ( LEN(TRIM(FORM.familyLetter)) AND LEN(TRIM(FORM.familyLetter)) LT 300 ) {
            	SESSION.formErrors.Add("Your letter is too short. If you would like to proceed to another portion of the application without finishing your letter, please use the menu to the left to navigate past this page.");
			}
		</cfscript>
        
        <!--- No Errors Found --->
		<cfif NOT SESSION.formErrors.length()>

			<!--- Update Letter --->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                	smg_hosts
                SET 
                	familyLetter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.familyLetter)#">
                WHERE 
                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.CFC.SESSION.getHostSession().ID#">
            </cfquery>
    
    		<cfscript>
				// Successfully Updated - Set navigation page
				Location(APPLICATION.CFC.UDF.setPageNavigation(section=URL.section), "no");
			</cfscript>
        
		</cfif>
    
    <cfelse>
    
		<cfscript>
			// Set FORM Values 
			FORM.familyLetter = qGetHostFamilyInfo.familyLetter;
		</cfscript>    
        
	</cfif>

</cfsilent>

<cfoutput>

    <h2>Personal Description</h2>
    
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

    <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
    	<input type="hidden" name="submitted" value="1" />
    
        Your personal description is the most important part of this application. Along with photos of your family and your home, this description will be your
        personal explanation of you and your family and why you have decided to host an exchange student. <br /><br />
    	
        We ask that you be brief yet thorough with your introduction to your 'extended' family. Please include all information that might be of importance to your newest
    	son or daughter and their parents, such as personalities, background, lifestyle and hobbies. <br /><br />
        
        <span class="required">* Required fields</span>
    
        <table width="100%" cellspacing="0" cellpadding="2" class="border">
            <tr bgcolor="##deeaf3">
                <td align="center">
                    <textarea cols="75" rows="25" name="familyLetter">#Replace(FORM.familyLetter,"<br>","#chr(10)#","all")#</textarea>
                </td>
            </tr>
        </table>
        
        <!--- Check if FORM submission is allowed --->
        <cfif APPLICATION.CFC.UDF.allowFormSubmission(section=URL.section)>
            <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
                <tr>
                    <td align="right"><input name="Submit" type="image" src="images/buttons/Next.png" border="0"></td>
                </tr>
            </table>
    	</cfif>
        
    </form>

</cfoutput>