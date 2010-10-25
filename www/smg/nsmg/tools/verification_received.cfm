<!--- ------------------------------------------------------------------------- ----
	
	File:		verificatio_report.cfm
	Author:		Marcus Melo
	Date:		April 14, 2010
	Desc:		Verification Report. This page allows users to change DS-2019 verification
				report data and check if a record is correct.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	<cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.branchID" default="0">
    
    <cfscript>
		if ( VAL(CLIENT.userType) AND CLIENT.userType LTE 4 ) {
			// Get All International Representatives List
			qIntRep = APPCFC.USER.getUsers(userType=8);	
		} else if ( CLIENT.userType EQ 8 )  {
			// Get Intl. Rep. Information
			qIntRep = APPCFC.USER.getUsers(userID=CLIENT.userID, userType=CLIENT.userType);
			FORM.intRep=CLIENT.userID;
		} else if ( CLIENT.userType EQ 11 ) {
			// Get Branch Information
			qIntRep = APPCFC.USER.getUsers(userID=CLIENT.userID, userType=CLIENT.userType);
			FORM.intRep=qIntRep.intRepID;
		}
		
		// Get Country List
		qCountryList = APPCFC.LOOKUPTABLES.getCountry();
	</cfscript>

</cfsilent>    

<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="nsmg.extensions.components.student" jsclassname="student">

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

	// Create an instance of the proxy. 
	var s = new student();

	// Load the list when page is ready
	$(document).ready(function() {
		getVerificationList();
	});
	
	// Call animated scroll to anchor/id function - This will scroll up the page to the student detail div
	function goToByScroll(){
	  $('html,body').animate({scrollTop: $("#studentDetailDiv").offset().top},'slow');
	}

	$('.editStudent').bind('click', function(event) {
	  event.preventDefault();
	  $.get(this.href, {}, function(reply) {
			  $("#studentDetailDiv").html(reply);
			  alert('test');
		  }, "html");
	});

	// --- START OF VERIFICATION LIST --- //

	// Use an asynchronous call to get the student details. The function is called when the user selects a student. 
	var getVerificationList = function() { 

		// Get Search Form Values
		var intRep = $("#intRep").val();
		var branchID = $("#branchID").val();
		
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		s.setCallbackHandler(populateVerificationList); 
		s.setErrorHandler(myErrorHandler); 
		// This time, pass the intRep ID to the getVerificationList CFC function. 
		s.getVerificationList(intRep,branchID);
	} 

	// Callback function to handle the results returned by the getVerificationList function and populate the table. 
	var populateVerificationList = function(verList) { 
		
		// Clear current result
		$("#verificationList").empty();
		
		// Create Table Header
		var tableHeader = '';		
		tableHeader += "<tr>";
        	tableHeader += "<td class='listTitle'>Student ID</td>";
        	tableHeader += "<td class='listTitle'>First Name</td>";
        	tableHeader += "<td class='listTitle'>Middle Name</td>";
        	tableHeader += "<td class='listTitle'>Last Name</td>";
        	tableHeader += "<td class='listTitle'>Gender</td>";
        	tableHeader += "<td class='listTitle'>DOB (mm/dd/yyyy)</td>";                                                            
            tableHeader += "<td class='listTitle'>City of Birth</td>";                                                          
            tableHeader += "<td class='listTitle'>Country of Birth</td>";                                                           
            tableHeader += "<td class='listTitle'>Country of Citizenship</td>"; 
            tableHeader += "<td class='listTitle'>Country of Residence</td>";  
            tableHeader += "<td class='listTitle' align='center'>Actions</td>";                                                          
		tableHeader += "</tr>";
		
		// Append Table Header to HTML
		$("#verificationList").append(tableHeader);
		
		if( verList.DATA.length == 0) {
			// No data returned, display message
			$("#verificationList").append("<tr bgcolor='#FFFFE6'><th colspan='11'>Your search did not return any results.</th></tr>");
		}
		
		// Loop over results and build the grid
		for(i=0;i<verList.DATA.length;i++) { 
			
			var studentID = verList.DATA[i][verList.COLUMNS.findIdx('STUDENTID')];		
			var firstName = verList.DATA[i][verList.COLUMNS.findIdx('FIRSTNAME')];
			var middleName = verList.DATA[i][verList.COLUMNS.findIdx('MIDDLENAME')];
			var familyLastName = verList.DATA[i][verList.COLUMNS.findIdx('FAMILYLASTNAME')];
			var sex = verList.DATA[i][verList.COLUMNS.findIdx('SEX')];
			var dob = verList.DATA[i][verList.COLUMNS.findIdx('DOB')];
			var cityBirth = verList.DATA[i][verList.COLUMNS.findIdx('CITYBIRTH')];
			var countryBirth = verList.DATA[i][verList.COLUMNS.findIdx('BIRTHCOUNTRY')];
			var countryCitizen = verList.DATA[i][verList.COLUMNS.findIdx('CITIZENCOUNTRY')];
			var countryResident = verList.DATA[i][verList.COLUMNS.findIdx('RESIDENTCOUNTRY')];
			
			// Create Table Rows
			var tableBody = '';	
			if (i % 2 == 0) {
				tableBody += "<tr bgcolor='#FFFFE6' id='" + studentID + "'>";
			} else {
				tableBody += "<tr bgcolor='#FFFFFF' id='" + studentID + "'>";
			}
				tableBody += "<td><a href='javascript:getStudentDetails(" + studentID + ");'>#" + studentID + "</a></td>"
				tableBody += "<td><a href='javascript:getStudentDetails(" + studentID + ");'>" + firstName + "</a></td>"
				tableBody += "<td><a href='javascript:getStudentDetails(" + studentID + ");'>" + middleName + "</a></td>"
				tableBody += "<td><a href='javascript:getStudentDetails(" + studentID + ");'>" + familyLastName + "</a></td>"
				tableBody += "<td>" + sex + "</td>"
				tableBody += "<td>" + dob + "</td>"
				tableBody += "<td>" + cityBirth + "</td>"
				tableBody += "<td>" + countryBirth + "</td>"
				tableBody += "<td>" + countryCitizen + "</td>"
				tableBody += "<td>" + countryResident + "</td>"
				tableBody += "<td align='center'><a href='javascript:getStudentDetails(" + studentID + ");'>[Edit]</a> &nbsp; | &nbsp; <a href='javascript:confirmReceived(" + studentID + ");'>[Received]</a></td>"
			tableBody += "</tr>";
			// Append table rows
			$("#verificationList").append(tableBody);
		} 
		
	}
	// --- END OF VERIFICATION LIST --- //


	// --- START OF STUDENT DETAILS --- //

	// Use an asynchronous call to get the student details. The function is called when the user selects a student. 
	var getStudentDetails = function(studentID) { 

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		s.setCallbackHandler(populateStudentDetails); 
		s.setErrorHandler(myErrorHandler); 
		// This time, pass the student ID to the getRemoteStudentByID CFC function. 
		s.getRemoteStudentByID(studentID);
	} 
	
	// Callback function to handle the results returned by the getVerificationList function and populate the form fields. 
	var populateStudentDetails = function(student) { 
		
		//var studentID = student.DATA[0][0];
		var studentID = student.DATA[0][student.COLUMNS.findIdx('STUDENTID')];		
		var firstName = student.DATA[0][student.COLUMNS.findIdx('FIRSTNAME')];
		var middleName = student.DATA[0][student.COLUMNS.findIdx('MIDDLENAME')];
		var familyLastName = student.DATA[0][student.COLUMNS.findIdx('FAMILYLASTNAME')];
		var sex = student.DATA[0][student.COLUMNS.findIdx('SEX')];
		var dob = student.DATA[0][student.COLUMNS.findIdx('DOB')];
		var cityBirth = student.DATA[0][student.COLUMNS.findIdx('CITYBIRTH')];
		var countryBirth = student.DATA[0][student.COLUMNS.findIdx('COUNTRYBIRTH')];
		var countryCitizen = student.DATA[0][student.COLUMNS.findIdx('COUNTRYCITIZEN')];
		var countryResident = student.DATA[0][student.COLUMNS.findIdx('COUNTRYRESIDENT')];
		
		// Populate fields
		$("#studentID").val(studentID);
		$("#firstName").val(firstName);
		$("#middleName").val(middleName);
		$("#familyLastName").val(familyLastName);
		$("#sex").val(sex);
		$("#dob").val(dob);
		$("#cityBirth").val(cityBirth);
		$("#countryBirth").val(countryBirth);
		$("#countryCitizen").val(countryCitizen);
		$("#countryResident").val(countryResident);
		
		// Slide down form field div
		if ($("#studentDetailDiv").css("display") == "none") {
			$("#studentDetailDiv").slideDown("fast");			
		}
		
		// Call animated scroll to anchor/id function
		goToByScroll();

	}

	var updateStudentDetail = function() { 
		// Store a list of errors used in the validation 
		var list_errors = '';
		
		// first name			
		if($("#firstName").val() == ''){
			list_errors = (list_errors + 'Please provide a first name \n')
		}
		// last name			
		if($("#familyLastName").val() == ''){
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
		if($("#cityBirth").val() == ''){
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
		submitStudentDetail();
		// do not remove - firefox needs it in order to work properly
		return false; 
	}				
	
	var submitStudentDetail = function() { 
	
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		s.setCallbackHandler(resetFormFields);
		s.setErrorHandler(myErrorHandler);
		
		// This time, pass the student data to the updateRemoteStudentByID CFC function. 
		s.updateRemoteStudentByID(
		  // Get values from the fields
		  $("#studentID").val(),
		  $("#firstName").val(),
		  $("#middleName").val(),
		  $("#familyLastName").val(),
		  $("#sex").val(),
		  $("#dob").val(),
		  $("#cityBirth").val(),
		  $("#countryBirth").val(),
		  $("#countryCitizen").val(),
		  $("#countryResident").val()
		);
		
	}

	var resetFormFields = function() {
		
		// Fade out form DIV
		$('#studentDetailDiv').slideUp('fast', function() {
			// Animation complete.
			
			// Set up page message, fade in and fade out after 2 seconds
			$("#studentDetailMessage").text( $("#firstName").val() + " " + $("#familyLastName").val() + " record has been saved successfully").fadeIn().fadeOut(3000);
			
			// Reset form fields
			$("#studentID").val("");
			$("#firstName").val("");
			$("#middleName").val("");
			$("#familyLastName").val("");
			$("#sex").val("");
			$("#dob").val("");
			$("#cityBirth").val("");
			$("#countryBirth").val("");
			$("#countryCitizen").val("");
			$("#countryResident").val("");
		});
		
		// Refresh Search List
		getVerificationList();
	}
	// --- END OF STUDENT DETAILS --- //
	
	
	// --- START OF VERICATION RECEIVED --- //
	var confirmReceived = function(studentID,studentName) {
		var answer = confirm("Are you sure you would like to check DS-2019 verification for student #" + studentID + " as received? \n You will no longer be able to update this record.")
		if (answer){
			setVerificationReceived(studentID);
		} 
	}	
	
	var setVerificationReceived = function(studentID) {

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		s.setCallbackHandler(verificationReceived(studentID)); 
		s.setErrorHandler(myErrorHandler); 
		// This time, pass the intRep ID to the getVerificationList CFC function. 
		s.confirmVerificationReceived(studentID);
		
	}
	
	var verificationReceived = function(studentID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#studentDetailMessage").text("Verification report for student #" + studentID + " received").fadeIn().fadeOut(3000);

		// Fade out record from search list
		$("#" + studentID).fadeOut("slow");
		
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

	.listTitle { 
		font-weight:bold;
	}

	.formTitle { 
		font-weight:bold;
		padding-top:15px;
		padding-left:10px;
	}

	.formField { 
		padding-left:10px;
	}

	.largeField {
		width:200px;
	}

	.smallField {
		width:80px;
	}

	.pageMessage {
		display:none;
		margin-bottom:10px;
		text-align:center;
		font-weight:bold;
		color:#006699;
	}

	.verList {
		display:none;
	}

	.studentDetail {
		display:none; 
		padding-top:10px;
		padding-bottom:20px;
	}
</style>

<cfoutput>

	<!--- This holds the student information messages --->
    <div id="studentDetailMessage" class="pageMessage"></div>
    
    <!--- This holds the form to update student information --->
    <div id="studentDetailDiv" class="studentDetail">
        
		<!--- Table Header --->    
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="DS-2019 Student Correction"
            tableRightTitle=""
        />
        
        <form name="studentDetail" id="studentDetail" onsubmit="return updateStudentDetail();">
            <input type="hidden" name="studentID" id="studentID" value="" />
            <table border="0" cellpadding="0" cellspacing="0" class="section" width="100%">
                <tr>
                	<td class="formTitle" colspan="6">Please make your corrections below and click on submit.</td>
				</tr>                    
                <tr>
                    <td class="formTitle"><label for="firstName">First Name</label></td>
                    <td class="formTitle"><label for="middleName">Middle Name</label></td>
                    <td class="formTitle"><label for="familyLastName">Last Name</label></td>
                    <td class="formTitle"><label for="sex">Gender</label></td>
                    <td class="formTitle"><label for="dob">DOB (mm/dd/yyyy)</label></td> 
				</tr>
                <tr>
                    <td class="formField"><input type="text" name="firstName" id="firstName" value="" class="largeField" maxlength="100" /></td>
                    <td class="formField"><input type="text" name="middleName" id="middleName" value="" class="largeField" maxlength="100" /></td>
                    <td class="formField"><input type="text" name="familyLastName" id="familyLastName" value="" class="largeField" maxlength="100" /></td>
                    <td class="formField">
                    	<select name="sex" id="sex">
                        	<option value=""></option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
						</select>                            
                    </td>
                    <td class="formField"><input type="text" name="dob" id="dob" value="" class="smallField" maxlength="10" /></td>
            	</tr> 
                <tr>                    
                    <td class="formTitle"><label for="cityBirth">City of Birth</label></td>                                                            
                    <td class="formTitle"><label for="countryBirth">Country of Birth</label></td>                                                            
                    <td class="formTitle"><label for="countryCitizen">Country of Citizenship</label></td> 
                    <td class="formTitle"><label for="countryResident">Country of Residence</label></td>   
                    <td class="formTitle">&nbsp;</td>                                                          
                </tr>            
				<tr>	
                    <td class="formField"><input type="text" name="cityBirth" id="cityBirth" value="" class="largeField" maxlength="100" /></td>
                    <td class="formField">
                    	<select name="countryBirth" id="countryBirth">
                        	<option value=""></option>
                        	<cfloop query="qCountryList">
                            	<option value="#qCountryList.countryID#">#qCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td class="formField">
                    	<select name="countryCitizen" id="countryCitizen">
                        	<option value=""></option>
                        	<cfloop query="qCountryList">
                            	<option value="#qCountryList.countryID#">#qCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td class="formField">
                    	<select name="countryResident" id="countryResident">
                        	<option value=""></option>
                        	<cfloop query="qCountryList">
                            	<option value="#qCountryList.countryID#">#qCountryList.countryName#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td class="formField"><input type="submit" name="Save" value="Save" /></td>
				</tr>                    
            </table>
        </form>
        
		<!--- Table Footer --->    
        <gui:tableFooter />
        
	</div>


	<!--- Table Header --->    
    <gui:tableHeader
        imageName="students.gif"
        tableTitle="DS-2019 Verification List"
        tableRightTitle=""
    />
    
    <!--- List Options --->
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%" style="padding:15px;">
        <tr>
            <td class="listTitle">
                <cfif CLIENT.userType EQ 11>
					<!--- Branch --->
                    International Representative: &nbsp;                
                    <select name="branchID" id="branchID" onchange="getVerificationList();">
                        <cfloop query="qIntRep">
                            <option value="#qIntRep.userID#" <cfif FORM.branchID EQ qIntRep.userID> selected="selected" </cfif> >#qIntRep.businessName#</option>
                        </cfloop>
                    </select>
                    <input type="hidden" name="intRep" id="intRep" value="#FORM.intRep#" />
                <cfelse>
                	<!--- Intl. Rep. --->
                    International Representative: &nbsp;                
                    <select name="intRep" id="intRep" onchange="getVerificationList();">
                        <cfif VAL(CLIENT.userType) AND CLIENT.userType LTE 4>
                            <option value="0"></option>
                        </cfif>
                        <cfloop query="qIntRep">
                            <option value="#qIntRep.userID#" <cfif FORM.intRep EQ qIntRep.userID> selected="selected" </cfif> >#qIntRep.businessName#</option>
                        </cfloop>
                    </select>
                </cfif>
            </td>                
			<td><input name="send" type="submit" value="Submit" onclick="getVerificationList();" /></td>
        </tr>            
    </table>

    <!--- Verification List --->
    <table id="verificationList" border="0" cellpadding="4" cellspacing="0" class="section" width="100%"></table>
                                   
    <!--- Table Footer --->    
    <gui:tableFooter />
	
</cfoutput>    