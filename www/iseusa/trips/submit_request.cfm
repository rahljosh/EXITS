<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Student Tours General Questions</title>
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
-->
</style></head>

<body class="oneColFixCtr">
<div id="topBar">
<div id="logoBox"><a href="../index.cfm"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<cfinclude template="../topBarLinks.cfm"><!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="titleTrips.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="../tabsBar.cfm"><!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddleQuest">
        <div class="trips">
        <br>
        <span class="style3"><span class="style3"><strong>Deposit Form </strong><br>
        </span><br>
        <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td class="style1"><div align="center"> 
                    <cfset desc= 'SMG Trip Deposit Form'>
									
					  
					 <cfmail to="josh@pokytrails.com"  from="trips@student-management.com" subject="SMG Trip Deposit Form">
					 
#desc# from the SMG Trip web site on #dateformat(Now())#.

Payment: #form.payment#
Card Number: #form.card#
Expires: #form.expires#
Name on Card: #form.name#
Charge: #form.charge# - #form.other#
American Company: #form.americomp#

----------------------------------------
Personal Information
----------------------------------------
Date of Birth: #form.birth#
Sex: #form.sex#
Last Name: #form.lastname#
First Name: #form.firstname#
Host Family Name: #form.hostname#
Street: #form.street#
City: #form.city#
State: #form.state#
ZIP: #form.zip#
Student email: #form.studentemail#
Host email: #form.hostemail#
Phone: #form.phone#

----------------------------------------
Airport Information
----------------------------------------
State: #form.stateaiport#
Airport: #form.airport#

----------------------------------------
TRIP(S)
----------------------------------------
#form.tour#
</cfmail>
                      </span></div>
                  <div align="center">
                    <div align="center" class="style1"><span class="style3"><br>
                    The following information was submitted to SMG Trip: </span><br>
                    </div>
                    <cfoutput>
                    <table width=90% align="center">
                      <tr>
                        <td class="style1"> <span class="style7">
													Payment: #form.payment#<br>
                          Card Number: #form.card#<br>
													Expires: #form.expires#<br>
                          Name on Card: #form.name#<br>
                          Charge: #form.charge# - #form.other#<br>
                          American Company: #form.americomp#<br><br>
                          ----------------------------------------<br>
                          Personal Information <br>
                          ----------------------------------------<br>
                          Date of Birth: #form.birth#<br>
                          Sex: #form.sex#<br>
                          Last Name: #form.lastname#<br>
                          First Name: #form.firstname#<br>
                          Host Family Name: #form.hostname#<br>
                          Street: #form.street#<br>
                          City: #form.city#<br>
													State: #form.state#<br>
													ZIP: #form.zip#<br>
													Student email: #form.studentemail#<br>
													Host email: #form.hostemail#<br>
													Phone: #form.phone#<br><br>
													----------------------------------------<br>
													Airport Information <br>
													----------------------------------------<br>
													State: #form.stateaiport#<br>
													Airport: #form.airport#<br><br>
                          ----------------------------------------<br>
                          TRIP(S)<br>
                          ----------------------------------------<br>
						  #form.tour#
						  </span></td>
                      </tr>
                    </table>
                  </cfoutput>
                <div align="center" class="style3"><br>
                  You will be contacted shortly.</div>
                <p align="center" class="style3">&nbsp;</p>
            </div>              </td>
          </tr>
        </table>
        <br>
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
