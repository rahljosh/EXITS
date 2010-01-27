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
</style><script src="../menu.js"></script></HEAD>
<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<cfoutput>

<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD COLSPAN=3><script>menutop();</script></TD>
	</TR>
	<TR>
		<TD width="17" background="../../images/blank_02.gif">&nbsp;			</TD>
		<TD width="736" bgcolor="FFFFFF"> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="42%"><div align="center"><img src="../images/ISEtrips.jpg" width="266" height="70"></div></td>
            <td width="58%"><img src="../images/top1.jpg" width="400" height="70"></td>
          </tr>
          <tr>
            <td height="305" colspan="2">
              <div align="center"> <br>
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
			  - Attention: Please read the questions first.<Br>
			  - Remember you must  have approval from your host family before you sign up. <br>
              - You will need to  have school and exchange representative signatures before you travel. 
              <br>
            </p>
              </td>
                  </tr>
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