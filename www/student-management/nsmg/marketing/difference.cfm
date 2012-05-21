<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Making a Difference</title>
<style type="text/css">

<!--
body {
	background: #EFEFEF;
	margin: 0;
	padding: 0;
	color: #000;
	font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;
	font-size: 12px;
	line-height: 17px;
	text-align: justify;
	font-style: italic;
}

/* ~~ Element/tag selectors ~~ */
ul, ol, dl { /* Due to variations between browsers, it's best practices to zero padding and margin on lists. For consistency, you can either specify the amounts you want here, or on the list items (LI, DT, DD) they contain. Remember that what you do here will cascade to the .nav list unless you write a more specific selector. */
	padding: 0;
	margin: 0;
}
h1, h2, h3, h4, h5, h6, p {
	margin-top: 0;	 /* removing the top margin gets around an issue where margins can escape from their containing div. The remaining bottom margin will hold it away from any elements that follow. */
	padding-right: 15px;
	padding-left: 15px; /* adding the padding to the sides of the elements within the divs, instead of the divs themselves, gets rid of any box model math. A nested div with side padding can also be used as an alternate method. */
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
	width: 570px;
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
	font-size: 11px;
	font-style: normal;
	color: #000;
	text-align: center;
	padding-top: 10px;
	background-color: #AFB2CA;
}
.container .header table tr td h1 {
	font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
	font-size: 26px;
	font-style: normal;
	line-height: 28px;
	color: #000;
	text-align: center;
}
#menu {
	height: 25px;
	width: 570px;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 0px;
	margin-left: auto;
	background-color: #CCC;
}
-->
</style></head>
<cfif client.companyid lte 5 OR client.companyid eq 12>
	<cfset companyImage = 1>
<cfelseif client.companyid eq 10>
	<cfset companyImage = 10>
</cfif>
<body>

<Cfquery name="repInfo" datasource="MySQL">
select firstname, lastname, email, phone
from smg_users
where userid = #client.userid#
</cfquery>

<div id="menu"><table width="275" border="0" cellspacing="5">
  <tr>
    <td><a href="DFsave.cfm? filetype=pdf"><img src="images/save.png" height="20" alt="save icon" border="0" /></a></td>
    </tr>
</table>
</div>
<Cfoutput>
<div class="container">
  <div class="header"><table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="121" rowspan="2"><a href="http://www.case-usa.org"><img src="images/#companyImage#_md_02.png" width="121" height="107" /></a></td>
    <td width="491" height="85"><h1>Perhaps Together, We CAN Make a Difference in the World...</h1></td>
  </tr>
  <tr>
    <td><a href="http://www.case-usa.org"><img src="images/#companyImage#_md_04.png" width="449" height="26" /></a></td>
  </tr>
</table>
    <!-- end .header --></div>
  <div class="content">
    <img src="images/#companyImage#_md_06.png" width="570" height="293" /><br />
    <img src="images/#companyImage#_md_07.png" width="570" height="38" /><br />
    <table width="570" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="228" rowspan="2"><img src="images/md_08.png" width="219" height="231" /></td>
    <td width="342" height="123"><br /><p>Cultural Academic Student Exchange (CASE) is a non-profit, educational and cultural organization founded in 1988 on the belief that international student exchange promotes understanding, respect and goodwill among people of all nations. CASE brings foreign teens together with US volunteer host families. Our program grants students, host families and entire communities the ability to discover and value other cultures, which ultimately increases international harmony and creates lasting friendships.</p><br /></td>
  </tr>
  <tr>
    <td class="info"> <p>If you are interested in learning more about student exchange, please visit our website <strong>www.case-usa.org</strong> or contact <strong>#repInfo.firstname# #repInfo.lastname#</strong> at <strong>#repInfo.phone#</strong> or email <strong>#repInfo.email#</strong>.</p>
      <div class="clearfloat"></div></td>
  </tr>
</table>
<!-- end .content --></div>
  <div class="footer">
    <img src="images/md_11.png" width="569" height="14" />    <!-- end .footer --></div>
  <!-- end .container --></div>
  </Cfoutput>
</body>
</html>
