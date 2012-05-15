<!--- ------------------------------------------------------------------------- ----
	
	File:		menu.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Menu for new report section
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=menu
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
</cfsilent>

<script type="text/javascript">
	// Display/Hide Form Options
	var showSelectedMenuOption = function(reportMenu) {
		
		// Hide Report
		$("#loadReportTable").fadeOut();
		
		// Hide All Menus
		$(".reportMenuTable").fadeOut();		
		
		// Set Menu Button as Inactive
		$(".divButton").removeClass("reportButtonSelected");
		
		// Set Menu Button as Active
		$("#" + reportMenu + "Button").addClass("reportButtonSelected");
		
		// Show Selected Menu	
		$("#" + reportMenu).fadeIn();
		
	}
	
	// Load Report
	var loadSelectedReport = function(action) {

		// Empty Report Load Section
		$("#loadReport").empty();
		
		// Hide All Menus
		$(".menuOption").fadeOut();

		// Load Report
		$("#loadReport").load("report/index.cfm?action=" + action);
		
		// Display Report
		$("#loadReportTable").fadeIn();
		
	}
</script>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Menu"
/>


<table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
    <tr>
    	<td align="center">
            <a href="javascript:showSelectedMenuOption('studentManagementMenu');" title="Click for Student Management Reports">
            	<div id="studentManagementMenuButton" class="divButton reportButton">Student Management</div>
            </a>
            
            <a href="javascript:showSelectedMenuOption('hostFamilyManagementMenu');" title="Click for Host Family Management Reports">
            	<div id="hostFamilyManagementMenuButton" class="divButton reportButton">Host Family Management</div>
            </a>

            <a href="javascript:showSelectedMenuOption('representativeManagementMenu');" title="Click for Representative Management Reports">
            	<div id="representativeManagementMenuButton" class="divButton reportButton">Representative Management</div>
            </a>
			
            <!---
            <a href="javascript:showSelectedMenuOption('officeManagementMenu');" title="Click for Office Management Reports">
            	<div id="officeManagementMenuButton" class="divButton reportButton">Office Management</div>
            </a>
			--->
        </td>
	</tr>    
</table>


<!--- Student Management Menu --->
<table id="studentManagementMenu" class="reportMenuTable menuOption displayNone">
    <tr>
        <td>
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentByRegion');">Student By Region</li>
                <ul>
                    <li>Generate a list of all students in your region</li>
                    <li>Filter by: placed/unplaced, date placed, program</li>
				</ul>
            </ul>  
        </td>
        <td>
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentFlightInformation');">Flight Information</li>
                <ul>
                    <li>Generate a list of all students and their flight information</li>
                    <li>Filter by program, rep, missing/received, arrival/departure, date placed</li>
				</ul>
            </ul>  
        </td>
        <td class="right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentHelpCommunityService');">Help Communitiy Service</li>
                <ul>
                    <li>Generate a report of students and the amount of Help hours submitted/approved</li>
                    <li>Filter by: prorgam, activity status, ## of hours, student status</li>
				</ul>
            </ul>  
        </td>
	</tr>   
    
    <tr>
        <td>
			<!--- Report is not ready --->
            <!---
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentPlacementPaperworkByRegion');">Placement Paperwork by Region</li>
                <ul>
                    <li>Generate a list of all students in your region and paperwork HQ has not received</li>
                    <li>Filter by: Rep (place vs super), program, date placed</li>
				</ul>
            </ul>
			--->  
        </td>
        <td>
        	<!---
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentRelocationReport');">Relocation Report</li>
                <ul>
                    <li>Generate a list of all relocation in your region</li>
                    <li>Filter by: date relocated, reason, program</li>
				</ul>
            </ul>  
			--->
        </td>
        <td class="right">
        	<!---
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentDoublePlacementPaperworkByRegion');">Double Placement Paperwork By Region</li>
                <ul>
                    <li>Generate a list of all students in your region and double placement paperwork HQ has not received</li>
                    <li>Filter by: Rep (place vs super), program, date placed, missing/received/all, on screen/excel</li>
				</ul>
            </ul>  
			--->
        </td>
	</tr>  
    
    <!---
    <tr>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentProgressReports');">Progress Reports MISSING</li>
                <ul>
                    <li>Generate a report of missing/completed and approved/non progress reports</li>
                    <li>Filter by: program, month, missing/complete/all, approval status</li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentSecondVisitReport');">Second Visit Reports MISSING</li>
                <ul>
                    <li>Generate a list of 2nd visit reports with completion and compliance status</li>
                    <li>Filter by: program, date placed, approval and completion status</li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow right">
            
        </td>
	</tr> 
	--->
</table>    

    
<!--- Host Family Management Menu --->
<table id="hostFamilyManagementMenu" class="reportMenuTable menuOption displayNone">
    <tr>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('hostFamilyCBCAuthorization');">CBC Authorization</li>
                <ul>
                    <li>Generate a list of all HFs that are missing CBC authorization</li>
                    <li>Filter by: season, user type, missing/complete/all</li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('hostFamilySpreadsheet');">Host Family Spreadsheet</li>
                <ul>
                    <li>Generate a list of all HFs in your region</li>
                    <li>Filter by: state, active/inactive, currently hosting</li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('hostFamilyWelcomeByRegion');">Welcome Host Family</li>
                <ul>
                    <li>Generate a list of welcome families in your region</li>
                    <li>Filter by: program </li>
				</ul>
            </ul>  
        </td>
	</tr> 
</table>


<!--- Representative Management Menu --->
<table id="representativeManagementMenu" class="reportMenuTable menuOption displayNone">
    <tr>
        <td>
			<ul class="mainList">
                <li onclick="loadSelectedReport('userAreaRepPaperwork');">Missing Area Representative Paperwork</li>
                <ul>
                    <li>Generate a list of missing paperwork per representative</li>
                    <li>Filter by: season, active/inactive, enabled/disabled, missing/complete/all</li>
				</ul>
            </ul>  
        </td>
        <td>
            <ul class="mainList">
                <li onclick="loadSelectedReport('userComplianceMileageReport');">Mileage Report</li>
                <ul>
                    <li>Generate a list of students and the distance between their supervising rep and HF</li>
                    <li>Filter by: program, compliant/non-compliant </li>
				</ul>
            </ul>  
        </td>
        <td class="right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('userRegionalHierarchy');">Hierarchy Report</li>
                <ul>
                    <li>Generate a list of all representativea in your region</li>
                    <li>Filter by: date, name, city,state, etc</li>
				</ul>
            </ul>  
        </td>
	</tr>  
    <tr>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('userSecondVisitCompliance');">Second Visit Reports Completed</li>
                <ul>
                    <li>Generate a list of 2nd visit reports with completion and compliance status</li>
                    <li>Filter by: program, date placed, approval and completion status</li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('userPendingStudentMissingSecondVisitRep');">Second Visit Assigned</li>
                <ul>
                    <li>Generate a list of 2nd visit reps assigned by student</li>
                    <li>Filter by: program, compliant/non-compliant </li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('userTrainingListByRegion');">Trainings (DOS test + AR Webex trainings)</li>
                <ul>
                    <li>Generate a list of reps and the trainings they have completed</li>
                    <li>Filter by: program, training, missing/complete/all</li>
				</ul>
            </ul>  
        </td>
	</tr>   
</table> 


<!--- Office Management Menu --->
<table id="officeManagementMenu" class="reportMenuTable menuOption displayNone">
    <tr>
        <td>

        </td>
        <td>

        </td>
        <td>

        </td>
	</tr>   
</table> 


<!--- Load Report Here --->
<table id="loadReportTable" class="reportMenuTable displayNone">
    <tr>
    	<td colspan="3" id="loadReport">
        
        </td>
    </tr>
    
</table>


<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>