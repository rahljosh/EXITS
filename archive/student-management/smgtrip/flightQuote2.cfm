<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
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
.oneColFixCtr #container {
	width: 780px;  /* using 20px less than a full 800px width allows for browser chrome and avoids a horizontal scroll bar */
	background: #FFFFFF;
	margin: 0 auto; /* the auto margins (in conjunction with a width) center the page */
	border: 1px solid #000000;
	text-align: left; /* this overrides the text-align: center on the body element. */
}
.oneColFixCtr #mainContent {
	padding: 0 20px; /* remember that padding is the space inside the div box and margin is the space outside the div box */
}
.paragraph {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 1em;
	color: #000;
}
.logo {
	padding: 0px;
	height: 200px;
	width: 200px;
	margin-top: 20px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 0px;
}
.header {
	padding: 0px;
	float: right;
	height: 50px;
	width: 500px;
	margin-top: 100px;
	margin-right: 10px;
	margin-bottom: 0px;
	margin-left: 0px;
	text-align: center;
	vertical-align: middle;
}
.Header1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 2em;
	color: #000;
	text-align: center;
	font-weight: bold;
}
.header3 {
	font-family: Verdana, Geneva, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #F00;
	text-decoration: underline;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
}
.style5 {
	color: #FFFFFF;
	font-size:10px;	
	font-weight: bold;
}
-->
</style></head>

<body class="oneColFixCtr">

<div id="container">
  <div id="mainContent">
  <table width="70%" border="0" cellspacing="1" cellpadding="0" align="center">
          <tr>
            <td width="18%" height="22" bgcolor="#2E4F7A" class="style1"><A href="principal.cfm" class="style5">
              <div align="center">Home</div>
            </A></td>
            <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style5">Contact</a></div></td>
            <td width="28%" bgcolor="#2E4F7A" class="style1"><div align="center" class="style6"><a href="rules.html" class="style5">Rules &amp; Policies</a></div></td>
            <td width="15%" bgcolor="#FFFFFF" class="style1"><div align="center" class="style6">Forms</div></td>
            <td width="21%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style5">Questions?</a></div></td>
          </tr>
        </table>
  <div class="header"><span class="Header1">Flight Quote</span></div>
    <div class="logo"><span class="oneColFixCtr"><img src="images/SMGLogo.png" width="200" height="200" /></span></div>
    
<cfform id="ContactForm" name="ContactForm" method="post" action="email_sasha.cfm">
  <p class="Header"><span class="header3">ALL FIELDS ARE REQUIRED</span></p>
  <p><span class="oneColFixCtr"><span class="paragraph">First Name<br />
    <cfinput type="text" name="firstname" message="First Name Required" required="yes" id="First Name" />
    <br />
    Last Name<br />
    <cfinput type="text" name="lastname" message="Last Name Required" required="yes" id="last name" />
    <br />
    Telephone Number (area code)<br />
    <cfinput type="text" name="phone" message="Telephone is required" validate="telephone" required="yes" id="phone" />
    <br />
    Email<br />
    <cfinput type="text" name="email" message="Email Required" validate="email" required="yes" id="email" />
  <br />
    Fax Number
    (Not required)<br />
    <input type="text" name="faxnumber" id="faxnumber" />
  <br />
    Name of Tour<br />
    <cfinput type="text" name="nameoftour" message="Tour Name Required" required="yes" id="nameoftour" />
  <br />
    Tour Dates<br />
     <select name="tourdates" id="tour dates">
      <option>Hawaii I &ndash; Feb. 5-12, 2010</option>
      <option>Hawaii II &ndash; Feb. 13-20, 2010</option>
      <option>Hawaii III &ndash; Feb. 22 Mar. 1, 2010</option>
      <option>Western Tour &ndash; Mar. 13-19, 2010</option>
      <option>California Experience &ndash; March 6-12, 2010</option>
      <option>Hawaii IV &ndash; Apr. 3-10, 2010</option>
      <option>East Coast Experience &ndash; April 13-19, 2010</option>
      <option>New York & Boston &ndash; May 1 - May 7, 2010</option>
      <option>NYC Long Weekend 1 &ndash; May 14-17, 2010</option>
      <option>NYC Long Weekend 1 &ndash; May 21-24, 2010</option>
      <option>LA Experience &ndash; Nov. 28 &ndash; Dec. 3, 2010</option>
      <option>New York Holiday &ndash; Dec. 12-17, 2010</option>
    </select>
     <br />
     <br />
    
    Host Family Departure City &amp; Airport<br />
    <cfinput type="text" name="departurecity" message="Departure City / Airport Required" required="yes" id="departurecity" />
    <br />
    Return City Airport</span><br />
    <cfinput type="text" name="returnAirport" message="Return City / Airport Required" required="yes" id="returnAirport" />
    <br />
    </span><br />
    <input type="submit" name="submit" id="submit" value="Submit" />
  </p>
    </cfform></p>
  <!-- end #mainContent --></div>
<!-- end #container --></div>
</body>
</html>
