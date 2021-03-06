// JavaScript Document
// Stores base javascript functions that can be used in any page of the application

// jQuery Date Picker Function // $(document).ready(function() { }
$(function() {
	$(".datePicker").datepicker({
		//numberOfMonths: 3,								
		showButtonPanel: true,
		changeMonth: true,
		changeYear: true
	});
	
	$('.timePicker').timepicker();
});


function getCurrentDate() {
	var d = new Date();
	var curr_day = d.getDate();
	var curr_month = d.getMonth();
	var curr_year = d.getFullYear();
	var curr_date = curr_month + "/" + curr_day + "/" + curr_year;

	return curr_date;
}


function checkInsertDate(CKname, FRname) {	
	if ($('#' + CKname).attr('checked')) {
		$("#" + FRname).val(getCurrentDate());
	} else { 
		$("#" + FRname).val('');
	}
}	


function openPopUp(url, width, height) {
	window.open(url,"","scrollbars=yes,resizable=yes,width=" + width + ",height=" + height);
	// return false;
}

function OpenWindow(url) {
	newwindow=window.open(url, 'NewWindow', 'height=350, width=720, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {
		newwindow.focus()
	}
}

// Display DIV
function displayDiv(divID) {
	if($("#" + divID).css("display") == "none"){
		$("#" + divID).fadeIn("slow");
	} else {
		$("#" + divID).fadeOut("slow");	
	}
}	

// Hide Div with the same class name and display selected div
function hideClass(className) {
	// Looping through a set of elements with the same class name
	$("." + className).each(function(i) {
									
		if($(this).css("display") != "none"){
			$(this).hide();
			//$(this).fadeOut("slow");	
		}
		
	});
}	

// Display Classes
function displayClass(className) {
	// Looping through a set of elements with the same class name
	$("." + className).each(function(i) {
									
		if($(this).css("display") == "none"){
			$(this).fadeIn("slow");
		} else {
			$(this).fadeOut("slow");	
		}
		
	});
}	



