<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Trips</title>

<style type="text/css">
<!--
h1, h2, h3, h4 {
	font-family: Arial, Helvetica, sans-serif;
}
.paragraph {
	font-family: Arial, Helvetica, sans-serif;
	color: #000;
}
.paragraphSm {
	font-family: Arial, Helvetica, sans-serif;
	color: #000;
	font-size: 13px;
	text-align: center;
}
.grey {
	background-color: #CCC;
}
.wrapper {
}
.box {
	width: auto;
	margin-top: 5px;
	margin-right: auto;
	margin-bottom: 50px;
	margin-left: auto;
}
.box div.topleft {
	display: block;
	background: url("images/box-bg.png") top left no-repeat white;
	padding: 2.0em 0em 0em 2.0em;
}

.box div.topright {
	display: block;
	background: url("images/box-bg.png") top right no-repeat white;
	margin-top: -2em;
	margin-right: 0em;
	margin-bottom: 0;
	margin-left: 2em;
	padding-top: 3em;
	padding-right: 5em;
	padding-bottom: 3em;
	padding-left: .50em;
}

.box div.bottomleft {
	display: block;
	height: 55px;
	margin-top: -2em;
	background: url("images/box-bg.png") bottom left no-repeat white;
}

.box div.bottomright {
	display: block;
	background: url("images/box-bg.png") bottom right no-repeat white;
	height: 55px;
	margin-left: 3em;
}
.center {
	text-align: center;
}
-->
</style>
</head>

<body>

<Cfquery name="tours" datasource="#application.dsn#">
select *, smg_tours.tour_name
from student_tours
left join smg_tours on smg_tours.tour_id = student_tours.tripid
where student_tours.studentid = #client.studentid#
</Cfquery>
<Cfquery name="allTrips" datasource="#application.dsn#">
select * 
from smg_tours
where tour_status = 'Active'
order by tour_name
</Cfquery>
<div class="box">
  <div class="topleft">
  <div class="topright">
    <div>
<h2 class="center">Student Trips</h2>

  <cfoutput>
  
<h4>Registered Trips</h4>
<table width=100% cellpadding=4 cellspacing=4>
	<tr>
    	<Td bgcolor="##999999" align="center"><span class="paragraph">Tour</span></Td>
    	<Td bgcolor="##999999" align="center"><span class="paragraph">Registered</span></Td>
    	<td bgcolor="##999999" align="center"><span class="paragraph">Paid</span></td>
    	<td bgcolor="##999999" align="center"><span class="paragraph">Flights</span></td>
    </tr>

  
    <cfif tours.recordcount eq 0>
        <tr>
            <Td colspan=5 align="Center"><span class="paragraph">Student has not signed up for any trips.</span></Td>
        </tr>
    <cfelse>
        <cfloop query="tours">
        <tr<cfif tours.currentrow mod 2> bgcolor="##CCCCCC" </cfif>>
            <Td><span class="paragraphSm">#tour_name#</span></Td>
            <Td><span class="paragraphSm">#DateFormat(date,'mm/dd/yyyy')#</span></Td>
            <td><cfif paid is ''>
              <span class="paragraphSm">----
              <cfelse><span class="paragraphSm">#DateFormat(paid,'mm/dd/yyyy')#</span>
            </cfif></td>
            <td><cfif flightinfo is ''>
              --
              <cfelse><span class="paragraphSm">#DateFormat(flightinfo,'mm/dd/yyyy')#</span>
            </cfif></td>
        </tr>  
        </cfloop>
    </cfif>

 </table>
    </cfoutput>
     </div>
  </div>
  </div>

  <div class="bottomleft">
  <div class="bottomright">
  </div>
  </div>
</div>


</body>
</html>