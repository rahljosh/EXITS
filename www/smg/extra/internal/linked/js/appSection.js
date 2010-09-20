// JavaScript Document	

// Show/hide request placement
var showHideRequestPlacement = function(selectedOption) { 
	if ( selectedOption == 'CSB-Placement' ) {
		// Show Request Placement Field
		$("#divRequestPlacement").slideDown("slow");
	} else {
		// Hide Request Placement Field
		$("#divRequestPlacement").slideUp("slow");
		// Clear Field
		
	}

}
