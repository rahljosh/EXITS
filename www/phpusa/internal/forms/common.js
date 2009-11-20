// Common JavaScript functions
// Author: Gerd Riesselmann
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



// After loading page, do what should be done
addEvent(window, 'load', initFocus);

// Ads eventhandelr to given object
function addEvent(obj, evType, fn)
{
	if (obj.addEventListener)
	{
   		obj.addEventListener(evType, fn, false);
   		return true;
	} 
	else if (obj.attachEvent)
	{
   		var r = obj.attachEvent("on"+evType, fn);
   		return r;
 	} 
 	else 
 	{
   		return false;
 	}
}

// Sets focus to first input with class "focus"
function initFocus()
{
	if (findFocus('input'))
		return;
		
	if (findFocus('select'))
		return;
		
	if (findFocus('textarea'))
		return;
}

function findFocus(elementName)
{
	var inputs = document.getElementsByTagName(elementName);
	for (var i = 0; i < inputs.length; i++)
	{
		if (inputs[i].className.indexOf('focus') != -1 )
		{
			inputs[i].focus();
			return true;			
		}
	}
	return false;
}
