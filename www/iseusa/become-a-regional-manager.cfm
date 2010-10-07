<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
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
-->
</style>
</head>
<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>

<div id="mainContent">
<div id="subPages">
  <div class="whtTop"></div>
  <div class="whtMiddle">
    <p class="header1">Be a Regional Manager</p>
    <div class="subPic"><img src="images/beArep.png" width="415" height="277" alt="Meet our Students" /></div>
    <p class="p1">ISE is searching for experienced regional coordinators/managers that have experience building a team of local representatives to place students for an academic year. Our managers are dedicated and passionate about the work they do and work tirelessly to achieve their goals. </p>
    <p class="p1"><span class="bold">SUPPORT:</span> ISE Regional Managers receive unparalleled support throughout the year from the New&nbsp; York Office. A Regional Manager is paired with a facilitator(a member of the office staff that assists a regional manager on a daily basis on all matters related to student exchange). The regional manager is also provided with a Program Manager(a member of the office staff that oversees the development of regions and growth of ISE in the field).    </p>
    <p class="p1"><span class="bold">NETWORKING:</span> Our experienced regional managers are skillful networkers, able to meet with people and develop long lasting relationships which foster positive environments for student exchange to thrive. </p>
    <p class="p1"><span class="bold">FLEXIBILITY:</span> Regional Managers are able to work from home and are free to develop their own personal working schedule. </p>
    <p class="p1"><span class="bold">COMMUNITY:</span> Through networking and outreach regional managers develop long lasting bonds with exchange students, schools, and families. Regional Managers reinforce positive growth and development within their communities.</p>
    <p class="margin"><form method ="post" action="jobForm.cfm"><input type="image" class="margin" src="images/buttons/RlearnMore.png" width="89" height="35" border="0"/><input type="hidden" name="job_type" value="Manager" /></form></p>
<p class="p1">&nbsp;</p>
  <!-- end whtMiddle --></div>
  <div class="whtBottom"></div>
<!-- end lead --></div>
<h1>&nbsp;</h1>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Header --->
<cfinclude template="extensions/includes/_pageFooter.cfm">
