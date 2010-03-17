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
<div class="imageHolderYes"><img src="images/imagem3.png" width="250" height="184" /></div>
<div class="bTextYes">
  <p class="linksY"><span class="header5">HOST FAMILY INFO</span> Continued</p>
  <p class="text2"> A trained ISE Area Representative visits each prospective host family. During this first visit the Area Representative will ask you questions about your family life. This will help the Area Representative in deciding if your family is ready to host a student for a full year or semester. The Area Representative will ask to see your home. ISE families have typical middle class homes. It is important that the Area Representative see the bedroom where the student will sleep and the general living areas, including bathrooms. If you were sending your child to a new family, you would want the same done for him or her.</p>
<p></p>
<p class="text2">The Area Representative will then ask you about your lifestyle. Do you enjoy sports? Do you have a more sedentary life style? Are you active church goers or do you only participate on holidays? Do you smoke? What do your children (if you have any) enjoy doing? Is everyone excited about hosting?</p>
<p></p>
<p class="text2">If you and the Area Representative agree that hosting is a good thing for your family, you will complete the ISE host family application. The application includes writing a letter to your prospective student and sending along some recent photos of your family. You will be asked to give the names, addresses, and phone numbers of references.</p>
<p></p>
<p class="text2">The ISE Area Representative will then contact the local high school to let them know that you may be hosting a student. If the high school allows foreign students to attend, the ISE Area Representative will continue the screening process by calling your references and asking them to send in written references as well.</p>
<p></p>
<p class="text2">The Area Representative will then return with student applications. You and your family will enjoy selecting the perfect student for your family.</p>
<p><img src="images/viewIncoming.png" width="171" height="13" alt="incoming Students" /></p>
<p><img src="images/beContacted.png" width="235" height="13" alt="contacted" /></p>
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
