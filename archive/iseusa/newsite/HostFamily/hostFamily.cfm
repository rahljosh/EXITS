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
<cfquery name="showcase" datasource="mysql">
select *
from external_site
where active = 1
order by rand()
limit 1
</cfquery>


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
<div id="containerHost">
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
 <div id="tabsHost"></div>
<div id="bottomSec">
<div class="imageHolderYes"><img src="images/familyphoto.png" width="250" height="167" /></div>
<div class="bTextYes">
  <p class="linksY"><span class="header5">HOST FAMILY INFO</span></p>
  <p class="text2"> ISE host families are middle class Americans. They open their heart and home to young people from over 55 countries. Each host family has an Area Representative who will meet with them and help them select the ideal student for their home. Students have as many interests and hobbies as any American teen. And, they are eager to share their native culture with their new American family, community and school. Students attend the local high school and participate in as many school activities as their interests and the school permit.</p>
<p></p>
<p class="text2">Our International Representatives send their students to ISE because ISE is famous all over the world for its wonderful, warm and loving host families. Please consider hosting a student from ISE to enrich your life.</p>
<p></p>
<p class="text2">To be an ISE host family, you must be able to provide a warm and loving home with full room and board. Students may share a room with siblings of the same sex. A host family consists of two or more people related by blood or marriage. Single parents with children may host if they meet the ISE requirements.</p>
<p></p>
<p class="text2">We ask that our families treat their student as they would their own; with love, concern, kindness and the little extra parenting which helps a youth grow into adulthood. Our ISE Area Representatives and Regional Directors are available should a family have any questions or concerns. After meeting with you, the ISE Area Representative will secure school approval and then assist you every step of the way to make this the experience of a lifetime.</p>
<p></p>
<p class="text2">Many host families have questions about foreign students. What are they really like? It is impossible to generalize about all students. But we can say that students who are successful in the ISE program share several positive characteristics. They are sincerely eager to learn about America first hand. They are willing to be flexible and adaptable as they learn to live in their new home. They are respectful towards the school and family which have made this year possible. They speak English well enough to function in an American school and home. They are at least above average students in their own country. They understand that ISE does not promise a diploma or graduation, sports participation or a driver's license. Students must have their own spending money - enough to cover school supplies, school fees and personal items. </p>
<p class="linksY"> <a href="hostFamilyII.cfm"><img src="images/next.png" width="40" height="13" /></a></p>
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
