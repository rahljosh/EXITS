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
		param name="form.hostid" default=0;
		/* 
			Check to see if passed key is the correct hash for the record. 
			This will stop people from tampering with the URLs.
		*/
		if ( Compare(APPLICATION.CFC.UDF.HashID(URL.id), URL.key) ) {
			// Wrong Key - Display message to user
			familyFound=0;
			SESSION.formErrors.Add('Host Family Lead could not be found (hashID mismatch). Please try again.');
		} 

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
				if ( NOT VAL(FORM.regionID) AND qGetHostLeadHistory.recordCount GT 3 ) {
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
					followUpID=FORM.followUpID,
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
				SESSION.pageMessages.Add("Form successfully submitted.");
				
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
    
</cfsilent>

<cfoutput>

<Cfif val(qGetHostLead.hostid)>
    <cfquery name=qGetHostInfo datasource="#application.dsn#">
    select applicationSent
	from smg_hosts
	where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostLead.hostid#">
    </cfquery>
</Cfif>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<script language="javascript">
            // Display warning when page is ready
            $(document).ready(function() {
                displayFinalDecision();
            });
           
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
                            HostLeadID
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
					SESSION.pageMessages.Add("Host App Email Sent.");
					
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
        
        <!--- Table Header --->
        <gui:tableHeader
            imageName="current_items.gif"
            tableTitle="Host Family Lead Information"
            width="95%"
            imagePath="../"
        />    
		
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
            
		<cfif familyFound>	
			
            <cfform name="hostLeadDetail" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="defaultForm" onsubmit="return confirmStatus();">
                <input type="hidden" name="submitted" value="1" />
                <input type="hidden" name="ID" value="#ID#" />
                <input type="hidden" name="KEY" value="#key#" />
                
                <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                    <tr class="projectHelpTitle">
                        <th colspan="2">Family Information</th>
                    </tr>
                    <tr>
                        
                        <!--- Left Column --->
                        <td width="50%" valign="top">
                        
                            <table width="100%" border="0" cellpadding="4" cellspacing="0" align="center">
                                <tr>
                                    <th width="170px" align="right" style="padding-top:10px;">Name:</th>
                                    <td style="padding-top:10px;">#qGetHostLead.firstName# #qGetHostLead.lastName#</td>
                                </tr> 
                                <tr>
                                    <th align="right" valign="top" rowspan="2">Address:</th>
                                    <td>
                                        #qGetHostLead.address# <br />
                                        <cfif LEN(qGetHostLead.address2)>
                                            #qGetHostLead.address2# <br />
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        #qGetHostLead.city#, #qGetHostLead.state# #qGetHostLead.zipCode# <br />
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">Phone:</th>
                                    <td>#qGetHostLead.phone#</td>
                                </tr>
                                <tr>
                                    <th align="right" style="padding-bottom:5px;">Date Submitted:</th>
                                    <td style="padding-bottom:5px;">#DateFormat(qGetHostLead.dateCreated, 'mm/dd/yyyy')# #TimeFormat(qGetHostLead.dateCreated, 'hh:mm:tt')# EST</td>
                                </tr>
                                
                              
                                <tr>
                                    <th align="right" style="padding-bottom:5px;">Application:</th>
                                    <td style="padding-bottom:5px;">
                                  
                                    <cfif not val(#qGetHostLead.companyID#)>
                                    	Assign Company before sending
                                    <cfelseif val(#qGetHostLead.hostid#)>
                                  
                                   	 #DateFormat(qGetHostInfo.applicationSent, 'mm/dd/yyyy')# @ #TimeFormat(qGetHostInfo.applicationSent, 'h:mm')#
                                    <cfelse>
                                    <a href="_detail.cfm?#CGI.QUERY_STRING#&startApp">Send Host App</a></td>
                                	</cfif>
                                </tr>
                              
                            </table>   
                                
                        </td>
                                            
                        <!--- Right Column --->
                        <td width="50%" valign="top">
                        
                            <table width="100%" border="0" cellpadding="4" cellspacing="0" align="center">
                                <tr>
                                    <th width="170px" align="right" style="padding-top:10px;">Email:</th>
                                    <td><a href="mailto:#qGetHostLead.email#" style="padding-top:10px;">#qGetHostLead.email#</a></td>
                                </tr>
                                <tr>
                                    <th align="right">Password:</th>
                                    <td>
                                    	<cfif ListFind("1,2,3,4", CLIENT.userType)>
                                        	#qGetHostLead.password#
                                    	<cfelse>
                                        	******
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right" valign="top">How did you hear about us :</th>
                                    <td>
                                        #qGetHostLead.hearAboutUs#
                                        <cfif LEN(qGetHostLead.hearAboutUsDetail)>
                                            &nbsp; - &nbsp; #qGetHostLead.hearAboutUsDetail#
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right" valign="top">Have been talking with:</th>
                                    <td>
                                        
                                        <cfif LEN(qGetHostLead.contactWithRepName)>
                                           #qGetHostLead.contactWithRepName#
                                        <cfelse>
                                        Nobody
                                        </cfif>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <th align="right" style="padding-bottom:5px;">Last Updated:</th>
                                    <td style="padding-bottom:5px;">#DateFormat(qGetHostLead.dateUpdated, 'mm/dd/yyyy')# #TimeFormat(qGetHostLead.dateUpdated, 'hh:mm:tt')# EST</td>
                                </tr>
                                <tr>
                                    <th align="right" style="padding-bottom:5px;">Last Login:</th>
                                    <td style="padding-bottom:5px;">#DateFormat(qGetHostLead.dateLastLoggedIn, 'mm/dd/yyyy')# #TimeFormat(qGetHostLead.dateLastLoggedIn, 'hh:mm:tt')# EST</td>
                                </tr>
                                <cfif val(#qGetHostLead.hostID#)>
                                <tr>
                                    <th align="right">Host ID:</th>
                                    <td><a href="../index.cfm?curdoc=host_fam_info&amp;hostid=#qGetHostLead.hostID#" target="_top">#qGetHostLead.hostID#</a></td>
                                </tr>
                                </cfif>
                            </table>    
                                                    
                        </td>
                    </tr>
                </table>
            
				<!--- Only Display Form on Edit Mode --->
                <cfif displayForm>
                
                    <!--- Follow Up --->
                    <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">                    
                        <tr class="projectHelpTitle">
                            <th colspan="2">Follow Up Information</th>
                        </tr>

                        <tr>
                            <th width="45%" align="right" valign="top" style="padding-top:10px;"><label for="companyID">Follow Up Representative:</label></th>
                            <td width="55%" style="padding-top:10px;">
								<!--- Only Office Can Assign a Follow Up UserID --->
                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                    <select name="followUpID" id="followUpID" class="largeField">
                                        <option value="0" <cfif NOT VAL(FORM.followUpID)>selected="selected"</cfif> >Unassigned</option>
                                        <cfloop query="qGetFollowUpUserList">
                                            <option value="#qGetFollowUpUserList.userID#" <cfif FORM.followUpID EQ qGetFollowUpUserList.userID>selected="selected"</cfif> >#qGetFollowUpUserList.firstName# #qGetFollowUpUserList.lastName# (###qGetFollowUpUserList.userID#)</option>
                                        </cfloop>
                                    </select>
                                <cfelse>
                                    <input type="hidden" name="followUpID" value="#FORM.followUpID#" />
                                    #qGetHostLead.followUpAssigned#
                                </cfif>
                            </td>
                        </tr>

                        <tr>
                            <th align="right" valign="top" style="padding-top:10px;"><label for="companyID">Company:</label></th>
                            <td style="padding-top:10px;">
                                <!--- Only Office Can Assign a Company --->
                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                    <select name="companyID" id="companyID" class="mediumField">
                                        <option value="0" <cfif NOT VAL(FORM.companyID)>selected="selected"</cfif> >Unassigned</option>
                                        <cfloop query="qGetCompanies">
                                            <option value="#qGetCompanies.companyID#" <cfif FORM.companyID EQ qGetCompanies.companyID>selected="selected"</cfif> >#qGetCompanies.companyshort#</option>
                                        </cfloop>
                                    </select>
                                <cfelse>
                                    <input type="hidden" name="companyID" value="#FORM.companyID#" />
                                    <cfif LEN(qGetHostLead.companyShort)>
                                    	#qGetHostLead.companyShort#
                                    <cfelse>
                                    	n/a
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <th align="right" valign="top" style="padding-top:10px;"><label for="regionID">Region:</label></th>
                            <td style="padding-top:10px;">
                                <!--- Only Office Can Assign a Region --->
                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                   <cfselect
                                        name="regionID" 
                                        id="regionID"
                                        class="xLargeField"
                                        value="regionID"
                                        display="regionInfo"
                                        selected="#FORM.regionID#" 
                                        bindonload="yes"
                                        bind="cfc:nsmg.extensions.components.region.getRegionRemote({companyID})" />
                                    <p class="formNote">Assign a region to give it's manager access to this lead</p>
                                <cfelse>
                                    <input type="hidden" name="regionID" value="#FORM.regionID#" />
                                    <cfif LEN(qGetHostLead.regionAssigned)>
                                    	#qGetHostLead.regionAssigned#
                                    <cfelse>
                                    	n/a
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <th align="right" valign="top"><label for="areaRepID">Area Representative:</label></th>
                            <td>
                                <!--- Only Managers can assign an Area Rep. --->
                                <cfif CLIENT.userType EQ 5>
                                   <cfselect
                                        name="areaRepID" 
                                        id="areaRepID"
                                        class="largeField"
                                        value="userID"
                                        display="userInformation"
                                        selected="#FORM.areaRepID#" 
                                        bindonload="yes"
                                        bind="cfc:nsmg.extensions.components.user.getUsersAssignedToRegion({regionID})" />
                                    <p class="formNote">Assign an area representative that will have instant access to this lead</p>
                                <cfelse>
                                    <input type="hidden" name="areaRepID" value="#FORM.areaRepID#" />
                                    #qGetHostLead.areaRepAssigned#
                                    <p class="formNote">Will be assigned by the region manager.</p>
                                </cfif>                            
                            </td>
                        </tr>
                        <tr>
                            <th align="right" valign="top"><label for="statusID">Status:</label></th>
                            <td>
                                <cfif CLIENT.userType NEQ 26>
                                    
                                    <select name="statusID" id="statusID" class="xLargeField" onchange="displayFinalDecision();">
                                        <option value="0" <cfif FORM.statusID EQ 0>selected="selected"</cfif> >Please Select a Status</option>
                                        <cfloop query="qGetStatus">
                                            <option value="#qGetStatus.fieldID#" <cfif FORM.statusID EQ qGetStatus.fieldID>selected="selected"</cfif> >#qGetStatus.name#</option>
                                        </cfloop>
                                    </select>
                                    
                                    <p id="pFinalDecision" class="formWarning displayNone">
                                        PS: This is a final decision, this lead will be removed from your active list. 
                                        <br />
                                        You can still find it under your host lead list by filtering by current status.
                                    </p>
                                
                                <cfelse>
                                    <input type="hidden" name="statusID" value="#FORM.statusID#" />
                                    #qGetHostLead.statusAssigned#
                                </cfif>
                            </td>
                        </tr>

                        <tr>
                            <th align="right" valign="top">Comments:</th>
                            <td>
                                <textarea name="comments" class="xLargeTextArea">#FORM.comments#</textarea>
                            </td>
                        </tr>                
                    </table>
        
                    <!--- Form Buttons --->            
                    <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
                        <tr>
                            <td align="center"><input name="Submit" type="image" src="../student_app/pics/save.gif" border="0" alt="Submit"/></td>
                        </tr>                
                    </table>    
            
                </cfif>
    
			</cfform>

			<!--- History --->
            <table width="95%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">                            				
                <tr class="projectHelpTitle">
                    <th colspan="4">Record History</th>
                </tr>
                <tr>
                    <td class="columnTitle">Date</td>
                    <td class="columnTitle">Actions</td>
                    <td class="columnTitle">Comments</td>
                </tr>
                <cfloop query="qGetHostLeadHistory">
                    <tr bgcolor="###iif(qGetHostLeadHistory.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                        <td valign="top" width="20%">#DateFormat(qGetHostLeadHistory.dateUpdated, 'mm/dd/yy')# at #TimeFormat(qGetHostLeadHistory.dateUpdated, 'hh:mm tt')# EST</td>
                        <td valign="top" width="30%">#qGetHostLeadHistory.actions#</td>
                        <td valign="top" width="50%">#qGetHostLeadHistory.comments#</td>
                    </tr>
                </cfloop>
            </table>   

		</cfif>
            
        <!--- Table Footer --->
        <gui:tableFooter 
  	        width="95%"
			imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfoutput>
