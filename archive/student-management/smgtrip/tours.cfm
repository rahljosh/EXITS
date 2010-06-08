<HTML>
<HEAD>
<TITLE>Student Management Group | Student Exchange | Trainee Program | Work &amp; Travel</TITLE>
<META NAME="Keywords" CONTENT="homestay, exchange student, foreign students, student exchange, work and travel, trainee program, trainee, foreign students, foreign exchange, student exchange, student exchange program, high school, high school program">
<META NAME="Description" CONTENT="SMG helps manage 4 Americans Foreign Exchange companies. ISE, INTO, DMD and ASA are all experts in the placement of foreign students in American public and private high schools.  SMG also helps manage Work and Travel programs as well as the Trainee Programs for university students.  SMG provides the managerial leadership that has quickly moved SMG and its affiliates to the top of the exchange industry.  Its emphasis on quality performance for all of its employees and independent contractors has made SMG unique among its competitors.  The quantitative growth of SMG to over 3,000 students annualy is only one indicator of its qualitative nature.">
<META NAME="Author" CONTENT="support@student-management.com">
<link href="../flash/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 16px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 18px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #666666;
	font-weight: bold;
	font-size: 14px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
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
-->
</style>
<script src="../flash/menu.js"></script></HEAD>
<BODY onLoad="MM_preloadImages('../flash/images/principal_15b.gif')">
<cfoutput>
<cfset company = 'SMG'>
<div align="center">
  <table width="770" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img src="../flash/images/smgtrip.jpg" width="770" height="43"></td>
    </tr>
    <tr>
      <td background="../flash/images/about_02.gif"><div align="center">
        <table width="70%" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td width="18%" height="22" bgcolor="##2E4F7A" class="style1"><A href="principal.cfm" class="style5">
              <div align="center" class="style6">Home</div>
            </A></td>
            <td width="18%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style6">Contact</a></div></td>
            <td width="28%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="rules.html" class="style6">Rules &amp; Policies</a></div></td>
            <td width="15%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="form.html" class="style6">Forms</a></div></td>
            <td width="21%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style6">Questions?</a></div></td>
          </tr>
        </table>
        <br>
        <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours WHERE tour_id = #url.tour_id#
		</cfquery> 
        <table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
          <tr>
            <td><img src="http://www.student-management.com/nsmg/uploadedfiles/student-tours/#tours.tour_img1#.jpg" width="280" border="0" align="right">
                <table width="60%" border="0" align="center" cellpadding="5" cellspacing="0">
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
			  <cfif tours.tour_status EQ 'Male Full'><font color='FF0000' size='2'><b><center>No More Seats Available<br>For Male Students!!</center></b></font></cfif>
			  <cfif tours.tour_status EQ 'Female Full'><font color='FF0000' size='2'><b><center>No More Seats Available<br>For Female Students!!</center></b></font></cfif>
			  <cfif tours.tour_status EQ 'Cancelled'><font color='FF0000' size='2'><b><center>Cancelled!!</center></b></font></cfif>
                <br>
				<cfset tour_description = Replace(tours.tour_description, (Chr(13) & Chr(10)), "<br />", "ALL")>
				<cfset tour_description = Replace(tour_description, ("!company!"), company, "ALL")>
				#tour_description#
				</span><br>
              <br>
                <span class="SubTitle"> <img src="http://www.student-management.com/nsmg/uploadedfiles/student-tours/#tours.tour_img2#.jpg" width="175" border="0" align="left" hspace="10"> Flights:</span><br>
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
                <span class="SubTitle"><br>
                </span><br>
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
        </table>
      </div></td>
    </tr>
    <tr>
      <td><img src="../flash/images/about_04.gif" width="770" height="79"></td>
    </tr>
  </table>
</div>
</cfoutput>
</BODY>
</HTML>