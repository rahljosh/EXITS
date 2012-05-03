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
	// Document Ready
	$(document).ready(function() {
		showHidePlacementDates('StudentListByRegion');
		showHidePlacementDates('PlacementPaperworkByRegion');
	});	

	// Display/Hide Form Options
	var showHidePlacementDates = function(reportName) {
		
		// Get Placement Status
		var vPlacementStatus = $("#placementStatus" + reportName).val();
		
		// Erase data
		$("#dateTo" + reportName).val("");
		$("#dateFrom" + reportName).val("");

		if ( vPlacementStatus == 'Placed' ) {
			// Show Fields
			$(".trPlacementDate" + reportName).slideDown();
		} else {
			// Hide Fields
			$(".trPlacementDate" + reportName).slideUp();
		}

	}
</script>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Student Management"
	tableRightTitle='<h2><a href="#CGI.SCRIPT_NAME#?curdoc=report/index" title="Click for Student Management Reports">[ Reports Menu ]</a></h2>'
/>

<table class="reportSection">
    <tr>
        <td>
			
            <h1>Select your report below:</h1>
            
            <!--- Report Options --->
            <ul class="mainList">
            	
                <li><a href="javascript:displayDiv('studentListByRegion');">Student List By Region</a></li> 

                <ul class="childList">
                    <li>Generate a list of all students in your region - Filter by: placed/unplaced, date placed and program</li>
                </ul>  
                                     
                <li><a href="javascript:displayDiv('placementPaperworkByRegion');">Placement Paperwork by Region</a></li>
                
                <ul class="childList">
                    <li>Generate a list of all relocation in your region - Filter by: Representative (place vs super), program, date placed </li>
                </ul>   
                
                <li><a href="">Double Placement Paperwork By Region</a></li>

                <ul class="childList">
                    <li>Generate a list of all students in your region - Filter by: placed/unplaced, date placed and program</li>
                </ul>   
                
                <li><a href="">Flight Information</a></li>

                <ul class="childList">
                    <li>Generate a list of all students in your region - Filter by: placed/unplaced, date placed and program</li>
                </ul>   
                
                <li><a href="">Help Communitiy Service</a></li>

                <ul class="childList">
                    <li>Generate a list of all students in your region - Filter by: placed/unplaced, date placed and program</li>
                </ul>   
                
                <li><a href="">Progress Reports</a></li>

                <ul class="childList">
                    <li>Generate a list of all students in your region - Filter by: placed/unplaced, date placed and program</li>
                </ul>   
                
                <li><a href="">Second Visit Reports</a></li>

                <ul class="childList">
                    <li>Generate a list of all students in your region - Filter by: placed/unplaced, date placed and program</li>
                </ul>   
			
            </ul>                
            
            <!--- Student List By Region --->
            <form action="report/index.cfm?action=studentListByRegion" name="studentListByRegion" id="studentListByRegion" method="post" target="blank" class="displayNone">
                
                <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
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
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>
            
            
            <!--- Placement Paperwork By Region --->
            <form action="report/index.cfm?action=placementPaperworkByRegion" name="placementPaperworkByRegion" id="placementPaperworkByRegion" method="post" target="blank" class="displayNone">
                
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
                        <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                    </tr>
                </table>
            </form>            

		</td>
    </tr>
</table>    

<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>