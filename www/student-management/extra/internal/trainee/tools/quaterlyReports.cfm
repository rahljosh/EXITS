<!--- ------------------------------------------------------------------------- ----
	
	File:		quaterlyReports.cfm
	Author:		Marcus Melo
	Date:		November 14, 2011
	Desc:		Quaterly Report Update Tool 

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="/extra/extensions/customTags/gui/" prefix="gui" /> 
	
    <cfparam name="FORM.monthEvaluation" default="">
    
    <cfscript>
		// Get International Representatives List
		qIntlRep = APPLICATION.CFC.USER.getIntlRepAssignedToCandidate();	

		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		
		vMonthEvaluationList = "2,5,8,11";
		
		// Set Current Month Evaluation
		vCurrentMonth = Month(now());
		
		switch(vCurrentMonth) {
			
			// February
			case 2: case 3: case 4: {
				FORM.monthEvaluation = 2;
			}
			// May
			case 5: case 6: case 7: {
				FORM.monthEvaluation = 5;
			}
			// August
			case 8: case 9: case 10: {
				FORM.monthEvaluation = 8;
			}
			// November
			case 11: case 12: case 1: {
				FORM.monthEvaluation = 11;
			}

		}
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
	// 	getCandidateList();
	// });

	// --- START OF CANDIDATE LIST --- //

	// Use an asynchronous call to get the candidate details. The function is called when the user selects a candidate. 
	var getCandidateList = function() { 

		// Create an instance of the proxy. 
		var c = new candidate();
		
		// Get Search Form Values
		var intlRep = $("#intlRep").val();
		var programID = $("#programID").val();
		var monthEvaluation = $("#monthEvaluation").val();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateCandidateList); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getCandidateList CFC function. 
		c.getTraineeQuaterlyReport(intlRep,programID,monthEvaluation);
	} 

	// Callback function to handle the results returned by the getCandidateList function and populate the table. 
	var populateCandidateList = function(verList) { 
		
		// Clear current result
		$("#candidateList").empty();
		
		// Get selected report
		var monthEvaluation = $("#monthEvaluation").val();
		
		// Create Table Header
		var tableHeader = '';		
		tableHeader += '<tr>';
        	tableHeader += '<td class="listTitle style2" width="5%">ID</td>';
        	tableHeader += '<td class="listTitle style2" width="10%">Last Name</td>';
			tableHeader += '<td class="listTitle style2" width="10%">First Name</td>';
			tableHeader += '<td class="listTitle style2" width="20%">Host Company</td>';
			tableHeader += '<td class="listTitle style2" width="20%">Intl. Rep.</td>';
			tableHeader += '<td class="listTitle style2" width="8%">Program <br /> Start Date</td>';
			tableHeader += '<td class="listTitle style2" width="8%">Program <br /> End Date</td>';
			tableHeader += '<td class="listTitle style2" align="center" width="8%">Date Submitted</td>';
			tableHeader += '<td class="listTitle style2" align="center" width="11%">Date Approved</td>';
		tableHeader += '</tr>';
		
		// Append Table Header to HTML
		$("#candidateList").append(tableHeader);
		
		if( verList.DATA.length == 0) {
			// No data returned, display message
			$("#candidateList").append("<tr><th colspan='10'>Your search did not return any results.</th></tr>");
		}
		
		// Loop over results and build the grid
		for(i=0;i<verList.DATA.length;i++) { 
			
			var uniqueID = verList.DATA[i][verList.COLUMNS.findIdx('UNIQUEID')];
			var candidateID = verList.DATA[i][verList.COLUMNS.findIdx('CANDIDATEID')];		
			var firstName = verList.DATA[i][verList.COLUMNS.findIdx('FIRSTNAME')];
			var lastName = verList.DATA[i][verList.COLUMNS.findIdx('LASTNAME')];
			var hostCompanyName = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYNAME')];
			var businessName = verList.DATA[i][verList.COLUMNS.findIdx('BUSINESSNAME')];
			var startDate = verList.DATA[i][verList.COLUMNS.findIdx('STARTDATE')];
			var endDate = verList.DATA[i][verList.COLUMNS.findIdx('ENDDATE')];
			var dateSubmitted = verList.DATA[i][verList.COLUMNS.findIdx('DATESUBMITTED')];
			var dateApproved = verList.DATA[i][verList.COLUMNS.findIdx('DATEAPPROVED')];

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
				tableBody += '<td class="style5">' + hostCompanyName + '</td>';
				tableBody += '<td class="style5">' + businessName + '</td>';
				tableBody += '<td class="style5">' + startDate + '</td>';
				tableBody += '<td class="style5">' + endDate + '</td>';
				tableBody += '<td class="style5" align="center">' + dateSubmitted + '</td>';	
				// Display Quaterly Options
				if ( dateSubmitted != '' && dateApproved == '' ) {
					tableBody += '<td class="style5" align="center"><a href="javascript:setQuaterlyReportReceived(' + candidateID + ',' + monthEvaluation + ');" class="style4">[Set as Received]</a></td>';
				} else {
					tableBody += '<td class="style5" align="center">' + dateApproved + '</td>';
				}
			tableBody += '</tr>';
			// Append table rows
			$("#candidateList").append(tableBody);
		} 
		
	}
	// --- END OF CANDIDATE LIST --- //

	
	// --- START OF VERICATION RECEIVED --- //
	var setQuaterlyReportReceived = function(candidateID, monthEvaluation) {
		
		// Create an instance of the proxy. 
		var c = new candidate();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(checkInReceived(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getCandidateList CFC function. 
		c.confirmQuaterlyReportReceived(candidateID, monthEvaluation);
		
	}
	
	var checkInReceived = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#updateMessage").text("Quaterly report for candidate #" + candidateID + " received").fadeIn().fadeOut(3000);

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
        tableTitle="Quaterly Questionnaire Tool"
    />

	<!--- This holds the candidate information messages --->
    <div id="updateMessage" class="pageMessage"></div>

    <!--- List Options --->
    <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
        <tr>
            <td class="formTitle">
            	International Representative: 
                &nbsp;
                <select name="intlRep" id="intlRep" onchange="getCandidateList();">
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
                    	<option value="#qGetProgramList.programID#">#qGetProgramList.programname#</option>
                    </cfloop>
                </select>
                
                &nbsp;
				&nbsp;
                	
                Month Report:
                <select name="monthEvaluation" id="monthEvaluation">
                    <cfloop list="#vMonthEvaluationList#" index="m">
                    	<option value="#m#" <cfif FORM.monthEvaluation EQ m> selected </cfif> >#MonthAsString(m)#</option>
                    </cfloop>
                </select>
                
                &nbsp;
                
                <input name="send" type="submit" value="Submit" onclick="getCandidateList();" />
            </td>                
        </tr>   
    </table>

    <!--- Candidate List --->
    <table id="candidateList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    