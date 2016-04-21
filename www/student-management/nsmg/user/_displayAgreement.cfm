<!--- ------------------------------------------------------------------------- ----
	
	File:		_displayAgreement.cfm
	Author:		Marcus Melo
	Date:		July 25, 2012
	Desc:		Services Agreement Contract

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userID" default="#CLIENT.userID#">
	<cfparam name="FORM.seasonID" default="#APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#">
    <cfparam name="FORM.termsAgree" default="">
    <cfparam name="FORM.signature" default="">

    <cfscript>
		// Get Season Info
		qGetSeason = APPLICATION.CFC.LOOKUPTABLES.getSeason(seasonID=FORM.seasonID);
		
		// Get User Information
		qGetUser = APPLICATION.CFC.USER.getUsers(userID=FORM.userID);
	
		// Get Paperwork Info
		qGetSeasonPaperwork = APPLICATION.CFC.USER.getSeasonPaperwork(userID=FORM.userID, seasonID=FORM.seasonID);
	</cfscript>
	
    <!--- FORM SUBMITTED --->
	<cfif VAL(FORM.submitted)>
    	
        <cfscript>
			// Check Signature
			vDoesSignatureMatch = 0;
			
			vUserSignature = TRIM(qGetUser.firstName) & " " & TRIM(qGetUser.lastName);
			
			if ( LEN(TRIM(FORM.Signature)) AND TRIM(FORM.Signature) EQ TRIM(vUserSignature) ) {
				vDoesSignatureMatch = 1;
			}
			
			/**********************
				Data Validation
			**********************/
			
			// Signature Is Required
			if ( NOT LEN(TRIM(FORM.signature)) )  {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please sign your name");
			}
			
			// Signature does not match
			if ( LEN(TRIM(FORM.signature)) AND NOT VAL(vDoesSignatureMatch) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Your signed name #FORM.signature# does not match the name on file #CLIENT.name#");
			}
			
			// Agreement
			if ( NOT VAL(FORM.termsAgree) )  {
				// Get all the missing items in a list
				SESSION.formErrors.Add("Please check the box indicating you agree to the terms of the service agreement.");
			}
        </cfscript>
        
        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        	
            <cfscript>
				// Add Page Message
				SESSION.pageMessages.Add("Form successfully submitted");				
            </cfscript>
            
			<!--- Generate PDF File --->
            <cfdocument format="PDF" filename="#APPLICATION.CFC.USER.getUserSession().myUploadFolder#Season#FORM.seasonID#AreaRepAgreement.pdf" overwrite="yes">
                
				<!--- Second Visit Representative --->
                <cfif CLIENT.usertype EQ 15>
    
                    <cfinclude template="agreement2ndVisit.cfm">
    
                <cfelse>
                
                    <cfif CLIENT.companyID EQ 14>
                        <cfinclude template="agreementESIAreaRep.cfm">
                    <cfelseif CLIENT.companyID EQ 15>
                    	<cfinclude template="agreementDASHAreaRep.cfm">
                    <cfelse>
                        <cfinclude template="agreementAreaRep.cfm">
                    </cfif>
                    
                </cfif>
            
                <cfoutput>
                    <br />
                    <p>
                        Electronically Signed <br />
                        #FORM.signature# <br />
                        #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')# <br />
                        IP Address: #CGI.REMOTE_ADDR# 
                    </p>
                </cfoutput>
            
            </cfdocument>
                
			<!--- Email to User --->    
            <cfsavecontent variable="repEmailMessage">
                <p>
                	Attached is a copy of the Service Agreement you electronically signed.  
                    A copy is also available at any time in the paperwork section under "Users -> My Information" when logged into EXITS.
                </p> <br />
                Regards-<br />
                EXITS Support
            </cfsavecontent>
            
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#CLIENT.email#">   
                <cfinvokeargument name="email_from" value="#CLIENT.emailfrom# (#CLIENT.companyshort# Support)">
                <cfinvokeargument name="email_subject" value="Agreement">
                <cfinvokeargument name="email_message" value="#repEmailMessage#">
                <cfinvokeargument name="email_file" value="#APPLICATION.CFC.USER.getUserSession().myUploadFolder#Season#FORM.seasonID#AreaRepAgreement.pdf">
            </cfinvoke>	
        	
			<cfif qGetSeasonPaperwork.recordcount> 
            	
                <!--- Update Paperwork --->
                <cfquery datasource="#APPLICATION.DSN#">
                    UPDATE 
                    	smg_users_paperwork
                    SET 
                    	ar_agreement = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	                    agreeSig = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.signature)#"> 
                    WHERE
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#"> 
                    AND 
                    	seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">
                </cfquery>
                
            <cfelse>
            
            	<!--- Insert Paperwork --->
                <cfquery datasource="#APPLICATION.DSN#">
                	INSERT INTO 
                    	smg_users_paperwork 
                    (
                    	ar_agreement, 
                        userID, 
                        seasonID,
                        fk_companyID, 
                        agreeSig,
                        dateCreated
                     )
                	VALUES	
                    (
                    	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.seasonID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.signature)#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
                </cfquery>
                
            </cfif>

            <cfscript>
				// Update User Session Paperwork
				APPLICATION.CFC.USER.setUserSessionPaperwork();
			
				// Check if we need to send out a notification to the regional manager
				APPLICATION.CFC.USER.paperworkSubmittedRMNotification(userID=FORM.userID);
			</cfscript>
        	
		</cfif>  <!--- NOT SESSION.formErrors.length() --->

	</cfif> <!--- FORM SUBMITTED --->
    
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        
            <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 2000);
            </script>
        
        </cfif>
        
        <style type="text/css">
            div.scroll {
                height: 400px;
                width:auto;
                overflow:auto;
                left:auto;
                padding: 8px;
                border-top-width: thin;
                border-right-width: 2px;
                border-bottom-width: thin;
                border-left-width: 2px;
                border-top-style: inset;
                border-right-style: solid;
                border-bottom-style: outset;
                border-left-style: solid;
                border-top-color: ##efefef;
                border-right-color: ##c6c6c6;
                border-bottom-color: ##efefef;
                border-left-color: ##c6c6c6;
            }
            .greyHeader{
                width:590px;
                background-color:##CCC;
                padding:5px;
                text-align: center;
            }
            .lightGrey{
                width:590px;
                background-color:##EFEFEF;
                padding:5px;
                text-align: left;
            }
            .wrapper {
                padding: 8px;
                width: 600px;
                margin-right: auto;
                margin-left: auto;
                border: thin solid ##CCC;
            }
            body {
                font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
                font-size: 12px;
                color: ##000;
            }
            .clearfix {
                display: block;
                height: 12px;
            }
            .italic {
                font-size: 11px;
            }
        </style>

        <div class="wrapper">
        
            <div class="greyHeader">
                <h1>Services Agreement - AYP 2014-2015</h1>
            </div> <br />
        
			<!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />
            
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="divOnly"
                width="90%"
                />

	        <p>
            	It's time to re-sign the <cfif CLIENT.usertype EQ 15>Second Visit</cfif> Area Representative Agreement.  
                Please read carefully and then sign below indicationg you agree to the terms and conditions.
            </p>
        
        	<p>Once signed, a PDF version will be available under your profile that is available for printing if you would like a hard copy.</p>
        
            <div class="scroll">
        
				<!--- Second Visit Representative --->
				<cfif CLIENT.usertype EQ 15>
    
                    <cfinclude template="agreement2ndVisit.cfm">
    
                <cfelse>
                
                    <cfif CLIENT.companyID EQ 14>
                        <cfinclude template="agreementESIAreaRep.cfm">
                    <cfelse>
                        <cfinclude template="agreementAreaRep.cfm">
                    </cfif>
                    
                </cfif>
                
        	</div>

        	<div class="clearfix"></div>
        
        	<div class="lightGrey">
        
				<cfif isDate(qGetSeasonPaperwork.ar_agreement)>
    
                    <div align="center">
                        Signed by #qGetSeasonPaperwork.agreeSig# on #DateFormat(qGetSeasonPaperwork.ar_agreement, 'mmmm d, yyyy')#
                    </div>
    
                <cfelse>
                
                      <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                          <input type="hidden" name="submitted" value="1" />
                          <input type="hidden" name="userID" value="#FORM.userID#" />
                          <input type="hidden" name="seasonID" value="#FORM.seasonID#" />
                          
                          <table width=100% align="Center">
                              <tr>
                                  <td valign="top"><input type="checkbox" name="termsAgree" id="termsAgree" value="1" /></td>
                                  <td>
                                      <label for="termsAgree">I agree to the terms and conditions set above.</label> <br />
                                      <i class="italic">(Typing your name below replaces your signature on this document)</i> <br />
                                  </td>
                              </tr>
                              <tr>
                                  <td colspan="2" align="center">
                                      <input type="text" name="signature" id="signature" class="largeField" /><br />#CLIENT.name#
                                  </td>
                              </tr>
                              <tr>                                  
                                  <td colspan="2" align="center"><br /><input type="image" src="../pics/buttons_SUBMIT.png" /></td>
                              </tr>
                          </table>
                          
                      </form>
                      
				</cfif>
           
			</div> <!--- <div class="lightGrey"> --->

		</div> <!--- <div class="wrapper"> --->
                
	<!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
    />

</cfoutput>