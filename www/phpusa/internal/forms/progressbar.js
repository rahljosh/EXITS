// A JavaScript Progress Bar
// Written by Gerd Riesselmann
// http://www.gerd-riesselmann.net
//
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



//add Elements to qualitymeter div
function initProgressBar(caption)
{
	var _container = document.getElementById("the_progressbar");
	if (_container)
	{
		_currentStyle = _container.style;
		if (_currentStyle != null)
		{
			_currentStyle.display = "block";
		}
		
		// create the caption
		var _caption = document.createElement("span");
		_caption.id = "progress_caption";
		var _text = document.createTextNode(caption);
		_caption.appendChild(_text);
		_container.appendChild(_caption);
		
		//Create The Left progress part
		//Looks like <span class="right" style="border: 1px solid black; padding: 0 50px; height: 1.2em; background-color: green;">
		var _progressL = document.createElement("span");
		_progressL.id = "progressl";
		var _style = _progressL.style;
		_style.backgroundColor = "green";
		_style.borderLeft = "1px solid black";
		_style.borderTop = "1px solid black";
		_style.borderBottom = "1px solid black";
		_style.padding = "0 0px";
		_style.height = "1.2em";
		_style.zIndex = 100;

		_container.appendChild(_progressL);
		
		// Create the Rigth progress part 
		// Looks like Left part, but background is transparent
		var _progressR = document.createElement("span");
		_progressR.id = "progressr";
		_style = _progressR.style;
		_style.borderRight = "1px solid black";
		_style.borderTop = "1px solid black";
		_style.borderBottom = "1px solid black";
		_style.padding = "0 100px";
		_style.height = "1.2em";		

		_container.appendChild(_progressR);
	}
}

function setProgressBarValue(value)
{
	var _value = parseInt(value);
	if (_value == NaN)
		_value = 0;
	
	if (_value > 100)
		_value = 100;
		
	_progressL = document.getElementById("progressl");
	_progressR = document.getElementById("progressr");
	if (_progressL && _progressR)
	{
		_progressL.style.paddingLeft = _value + "px";
		_progressL.style.paddingRight = _value + "px";
		_progressR.style.paddingLeft = (100 - _value) + "px";
		_progressR.style.paddingRight = (100 - _value) + "px";
	}		
}

