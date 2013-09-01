<!--- ------------------------------------------------------------------------- ----
	
	File:		referenceQuestionnaire.cfm
	Author:		Marcus Melo
	Date:		January 18, 2013
	Desc:		Host Family Reference Questionnaire
				
	Updates:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="0">
    <cfparam name="URL.refID" default="0">
    
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.hostID" default="0">
    <cfparam name="FORM.refID" default="0">
	<cfparam name="FORM.dateInterview" default="">    
    
    <cfscript>
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		// Check if we have a valid URL.refID
		if ( VAL(URL.refID) AND NOT VAL(FORM.refID) ) {
			FORM.refID = URL.refID;
		}
		
		// Get Current SeasonID
		vCurrentSeasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID; // This needs to be replaced to get the assigned season for this app as a host family might apply to different seasons
		
		// Get List of Host Family Applications
		qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID);	

		// Get Reference for this season
		qGetReferenceInfo = APPLICATION.CFC.HOST.getReferences(refID=FORM.refID,hostID=qGetHostInfo.hostID,seasonID=vCurrentSeasonID);
		
		// Get Reference Questionnaire Details
		qGetQuestionnaireDetails = APPLICATION.CFC.HOST.getReferenceQuestionnaireAnswers(fk_reportID=FORM.refID);

		// Get User By Userid
		qGetCurrentUserInfo = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);

		// Param FORM Variables
		For ( i=1; i LTE qGetQuestionnaireDetails.recordCount; i++ ) {
			param name="FORM.question#qGetQuestionnaireDetails.ID[i]#" default="";
		}
		
		// This returns the approval fields for the logged in user
		stCurrentUserFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames();
		
		// This Returns who is the next user approving / denying the report
		stUserOneLevelUpInfo = APPLICATION.CFC.USER.getUserOneLevelUpInfo(currentUserType=qGetHostInfo.hostAppStatus,regionalAdvisorID=qGetHostInfo.regionalAdvisorID);
		
		// This returns the fields that need to be checked
		stOneLevelUpFieldSet = APPLICATION.CFC.HOST.getApprovalFieldNames(userType=stUserOneLevelUpInfo.userType);

		// If report approved by current user and denied by up level display edit page, else display print version
		if ( NOT VAL(qGetReferenceInfo.ID) OR qGetReferenceInfo[stCurrentUserFieldSet.statusFieldName][qGetReferenceInfo.currentrow] NEQ 'approved' OR qGetReferenceInfo[stOneLevelUpFieldSet.statusFieldName][qGetReferenceInfo.currentrow] EQ 'denied' ) {
			// Allow edit	
			vIsEditAllowed = true;
		} else {
			// Read only if it has been approved 
			vIsEditAllowed = false;
		}
	</cfscript>
    
    <!--- FORM Submitted --->
    <cfif FORM.submitted>

		<cfscript>
			// Data Validation
			
            // Date of Visit
            if ( NOT isDate(FORM.dateInterview) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the date of the interview.");
            }	
			
            // Date of Visit
            if ( isDate(FORM.dateInterview) AND FORM.dateInterview GT now() ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter a past date for the date of the interview.");
            }	
			
			// Check Answers
			For ( i=1; i LTE qGetQuestionnaireDetails.recordCount; i++ ) {
				
				if ( NOT LEN( FORM["question" & qGetQuestionnaireDetails.ID[i]] ) ) {
					SESSION.formErrors.Add("Please answer question number #qGetQuestionnaireDetails.ID[i]#.");
				}
				
			}
        </cfscript>
        
		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length() AND VAL(FORM.hostID) AND VAL(FORM.refID)>			
            
            <!--- Loop Through Questions --->
            <cfloop query="qGetQuestionnaireDetails">
            
				<!--- Update Answers --->
                <cfif VAL(qGetQuestionnaireDetails.answerID)>
                    
                    <cfquery datasource="#APPLICATION.DSN#">
						UPDATE
                        	smg_host_reference_answers
                        SET
                        	answer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['question' & qGetQuestionnaireDetails.ID]#">
                        WHERE
                        	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetQuestionnaireDetails.answerID#">
                        AND
                        	fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.refID#">
                    </cfquery>
                    
                <!--- Insert Answers --->
                <cfelse>
                
                    <cfquery datasource="#APPLICATION.DSN#">
						INSERT INTO
                        	smg_host_reference_answers
                        (
                        	fk_reportID, 
                            fk_questionID,
                            answer
                        )
                        VALUES
                        (
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.refID#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetQuestionnaireDetails.ID#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['question' & qGetQuestionnaireDetails.ID]#">
                        )
                    </cfquery>
    
                </cfif>
            
            </cfloop>
            
			<cfscript>
				// Use same approval process of the host family sections and update Date of Interview
				APPLICATION.CFC.HOST.updateReferenceStatus(
					ID=qGetReferenceInfo.ID,
					hostID=qGetHostInfo.hostID,
					fk_referencesID=FORM.refID,
					action="approved",
					notes="",
					areaRepID=qGetHostInfo.areaRepID,
					regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
					regionalManagerID=qGetHostInfo.regionalManagerID,
					dateInterview=FORM.dateInterview
				);
            </cfscript>
        
            <cfscript>
                // Refresh Query used in the approval process
                qGetQuestionnaireDetails = APPLICATION.CFC.HOST.getReferenceQuestionnaireAnswers();
			
				// Set Page Message
				SESSION.pageMessages.Add("Reference Questionnaire successfully submitted. This window will close shortly.");
			</cfscript>
    
    	</cfif>
            
    <!--- Set Default FORM Values --->
    <cfelse>
		
        <cfscript>
			// Set FORM Values   
			FORM.dateInterview = qGetReferenceInfo.dateInterview;

			// Set Default Form Values - Questionnaire Answers
			For ( i=1; i LTE qGetQuestionnaireDetails.recordCount; i++ ) {
				FORM["question" & qGetQuestionnaireDetails.ID[i]] = qGetQuestionnaireDetails.answer[i];
			}
		</cfscript>
        
    </cfif>

</cfsilent>    

<cfoutput>
	
	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
        filePath="../"
    />	

		<style type="text/css">
            p, h1, form, button{
                border:0; 
                margin:0; 
                padding:0;
            }
            /* ----------- My Form ----------- */
            .myform{
                margin:0 auto;
                width:700px;
                padding:14px;
            }
            /* ----------- stylized ----------- */
            .stylized{
                border:solid 2px ##b7ddf2;
                background:##ebf4fb;
            }
            .stylized h1 {
                font-size:1.3em;
                font-weight:bold;
                margin-bottom:8px;
            }
            .stylized p {
                color:##666666;
                border-bottom:solid 1px ##b7ddf2;
				margin-bottom:10px;
				padding-bottom:10px;
            }
            .stylized label {
                padding-right: 15px;
                vertical-align: top;
				display:block;
				margin-bottom:5px;
				font-size:1em;
            }
            .stylized button{
                clear:both;
                margin-left:150px;
                width:125px;
                height:31px;
                background:##666666 no-repeat;
                text-align:center;
                line-height:31px;
                color:##FFFFFF;
                font-size:11px;
                font-weight:bold;
				cursor:pointer;
            }
        </style>
    
    	<!--- Close Window --->
        <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        
			<script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
		
        </cfif>
        
        <form action="#CGI.SCRIPT_NAME#" method="POST"> 
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="refID" value="#FORM.refID#" />
            <input type="hidden" name="hostID" value="#FORM.hostID#">
        	
            <div class="myform stylized">

	            <h1>Host Family Reference Questionnaire</h1>
                
                <p>
                    <strong>Host Family:</strong> 
                    #APPLICATION.CFC.HOST.displayHostFamilyName(
                        fatherFirstName=qGetHostInfo.fatherFirstName,
                        fatherLastName=qGetHostInfo.fatherLastName,
                        motherFirstName=qGetHostInfo.motherFirstName,
                        motherLastName=qGetHostInfo.motherLastName)# (###qGetHostInfo.hostid#) - 
                        #qGetHostInfo.city#, #qGetHostInfo.state# #qGetHostInfo.zip# <br />
                        
					<strong>Interviewer:</strong> 
                 
              
                    	#qGetReferenceInfo.submittedBy# <br />
                        <cfif LEN(qGetReferenceInfo.submittedBy)>
                    <cfelse>
                        #qGetCurrentUserInfo.firstName# #qGetCurrentUserInfo.lastName# (###qGetCurrentUserInfo.userID#) <br />
                    </cfif>
              	</p>
               
                <h1>Reference Information</h1>

                <p>
                    <strong>Name:</strong> #qGetReferenceInfo.firstname# #qGetReferenceInfo.lastname# <br />
                    <strong>Phone:</strong> #qGetReferenceInfo.phone# <br />
                    <strong>Address:</strong> #qGetReferenceInfo.address# #qGetReferenceInfo.address2# #qGetReferenceInfo.city# #qGetReferenceInfo.state#, #qGetReferenceInfo.zip# <Br />
                    <strong>Email:</strong> <cfif LEN(qGetReferenceInfo.email)>#qGetReferenceInfo.email#<cfelse>n/a</cfif>            
                </p>

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
            
                <!--- Form Values --->
                <p>
                    <label for="dateInterview">
                        Date of Interview <span class="required">*</span>
                    </label>
                                    
                    <cfif vIsEditAllowed>
                        <input type="text" name="dateInterview" id="dateInterview" value="#DateFormat(FORM.dateInterview, 'mm/dd/yyyy')#" class="datePicker" placeholder='MM/DD/YYYY'>
                    <cfelse>
                        #DateFormat(FORM.dateInterview, 'mm/dd/yyyy')# 
                    </cfif>
                </p>
                
                <!--- Loop Through Questions --->
                <cfloop query="qGetQuestionnaireDetails">
                    <p>
	                    <label for="question#qGetQuestionnaireDetails.ID#">#qGetQuestionnaireDetails.ID#. #qGetQuestionnaireDetails.qtext# <span class="required">*</span></label>
                    	
                        <cfif vIsEditAllowed>
                            <textarea name="question#qGetQuestionnaireDetails.ID#" id="question#qGetQuestionnaireDetails.ID#" cols="80" rows="4"/>#FORM["question" & qGetQuestionnaireDetails.ID]#</textarea>                    
						<cfelse>
                        	#FORM["question" & qGetQuestionnaireDetails.ID]#
                        </cfif>
                                                    
                    </p>
				</cfloop>

                <cfif vIsEditAllowed>
                    <span class="required">* Required fields</span>           
                
                    <div align="right">
                        <input type="hidden" name="submit" />
                        <button type="submit">Submit Information</button>
                    </div>
				</cfif>
                
            </div>  
        
   		</form>
        
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="noFooter"
        filePath="../"
    />

</cfoutput>