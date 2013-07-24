<cfparam name="url.page" default="home">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Exchange Service International: Bringing the F-1 program to public schools</title>
<link href="css/ESI.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div class="container">
<!--- HEADER  --->
<cfinclude template="includes/header.cfm">

<!---LOGO AND SLIDESHOW SECTION--->
  <div class="display">
  	<div class="left"><table width="250" border="0" cellspacing="8" cellpadding="5" align="center">
  <tr>
    <td><a href="index.cfm"><img src="images/logo_ESI.jpg" width="250" height="88" alt="Exchange Student International logo" /></a></td>
  </tr>
  <tr>
    <td><p>&nbsp;</p><p>Welcomes you to "the F-1 Program in the Public Schools".</p></td>
  </tr>
</table>
<!-- end display left --></div>
    <div class="right">
    <cfinclude template="slideshow/index.cfm"></div>
<!-- end display --></div>

<!---DROP DOWN MENU--->
<div class="menu">
<cfinclude template="menu/ESI_Menu.cfm">
</div>

<!---LEFT SIDE BAR--->
<cfinclude template="includes/sidebar1.cfm">

<!---MAIN CONTENT--->
  <div class="content">
    <cfinclude template= "#url.page#.cfm">
    <!-- end .content --></div>
    
  <!---RIGHT SIDEBAR--->  
<cfinclude template="includes/sidebar2.cfm">

<!---FOOTER --->
  <div class="footer">
 
    <!-- end .footer --></div>
  <!-- end .container --></div>
</body>
</html>
