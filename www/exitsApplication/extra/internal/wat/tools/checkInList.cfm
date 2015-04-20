<!--- ------------------------------------------------------------------------- ----
	
	File:		checkInList.cfm
	Author:		Marcus Melo
	Date:		June 28, 2011
	Desc:		Verification Report. This page allows users/intl reps to update 
				Check-In List

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="/extensions/customTags/gui/" prefix="gui" /> 

    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Get International Representatives List
		qIntlRep = APPLICATION.CFC.USER.getIntlRepAssignedToCandidate();	

		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>
    
	<cfquery name="qGetStateList" datasource="MySql">
        SELECT id, state, stateName
        FROM smg_states
      	ORDER BY stateName
    </cfquery>
    
</cfsilent>    

<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="extensions.components.candidate" jsclassname="candidate">

<script language="javascript">
	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	} 
	
	// Bring the list when the page is ready
	// $(document).ready(function() {
	// 	getVerificationList();
	// });

	// --- START OF VERIFICATION LIST --- //

	// Use an asynchronous call to get the candidate details. The function is called when the user selects a candidate. 
	var getVerificationList = function() { 

		// Create an instance of the proxy. 
		var c = new candidate();
		
		// Get Search Form Values
		var intlRep = $("#intlRep").val();
		var programID = $("#programID").val();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateVerificationList); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getVerificationList CFC function. 
		c.getCheckInToolStudentList(intlRep,programID);
	} 

	// Callback function to handle the results returned by the getVerificationList function and populate the table. 
	var populateVerificationList = function(verList) { 
		
		// Clear current result
		$("#verificationList").empty();
		
		// Create Table Header
		var tableHeader = '';		
		tableHeader += '<tr>';
        	tableHeader += '<td class="listTitle style2">ID</td>';
        	tableHeader += '<td class="listTitle style2">Last Name</td>';
			tableHeader += '<td class="listTitle style2">First Name</td>';
			tableHeader += '<td class="listTitle style2">Email</td>';
        	tableHeader += '<td class="listTitle style2">Gender</td>';
			tableHeader += '<td class="listTitle style2">Country</td>';
			tableHeader += '<td class="listTitle style2">DS 2019</td>';
		
			tableHeader += '<td class="listTitle style2">Intl. Rep.</td>';
			tableHeader += '<td class="listTitle style2" colspan="2">Employer</td>';
			tableHeader += '<td class="listTitle style2">Start Date</td>';
			tableHeader += '<td class="listTitle style2">Arrival</td>';
			tableHeader += '<td class="listTitle style2">U.S. Phone</td>';
			tableHeader += '<td class="listTitle style2">Address</td>';
			tableHeader += '<td class="listTitle style2">Address 2</td>';
			tableHeader += '<td class="listTitle style2">City</td>';
			tableHeader += '<td class="listTitle style2">State</td>';
			tableHeader += '<td class="listTitle style2">Zip</td>';
			tableHeader += '<td class="listTitle style2" align="center">Track</td>';
            tableHeader += '<td class="listTitle style2" align="center">Actions</td>';                                                          
		tableHeader += '</tr>';
		
		// Append Table Header to HTML
		$("#verificationList").append(tableHeader);
		
		if( verList.DATA.length == 0) {
			// No data returned, display message
			$("#verificationList").append("<tr><th colspan='10'>Your search did not return any results.</th></tr>");
		}
		
		// Loop over results and build the grid
		for(i=0;i<verList.DATA.length;i++) { 
			
			var uniqueID = verList.DATA[i][verList.COLUMNS.findIdx('UNIQUEID')];
			var candidateID = verList.DATA[i][verList.COLUMNS.findIdx('CANDIDATEID')];		
			var firstName = verList.DATA[i][verList.COLUMNS.findIdx('FIRSTNAME')];
			var lastName = verList.DATA[i][verList.COLUMNS.findIdx('LASTNAME')];
			var email = verList.DATA[i][verList.COLUMNS.findIdx('EMAIL')];
			var ds2019 = verList.DATA[i][verList.COLUMNS.findIdx('DS2019')];
			var sex = verList.DATA[i][verList.COLUMNS.findIdx('SEX')];
			var countryName = verList.DATA[i][verList.COLUMNS.findIdx('COUNTRYNAME')];
			var programName = verList.DATA[i][verList.COLUMNS.findIdx('PROGRAMNAME')];
			var businessName = verList.DATA[i][verList.COLUMNS.findIdx('BUSINESSNAME')];
			var startDate = verList.DATA[i][verList.COLUMNS.findIdx('STARTDATE')];
			var endDate = verList.DATA[i][verList.COLUMNS.findIdx('ENDDATE')];
			var hostCompanyName = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYNAME')];
			var hostCompanyAddress = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYADDRESS')];
			var hostCompanyCity = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYCITY')];
			var hostCompanyState = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYSTATE')];
			var hostCompanyZip = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYZIP')];
			var usPhone = verList.DATA[i][verList.COLUMNS.findIdx('US_PHONE')];
			var arrival_address = verList.DATA[i][verList.COLUMNS.findIdx('ARRIVAL_ADDRESS')];
			var arrival_address_2 = verList.DATA[i][verList.COLUMNS.findIdx('ARRIVAL_ADDRESS_2')];
			var arrival_city = verList.DATA[i][verList.COLUMNS.findIdx('ARRIVAL_CITY')];
			var arrival_state = verList.DATA[i][verList.COLUMNS.findIdx('ARRIVAL_STATE')];
			var arrival_zip = verList.DATA[i][verList.COLUMNS.findIdx('ARRIVAL_ZIP')];
			var recentTracking = verList.DATA[i][verList.COLUMNS.findIdx('COMMENT')];
			
			if (recentTracking == null) {
				recentTracking = "";
			}
			
			if (arrival_address == null) arrival_address = "";
			if (arrival_address_2 == null) arrival_address_2 = "";
			if (arrival_city == null) arrival_city = "";
			if (arrival_zip == null) arrival_zip = "";
			
			var arrivalDate = "n/a";
			var departDate = verList.DATA[i][verList.COLUMNS.findIdx('DEPARTDATE')];
			var isOvernightFlight = verList.DATA[i][verList.COLUMNS.findIdx('ISOVERNIGHTFLIGHT')];
			if (departDate != null) {
				var arrive;
				if (isOvernightFlight == 1) {
					arrive = new Date(departDate);
					arrive.setDate(arrive.getDate()+1);
				} else {
					var arrive = new Date(departDate);
				}
				var month = arrive.getMonth() + 1;
				arrivalDate = month.toString() + "/" + arrive.getDate().toString() + "/" + arrive.getFullYear().toString();
			}
			
			var warning = 1;
			var nonCompliant = 1;
			var now = new Date();
			var nowInMillis = now.getTime();
			var start = new Date(startDate);
			var startInMillis = start.getTime();
			var millisInDay = 86400000;
			// They are non compliant if the program began more than 10 days ago.
			if (nowInMillis - startInMillis < (30*millisInDay)) {
				nonCompliant = 0;
			}
			// They are in a warning state if the program began more than 5 days ago.
			if ((nowInMillis - startInMillis < (15*millisInDay))) {
				warning = 0;
			}
			// If they are non compliant then they should NOT be in a warning state.
			if (nonCompliant == 1) {
				warning = 0;	
			}
			
			var show = $("#reportType").val();
			if (show == 0 || (show == 1 && warning == 1) || (show == 2 && nonCompliant == 1)) {
				// Create Table Rows
				var tableBody = '';	
				if (i % 2 == 0) {
					tableBody += '<tr id="' + candidateID + '" class="rowOff">';
				} else {
					tableBody += '<tr id="' + candidateID + '" class="rowOn">';
				}
				tableBody += '<td class="style5"><a href="?curdoc=candidate/candidate_info&uniqueID=' + uniqueID + '" class="style4" target="_blank">#' + candidateID + '</a></td>';
				tableBody += '<td class="style5"><a href="?curdoc=candidate/candidate_info&uniqueID=' + uniqueID + '" class="style4" target="_blank">' + lastName + '</a></td>';
				tableBody += '<td class="style5"><a href="?curdoc=candidate/candidate_info&uniqueID=' + uniqueID + '" class="style4" target="_blank">' + firstName + '</a></td>';
				tableBody += '<td class="style5">' + email + '</td>';
				tableBody += '<td class="style5">' + sex + '</td>';
				tableBody += '<td class="style5">' + countryName + '</td>';
				tableBody += '<td class="style5">' + ds2019 + '</td>';
			
				tableBody += '<td class="style5">' + businessName + '</td>';
				
				tableBody += '<td class="style5" colspan=2>' + hostCompanyName + '<br>' + hostCompanyAddress + ' ' + hostCompanyCity + ' ' + hostCompanyState + ' ' + hostCompanyZip  +'</td>';
				tableBody += '<td class="style5">' + startDate + '</td>';
				tableBody += '<td class="style5">' + arrivalDate + '</td>';
				tableBody += '<td class="style5"><input type="text" size="12" id="usphone' + candidateID + '" value="' + usPhone + '" onclick="applyPhoneMask(this.id);" /></td>';
				tableBody += '<td class="style5"><input type="text" size="12" id="arrival_address' + candidateID + '" value="' + arrival_address + '" /></td>';
				tableBody += '<td class="style5"><input type="text" size="12" id="arrival_address_2' + candidateID + '" value="' + arrival_address_2 + '" /></td>';
				tableBody += '<td class="style5"><input type="text" size="12" id="arrival_city' + candidateID + '" value="' + arrival_city + '" /></td>';
				tableBody += '<td class="style5"><select id="arrival_state' + candidateID + '"><option value="0"></option>';
				<cfoutput query="qGetStateList">
					if (arrival_state == #id#) {
						tableBody += '<option value="#id#" selected="selected">#state#</option>';
					} else {
						tableBody += '<option value="#id#">#state#</option>';
					}
				</cfoutput>
				tableBody += '</select>';
				tableBody += '<td class="style5"><input type="text" size="5" maxlength="5" id="arrival_zip' + candidateID + '" value="' + arrival_zip + '" /></td>';
				tableBody += '<td align="center" class="style5">';
				tableBody += '<a href="" onClick="javascript:checkInTrackingPopup(\'' + uniqueID + '\',\'0\')" class="style4 jQueryModal">Track</a>';
				tableBody += '<br/>'+recentTracking;
				tableBody += '</td>';
				tableBody += '<td align="center" class="style5"><a href="javascript:setCheckInReceived(' + candidateID + ');" class="style4">[Received]</a></td>';
				tableBody += '</tr>';
				// Append table rows
				$("#verificationList").append(tableBody);
			}
			
		} 
		
	}
	// --- END OF VERIFICATION LIST --- //

	
	// --- START OF VERICATION RECEIVED --- //
	var setCheckInReceived = function(candidateID) {
		
		// Create an instance of the proxy. 
		var c = new candidate();
		
		var initPhone = document.getElementById('usphone' + candidateID).value;
		var initAddress = document.getElementById('arrival_address' + candidateID).value;
		var initAddress2 = document.getElementById('arrival_address_2' + candidateID).value;
		var initCity = document.getElementById('arrival_city' + candidateID).value;
		var initState = document.getElementById('arrival_state' + candidateID).value;
		var initZip = document.getElementById('arrival_zip' + candidateID).value;		

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(checkInReceived(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getVerificationList CFC function. 
		c.confirmCheckInReceived(candidateID, initPhone, initAddress, initAddress2, initCity, initState, initZip);
		
	}
	
	var checkInReceived = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#candidateDetailMessage").text("Check-in for candidate #" + candidateID + " received").fadeIn().fadeOut(3000);

		// Fade out record from search list
		$("#" + candidateID).fadeOut("slow");
		
	}
	// --- END OF VERICATION RECEIVED --- //
	
	var checkInTrackingPopup = function(unqID, trackID) {
		var url = "candidate/evaluation_tracking.cfm?uniqueID=" + unqID + "&id=" + trackID;
		$(".jQueryModal").colorbox( {
			width:"50%", 
			height:"60%", 
			iframe:true,
			overlayClose:false,
			escKey:false,
			href:url,
			onClosed:function(){}
		});	
	}

	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	}
	
	var applyPhoneMask = function(usPhoneID) {
		$("#" + usPhoneID).mask("9-999-999-9999");
	}
	
</script>


<style>
	input { 
		border: 1px solid #999; 
		margin-bottom: 0.5em;  
	}
	
	select {
		border: 1px solid #999; 
		margin-bottom: .5em;
	}
	
	.listTable {
		width:95%;
		padding:10px 15px 10px 15px;
		border:1px solid #CCCCCC;
		margin-top:10px;
		margin-bottom:10px;
		font-size: 0.9em;
	}
			
	.listTitle { 
		font-weight:bold;
		background-color:#4F8EA4;
	}

	.rowOn {
		background-color:#e9ecf1;
	}
	
	.rowOff {
		background-color:#FFFFFF;
	}
	
	.formTitle { 
		padding-top:10px;
		font-weight:800;
	}

	.largeField {
		width:250px;
	}

	.smallField {
		width:120px;
	}

	.pageMessage {
		display:none;
		margin:10px 0px 10px 0px;
		text-align:center;
		font-weight:bold;
		color:#006699;
	}

	.verList {
		display:none;
	}

	.candidateDetail {
		font-size:1.1em;
		font-family:Georgia, "Times New Roman", Times, serif;
		display:none;
		padding-top:10px;
	}
</style>

<cfoutput>
	
	<!--- Table Header --->    
    <gui:tableHeader
        tableTitle="Check-In List"
    />

	<!--- This holds the candidate information messages --->
    <div id="candidateDetailMessage" class="pageMessage"></div>

    <!--- List Options --->
    <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
        <tr>
            <td class="formTitle">
            	International Representative: 
                &nbsp;
                <select name="intlRep" id="intlRep" onchange="getVerificationList();">
                    <option value=""></option>
                    <cfloop query="qIntlRep">
                        <option value="#qIntlRep.userID#" <cfif CLIENT.userID EQ qIntlRep.UserID> selected </cfif> >#qIntlRep.businessName#</option>
                    </cfloop>
                </select>
                &nbsp;
				&nbsp;	
                Program:
                <select name="programID" id="programID">
                    <option value=""></option>
                    <cfloop query="qGetProgramList">
                    	<option value="#programID#">#programname#</option>
                    </cfloop>
                </select>
                &nbsp;
                Show:
                <select name="reportType" id="reportType">
                	<option value="0">All</option>
                    <option value="1">Warning</option>
                    <option value="2">Non-Compliant</option>
                </select>
                &nbsp;
                <input name="send" type="submit" value="Submit" onclick="getVerificationList();" />
            </td>                
        </tr>   
         
    </table>

    <!--- Verification List --->
    <table id="verificationList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    