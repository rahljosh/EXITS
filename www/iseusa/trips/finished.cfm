<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>All Done</title>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<link href="../css/trips.css" rel="stylesheet" type="text/css" />
 <link rel="stylesheet" media="all" type="text/css"href="../css/baseStyle.css" />



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
---->
</head>

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


<h2>All Finished</h2>
<Cfoutput>
<p> You have successfully reserved a spot on your trip to <strong>#tripDetails.tour_name#</strong> Please note that your spot is not confirmed until your payment permission forms are received by MPD Tours.</p>
<p>You should have these forms via email with in moments. They were sent to: <strong>#studentInfo.email#</strong>
 If you have not received them within 30 minutes, be sure to check your spam folder. If they are not there please contact <a href="mailto:trips@iseusa.com">trips@iseusa.com</a> to have them re-sent.</p>
      </Cfoutput>
      </div>
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
