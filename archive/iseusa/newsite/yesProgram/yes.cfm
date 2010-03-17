<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>International Student Exchange</title>
<link href="../css/iseusa.css" rel="stylesheet" type="text/css" /><style type="text/css">
<!--
a:link {
	text-decoration: none;
	color: #666;
}
a:visited {
	text-decoration: none;
	color: #666;
}
a:hover {
	text-decoration: none;
	color: #999;
}
a:active {
	color: #999;
}
-->
</style></head>
<cfset showcase.id = 1>


<cfquery name="other_items" datasource="mysql">
SELECT *
FROM external_site
where rand()
and id <> #showcase.id#
LIMIT 3
</cfquery>


<body>
<cfoutput>
<div id="spacer"></div>
<div id="logo"><a href="../index.cfm"><img src="../images/logo.png" width="235" height="148" alt="ise logo" border="0" /></a></div>
<div id="header">
  <div class="topbuttons">
    <table width="200" border="0">
      <tr>
        <td><a href="##"><img src="../images/contactus.png" width="65" height="32" border="0" /></a></td>
        <td><a href="##"><img src="../images/faq.png" width="86" height="32" border="0" /></a></td>
        <td><a href="../Login/login.cfm" target="_blank"><img src="../images/login.png" width="86" height="32" border="0" /></a></td>
      </tr>
    </table>
  </div><!-- end topbuttons -->
</div> <!-- end header -->
<div id= "contentwrap" class="clearfix">
  <div id="containerMain">
  <div id="sidebarR">
  <cfloop query="other_items">
  <div id="#css_id#">
    <div class="#css_class#"> <cfif len(#text#) gt 150>#Left(text,100)#... 
        <cfelse>#text#</cfif><font size=-2> <a href="#link#">more</a></font></div>
  </div><!-- end studenTab -->
  </cfloop>
  </div> <!-- end sidebarR -->
<div id="containerYes">
  <div id="bluegradient">
    <div class="bullets">
    <ul> <li><a href="../index.cfm">HOME</a></li>
      <li>Host Family Info</li>
      <li>Student Info</li>
      <li>Incoming Students</li>
      <li>Project H.E.L.P</li>
      <li>Headquarter News</li>
      <li>ISE Trips</li>
      <li>Scholarships</li>
      <li>Web Store</li>
      <li>Contact Us</li>
    </ul>
    </div> <!-- end bullets -->
</div> <!-- end bluegradient -->
</div><!-- end container -->
 <div id="tabsYes"></div>
<div id="bottomSec">
<div class="imageHolderYes"><img src="images/yesII.jpg" width="250" height="194" border="1" /></div>
<div class="bTextYes">
  <p class="linksY"><span class="header5">Youth Exchange and Study (YES)</span></p>
  <p class="text2"><strong>Youth Exchange and Study (YES)</strong> is a program that was established in October, 2002 and sponsored by ECA to provide scholarships for high school students (15-17 years) from countries with significant Muslim populations to spend up to one academic year in the U.S. The program is vital to expanding communication between the people of the United States and the partner countries in the interest of promoting mutual understanding and respect. Students live with host families, attend high school, engage in activities to learn about American society and values, acquire leadership skills, and help educate Americans about their countries and cultures.</p>
  <p></p>
  <p class="text2">From 2003 to the present a total of 1,990 students have participated in the YES program. During the coming academic year, over 750 students will join the program from: Afghanistan, Bahrain, Bangladesh, Brunei, Egypt, Ethiopia, Gaza, Ghana, India, Indonesia, Israel (Arab Community), Jordan, Kenya, Kuwait, Lebanon, Malaysia, Mali, Morocco, Nigeria, Oman, Pakistan, Philippines, Qatar, Saudi Arabia, Senegal, Tanzania, Thailand, Tunisia, Turkey, West Bank, and Yemen.</p>
  <p></p>
 <p class="text2">Upon their return the students apply their leadership skills in their home countries. In addition, alumni groups have formed and been involved with many community service activities including clothing drives, mentoring younger children and English teaching, immunization drives, and much more.</p>
  <p></p>
  <p class="text2">ISE has placed 30 YES students with American host families for the 2009 - 10 school year.  Our YES students are an extraordinary group of young people.  They represent the best and brightest from their countries.  One of the students, Syed Aown Shahzad from Pakistan, recently participated in the opening of the United Nations General Assembly.  He was one of 13 students chosen to represent the Youth in the Secretary General’s Summit on Climate Change on September 22nd. He met with Secretary General Mr. Ban Ki Moon (the host of the Event), Barack Obama, Michelle Obama, Tony Blair, Gordon Brown, Nicolus Sarcozi, Queen Rania of Jordan, the German Chancellor, Ahmedinijad (for the 1st time in the UN) along with 100 more presidents and 97 foreign delegates.</p>
 <p></p>
 <p class="text2">ISE is very proud to have Aown and all the other YES students as part of our academic year program.  We encourage families in the U.S. to become involved in this program and bring these students to their communities.</p>
</div><!-- bText -->
</div><!-- bottomSec -->
<div class="bottomTabs">
  <table width="200" border="0" align="center">
  <tr>
    <td><img src="../images/BaggageInsurance.png" width="152" height="35" /></td>
    <td><img src="../images/GlobalSecutive.png" width="152" height="34" /></td>
    <td><img src="../images/taxBack.png" width="152" height="35" /></td>
    <td><img src="../images/chinaAffiliate.png" width="70" height="34" /></td>
  </tr>
</table>
</div><!-- bottomTabs -->
  </div><!-- end containerMain -->
</div> <!-- contentwrap -->
<p>
<div id="footer">
  <div class="botText"><a href="##">HOME</a> &nbsp;  | &nbsp;  <a href="##">Webstore</a>  &nbsp; | &nbsp;   <a href="##">Success Stories</a>&nbsp;   | &nbsp; <a href="##">Job Opportunities</a>   &nbsp; |  &nbsp; <a href="##"> Login </a> &nbsp; | &nbsp; <a href="##"> Contact Us</a> &nbsp; | &nbsp; <a href="##"> Headquarter News</a><span class="botTextItalic"><br />
 U.S. Department of State – Toll free: (866) 283-9090 – jvisas@state.gov</span> </div>
</div>
</cfoutput>
</body>
</html>
