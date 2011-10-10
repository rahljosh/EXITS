<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="css/maincss.css" rel="stylesheet" type="text/css" />
<script src="SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script>
<link href="SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
a:link {
	color: #003;
	text-decoration: none;
}
a:visited {
	color: #003;
	text-decoration: none;
}
a:hover {
	color: #003;
	text-decoration: none;
}
a:active {
	color: #003;
	text-decoration: none;
}
a {
	font-weight: bold;
}
.lightGreen {
	color: #000;
	
	background-repeat: repeat;
	text-align: center;
	background-color: #a5aac7;
}
-->
</style></head>

<body>

<div id="wrapper">
<cfinclude template="includes/header.cfm">
<div id="mainbody">
<cfinclude template="includes/leftsidebar.cfm">
<div id="trip">
   
    <h1 class="enter">ISE Student Tours</h1>
          <em><font color="#be1e2d" size=+1><strong><div align="center">For ISE students ONLY!</div></strong></font></em>
          <p>International Student Exchange and our partner organization, MPD Tour America are proud to offer this year's ISE Trips of exciting adventures across America. MPD Tour America will be organizing 10 ISE trips, chaperoned and supervised exclusively by ISE Representatives, for the 2011-12 season.<br /><br />
          <strong>NEW THIS SEASON: STUDENTS DO NOT PURCHASE THEIR OWN AIRFARE.  Once you are registered for a tour, you will be contacted regarding airfare.</strong></p>
          
          <table width="573" height="333" border="0">
            <tr>
              <td height="45" colspan="3" scope="row" align="center" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
             <a href="/trips">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td>
              </tr>
             <tr>
             	<td colspan=4 align='4'> 
					<cfif tours.recordcount eq 0>
                   	 	<h3><div align="center">Trips are no longer available for booking.<br />  Please check back later.</div></h3>
                    </cfif>
            	</td>
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
          
            	</tr>
      		
    
             
          </table>
    <!-- trips --></div>
    <!-- mainbody --> </div>
<!-- wrapper --></div>
<div class="clearfix"></div>
<cfinclude template="includes/footer.cfm">
</div>
<script type="text/javascript">
<!--
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
//-->
</script>
</body>
</html>
