<!--- ------------------------------------------------------------------------- ----
	
	File:		menu.cfm
	Author:		James Griffiths
	Date:		June 26, 2012
	Desc:		Menu for MPD Report Section
				
				#CGI.SCRIPT_NAME#?curdoc=tours/MPDReports/index?action=menu				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
</cfsilent>

<script type="text/javascript">	
	// Load Report
	var loadSelectedReport = function(action) {

		// Empty Report Load Section
		$("#loadReport").empty();
		
		// Hide All Menus
		$(".menuOption").fadeOut();

		// Load Report
		$("#loadReport").load("tours/MPDReports/index.cfm?action=" + action);
		
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


<!--- Student Management Menu --->
<table id="studentManagementMenu" class="reportMenuTable menuOption">
    <tr>
        <td>
            <ul class="mainList">
                <li onclick="loadSelectedReport('emailAddressesPerTrip');">Email Addresses Per Tour</li>
                <ul>
                    <li>Generate a list of student email addresses</li>
                    <li>Filter by: Tour</li>
				</ul>
            </ul>  
        </td>
        <td>
            <ul class="mainList">
                <li onclick="loadSelectedReport('permissionFormPerTour');">Permission Forms Per Tour</li>
                <ul>
                    <li>Generate a report of all permission forms</li>
                    <li>Filter by: Tour</li>
				</ul>
            </ul>  
        </td>
        <td class="right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('flightInformationPerTour');">Flight Information Per Tour</li>
                <ul>
                    <li>Generate a report all flight information</li>
                    <li>Filter by: Tour</li>
				</ul>
            </ul>  
        </td>
        </tr>
        <tr>
         <td class="right">
            <ul class="mainList">
                <li onclick="loadSelectedReport('paymentHistory');">Payment Information Per Tour</li>
                <ul>
                    <li>Generate a report with all payment transactions</li>
                    <li>Filter by: Tour</li>
				</ul>
            </ul>  
        </td>
	</tr>	
</table>    

<!--- Load Report Here --->
<table id="loadReportTable" class="reportMenuTable displayNone">
    <tr>
    	<td colspan="4" id="loadReport"></td>
    </tr>
</table>


<!--- Table Footer --->
<gui:tableFooter />

</cfoutput>