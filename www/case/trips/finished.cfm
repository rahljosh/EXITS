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
h1 {
	font-family: Arial, Helvetica, sans-serif;
	border-bottom-width: medium;
	border-bottom-style: double;
	border-bottom-color: #999;
}
-->
</style></head>

<body>
<Cfquery name="studentInfo" datasource="mysql">
select s.firstname, s.familylastname, s.email, s.uniqueid, sch.schoolname, sch.address, sch.address2, sch.city, sch.state, sch.zip, sch.principal, sch.phone, sch.phone_ext,
u.firstname as repfirst, u.lastname as replast, u.email as repemail, u.phone as repphone
from smg_students s
left join smg_schools sch on sch.schoolid = s.schoolid
left join smg_users u on u.userid = s.arearepid
where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.verifiedStudent#"> 
</cfquery>
<Cfquery name="tripDetails" datasource="mysql">
select *
from smg_tours
where tour_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.selectedTrip#"> 
</cfquery>

<script language="javascript"> 
function toggle(showHideDiv, switchImgTag) {
        var ele = document.getElementById(showHideDiv);
        var imageEle = document.getElementById(switchImgTag);
        if(ele.style.display == "block") {
                ele.style.display = "none";
		imageEle.innerHTML = '<img src="../images/buttons/noInfo.png">';
        }
        else {
                ele.style.display = "block";
                imageEle.innerHTML = '<img src="../images/buttons/noInfo.png">';
        }
}
</script>
<div id="wrapper">
<cfinclude template="../includes/header.cfm">
<div id="mainbody">
<cfinclude template="../includes/leftsidebar.cfm">
<div id="trip">
   
   <h1>All Finished</h1>
<Cfoutput>
<p> You have successfully reserved a spot on your trip to <strong>#tripDetails.tour_name#</strong> Please note that your spot is not confirmed until your payment permission forms are received by MPD Tours.</p>
<p>You should have these forms via email with in moments. They were sent to: <strong>#studentInfo.email#</strong>
 If you have not received them within 30 minutes, be sure to check your spam folder. If they are not there please contact <a href="mailto:trips@case-usa.org">trips@case-usa.org</a> to have them re-sent.</p>
      </Cfoutput>
    <!-- trips --></div>
    <!-- mainbody --> </div>
    <div class="clearfix"></div>
<cfinclude template="../includes/footer.cfm">
<!-- wrapper --></div>



</body>
</html>
