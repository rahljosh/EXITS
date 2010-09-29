<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
<style type="text/css">
<!--
table {
	width: 606px;
}
-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
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
	color: #0B954E;
	text-decoration: none;
}
a {
	font-weight: bold;
}
a:active {
	text-decoration: none;
}
table {
	width: 600px;
}
.whtMiddleTrips {
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	height: auto;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	min-height: 1300px;
}


-->
</style>




</head>

<body class="oneColFixCtr">

 <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours where tour_status <> 'inactive'
		</cfquery>
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
      <div class="whtMiddleTrips">
        <div class="trips">
          <h1 class="enter">ISE Student Tours</h1>
          <p>International Student Exchange and our partner organization, MPD Tour America are proud to offer this year's ISE Trips of exciting adventures across America. MPD Tour America will be organizing 9 ISE trips, chaperoned and supervised exclusively by ISE Representatives, for the 2010-11 season.<br /><br />
          <strong>NEW THIS SEASON: STUDENTS DO NOT PURCHASE THEIR OWN AIRFARE.  Once you are registered for a tour, you will be contacted regarding airfare.</strong></p>
          
          <table width="573" height="333" border="0">
            <tr>
              <td height="45" colspan="3" scope="row" align="center" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
             <a href="/">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td>
              </tr>
            <tr>
           
            <cfoutput>
            	<cfloop query="tours">
              
              <td width="285" height="178" class="lightGreen" scope="row"><a href="tours.cfm?tour_id=#tour_id#">
              <img src="images/trips_#tour_id#.png" width="239" height="165" alt="#tour_name#" border="0" /></a><br />
              #tour_name#<br />
              #tour_date#<br />
              Status: <cfif tour_status eq 'Active'>Seats Available<cfelse>#tour_status#</cfif></td>
					<cfif currentrow mod 2 eq 0> 
                    </tr>
                    <tr>
                </cfif>
                </cfloop>    
           </cfoutput>
           <!----
           </cfif>
		   ---->
            	</tr>
      		
            <!----
              <th width="285" height="178" class="lightGreen" scope="row"><a href="tours.cfm?tour_id=10"><img src="images/trips_03.png" width="239" height="165" alt="LA Experience" border="0" /></a></th>
              <td width="264" align="center" valign="middle" class="lightGreen"><a href="tours.cfm?tour_id=7"><img src="images/trips_04.png" width="239" height="166" alt="NYC Holiday" border="0"/></a><br /></td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><a href="tours.cfm?tour_id=1"><img src="images/trips_08.png" width="240" height="166" border="0"/></a></th>
              <th class="lightGreen"><a href="tours.cfm?tour_id=2"><img src="images/trips_11.png" width="237" height="165" border="0"/></a></th>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><a href="tours.cfm?tour_id=8"><img src="images/trips_13.png" width="241" height="168" border="0"/></a></th>
              <th class="lightGreen"><a href="tours.cfm?tour_id=9"><img src="images/trips_14.png" width="237" height="168" border="0"/></a></th>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><a href="tours.cfm?tour_id=6"><img src="images/trips_09.png" width="244" height="166" border="0" /></a></th>
              <td class="lightGreen" align="center"><a href="tours.cfm?tour_id=11"><img src="images/trips_05.png" width="244" height="165" alt="mousepad" border="0" /></a></td>
            </tr>
            <tr>
              <th class="lightGreen" scope="row"><img src="images/trips_15.png" width="245" height="168" /></th>
              <th class="lightGreen"></th>
            </tr>
            <tr>
			---->
             
          </table>
                   </div>

        <!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end subPages --></div>
    <!-- end mainContent --></div>
<!-- end container --></div>
<div id="main" class="clearfix"></div>
<div id="footer">
  <div class="clear"></div>
<cfinclude template="../bottomLinks.cfm">
<!-- end footer --></div>
</body>
</html>
