<cfparam name="url.page" default="/HostFamily/be-host-family">
<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<head>
<style type="text/css">
<!--
a:link {
	color: #000;
	/* font-weight: bold; */
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #f7931f; /* #0B954E; */
}
a:active {
	text-decoration: none;
}
.subMenuTop {
	background-image: url(images/orgBoxTop.png);
	background-repeat: no-repeat;
	height: 25px;
	width: 746px;
	margin-top: 2px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-left: 0px;
	padding: 2px;
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
<cfoutput>
<div id="mainContent">
    <div id="subPages">
      <div class="subMenuTop"><cfinclude template="includes/subMenu.cfm"></div>
      <div class="HFwhtMiddle">
     <cfinclude template= "#url.page#.cfm">
<!-- end whtMiddle --></div>
      <div class="whtBottom"></div>
      <!-- end lead --></div>
    <!-- end mainContent --></div>
</cfoutput>
<cfinclude template="includes/bottomTabs.cfm">
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">
