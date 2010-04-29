/***********************************************************************************
*	(c) Ger Versluis 2000 version 5.41 24 December 2001	          *
*	For info write to menus@burmees.nl		          *
*	You may remove all comments for faster loading	          *		
***********************************************************************************/

	var NoOffFirstLineMenus=7;			// Number of first level items
	var LowBgColor='#5564B5';			// Background color when mouse is not over
	var LowSubBgColor='#5564B5';			// Background color when mouse is not over on subs
	var HighBgColor='#93A0B2';			// Background color when mouse is over
	var HighSubBgColor='#93A0B2';			// Background color when mouse is over on subs
	var FontLowColor='#FFFFFF';			// Font color when mouse is not over
	var FontSubLowColor='#FFFFFF';			// Font color subs when mouse is not over
	var FontHighColor='#FFFFFF';			// Font color when mouse is over
	var FontSubHighColor='#FFFFFF';			// Font color subs when mouse is over
	var BorderColor='';			// Border color
	var BorderSubColor='#5B5B5B';			// Border color for subs
	var BorderWidth=1;				// Border width
	var BorderBtwnElmnts=1;			// Border between elements 1 or 0
	var FontFamily="arial,comic sans ms,technical"	// Font family menu items
	var FontSize=9;				// Font size menu items
	var FontBold=1;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
	var MenuCentered='center';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=.2;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=.7;			// vertical overlap child/ parent
	var StartTop=85;				// Menu offset x coordinate
	var StartLeft=1;				// Menu offset y coordinate
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var LeftPaddng=3;				// Left padding
	var TopPaddng=2;				// Top padding
	var FirstLineHorizontal=1;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=1000;			// delay before menu folds in
	var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';			// Frame where first level appears
	var SecLineFrame='space';			// Frame where sub levels appear
	var DocTargetFrame='space';			// Frame where target documents appear
	var TargetLoc='';				// span id for relative positioning
	var HideTop=0;				// Hide first level when loading new document 1 or 0
	var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
	var ShowArrow=0;				// Uses arrow gifs when 1
	var KeepHilite=1;				// Keep selected path highligthed
	var Arrws=['tri.gif',5,10,'tridown.gif',10,5,'trileft.gif',5,10];	// Arrow source, width and height

function BeforeStart(){return}
function AfterBuild(){return}
function BeforeFirstOpen(){return}
function AfterCloseAll(){return}


// Menu tree
//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

Menu1=new Array("Home","index_ise.cfm","",0,20,40);
Menu2=new Array("Host Family Info","host_family_info.cfm","",0,20,100);
Menu3=new Array("Student Info","student_info.cfm","",0,20,80);
Menu4=new Array("FAQ's","","",3,20,53);
		Menu4_1=new Array("Student FAQ's","student_faq.cfm","",0,20,110);
		Menu4_2=new Array("Host FAQ's","host_faq.cfm","",0,20,90);
		Menu4_3=new Array("High School FAQ's","high_school_faq.cfm","",0,20,120);		
Menu5=new Array("Contact ISE","contact.cfm","",0,20,80);
Menu6=new Array("Message from Headquarters","message.cfm","",0,20,180);
Menu7=new Array("Webmail","https://www.iseusa.com:32001/mail","",0,20,90);
