<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>WebEx Training</title>
<link href="http://trips.exitsapplication.com/STB.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.wrapper {
	width: 700px;
	margin-right: auto;
	margin-left: auto;
}
.info {
	width: 580px;
	margin-right: auto;
	margin-left: auto;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 13px;
}
.infoBold {
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.infoItalic {
	font-style: italic;
	font-family: Arial, Helvetica, sans-serif;

}
.clear {
	display: block;
	clear: both;
	height: 10px;
}
.boxTile2 {
	background-image: url(http://trips.exitsapplication.com/images/loginTile.png);
	background-repeat: repeat-y;
	width: 700px;
}
.topColor {
	background-color: #073E55;
	height: 60px;
	width: 580px;
	float: left;
	margin-top: 25px;
}
#tripLogo {
	background-color: #FFF;
	height: 100px;
	width: 125px;
	position: absolute;
	z-index: 200;
}
-->
</style>
</head>

<body>
<script type="text/javascript">
function highlight(checkbox) {
   if (document.getElementById) {
      var tr = eval("document.getElementById(\"TR" + checkbox.value + "\")");
   } else {
      return;
   }
   if (tr.style) {
      if (checkbox.checked) {
         tr.style.backgroundColor = "lightgreen";
      } else {
         tr.style.backgroundColor = "white";
      }
   }
}
</script>




<cfoutput>
<div class="wrapper">
      <div class="boxTop"></div>
      <div class="boxTile2">
        <div class="info">
			<!----
          <div id="tripLogo"><img src="https://ise.exitsapplication.com/nsmg/pics/logos/#client.companyid#_header_logo.png"/></div>
            <div class="topColor"> 
            <h2 align="center">Account Suspended</h2><!-- end topColor --></div>---->

<span class="infoBold"><table align="center">
          	<tr>
            	<td><img src="http://www.iseusa.com/images/shucks.png" width="70" height="71" /></td>
            	<td><h1>Aw, Shucks...</h1></td>
            </tr>
          </table></span>
<span class="infoBold">
<br />
<br />
<cfquery name="qNextWebExMeeting" datasource="#application.dsn#">
select date_started, time_started, time_ended, description, webEx_url
from calendar_event
where date_started > #now()#
limit  30
</cfquery>

Don't worry, you didn't do anything wrong, all new accounts are suspended until you've completed the 'New Area Reps' training session. <Br /><Br />
This hour long WebEx session will go over the requirments and procedures that are expected of all Area Representatives.   This training is all online via a shared desktop, so please pick a time when you can be near a computer, phone, and cup of coffee.

<br /><Br />
<table cellpadding=4 cellspacing=0 width=100%>
	<Tr>
    	<th>Date</th><th>Start Time</th><th>End Time</th><Th>Additional Info</Th><th></th>
    </tr>
<cfloop query="qNextWebExMeeting">
	<tr bgcolor="<cfif qNextWebExMeeting.currentrow mod 2>##F7F7F7<cfelse>##dbe9f2</cfif>" onMouseOver="this.bgColor='##cccccc';" onMouseOut="this.bgColor='<cfif qNextWebExMeeting.currentrow mod 2>##F7F7F7<cfelse>##dbe9f2</cfif>';">
    	<td>#DateFormat(date_started, 'mmmm d, yyyy')#</td><td>#TimeFormat(time_started, 'h:mm tt')# EST</td><td>#TimeFormat(time_ended, 'h:mm tt')# EST</td><Td><Cfif description is ''><span class="infoItalic">None Avail.</span><cfelse>#description#</Cfif></Td>
        <td><a href="#webex_url#"><img src="http://www.iseusa.com/trips/images/reserve.png" border=0/></a></td>
    </tr>
</cfloop>
	<tr>
    	<Td colspan="5"><Br /><strong>Feeling spunky?</strong> There are a number of WebEx Training session available on different topics.  Check out the <A href="trainingCalendar.cfm">full schedule</A>, sign up, and on training day, grab a cup of coffee, relax and learn about the handy tools at your disposale to help you succeed.
</table>
</span>
<!-- end info --></div>
<div class="clear"></div>
<!-- end boxTile --></div>
      <div class="boxBot"></div>
  <!-- end wrapper --></div>
</cfoutput>
</body>
</html>







