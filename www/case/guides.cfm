<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>CASE: About </title>
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<!----
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #333;
}
a:active {
	text-decoration: none;
	color: #333;
}
-->
</style>
---->
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #98002E;
}
a:active {
	text-decoration: none;
	color: #000;
}
.clearfix {
	display: block;
	clear: both;
	height: 30px;
}
-->
</style>

<link rel="shortcut icon" href="favicon.ico" />

</head>

<body>
<div id="wrapper">
 <cfinclude template="includes/header.cfm">
  <div id= "mainbody">
   <cfinclude template="includes/leftsidebar.cfm">
    <div id="mainContent">
  <div id="ContentTop"></div>
  <div id="content">
    <div id="aboutCase">
      
      <p class="header2">Helpful Guides</p>
      <p>&nbsp;</p>
      <p> We have prepared a few documents to help you get comfortable with the new host family application and the process of moving through EXITS.  You will initiate the application, help the host family with any questions they may have, and then review the information online and submit it to headquarters. <br /><br />
    The Quick Start Guide is a one page summary of the process, while the other two guides are more in-depth on each step of the process. <br />
    <br />
    Simply select which type of host family you are interacting with and you'll be set!
    <div align="center">
	<img src="images/graphics.png" width=700 border="0" usemap="#Pictures" />
    <map name="Pictures" id="Pictures">
      <area shape="poly" coords="61,133,239,107,249,190,216,303,84,321" href="pdfs/Host App Quick Start Guide.pdf" />
      <area shape="poly" coords="281,108,457,157,407,339,228,292" href="pdfs/Area Rep Host App Instructions for Existing Host Family.pdf" />
      <area shape="poly" coords="625,115,640,310,448,321,445,227,468,155,443,143,439,129" href="pdfs/Area Rep Instructions for New Host Family.pdf" />
    </map></p>
      </div>
  </div>
  <div id="Contentbottom"></div>
</div>
</div><!-- end mainbody -->
    <!-- This clearing element should immediately follow the #mainContent div in order to force the container div to contain all child floats --><br class="clearfloat" />
<cfinclude template="includes/footer.cfm">
</div><!-- end wrapper -->
</body>
</html>
