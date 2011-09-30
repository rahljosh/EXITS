<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
a:link {
	color: #003;
	text-decoration: none;
}
a:visited {
	color: #003;
	text-decoration: none;
}
a:hover {
	color: #BE1E2D;
	text-decoration: underline;
}
a:active {
	color: #003;
	text-decoration: none;
}
a {
	font-weight: bold;
}
.lightGreen {
	color: #000;
	background-repeat: repeat;
	text-align: center;
	background-color: #a5aac7;
}
.accent {
	background-color: #F5E5E5;
}
h1 {
	font-family: Arial, Helvetica, sans-serif;
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}
-->
</style></head>

<body>

<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">
   
    <h1 class="enter">Student Tours</h1>
          <em><font color="#be1e2d" size=+1><strong><div align="center">For CASE students ONLY!</div></strong></font></em>
          <p>Cultural Academic Student Exchange and our partner organization, MPD Tour America are proud to offer this year's CASE Trips of exciting adventures across America. MPD Tour America will be organizing 9 CASE trips, chaperoned and supervised exclusively by CASE Representatives, for the 2010-11 season.</p>
         <cfoutput>
<cfset company = 'CASE'>
 <br>
        <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours WHERE tour_id = #url.tour_id#
		</cfquery>
        <div class="tours"> 
        <table width="665" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr><td height="45" scope="row" align="center" ><img src="../images/webStore_lines_03.gif" width="655" height="15" alt="line" /><br />
                <a href="/trips">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="655" height="14" /></td></tr>
          <tr>
            <td width="665"><table width="101%" border="0" align="center" cellpadding="5" cellspacing="0" class="bBackground">
              <tr class="accent">
                    <td width="28%" height="62" align="center">
					
						<cfset tour_name = Replace(tours.tour_name, (Chr(13) & Chr(10)), "<br />", "ALL")>
					  	<cfset tour_name = Replace(tour_name, ("!company!"), company, "ALL")>
                        <span class="TitlesLG">#tour_name#</span><br />
                        <cfset tour_price = Replace(tours.tour_price, (Chr(13) & Chr(10)), "<br />", "ALL")>
						<cfset tour_price = Replace(tour_price, ("!company!"), company, "ALL")>
					  		
                            <span class="SubTitle">
			  		    #LSCurrencyFormat(tour_price, 'local')#</span>
                        </td>
                    <td width="48%">
					  <cfset tour_date = Replace(tours.tour_date, (Chr(13) & Chr(10)), "<br />", "ALL")>
					  <cfset tour_date = Replace(tour_date, ("!company!"), company, "ALL")>
                      	  <span class="SubTitleLG">#tour_date#</span>
<cfset tour_price = Replace(tours.tour_price, (Chr(13) & Chr(10)), "<br />", "ALL")>
					  		<cfset tour_price = Replace(tour_price, ("!company!"), company, "ALL")>
					  		<span class="SubTitle"><br />
			  		  #tours.tour_length#</span></td>
                    <td width="24%">
                     <cfif tours.tour_status EQ 'Full'><font color='FF0000' size='2'><b><center>No More Seats Available!!</center></b></font>
                     <cfelseif tours.tour_status EQ 'Cancelled'><font color='FF0000' size='2'><b><center>Cancelled!!</center></b></font><cfelse> <a href="selectTrips.cfm?tour_id=#tour_id#"><img src="images/reserve_class.png" alt="reserve spot" border="0" /></a> 
                     </cfif>
                   
                    </td>
                  </tr>
                </table>
              <span class="RegularText">
			 
                <br>
				<cfset tour_description = Replace(tours.tour_description, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_description = Replace(tour_description, ("!company!"), company, "ALL")>
				#tour_description#
				</span><br>
              <br>
                <span class="SubTitle"> <img src="http://case.exitsapplication.com/nsmg/uploadedfiles/student-tours/#tours.tour_img2#.jpg" width="215" hspace="10" border="0" align="left" class="image-left"> Flights:</span><br>
                <span class="RegularText">
				<cfset tour_flights = Replace(tours.tour_flights, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_flights = Replace(tour_flights, ("!company!"), company, "ALL")>
				#tour_flights#
				<br>
                <br>
                <span class="SubTitle">Payment:</span><br>
				<cfset tour_payment = Replace(tours.tour_payment, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_payment = Replace(tour_payment, ("!company!"), company, "ALL")>
				#tour_payment#<br>
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

        </table></div>
        <br />
        </cfoutput>
      
    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>



</body>
</html>
