<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Student Tours Flight Quote</title>
<meta name="description" content="International Student Exchange Student Tours"/>

<meta name="keywords" content="Trips, Vacation, student Tours, Student Trips"/>
<style type="text/css">
<!--
-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
.whtMiddle1 {
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	height: 700px;
	width: 746px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
-->
</style></head>

<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="titleTrips.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="../tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddle1">
        <div class="trips">
          <h1 class="enter">Flight Quote          </h1>
          <cfform id="ContactForm" name="ContactForm" method="post" action="email_sasha.cfm">
          <table width="603" height="229" border="0">
            <tr>
              <td width="597" height="45" align="center" scope="row" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
                <a href="/">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="forms.cfm">Forms</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td>
              </tr>
            <tr>
              <td height="178" class="lightGreen" scope="row"><p class="boldLJ">ALL FIELDS ARE REQUIRED  </p>
                <p class="p2">First Name
                  <br />
                  <cfinput type="text" form id="First Name" name="firstname" message="First Name Required" required="yes">
                  <br />
                  Last Name
                  <br />
                  <cfinput type="text" name="lastname" message="Last Name Required" required="yes" id="last name" />
                  <br />
                  Phone (area code)
                  <br />
                  <cfinput type="text" name="phone" message="Telephone is required" validate="telephone" required="yes" id="phone" />
                  <br />
                  Email
                  <br />
                  <cfinput type="text" name="email" message="Email Required" validate="email" required="yes" id="email" />
                  <br />
                  Fax  
                  (Not required)
                  <br />
                  <input type="text" name="faxnumber" id="faxnumber" />
                  <br />
                  Name of Tour
                  <br />
                  <cfinput type="text" name="nameoftour" message="Tour Name Required" required="yes" id="nameoftour" />
                  <br />
                  <br />
                  Tour Dates<br />
<select name="TourDates" id="tourdates">
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
                    <option>LA Experience &ndash; Nov. 28 - Dec. 3, 2010</option>
                    <option>New York Holiday &ndash; Dec. 12-17, 2010</option>
                  </select>
<br />
<br />
                  
                  Host Family Departure City &amp; Airport<br />
                  <cfinput type="text" name="departurecity" message="Departure City / Airport Required" required="yes" id="departurecity" />
                  <br />
                  Return City Airport<br />
                  <cfinput type="text" name="returnAirport" message="Return City / Airport Required" required="yes" id="returnAirport" />
                  <br />
                  </span><br />
                  <input type="submit" name="submit" id="submit" value="Submit" />
                </p>
  </form>
</cfform>

              </td>
              </tr>
              <td width="597" height="45" align="center" scope="row" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
                <a href="/">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="forms.cfm">Forms</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td>
          </table>
          <div class="clear"></div>
        <!-- end trips --></div>
        <!-- end whtMiddle -->
      </div>
      <div class="whtBottom"></div>
      <!-- end subPages --></div>
    <!-- end mainContent -->
  </div>
<!-- end container --></div>
<div class="clear"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
