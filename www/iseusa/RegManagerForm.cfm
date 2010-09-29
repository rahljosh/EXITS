<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
<style type="text/css">
<!--
-->
.loginBox {
	float: right;
	height: 52px;
	width: 300px;
	margin-top: 10px;
	margin-right: 20px;
	padding: 30px;
	background-color: #CCC;
}
.testimonial {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 13px;
	font-style: italic;
	line-height: 16px;
	padding: 10px;
}
.testimonialBold {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 13px;
	font-style: italic;
	line-height: 16px;
	padding: 10px;
	font-weight: bold;
}
</style>

<link href="css/ISEstyle.css" rel="stylesheet" type="text/css" />
</head>
<!----Query to get states and id's---->

<cfquery name="states" datasource="#application.dsn#">
select id, state
from smg_states
</cfquery>

<cfoutput>
<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddle">
        <div class="subPic"><img src="images/beArep.png" width="415" height="277" alt="Meet our Students" /><div class="loginBox"><span class="testimonial">""Our Area Rep is very helpful and has been available to our family any time we needed to talk to her." Jan Gavilanes- Host Mother</span></div></div>
        <div class="formRep">
          <p class="p1"><span class="bold">Regional Manager</span><br /></p>
         <p>First Name<br />
            <input type="text" name="firstname" id="First Name" />
            <br />
            Last Name<br />
            <input type="text" name="lastname" id="First Name2" />
            <br />
            Email<br />
            <input type="text" name="email" id="First Name3" />
            <br />
            Street Address
            <br />
            <input type="text" name="address" id="First Name4" />
            <br />
            City
            <br />
            <input type="text" name="city" id="First Name5" />
            <br />
            State of Residence<br />
		    <select name="state">
		      <option value="0"></option>
		      <cfloop query="states">
		        <option value=#id#>#state#</option>
		        </cfloop>
		      </select>
            <br />
            Zip Code<br />
            <input type="text" name="zip" id="First Name7" />
            <br />
            Home Phone<br />
            <input type="text" name="phone" id="First Name8" />
            <br />
          Cell Phone<br />
            <input type="text" name="cellphone" id="First Name9" />
            <br />
            Why are you interested in this position</span><span class="loginButton"><br />
            
            <textarea name="comments" id="comments" cols="25" rows="5"></textarea>
            <br />
            <input type="image" src="images/submitRed.png" />
          </p>
        </form></div>
        
<p class="p1">&nbsp;</p>
        <!-- end whtMiddle -->
      </div>
      <div class="whtBottom"></div>
      <!-- end lead --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="bottomLinks.cfm">
<!-- end footer --></div>
</body>
</cfoutput>
</html>
