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
		qGetStatus = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='hostLeadStatus');
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

	<table border="0" cellpadding="8" cellspacing="2" width="100%" class="section" >
		<tr>
			<td width="50%" valign="top">

				<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
					<input type="hidden" name="submitted" value="1" />
					
					<table  cellpadding="6" cellspacing="0" width="100%"  class="blueThemeReportTable">
						<tr><th colspan="2" bgcolor="##e2efc7">Host Lead Information</th></tr>
						<tr class="on">
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
						<tr class="on">
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
						<tr class="on">
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
						<tr class="on"><td colspan="2">Including Period Below (Received Date)</td></tr>
						<tr class="on">
							<td>From:</td>
							<td><input type="text" name="dateFrom" value="#DateFormat(FORM.dateFrom, 'mm/dd/yyyy')#" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
						</tr>
						<tr class="on">
							<td>To: </td>
							<td><input type="text" name="dateTo" value="#DateFormat(FORM.dateTo, 'mm/dd/yyyy')#" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
						</tr>			
						<tr><td colspan="2" align="center" bgcolor="##3b5998"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
					
				</form>
			
			</td>

			<td width="50%" valign="top">
            
            	<form action="index.cfm?curdoc=hostLeads/index&action=leadList" method="post">
					
					<table cellpadding="6" cellspacing="0" width="100%" class="blueThemeReportTable" >
						<tr class="on"><th colspan="2" bgcolor="##e2efc7">Host Lead List</th></tr>
						<tr class="on"><td colspan="2">Including Period Below (Received Date)</td></tr>
						<tr class="on">
							<td>From:</td>
							<td><input type="text" name="dateFrom" value="#DateFormat(FORM.dateFrom, 'mm/dd/yyyy')#" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
						</tr>
						<tr class="on">
							<td>To: </td>
							<td><input type="text" name="dateTo" value="#DateFormat(FORM.dateTo, 'mm/dd/yyyy')#" size="7" maxlength="10" class="datePicker"> mm-dd-yyyy</td>
						</tr>
                        <tr class="on">
                        	<td>Google Adwords Leads: </td>
                        	<td>
                            	<select name="adwords" id="adwords" class="smallField">
									<option value="">All</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
								</select>
                            </td>
                        </tr>
						<tr><td colspan="2" align="center" bgcolor="##3b5998"><input type="image" src="pics/view.gif" align="center" border=0></td></tr>
					</table>
					
				</form>
				
			</td>
			
		</tr>
        <tr>
        <td>
        <!----Host Lead Stats---->
          <cfsetting requesttimeout="9999">
    <Cfset defaultStartDate = '#DatePart('m',now())#/1/#DatePart('yyyy',now())#'>
    <cfset d=DaysInMonth(defaultStartDate)>
    <cfset defaultEndDate  = '#DatePart('m',now())#/#d#/#DatePart('yyyy',now())#'>

	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.studentStatus" default="All";
		param name="FORM.outputType" default="excel";

		// Set Report Title To Keep Consistency
		vReportTitle = "Host Lead Statistics";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		// Get User Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
	</cfscript>	
         <form action="hostLeads/index.cfm?action=officeHostLeads" name="officeHostLeads" id="officeHostLeads" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="100%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Time Frame&dagger;: <span class="required"></span></td>
                    <td>
                       From: <input type="text" name="fromDate" id="placedDateFrom" value="#defaultStartDate#" size="7" maxlength="10" class="datePicker">
                       &nbsp;&nbsp;
                To: <input type="datefield" name="toDate" size=15 value="#defaultEndDate#" size="7" maxlength="10" class="datePicker">
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Region&Dagger;: <span class="required"></span></td>
                    <td>
                        <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                           
                            <cfloop query="qGetRegionList">
                            	<option value="#qGetRegionList.regionID#" selected>
                                	<cfif CLIENT.companyID EQ 5>#qGetRegionList.companyShort# -</cfif>
                                    #qGetRegionList.regionname#
                                </option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <!---
                <tr class="on">
                    <td class="subTitleRightNoBorder">Student Status: <span class="required">*</span></td>
                    <td>
                        <select name="studentStatus" id="studentStatus" class="xLargeField" required>
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                            <option value="Canceled">Canceled</option>
                            <option value="All" selected="selected">All</option>
                        </select>
                    </td>		
                </tr>
				---->
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
							<option value="onScreen">On Screen</option>
                            
                        </select>
                    </td>		
                </tr>
                 <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required</td>
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">&dagger; Defaults to Current Month</td>
                </tr><tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">&Dagger; Defaults to All Regions</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>This report generates the statistics on host leads for a specified time frame and region (optional).</td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        </form>            

        
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
        
            <tr>
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


