<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentManagementMenu.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Student Management Report Options
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentManagementMenu
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		// Get Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
		
		// Get Facilitators
		qGetFacilitatorList = APPLICATION.CFC.USER.getFacilitators();

		// Get User Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
	</cfscript>
	
</cfsilent>

<script type="text/javascript">
	// Display/Hide Form Options
	var showReport = function(reportID) {
		
		// Hide Menu
		$(".reportMenu").fadeOut();
		
		// Show Report	
		$("#" + reportID).fadeIn();
		
	}
	
	// Display/Hide Form Options
	var showMenu = function(reportID) {
		
		// Hide Report
		$(".reportForm").fadeOut();
		
		// Show Menu
		$(".reportMenu").fadeIn();
		
	}
</script>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Student Management"
	tableRightTitle='<h2><a href="#CGI.SCRIPT_NAME#?curdoc=report/index" title="Click for Student Management Reports">[ Reports Menu ]</a></h2>'
/>

<!--- Reports Menu --->
<table class="reportSection">
    <tr class="reportMenu">
        <td>
            <input type="radio" name="reportSelection" id="radioStudentListByRegion" value="studentListByRegion" onclick="showReport('studentListByRegion');"/>                 
            <label for="radioStudentListByRegion">Student List By Region</label>
            <ul>
                <li>
                	Generate a list of all students in your region <br />
                    Filter by: placed/unplaced, date placed, program 
                </li>
            </ul>  
        </td>
        <td>
            <input type="radio" name="reportSelection" id="radioRelocationReport" value="relocationReport" onclick="showReport(this.value);"/>                 
            <label for="radioRelocationReport">Relocation Report</label>
            <ul>
                <li>
                    Generate a list of all relocation in your region <br />
                    Filter by: date relocated, reason, program <br />
                    This report will provide you with a detailed explanation of each reloctaion including: date relocated, rep assigned, HF name, date of relocation, reason for relocation
                </li>
            </ul>  
        </td>
        <td>
            <input type="radio" name="reportSelection" id="radioPlacementPaperworkByRegion" value="placementPaperworkByRegion" onclick="showReport(this.value);"/>                 
            <label for="radioPlacementPaperworkByRegion">Placement Paperwork by Region</label>
            <ul>
                <li>
                    Generate a list of all students in your region and paperwork HQ has not received <br />
					Filter by: Rep (place vs super), program, date placed <br />
                    This report will provide you with a list, by student, of any paperwork that has still not been received by your facilitator.  
                    This will include both current and previous placements
                </li>
            </ul>   
        </td>
	</tr>   
    
    <tr class="reportMenu">
        <td>
            <input type="radio" name="reportSelection" id="radioDoublePlacementPaperworkByRegion" value="doublePlacementPaperworkByRegion" onclick="showReport(this.value);"/>                 
            <label for="radioDoublePlacementPaperworkByRegion">Double Placement Paperwork By Region</label>
            <ul>
                <li>
                    Generate a list of all students in your region and double placement paperwork HQ has not received <br />
                    Filter by: Rep (place vs super), program, date placed, missing/received/all, on screen/excel <br />  
                    This report will provide you with a list, by rep and student, of all paperwork due. 
                    It will also note paperwork thatis compliant, non-compliant, and has still not been received by your facilitator
                </li>
            </ul>  
        </td>
        <td>
            <input type="radio" name="reportSelection" id="radioFlightinformation" value="flightInformation" onclick="showReport(this.value);"/>                 
            <label for="radioFlightinformation">Flight Information</label>
            <ul>
                <li>
                    Generate a list of all students and their flight information <br />
                    Filter by program, rep, missing/received, arrival/departure, date placed <br />
                    This report will provide you with a comprehensive list of students and their arrival/departure flight information. 
                    You can sort this by place or super rep so that a list of students' flight info can be sent to your reps. 
                    Missing flight info can also be generated so that you know who still needs to submit it.
                </li>
            </ul>  
        </td>
        <td>
            <input type="radio" name="reportSelection" id="radioHelpCommunityService" value="helpCommunityService" onclick="showReport(this.value);"/>                 
            <label for="radioHelpCommunityService">Help Communitiy Service</label>
            <ul>
                <li>
                    Generate a report of students and the amount of Help hours submitted/approved <br />
                    Filter by: prorgam, activity status, ## of hours, student status <br />
                    This report will offer you a list of student, by AR, and the amount of HELP hours they have completed. 
                    You can also generat a list of students that have not completed and hours so you know who still needs some motivation. You can export this into Excel.
                </li>
            </ul>   
        </td>
	</tr>  
    
    <tr class="reportMenu">
        <td>
            <input type="radio" name="reportSelection" id="radioProgressReports" value="progressReports" onclick="showReport(this.value);"/>                 
            <label for="radioProgressReports">Progress Reports</label>
            <ul>
                <li>
                    Generate a report of missing/completed and approved/non progress reports <br />
                    Filter by: program, month, missing/complete/all, approval status <br />
                    This report will provide you with a list of students, by super rep, and the status of each student's progress reports for a given month. 
                    You can easily see who has completed their reports and whether or not they have been approved.
                </li>
            </ul>   
        </td>
        <td>
            <input type="radio" name="reportSelection" id="radioSecondVisitReport" value="secondVisitReport" onclick="showReport(this.value);"/>                 
            <label for="radioSecondVisitReport">Second Visit Reports</label>
            <ul>
                <li>
					Generate a list of 2nd visit reports with completion and compliance status <br />
                    Filter by: program, date placed, approval and completion status <br />
                    This report will summarize all of the second visits required for your region by student. 
                    It will provide all of the information needed to determine which reports are completed and compliant vs non. 
                    (student,HF,date placed, date of arrival, window of compliance, due date, date of visit, days left)
                </li>
            </ul>  
        </td>
        <td>
            
        </td>
	</tr> 
    
    <!--- List Reports Below --->
    <tr>
    	<td colspan="3">
        
            <!--- Student List By Region --->
            <form action="report/index.cfm?action=studentListByRegion" name="studentListByRegion" id="studentListByRegion" method="post" class="displayNone reportForm" target="blank">
                
                <table width="40%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                    <tr><th colspan="2">Student List By Region</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                        <td>
                            <select name="programID" id="programIDStudentListByRegion" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionIDStudentListByRegion" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Student Status: <span class="required">*</span></td>
                        <td>
                            <select name="studentStatus" id="studentStatusStudentListByRegion" class="xLargeField" required>
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                                <option value="Canceled">Canceled</option>
                                <option value="All">All</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Placement Status: <span class="required">*</span></td>
                        <td>
                            <select name="placementStatus" id="placementStatusStudentListByRegion" class="xLargeField" onchange="showHidePlacementDates('StudentListByRegion');" required>
                                <option value="Placed">Placed</option>
                                <option value="Unplaced">Unplaced</option>
                                <option value="Pending">Pending</option>
                                <option value="All">All</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on trPlacementDateStudentListByRegion">
                        <td class="subTitleRightNoBorder">Placed From:</td>
                        <td><input type="text" name="dateFrom" id="dateFromStudentListByRegion" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                    </tr>
                    <tr class="on trPlacementDateStudentListByRegion">
                        <td class="subTitleRightNoBorder">Placed To: </td>
                        <td><input type="text" name="dateTo" id="dateToStudentListByRegion" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Report By: <span class="required">*</span></td>
                        <td>
                            <select name="reportByStudent" id="reportByStudentListByRegion" class="xLargeField">
                                <option value="placeRepID">Placing Representative</option>
                                <option value="areaRepID">Supervising Representative</option>
                            </select>
                        </td>		
                    </tr>                                    
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" id="outputTypeStudentListByRegion" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2" align="center">
                        	<input type="image" src="pics/view.gif" align="center" border="0">                        
                        	<input type="image" class="buttonBack" src="pics/back.gif" align="center" border="0" onclick="showMenu();">
                        </th>
                    </tr>
                </table>
            </form>
            
            
            <!--- Placement Paperwork By Region --->
            <form action="report/index.cfm?action=placementPaperworkByRegion" name="placementPaperworkByRegion" id="placementPaperworkByRegion" method="post" class="displayNone reportForm" target="blank">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                    <tr><th colspan="2">Placement Paperwork By Region</th></tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                        <td>
                            <select name="programID" id="programIDPlacementPaperworkByRegion" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
                            </select>
                        </td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                        <td>
                            <select name="regionID" id="regionIDPlacementPaperworkByRegion" class="xLargeField" multiple size="6" required>
                                <cfloop query="qGetRegionList"><option value="#qGetRegionList.regionID#">#qGetRegionList.regionname#</option></cfloop>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Student Status: <span class="required">*</span></td>
                        <td>
                            <select name="studentStatus" id="studentStatusPlacementPaperworkByRegion" class="xLargeField" required>
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                                <option value="Canceled">Canceled</option>
                                <option value="All">All</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Placement Status: <span class="required">*</span></td>
                        <td>
                            <select name="placementStatus" id="placementStatusPlacementPaperworkByRegion" class="xLargeField" onchange="showHidePlacementDates('PlacementPaperworkByRegion');" required>
                                <option value="Placed">Placed</option>
                                <option value="Pending">Pending</option>
                                <option value="All">Both</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on trPlacementDatePlacementPaperworkByRegion">
                        <td class="subTitleRightNoBorder">Placed From:</td>
                        <td><input type="text" name="dateFrom" id="dateFromPlacementPaperworkByRegion" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                    </tr>
                    <tr class="on trPlacementDatePlacementPaperworkByRegion">
                        <td class="subTitleRightNoBorder">Placed To: </td>
                        <td><input type="text" name="dateTo" id="dateToPlacementPaperworkByRegion" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Paperwork Option: <span class="required">*</span></td>
                        <td>
                            <select name="compliantOption" id="compliantOptionPlacementPaperworkByRegion" class="xLargeField">
                                <option value="">Comprehensive Report</option>
                                <option value="missing">Missing Paperwork</option>
                                <option value="non-compliant">Non-compliant Paperwork</option>                                                
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Facilitator: <span class="required">*</span></td>
                        <td>
                            <select name="facilitatorID" id="facilitatorIDPlacementPaperworkByRegion" class="xLargeField">
                                <option value="0">All</option>
                                <cfloop query="qGetFacilitatorList"><option value="#qGetFacilitatorList.userID#">#qGetFacilitatorList.firstName# #qGetFacilitatorList.lastName#</option></cfloop>
                            </select>
                        </td>		
                    </tr>   
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Report By: <span class="required">*</span></td>
                        <td>
                            <select name="reportBy" id="reportByPlacementPaperworkByRegion" class="xLargeField">
                                <option value="placeRepID">Placing Representative</option>
                                <option value="areaRepID">Supervising Representative</option>
                            </select>
                        </td>		
                    </tr>                                    
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                        <td>
                            <select name="outputType" id="outputTypePlacementPaperworkByRegion" class="xLargeField">
                                <option value="onScreen">On Screen</option>
                                <option value="Excel">Excel Spreadsheet</option>
                            </select>
                        </td>		
                    </tr>
                    <tr class="on">
                        <td class="subTitleRightNoBorder">Email Regional Manager: <span class="required">*</span></td>
                        <td>
                            <input type="radio" name="sendEmail" id="sendEmailPlacementPaperworkByRegionNo" value="0" checked="checked"> <label for="sendEmailPlacementPaperworkByRegionNo">No</label>  
                            <input type="radio" name="sendEmail" id="sendEmailPlacementPaperworkByRegionYes" value="1"> <label for="sendEmailPlacementPaperworkByRegionYes">Yes</label>
                            <br /><font size="-2">Available only on screen option</font>
                        </td>
                    </tr>
                    <tr class="on">
                        <td>&nbsp;</td>
                        <td class="required noteAlert">* Required Fields</td>
                    </tr>
                    <tr>
                        <th colspan="2" align="center">
                        	<input type="image" src="pics/view.gif" align="center" border="0">                        
                        	<input type="image" class="buttonBack" src="pics/back.gif" align="center" border="0" onclick="showMenu();">
                        </th>
                    </tr>
                </table>
            </form>            
        
        </td>
	</tr>        
</table>  

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>