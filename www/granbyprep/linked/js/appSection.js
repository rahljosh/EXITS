// JavaScript Document

/**********************************************************
	AdminTool
**********************************************************/

// Pop Up Application 
var popUpApplication = function(hashID) { 	
	//alert(hashID);
	setURL = '../admissions/index.cfm?action=initial&hashID=' + hashID;
	window.open(setURL, 'onlineApplication', 'height=600, width=1100, toolbar=0, scrollbars=1, status=1, resizable=1').focus();
}

/**********************************************************
	Online Application
**********************************************************/

// Word Count - Used on _section5.cfm
var countWord = function(field, displayCount) {	
	var number = 0;
	var matches = $(field).val().match(/\b/g);
	if(matches) {
		number = matches.length/2;
	}
	// Display Total of Words on span
	$(displayCount).text(' - ' + number + ' word' + (number != 1 ? 's' : '') + ' approx');
}	

// Display Credit Card Image - Used on _applicationFee.cfm
var displayCreditCard = function(selectedCard) {

	$("#displayCardImage").removeClass();
	$("#displayCardImage").addClass("card" + selectedCard); 

}


// Slide down steateform field div
var displayStateField = function(countryValue, usDiv, nonUsDiv, usFieldClass, nonUsFieldClass) { 

	if ( countryValue == 211 ) {
		// US Selected	
		$("#" + nonUsDiv).slideUp("slow");
		$("#" + usDiv).slideDown("slow");
		// clear the other value
		$("." + nonUsFieldClass).val("");
	} else {
		// Non Us Selected
		$("#" + usDiv).slideUp("slow");
		$("#" + nonUsDiv).slideDown("slow");	
		// clear the other value
		$("." + usFieldClass).val("");
	}

}


// Slide down stateForm field div
var displaySemesterDetail = function(semesterSelected) { 

	if ( semesterSelected == 3 ) {
		// Display Please Specify
		$("#semesterDetailDiv").slideDown("slow");
	} else {
		// Hide Please Specify
		$("#semesterDetailDiv").slideUp("slow");
	}

}

