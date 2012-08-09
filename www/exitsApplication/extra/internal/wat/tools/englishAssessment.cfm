<!--- ------------------------------------------------------------------------- ----
	
	File:		englishAssessment..cfm
	Author:		Marcus Melo
	Date:		May 20, 2011
	Desc:		Update English Assessment CSB.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="/extra/extensions/customTags/gui/" prefix="gui" /> 

    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Get International Representatives List
		qIntlRep = APPLICATION.CFC.USER.getIntlRepAssignedToCandidate();	
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

	// --- START OF VERIFICATION LIST --- //

	// Use an asynchronous call to get the candidate details. The function is called when the user selects a candidate. 
	var getCandidateList = function() { 

		// Create an instance of the proxy. 
		var c = new candidate();
		
		// Get Search Form Values
		var keyWord = $("#keyWord").val();
		var intlRep = $("#intlRep").val();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateVerificationList); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getEnglishAssessmentToolList CFC function. 
		c.getEnglishAssessmentToolList(keyWord,intlRep);
	} 

	// Callback function to handle the results returned by the getEnglishAssessmentToolList function and populate the table. 
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
				tableBody += '<td class="style5"><a href="javascript:getCandidateDetails(' + candidateID + ');" class="style4">#' + candidateID + '</a></td>';
				tableBody += '<td class="style5"><a href="javascript:getCandidateDetails(' + candidateID + ');" class="style4">' + lastName + '</a></td>';
				tableBody += '<td class="style5"><a href="javascript:getCandidateDetails(' + candidateID + ');" class="style4">' + firstName + '</a></td>';
				tableBody += '<td class="style5">' + sex + '</td>';
				tableBody += '<td class="style5">' + countryName + '</td>';
				tableBody += '<td class="style5">' + programName + '</td>';
				tableBody += '<td class="style5">' + businessName + '</td>';
				tableBody += '<td class="style5">' + startDate + '</td>';
				tableBody += '<td class="style5">' + endDate + '</td>';
				tableBody += '<td align="center" class="style5"><a href="javascript:getCandidateDetails(' + candidateID + ');" class="style4">[Edit]</a></td>';
			tableBody += '</tr>';
			// Append table rows
			$("#verificationList").append(tableBody);
		} 
		
	}
	// --- END OF VERIFICATION LIST --- //


	// --- START OF STUDENT DETAILS --- //

	// Use an asynchronous call to get the candidate details. The function is called when the user selects a candidate. 
	var getCandidateDetails = function(candidateID) { 

		// Create an instance of the proxy. 
		var c = new candidate();
		
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateCandidateDetails); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the candidate ID to the getRemoteCandidateByID CFC function. 
		c.getRemoteCandidateByID(candidateID);
	} 
	
	// Callback function to handle the results returned by the getEnglishAssessmentToolList function and populate the form fields. 
	var populateCandidateDetails = function(candidate) { 
		
		//var candidateID = candidate.DATA[0][0];
		var candidateID = candidate.DATA[0][candidate.COLUMNS.findIdx('CANDIDATEID')];		
		var firstName = candidate.DATA[0][candidate.COLUMNS.findIdx('FIRSTNAME')];
		var lastName = candidate.DATA[0][candidate.COLUMNS.findIdx('LASTNAME')];
		var middleName = candidate.DATA[0][candidate.COLUMNS.findIdx('MIDDLENAME')];
		var englishAssessment = candidate.DATA[0][candidate.COLUMNS.findIdx('ENGLISHASSESSMENT')];
		var englishAssessmentDate = candidate.DATA[0][candidate.COLUMNS.findIdx('ENGLISHASSESSMENTDATE')];
		var englishAssessmentComment = candidate.DATA[0][candidate.COLUMNS.findIdx('ENGLISHASSESSMENTCOMMENT')];

		// Populate fields
		$("#candidateID").val(candidateID);
		$("#firstName").val(firstName);
		$("#lastName").val(lastName);
		$("#middleName").val(middleName);
		$("#englishAssessment").val(englishAssessment);
		$("#englishAssessmentDate").val(englishAssessmentDate);
		$("#englishAssessmentComment").val(englishAssessmentComment);

		// Slide down form field div
		if ($("#candidateDetailDiv").css("display") == "none") {
			$("#candidateDetailDiv").slideDown("fast");			
		}

	}

	var updateCandidateDetail = function() { 
		// Store a list of errors used in the validation 
		var list_errors = '';
		
		// first name			
		if($("#firstName").val() == ''){
			list_errors = (list_errors + 'Please provide a first name \n')
		}
		// last name			
		if($("#lastName").val() == ''){
			list_errors = (list_errors + 'Please provide a last name \n')
		}
		
		// check if there are errors
		if (list_errors != '') {
			alert(list_errors);				
			return false;
		}
		
		// No errors, submit the data
		submitCandidateDetail();
		// do not remove - firefox needs it in order to work properly
		return false; 
	}				
	
	var submitCandidateDetail = function() { 
	
		// Create an instance of the proxy. 
		var c = new candidate();
	
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(resetFormFields);
		c.setErrorHandler(myErrorHandler);
		
		// This time, pass the candidate data to the updateRemoteCandidateByID CFC function. 
		c.updateEnglishAssessmentByID(
		  	// Get values from the fields
		  	$("#candidateID").val(),
			$("#englishAssessment").val(),
			$("#englishAssessmentDate").val(),
			$("#englishAssessmentComment").val()
		);
		
	}

	var resetFormFields = function() {
		
		// Fade out form DIV
		$('#candidateDetailDiv').slideUp('fast', function() {
			// Animation complete.
			
			// Set up page message, fade in and fade out after 2 seconds
			$("#candidateDetailMessage").text( $("#firstName").val() + " " + $("#lastName").val() + " record has been saved successfully").fadeIn().fadeOut(3000);
			
			// Reset form fields
			$("#candidateID").val("");
			$("#firstName").val("");
			$("#lastName").val("");
			$("#middleName").val("");
			$("#englishAssessment").val("");
			$("#englishAssessmentDate").val("");
			$("#englishAssessmentComment").val("");
		});
		
		// Refresh Search List
		getCandidateList();
	}
	// --- END OF STUDENT DETAILS --- //
	

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

	.tableTitle { 
		padding:10px;
		font-weight:800;
		border: 1px solid #666;
		background-color: #F5F4F4;
	}

	.formTitle { 
		padding-top:10px;
		font-weight:800;
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
        tableTitle="English Assessment Update Tool"
    />

	<!--- This holds the candidate information messages --->
    <div id="candidateDetailMessage" class="pageMessage"></div>
    
    <!--- This holds the form to update candidate information --->
    <div id="candidateDetailDiv" class="candidateDetail">

        <form name="candidateDetail" onsubmit="return updateCandidateDetail();">
            <input type="hidden" name="candidateID" id="candidateID" value="" />
            <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
                <tr>
                	<td class="tableTitle" colspan="6">Update candidate information and click on submit.</td>
				</tr>                    
                <tr>
                    <td class="formTitle"><label for="lastName">Last Name</label></td>
                    <td class="formTitle"><label for="firstName">First Name</label></td>
                    <td class="formTitle"><label for="middleName">Middle Name</label></td>
                 </tr>   
                <tr>
                    <td><input type="text" name="lastName" id="lastName" value="" class="largeField" maxlength="100" disabled /></td>
                    <td><input type="text" name="firstName" id="firstName" value="" class="largeField" maxlength="100" disabled /></td>
                    <td><input type="text" name="middleName" id="middleName" value="" class="largeField" maxlength="100" disabled /></td>                    
            	</tr> 
                <tr>
                    <td class="formTitle"><label for="englishAssessment">English Assessment CSB:</label></td>
                    <td class="formTitle"><label for="englishAssessmentDate">Date of Interview</label></td>
                    <td class="formTitle"><label for="englishAssessmentComment">Comment</label></td>
                 </tr>   
                <tr>
                    <td valign="top"><textarea name="englishAssessment" id="englishAssessment" class="largeTextArea"></textarea></td>
                    <td valign="top"><input type="text" name="englishAssessmentDate" id="englishAssessmentDate" value="" class="datePicker" maxlength="100" /></td>
                    <td valign="top"><textarea name="englishAssessmentComment" id="englishAssessmentComment" class="largeTextArea"></textarea></td>                    
            	</tr> 
                <tr>
                    <td></td>
                    <td></td>
                    <td><input type="submit" name="submit" value="Submit" /></td>
                </tr>
            </table>
        </form>
        
	</div>

    <!--- List Options --->
    <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
        <tr>
            <td class="formTitle">
            	Keyword: <input type="text" name="keyWord" id="keyWord" class="largeField">
            </td>                
            <td class="formTitle">
                International Representative: 
                <select name="intlRep" id="intlRep" onchange="getCandidateList();">
                    <option value=""></option>
                    <cfloop query="qIntlRep">
                        <option value="#qIntlRep.userID#" <cfif CLIENT.userID EQ qIntlRep.UserID> selected </cfif> >#qIntlRep.businessName#</option>
                    </cfloop>
                </select>
            </td>    
            <td class="formTitle">
                <input name="send" type="submit" value="Search" onclick="getCandidateList();" />
            </td>                
        </tr>            
    </table>

    <!--- Verification List --->
    <table id="verificationList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%" style="margin-bottom:10px;"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    