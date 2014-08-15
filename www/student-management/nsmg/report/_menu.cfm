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
	
	<cfscript>
		// rebuilt QueryString and remove sortBy and sortOrder
		vCurrentURL = CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING;
			
		// Clean Up Current Option
		if ( ListContainsNoCase(vCurrentURL, "includeInactivePrograms", "&") ) {
			vCurrentURL = ListDeleteAt(vCurrentURL, ListContainsNoCase(vCurrentURL, "includeInactivePrograms", "&"), "&");
		}

		// Build URL to display All/Active Programs
		if ( VAL(URL.includeInactivePrograms) ) {
			vSetAllProgramsLink = '<a href="#vCurrentURL#">[ Show Active Programs Only ]</a>';
		} else {		
			vSetAllProgramsLink = '<a href="#vCurrentURL#&includeInactivePrograms=1">[ Show All Programs ]</a>';
		}
	</cfscript>
    
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
		$("#loadReport").load("report/index.cfm?action=" + action + "&includeInactivePrograms=<cfoutput>#URL.includeInactivePrograms#</cfoutput>");
		
		// Display Report
		$("#loadReportTable").fadeIn();
		
	}
</script>

<cfoutput>

<!--- Table Header --->
<gui:tableHeader
	imageName="docs.gif"
	tableTitle="Reports - Menu"
    tableRightTitle="#vSetAllProgramsLink#"    
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
			
            <cfif APPLICATION.CFC.USER.isOfficeUser()>
                <a href="javascript:showSelectedMenuOption('officeManagementMenu');" title="Click for Office Management Reports">
                    <div id="officeManagementMenuButton" class="divButton reportButton">Office Management</div>
                </a>
            </cfif>
            
            <!--- The payment menu is only being used by ESI currently --->
            <cfif CLIENT.companyID EQ 14 OR APPLICATION.isServerLocal>
                <a href="javascript:showSelectedMenuOption('paymentManagementMenu');" title="Click for Payment Reports">
                    <div id="paymentManagementMenuButton" class="divButton reportButton">Payment Reports</div>
                </a>
            </cfif>
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
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentPlacementPaperworkByRegion');">Placement Paperwork by Region</li>
                <ul>
                    <li>Generate a list of all students in your region and paperwork HQ has not received</li>
                    <li>Filter by: Rep (place vs super), program, date placed</li>
				</ul>
            </ul>
        </td>
        <td>
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentDoublePlacementPaperworkByRegion');">Double Placement Paperwork By Region</li>
                <ul>
                    <li>Generate a list of all students in your region and double placement paperwork HQ has not received</li>
                    <li>Filter by: Rep (place vs super), program, region, date placed, missing/non-compliant/all, on screen/excel</li>
				</ul>
            </ul> 
        </td>
        <td class="right"> 
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentDoublePlacementPaperworkByIntlRep');">Double Placement Paperwork By Intl. Representative</li>
                <ul>
                    <li>Generate a list of all students per Intl. Representative and double placement paperwork HQ has not received</li>
                    <li>Filter by: Program, Region, missing/non-compliant/all, date placed, on screen/excel</li>
				</ul>
            </ul>
        </td>
	</tr>  	
    
    <tr>
        <td>
              <ul class="mainList">
                <li onclick="loadSelectedReport('studentCompliancePaperwork');">Compliance Placement Paperwork by Region</li>
                <ul>
                    <li>Generate a list of all students in your region and paperwork that is not compliant.</li>
                    <li>Filter by: Rep (place vs super), program, date placed</li>
				</ul>
            </ul>
        </td>
        <td>
        	<ul class="mainList">
                <li onclick="loadSelectedReport('studentSecondVisitRepCompliance');">2<sup>nd</sup> Visit Representative Compliance</li>
                <ul>
                    <li>Generate a list of 2<sup>nd</sup> visit reports with completion and compliance status</li>
                    <li>Filter by: program, date placed, approval and completion status</li>
				</ul>
            </ul>
        </td>
        <td class="right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('studentRelocation');">Relocation</li>
                <ul>
                    <li>Generate a list of all relocation in your region</li>
                    <li>Filter by: date relocated, reason, program</li>
				</ul>
            </ul> 
        </td>
	</tr> 
    <tr>
    	<td>
        	<ul class="mainList">
                <li onclick="loadSelectedReport('studentProgressReports');">Progress Reports</li>
                <ul>
                    <li>Generate a report of missing/approved/not approved progress reports</li>
                    <li>Filter by: program, region, month, and status (missing, approved, not approved)</li>
				</ul>
            </ul> 
         </td>
         <td>
         </td>
         <td class="right">
         </td>
    </tr>
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
                <li onclick="loadSelectedReport('hostFamilyWelcomeByRegion');">Welcome Host Family</li>
                <ul>
                    <li>Generate a list of welcome families in your region</li>
                    <li>Filter by: program </li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('hostFamilyList');">Host Family List</li>
                <ul>
                    <li>Generate a list of all HFs in your region</li>
                    <li>Filter by: state, active/inactive, currently hosting</li>
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
                <li onclick="loadSelectedReport('userRegionalHierarchy');">Regional Hierarchy Report</li>
                <ul>
                    <li>Generate a list of all representativea in your region</li>
                    <li>Filter by: date, name, city,state, etc</li>
				</ul>
            </ul>  
        </td>
        <td>
			<ul class="mainList">
                <li onclick="loadSelectedReport('userAreaRepPaperwork');">Missing Area Representative Paperwork</li>
                <ul>
                    <li>Generate a list of missing paperwork per representative</li>
                    <li>Filter by: season, active/inactive, enabled/disabled, missing/complete/all</li>
				</ul>
            </ul>  
        </td>
        <td class="right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('userComplianceMileageReport');">Compliance Mileage Report</li>
                <ul>
                    <li>Generate a list of students and the distance between their supervising rep and HF</li>
                    <li>Filter by: program, compliant/non-compliant </li>
				</ul>
            </ul>  
        </td>
	</tr>  
    <tr>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('userTrainingList');">User Training List</li>
                <ul>
                    <li>Generate a list of reps and the trainings they have completed</li>
                    <li>Filter by: program, training, missing/complete/all</li>
				</ul>
            </ul>
        </td>
        <td class="lastRow">&nbsp;
        	<!--- This report is only available for office users and managers --->
			<cfif CLIENT.userType LTE 5>
                <ul class="mainList">
                    <li onclick="loadSelectedReport('userIncentiveTripReport');">Incentive Trip Report</li>
                    <ul>
                        <li>Generate a list of guests for the incentive trips</li>
                        <li>Filter by: Season, trip</li>
                    </ul>
                </ul>
          	</cfif>
        </td>
        <td class="lastRow right">&nbsp;
        	
        </td>
	</tr>   
</table> 


<!--- Office Management Menu --->
<table id="officeManagementMenu" class="reportMenuTable menuOption displayNone">
    <tr>
        <td>
			<ul class="mainList">
                <li onclick="loadSelectedReport('officeRegionGoal');">Region Goal</li>
                <ul>
                    <li>Generate a report of allocations by company and region</li>
                    <li>Filter by: season, August/January goals, region</li>
				</ul>
            </ul>
        </td>
        <td>
			<ul class="mainList">
                <li onclick="loadSelectedReport('officeComplianceCheckPaperwork');">Compliance Check Placement Paperwork</li>
                <ul>
                    <li>Generate a list of all students in your region and paperwork compaliance has not checked</li>
                    <li>Filter by: Region</li>
				</ul>
            </ul>
        </td>
        <td class="right">
			<ul class="mainList">
                <li onclick="loadSelectedReport('officeDOSCertification');">DOS Certification</li>
                <ul>
                    <li>Generate a list of all users who have or have not taken the DOS Certification</li>
                    <li>Filter by: Region</li>
				</ul>
            </ul>
        </td>
	</tr>   
    <tr>
        <td>&nbsp;
			<ul class="mainList">
                <li onclick="loadSelectedReport('officeRegionGoalByProgram');">Region Goal by Program</li>
                <ul>
                    <li>Generate a report of allocations by company and region</li>
                    <li>Filter by: program, August/January goals, region</li>
				</ul>
            </ul>
        </td>
        <td>
        	<ul class="mainList">
          		<li onclick="loadSelectedReport('officeComplianceStateCountry');">Compliance Students per State / Country</li>
              	<ul>
                	<li>Breakdown of students per State &amp; Country</li>
                	<li>Filter by: Program</li>
              	</ul>
         	</ul>
     	</td>
        <td class="right">
			<ul class="mainList">
                <li onclick="loadSelectedReport('officeDOSRelocation');">DOS Relocation</li>
                <ul>
                    <li>Generate the Deparment of State Annual Change of Placement Report</li>
                    <li>Filter by: Program, Region</li>
				</ul>
            </ul>
        </td>
	</tr>
    <tr>
        <td class="lastRow">&nbsp;
            <ul class="mainList">
                <li onclick="loadSelectedReport('officeRecruitmentReport');">Recruitment Report</li>
                <ul>
                    <li>Generate a total by region of new area reps</li>
                    <li>Filter by: Region, Season</li>
                </ul>
            </ul>
        </td>
    </tr>
</table> 


<!--- Payment Management Menu --->
<table id="paymentManagementMenu" class="reportMenuTable menuOption displayNone">
    <tr>
        <td class="lastRow">
            <ul class="mainList">
                <li onclick="loadSelectedReport('esiPayments');">ESI Payments</li>
                <ul>
                    <li>Generate a list of all ESI payments</li>
                    <li>Filter by: season, program</li>
				</ul>
            </ul>  
        </td>
        <td class="lastRow right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('esiHostFamilyPayments');">ESI Host Family Payments</li>
                <ul>
                    <li>Generate a list of all ESI host family payments</li>
                    <li>Filter by: season, program</li>
				</ul>
            </ul>  
        </td>
	</tr> 
</table>


<!--- Load Report Here --->
<table id="loadReportTable" class="reportMenuTable displayNone">
    <tr>
    	<td colspan="3" id="loadReport"></td>
    </tr>
</table>


<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>