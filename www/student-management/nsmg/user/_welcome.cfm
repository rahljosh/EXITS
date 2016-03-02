<!--- ------------------------------------------------------------------------- ----
	
	File:		_welcome.cfm
	Author:		Marcus Melo
	Date:		July 17, 2012
	Desc:		User Landing Page	
	
	Notes:		2nd Visit Reps only see agreement and CBC.
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.subAction" default="">
    <cfparam name="URL.refID" default="">
    <cfparam name="URL.employmentID" default="">
	
    <!--- Delete Employment History --->
    <cfif URL.subAction EQ 'deleteEmploymentHistory' AND VAL(URL.employmentID)>>

        <cfquery datasource="#APPLICATION.DSN#">	
        	DELETE FROM 
            	smg_users_employment_history
        	WHERE
            	employmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.employmentID#">
            AND
            	fk_userID = <cfqueryparam cfsqltype="cf_sql_interger" value="#CLIENT.userID#"> <!--- DO NOT USE CLIENT --->
        </cfquery>

		<cfscript>
			// Update User Session Paperwork
			APPLICATION.CFC.USER.setUserSessionPaperwork();
		
            // Add Page Message
            SESSION.pageMessages.Add("Employment history successfully deleted");	

			// Refresh Page
			Location("index.cfm?curdoc=user/index", "no");
        </cfscript>

    <!--- Delete Reference --->
	<cfelseif URL.subAction EQ 'deleteReference' AND VAL(URL.refID) AND VAL(URL.userID)>
    	
        <cfquery datasource="#APPLICATION.DSN#">	
        	DELETE FROM 
            	smg_user_references
        	WHERE
            	refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.refID#">
            AND
            	referenceFor = <cfqueryparam cfsqltype="cf_sql_interger" value="#URL.userID#">  <!--- DO NOT USE CLIENT --->
        </cfquery>

		<cfscript>
			// Update User Session Paperwork
			APPLICATION.CFC.USER.setUserSessionPaperwork();
		
            // Add Page Message
            SESSION.pageMessages.Add("Reference successfully deleted");	
			
			// Refresh Page
			//Location("index.cfm?curdoc=user/index", "no");
			Location(CGI.HTTP_REFERER, "no");
        </cfscript>
    
    <!--- Skip Paperwork Fill Out Later --->
    <cfelseif URL.subAction EQ 'skipPaperwork' AND NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isPaperworkRequired>
    	
        <cfscript>
			// Set as later
			SESSION.USER.paperworkSkipAllowed = true;
			
			// Go to Welcome Page
			Location("index.cfm?curdoc=initial_welcome", "no");
		</cfscript>
        
    </cfif>
    

    <cfscript>
		// Get Current Season
		qGetSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
	
		// Get User Information
		qGetUser = APPLICATION.CFC.USER.getUsers(userID=CLIENT.userID);

		// Get Training records for this user
		qGetTraining = APPLICATION.CFC.USER.getTraining(userID=CLIENT.userID, seasonID=qGetSeason.seasonID);

		// Get Leads that need attention
		qGetHostLeads = APPLICATION.CFC.HOST.getPendingHostLeads(
			userType=CLIENT.userType,
			areaRepID=qGetUser.userID, 
			regionID=CLIENT.regionID,
			lastLogin=CLIENT.lastlogin
		);	

		// Get Unplaced Students
		qGetUnplacedStudents = APPLICATION.CFC.STUDENT.getUnplacedStudents(regionID=CLIENT.regionID);

		// Get Employment History - Does not expire
		qGetEmploymentHistory = APPLICATION.CFC.USER.getEmploymentByID(userID=qGetUser.userID);

		// Get References - Does not expire - Minimum of 4 references
		qGetReferences = APPLICATION.CFC.USER.getReferencesByID(userID=qGetUser.userID);
		
		
		/*****
			Reset Paperwork - REMOVE THIS LATER - 11/01/2012
		*****/
		APPLICATION.CFC.USER.getUserSessionPaperwork();
	</cfscript>
    
</cfsilent>

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal - Refresh Student Info page after closing placement management
		$(".jQueryModal").colorbox( {
			width:"50%", 
			height:"75%", 
			iframe:true,
			overlayClose:false,
			escKey:false, 
			onClosed:function(){ window.location.reload(); }
		});	

	});
</script> 	

<cfoutput>

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

    <!--- User Paperwork --->
    <div class="rdholder"> 
        
        <div class="rdtop"> 
            <span class="rdtitle">User Paperwork - Season #qGetSeason.years# </span> 
        </div> <!-- end rdtop --> 

        <div class="rdboxPaperwork">
			
			<cfif APPLICATION.CFC.USER.getUserSessionPaperwork().isAccountCompliant>
            	<!--- Full Access --->            	
            	<p align="center"><strong>Paperwork Status:</strong> Submitted | <strong>EXITS Access:</strong> Granted</p>
                <p align="center">Your account is compliant.</p>
            
			<cfelseif APPLICATION.CFC.USER.getUserSessionPaperwork().accountReviewStatus EQ 'missingTraining'>
            	<!--- Missing Trainings --->   
            	<p align="center"><strong>Paperwork Status:</strong> Submitted | <strong>EXITS Access:</strong> Limited</p>
				<cfif NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isDOSCertificationCompleted AND NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isTrainingCompleted>
                    <p align="center">You are missing the DOS Certification and WebEx Area Rep Training (New Area Rep or Refresher), please see below.</p>
                <cfelseif NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isDOSCertificationCompleted>
                    <p align="center">You are missing the DOS Certification, please see below.</p>
                <cfelse>
                    <p align="center">You are missing the WebEx Area Rep Training (New Area Rep or Refresher), please see below.</p>
                </cfif>

			<cfelseif APPLICATION.CFC.USER.getUserSessionPaperwork().accountReviewStatus EQ 'officeReview'>
            	<!--- Office Review ---> 
            	<p align="center"><strong>Paperwork Status:</strong> Submitted | <strong>EXITS Access:</strong> Limited</p>
                <p align="center">              	
                    You have submitted initial paperwork for this season and your references have been checked by your Regional Manager. 
                    Headquarters is going to review your account. <br />
                </p>
            
			<cfelseif APPLICATION.CFC.USER.getUserSessionPaperwork().accountReviewStatus EQ 'rmReview'>
            	<!--- RM Review ---> 
            	<p align="center"><strong>Paperwork Status:</strong> Initial Paperwork Submitted | <strong>EXITS Access:</strong> Limited</p>
                <p align="center">                	
                    You have submitted initial paperwork for this season. 
                    Your Regional Manager is going to review your account and check your references. <br />
                </p>
			
			<cfelseif APPLICATION.CFC.USER.getUserSessionPaperwork().isUserPaperworkCompleted> 
				<!--- Paperwork Completed --->            	
            	<p align="center"><strong>Paperwork Status:</strong> Submitted | <strong>EXITS Access:</strong> Limited</p>
                <p align="center">             	
                    You have submitted all required paperwork for this season. A manual review is needed in order to fully activate your account. <br />
					As soon as we review it, you are going to be notified by email and be granted full access to EXITS. <br />
                </p>
            </cfif>
            
            <!--- 21 Days Extra Window --->
            <cfif isDate(APPLICATION.CFC.USER.getUserSessionPaperwork().season.dateExtraPaperworkRequired) AND NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isPaperworkRequired>
            	<p align="center">
                	You have until #APPLICATION.CFC.USER.getUserSessionPaperwork().season.dateExtraPaperworkRequired# to complete your paperwork.
				</p>
            </cfif>
            
            <div class="subSection">
            
                <div class="title">  
                	<img src="pics/icons/onlinePaperwork.png" border="0" title="Services Agreement" />              
                    <h2>Services Agreement</h2>
                </div>
                
				<cfif APPLICATION.CFC.USER.getUserSessionPaperwork().isAgreementCompleted>
                    <p>
                    	#qGetSeason.years# Agreement expires on #APPLICATION.CFC.USER.getUserSessionPaperwork().season.datePaperworkEnded#
						<cfif FileExists("#APPLICATION.CFC.USER.getUserSession().myUploadFolder#Season#qGetSeason.seasonID#AreaRepAgreement.pdf")>
	                        <a href="#APPLICATION.CFC.USER.getUserSession().myRelativeUploadFolder#Season#qGetSeason.seasonID#AreaRepAgreement.pdf" target="_blank" style="float:right;">[ Download Agreement ]</a>
                        </cfif>
					</p>
                    <div align="center" style="padding-top:7px;"><img src="pics/buttons/complete.png" border="0" /></div>
                <cfelse>
                	<p>Our records indicate that you have <strong>NOT</strong> signed the agreement for this season, please click on the link below to sign.</p>
                    <div align="center" style="padding-top:7px;"><a href="user/index.cfm?action=displayAgreement" class="jQueryModal"><img src="pics/buttons/needInformation.png" border="0" /></a></div>
                </cfif> 
                
            </div>
        
            <div class="subSection">
            
                <div class="title">
	                <img src="pics/icons/doc.png" border="0" title="CBC Authorization" />                
                    <h2>CBC Authorization</h2>
                </div>
                
                <cfif APPLICATION.CFC.USER.getUserSessionPaperwork().isCBCAuthorizationCompleted>
                    <p>
                    	#qGetSeason.years# Authorization expires on #APPLICATION.CFC.USER.getUserSessionPaperwork().season.datePaperworkEnded# 
						<cfif FileExists("#APPLICATION.CFC.USER.getUserSession().myUploadFolder#Season#qGetSeason.seasonID#cbcAuthorization.pdf")>
	                        <a href="#APPLICATION.CFC.USER.getUserSession().myRelativeUploadFolder#Season#qGetSeason.seasonID#cbcAuthorization.pdf" target="_blank" style="float:right;">[ Download CBC Authorization ]</a>
                        </cfif>
                    </p>
                    <div align="center" style="padding-top:7px;"><img src="pics/buttons/complete.png" border="0" /></div>
                <cfelse>
                	<p>Our records indicate that you have <strong>NOT</strong> submitted a CBC authorization, please click on the link below to submit.</p>
                    <div align="center" style="padding-top:7px;"><a href="user/index.cfm?action=cbcAuthorization" class="jQueryModal"><img src="pics/buttons/needInformation.png" border="0" /></a></div>
                </cfif>
                
            </div>


            <!--- Do Not Display for Second Visit Reps or ESI --->
            <cfif CLIENT.userType NEQ 15 AND APPLICATION.SETTINGS.COMPANYLIST.ESI NEQ companyID>

                <div class="subSection">
                    
                    <div class="title">
                        <img src="pics/icons/DOS.png" border="0" title="Department of State Certification" />               
                        <h2>Department of State Certification</h2>
                    </div>
                    
                    <!--- Complete --->
                    <cfif APPLICATION.CFC.USER.getUserSessionPaperwork().isDOSCertificationCompleted>
                        <p>#qGetSeason.years# DOS Certification expires on #APPLICATION.CFC.USER.getUserSessionPaperwork().dateDOSTestExpired#</p>
                        <div align="center" style="padding-top:7px;"><img src="pics/buttons/complete.png" border="0" /></div>
                    <!--- Need Info --->
                    <cfelse>
                        <p>Our records indicate that you have <strong>NOT</strong> taken the DOS Certification test for this season, please click on the link below to take the test.</p>
                        <div align="center">
                            <a href="user/index.cfm?uniqueID=#CLIENT.uniqueID#&action=trainCasterLogin" target="_blank" title="Click Here to Take the DOS Test">
                                <img src="pics/buttons/needInformation.png" border="0" /> 
                                <!--- <img src="pics/buttons/DOScertification.png" border="0" title="Click Here to Take the DOS Certification Test" /> --->
                            </a>
                        </div>                    
                    </cfif> 
                    
                </div>
            

                <div class="subSectionLarge">
                
                    <div class="title">
                    	<img src="pics/icons/onlineReport.png" border="0" title="Employment History" />                
                        <h2>Employment History</h2>
                    </div>

                    <table width="96%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" style="margin-bottom:15px;">
                        <tr>
                            <th class="left">Employer</th>
                            <th class="left">Address</th>
                            <th class="left">Phone</th>
                            <th class="left">Actions</th>
                        </tr>
                        <cfloop query="qGetEmploymentHistory">
                            <tr class="#iif(qGetEmploymentHistory.currentrow MOD 2 ,DE("on") ,DE("off") )#">
                                <cfif qGetEmploymentHistory.employer EQ 'None Provided'>
                                	<td colspan="3">#qGetEmploymentHistory.employer#</td>
                                <cfelse>
                                    <td>#qGetEmploymentHistory.employer#</td>
                                    <td>#qGetEmploymentHistory.address#, #qGetEmploymentHistory.city#, #qGetEmploymentHistory.state# #qGetEmploymentHistory.zip#</td>
                                    <td>#qGetEmploymentHistory.phone#</td>
                                </cfif>
                                <td>
                                	[
                                    <a href="user/index.cfm?action=employmentHistory&employmentID=#qGetEmploymentHistory.employmentID#" class="jQueryModal">Edit</a> 
                                    |
                                    <a href="index.cfm?curdoc=user/index&action=welcome&subAction=deleteEmploymentHistory&employmentID=#qGetEmploymentHistory.employmentID#" onClick="return confirm('Are you sure you want to delete this employment history?')">Delete</a>
                                	]
                                </td>
                            </tr>                        
                        </cfloop>
                        <cfif NOT qGetEmploymentHistory.recordCount>
                        	<tr class="on"><td colspan="4" align="center">You have not submitted your employment history</td>
                        </cfif>                        
                    </table>
					
                    <!--- Complete --->
					<cfif APPLICATION.CFC.USER.getUserSessionPaperwork().isEmploymentHistoryCompleted>
                        <div align="center" style="padding-top:7px;"><img src="pics/buttons/complete.png" border="0" /></div>
                    <!--- Need Info --->
					<cfelse>
                    	<p>1 employer is required. <strong>You have not added an employer yet.</strong> Click the link below to add one.</p>
                    	<div align="center" style="padding-top:7px;"><a href="user/index.cfm?action=employmentHistory" class="jQueryModal"><img src="pics/buttons/needInformation.png" border="0" /></a></div>
					</cfif>                    
                                    
                </div>            
                
                
                <div class="subSectionLarge">
                
                    <div class="title"> 
                    	<img src="pics/icons/annualPaperwork.png" border="0" title="References" />               
                        <h2>References</h2>
                    </div>
                    
                    <table width="96%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" style="margin-bottom:15px;">
                        <tr>
                            <th class="left">Ref.</th>
                            <th class="left">Name</th>
                            <th class="left">Address</th>
                            <th class="left">Phone</th>
                            <th class="left">Actions</th>
                        </tr>
                        <cfloop query="qGetReferences">
                            <tr class="#iif(qGetReferences.currentrow MOD 2 ,DE("on") ,DE("off") )#">
                                <td>#qGetReferences.currentRow#</td>
                                <td>#qGetReferences.firstName# #qGetReferences.lastName#</td>
                                <td>#qGetReferences.address#, #qGetReferences.city#, #qGetReferences.state# #qGetReferences.zip#</td>
                                <td>#qGetReferences.phone#</td>
                                <td>
                                	[
                                    <a href="user/index.cfm?action=reference&refID=#qGetReferences.refID#" class="jQueryModal">Edit</a> 
                                    |
                                    <a href="index.cfm?curdoc=user/index&action=welcome&subAction=deleteReference&refID=#qGetReferences.refID#&userID=#qGetReferences.referenceFor#" onClick="return confirm('Are you sure you want to delete this reference?')">Delete</a>
                                	]
                                </td>
                            </tr>                        
                        </cfloop>
                        <cfif NOT qGetReferences.recordCount>
                        	<tr class="on"><td colspan="5" align="center">You have not submitted your references</td>
                        </cfif>                                                
                    </table>

					<cfswitch expression="#APPLICATION.CFC.USER.getUserSessionPaperwork().missingReferences#">
                    	
                        <!--- Complete --->
                        <cfcase value="0">
                        	<div align="center" style="padding-top:7px;"><img src="pics/buttons/complete.png" border="0" /></div>
                        </cfcase>
                        
                        <cfcase value="1">
                            <p>4 references are required. <strong>You need to add #APPLICATION.CFC.USER.getUserSessionPaperwork().missingReferences# additional reference,</strong> click the link below to add a reference.</p>
                        </cfcase>

                        <cfcase value="2,3">
                        	<p>4 references are required. <strong>You need to add #APPLICATION.CFC.USER.getUserSessionPaperwork().missingReferences# additional references,</strong> click the link below to add references.</p>                         
                        </cfcase>

                        <cfcase value="4">
                        	<p>4 references are required. <strong>You have not added references yet.</strong> Click the link below to add references.</p>
                        </cfcase>
                    
                    </cfswitch>
					
                    <!--- Add Reference Button --->
					<cfif VAL(APPLICATION.CFC.USER.getUserSessionPaperwork().missingReferences)>
                        <div align="center" style="padding-top:7px;"><a href="user/index.cfm?action=reference" class="jQueryModal"><img src="pics/buttons/needInformation.png" border="0" /></a></div>
                    </cfif>
                    
                </div>


				<!--- Do not display for ESI --->
                <cfif APPLICATION.SETTINGS.COMPANYLIST.ESI NEQ companyID OR APPLICATION.SETTINGS.COMPANYLIST.DASH NEQ companyID>
                    <div class="subSectionLarge">
                        
                        <div class="title"> 
                            <img src="pics/icons/onlineReports.png" border="0" title="Department of State Certification" />               
                            <h2>Trainings</h2>
                        </div>
        
                        <table width="96%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" style="margin-bottom:15px;">
                            <tr>
                                <th class="left">Date Trained</th>
                                <th class="left">Training</th>
                                <th class="left">Score %</th>
                                <th class="left">Added By</th>
                                <th class="left">Date Recorded</th>
                            </tr>
                            
                            <cfloop query="qGetTraining">
                                <tr class="#iif(qGetTraining.currentrow MOD 2 ,DE("on") ,DE("off") )#">
                                    <td>#DateFormat(qGetTraining.date_trained, 'mm/dd/yyyy')#</td>
                                    <td>#qGetTraining.trainingName#</td>
                                    <td>
                                        <cfif qGetTraining.score GT 0>
                                            #qGetTraining.score#%
                                        <cfelse>
                                            n/a
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif LEN(qGetTraining.officeUser)>
                                            #qGetTraining.officeUser#
                                        <cfelse>
                                            EXITS
                                        </cfif>                                
                                    </td>
                                    <td>#DateFormat(qGetTraining.date_created, 'mm/dd/yyyy')#</td>
                                </tr>                        
                            </cfloop>
                            <cfif NOT qGetTraining.recordCount>
                                <tr class="on"><td colspan="5" align="center">You have not taken any trainings this season</td>                                              
                            </cfif>
                        </table>                                                
                        
						<!--- Do Not Display for DASH --->
            				<cfif APPLICATION.SETTINGS.COMPANYLIST.DASH NEQ companyID>
                        <div align="center">
                            <p>Click Below to view trainings available</p>
                            
                            <a href="index.cfm?curdoc=calendar/index">
                                <cfif NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isTrainingCompleted>
                        			<div align="center" style="margin-top:7px;margin-bottom:7px;"><img src="pics/buttons/needInformation.png" border="0" /></div>
                                </cfif>
                                <img src="pics/webex-logo.jpg" border="0">
                            </a>
                        </div>                                        
                            </cfif>
        				
                        <!----
                        <!--- Complete --->
                        <cfif APPLICATION.CFC.USER.getUserSessionPaperwork().isTrainingCompleted>
                            <div align="center" style="padding-top:7px;"><img src="pics/buttons/complete.png" border="0" /></div>                
                        <!--- Need Info --->
                        <cfelse>
                            <div align="center">
                                <p>You are missing the New Area Rep or Area Rep Refresher training. Click below for our WebEx trainings schedule</p>
                                <a href="index.cfm?curdoc=calendar/index">
                                    <img src="pics/webex-logo.jpg" border="0">
                                </a>
                            </div>                                        
                        </cfif>
						--->						
                        
                    </div>
                    
				</cfif>
                
                
			</cfif>
            
            <!--- Skip Paperwork Option --->
            <cfif NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isPaperworkRequired>
                <div align="center" style="padding-top:7px;"><a href="index.cfm?curdoc=user/index&subAction=skipPaperwork"><img src="pics/buttons/skipPaperwork.png" border="0" /></a></div> 
            </cfif>

        </div> <!-- end rdbox --> 

        <div class="rdbottom"></div> <!-- end rdbottom --> 
        
    </div>
	    
    <!---
    <cfdump var="#APPLICATION.CFC.USER.getUserSession()#">    
    <cfdump var="#NOT APPLICATION.CFC.USER.getUserSessionPaperwork().isUserPaperworkCompleted#">
	<cfdump var="#APPLICATION.CFC.USER.getUserSessionPaperwork()#">
    --->
    
    <!---
    <!--- Notification --->
    <div class="rdholder" style="width:100%;"> 
        
        <div class="rdtop"> 
            <span class="rdtitle">Notifications</span> 
        </div> <!-- end rdtop --> 

        <div class="rdbox">

            <div class="subSection">
                <div class="title">                
                    <h2>Students</h2>
                    <a href="index.cfm?curdoc=students" title="Click here to see all items" target="_blank">See All</a>
                </div>
            
                <p>There are #qGetUnplacedStudents.recordCount# unplaced students in your region.</p>
            </div>

            <div class="subSection">
                <div class="title">                
                    <h2>Host Family Leads</h2>
                    <a href="index.cfm?curdoc=hostLeads/index" title="Click here to see all items" target="_blank">See All</a>
                </div>
            
                <p>There are #qGetHostLeads.recordCount# host leads needing your attention.</p>
            </div>
        
            <div class="subSection">
                <div class="title">                
                    <h2>Progress Reports</h2>
                    <a href="" title="Click here to see all items">See All</a>
                </div>
            
            </div>
            
            <div class="subSection">
                <div class="title">                
                    <h2>2<sup>nd</sup> Visit Reports</h2>
                    <a href="" title="Click here to see all items">See All</a>
                </div>
                
            </div>
            
            <div class="subSection">
                <div class="title">                
                    <h2>Students Arriving in the US</h2> <!--- this week? / soon --->
                    <a href="" title="Click here to see all items">See All</a>
                </div>
                
            </div>

            <div class="subSection">
                <div class="title">                
                    <h2>Students Departing the US</h2>
                    <a href="" title="Click here to see all items">See All</a>
                </div>
                
            </div>
            
        </div> <!-- end rdbox --> 

        <div class="rdbottom"></div> <!-- end rdbottom --> 

    </div>
	--->
    
</cfoutput>