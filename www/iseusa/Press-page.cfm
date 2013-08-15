<cfparam name="url.page" default="/pressKit/home">
<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--
-->
</style>
<link href="pressKit/css/press_theme.css" rel="stylesheet" type="text/css" />
</head>

<body class="oneColFixCtr">
<cfinclude template="slidingLogin.cfm">
  <div class="clearfix"></div>

<cfinclude template="includes/leftMenu_PressPage.cfm">

<div id="container">
<div class="spacer2"></div>
<div class="title"><cfinclude template="title.cfm"><!-- end title --></div>
<div class="tabsBar"><cfinclude template="tabsBar.cfm"><!-- end tabsBar --></div>

<div id="mainContent">
<div id="subPages">
  <div class="whtTop"></div>
  <div class="whtMiddle">

    <cfinclude template= "#url.page#.cfm">

    <div class="clearfix"></div>
  <!-- end whtMiddle --></div>
  <div class="whtBottom"></div>
<!-- end subpages --></div>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">