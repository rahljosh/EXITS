<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>International Student Exchange</title>
<link href="css/iseusa.css" rel="stylesheet" type="text/css" /><style type="text/css">
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
<div id="logo"><a href="index.cfm"><img src="images/logo.png" width="235" height="148" alt="ise logo" border="0" /></a></div>
<div id="header">
  <div class="topbuttons">
    <table width="200" border="0">
      <tr>
        <td><a href="##"><img src="images/contactus.png" width="65" height="32" border="0" /></a></td>
        <td><a href="##"><img src="images/faq.png" width="86" height="32" border="0" /></a></td>
        <td><a href="Login/login.cfm" target="_blank"><img src="images/login.png" width="86" height="32" border="0" /></a></td>
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
        <cfelse>#text#</cfif><a href="#showcase.link#"><font size=-3 font color="CD381A"> more</font></a></div>
  </div><!-- end studenTab -->
  </cfloop>
  </div> <!-- end sidebarR -->
<div id="container">
<div class="whiteInfo">

  <table width="365" height="219" border="0">
    <tr>
      <td height="31" colspan="2" class="header4">#showcase.title#</td>
      </tr>
    <tr>
      <td width="242" class="text1">#showcase.text#<a href="#showcase.link#"><font size=-3 font color="CD381A"> more</font></a>
        </p>
      </span></td>
      <td width="127"><img src="whiteTabs/images/#showcase.image#"></td>
    </tr>
    </table>
    
</div>
<div id="bluegradient">
<cfinclude template="bullets.cfm">
</div> <!-- end bluegradient -->
</div><!-- end container -->
 <div id="tabs"></div>
<div id="bottomSec">
<div class="bText">
  <table width="651" height="265" border="0">
      <tr>
        <td width="276" height="261"><p class="linksY"><span class="header5">International Student Exchange</span></p>
          <p class="text1"><span class="text2">We at ISE are proud of our organization. Programs have been designed that help put students, schools and families above all else in such wonderful cultural and educational programs.  Similarly, we have developed a structure that has assisted and helped supervise the work experience programs to consider the effects on all host companies, communities and participating work experience individuals.  Regardless of what program SMG assists, our goal is to help bring people of the world closer together.  That is what motivates everyone at SMG to achieve in our daily work.</span></p>
          <p class="text1"><span class="linksY">more info...</span></p></td>
        <td width="365"><img src="images/baseball.gif" width="300" height="225" border="1" /></td>
      </tr>
    </table>
  </div><!-- bText -->
</div><!-- bottomSec -->
<div class="bottomTabs">
  <table width="200" border="0" align="center">
  <tr>
    <td><img src="images/BaggageInsurance.png" width="152" height="35" /></td>
    <td><img src="images/GlobalSecutive.png" width="152" height="34" /></td>
    <td><img src="images/taxBack.png" width="152" height="35" /></td>
    <td><img src="images/chinaAffiliate.png" width="70" height="34" /></td>
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
