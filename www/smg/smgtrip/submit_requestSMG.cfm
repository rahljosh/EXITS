<HTML>
<HEAD>
<TITLE>Student Management Group | Student Exchange | Trainee Program | Work &amp; Travel</TITLE>
<META NAME="Keywords" CONTENT="homestay, exchange student, foreign students, student exchange, work and travel, trainee program, trainee, foreign students, foreign exchange, student exchange, student exchange program, high school, high school program">
<META NAME="Description" CONTENT="SMG helps manage 4 Americans Foreign Exchange companies. ISE, INTO, DMD and ASA are all experts in the placement of foreign students in American public and private high schools.  SMG also helps manage Work and Travel programs as well as the Trainee Programs for university students.  SMG provides the managerial leadership that has quickly moved SMG and its affiliates to the top of the exchange industry.  Its emphasis on quality performance for all of its employees and independent contractors has made SMG unique among its competitors.  The quantitative growth of SMG to over 3,000 students annualy is only one indicator of its qualitative nature.">
<META NAME="Author" CONTENT="support@student-management.com">
<link href="../flash/style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body,td,th {
	font-size: 14px;
}
.style5 {
	color: #FFFFFF;
	font-weight: bold;
}
.style6 {
	color: #2E4F7A;
	font-weight: bold;
}
.style7 {color: #293926; font-family: Verdana, Arial, Helvetica, sans-serif;}
-->
</style>
<script src="../flash/menu.js"></script></HEAD>
<BODY>
<cfif form.required NEQ "" OR form.emailRequired NEQ ""> 
	<script>
		alert("Error! Please try again!");
		history.back(1);
	</script>
</cfif>
<div align="center">
  <table width="770" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img src="../flash/images/smgtrip.jpg" width="770" height="43"></td>
    </tr>
    <tr>
      <td background="../flash/images/about_02.gif"><div align="center">
        <table width="70%" border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td width="18%" height="22" bgcolor="#2E4F7A" class="style1"><A href="principal.html" class="style5">
              <div align="center">Home</div>
            </A></td>
            <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="contact.cfm" class="style5">Contact</a></div></td>
            <td width="28%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="rules.html" class="style5">Rules &amp; Policies</a></div></td>
            <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="form.html" class="style5">Forms</a></div></td>
            <td width="18%" bgcolor="#2E4F7A" class="style1"><div align="center"><a href="faqs.html" class="style5">FAQs</a></div></td>
          </tr>
        </table>
        <br>
        <span class="style3"><strong>Deposit Form </strong><br>
        </span><br>
        <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td class="style1"><div align="center"> 
                    <cfset desc= 'SMG Trip Deposit Form'>
									
					  
					 <cfmail to="info@mpdtoursamerica.com"  from="trips@student-management.com" subject="SMG Trip Deposit Form">
					 
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
      </div></td>
    </tr>
    <tr>
      <td><img src="../flash/images/about_04.gif" width="770" height="79"></td>
    </tr>
  </table>
</div>
</BODY>
</HTML>