// A password quality meter
// Written by Gerd Riesselmann
// http://www.gerd-riesselmann.net
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// This program uses code from mozilla.org (http://mozilla.org)

// On start up, initialize the qualiy meter
addEvent(window, "load", initQualityMeter);

//init 
function initQualityMeter()
{
	var _pwd = document.getElementById('newpwd1');
	if (_pwd)
	{
		addEvent(_pwd, "keypress", updateQualityMeter);
		initProgressBar("Password Quality: ");
		updateQualityMeter();
	}
}


function updateQualityMeter()
{
	var quality = getPasswordStrength();
	setProgressBarValue(quality);
}

// Function taken from Mozilla Code:
// http://lxr.mozilla.org/seamonkey/source/security/manager/pki/resources/content/password.js
function getPasswordStrength()
{
	// Here is how we weigh the quality of the password
	// number of characters
	// numbers
	// non-alpha-numeric chars
	// upper and lower case characters

	var pw = document.getElementById('newpwd1').value;
	//  alert("password='" + pw +"'");

	//length of the password
	var pwlength=(pw.length);
	if (pwlength>5)
		pwlength=5;


	//use of numbers in the password
	var numnumeric = pw.replace (/[0-9]/g, "");
	var numeric=(pw.length - numnumeric.length);
	if (numeric>3)
		numeric=3;

	//use of symbols in the password
	var symbols = pw.replace (/\W/g, "");
	var numsymbols=(pw.length - symbols.length);
	if (numsymbols>3)
		numsymbols=3;

	//use of uppercase in the password
	var numupper = pw.replace (/[A-Z]/g, "");
	var upper=(pw.length - numupper.length);
	if (upper>3)
		upper=3;


	var pwstrength=((pwlength*10)-20) + (numeric*10) + (numsymbols*15) + (upper*10);

	// make sure we're give a value between 0 and 100
	if ( pwstrength < 0 ) {
		pwstrength = 0;
	}

	if ( pwstrength > 100 ) {
		pwstrength = 100;
	}

	return pwstrength;
}
