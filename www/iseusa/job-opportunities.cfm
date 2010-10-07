<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--
a:link {
	color: #000;
	font-weight: bold;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #0B954E;
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
    <p class="header1">Job Opportunity</p>
    <div class="subPic"><img src="images/beArep.png" width="415" height="277" alt="Meet our Students" /></div>
     <p class="p1"><span class="bold"> Be an Area Representative</span></p>
    <p class="p1">ISE is searching for area representatives to help place and supervise exchange students for the upcoming school year.<br />
      <a href="become-an-area-rep.cfm"><img src="images/buttons/RlearnMore.png" width="89" height="35" border="0" /></a></p>
    
    <p class="p1"><span class="bold"> Be a Regional Manager </span></p>
    <p class="p1">ISE is searching for experienced regional coordinators/managers that have experience building a team of local representatives to place students for an academic year. Our managers are dedicated and passionate about the work they do and work tirelessly to achieve their goals.<br />
      <a href="become-a-regional-manager.cfm"><img src="images/buttons/RlearnMore.png" width="89" height="35" border="0"/></a></p>
   
  <!-- end whtMiddle --></div>
  <div class="whtBottom"></div>
<!-- end lead --></div>
<h1>&nbsp;</h1>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">