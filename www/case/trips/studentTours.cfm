<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Tour FAQs</title>
<link href="../css/maincss.css" rel="stylesheet" type="text/css" />

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
	color: #BE1E2D;
	text-decoration: underline;
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
p {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
h1 {
	font-family: Arial, Helvetica, sans-serif;
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}

-->
</style></head>

<body>
 <cfquery name="tours" datasource="mysql">
			SELECT * FROM smg_tours where tour_status <> 'inactive'
		</cfquery>
<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">
   
    <h1 class="enter">CASE Student Tours</h1>
          <div align="center"><em><font color="#be1e2d" size="+1"><strong>For CASE students ONLY!</strong></font></em></div>
          <p>Cultural Academic Student Exchange and our partner organization, MPD Tour America are proud to offer this year's CASE Trips of exciting adventures across America. MPD Tour America will be organizing 10 CASE trips, chaperoned and supervised exclusively by CASE Representatives, for the 2011-12 season.<br /><br />
          <strong>NEW THIS SEASON: STUDENTS DO NOT PURCHASE THEIR OWN AIRFARE.  Once you are registered for a tour, you will be contacted regarding airfare.</strong></p>
          
          <table width="573" height="333" border="0" align="center">
          <!----
            <tr>
              <td height="45" colspan="3" scope="row" align="center" ><img src="../images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
             <a href="/trips">Trips</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="contact.cfm">Contact</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="rules.cfm">Rules and Policies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="questions.cfm">Questions</a><br /><img src="../images/webStore_lines_06.gif" width="600" height="14" /></td>
              </tr>
             ---->
			 <tr>
             	<td colspan=4 align='4'> 
					<cfif 1 eq 1>
                   	 	<h3><div align="center">Trips are unavailable for registration until Oct 3rd. <br />  Please check back on that date to book your trip.</div></h3>
                    </cfif>
            	</td>
             </tr>
            <tr>
            <!----
            <cfoutput>
            	<cfloop query="tours">
              
              <td width="285" height="178" class="lightGreen" scope="row"><a href="tours.cfm?tour_id=#tour_id#">
              <img src="images/trips_#tour_id#.png" width="239" height="165" alt="#tour_name#" border="0" /></a><br />
              <strong>#tour_name#</strong><br />
              #tour_date#<br />
              Status: <cfif tour_status eq 'Active'><i>Seats Available<cfelse>#tour_status#</i></cfif></td>
					<cfif currentrow mod 2 eq 0> 
                    </tr>
                    <tr>
                </cfif>
                </cfloop>    
           </cfoutput>
          ---->
            	</tr>
      		
    
             
          </table>
    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>


</body>
</html>
