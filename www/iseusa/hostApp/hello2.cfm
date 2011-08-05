<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
<style type="text/css">
<!--

-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
</head>

<body class="oneColFixCtr">
<Cfparam name="client.menuSel" default="Overview">
<cfquery name="hostInfo" datasource="mysql">
SELECT shl.firstname, shl.lastname, shl.address, shl.address2, shl.city, shl.stateID, shl.zipCode, shl.email, shl.phone, smg_states.state
FROM smg_host_lead shl
LEFT JOIN smg_states on smg_states.id = shl.stateID
where email = '#client.email#'
</cfquery>
<cfoutput>
<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBoxB">
  <div class="blueBox">
  <a href="../index.cfm"><img src="../hostApp/images/logo_21.png" width="214" height="165" alt="ISE logo" border="0" /></a>
<cfinclude template="includes/leftMenu.cfm">
<!--logoBoxB --></div>
<!--blueBox --></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><!-- end title --></div>
<div class="tabsBar">
  <cfinclude template="../tabsBar.cfm">
  <!-- end tabsBar --></div>
<div id="mainContent">
<div id="subPages">
      <div class="whtTop"></div>
  <div class="whtMiddletours2">
        <div class="tripsTours">
       
  
          <h1 class="enter">Welcome #lcase(hostInfo.lastname)# Family!</h1>
          <p></p>
      
        
       <table width=80%>
       	<tr>
        	<Th><u>Contact Info</u></Th><th><u>Status</u></th>
        </tr>
        <Tr>
        	<Td valign="top">
            <p class="p_uppercase">#hostInfo.firstName# #hostInfo.lastname#<Br />
            #hostInfo.address#<br />
            <cfif hostInfo.address2 is not ''>#hostInfo.address2#<br /></cfif>
            #hostInfo.city# #hostInfo.state#, #hostInfo.zipCode#</p></Td>
            <td valign="top">Initial - Student view limited.<br />
            Rep - N/A<br />
            Region - N/A </td>
         </Tr>
        </table>
        <br />
        <Table align="center">
        <tr>
        	<Td><a href="../viewStudents.cfm"><img src="../images/subMeetStudents.png" width="207" height="138" border=0/></a></Td><td>View perspective students that are coming to the United States from various countries below.  Due to Department of State regulations, we are unable to limit the view to students that are in your specific area until you have passed some preliminary interview with a representative.   Once you have visited with a representative regarding the process your account will then have access to see specific students in your area.</td>
        </tr>
        <tr>
        
            <td><a href="startHostApp.cfm"><img src="../images/subBhost.png" width="207" height="138" border=0 /></a></td><td>Please feel free to start your host family application as this will help speed up the placement process.</td>
            
        </tr>
        </table>
        
        
        
        <div id="main" class="clearfix"></div>
      <!-- endtripTours --></div>
      <div id="main" class="clearfix"></div>
      <!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end subpages --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</cfoutput>
</body>
</html>
