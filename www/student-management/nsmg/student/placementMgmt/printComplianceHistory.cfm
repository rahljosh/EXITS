<!--- ------------------------------------------------------------------------- ----
	
	File:		_printcomplianceHistory.cfm
	Author:		Marcus Melo
	Date:		June 28, 2012
	Desc:		Prints Compliance Notes

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	

    <!--- PARAM URL Variables --->
    <cfparam name="URL.uniqueID" default="" />
    <cfparam name="URL.historyID" default="" />
    
	<cfscript>
		// Get Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(uniqueID=URL.uniqueID);

		// Get Region Assigned
		qGetRegionAssigned = APPLICATION.CFC.REGION.getRegions(qGetStudentInfo.regionAssigned);

		// Get Placement History List
		qGetPlacementHistoryList = APPLICATION.CFC.STUDENT.getPlacementHistory(studentID=qGetStudentInfo.studentID);

		// Get Placement History By ID - First record of qGetPlacementHistoryList is the current record
		if ( VAL(URL.historyID) ) {
			// Get Previous History from URL
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=URL.historyID);
		} else if ( VAL(qGetPlacementHistoryList.isActive) ) {
			// Get Current History
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=qGetPlacementHistoryList.historyID);
		} else {
			// Student is unplaced 
			qGetPlacementHistoryByID = APPLICATION.CFC.STUDENT.getHostHistoryByID(studentID=qGetStudentInfo.studentID, historyID=0);
		};

		// Get Host Family Information
		qGetHostInfo = APPLICATION.CFC.HOST.getHosts(hostID=qGetPlacementHistoryByID.hostID);

		// Get Compliance Log
		qGetComplianceHistory = APPLICATION.CFC.LOOKUPTABLES.getApplicationHistory(
			applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,																				   
			foreignTable="smg_hosthistorycompliance",
			foreignID=qGetPlacementHistoryByID.historyID,
			isResolved=0
		);
	</cfscript>	
        
</cfsilent>

<cfoutput>
	
    <cfdocument format="flashPaper" orientation="portrait" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
	
		<!--- Page Header --->
        <gui:pageHeader
            headerType="applicationNoHeader"
            filePath="../../"
        />	
    
            <table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th colspan="4">Compliance History</th>
                </tr>   
			</table>
            
			<table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">                       
                <tr class="on">
                    <td class="subTitleLeft" width="50%">Student: #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)</td>
                    <td class="subTitleLeft" width="50%">
						Host Family: #qGetHostInfo.familyLastName# (###qGetHostInfo.hostID#)
						<cfif VAL(qGetPlacementHistoryByID.isActive)>
							- Current Placement
						<cfelse>
							- Previous Placement
						</cfif>
					</td>
                </tr>  
                <tr class="off">
                    <td class="subTitleLeft" width="50%">Region: #qGetRegionAssigned.regionName# (###qGetRegionAssigned.regionID#)</td>
                    <td class="subTitleLeft" width="50%">Facilitator: #qGetRegionAssigned.facilitatorName#</td>
                </tr>  
            </table>

            <table width="100%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr class="on">
                    <td class="subTitleLeft" width="20%">Date</td>
                    <td class="subTitleLeft" width="50%">Comments</td>
                    <td class="subTitleLeft" width="20%">Entered By</td>
                    <td class="subTitleLeft" width="10%">Resolved?</td>
                </tr>  
                <cfloop query="qGetComplianceHistory">                    
                    <tr class="#iif(qGetComplianceHistory.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>#DateFormat(qGetComplianceHistory.dateCreated, 'mm/dd/yy')# at #TimeFormat(qGetComplianceHistory.dateCreated, 'hh:mm tt')# EST</td>
                        <td>#qGetComplianceHistory.actions#</td>
                        <td>#qGetComplianceHistory.enteredBy#</td>
                        <td>#YesNoFormat(qGetComplianceHistory.isResolved)#</td>
                    </tr>
                    <tr class="#iif(qGetComplianceHistory.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td  class="subTitleLeft" colspan="5" style="height:150px;" valign="top">Solution:</td>
                    </tr>
                </cfloop> 
            </table>

            <cfdocumentitem type="footer">  

				<!--- Page Header --->
                <gui:pageHeader
                    headerType="applicationNoHeader"
                    filePath="../../"
                />	

				<!--- Page Footer --->
                <gui:pageFooter
                    footerType="printDocumentItem"
                    filePath="../../"
                    width="100%"
                />
			
            </cfdocumentitem>  
        
    </cfdocument>
    
</cfoutput>    