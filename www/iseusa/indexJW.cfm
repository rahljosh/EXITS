<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - A Non-profit Organization for Tomorrow's Leaders</title>
<meta name="description" content="International Student Exchange, Helping kids in a more diverse world, Non-Profit"/>

<meta name="keywords" content="foreign exchange, Cultural Diversity, Student Exchange. Travel Abroad, Meet our Students, Be a Host Family "/>
<link rel="shortcut icon" href="favicon.ico" />
<!---This defines the area of the div area to swap---->
<style type="text/css">
.mybox { width:746px; height:307px;padding:0px; }
.MOtext {
	background-color: #09C;
	z-index: 10;
	display: none;
	height: 200px;
	width: 200px;
	clear: none;
	float: left;
}
</style>
<!----Script to Swap div area---->
<script type="text/javascript" language="JavaScript"><!--
function HideDIV(d) { document.getElementById(d).style.display = "none"; }
function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//--></script>

<link href="css/ISEstyle.css" rel="stylesheet" type="text/css" />
</head>

<body class="oneColFixCtr">
<div id="topBar">
<div id="logoBox"><a href="index.cfm"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<cfinclude template="topBarLinks.cfm"><!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title">
<cfinclude template="title.cfm">
  <!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBarJR.cfm"><!-- end tabsBar --></div>

<div id="mainContent">
<!---area that mouse overs will affect---->
<div id="lead">
    <div id="initDiv" class="mybox" style="background-image:url('images/LargeTabs/blanktabs_01.png'); background-position:center center; background-repeat:no-repeat;line-height:20px; margin-top:10px;"">
</div>
         <!---Meet our Students---->
     
        <div id="meetStudents" class="mybox" style="display:none; text-align:center;":>
        <div class="MOtext">ISE students come from all over the world and are excited about their upcoming exchange program in the United States. Will you be the loving host family that opens the door to the world for an exchange student?</div>
        <div style="font-family:serif; font-size:20px; color:red; font-weight:bold; line-height:20px; margin-top:10px;">
          <img src="images/LargeTabs/blanktabs_01.png" width="746" height="307" />
          </div>
           
</div>
        <!---Host Fam---->
        <div id="hostFam" class="mybox" style="display:none; text-align:center;":>
            <div style="font-family:serif; font-size:20px; color:red; font-weight:bold; line-height:20px; margin-top:10px;">
            <img src="images/LargeTabs/blanktabs_02.png" width="747" height="307" />
            </div>
        </div>
        <!---Travel Abroad---->
        <div id="travelAbroad" class="mybox" style="display:none; text-align:center;":>
            <div style="font-family:serif; font-size:20px; color:red; font-weight:bold; line-height:20px; margin-top:10px;">
            <img src="images/LargeTabs/blanktabs_03.png" width="747" height="307" />
            </div>
        </div>
        <!---Student Trips---->
        <div id="studentTrips" class="mybox" style="display:none; text-align:center;":>
            <div style="font-family:serif; font-size:20px; color:red; font-weight:bold; line-height:20px; margin-top:10px;">
            <img src="images/LargeTabs/blanktabs_04.png" width="747" height="307" />
            </div>
        </div>
        <!---webstore---->
        <div id="webstore" class="mybox" style="display:none; text-align:center;":>
            <div style="font-family:serif; font-size:20px; color:red; font-weight:bold; line-height:20px; margin-top:10px;">
            <img src="images/LargeTabs/blanktabs_05.png" width="747" height="307" />
            </div>
        </div>
        <div id="blog" class="mybox" style="display:none; text-align:center;":>
            <div style="font-family:serif; font-size:20px; color:red; font-weight:bold; line-height:20px; margin-top:10px;">
            <img src="images/LargeTabs/blanktabs_06.png" width="747" height="307" />
            </div>
      </div>

<!-- end lead -->

</div>
<!----End of Area that Mouse Overs will effect---->
<div id="bottomInfoRight"><a href="hostStudent.cfm"><img src="images/hostAstudent.png" width="233" height="170" alt="host Student" border="0" /></a><img src="images/HELP.png" width="233" height="176" alt="HELP" border="0" />
<table width="200" border="0">
  <tr>
    <th scope="row"><a href="http://www.esecutive.com/index.php"><img src="images/globalSec.gif" width="108" height="28" border="1" /></a></th>
    <td><a href="http://www.erikainsurance.com/index_eng.asp"><img src="images/Erika.gif" width="108" height="26" border="1"/></a></td>
  </tr>
</table>
<!-- end bottomInfoRight --></div>
<div id="bottomInfoLeft">
  <div class="top"><!-- end top --></div>
  <div class="middle"><a href="aboutUs.cfm"><img src="images/aboutStudents.gif" width="229" height="172" alt="About Students" border="0"/></a><a href="sSucces.cfm"><img src="images/studentSuccess.gif" width="240" height="172" alt="student Success" border="0"/></a><a href="http://www.iseusa.com/blog/" target="_blank"><img src="images/Blog.gif" width="469" height="167" alt="blog" border="0"/></a></div>
  <div class="bottom"></div>
<!-- end bottomInfoLeft --></div>
<h1>&nbsp;</h1>
  <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
