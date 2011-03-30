<!--- ------------------------------------------------------------------------- ----
	
	File:		_detail.cfm
	Author:		Marcus Melo
	Date:		December 11, 2009
	Desc:		ISEUSA.com Host Family Leads

	Updated:	02/01/2011 - Ability to assign a host lead to a region/area rep
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
		param name="FORM.companyID" default=0;
		param name="FORM.regionID" default=0;
		param name="FORM.areaRepID" default=0;
		param name="FORM.statusID" default=0;
		param name="FORM.comments" default='';
		param name="familyFound" default=1;
		param name="displayForm" default=1;
	
		/* 
			Check to see if passed key is the correct hash for the record. 
			This will stop people from tampering with the URLs.
		*/
		if ( Compare(APPLICATION.CFC.UDF.HashID(URL.id), URL.key) ) {
			// Wrong Key - Display message to user
			familyFound=0;
			SESSION.formErrors.Add('Host Family Lead could not be found. Please try again.');
		} 

		// Get the given host family lead record
		qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=URL.ID);
		
		// Get Companies
		qGetCompanies = APPLICATION.CFC.COMPANY.getCompanies(companyIDList=APPLICATION.SETTINGS.COMPANYLIST.ISE);
		
		// Get List of Status
		qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(
			applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
			fieldKey='hostLeadStatus'
		);
		
		// FORM SUBMITTED
		if ( FORM.submitted ) {
			
			// Data Validation
			if ( NOT VAL(FORM.regionID) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select a region');
			}			

			if ( NOT VAL(FORM.statusID) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select a status');
			}			
			
			// Managers Must Assign an Area Representative
			if ( CLIENT.userType EQ 5 AND NOT VAL(FORM.areaRepID) ) {
				// Get all the missing items in a list
				SESSION.formErrors.Add('You must select an area representative');
			}
			
			// Check if there are no errors
			if ( NOT SESSION.formErrors.length() ) {				
				
				// Do Not Display Form
				displayForm = 0;
				
				// Update / Add History Host Lead
				APPLICATION.CFC.HOST.updateHostLead(
					ID=FORM.ID,					
					regionID=FORM.regionID,
					areaRepID=FORM.areaRepID,
					statusID=FORM.statusID,
					enteredByID=CLIENT.userID,
					comments=FORM.comments					
				);
				
				// Get the latest updates
				qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=URL.ID);
				
				// Set Page Message
				SESSION.pageMessages.Add("Form successfully submitted.");

			}
			
		} else {			
			// Set FORM Values
			FORM.companyID = qGetHostLead.companyID;
			FORM.regionID = qGetHostLead.regionID;
			FORM.areaRepID = qGetHostLead.areaRepID;
			FORM.statusID = qGetHostLead.statusID;
			// FORM.comments = qGetHostLead.comments;
		}
		
		// Get History
		qGetHostLeadHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
			foreignTable='smg_host_lead',
			foreignID=qGetHostLead.ID
		);
	</cfscript>
    
</cfsilent>

<cfoutput>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
		
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

            <cfform name="hostLeadDetail" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="defaultForm">
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
                                    <td>#qGetHostLead.password#</td>
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
                                    <th align="right">Joined Mailing List:</th>
                                    <td>#YesNoFormat(qGetHostLead.isListSubscriber)#</td>
                                </tr>
                                <tr>
                                    <th align="right" style="padding-bottom:5px;">Last Updated:</th>
                                    <td style="padding-bottom:5px;">#DateFormat(qGetHostLead.dateUpdated, 'mm/dd/yyyy')# #TimeFormat(qGetHostLead.dateUpdated, 'hh:mm:tt')# EST</td>
                                </tr>
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
                            <th width="45%" align="right" valign="top" style="padding-top:10px;"><label for="regionID">Company:</label></th>
                            <td width="55%" style="padding-top:10px;">
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
                                    #qGetHostLead.companyShort#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <th width="45%" align="right" valign="top" style="padding-top:10px;"><label for="regionID">Region:</label></th>
                            <td width="55%" style="padding-top:10px;">
                                <!--- Only Office Can Assign a Region --->
                                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                                   <cfselect
                                        name="regionID" 
                                        id="regionID"
                                        class="largeField"
                                        value="regionID"
                                        display="regionName"
                                        selected="#FORM.regionID#" 
                                        bindonload="yes"
                                        bind="cfc:nsmg.extensions.components.region.getRegionRemote({companyID})" />
                                    <p class="formNote">Assign a region to give it's manager access to this lead</p>
                                <cfelse>
                                    <input type="hidden" name="regionID" value="#FORM.regionID#" />
                                    #qGetHostLead.regionAssigned#
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <th align="right" valign="top">Area Representative:</th>
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
                            <th align="right" valign="top">Status:</th>
                            <td>
                                <select name="statusID" id="statusID" class="largeField">
                                    <option value="0" <cfif FORM.statusID EQ 0>selected="selected"</cfif> >Please Select a Status</option>
                                    <cfloop query="qGetStatus">
                                        <option value="#qGetStatus.fieldID#" <cfif FORM.statusID EQ qGetStatus.fieldID>selected="selected"</cfif> >#qGetStatus.name#</option>
                                    </cfloop>
                                </select>
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
                        <td valign="top">#DateFormat(qGetHostLeadHistory.dateUpdated, 'mm/dd/yy')# at #TimeFormat(qGetHostLeadHistory.dateUpdated, 'hh:mm tt')# EST</td>
                        <td valign="top">#qGetHostLeadHistory.actions#</td>
                        <td valign="top">#qGetHostLeadHistory.comments#</td>
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
