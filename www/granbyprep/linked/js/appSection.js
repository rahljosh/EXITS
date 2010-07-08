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
