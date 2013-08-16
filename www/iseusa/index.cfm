
<cfparam name="client.companyid" default="1">

<cfinclude template="/extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<script type="text/javascript" language="JavaScript">
    var GB_ROOT_DIR = "https://www.iseusa.com/greybox/";
</script>
<script type="text/javascript" src="greybox/AJS.js"></script>
<script type="text/javascript" src="greybox/AJS_fx.js"></script>
<script type="text/javascript" src="greybox/gb_scripts.js"></script>
<link href="greybox/gb_styles.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="JavaScript">
<!-- Script to Swap div area
	function HideDIV(d) { document.getElementById(d).style.display = "none"; }
	function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//-->
</script>
<style type="text/css">
<!--
/*** This defines the area of the div area to swap  ***/
.mybox { width:741px; height:307px;padding:0px;background-image:url('images/white_background.png'); background-position:center; background-repeat:no-repeat; }
.MOtext {
	
	z-index: 10;
	height: 245px;
	width: 260px;
	clear: none;
	float: left;
	margin-left: 25px;
	margin-top: 20px;
 	padding: 10px;
	text-align:left;
	
}
.alert {
	background-color: #FF0;
	height: 25px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	padding-top: 5px;
	padding-right: 2px;
	padding-left: 2px;
}
.alertSpacer {
	display: block;
	height: 40px;
}
.bigImage {
	float: right;
	margin-right: 25px;
	margin-top: 20px;
}
.videoClip {
	float: right;
	margin-right: 25px;
	margin-top: 20px;
	height: 265px;
	width: 350px;
}
.SStext {
	z-index: 10;
	height: 245px;
	width: 310px;
	clear: none;
	float: left;
	margin-left: 25px;
	margin-top: 20px;
	text-align:left;
	padding-top: 10px;
	padding-right: 10px;
	padding-bottom: 10px;
	padding-left: 20px;
}
.smText {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
/*** ***/

a:link {
	color: #165EA9;
	text-decoration: none;
}
a:visited {
	color: #165EA9;
	text-decoration: none;
}
a:hover {
	color: #009244;
	text-decoration: none;
}
a:active {
	color: #165EA9;
	text-decoration: none;
}
.oneColFixCtr #container #mainContent #bottomInfoLeft .middle .youTube {
	float: none;
	height: 135px;
	width: 190px;
	position: absolute;
	z-index: 250;
	margin-top: 190px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 285px;
}
-->
</style>

<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
function ShowHide(){
$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
}
//]]>
</script>
</head>

<body class="oneColFixCtr">

<cfinclude template="slidingLogin.cfm">

<div id="topBar">
<!----
<cfinclude template="topBarLinks.cfm">
---->
<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="International Student Exchange (ISE) logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>

<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
	<!---area that mouse overs will affect---->
    <div id="lead">
		
        <div id="initDiv" class="mybox">
        <span class="MOtext" style="background-color: #E6F2D5; font-size: 90%;">
            <!---<div style="width: 125px; float: right;"><a href="student_of_the_day.cfm?page=/studentDay/Exchange_Student_1" target="_self" ><img src="images/studentOfDay/studentWeek.png" alt="Host Student of the week" width="125" height="125" border="0" /></a></div>--->
            <strong>Meet our Students</strong><br /><br />
            ISE students come from all over the world and are excited about their upcoming exchange program in the United States. Will you be the loving host family that opens the door to the world for an exchange student?<br /><p align="center"><a href="meetStudents.cfm"><img src="images/buttons/GlearnMore.png" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subMeetStudents.gif" /></span>
        </div>
		
		
		<!---Meet our Students---->
        <div id="meetStudents" class="mybox" style="display:none;":>
            <span class="MOtext" style="background-color: #E6F2D5; font-size: 90%;">
            <!---<div style="width: 125px; float: right;"><a href="student_of_the_day.cfm?page=/studentDay/Exchange_Student_1" target="_self" ><img src="images/studentOfDay/studentWeek.png" alt="Host Student of the week" width="125" height="125" border="0" /></a></div>--->
            <strong>Meet our Students</strong><br /><br />
             ISE students come from all over the world and are excited about their upcoming exchange program in the United States. Will you be the loving host family that opens the door to the world for an exchange student?<br /><p align="center"><a href="meet-our-students.cfm"><img src="images/buttons/GlearnMore.png" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subMeetStudents_03.gif" /></span>
      	</div>
           
        <!---Host Fam---->
        <div id="hostFam" class="mybox" style="display:none; text-align:center;":>
            <span class="MOtext" style="background-color: #ffefd6;"> 
            <strong>Be a Host Family</strong><br /><br />
            Hosting a foreign exchange student is a life changing experience that brings the world closer together.  See the world through the eyes of a foreign exchange student and exchange the world!
            <br /><br /><p align="center"><a href="become-a-host-family.cfm"><img src="images/buttons/OreadMore.png" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subBaHost.gif" /></span>
      	</div>
        
        <!---Travel Abroad---->
        <div id="travelAbroad" class="mybox" style="display:none; text-align:center;font-size: 90%;":>
            <span class="MOtext" style="background-color: #F1D0D1;">
            <strong>Travel Abroad</strong><br/><br/>

American students are invited to go outbound to learn and study in different countries. ISE offers many different types of individualized programs to fit your personal needs. <br/><br/>

Become a world leader of tomorrow by expanding your horizons, learning new languages, and being an ambassador for your country!  
         
 <!--<br />American students are invited to go outbound to learn and study in different countries.  ISE offers many different types of individualized programs to fit your personal needs. <br /><Br />Become a world leader of tomorrow by expanding your horizons, learning new languages, and being an ambassador for your country!--><p align="center"><a href="mailto:john@iseusa.com"><img src="images/contactUsButton.png" width="75px" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subTravel.gif" /></span>
      	</div>
        
        <!---Student Trips---->
        <div id="studentTrips" class="mybox" style="display:none; text-align:center;":>
            <span class="MOtext" style="background-color: #D0EDF9;"> 
            <strong>Student Trips</strong><br /><br />
            International Student Exchange offers many trips for our students throughout the school year.
            <br /><br /><p align="center"><a href="trips/exchange-student-trips.cfm"><img src="images/buttons/Details.png" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subStudentTrips.gif" /></span>
        </div>
        
        <!---webstore---->
        <div id="webstore" class="mybox" style="display:none; text-align:center;":>
            <span class="MOtext" style="background-color: #E6F2D5;"> 
            <strong>Webstore</strong><br /><br />
            The ISE Webstore has many great items for you to share with friends and family!
            <br /><br /><p align="center"><a href="webstore.cfm"><img src="images/buttons/Gshop.png" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subWebstore.gif" /></span>
        </div>
        
        <!----blog---->
        <div id="blog" class="mybox" style="display:none; text-align:center;":>
            <span class="MOtext" style="background-color: #ffefd6;"> 
            <strong>BLOG</strong><br /><br />
            Student Exchange is changing the world and we're keeping up with these changes!
            <br /><br /><p align="center"><a href="http://blog.iseusa.com/" target="_blank"><img src="images/buttons/OreadMore.png" border="0"></a></p></span>
            <span class="bigImage"><img src="images/subPages/subBlog.gif" /></span>
      	</div>

    <!-- end lead -->
    </div>

<!----End of Area that Mouse Overs will effect---->
<div id="bottomInfoRight"><a href="host-a-foreign-exchange-student.cfm"><img src="images/hostAstudent.png" width="233" height="170" alt="host Student" border="0" /></a><a href="project-help.cfm"><img src="images/HELP.png" width="233" height="176" alt="HELP" border="0" /></a>
<table width="210" border="0" style="margin-left:0px;">
  <tr>
    <th height="63" align="left" scope="row">
    	<a href="https://www.esecutive.com/ise/" target="_blank"><img src="images/BaggageInsurance.png" width="91" height="40" border="0" title="Global Secutive Insurance" /></a>
    </th>
    <th scope="row" align="right"><a href="http://www.esecutive.com/index.php"><img src="images/GSlogo.png" width="79" height="34" /></a></th>
    <th scope="row" align="right">
    	<a href="pdfs/CSIET_CERTIFICATE_2013-14.pdf" target="_blank"><img src="images/csiet-13-14.png" width="64" height="43" border="0" title="CSIET 2010-2011 Certificate of Acceptance" /></a>
    </th>
  </tr>
</table>
<!-- end bottomInfoRight --></div>
<div id="bottomInfoLeft">
  <div class="top"><!-- end top --></div>
  <div class="middle">
 <!--- <div class="youTube"><object width="190" height="107"><param name="movie" value="//www.youtube-nocookie.com/v/U9D4yQms9Bs?version=3&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="//www.youtube-nocookie.com/v/U9D4yQms9Bs?version=3&amp;hl=en_US" type="application/x-shockwave-flash" width="190" height="107" allowscriptaccess="always" allowfullscreen="true"></embed></object></div>--->
  <a href="about-our-students.cfm"><img src="images/aboutStudents.gif" width="229" height="172" alt="About Students" border="0"/></a><a href="international-student-success-stories.cfm"><img src="images/studentSuccess.gif" width="240" height="172" alt="student Success" border="0"/></a><a href="be_a_ise_host_video.cfm" class="white"  rel="gb_page_center[600,400]"><img src="images/Be_a_host_button.png"alt="be a host family" border="0"/></a>
    
    <a href="https://www.iseusa.com/Host_foreign_exchange_student_video.cfm"  rel="gb_page_center[600,400]"><img src="images/host_foreign_exchange_student.png" alt="be a ISE hero" width="236" height="171" border="0" /></a></div>
  <div class="bottom"></div>
<!-- end bottomInfoLeft --></div>
<h1>&nbsp;</h1>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">

