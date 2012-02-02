<!--- ------------------------------------------------------------------------- ----
	
	File:		_report.cfm
	Author:		Marcus Melo
	Date:		November 22, 2011
	Desc:		ISEUSA.com Host Family Leads Reports

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;	
		param name="FORM.followUpID" default=16843;	
		param name="FORM.regionID" default=0;	
		param name="FORM.statusID" default="";
		param name="FORM.dateFrom" default="";
		param name="FORM.dateTo" default="";
	
		// Follow Up User List
		qGetFollowUpUserList = APPLICATION.CFC.USER.getUsers(userType=26);
	
		// Get User Regions
		qGetRegions = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
		
		// Get List of Status
		qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(
			applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
			fieldKey='hostLeadStatus'
		);
	</cfscript>	
    
	<cfscript>
		// FORM Submitted
        if ( VAL(FORM.submitted) ) {
    
            // Date From
            if ( LEN(FORM.dateFrom) AND NOT IsDate(FORM.dateFrom) ) {
				FORM.dateFrom = '';
                // Set Page Message
                SESSION.formErrors.Add("Please enter a valid date from");
            }

            // Date To
            if ( LEN(FORM.dateTo) AND NOT IsDate(FORM.dateTo) ) {
				FORM.dateTo = '';
                // Set Page Message
                SESSION.formErrors.Add("Please enter a valid date to");
            }
            
            // No Errors Found 
            if ( NOT SESSION.formErrors.length() ) {
                
                // Get Report
                qGetHostLeadsReport = APPLICATION.CFC.HOST.getHostLeadFollowUpReport( 
                	followUpID=FORM.followUpID,
					regionID=FORM.regionID,
					statusID=FORM.statusID,
                    dateFrom=FORM.dateFrom,
					dateTo=FORM.dateTo
                );
            
            }
        
        }
    </cfscript>

</cfsilent>    

<cfoutput>

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false
		});		

	});
</script> 	

<!--- Display Form --->
<cfif NOT VAL(FORM.submitted) OR SESSION.formErrors.length()>

	<!--- Table Header --->
	<gui:tableHeader
		imageName="family.gif"
		tableTitle="Host Family Leads Report"
		tableRightTitle=""
	/>

	<!--- Page Messages --->
	<gui:displayPageMessages 
		pageMessages="#SESSION.pageMessages.GetCollection()#"
		messageType="tableSection"
		width="100%"
		/>

	<!--- Form Errors --->
	<gui:displayFormErrors 
		formErrors="#SESSION.formErrors.GetCollection()#"
		messageType="tableSection"
		width="100%"
		/>	

	<table border="0" cellpadding="8" cellspacing="2" width="100%" class="section">
		<tr>
			<td width="50%" valign="top">

				<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
					<input type="hidden" name="submitted" value="1" />
					
					<table class="nav_bar" cellpadding="6" cellspacing="0" width="100%">
						<tr><th colspan="2" bgcolor="##e2efc7">Host Lead Information</th></tr>
						<tr>
							<td>Follow Up Rep:</td>
							<td>
								<select name="followUpID" id="followUpID" class="largeField">
									<option value="0" <cfif NOT VAL(FORM.followUpID)>selected="selected"</cfif> ></option>
									<cfloop query="qGetFollowUpUserList">
										<option value="#qGetFollowUpUserList.userID#" <cfif FORM.followUpID EQ qGetFollowUpUserList.userID>selected="selected"</cfif> >#qGetFollowUpUserList.firstName# #qGetFollowUpUserList.lastName# (###qGetFollowUpUserList.userID#)</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>Region:</td>
							<td>
								<select name="regionID" id="regionID" class="mediumField">
									<cfif ListFind("1,2,3,4", CLIENT.userType)>
										<option value="0" <cfif NOT VAL(FORM.regionID)>selected="selected"</cfif> >All</option>
									</cfif>
									<cfloop query="qGetRegions">
										<option value="#qGetRegions.regionID#" <cfif FORM.regionID EQ qGetRegions.regionID>selected="selected"</cfif> >#qGetRegions.regionName#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>Status:</td>
							<td>
								<select name="statusID" id="statusID" class="largeField">
									<option value="" <cfif NOT LEN(FORM.statusID)>selected="selected"</cfif> >All</option>
									<cfloop query="qGetStatus">
										<option value="#qGetStatus.fieldID#" <cfif FORM.statusID EQ qGetStatus.fieldID>selected="selected"</cfif> >#qGetStatus.name#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr><td colspan="2">Including Period Below (Received Date)</td></tr>
						<tr>
							<td>From:</td>
							<td><input type="text" name="dateFrom" value="#DateFormat(FORM.dateFrom, 'mm/dd/yyyy')#" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
						</tr>
						<tr>
							<td>To: </td>
							<td><input type="text" name="dateTo" value="#DateFormat(FORM.dateTo, 'mm/dd/yyyy')#" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
						</tr>			
						<tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
					
				</form>
			
			</td>

			<td width="50%" valign="top">&nbsp;
				
			</td>
			
		</tr>
	</table>

	<!--- Table Footer --->
	<gui:tableFooter />

<!--- Run Report --->
<cfelse>

	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
		<tr>
			<th>Host Lead Follow Up Report</th>
		</tr>
		<cfif isDate(FORM.dateFrom) AND isDate(FORM.dateTo)>
			<tr>
				<th>Period from #DateFormat(FORM.dateFrom, 'mm/dd/yyyy')# to #DateFormat(FORM.dateTo, 'mm/dd/yyyy')#</th>
			</tr>
		</cfif>
	</table>

    <cfloop query="qGetHostLeadsReport">

        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left" width="20%">Family Name</th>
                <th class="left" width="5%">State</th>
                <th class="left" width="10%">Phone</th>
                <th class="left" width="15%">Email</th>
                <th class="left" width="10%">Submitted On</th>
                <th class="left" width="10%">Region</th>
                <th class="left" width="15%">Area Rep.</th>
                <th class="left" width="25%">Status</th>
            </tr>      

			<cfscript>
                // Get History
                qGetHostLeadHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
                    applicationID=APPLICATION.CONSTANTS.type.hostFamilyLead,
                    foreignTable='smg_host_lead',
                    foreignID=qGetHostLeadsReport.ID,
                    enteredByID=FORM.followUpID
                );
            </cfscript>
        
            <tr class="#iif(qGetHostLeadsReport.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                <td>
                    <a href="hostLeads/index.cfm?action=detail&id=#qGetHostLeadsReport.ID#&key=#qGetHostLeadsReport.hashID#" class="jQueryModal">
                        #qGetHostLeadsReport.firstName# #qGetHostLeadsReport.lastName# (###qGetHostLeadsReport.ID#)
                    </a>
                </td>
                <td>#qGetHostLeadsReport.state#</td>
                <td>#qGetHostLeadsReport.phone#</td>
                <td><a href="mailto:#qGetHostLeadsReport.email#">#qGetHostLeadsReport.email#</a></td>
                <td>#DateFormat(qGetHostLeadsReport.dateCreated, 'mm/dd/yyyy')#</td>
                <td>#qGetHostLeadsReport.regionAssigned#</td>
                <td>#qGetHostLeadsReport.areaRepAssigned#</td>
                <td>#qGetHostLeadsReport.statusAssigned#</td>
            </tr>
            <tr>
                <td colspan="9">
                    
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr>
                            <td class="subTitleLeft" width="25%">Date</td>
                            <td class="subTitleLeft" width="25%">Actions</td>
                            <td class="subTitleLeft" width="50%">Comments</td>
                        </tr>
                        <cfif qGetHostLeadHistory.recordCount>
                            <cfloop query="qGetHostLeadHistory">
                                <tr class="#iif(qGetHostLeadHistory.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                                    <td>#DateFormat(qGetHostLeadHistory.dateUpdated, 'mm/dd/yy')# at #TimeFormat(qGetHostLeadHistory.dateUpdated, 'hh:mm tt')# EST</td>
                                    <td>#qGetHostLeadHistory.actions#</td>
                                    <td>#qGetHostLeadHistory.comments#</td>
                                </tr>
                            </cfloop>
                        <cfelse>
                            <tr>
                                <td colspan="2" align="center">no comments have been assigned</td>
                            </tr>            
                        </cfif>
                    </table>
                    
                </td>
            </tr>            

    	</table>

    </cfloop>

</cfif>
    
</cfoutput>


