// JavaScript Document

// Auto Focus - Set cursor to username field
$(document).ready(function() {
	
	if ( $("#loginEmail").val() == '' ) {
		$("#loginEmail").focus();
	} else {
		$("#loginPassword").focus();
	}
	
});


$(function() {
	$('.password').pstrength();
});

// Slide down form field div
var displayForgotPass = function() { 
	
	if ($("#forgotPassForm").css("display") == "none") {
		$("#loginForm").slideToggle(500);
		$("#forgotPassForm").slideToggle(500);	
		$("#forgotEmail").focus();
	} else {
		$("#forgotPassForm").slideToggle(500);	
		$("#loginForm").slideToggle(500);
		$("#loginEmail").focus();
	}
	
}