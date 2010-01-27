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
<div id="containerbStudent">
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
 <div id="tabsStudent"></div>
<div id="bottomSec">
<div class="imageHolderYes"><img src="images/bestudentphoto.png" width="250" height="188" border="1" /></div>
<div class="bTextYes">
  <p class="linksY"><span class="header5">STUDENT INFORMATION</span></p>
  <p class="text2">For a foreign student, spending a semester or year in the US is the fulfillment of a lifetime dream. American culture plays an important role all over the world. English language is the international language of our times. And American families are known the world over for their warmth and generosity.</p>
<p></p>
<p class="text2">When a student returns to his/her own country, he/she will have gained maturity and insight into our culture and way of life as well as his/her own. They will have achieved a high level of fluency in English and will have participated in the most democratic of all school systems. Depending on their interests and abilities, they may have played in sports, participated in drama productions or performed in an American band or orchestra. The friends they make and the American family they have learned to love will be treasured forever.</p>
<p></p>
<p class="text2">Some students come to the US after graduating from high school in their own country. These serious students are truly interested in learning about life in the US. They often enjoy taking classes that might not be available in their own country.</p>
<p></p>
<p class="text2">Other students come to the US and need to have their courses convalidated in their own country in order to get credit for the year they have spent in the United States.</p>
<p></p>
<p class="text2">Still other students come to the US and know that they will not get credit at home for their classes, yet they come in order to spend a year in the US and enjoy all the experiences of being an exchange student that this program will provide them.</p>
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
