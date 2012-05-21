<Cfquery name="repInfo" datasource="MySQL">
select firstname, lastname, email, phone
from smg_users
where userid = #client.userid#
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Seeking Volunteer Host Families</title>
<style type="text/css">
<!--
body {
	margin: 0;
	padding: 0;
	color: #000;
	font-family: Verdana, Geneva, sans-serif;
	font-size: 10px;
	line-height: 1.4em;
	background-color: #efefef;
}

/* ~~ Element/tag selectors ~~ */
ul, ol, dl { /* Due to variations between browsers, it's best practices to zero padding and margin on lists. For consistency, you can either specify the amounts you want here, or on the list items (LI, DT, DD) they contain. Remember that what you do here will cascade to the .nav list unless you write a more specific selector. */
	padding: 0;
	margin: 0;
}
h1, h2, h3, h4, h5, h6, p {
	margin-top: 0;	 /* removing the top margin gets around an issue where margins can escape from their containing div. The remaining bottom margin will hold it away from any elements that follow. */
	padding-right: 8px;
	padding-left: 8px; /* adding the padding to the sides of the elements within the divs, instead of the divs themselves, gets rid of any box model math. A nested div with side padding can also be used as an alternate method. */
}
a img { /* this selector removes the default blue border displayed in some browsers around an image when it is surrounded by a link */
	border: none;
}
/* ~~ Styling for your site's links must remain in this order - including the group of selectors that create the hover effect. ~~ */
a:link {
	color: #42413C;
	text-decoration: underline; /* unless you style your links to look extremely unique, it's best to provide underlines for quick visual identification */
}
a:visited {
	color: #6E6C64;
	text-decoration: underline;
}
a:hover, a:active, a:focus { /* this group of selectors will give a keyboard navigator the same hover experience as the person using a mouse. */
	text-decoration: none;
}

/* ~~ this fixed width container surrounds the other divs ~~ */
.container {
	width: 612px; /* the auto value on the sides, coupled with the width, centers the layout */
	background-color: #FFF;
	background-image: url(HF/backgroundsm.jpg);
	margin-top: 15;
	margin-right: auto;
	margin-bottom: 0;
	margin-left: auto;
}

/* ~~ the header is not given a width. It will extend the full width of your layout. It contains an image placeholder that should be replaced with your own linked logo ~~ */
.header {
	text-align: center;
}

/* ~~ This is the layout information. ~~ 

1) Padding is only placed on the top and/or bottom of the div. The elements within this div have padding on their sides. This saves you from any "box model math". Keep in mind, if you add any side padding or border to the div itself, it will be added to the width you define to create the *total* width. You may also choose to remove the padding on the element in the div and place a second div within it with no width and the padding necessary for your design.

*/

.content {
	background-image: url(HF/papersm.png);
	background-repeat: no-repeat;
	background-position: center 10px;
	padding-top: 25px;
	padding-right: 30;
	padding-bottom: 10px;
	padding-left: 10;
}

/* ~~ The footer ~~ */
.footer {
	padding: 3px 0;
	text-align: center;
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
 .rdholder {

  height:auto;
  width:auto;
  margin-bottom:5px;

 } 


 .rdholder .rdbox {
	background-color: #C0B6B4;
	border-left:1px solid #c6c6c6;
	border-right:1px solid #c6c6c6;
	margin:0;
	display: block;
	font-family: Verdana, Geneva, sans-serif;
	font-size: 10px;
	color: #000;
	padding-top: 0px;
	padding-right: 12px;
	padding-bottom: 0px;
	padding-left: 12px;
 } 

 .rdtop {
	width:auto;
	height:15px;
	border: 1px solid #C0B6B4;
	/* -webkit for Safari and Google Chrome */

  -webkit-border-top-left-radius:12px;
	-webkit-border-top-right-radius:12px;
	/* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-topright:12px;
	-moz-border-radius-topleft:12px;
	background-color: #C0B6B4;
	color: #006699;
 } 

 .rdtop .rdtitle {
	margin:0;
	line-height:30px;
	font-family:Arial, Geneva, sans-serif;
	font-size:20px;
	padding-top: 5px;
	padding-right: 10px;
	padding-bottom: 0px;
	padding-left: 10px;
	color: #006699;
 }

 .rdbottom {

  width:auto;
  height:15px;
  background-color: #C0B6B4;
  border-bottom: 1px solid #C0B6B4;
  border-left:1px solid #C0B6B4;
  border-right:1px solid #C0B6B4;
   /* -webkit for Safari and Google Chrome */

  -webkit-border-bottom-left-radius:12px;
  -webkit-border-bottom-right-radius:12px;


 /* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-bottomright:12px;
  -moz-border-radius-bottomleft:12px; 
 
 }
.rdPic {
	padding: 3px;
	border: thin solid #CCC;
	font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
	font-style: italic;
	 -moz-box-shadow: 3px 3px 4px #999; /* Firefox */
 -webkit-box-shadow: 3px 3px 4px #999; /* Safari/Chrome */
 box-shadow: 3px 3px 4px #999; /* Opera and other CSS3 supporting browsers */
 -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=4, Direction=135, Color='#999999')";/* IE 8 */
 : progid:DXImageTransform.Microsoft.Shadow(Strength=4, Direction=135, Color='#999999');/* IE 5.5 - 7 */  
}
.container .content .textBlock {
	width: 525px;
	margin-right: auto;
	margin-left: auto;
	display: block;
	height: 200px;
}
h1 {
	padding-bottom: 0px;
	margin-bottom: 13px;
	margin-top: 13px;
}
.clearfix {
	display: block;
	clear: both;
	width: 100%;
	text-align: center;
	margin-top: 15px;
}
#menu {
	height: 25px;
	width: 615px;
	margin-top: 0px;
	margin-right: auto;
	margin-bottom: 0px;
	margin-left: auto;
	background-color: #CCC;
}
-->
</style></head>

<body>
<cfoutput>
<div id="menu"><table width="275" border="0" cellspacing="5">
  <tr>
    <td><a href="HFsave.cfm? filetype=pdf"><img src="../images/save.png" height="20" alt="save icon" border="0" /></a></td>
    </tr>
</table>
</div>
<div class="container">
  <div class="header"><!-- end .header -->
  <cfif client.companyid lte 6 OR client.companyid eq 12>
  	<img src="HF/1_logoSM.png" width="577" height="108" />
  <cfelseif client.companyid eq 10>
 	<img src="HF/10_logoSM.png" width="577" height="108" />
  <cfelse>
  	<img src="HF/14_logoSM.png" width="577" height="108" />
  </cfif>
  </div>
  <div class="content">
  <div align="center"><img src="HF/headersm.png" width="510" height="241" /></div>
  <div class="textBlock">
  <h1>Seeking Volunteer Host Families</h1>
  <div style="width: 175px; float: left;">
    <p>Share in a culturally rewarding experience by becoming a volunteer host family for 2012-13 foreign exchange high school students from around the globe.  Students range in age from 15- 18 1/2, will be part of your family and will attend your local high school.  Our students have their own health insurance</p></div>
  <div style="width: 175px; float: left;"><p> and spending money.  As a volunteer host family you will have the support of a highly dedicated network of professionals to assist you right from the submission of your application until the time that your student returns home.  You can host a student from a country of your choice for 5, 10 or 12-months.</p></div>
  <div style="width: 175px; float: right;"><div class="rdholder">
          <div class="rdtop"></div>
        <div class="rdbox"><em>If you would like more information on becoming a volunteer host family, please contact:</em><br />
          <br />
          <strong>#repInfo.firstname# #repInfo.lastname#</strong><br />
          P: #repInfo.phone#<br />
           #repInfo.email#<br />
          </div>
        <div class="rdbottom"></div>
      </div></div></div>
    <div class="clearfix"><table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="HF/pic1sm.png" width="200" height="207" /></td>
    <td><img src="HF/pic2sm.png" width="200" height="207" /></td>
    <td><img src="HF/pic3sm.png" width="200" height="207" /></td>
  </tr>
</table>
</div>
    <!-- end .content --></div>
  <div class="footer">
  <cfif client.companyid lte 6 OR client.companyid eq 12>
  	<img src="HF/1_footerSM.png" width="577" height="30" />
  <cfelseif client.companyid eq 10>
 	<img src="HF/10_footerSM.png" width="577" height="30" />
  <cfelse>
  	<img src="HF/14_footerSM.png" width="577" height="30" />
  </cfif>

    
    <!-- end .footer --></div>
  <!-- end .container --></div>
</cfoutput>
</body>
</html>
