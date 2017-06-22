<!--- ------------------------------------------------------------------------- ----
	
	File:		_detail.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		ISEUSA.com Host Family Leads

	Updated:	11/08/2011 - Ability to assign a lead to a follow up user
	
				02/01/2011 - Ability to assign a host lead to a region/area rep
				and enter status
				
				Office User  	Assign a region (required)
								Update status and comments (optional)
				Regional Man.	Assign an Area Representative (required)
								Update status and comments (optional)
				Area Rep.    	Update status and comments (optional)																	
				
----- ------------------------------------------------------------------------- --->


<!--- Kill Extra Output --->
<cfsilent>
		
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
	<cfscript>
		// Param URL Variables
		param name="URL.Key" type="string" default=0;
		param name="URL.app_sent" type="string" default=0;		
		try {
			param name="URL.ID" type="numeric" default=0;	
		} catch (any excpt) {
			URL.ID = 0;
		}
		
		// Param Form Variables
		param name="FORM.submitted" default=0;
		param name="FORM.hostLeadJNID" default=0;
		param name="FORM.followUpID" default=0;
		param name="FORM.companyID" default=0;
		param name="FORM.regionID" default=0;
		param name="FORM.areaRepID" default=0;
		param name="FORM.statusID" default=0;
		param name="FORM.comments" default='';
		param name="familyFound" default=1;
		param name="displayForm" default=1;
		param name="FORM.hostid" default=0;
		
		/* 
			Check to see if passed key is the correct hash for the record. 
			This will stop people from tampering with the URLs.
		*/
		

		// Get the given host family lead record
		qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=URL.ID);
		
		// Get Companies
		qGetCompanies = APPLICATION.CFC.COMPANY.getCompanies(companyIDList=APPLICATION.SETTINGS.COMPANYLIST.ISE);
		
		// Get List of Status
		qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='hostLeadStatus');
		
		//get status of app, if they have started filling it out.
		//this will only apply if they app was started from the host lead page.
		
		
		// Get History
		qGetHostLeadHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
			foreignTable='smg_host_lead',
			foreignID=qGetHostLead.ID
		);
		
		// Follow Up User List
		qGetFollowUpUserList = APPLICATION.CFC.USER.getUsers(userType=26);
		
		// FORM SUBMITTED
		if ( FORM.submitted ) {
		
		
			// Host Lead User is able to enter a comment only
			if ( CLIENT.userType NEQ 26 ) {
			
					
				// Data Validation - Allow adding comment only up to 3 times, after that region is required
				if ( NOT VAL(FORM.regionID) AND qGetHostLeadHistory.recordCount GT 3 AND CLIENT.usertype eq 5 ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('You must select a region');
				}			
	
				if ( NOT VAL(FORM.statusID) ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('You must select a status');
				}			
				
				if ( ListFind("3,8", FORM.statusID) AND NOT LEN(FORM.comments) ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('This is a final decision. Comments are required.');
				}			
				
				// Managers Must Assign an Area Representative
				if ( CLIENT.userType EQ 5 AND NOT VAL(FORM.areaRepID) ) {
					// Get all the missing items in a list
					SESSION.formErrors.Add('You must select an area representative');
				}
			
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Do Not Display Form
				displayForm = 0;
				
				// Update / Add History Host Lead
				APPLICATION.CFC.HOST.updateHostLead(
					ID=FORM.ID,					
					followUpID=FORM.areaRepID,
					regionID=FORM.regionID,
					areaRepID=FORM.areaRepID,
					statusID=FORM.statusID,
					enteredByID=CLIENT.userID,
					comments=FORM.comments					
				);
				
				
						
				// Get the latest updates
				qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=URL.ID);

				// Get History
				qGetHostLeadHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
					applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
					foreignTable='smg_host_lead',
					foreignID=qGetHostLead.ID
				);

				// Set Page Message
				SESSION.pageMessages.Add("Changes have been saved.");
				
				// Refresh Page
				// Location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no"); 

			}
			
		} else {			
			// Set FORM Values
			FORM.followUpID = qGetHostLead.followUpID;
			FORM.companyID = qGetHostLead.companyID;
			FORM.regionID = qGetHostLead.regionID;
			FORM.areaRepID = qGetHostLead.areaRepID;
			FORM.statusID = qGetHostLead.statusID;
			// FORM.comments = qGetHostLead.comments;
		}
	</cfscript>
    
    <cfquery name="checkHostAppExist" datasource="#application.dsn#">
    select *
    from smg_hosts
    where email =<cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.email#">
	</cfquery>

</cfsilent>

<cfoutput>

<Cfif val(qGetHostLead.hostid)>
    <cfquery name=qGetHostInfo datasource="#application.dsn#">
    select applicationSent
	from smg_hosts
	where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.hostid#">
    </cfquery>
</Cfif>







		<script language="javascript">
            // Display Final Decision Warning
			var displayFinalDecision = function() { 
                // Get Status Value
				vGetSelectedStatus = $("##statusID").val();
                // 3 - Not Interested
				// 8 - Committed to Host
				if ( vGetSelectedStatus == 3 || vGetSelectedStatus == 8 ) {
					$("##pFinalDecision").fadeIn();	
				} else {
					$("##pFinalDecision").fadeOut();	
				}				
            }
			
			var confirmStatus = function() { 
                // Get Status Value
				vGetSelectedStatus = $("##statusID").val();
			    
				if ( vGetSelectedStatus == 3 || vGetSelectedStatus == 8 ) {
					
					if( confirm("This lead will be removed from your active list. Would you like to continue?") ) { 
						return true; 
					} else { 
						return false; 
					} 
					
				} else {
					return true; 
				}
			}
			
			// Display warning when page is ready
        $(document).ready(function() {
            displayFinalDecision();
        });
    	</script>
		<cfif isDefined('url.startApp')>
          <!--- Check for duplicate accounts --->
		<cfif isValid("email", qGetHostLead.email)>
        
        	<cfscript>
				
				qCheckEmail = APPLICATION.CFC.host.checkHostEmail(email=qGetHostLead.email,companyID=CLIENT.companyID);
				
                // Check for email address. 
                if ( qCheckEmail.recordCount ) {
                    //Get all the missing items in a list
                    SESSION.formErrors.Add("There is already an account using the same email address, please refer to host family ID ###qCheckEmail.hostID#");
                }
            </cfscript>

        </cfif>
        <cfif NOT SESSION.formErrors.length()>
		 <cfquery result="newRecord" datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                        smg_hosts 
                    (
                        uniqueID,
                        familyLastName, 
                        fatherLastName, 
                        fatherFirstName, 
                        address, 
                        address2, 
                        city, 
                        state, 
                        zip, 
                        phone, 
                        email, 
                        password,
                        companyID, 
                        regionid,
                        
                        
                            HostAppStatus,
                            applicationSent,
                            sourceCode,
                            sourceType,
                            fk_HostLeadID
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(qGetHostLead.lastname)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(qGetHostLead.lastName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(qGetHostLead.firstName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.zipCode#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.password#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetHostLead.hearAboutUs#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="Lead">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.id#">
                    )  
                </cfquery>
				<!----Insert Host ID into HostLead Table, so we know the app has been sent---->
                <Cfquery datasource="#APPLICATION.DSN#">
                update smg_host_lead
       				set hostid = #form.hostID#
                </Cfquery>
                <cfscript>
                    // Set new host company ID
                    FORM.hostID = newRecord.GENERATED_KEY;
					  // Email Host Family - Welcome Email
                    stSubmitApplication = APPLICATION.CFC.HOST.submitApplication(hostID=FORM.hostID,action="newApplication");
					
					// Set Page Message
					SESSION.pageMessages.Add("Host Application was started and an email sent to the host family.");
					
					// Update Host Status According to usertype approving/denying the application
					 APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=FORM.hostID);
                </cfscript>
                
                <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
            </cfif>
		</cfif>
        
        <cfif VAL(FORM.submitted) AND NOT SESSION.formErrors.length()>
        
			<script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
		
        </cfif>
      
      		<!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="95%"
            />
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="95%"
            />
      
      		<div class="">
				<div class="row">
					<!-- Begin Content -->
					<div class="col-md-12">
						<!-- Alert Tabs -->
						<div class="tab-v2 margin-bottom-40">
							 
						<div class="tag-box tag-box-v3">
						<!-- Heading v6 -->
						<div class="heading heading-v6"><h2>#qGetHostLead.statusAssigned#</h2></div>
							 <div class="row row-eq-height">
								<div class="col-md-4">
									<div class="bg-light"><!-- You can delete "bg-light" class. It is just to make background color -->
										<h4><i class="fa fa-home"></i>Potential Host Family</h4>
										<p>#qGetHostLead.firstname# #qGetHostLead.lastname#</p>
										<p>#qGetHostLead.address#</p>
										<p>#qGetHostLead.address2#</p>
										<p>#qGetHostLead.city# #qGetHostLead.state# #qGetHostLead.zipCode#</p>
										<p>#qGetHostLead.email#</p>
										<p>#qGetHostLead.phone#</p>
									</div>
								</div>
								<div class="col-md-4">
									<div class="bg-light"><!-- You can delete "bg-light" class. It is just to make background color -->
										<h4><i class="fa fa-gears"></i>Lead Information</h4>
							
										<p>Source: #qGetHostLead.hearAboutUs# #qGetHostLead.hearAboutUsDetail# </p>
										<p>Created: #DateFormat(qGetHostLead.dateCreated, 'mmmm d, yyyy')#</p>
										<p>Updated: #DateFormat(qGetHostLead.dateUpdated, 'mmmm d, yyyy')#</p>
										<p>Converted:
										<cfif isDate(#qGetHostLead.dateConverted#)>
										#DateFormat(qGetHostLead.dateConverted, 'mmmm d, yyyy')#
										<cfelse>
										Not yet! Don't give up!
									
										</cfif>
										</p>
										<p>Days to Convert: 
										<cfif isDate(#qGetHostLead.dateConverted#)>
										#dateDiff("d", qGetHostLead.dateCreated, qGetHostLead.dateConverted)# days
										</cfif>
									</p>	
										
									</div>
								</div>
								<div class="col-md-4">
									<div class="bg-light"><!-- You can delete "bg-light" class. It is just to make background color -->
										<h4><i class="fa fa-address-book"></i>#CLIENT.companyshort# Contacts</h4>
							
										<p>Program Manager: 
											<cfif LEN(qGetHostLead.companyShort)>
												#qGetHostLead.companyShort#
											<cfelse>
												N/A
											</cfif></p>
										 <p>Region:
											<cfif LEN(qGetHostLead.regionAssigned)>
											#qGetHostLead.regionAssigned#
											<cfelse>
												N/A
											</cfif>
										</p>
										 <p>First Contact Rep: 
											 <cfif LEN(qGetHostLead.contactWithRepName)>#qGetHostLead.contactWithRepName#<cfelse>Nobody</cfif></p>
										
										<p>Current Rep: 
											<cfif LEN(qGetHostLead.areaRepAssigned)>
											#qGetHostLead.areaRepAssigned#
											<cfelse>
												N/A
											</cfif></p>
										
										
										
									</div>
								</div>
							</div><!--/row-->
					
							
						</div>
						<!----Action to take---->
						
						<div class="tag-box tag-box-v3">
							<div class="heading heading-v6"><h2>Make an Update</h2></div>
							
								  <cfform name="hostLeadDetail" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="sky-form">
									<input type="hidden" name="submitted" value="1" />
									<input type="hidden" name="ID" value="#ID#" />
									<input type="hidden" name="KEY" value="#key#" />
									<fieldset>
									<cfif ListFind("1,2,3,4", CLIENT.userType)>
										
										<section class="col-md-6">
											<label class="label">Program Manager</label>
											<label class="select">
												<select name="companyID" id="companyID" >
												    <option value="0" <cfif NOT VAL(FORM.companyID)>selected="selected"</cfif> >Unassigned</option>
													<cfloop query="qGetCompanies">
														<option value="#qGetCompanies.companyID#" <cfif FORM.companyID EQ qGetCompanies.companyID>selected="selected"</cfif> >#qGetCompanies.companyshort#</option>
													</cfloop>
												</select>
												<i></i>
											</label>
										</section>
										<section class="col-md-6">
											<label class="label">Region</label>
											<label class="select">
												 <cfselect
													name="regionID" 
													id="regionID"
													class="xLargeField"
													value="regionID"
													display="regionInfo"
													selected="#FORM.regionID#" 
													bindonload="yes"
													bind="cfc:nsmg.extensions.components.region.getRegionRemote({companyID})" />
												<i></i>
											</label>
										</section>
										<Cfelse>
											
											  <input type="hidden" name="companyID" value="#FORM.companyID#" />
										</cfif>
									
										<cfif CLIENT.userType EQ 5>
										<input type="hidden" name="regionID" value="#FORM.regionID#" />
											<section>
												<label class="label">Area Representative</label>
												<label class="select">
													<cfselect
													name="areaRepID" 
													id="areaRepID"
													class="largeField"
													value="userID"
													display="userInformation"
													selected="#FORM.areaRepID#" 
													bindonload="yes"
													bind="cfc:nsmg.extensions.components.user.getUsersAssignedToRegion({regionID})" />
													<i></i>
												</label>
											</section>
										<Cfelse>
											 <input type="hidden" name="areaRepID" value="#FORM.areaRepID#" />
										</cfif>
										<section class="col-md-12">
											<label class="label">Status</label>
											<label class="select">
												<select name="statusID" id="statusID" >
												    <option value="0" <cfif FORM.statusID EQ 0>selected="selected"</cfif> >Please Select a Status</option>
													<cfloop query="qGetStatus">
													<Cfif qGetStatus.fieldID neq 14>
														<option value="#qGetStatus.fieldID#" <cfif FORM.statusID EQ qGetStatus.fieldID>selected="selected"</cfif> >#qGetStatus.name#</option>
													</cfif>
													</cfloop>
												</select>
												<i></i>
											</label>
										</section>
										<section class="col-md-12">
											<label class="label">Comments</label>
											<label class="textarea">
												<textarea rows="5" name="comments">#FORM.comments#</textarea>
											</label>
											
										</section>
										<Cfif FORM.statusID neq 14>
										
											<div class="row padding-top-5">
												
												<div class="col-md-12">
													<div align="center">
														<button type="submit" class="btn-u btn-u-lg  btn-u-orange center"><i class="fa fa-cloud-upload" aria-hidden="true"></i> Update</button>
													</div>
												
												</div> 
											
											</div>	
										</cfif>
									</fieldset>
								
								</cfform>
							
							</div>
							
						</div>
						<!-- End Heading v6 -->
						
						
					<div class="tag-box tag-box-v3">
							<div class="heading heading-v6"><h2>History</h2></div>
			<div class="row">
								<!-- Begin Content -->
				<div class="col-md-12">
					<ul class="timeline-v2">
					  <cfloop query="qGetHostLeadHistory">
						<li class="equal-height-columns">
							<div class="cbp_tmtime equal-height-column">
							 <span></span>
							 <span>#DateFormat(qGetHostLeadHistory.dateUpdated, 'mmm d, yyyy')# </span>
							</div>
							<i class="cbp_tmicon rounded-x hidden-xs"></i>
							<div class="cbp_tmlabel equal-height-column">
								<h4><cfoutput>#qGetHostLeadHistory.actions#</cfoutput></h4>
								<p><cfoutput>#qGetHostLeadHistory.comments#</cfoutput></p>
							</div>
						</li>
						</cfloop>
					</ul>
				</div>
				<!-- End Content -->

							
						</div>
						<!-- End Heading v6 -->
							</div>	
						
						
						
						
			
						
						
						</div>		
					</div>
				</div>		
			  </div>
		
      
      
      
      
      	
      


      


</cfoutput>
