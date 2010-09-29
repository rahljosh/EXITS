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
h3{text-indent:10px;}	
-->
</style></head>
<cfparam name="url.tour_id" default="1">
<cfparam name="stuEdit" default="1">
<!----Student Info---->
<cfparam name="form.studentLName" default="">
<cfparam name="form.studentFName" default="">
<cfparam name="form.Email" default="">

<!----Host Info---->

<cfparam name="hostInfo.local_air_code" default="">
<cfparam name="hostInfo.major_air_code" default="">



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
           
        <cfquery name="trips" datasource="#application.dsn#">
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
        <h2 align="Center">Flight Quote</h2>
        <cfform method="post" action="quote.cfm">


        <h2>Select  Tours</h2>
                         <em>Want to compare a couple of tours?</em><br /><br />
                         <table width=100% cellspacing=0 cellpadding=2 class="border">
                           <tr>
                             <td><table  width=100% cellspacing=0 cellpadding=2>
                               <tr>
                                 <td width="22" class="boxB"></td>
                                 <td width="181" class="boxB"><h3><u>Tour</u></h3></td>
                                 <td width="169" class="boxB"><h3><u>Dates</u></h3></td>
                                 <td width="84" class="boxB"><h3><u>Price</u></h3></td>
                                 <td width="73" class="boxB"><h3><u>Status</u></h3></td>
                               </tr>
                               <cfloop query="trips">
                                 <tr id=#tour_id#2 <CFif url.tour_id eq tour_id>bgcolor="lightgreen"<cfelseif trips.currentrow mod 2>bgcolor="##deeaf3"</cfif>>
                                   <td><h3>
                                     <input name="select_trip" type="checkbox" onclick="highlight(this);"  value="#tour_id#" <cfif url.tour_id eq #tour_id#>checked</cfif>/>
                                   </h3></td>
                                   <td align="left" valign="middle" class="infoBold"><h3>#tour_name#</h3></td>
                                   <td align="left" valign="middle"><h3>#tour_date#</h3></td>
                                   <td align="center" valign="middle" class="infoBold"><h3>#LSCurrencyFormat(tour_price,'local')#</h3></td>
                                   <td align="center" valign="middle"><h3>#tour_status#</h3></td>
                                 </tr>
                               </cfloop>
                             </table></td>
                           
                             
                           </tr>
                         </table>
                     
                         <br /> <div align="center"><input type="image" src="../images/buttons/Next.png" /></div>
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
