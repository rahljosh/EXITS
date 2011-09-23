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
<style type="text/css">
<!--
#footer3 {
	clear: both;
	height: 40%;
	margin: 0;
	background-color: #000;
	padding-top: 0;
	padding-right: 0;
	padding-bottom: 0;
	padding-left: 0;
	bottom: -8px;
	display: block;
}
.tripsTours {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	width: 675px;
	margin-left: 35px;
	margin-top: 10px;
	padding: 0px;
	text-align: left;
}
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	color: #000;
	text-decoration: none;
}
a:hover {
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 14px;
}
.TitlesLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 20px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 12px;
}
.SubTitleLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 16px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(file:///JW%20BACKUP/SMG/ISE/site/trips/images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:#000000;
	font-style: normal;
	font-weight: normal;
}
.style1 {color: #FFFFFF}
.style2 {font-size: 12px}
.style4 {font-size: 12}
.style5 {color: #FFFFFF; font-weight: bold; }
.style6 {
	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
.image-right {
border:solid 1px;
margin-right: 0px;
margin-left: 15px;
}
.image-left {
border:solid 1px;
margin-right: 15px;
margin-left: 0px;
}
.whtMiddletours2{
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
.bBackground {
	background-color: #C5DCEA;
	border: thin solid #000;
	text-align: center;
}
.border{border:solid 1px;}

li{
	line-height:24px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
}	
.submiterror{
	line-height:24px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16px;
	background-color:#FCC;
}
.error{background-color:#FF9DA7;
		
}
-->
</style>
</head>

<cfparam name="form.rulesread" default="0">
<cfparam name="form.booktravel" default="0">
<cfset client.selectedtrip = #url.tour_id#>
<Cfif isDefined('form.verifyRules')>
	<cfif form.rulesread eq 1 and form.booktravel eq 1>
		<cflocation url="step1.cfm?tour_id=#url.tour_id#">
    </cfif>
</Cfif>
<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="titleTrips.cfm"><!-- end title --></div>
<div class="tabsBar">
  <cfinclude template="../tabsBar.cfm">
  <!-- end tabsBar --></div>
<div id="mainContent">
<div id="subPages">
      <div class="whtTop"></div>
  <div class="whtMiddletours2">
        <div class="tripsTours">
           
        <cfquery name="trips" datasource="#APPLICATION.DSN.Source#">
        select *
        from smg_tours
        where tour_status = 'active'
        </cfquery>
       	<cfquery name="tripInfo" dbtype="query">
        select *
        from trips 
        where tour_id = #url.tour_id#
        </cfquery>
        <cfoutput>
        <h2 align="Center">Sweet! Let's get you registered<cfif tripInfo.recordcount neq 0> to go on the #tripInfo.tour_name# Tour</cfif>.</h2>
        
        
        <cfform method="post" action="selectTrips.cfm?tour_id=#url.tour_id#">


        <h2>Booking Process</h2>
        
                         <em>Before we get started, here is a quick overview of the Tours Reservation Process.  </em><br /><br />
                         <div class="error">
						 <cfif isDefined('form.verifyRules')>
                         	<table width=400 align="Center">
                            	<tr>
                                	<Td><img src="../images/shucks.png" width="80" height="80" /></Td><Td> <h4>Shucks, we can't go foward yet.</h4> Errors are highlighted below. make sure you've read the process and know that you should NOT book your own airfare.</Td>
                                </tr>
                             </table>
                             <Br />
                         </cfif>
                         </div>
   <table width=100% cellspacing=0 cellpadding=2 class="border">
                           <tr>
                              <th align="Center"> <h3> Please carefully read the steps below explaining the enrollment process.
                                  <hr width=80% /></h3></th>
                           </tr>
                            <tr>
                              <td>
                             
                               <ol>
                                       <li>Visit iseusa.com to book and  your trip. <em>(Your almost done with this step!) </em></li>
                                       <ul><li><font size=-1>If you want to go on other tours, you will need to do this process for <em><strong>each</strong></em> tour you want to go on.</font></li></ul>
                                        
                                        <li>Submit permission form and payment forms with all signatures to MPD Tours.
                                        	<ul><li>info@mpdtoursamerica.com
                                        		<li>fax:   +1 718 439 8565  
                                        		<li>mail:  9101 Shore Road, ##203 - Brooklyn, NY 11209
                                       	  </ul>
                                
                                        <li> MPD will contact you once your payment and permission form have been received to book your flights. Do NOT book your own flights.  
                                        </ol>
                               
                               </td>
                           </tr>
                         </table>
                     
                         <br /> <div align="center">
                          
                           <p>
                           <table width=450 bgcolor="##EFEFEF" cellpadding=4 cellspacing=0>
                           <Tr>
                           	
                           	</Tr>
                           		<tr <cfif form.rulesread eq 0 and isDefined('form.verifyrules')>bgcolor="##FF9DA7"</cfif>>
                                	<Td valign="top" ><input type="checkbox" name="rulesread" value="1" <cfif form.rulesread eq 1>checked</cfif>/></Td><td>I've read and understand the process of registering for a tour.</td>
                          		</tr>
                                <Tr>
                                	<td colspan=2><hr width=50% /></td>
                                </Tr>
                                <tr <cfif form.booktravel eq 0 and isDefined('form.verifyrules')>bgcolor="##FF9DA7"</cfif>>
                                	<td valign="top"><input type="checkbox" name="booktravel" value="1" <cfif form.booktravel eq 1>checked</cfif> /></Td><td>I understand that I should not book travel and that MPD will contact me to book my airfare.  </td>
                           			
                                 </tr>
                          
                              </table>
                              <br />
                             <input type="image" src="../images/buttons/Next.png" />
                                    <input type="hidden" name="verifyRules" />
                           </p>
                         </div>
                         </cfform>
                        
                         </cfoutput>
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
</body>
</html>
