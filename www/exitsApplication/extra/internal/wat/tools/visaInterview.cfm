<!--- ------------------------------------------------------------------------- ----
	
	File:		visaInterview.cfm
	Author:		James Griffiths
	Date:		July 30, 2013
	Desc:		Visa Interview list - shows all candidates that are missing a date 
				for their Visa Interview and allows the dates to be added.	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="/extensions/customTags/gui/" prefix="gui" /> 

    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Get International Representative List
		qIntlRep = APPLICATION.CFC.USER.getIntlRepAssignedToCandidate();	
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>
    
	<cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT id, state, stateName
        FROM smg_states
      	ORDER BY stateName
    </cfquery>
    
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

	// --- START OF VISA INTERVIEW LIST --- //

	// Use an asynchronous call to get the candidate details. The function is called when the user selects a candidate. 
	var getVisaInterviewList = function() {
		
		// Create an instance of the proxy. 
		var c = new candidate();
		
		// Get Search Form Values
		var intRep = $("#intRep").val();
		var programID = $("#programID").val();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateVisaInterviewList); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getVisaInterviewList CFC function. 
		c.getMissingVisaInterviewStudentList(intRep,programID);
	} 

	// Callback function to handle the results returned by the getVisaInterviewList function and populate the table. 
	var populateVisaInterviewList = function(verList) { 

		// Clear current result
		$("#visaInterviewList").empty();
		
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
		tableHeader += '<td class="listTitle style2">Program</td>';
		tableHeader += '<td class="listTitle style2">Program <br /> Start Date</td>';
		tableHeader += '<td class="listTitle style2">Program <br /> End Date</td>';
		tableHeader += '<td class="listTitle style2" align="center">Visa Interview Date</td>';                                                          
		tableHeader += '</tr>';
		
		// Append Table Header to HTML
		$("#visaInterviewList").append(tableHeader);
		
		if( verList.DATA.length == 0) {
			// No data returned, display message
			$("#visaInterviewList").append("<tr><th colspan='13'>Your search did not return any results.</th></tr>");
		} 
		
		// Loop over results and build the grid
		for(i=0;i<verList.DATA.length;i++) { 
			
			var uniqueID = verList.DATA[i][verList.COLUMNS.findIdx('UNIQUEID')];
			var candidateID = verList.DATA[i][verList.COLUMNS.findIdx('CANDIDATEID')];		
			var lastName = verList.DATA[i][verList.COLUMNS.findIdx('LASTNAME')];
			var firstName = verList.DATA[i][verList.COLUMNS.findIdx('FIRSTNAME')];
			var email = verList.DATA[i][verList.COLUMNS.findIdx('EMAIL')];
			var sex = verList.DATA[i][verList.COLUMNS.findIdx('SEX')];
			var countryName = verList.DATA[i][verList.COLUMNS.findIdx('COUNTRYNAME')];
			var ds2019 = verList.DATA[i][verList.COLUMNS.findIdx('DS2019')];
			var businessName = verList.DATA[i][verList.COLUMNS.findIdx('BUSINESSNAME')];
			var programName = verList.DATA[i][verList.COLUMNS.findIdx('PROGRAMNAME')];
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
			tableBody += '<td class="style5">' + email + '</td>';
			tableBody += '<td class="style5">' + sex + '</td>';
			tableBody += '<td class="style5">' + countryName + '</td>';
			tableBody += '<td class="style5">' + ds2019 + '</td>';
			tableBody += '<td class="style5">' + businessName + '</td>';
			tableBody += '<td class="style5">' + programName + '</td>';
			tableBody += '<td class="style5">' + startDate + '</td>';
			tableBody += '<td class="style5">' + endDate + '</td>';
			tableBody += '<td align="center" class="style5"><a href="javascript:setVisaInterviewDate(' + candidateID + ');" class="style4">[Set Date]</a></td>';
			tableBody += '</tr>';
			
			// Append table rows
			$("#visaInterviewList").append(tableBody);
		} 
		
	}
	// --- END OF VISA INTERVIEW LIST --- //

	
	// --- START OF VISA INTERVIEW DATE --- //
	var setVisaInterviewDate = function(candidateID) {
		
		// Create an instance of the proxy. 
		var c = new candidate();	

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(visaInterviewDateSet(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		c.setVisaInterviewDateToday(candidateID);
	}
	
	var visaInterviewDateSet = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#candidateDetailMessage").text("Visa Interview Date for candidate #" + candidateID + " set").fadeIn().fadeOut(3000);

		// Fade out record from search list
		$("#" + candidateID).fadeOut("slow");
		
	}
	// --- END OF VISA INTERVIEW DATE --- //

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
        tableTitle="Visa Interview"
    />

	<!--- This holds the candidate information messages --->
    <div id="candidateDetailMessage" class="pageMessage"></div>

    <!--- List Options --->
    <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
        <tr>
            <td class="formTitle">
                <cfif ListFind("1,2,3,4", CLIENT.userType)>
                	International Representative: 
                	&nbsp;
                    <select name="intRep" id="intRep" onchange="getVisaInterviewList();">
                        <option value="0">All</option>
                        <cfloop query="qIntlRep">
                            <option value="#qIntlRep.userID#" <cfif CLIENT.userID EQ qIntlRep.UserID> selected </cfif> >#qIntlRep.businessName#</option>
                        </cfloop>
                    </select>
              	<cfelse>
                	<cfloop query="qIntlRep">
                    	<cfif userID EQ VAL(CLIENT.userID)>
                        	<input type="hidden" name="intRep" id="intRep" value="#userID#"/>
                        </cfif>
                    </cfloop>
                </cfif>
                &nbsp;
				&nbsp;	
                Program:
                <select name="programID" id="programID">
                    <option value="0">All</option>
                    <cfloop query="qGetProgramList">
                    	<option value="#programID#">#programname#</option>
                    </cfloop>
                </select>
                &nbsp;
                <input name="send" type="submit" value="Submit" onclick="getVisaInterviewList();" style="cursor:pointer;" />
            </td>                
        </tr>   
         
    </table>

    <!--- Visa Interview List --->
    <table id="visaInterviewList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    