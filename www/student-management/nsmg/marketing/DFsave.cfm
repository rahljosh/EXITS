<cfif client.companyid lte 5 OR client.companyid eq 12>
	<cfset companyImage = 1>
<cfelseif client.companyid eq 10>
	<cfset companyImage = 10>
</cfif>
<Cfquery name="repInfo" datasource="MySQL">
select firstname, lastname, email, phone
from smg_users
where userid = #client.userid#
</cfquery>

<cfdocument format="PDF" margintop=".25" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="Make_A_Difference_World.pdf" >


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Making a Difference</title>
<style type="text/css">
<!--
body {
	background: #FFF;
	margin: 0;
	padding: 0;
	
}
.text{
	color: #000;
	font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;
	font-size: 60px;
	font-style: italic;
	line-height: 85px;
}

/* ~~ Element/tag selectors ~~ */
ul, ol, dl { /* Due to variations between browsers, it's best practices to zero padding and margin on lists. For consistency, you can either specify the amounts you want here, or on the list items (LI, DT, DD) they contain. Remember that what you do here will cascade to the .nav list unless you write a more specific selector. */
	padding: 0;
	margin: 0;
}
h1, h2, h3, h4, h5, h6, p {
	margin-top: 0;	 /* removing the top margin gets around an issue where margins can escape from their containing div. The remaining bottom margin will hold it away from any elements that follow. */
	padding-right: 55px;
	padding-left: 55px; /* adding the padding to the sides of the elements within the divs, instead of the divs themselves, gets rid of any box model math. A nested div with side padding can also be used as an alternate method. */
	font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
}
a img { /* this selector removes the default blue border displayed in some browsers around an image when it is surrounded by a link */
	border: none;
}
/* ~~ Styling for your site's links must remain in this order - including the group of selectors that create the hover effect. ~~ */
a:link {
	color: #000;
	text-decoration: none; /* unless you style your links to look extremely unique, it's best to provide underlines for quick visual identification */
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover, a:active, a:focus { /* this group of selectors will give a keyboard navigator the same hover experience as the person using a mouse. */
	text-decoration: underline;
	color: #BF2125;
}

/* ~~ this fixed width container surrounds the other divs ~~ */
.container {
	width: 2550px;
	background: #FFF;
	margin: 0 auto; /* the auto value on the sides, coupled with the width, centers the layout */
}

/* ~~ the header is not given a width. It will extend the full width of your layout. It contains an image placeholder that should be replaced with your own linked logo ~~ */
.header {
	background: #FFF;
}

/* ~~ This is the layout information. ~~ 

1) Padding is only placed on the top and/or bottom of the div. The elements within this div have padding on their sides. This saves you from any "box model math". Keep in mind, if you add any side padding or border to the div itself, it will be added to the width you define to create the *total* width. You may also choose to remove the padding on the element in the div and place a second div within it with no width and the padding necessary for your design.

*/

.content {
	padding: 10px 0;
}

/* ~~ The footer ~~ */
.footer {
	padding: 0px 0;
	background: #000;
}

/* ~~ miscellaneous float/clear classes ~~ */
.fltrt {  /* this class can be used to float an element right in your page. The floated element must precede the element it should be next to on the page. */
	float: right;
	margin-left: 8px;
}
.fltlft { /* this class can be used to float an element left in your page. The floated element must precede the element it should be next to on the page. */
	float: left;
	margin-right: 8px;
}
.clearfloat { /* this class can be placed on a <br /> or empty div as the final element following the last floated div (within the #container) if the #footer is removed or taken out of the #container */
	clear:both;
	height:0;
	font-size: 1px;
	line-height: 0px;
}
.info {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 55px;
	font-style: normal;
	color: #000;
	text-align: center;
	padding-top: 50px;
	background-color: #AFB2CA;
	padding-bottom: 60px;
}
.container .header table tr td h1 {
	font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
	font-size: 110px;
	font-style: normal;
	color: #000;
	text-align: center;
}
-->
</style></head>

<body>
<cfoutput>
<div class="container">
  <div class="header"><table width="2550" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="121" rowspan="2"><a href="http://www.case-usa.org"><img src="images/print/#companyImage#_MDlarge_01.png" width="565" height="478" /></a></td>
    <td width="491" height="85"><h1>Perhaps Together, We CAN Make a Difference in the World...</h1></td>
  </tr>
  <tr>
    <td><a href="#companyInfo.url#"><img src="images/print/#companyImage#_MDlarge_03.png" width="1952" height="117" /></a></td>
  </tr>
</table>
    <!-- end .header --></div>
  <div class="content">
  <img src="images/print/#companyImage#_MDlarge_05.png" width="2518" height="1289" alt="group shot" /> <img src="images/print/#companyImage#_MDlarge_07.png" width="2520" height="164" /><br />
    <br />
    <table width="2550" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="228" rowspan="2"><img src="images/print/MDlarge_09.png" width="985" height="1026" /></td>
    <td width="342" height="123" class="text"><br /><p>#companyInfo.companyname# (#companyInfo.companyshort_nocolor#) is a non-profit, educational and cultural organization founded in 1988 on the belief that international student exchange promotes understanding, respect and goodwill among people of all nations. #companyInfo.companyshort_nocolor# brings foreign teens together with US volunteer host families. Our program grants students, host families and entire communities the ability to discover and value other cultures, which ultimately increases international harmony and creates lasting friendships.</p><BR /></td>
  </tr>
  <tr>
    <td class="info"><p>If you are interested in learning more about student exchange, please visit our website <strong>#companyInfo.url#</strong> or contact <strong>#repInfo.firstname# #repInfo.lastname#</strong> at <strong>#repInfo.phone#</strong> or email <strong>#repInfo.email#</strong>.</p></td>
  </tr>
</table>
<!-- end .content --></div>
  <div class="footer">
    <img src="images/md_11.png" width="569" height="14" />    <!-- end .footer --></div>
  <!-- end .container --></div>
  </cfoutput>
</body>
</html>
</cfdocument>