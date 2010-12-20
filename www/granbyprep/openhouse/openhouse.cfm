<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script src="../SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="../SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
<link href="../css/granby.css" rel="stylesheet" type="text/css" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Granby Preparatory Academy: Request Information</title>
<style type="text/css">

<!--
body {
	font: 100% Verdana, Arial, Helvetica, sans-serif;
	background: #666666;
	margin: 0; /* it's good practice to zero the margin and padding of the body element to account for differing browser defaults */
	padding: 0;
	text-align: center; /* this centers the container in IE 5* browsers. The text is then set to the left aligned default in the #container selector */
	color: #000000;
}
td, th {
	padding-left: 15px;
	padding-top: 2px;
	padding-bottom: 2px;
}
.InsPhoto {
	float: right;
	height: 500px;
	width: 330px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
	text-align: center;
}
.call-out {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	padding: 10px;
	height: 200px;
	width: 290px;
	background-color: #FDD22B;
	margin-top: 20px;
	margin-left: 10px;
}
.video {
	background-color: #999;
	text-align: center;
	vertical-align: middle;
	height: 286px;
	width: 500px;
	margin-right: auto;
	margin-left: auto;
	margin-top: 25px;
}
-->
</style></head>
<!----Script to Swap div area---->
<script type="text/javascript" language="JavaScript">
    var GB_ROOT_DIR = "http://www.granbyprep.com/greybox/";
</script>
<script type="text/javascript" src="../greybox/AJS.js"></script>
<script type="text/javascript" src="../greybox/AJS_fx.js"></script>
<script type="text/javascript" src="../greybox/gb_scripts.js"></script>
<link href="../greybox/gb_styles.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" language="JavaScript">
<!--
function HideDIV(d) { document.getElementById(d).style.display = "none"; }
function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//-->
</script>

<body class="oneColElsCtrHdr">
<Cfif isDefined('form.sendEmail')>
<cfmail  to="#APPLICATION.EMAIL.headMaster#;#APPLICATION.EMAIL.admissionsOfficer#;jeimi@exitgroup.org" replyto="#form.email#" from="support@granbyprep.com" type="html" SUBJECT="Granby Info Request"> 
<p> The info submitted was:
  <br /><br />
  <strong>Student Information</strong><br />
  Name:#form.firstname# #form.lastname#<br />
  Email:#form.email#<br />
  
<strong>Parent / Guardian Information</strong><br />
  Name:#form.ptfirstname# #form.ptlastname#<Br />
  Address:#form.address#<br />
  City:#form.city#<Br />
  State:#form.state#<br />
  Zip:#form.zip#<br />
  Country: #form.country#<br />
  Phone: #form.phone#<br /><br />
  Attendees: #form.attendees#<br /><br />
  Comments:#form.comments#<br /><br /><br />
  
  </p>

</cfmail>
</Cfif>
<div id="container">
<div href="javascript:void(0)" onclick="window.location.href='http://www.granbyprep.com'">
  <div id="headerBar">
    <div id="clickright">
  <a href="../index.cfm"><img src="../images/click.png" width="190" height="170" border="0" /></a>
  <!-- BEGIN ProvideSupport.com Graphics Chat Button Code -->
<div id="ciQmQ6" style="z-index:100;position:absolute"></div><div id="scQmQ6" style="display:inline"></div><div id="sdQmQ6" style="display:none"></div><script type="text/javascript">var seQmQ6=document.createElement("script");seQmQ6.type="text/javascript";var seQmQ6s=(location.protocol.indexOf("https")==0?"https":"http")+"://image.providesupport.com/js/granbyprep/safe-standard.js?ps_h=QmQ6&ps_t="+new Date().getTime();setTimeout("seQmQ6.src=seQmQ6s;document.getElementById('sdQmQ6').appendChild(seQmQ6)",1)</script><noscript><div style="display:inline"><a href="http://www.providesupport.com?messenger=granbyprep">Live Support Chat</a></div></noscript>
<!-- END ProvideSupport.com Graphics Chat Button Code -->
  <!-- end clickright --></div>
  <!-- end header --></div></div>
  <div id="menu">
<cfinclude template ="../menu.cfm">
  </div>
<div id="mainContent">
   
    <h2>Granby Preparatory Academy Open House</h2>
 <p class="paragraphText">Granby Preparatory Academy opened its doors for the first time to the area residents to come and see all of the changes that the GPA campus has undergone. On Sunday, November 7th, over seventy visitors walked through the classrooms, the gymnasium, and even sat in on a SmartBoard demonstration. While on campus families were able to view several of the clubs, programs, and a sample schedule that will be available to students next fall.<br /><br />
There were several information tables that also provided information on tuition and fees, financial aid, the Admission process, as well as our esteemed food service providers, SAGE Dining Services, sent a representative, Mr. Fabian Dominguez, to discuss the meal services that will be provided to students.<br /><br /> 
The success of the Open House is marked by the enthusiastic response we received from the guests! Several left the building exclaiming: "I can not wait to come back! What an impressive sight!".</p>
 <div class="video"><a href="http://sharing.theflip.com/session/4a3671ba66e3462986f4fd8614366569/video/27520191" rel="gb_page_center[675,600]"><img src="images/video.jpg" width="500" height="286" alt="video" /></a></div><br />

<p class="paragraphText"> Thank you for your interest in Granby Preparatory Academy. We look forward to seeing you at our NEXT Open House</p>
<p class="paragraphText"><a href="index.cfm"><img src="../images/register_03.png" width="86" height="21" alt="register" border="0" /></a><strong></strong> </p>

 <p>&nbsp;</p>
 <div class="clearfix"></div>
<!-- end mainContent --></div>
<cfinclude template ="../footer.cfm">
<!-- end container --></div>
<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"SpryAssets/SpryMenuBarDownHover.gif", imgRight:"SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>
</body>
</html>
