<!--- ------------------------------------------------------------------------- ----
	
	File:		montlyEvaluations.cfm
	Author:		Marcus Melo
	Date:		July 7, 2011
	Desc:		Monthly Evaluation Update Tool 

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
    
</cfsilent>    

<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="extensions.components.candidate" jsclassname="candidate">

<script type="text/javascript">
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
		var evaluationID = $("#evaluationID").val();
		var reportType = $("#reportType").val();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateCandidateList); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getCandidateList CFC function. 
		c.getMonthlyEvaluationList(intlRep,programID,evaluationID,reportType);
	}

	// Callback function to handle the results returned by the getCandidateList function and populate the table. 
	var populateCandidateList = function(verList) { 
		
		// Clear current result
		$("#candidateList").empty();
		
		// Get selected evaluation
		var evaluationID = $("#evaluationID").val();
		var reportType = $("#reportType").val();
		
		// Create Table Header
		var tableHeader = '';		
		tableHeader += '<tr>';
        	tableHeader += '<td class="listTitle style2">ID</td>';
        	tableHeader += '<td class="listTitle style2">Last Name</td>';
			tableHeader += '<td class="listTitle style2">First Name</td>';
			tableHeader += '<td class="listTitle style2">DS-2019</td>';
			tableHeader += '<td class="listTitle style2">Host Company</td>';
			tableHeader += '<td class="listTitle style2">Email</td>';
			if (reportType == 1 || reportType == 2) {
				tableHeader += '<td class="listTitle style2">Phone</td>';
			}
			tableHeader += '<td class="listTitle style2">Intl. Rep.</td>';
			tableHeader += '<td class="listTitle style2">Program <br /> Start Date</td>';
			tableHeader += '<td class="listTitle style2">Program <br /> End Date</td>';
			tableHeader += '<td class="listTitle style2">Check-in Date</td>';
			tableHeader += '<td class="listTitle style2">Days since check-in</td>';
			tableHeader +=  '<td class="listTitle style2" align="center">Cultural Activity</td>';
			if ( (evaluationID == 1) || (evaluationID == 5) ) {
				// Month 1
				tableHeader += '<td class="listTitle style2" align="center">Evaluation 1</td>';
			} else if ( (evaluationID == 2) || (evaluationID == 6) ) {
				// Month 2
				tableHeader += '<td class="listTitle style2" align="center">Evaluation 2</td>';
			} else if ( (evaluationID == 3) || (evaluationID == 7) ) {
				// Month 2
				tableHeader += '<td class="listTitle style2" align="center">Evaluation 3</td>';
			} else if ( (evaluationID == 4) || (evaluationID == 8) ) {
				// Month 2
				tableHeader += '<td class="listTitle style2" align="center">Evaluation 4</td>';
			}
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
			var ds2019 = verList.DATA[i][verList.COLUMNS.findIdx('DS2019')];
			var hostCompanyName = verList.DATA[i][verList.COLUMNS.findIdx('HOSTCOMPANYNAME')];
			var email = verList.DATA[i][verList.COLUMNS.findIdx('EMAIL')];
			var phone = verList.DATA[i][verList.COLUMNS.findIdx('PHONE')];
			var businessName = verList.DATA[i][verList.COLUMNS.findIdx('BUSINESSNAME')];
			var startDate = verList.DATA[i][verList.COLUMNS.findIdx('STARTDATE')];
			var endDate = verList.DATA[i][verList.COLUMNS.findIdx('ENDDATE')];
			var checkIn = verList.DATA[i][verList.COLUMNS.findIdx('CHECKINDATE')];
			if (checkIn == null)
				checkIn = "missing";
			var evaluation1 = verList.DATA[i][verList.COLUMNS.findIdx('WATDATEEVALUATION1')];
			var evaluation2 = verList.DATA[i][verList.COLUMNS.findIdx('WATDATEEVALUATION2')];
			var evaluation3 = verList.DATA[i][verList.COLUMNS.findIdx('WATDATEEVALUATION3')];
			var evaluation4 = verList.DATA[i][verList.COLUMNS.findIdx('WATDATEEVALUATION4')];
			
			// These are for comparing the evaluation dates in order to show alerts
			var cIn = new Date(checkIn);
			var now = new Date();
			var nComplianceDate = new Date(cIn);
			var nCloseDate = new Date(cIn);
			var dateDiff = "";
			var nComplianceDays = 0;
			var nCloseDays = 0;
			if (checkIn != 'missing')
				dateDiff = Math.round((now - cIn)/(1000*60*60*24));
			if (evaluationID == 1) {
				nComplianceDays = 30;
				nCloseDays = 25;
			} else if (evaluationID == 2) {
				nComplianceDays = 60;
				nCloseDays = 55;
			} else if (evaluationID == 3) {
				nComplianceDays = 90;
				nCloseDays = 85;
			} else if (evaluationID == 4) {
				nComplianceDays = 120;
				nCloseDays = 115;
			}
			nComplianceDate.setDate(cIn.getDate() + nComplianceDays);
			nCloseDate.setDate(cIn.getDate() + nCloseDays);
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
				tableBody += '<td class="style5">' + ds2019 + '</td>';
				tableBody += '<td class="style5">' + hostCompanyName + '</td>';
				tableBody += '<td class="style5"><a href="mailto:' + email + '" class="style4">' + email + '</a></td>';
				if (reportType == 1 || reportType == 2) {
					tableBody += '<td class="style5">' + phone + '</td>';
				}
				tableBody += '<td class="style5">' + businessName + '</td>';
				tableBody += '<td class="style5">' + startDate + '</td>';
				tableBody += '<td class="style5">' + endDate + '</td>';
				tableBody += '<td class="style5">' + checkIn + '</td>';
				if (nComplianceDate <= now) {
					tableBody += '<td class="style5" style="background-color:#F00; text-align:center;">' + dateDiff + '</td>';
				} else if (nCloseDate <= now) {
					tableBody += '<td class="style5" style="background-color:#F90; text-align:center;">' + dateDiff + '</td>';
				} else {
					tableBody += '<td class="style5" style="text-align:center;">' + dateDiff + '</td>';
				}
				tableBody += '<td align="center" class="style5"><a href="" onClick="javascript:culturalActivityPopup(\'' + uniqueID + '\')" class="style4 jQueryModal">Add</a>';
				if (evaluationID == 1) {
					tableBody += '<td align="center" class="style5"><a href="javascript:setEvaluationReceived(' + candidateID + ',1);" class="style4">Received</a></td>';
				} else if (evaluationID == 2) {
					tableBody += '<td align="center" class="style5"><a href="javascript:setEvaluationReceived(' + candidateID + ',2);" class="style4">Received</a></td>';
				} else if (evaluationID == 3) {
					tableBody += '<td align="center" class="style5"><a href="javascript:setEvaluationReceived(' + candidateID + ',3);" class="style4">Received</a></td>';
				} else if (evaluationID == 4) {
					tableBody += '<td align="center" class="style5"><a href="javascript:setEvaluationReceived(' + candidateID + ',4);" class="style4">Received</a></td>';
				}
			tableBody += '</tr>';
			// Append table rows
			$("#candidateList").append(tableBody);
		} 
		
	}
	// --- END OF CANDIDATE LIST --- //
	
	var culturalActivityPopup = function(unqID) {
		var url = "candidate/culturalActivityReport.cfm?uniqueID=" + unqID;
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
	
	// --- START OF VERICATION RECEIVED --- //
	var setEvaluationReceived = function(candidateID, evaluationID) {
		
		// Create an instance of the proxy. 
		var c = new candidate();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(checkInReceived(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getCandidateList CFC function. 
		c.confirmEvaluationReceived(candidateID, evaluationID);
		
	}
	
	var checkInReceived = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#updateMessage").text("Evaluation for candidate #" + candidateID + " received").fadeIn().fadeOut(3000);

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
        tableTitle="Monthly Evaluation Tool"
    />

	<!--- This holds the candidate information messages --->
    <div id="updateMessage" class="pageMessage"></div>

    <!--- List Options --->
    <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
        <tr>
            <td class="formTitle">
            	Intl. Rep: 
                &nbsp;
                <select name="intlRep" id="intlRep" onchange="getCandidateList();">
                    <option value="">All</option>
                    <cfloop query="qIntlRep">
                        <option value="#qIntlRep.userID#" <cfif CLIENT.userID EQ qIntlRep.UserID> selected </cfif> >
                        	<cfif LEN(qIntlRep.businessName) GT 50>
                        		#MID(qIntlRep.businessName,1,50)#...
                           	<cfelse>
                            	#qIntlRep.businessName#
                          	</cfif>
                      	</option>
                    </cfloop>
                </select>
            </td>
            <td class="formTitle">	
                Program:
                <select name="programID" id="programID">
                    <option value="">All</option>
                    <cfloop query="qGetProgramList">
                    	<option value="#programID#">#programname#</option>
                    </cfloop>
                </select>
            </td>
            <td class="formTitle">	
                Evaluation:
                <select name="evaluationID" id="evaluationID">
                    <option value="1">Month 1</option>
                    <option value="2">Month 2</option>
                    <option value="3">Month 3</option>
                    <option value="4">Month 4</option>
                </select>
            </td>
            <td class="formTitle">
                Show:
                <select name="reportType" id="reportType">
                	<option value="0">All</option>
                    <option value="1">Warning</option>
                    <option value="2">Non-Compliant</option>
                </select>
           	</td>              
        </tr>
        <tr>
        	<td class="formTitle" colspan="4">
        		<center><input name="send" type="submit" value="Submit" onclick="getCandidateList();" /></center>
           	</td>
        </tr>  
    </table>

    <!--- Candidate List --->
    <table id="candidateList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    