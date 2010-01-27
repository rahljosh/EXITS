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
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style5 {	color: #FFFFFF;
	font-weight: bold;
}
.style6 {	color: #2E4F7A;
	font-weight: bold;
}
.style7 {font-size: 14px}
.style8 {color: #FF0000}
.style13 {	font-size: 10px;
	color: #FF0000;
	font-weight: bold;
}
.style9 {font-size: 10px}
.style14 {color: #293926; font-family: Verdana, Arial, Helvetica, sans-serif;}
-->
</style><script src="../menu.js"></script>
</HEAD>
<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<cfif form.required NEQ "" OR form.emailRequired NEQ ""> 
	<script>
		alert("Error! Please try again!");
		history.back(1);
	</script>
</cfif>
<cfif form.company EQ "ISE"> 

<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD COLSPAN=3><script>menutop();</script></TD>
	</TR>
	<TR>
		<TD width="17" background="../../images/blank_02.gif">&nbsp;			</TD>
		<TD width="736" bgcolor="#FFFFFF"> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="42%"><div align="center"><img src="../images/ISEtrips.jpg" width="266" height="70"></div></td>
            <td width="58%"><img src="../images/top1.jpg" width="400" height="70"></td>
          </tr>
          <tr>
            <td height="305" colspan="2">
              <div align="center"> <br>
                <table width="70%" border="0" cellspacing="1" cellpadding="0">
                  <tr>
                    <td width="18%" height="22" bgcolor="#2E4F7A" class="style1"><A href="index.cfm" class="style5">
                      <div align="center">Home</div>
                    </A></td>
                    <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style5">Contact</a></div></td>
                    <td width="28%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="rules.html" class="style5">Rules &amp; Policies</a></div></td>
                    <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="form.html" class="style5">Forms</a></div></td>
                    <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style5">FAQs</a></div></td>
                  </tr>
                </table>
                <br>
                <span class="style3"><strong class="style1">Deposit Form </strong><br>
                </span><br>
                <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td class="style1"><div align="center">
                        
                        <cfset desc= 'ISE Trip Deposit Form'>
                        
						<cfmail to="info@mpdtoursamerica.com" bcc="bruno@student-management.com" from="trips@iseusa.com" subject="ISE Trip Deposit Form">
                        
#desc# from the ISE Trip web site on #dateformat(Now())#.
						  
Company: ISE
                          
Payment: #form.payment#
Card Number: #form.card#
Expires: #form.expires#
Name on Card: #form.name#
Charge: #form.charge# - #form.other#

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
                            The following information was submitted to ISE Trip: </span><br>
                          </div>
                          <cfoutput>
                            <table width=90% align="center">
                              <tr>
                                <td class="style1"><span class="style14"> Payment: #form.payment#<br>
                                  Card Number: #form.card#<br>
                                  Expires: #form.expires#<br>
                                  Name on Card: #form.name#<br>
                                  Charge: #form.charge# - #form.other#<br>
                                  <br>
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
                                  Phone: #form.phone#<br>
                                  <br>
                                  ----------------------------------------<br>
                                  Airport Information <br>
                                  ----------------------------------------<br>
                                  State: #form.stateaiport#<br>
                                  Airport: #form.airport#<br>
                                  <br>
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
                        </div></td>
                  </tr>
                </table>
                <span class="style1"><br>
                </span></div></td></tr>
        </table></TD>
		<TD width="17" background="../images/blank_04.gif">&nbsp;			</TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<IMG SRC="../images/blank_05.gif" ALT="" WIDTH=770 HEIGHT=34 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>
<map name="Map">
  <area shape="rect" coords="521,6,655,22" href="mailto:contact@iseusa.com">
</map>
</cfif>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-2";
urchinTracker();
</script>
</BODY>
</HTML>