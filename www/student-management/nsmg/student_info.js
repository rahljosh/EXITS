/********** Java Script functions for student_info.cfm  *************/

var currentTime = new Date()
var month = currentTime.getMonth() + 1
var day = currentTime.getDate()
var year = currentTime.getFullYear()
if (day < 10) 
	day = "0"+day;
if (month < 10) 
	month = "0"+month;

// opens small pop up in a defined format
var newwindow;

var OpenSmallW = function(url) {	
	newwindow=window.open(url, 'Application', 'height=300, width=400, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

var OpenMediumW = function(url) {		
	newwindow=window.open(url, 'Application', 'height=500, width=400, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

// opens letters in a defined format
var OpenLetter = function(url) {		
	newwindow=window.open(url, 'Application', 'height=580, width=820, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

//open region / program history
var OpenHistory = function(url) {		
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

//open region / program history
var OpenHistoryLarge = function(url) {		
	newwindow=window.open(url, 'Application', 'height=400, width=800, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

// open online application 
var OpenApp = function(url) {
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

// Send online applications 
var SendEmail = function(url, setHeight, setWidth) {
	newwindow=window.open(url, 'Application', 'height=' + setHeight + ', width=' + setWidth + ', location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=no'); 
	if (window.focus) {newwindow.focus()}
}

// DS 2019 verification_box  
var PopulateDS2019Box = function() {	
	if (document.studentForm.verification_box.checked) {
		document.studentForm.verification_form.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.verification_form.value = '';
	}
}

// Student Canceled  
var PopulateCancelBox = function() {	
	if (document.studentForm.student_cancel.checked) {
		document.studentForm.date_canceled.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_canceled.value = '';
	}
}

// depositReceived
var PopulateDepositReceivedBox = function() {	
	if (document.studentForm.depositReceived.checked) {
		document.studentForm.date_depositReceived.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_depositReceived.value = '';
	}
}

// Payment Received 
var PopulateFinalPaymentBox = function() {	
	if (document.studentForm.finalPayment.checked) {
		document.studentForm.date_finalPayment.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_finalPayment.value = '';
	}
}

// check Drawn
var PopulateCheckDrawnBox = function() {	
	if (document.studentForm.checkDrawn.checked) {
		document.studentForm.date_checkDrawn.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_checkDrawn.value = '';
	}
}

// check sent to school
var PopulateCheckSentSchoolBox = function() {	
	if (document.studentForm.checkSentSchool.checked) {
		document.studentForm.date_checkSentSchool.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_checkSentSchool.value = '';
	}
}

// i20 sent
var Populatei20SentBox = function() {	
	if (document.studentForm.i20Sent.checked) {
		document.studentForm.date_i20Sent.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_i20Sent.value = '';
	}
}

// i20 Received
var Populatei20ReceivedBox = function() {	
	if (document.studentForm.i20Received.checked) {
		document.studentForm.date_i20Received.value = (month + "/" + day + "/" + year);
	} else {
		document.studentForm.date_i20Received.value = '';
	}
}
// Program Reason
var displayProgramReason = function(previousProgramID, selectedProgramID) {
	// Display Reason	
	if ( previousProgramID > '0' && selectedProgramID != previousProgramID) {
		$("#trProgramHistory").fadeIn();
		$("#program_reason").focus();
	} else {
		$("#program_reason").val('');
		$("#trProgramHistory").fadeOut();
	}
}

// Region Reason
var displayRegionReason = function(previousRegionID, selectedRegionID) {
	// Display Reason	
	if ( previousRegionID > '0' && selectedRegionID != previousRegionID) {
		$("#trRegionHistory").fadeIn();
		$("#region_reason").focus();
	} else {
		$("#region_reason").val('');
		$("#trRegionHistory").fadeOut();
	}
}

// Region Guaranteed
var displayGuaranteed = function(selectedRegionID) {	
	
	if ( selectedRegionID == 0 && document.studentForm.regionguar[0].checked ) {
		alert("You must select a region in order to view Regions and States Preferences");
		document.studentForm.regionguar[1].checked = true;
	}
	
	if ( document.studentForm.regionguar[0].checked && selectedRegionID != '0')  {
		// Hide fields
		$(".displayNoGuarantee").fadeOut();
		// Display fields
		$(".displayGuarantee").fadeIn();
	} else {
	   	// Reset values
	   	$("#rguarantee").val('');
	   	$("#state_guarantee").val(0);
		// Hide fields
	   	$(".displayGuarantee").fadeOut();
		// Display fields
		$(".displayNoGuarantee").fadeIn();
	}
}

// Fee waived = no if State guarantee is choosen
var FeeWaived = function() {	
  if (document.studentForm.state_guarantee.value != '0') {
		document.studentForm.jan_app[0].checked = true ;
	} else {
	   if (fwaive = '1') {
		document.studentForm.jan_app[1].checked = true ; 
	   }
	}
}

/*
var FeeWaived2 = function() {	
  if (document.studentForm.state_guarantee.value != '0') {
		document.studentForm.jan_app[0].checked = true ;
		alert("Fee waived must be NO for State Guarantees.");
	}			  			  	
}
*/

// Region / State Guarantee Choices
var formValidation = function(previousRegionID, previousProgramID) {
	
	// Get Current Values
	selectedProgramID = $("#program").val();
	currentProgramReason = $("#program_reason").val();
	
	selectedRegionID = $("#region").val();
	currentRegionReason = $("#region_reason").val();
	
	if ( (document.studentForm.regionguar[0].checked) && (document.studentForm.rguarantee.value == '0') && (document.studentForm.state_guarantee.value == '0') ) {
		alert("You must select either a State or a Region Preference.");
	  	return false; 
	}	
	
	if ( (document.studentForm.regionguar[0].checked) && (document.studentForm.rguarantee.value != '0') && (document.studentForm.state_guarantee.value != '0') ) {
		alert("You cannot select both region and state preference. You must select either a State or a Region preference.");
		return false; 
	}			  	

   	// FEE WAIVED
   	/*
	var Counter = 0;
   	for (i=0; i<document.studentForm.jan_app.length; i++){
		if (document.studentForm.jan_app[i].checked){
			Counter++; 
		}
   	}
   
	if ( (document.studentForm.regionguar[0].checked) && (Counter == 0) ) {
		alert("You must select either Yes or NO for the Regional Fee Waived field.");
		return false; 
	}		
	*/
	
   	// CHECK DIRECT PLACEMENT	 
   	var Counter2 = 0;
	
   	for (i=0; i<document.studentForm.direct_placement.length; i++) {
		if (document.studentForm.direct_placement[i].checked){
        	Counter2++; }
	   }
	   
   	if (Counter2 == 0) {
		alert("You must select either Yes or NO for Direct Placement field.");
		return false; 
	}	
	
	// CANCELLING A STUDENT  
	if ((document.studentForm.student_cancel.checked) && (document.studentForm.Reason_canceled.value == '')) {
		alert("In order to cancel this student you must enter a reason.");
		document.studentForm.Reason_canceled.focus(); 
		return false; 
	} 
	
	// REGION HISTORY
	if ((previousRegionID > 0) && (selectedRegionID != previousRegionID) && (currentRegionReason == '')) {
		alert("In order to change the region you must enter a reason (for history purpose).");
		$("#trRegionHistory").fadeIn();
		$("#region_reason").focus();
		return false; 
	} 
	
	// PROGRAM HISTORY
	if ((previousProgramID > '0') && (selectedProgramID != previousProgramID) && (currentProgramReason == '')) {
		alert("In order to change the program you must enter a reason (for history purpose).");
		$("#trProgramHistory").fadeIn();
		$("#program_reason").focus();
		return false; 
	}
	
	//PRE AYP
	if (((document.studentForm.english_check.checked) && (document.studentForm.ayp_englsh.value != 0)) && ((document.studentForm.orientation_check.checked) && (document.studentForm.ayp_orientation.value != 0))) {	
		alert("The student cannot participate in both English and Orientation Camps. Please select only one.");
		return false; 
	}
	
}