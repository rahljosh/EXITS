<cfparam name="url.page" default="/promotions/index">
<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--


-->
</style>
<link href="/promotions/promotion.css" rel="stylesheet" type="text/css" />
</head>

<body class="oneColFixCtr">
<cfinclude template="slidingLogin.cfm">
<div id="topBar">

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
  
    
    <cfinclude template= "#url.page#.cfm">

     <div class="clearfix"> </div>
  <!-- end whtMiddle --></div>
  <div class="whtBottom"></div>
<!-- end lead --></div>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">