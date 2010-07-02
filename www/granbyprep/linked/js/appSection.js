// JavaScript Document

// Word Count - Used on _section3.cfm
function countWord(field, displayCount) {
	var number = 0;
	var matches = $(field).val().match(/\b/g);
	if(matches) {
		number = matches.length/2;
	}
	// Display Total of Words on span
	$(displayCount).text(' - ' + number + ' word' + (number != 1 ? 's' : '') + ' approx');
}	

