<HTML>
<HEAD>
<TITLE>ISE - International Student Exchange | Private and Public High School Programs</TITLE>
<META NAME="Keywords" CONTENT="homestay, exchange student, foreign students, student exchange, foreign exchange, foreign exchange program, academic exchange, student exchange program, high school, high school program, host family, host families, public high school program, private high school program, public high school, private high school, American exchange">
<META NAME="Description" CONTENT="ISE offers semester programs, as well as school year programs, that allow foreign students the opportunity to become familiar with the American way of life by experiencing its schools, homes and communities. ISE can also now offer students the opportunity to study at some of America's finest Private High Schools. ISE works with a network of independent international educational partners who provide information, screening and orientations for prospective applicants to a variety of education and training programs in the United States.">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	background-color: #000343;
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
	background-image: url(images/botton.gif);
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
</style>
<script src="../menu.js"></script>
</HEAD>
<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<cfoutput>
<cfset company = 'ISE'>
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD COLSPAN=3><script>menutop();</script></TD>
	</TR>
	<TR>
		<TD width="17" background="../../images/blank_02.gif">&nbsp;			</TD>
		<TD width="736" bgcolor="##FFFFFF"> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="42%"><div align="center"><img src="../images/ISEtrips.jpg" width="266" height="70"></div></td>
            <td width="58%"><img src="../images/top1.jpg" width="400" height="70"></td>
          </tr>
          <tr>
            <td height="305" colspan="2">
              <div align="center"> <br>
                <table width="70%" border="0" cellspacing="1" cellpadding="0">
                  <tr>
                    <td width="18%" height="22" bgcolor="##2E4F7A" class="style1"><A href="index.cfm" class="style5">
                      <div align="center" class="style6">Home</div>
                    </A></td>
                    <td width="18%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style6">Contact</a></div></td>
                    <td width="28%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="rules.html" class="style6">Rules &amp; Policies</a></div></td>
                    <td width="18%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="form.html" class="style6">Forms</a></div></td>
                    <td width="18%" bgcolor="##2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style6">FAQs</a></div></td>
                  </tr>
                </table>
                <br>
        <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours WHERE tour_id = #url.tour_id#
		</cfquery> 
        <table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
          <tr>
            <td><img src="http://www.student-management.com/nsmg/uploadedfiles/student-tours/#tours.tour_img1#.jpg" width="300" border="0" align="right" class="image-right">
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
        </table>
		
		         <span class="style1"><br>
                </span></div></td></tr>
        </table></TD>
		<TD width="17" background="../images/blank_04.gif">&nbsp;			</TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<IMG SRC="../images/blank_05.gif" ALT="" WIDTH=770 HEIGHT=34 border="0" usemap="##Map"></TD>
	</TR>
</TABLE>
<map name="Map">
  <area shape="rect" coords="521,6,655,22" href="mailto:contact@iseusa.com">
</map>
</cfoutput>
</BODY>
</HTML>