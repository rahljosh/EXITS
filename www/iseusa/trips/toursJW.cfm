<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
<style type="text/css">
<!--
-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.tripsTours {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	height: 1600px;
	width: 675px;
	margin-left: 35px;
	margin-top: 10px;
	padding: 0px;
	text-align: left;
}
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
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 14px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 12px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(file:///JW%20BACKUP/SMG/ISE/site/trips/images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:#000000;
	font-style: normal;
	font-weight: normal;
}
.style1 {color: #FFFFFF}
.style2 {font-size: 12px}
.style4 {font-size: 12}
.style5 {color: #FFFFFF; font-weight: bold; }
.style6 {
	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
.image-right {
border:solid 1px;
margin-right: 0px;
margin-left: 15px;
}
.image-left {
border:solid 1px;
margin-right: 15px;
margin-left: 0px;
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
<div class="tabsBar">
  <cfinclude template="../tabsBar.cfm">
  <!-- end tabsBar --></div>
<div id="mainContent">
    <div id="subPages">
      <div class="whtTop"></div>
      <div class="whtMiddleStretch">
        <div class="tripsTours">
          <h1 class="enter">ISE Student Tours</h1>
          <p>International Student Exchange and our partner organization, MPD Tour America are proud to offer this year's ISE Trips of exciting adventures across America. MPD Tour America will be organizing 9 ISE trips, chaperoned and supervised exclusively by ISE Representatives, for the 2010-11 season.</p>
         <cfoutput>
<cfset company = 'CASE'>
 <br>
        <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours WHERE tour_id = #url.tour_id#
		</cfquery>
        <div class="tours"> 
        <table width="665" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr><td height="45" scope="row" align="center" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
                <a href="index.cfm">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="forms.cfm">Forms</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td></tr>
          <tr>
            <td width="665"><img src="http://www.student-management.com/nsmg/uploadedfiles/student-tours/#tours.tour_img1#.jpg" width="300" border="0" align="right" class="image-right">
                <table width="50%" border="0" align="center" cellpadding="5" cellspacing="0">
                  <tr>
                    <td><span class="Titles">
					
						<cfset tour_name = Replace(tours.tour_name, (Chr(13) & Chr(10)), "<br />", "ALL")>
					  	<cfset tour_name = Replace(tour_name, ("!company!"), company, "ALL")>
					  	#tour_name#
						
						</span><br>
                      	<span class="SubTitle"><font size="1">
					  
					  <cfset tour_date = Replace(tours.tour_date, (Chr(13) & Chr(10)), "<br />", "ALL")>
					  <cfset tour_date = Replace(tour_date, ("!company!"), company, "ALL")>
					  #tour_date#
					  
					  </font></span></td>
                    <td><table width="90" class="Boxx" align="center" cellpadding="5" cellspacing="0">
                        <tr>
                          <td><div align="center">
						  	<cfset tour_price = Replace(tours.tour_price, (Chr(13) & Chr(10)), "<br />", "ALL")>
					  		<cfset tour_price = Replace(tour_price, ("!company!"), company, "ALL")>
					  		#tour_price#
					  </div></td>
                        </tr>
                    </table>
					
					</td>
                  </tr>
                </table>
              <span class="RegularText">
			  <cfif tours.tour_status EQ 'Full'><font color='FF0000' size='2'><b><center>No More Seats Available!!</center></b></font></cfif>
			  <cfif tours.tour_status EQ 'Cancelled'><font color='FF0000' size='2'><b><center>Cancelled!!</center></b></font></cfif>
                <br>
				<cfset tour_description = Replace(tours.tour_description, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_description = Replace(tour_description, ("!company!"), company, "ALL")>
				#tour_description#
				</span><br>
              <br>
                <span class="SubTitle"> <img src="http://www.student-management.com/nsmg/uploadedfiles/student-tours/#tours.tour_img2#.jpg" width="175" hspace="10" border="0" align="left" class="image-left"> Flights:</span><br>
                <span class="RegularText">
				<cfset tour_flights = Replace(tours.tour_flights, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_flights = Replace(tour_flights, ("!company!"), company, "ALL")>
				#tour_flights#
				<br>
                <br>
                <span class="SubTitle">Payment:</span><br>
				<cfset tour_payment = Replace(tours.tour_payment, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_payment = Replace(tour_payment, ("!company!"), company, "ALL")>
				#tour_payment#
                <br>
                <br>
				<span class="SubTitle">Tour Cancellation Fees and Penalties:</span><br>
				<cfset tour_cancelfee = Replace(tours.tour_cancelfee, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_cancelfee = Replace(tour_cancelfee, ("!company!"), company, "ALL")>
				#tour_cancelfee#
                <br>
                <br>
                </span>
                <table width="85%" border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="##000066">
                  <tr>
                    <td width="50%"><div align="center"><span class="SubTitle style1 style2">Included:</span></div></td>
                    <td width="50%"><div align="center"><span class="SubTitle style1 style2"><span class="style4"><u>NOT</u> Included:</span></span></div></td>
                  </tr>
                  <tr>
                    <td width="50%" valign="top" bgcolor="##FFFFFD"><span class="RegularText">
					<cfset tour_include = Replace(tours.tour_include, (Chr(13) & Chr(10)), "<br />", "ALL")>
					<cfset tour_include = Replace(tour_include, ("!company!"), company, "ALL")>
					#tour_include#
					</span></td>
                    <td width="50%" valign="top" bgcolor="##FFFFFD"><span class="RegularText">
					<cfset tour_notinclude = Replace(tours.tour_notinclude, (Chr(13) & Chr(10)), "<br />", "ALL")>
					<cfset tour_notinclude = Replace(tour_notinclude, ("!company!"), company, "ALL")>
					#tour_notinclude#
					</span></td>
                  </tr>
                </table>
              <span class="RegularText"><br>
                <center>
                  <strong><span class="SubTitle"></span>For further information regarding tours and flights:</strong><BR>
                  Call Toll Free: 1-800-983-7780 from 9:00am to 8:00pm Eastern Standard Time
                </center>
              </span></td>
          </tr>
          <tr><td height="45" scope="row" align="center" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
                <a href="index.cfm">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="forms.cfm">Forms</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td></tr>
        </table>
        </cfoutput>
        </div>

        <!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end subPages --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
