// JavaScript Document

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


