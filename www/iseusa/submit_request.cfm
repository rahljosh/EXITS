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
.style7 {font-weight: bold; font-size: 12px; color: #000066;}
-->
</style><script src="menu.js"></script>
</HEAD>
<BODY LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<TABLE WIDTH=770 BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
	<TR>
		<TD COLSPAN=3><script>menutop();</script></TD>
	</TR>
	<TR>
		<TD width="17" background="images/blank_02.gif">&nbsp;			</TD>
		<TD width="736" bgcolor="#FFFFFF"> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="42%"><div align="center"><img src="images/contact.gif" width="266" height="70"></div></td>
            <td width="58%"><div align="center"><img src="images/top1.jpg" width="400" height="70"></div></td>
          </tr>
          <tr>
            <td height="248" colspan="2"><div align="justify"><br>
<cfparam name="Fname" default="Not filled in the request form">
<cfparam name="Lname" default="Not filled in the request form">
<cfparam name="email" default="">
<cfparam name="State" default="Not filled in the request form">
<cfparam name="Dphone" default="Not filled in the request form">
<cfparam name="Nphone" default="Not filled in the request form">
<cfparam name="Comment" default="Not filled in the request form">
<cfparam name="country" default="Not filled in the request form">

<cfif url.request is 'student'>
  <span class="style1">
<cfset desc = 'The following student requested information on being an exchange student'>
<cfelseif url.request is 'agent'>
<cfset desc= 'The following person requested information on becoming a Area Representative'>
<cfelseif url.request is 'host'>
<cfset desc='The following family requested information on hosting a student'>
<cfelse>
<cfset desc='Info submitted with no student/host/agent specifincation'>
  </span>
</cfif>

 
<cfif url.request is 'student'>
<cfmail to='bob@iseusa.com' cc='josh@pokytrails.com' from='request_for_info@student-management.com' subject=' #url.request# Request for Info'>
DO NOT REPLY TO THIS EMAIL<br> 
  <span class="style1">#desc# from the ISE web site on #dateformat(Now())#.

First Name: #form.fname#
Last Name: #form.lname#
E-Mail Address: #form.email#
Address: #form.address#<br>
City: #form.city#
Country: #form.country#
Day Phone: #form.dphone#
Evening Phone: #form.nphone#

Additional Comments: #form.comment#

--
  </span>
</cfmail>
<span class="style1">
<Cfelse>
<cfmail to='bob@iseusa.com' cc='josh@pokytrails.com' from='request_for_info@student-management.com' subject=' #url.request# Request for Info'>
  #desc# from the ISE web site on #dateformat(Now())#.
  

  First Name: #form.fname#
  Last Name: #form.lname#
  E-Mail Address: #form.email#
  Address: #form.address#
  City: #form.city#
  State: #form.state#
  Zip: #form.zip#
  Day Phone: #form.dphone#
  Evening Phone: #form.nphone#
  
Additional Comments: #form.comment#
  
--
</cfmail>
</span>
</cfif>
<span class="style1">
The following information was submitted to ISE:
<cfoutput><br>
</cfoutput></span><cfoutput><table width=90% align="center">
	<tr>
		<td class="style1">
First Name: #form.fname#<br>
Last Name: #form.lname#<br>
E-Mail Address: #form.email#<br>
<cfif url.request is 'student'>
  Address: #form.address#<br>
  City: #form.city#
  Country: #form.country#<br>
  <cfelse>
  Address: #form.address#<br>
  City: #form.city#<br>
  State: #form.state#<br>
</cfif>
Zip: #form.zip#
Day Phone: #form.dphone#<Br>
Evening Phone: #form.nphone#<br>
<br>

Additional Comments: #form.comment#
		</td>
	</tr>
</table>
</cfoutput><span class="style1">
You will be contacted shortly.</span><br>

<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="71" background="images/back-squares3.jpg"><div align="center"></div></td>
                </tr>
              </table>
              </div></td>
          </tr>
        </table></TD>
		<TD width="17" background="images/blank_04.gif">&nbsp;			</TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<IMG SRC="images/blank_05.gif" ALT="" WIDTH=770 HEIGHT=34 border="0" usemap="#Map"></TD>
	</TR>
</TABLE>
<map name="Map">
  <area shape="rect" coords="449,10,580,21" href="mailto:contact@iseusa.com">
</map>
</BODY>
</HTML>