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
	border: 1px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	color: #000066;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style5 {	color: #FFFFFF;
	font-size: 10px;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
.style6 {	color: #FFFFFF;
	font-size: 12px;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
.style7 {	color: #2E4F7A;
	font-size: 10px;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
-->
</style>
<script src="../flash/menu.js"></script></HEAD>
<BODY>
<cfoutput>
<div align="center">
  <table width="770" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img src="../flash/images/smgtrip.jpg" width="770" height="43"></td>
    </tr>
    <tr>
      <td background="../flash/images/about_02.gif"><div align="center">
        <table width="70%" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td width="16%" height="22" bgcolor="FFFFFF" class="style1"><div align="center" class="style7">Home</div></td>
            <td width="19%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style5">Contact</a></div></td>
            <td width="30%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="rules.html" class="style5">Rules &amp; Policies</a></div></td>
            <td width="15%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="form.html" class="style5">Forms</a></div></td>
            <td width="20%" bgcolor="2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style5">Questions?</a></div></td>
          </tr>
        </table>
        <br>
        <table width="92%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="39" valign="top"><p align="justify" class="style1">
			   
			  - Remember you must  have approval from your host family before you sign up. <br>
              - You will need to  have school and exchange representative signatures before you travel. 
              <br><br>
            </p>
              </td>
              <td>
              <img src = "pics/spot.png" width = 200 height = 40>
              </td>
          </tr>
          <tr>
          	<td colspan=2 align="center"><font size = +1><strong>Attention:</strong><a href ="faqs.html"><font color="##000000">&nbsp; Please Read the Questions First.</font></font></a><Br></td>
        </table>
		
		<cfquery name="tours" datasource="mysql">
					SELECT *
					FROM smg_tours
					WHERE tour_status <> 'Inactive'
					ORDER BY tour_name
				</cfquery> 
				
				<cfset company = 'SMG'>
				
                <table width="95%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
				  
				  
				 <cfset i=0>
				  
				  <cfloop query="tours">
				  	<cfset i=i+1>	
                    <td width="50%">
					
                      <table width="95%" border="0" cellpadding="0" cellspacing="2" bgcolor="##2E4F7A" align="center">
                        <tr>
                          <td width="150" rowspan="2"><span class="SubTitle"><img src="http://www.student-management.com/nsmg/uploadedfiles/student-tours/#tours.tour_img2#.jpg" width="150" border="0"></span></td>
                          <td width="498" bgcolor="2E4F7A"class="style6" align="center" height="10">#Replace(tour_name, ("!company!"), company, "ALL")# </td>
                        </tr>
                        <tr>
                          <td bgcolor="##FFFFFF" class="style1" align="center">
						  <cfif tour_status EQ 'Full'><font color="FF0000"><b> No More Seats Available </b></font><br><br></cfif>
						  <cfif tour_status EQ 'Male Full'><font color="FF0000"><b> No More Seats Available <br> For Male Students </b></font><br><br></cfif>
						  <cfif tour_status EQ 'Female Full'><font color="FF0000"><b> No More Seats Available <br> For Female Students </b></font><br><br></cfif>
						  <cfif tour_id eq 10>  <strong><font color="98002E">You can still book this trip. Deadline 11-15-09</font></strong><br><br></cfif>
						  <cfif tour_id eq 7>  <strong><font color="98002E">You can still book this trip. Deadline 11-15-09</font></strong><br><br></cfif> 
						  <cfif tour_status EQ 'Cancelled'><font color="FF0000"><b> Cancelled </b></font><br><br></cfif> 
						  #tour_date#<br><br>
						  <table class="Boxx"><tr><td><b>&nbsp; #tour_price# &nbsp;</b></td></tr></table><br>
						  <a href="tours.cfm?tour_id=#tour_id#"><b><font color="2E4F7A">Read more</font></b></a>
						  </td>
                        </tr>
                      </table>
					  
					</td>
				<cfif i EQ 2>
						<cfset i=0>
						</tr> <tr><TD>&nbsp;</TD></tr> <TR>
					</cfif>
					</cfloop>
				</tr>
                 </table>
		
        <br>
      </div></td>
    </tr>
    <tr>
      <td><img src="../flash/images/about_04.gif" width="770" height="79"></td>
    </tr>
  </table>
</div>
</cfoutput>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-1";
urchinTracker();
</script>
</BODY>
</HTML>