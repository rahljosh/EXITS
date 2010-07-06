<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DMD &#45; Private High Schools Contact Us</title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--
.table {
	width: 700px;
}
.loginBox {
	float: right;
	height: 120px;
	width: 200px;
	border: medium solid #202554;
	margin-top: 25px;
	margin-left: 20px;
	margin-bottom: 20px;
	background-color: #FFF;
	padding-top: 20px;
	padding-right: 20px;
	padding-bottom: 20px;
	padding-left: 40px;
	font-family: Verdana, Geneva, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #666;
}
-->
</style>
<link href="css/phpusa.css" rel="stylesheet" type="text/css" />
</head>

<body class="oneColFixCtrHdr">

<div id="container">
  <cfinclude template="header.cfm">
  <div class="spacer"></div>
  
  <div id="mainContent">
  <div class="spacerlg"></div>
  <cfform action="loginprocess.cfm" target="_top" method="post" name="login">
    <div class="loginBox">username<br />
<cfinput type="text" name="username" message="Please enter a username." required="yes" typeahead="no" showautosuggestloadingicon="true" />
<br />
<br />
password<br />
<cfinput type="password" name="password" message="Please enter a password." required="yes" />
<br />
<br />
  <input type="submit" name="submit" id="submit" value="Submit" />
</cfform>
<!-- end loginBox --></div>

     <p class="headline">Contact Us</p>
     <p><span class="bold">Luke Davis</span> - <br />
       Program Director <br />
       E-mail: luke@phpusa.com
       <br />
       Toll Free: 1-866-822-1095
       <br />
       Phone: 631-422-1095
       <br />
    Fax: 631-669-1252</p>
<p>
DM Discoveries
  <br />
  119 Cooper Street
  <br />
  Babylon, NY 11702</p>


  <p>If you are interested in participating in a DMD Program, click on the <a href="studentForm.cfm" class="menu2">"Student Form"</a> button
to fill out your information and a representative from your home country will contact you.</p>
  <p><a href="studentForm.cfm" class="center"><img src="images/studentForm.png" width="95" height="23" border="0" /></a> &nbsp; &nbsp; <a href="HFForm.cfm" class="center"><img src="images/hostFamily.png"border="0" /></a> &nbsp;&nbsp; <a href="agentForm.cfm" class="center"><img src="images/agent.png"border="0" /></a></p>
   <div class="bottomGradient"></div>
  <!-- end mainContent --></div>
  <div class="spacersm"></div>
<cfinclude template="footer.cfm">
  <div class="spacersm"></div>
<!-- end container --></div>
</body>
</html>
