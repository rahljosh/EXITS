<HTML>
<HEAD>
<TITLE>ISE - International Student Exchange | Private and Public High School Programs</TITLE>
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
            <td width="58%"><div align="center"><img src="images/top3.jpg" width="400" height="70"></div></td>
          </tr>
          <tr>
            <td height="248" colspan="2"><div align="justify">
<div class="style1"><span class="style1"><Cfif url.request is 'host'>
    <form action="submit_request.cfm?request=host" method="post">
    <cfelseif url.request is 'student'>
    <form action="submit_request.cfm?request=student" method="post">
    <Cfelseif url.request is 'agent'>
    <form action="submit_request.cfm?request=agent" method="post">
</cfif>
    <br>
&nbsp;&nbsp;    Fill out the following form to recieve more information on being  
<cfif url.request is "host">
   a host family
      <cfelseif url.request is "student">
      an exchange student
      <cfelseif url.request is "agent">
     an Area Representative
</cfif> 
and   
<cfif url.request is "agent">
    a Manager
      <cfelse>
      an Area Representative
</cfif> 
from your 
<cfif url.request is "Student">
    home country
      <cfelse>
      region
</cfif> 
will contact you shortly.
<br>
<BR>
</span></div>
<TABLE Align="center">
<TR><TD class="style1"><font face="Tahoma, Arial">First Name</font> </TD><TD class="style1">
  <input type="Text" name="Fname" size="30" maxlength="30">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">Last Name</font> </TD><TD class="style1">
  <input type="Text" name="Lname" size="30" maxlength="30">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">Email Address</font> </TD><TD class="style1">
  <input type="Text" name="email" size="30" maxlength="30">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">Street Address</font> </TD><TD class="style1">
  <input type="Text" name="address" size="30" maxlength="30">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">City</font> </TD><TD class="style1">
  <input type="Text" name="city" size="30" maxlength="30">
</td></tr>
<cfif url.request is "student"><TR><TD class="style1"><font face="Tahoma, Arial">Country of residence</font><font face="Tahoma, Arial">&nbsp;</font> </TD><TD><span class="style1">
  <input type="Text" name="country" size="30" maxlength="30">
  <cfelse>

			</span>
<TR><TD class="style1"><font face="Tahoma, Arial">State of residence</font><font face="Tahoma, Arial">&nbsp;</font> </TD><TD>
			<span class="style1">
			<select name="state" size="1">
				  <option value="">
				  <option value="AL">	Alabama
				  <option value="AK">	Alaska
				  <option value="AZ">	Arizona
				  <option value="AR">	Arkansas
				  <option value="CA">	California
				  <option value="CO">	Colorado
				  <option value="CT">	Connecticut
				  <option value="DE">	Delaware
				  <option value="DC">	District of Columbia
				  <option value="FL">	Florida
				  <option value="GA">	Georgia
				  <option value="HI">	Hawaii
				  <option value="ID">	Idaho
				  <option value="IL">	Illinois
				  <option value="IN">	Indiana
				  <option value="IA">	Iowa
				  <option value="KS">	Kansas
				  <option value="KY">	Kentucky
				  <option value="LA">	Louisiana
				  <option value="ME">	Maine
				  <option value="MD">	Maryland
				  <option value="MA">	Massachusetts
				  <option value="MI">	Michigan
				  <option value="MN">	Minnesota
				  <option value="MS">	Mississippi
				  <option value="MO">	Missouri
				  <option value="MT">	Montana
				  <option value="NE">	Nebraska
				  <option value="NV">	Nevada
				  <option value="NH">	New Hampshire
				  <option value="NJ">	New Jersey
				  <option value="NM">	New Mexico
				  <option value="NY">	New York
				  <option value="NC">	North Carolina
				  <option value="ND">	North Dakota
				  <option value="OH">	Ohio
				  <option value="OK">	Oklahoma
				  <option value="OR">	Oregon
				  <option value="PA">	Pennsylvania
				  <option value="RI">	Rhode Island
				  <option value="SC">	South Carolina
				  <option value="SD">	South Dakota
				  <option value="TN">	Tennessee
				  <option value="TX">	Texas
				  <option value="UT">	Utah
				  <option value="VT">	Vermont
				  <option value="VA">	Virginia
				  <option value="WA">	Washington
				  <option value="WV">	West Virginia
				  <option value="WI">	Wisconsin
				  <option value="WY">	Wyoming
			      </select>
			</span></td></tr>
</cfif>

<tr><td class="style1"><font face="Tahoma, Arial">Zip Code</font> </TD><TD class="style1">
  <input type="Text" name="zip" size="10" maxlength="15">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">Daytime phone number</font> </TD><TD class="style1">
  <input type="Text" name="Dphone" size="20" maxlength="20">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">Evening phone number</font> </TD><TD class="style1">
  <input type="Text" name="Nphone" size="20" maxlength="20">
</td></tr>
<TR><TD class="style1"><font face="Tahoma, Arial">Additional Comments</font> </TD><TD class="style1">
  <textarea name="comment" cols="30" rows="4" wrap="VIRTUAL"></textarea>
</td></tr>

<TR><TD colspan="2" align="center" class="style1">
  <input type="Submit" name="" value="Submit">
</td></tr>
</table>
<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="70" valign="top" background="images/back-squares3.jpg"><div align="center"></div>                    <div align="center"></div></td>
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
  <area shape="rect" coords="523,7,652,22" href="mailto:contact@iseusa.com">
</map>
</BODY>
</HTML>