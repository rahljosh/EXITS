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
    <cfimport taglib="/extra/extensions/customTags/gui/" prefix="gui" /> 

    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Get All International Representatives List
		qIntlRep = APPLICATION.CFC.USER.getUsers(userType=8, getAll=0);	

		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>
    
</cfsilent>    

<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="extra.extensions.components.candidate" jsclassname="candidate">

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
        	tableHeader += '<td class="listTitle style2">Gender</td>';
			tableHeader += '<td class="listTitle style2">Country</td>';
			tableHeader += '<td class="listTitle style2">Program</td>';
			tableHeader += '<td class="listTitle style2">Intl. Rep.</td>';
			tableHeader += '<td class="listTitle style2">Program <br /> Start Date</td>';
			tableHeader += '<td class="listTitle style2">Program <br /> End Date</td>';
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
			var sex = verList.DATA[i][verList.COLUMNS.findIdx('SEX')];
			var countryName = verList.DATA[i][verList.COLUMNS.findIdx('COUNTRYNAME')];
			var programName = verList.DATA[i][verList.COLUMNS.findIdx('PROGRAMNAME')];
			var businessName = verList.DATA[i][verList.COLUMNS.findIdx('BUSINESSNAME')];
			var startDate = verList.DATA[i][verList.COLUMNS.findIdx('STARTDATE')];
			var endDate = verList.DATA[i][verList.COLUMNS.findIdx('ENDDATE')];

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
				tableBody += '<td class="style5">' + sex + '</td>';
				tableBody += '<td class="style5">' + countryName + '</td>';
				tableBody += '<td class="style5">' + programName + '</td>';
				tableBody += '<td class="style5">' + businessName + '</td>';
				tableBody += '<td class="style5">' + startDate + '</td>';
				tableBody += '<td class="style5">' + endDate + '</td>';
				tableBody += '<td align="center" class="style5"><a href="javascript:setCheckInReceived(' + candidateID + ');" class="style4">[Received]</a></td>';
			tableBody += '</tr>';
			// Append table rows
			$("#verificationList").append(tableBody);
		} 
		
	}
	// --- END OF VERIFICATION LIST --- //

	
	// --- START OF VERICATION RECEIVED --- //
	var setCheckInReceived = function(candidateID) {
		
		// Create an instance of the proxy. 
		var c = new candidate();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(checkInReceived(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getVerificationList CFC function. 
		c.confirmCheckInReceived(candidateID);
		
	}
	
	var checkInReceived = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#candidateDetailMessage").text("Check-in for candidate #" + candidateID + " received").fadeIn().fadeOut(3000);

		// Fade out record from search list
		$("#" + candidateID).fadeOut("slow");
		
	}
	// --- END OF VERICATION RECEIVED --- //

	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
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
                <input name="send" type="submit" value="Submit" onclick="getVerificationList();" />
            </td>                
        </tr>   
        
        
                 
    </table>

    <!--- Verification List --->
    <table id="verificationList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    