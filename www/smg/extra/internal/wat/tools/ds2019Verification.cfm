<!--- ------------------------------------------------------------------------- ----
	
	File:		ds2019Verification.cfm
	Author:		Marcus Melo
	Date:		August 19, 2010
	Desc:		Verification Report. This page allows users/intl reps to update 
				DS-2019 verification report data and check if a record is correct.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="/extra/extensions/customtags/gui/" prefix="gui" /> 
    
    <cfscript>
		if ( CLIENT.userType LTE 4 ) {
			// Get All International Representatives List
			qIntlRep = APPLICATION.CFC.USER.getUsers(userType=8, getAll=0);	
		} else {
			// Get Current International Representatives List
			qIntlRep = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);	
		}
		
		// Get Country List
		qCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountry();
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

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(populateVerificationList); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getVerificationList CFC function. 
		c.getVerificationList(intlRep);
	} 

	// Callback function to handle the results returned by the getVerificationList function and populate the table. 
	var populateVerificationList = function(verList) { 
		
		// Clear current result
		$("#verificationList").empty();
		
		// Create Table Header
		var tableHeader = '';		
		tableHeader += "<tr>";
        	tableHeader += "<td class='listTitle style2'>ID</td>";
        	tableHeader += "<td class='listTitle style2'>First Name</td>";
        	tableHeader += "<td class='listTitle style2'>Middle Name</td>";
        	tableHeader += "<td class='listTitle style2'>Last Name</td>";
        	tableHeader += "<td class='listTitle style2'>Gender</td>";
        	tableHeader += "<td class='listTitle style2'>DOB <br /> (mm/dd/yyyy)</td>";                                                            
            tableHeader += "<td class='listTitle style2'>City of <br /> Birth</td>";                                                          
            tableHeader += "<td class='listTitle style2'>Country of <br /> Birth</td>";                                                           
            tableHeader += "<td class='listTitle style2'>Country of <br /> Citizenship</td>"; 
            tableHeader += "<td class='listTitle style2'>Country of <br /> Residence</td>";  
            tableHeader += "<td class='listTitle style2' align='center'>Actions</td>";                                                          
		tableHeader += "</tr>";
		
		// Append Table Header to HTML
		$("#verificationList").append(tableHeader);
		
		if( verList.DATA.length == 0) {
			// No data returned, display message
			$("#verificationList").append("<tr><th colspan='11'>Your search did not return any results.</th></tr>");
		}
		
		// Loop over results and build the grid
		for(i=0;i<verList.DATA.length;i++) { 
			
			var candidateID = verList.DATA[i][verList.COLUMNS.findIdx('CANDIDATEID')];		
			var firstName = verList.DATA[i][verList.COLUMNS.findIdx('FIRSTNAME')];
			var middleName = verList.DATA[i][verList.COLUMNS.findIdx('MIDDLENAME')];
			var lastName = verList.DATA[i][verList.COLUMNS.findIdx('LASTNAME')];
			var sex = verList.DATA[i][verList.COLUMNS.findIdx('SEX')];
			var dob = verList.DATA[i][verList.COLUMNS.findIdx('DOB')];
			var birthCity = verList.DATA[i][verList.COLUMNS.findIdx('BIRTH_CITY')];
			var countryBirth = verList.DATA[i][verList.COLUMNS.findIdx('BIRTHCOUNTRY')];
			var countryCitizen = verList.DATA[i][verList.COLUMNS.findIdx('CITIZENCOUNTRY')];
			var countryResident = verList.DATA[i][verList.COLUMNS.findIdx('RESIDENTCOUNTRY')];
			
			// Create Table Rows
			var tableBody = '';	
			
				if (i % 2 == 0) {
					tableBody += "<tr id='" + candidateID + "' class='rowOff'>";
				} else {
					tableBody += "<tr id='" + candidateID + "' class='rowOn'>";
				}
				tableBody += "<td class='style5'><a href='javascript:getCandidateDetails(" + candidateID + ");' class='style4'>#" + candidateID + "</a></td>"
				tableBody += "<td class='style5'><a href='javascript:getCandidateDetails(" + candidateID + ");' class='style4'>" + firstName + "</a></td>"
				tableBody += "<td class='style5'><a href='javascript:getCandidateDetails(" + candidateID + ");' class='style4'>" + middleName + "</a></td>"
				tableBody += "<td class='style5'><a href='javascript:getCandidateDetails(" + candidateID + ");' class='style4'>" + lastName + "</a></td>"
				tableBody += "<td class='style5'>" + sex + "</td>"
				tableBody += "<td class='style5'>" + dob + "</td>"
				tableBody += "<td class='style5'>" + birthCity + "</td>"
				tableBody += "<td class='style5'>" + countryBirth + "</td>"
				tableBody += "<td class='style5'>" + countryCitizen + "</td>"
				tableBody += "<td class='style5'>" + countryResident + "</td>"
				tableBody += "<td align='center' class='style5'><a href='javascript:getCandidateDetails(" + candidateID + ");' class='style4'>[Edit]</a> | <a href='javascript:setVerificationReceived(" + candidateID + ");' class='style4'>[Received]</a></td>"
			tableBody += "</tr>";
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
	
	// Callback function to handle the results returned by the getVerificationList function and populate the form fields. 
	var populateCandidateDetails = function(candidate) { 
		
		//var candidateID = candidate.DATA[0][0];
		var candidateID = candidate.DATA[0][candidate.COLUMNS.findIdx('CANDIDATEID')];		
		var firstName = candidate.DATA[0][candidate.COLUMNS.findIdx('FIRSTNAME')];
		var middleName = candidate.DATA[0][candidate.COLUMNS.findIdx('MIDDLENAME')];
		var lastName = candidate.DATA[0][candidate.COLUMNS.findIdx('LASTNAME')];
		var sex = candidate.DATA[0][candidate.COLUMNS.findIdx('SEX')];
		var dob = candidate.DATA[0][candidate.COLUMNS.findIdx('DOB')];
		var birthCity = candidate.DATA[0][candidate.COLUMNS.findIdx('BIRTH_CITY')];
		var countryBirth = candidate.DATA[0][candidate.COLUMNS.findIdx('BIRTH_COUNTRY')];
		var countryCitizen = candidate.DATA[0][candidate.COLUMNS.findIdx('CITIZEN_COUNTRY')];
		var countryResident = candidate.DATA[0][candidate.COLUMNS.findIdx('RESIDENCE_COUNTRY')];
		
		// Populate fields
		$("#candidateID").val(candidateID);
		$("#firstName").val(firstName);
		$("#middleName").val(middleName);
		$("#lastName").val(lastName);
		$("#sex").val(sex);
		$("#dob").val(dob);
		$("#birthCity").val(birthCity);
		$("#countryBirth").val(countryBirth);
		$("#countryCitizen").val(countryCitizen);
		$("#countryResident").val(countryResident);
		
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
		// Gender			
		if($("#sex").val() == ''){
			list_errors = (list_errors + 'Please select a gender \n')
		}
		// DOB			
		if($("#dob").val() == ''){
			list_errors = (list_errors + 'Please provide a valid date of birth (mm/dd/yyyy) \n')
		}
		// City of Birth			
		if($("#birthCity").val() == ''){
			list_errors = (list_errors + 'Please provide a city of birth \n')
		}
		// Country of Birth			
		if($("#countryBirth").val() == ''){
			list_errors = (list_errors + 'Please select a country of birth \n')
		}
		// Country of Citizen			
		if($("#countryCitizen").val() == ''){
			list_errors = (list_errors + 'Please select a country of citizen \n')
		}
		// Country of Resident			
		if($("#countryResident").val() == ''){
			list_errors = (list_errors + 'Please select a country of residence \n')
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
		c.updateRemoteCandidateByID(
		  // Get values from the fields
		  $("#candidateID").val(),
		  $("#firstName").val(),
		  $("#middleName").val(),
		  $("#lastName").val(),
		  $("#sex").val(),
		  $("#dob").val(),
		  $("#birthCity").val(),
		  $("#countryBirth").val(),
		  $("#countryCitizen").val(),
		  $("#countryResident").val()
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
			$("#middleName").val("");
			$("#lastName").val("");
			$("#sex").val("");
			$("#dob").val("");
			$("#birthCity").val("");
			$("#countryBirth").val("");
			$("#countryCitizen").val("");
			$("#countryResident").val("");
		});
		
		// Refresh Search List
		getVerificationList();
	}
	// --- END OF STUDENT DETAILS --- //
	
	
	// --- START OF VERICATION RECEIVED --- //
	var setVerificationReceived = function(candidateID) {
		
		// Create an instance of the proxy. 
		var c = new candidate();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(verificationReceived(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getVerificationList CFC function. 
		c.confirmVerificationReceived(candidateID);
		
	}
	
	var verificationReceived = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#candidateDetailMessage").text("Verification report for candidate #" + candidateID + " received").fadeIn().fadeOut(3000);

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
		margin-bottom: .5em;  
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
		width:200px;
	}

	.smallField {
		width:80px;
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
		display:none;
		padding-top:10px;
	}
</style>

<cfoutput>

	<!--- Table Header --->    
    <gui:tableHeader
        tableTitle="DS-2019 Verification List"
    />

	<!--- This holds the candidate information messages --->
    <div id="candidateDetailMessage" class="pageMessage"></div>
    
    <!--- This holds the form to update candidate information --->
    <div id="candidateDetailDiv" class="candidateDetail">

        <form name="candidateDetail" onsubmit="return updateCandidateDetail();">
            <input type="hidden" name="candidateID" id="candidateID" value="" />
            <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
                <tr>
                	<td class="formTitle" colspan="6">Please make your corrections below and click on submit.</td>
				</tr>                    
                <tr>
                    <td class="formTitle"><label for="firstName">First Name</label></td>
                    <td class="formTitle"><label for="middleName">Middle Name</label></td>
                    <td class="formTitle"><label for="lastName">Last Name</label></td>
                    <td class="formTitle"><label for="sex">Gender</label></td>
                    <td class="formTitle"><label for="dob">DOB (mm/dd/yy)</label></td> 
				</tr>
                <tr>
                    <td><input type="text" name="firstName" id="firstName" value="" class="largeField" maxlength="100" /></td>
                    <td><input type="text" name="middleName" id="middleName" value="" class="largeField" maxlength="100" /></td>
                    <td><input type="text" name="lastName" id="lastName" value="" class="largeField" maxlength="100" /></td>
                    <td>
                    	<select name="sex" id="sex">
                        	<option value=""></option>
                            <option value="M">Male</option>
                            <option value="F">Female</option>
						</select>                            
                    </td>
                    <td><input type="text" name="dob" id="dob" value="" class="smallField" maxlength="10" /></td>
            	</tr> 
                <tr>                    
                    <td class="formTitle"><label for="birthCity">City of Birth</label></td>                                                            
                    <td class="formTitle"><label for="countryBirth">Country of Birth</label></td>                                                            
                    <td class="formTitle"><label for="countryCitizen">Country of Citizenship</label></td> 
                    <td class="formTitle"><label for="countryResident">Country of Residence</label></td>   
                    <td class="formTitle">&nbsp;</td>                                                          
                </tr>            
				<tr>	
                    <td><input type="text" name="birthCity" id="birthCity" value="" class="largeField" maxlength="100" /></td>
                    <td>
                    	<select name="countryBirth" id="countryBirth">
                        	<option value=""></option>
                        	<cfloop query="qCountryList">
                            	<option value="#qCountryList.countryID#">#qCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td>
                    	<select name="countryCitizen" id="countryCitizen">
                        	<option value=""></option>
                        	<cfloop query="qCountryList">
                            	<option value="#qCountryList.countryID#">#qCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td>
                    	<select name="countryResident" id="countryResident">
                        	<option value=""></option>
                        	<cfloop query="qCountryList">
                            	<option value="#qCountryList.countryID#">#qCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td><input type="submit" name="submit" value="Submit" /></td>
				</tr>                    
            </table>
        </form>
        
	</div>

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
                <input name="send" type="submit" value="Submit" onclick="getVerificationList();" />
            </td>                
        </tr>            
    </table>

    <!--- Verification List --->
    <table id="verificationList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%"></table>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    