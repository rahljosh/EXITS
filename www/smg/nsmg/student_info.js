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
function OpenSmallW(url) {
	newwindow=window.open(url, 'Application', 'height=300, width=400, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

function OpenMediumW(url) {
	newwindow=window.open(url, 'Application', 'height=500, width=400, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

// opens letters in a defined format
function OpenLetter(url) {
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

//open region / program history
function OpenHistory(url) {
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

//open placement management
function OpenPlaceMan(url) {
	newwindow=window.open(url, 'Application', 'height=550, width=600, location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=no'); 
	if (window.focus) {newwindow.focus()}
}

// open online application 
function OpenApp(url)
{
	newwindow=window.open(url, 'Application', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}

// Send online applications 
function SendEmail(url)
{
	newwindow=window.open(url, 'Application', 'height=410, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=no'); 
	if (window.focus) {newwindow.focus()}
}

// DS 2019 verification_box  
function PopulateDS2019Box() {
	if (document.StudentInfo.verification_box.checked) {
		document.StudentInfo.verification_form.value = (month + "/" + day + "/" + year);
	}
	else {
		document.StudentInfo.verification_form.value = '';
	}
}

// Student Canceled  
function PopulateCancelBox() {
	if (document.StudentInfo.student_cancel.checked) {
		document.StudentInfo.date_canceled.value = (month + "/" + day + "/" + year);
	}
	else {
		document.StudentInfo.date_canceled.value = '';
	}
}

// Region Guaranteed
function Guaranteed(){
 if ((document.StudentInfo.region.value == '0') && (document.StudentInfo.regionguar[0].checked)) {
	alert("You must select a region in order to view Regions and States Guarantees");
	document.StudentInfo.regionguar[1].checked = true;
 }
 if ((document.StudentInfo.regionguar[0].checked) && (document.StudentInfo.region.value != '0'))  {
	 document.getElementById('reg_guarantee').style.display = 'inline';
	 document.getElementById('sta_guarantee').style.display = 'inline';
	 document.getElementById('fee_waived').style.display = 'inline';					 
	 document.getElementById('nreg_guarantee').style.display = 'none';
	 document.getElementById('nsta_guarantee').style.display = 'none';
	 document.getElementById('nfee_waived').style.display = 'none';
 } else {
	 document.getElementById('nreg_guarantee').style.display = 'inline';
	 document.getElementById('nsta_guarantee').style.display = 'inline';
	 document.getElementById('nfee_waived').style.display = 'inline';
	 document.getElementById('reg_guarantee').style.display = 'none';
	 document.getElementById('sta_guarantee').style.display = 'none';
	 document.getElementById('fee_waived').style.display = 'none';		 
 }
}

// Fee waived = no if State guarantee is choosen
function FeeWaived(fwaive) {
  if (document.StudentInfo.state_guarantee.value != '0') {
		document.StudentInfo.jan_app[0].checked = true ;
	} else {
	   if (fwaive = '1') {
		document.StudentInfo.jan_app[1].checked = true ; 
	   }
	}
}
function FeeWaived2() {
  if (document.StudentInfo.state_guarantee.value != '0') {
		document.StudentInfo.jan_app[0].checked = true ;
		alert("Fee waived must be NO for State Guarantees.");
	}			  			  	
}

// Region / State Guarantee Choices
function CheckGuarantee(sturegion, stuprogram) {
  if ((document.StudentInfo.regionguar[0].checked) && (document.StudentInfo.rguarantee.value == '0') && (document.StudentInfo.state_guarantee.value == '0')) {
	 alert("You must select either a State or a Region Guarantee.");
	  return false; }			  	
  if ((document.StudentInfo.regionguar[0].checked) && (document.StudentInfo.rguarantee.value != '0') && (document.StudentInfo.state_guarantee.value != '0')) {
	 alert("You cannot select both region and state guarantee. You must select either a State or a Region Guarantee.");
	  return false; }			  	

   // FEE WAIVED
   var Counter = 0;
   for (i=0; i<document.StudentInfo.jan_app.length; i++){
      if (document.StudentInfo.jan_app[i].checked){
         Counter++; }
   }
   if ((document.StudentInfo.regionguar[0].checked) && (Counter == 0)) {
	 alert("You must select either Yes or NO for the Regional Fee Waived field.");
	 return false; }		
	 
   // CHECK DIRECT PLACEMENT	 
   var Counter2 = 0;
   for (i=0; i<document.StudentInfo.direct_placement.length; i++) {
      if (document.StudentInfo.direct_placement[i].checked){
         Counter2++; }
   }
   if (Counter2 == 0) {
	 alert("You must select either Yes or NO for Direct Placement field.");
	 return false; }	

	// if ((document.StudentInfo.direct_placement[1].checked) && (document.StudentInfo.direct_place_nature.value == '')) {	
	// alert("You must enter the nature of direct placement.");
	// document.StudentInfo.direct_place_nature.focus();
	// return false; }

	// CANCELLING A STUDENT  
   if ((document.StudentInfo.student_cancel.checked) && (document.StudentInfo.Reason_canceled.value == '')) {
	 alert("In order to cancel this student you must enter a reason.");
	 document.StudentInfo.Reason_canceled.focus(); 
	 return false; } 
	
	// REGION HISTORY
   if ((sturegion > 0) && (document.StudentInfo.region.value != sturegion) && (document.StudentInfo.region_reason.value == '')) {
	alert("In order to change the region you must enter a reason (for history purpose).");
	document.getElementById('region_history').style.display = 'inline';
	document.StudentInfo.region_reason.focus(); 
	return false; } 
	
	// PROGRAM HISTORY
   if ((stuprogram > '0') && (document.StudentInfo.program.value != stuprogram) && (document.StudentInfo.program_reason.value == '')) {
	alert("In order to change the program you must enter a reason (for history purpose).");
	document.getElementById('program_history').style.display = 'inline';
	document.StudentInfo.program_reason.focus(); 
	return false; }
	
	//PRE AYP
   if (((document.StudentInfo.english_check.checked) && (document.StudentInfo.ayp_englsh.value != 0)) && ((document.StudentInfo.orientation_check.checked) && (document.StudentInfo.ayp_orientation.value != 0))) {	
	alert("The student cannot participate in both English and Orientation Camps. Please select only one.");
	return false; }
	
}