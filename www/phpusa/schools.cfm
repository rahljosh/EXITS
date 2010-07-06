<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DMD - Private High Schools </title>
<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
<!--

-->
</style>
<link href="css/phpusa.css" rel="stylesheet" type="text/css" />

<cfquery name="school" datasource="mysql">
	SELECT schoolid as School_ID, schoolname as School_Name, city as School_City, active as School_Active, smg_states.state as School_state
	FROM php_schools
	LEFT JOIN smg_states ON smg_states.id = php_schools.state
	WHERE active = 1 AND show_school = 1
	ORDER BY smg_states.state, city
</cfquery>
<style type="text/css">
<!--
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #F9A423;
	text-decoration: none;
}
a:active {
	text-decoration: none;
}
-->
</style></head>

<body class="oneColFixCtrHdr">

<div id="container">
  <cfinclude template="header.cfm">
  <div class="spacer"></div>
  
  <div id="mainContent">
  <div id="mainContentPad">
  <div class="spacerlg"></div>
  
  <div class="photobox"><a href="slideshow/index.html" target="_blank"><img src="images/highSchools/schoolsstroke.gif" width="350" height="250" border="0" /></a>
    <div class="testimonial">"My name is Cairo Santos, and ever since I was 15 years old, I had this awesome idea of coming to the USA. With the assistance and support of my parents, I realized this could be a dream-fulfilling experience, and it sure was, because I received a football scholarship to Tulane University. The memories I hold of everything I experienced during those amazing three years as an exchange student are simply the best. <br />

<strong>Cairo Santos -- Brazil</strong>
<br /></div>
    <!-- end photobox --></div>

     <p class="headline">High School</p>
<p>Please click on the city or state below to learn more about each school we work with.  Please feel free to <a href="contact.cfm" class="menu2">CONTACT US</a> with questions about any school on this list. </p>
                  <table width="48%" border=0 cellpadding=4 cellspacing=0>
	<blockquote><tr>
		<th width=85>
		  <p><strong>City</strong></p>
		  </th>
		<th width=45><p><strong>State</strong></p></th>
        <th width=85>
		  <p><strong>City</strong></p>
		  </th>
		<th width=45><p><strong>State</strong></p></th>
	</tr></blockquote>
</table>
<table width="45%" border=0 cellpadding=4 cellspacing=0>
<CFOUTPUT QUERY="school">
 <blockquote>
	<cfif currentrow mod 2>
         </tr>
    	<tr bgcolor="#iif(school.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" class="orange">
     
     </cfif><td width=289>
       <p><a href="details.cfm?School_id=#URLEncodedFormat(Trim(School_id))#"class="menu">#School_City#</a></p>
     </td>
     <td width=98><a HREF="details.cfm?School_id=#URLEncodedFormat(Trim(School_id))#" class="menu">#School_State#</a></td>
</blockquote>
</CFOUTPUT>
</table><br />

<div class="clearfix"></div> 
<!-- end mainContentPad --></div>
<div class="bottomGradient"></div>
  <!-- end mainContent --></div>
  <div class="spacersm"></div>
<cfinclude template="footer.cfm">
  <div class="spacersm"></div>
<!-- end container --></div>
</body>
</html>
