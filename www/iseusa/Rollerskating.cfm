<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--
table {
	width: 600px;
}
.whtMiddleService {
	background-image: url(images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	height: 700px;
	min-height: 50px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	min-height: 400px;
}
.SuccessInfo {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	height: 400px;
	width: 650px;
	margin-left: 55px;
	margin-top: 10px;
	padding: 0px;
	text-align: center;
}
a:link {
	color: #000;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #000;
}
a:hover {
	text-decoration: none;
	color: #94B9D7;
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
   <div class="whtMiddleService">
    <div class="SuccessInfo">
     <h1 class="enter">Roller Skating Party</h1>
     <table width="633">
      <tr>
       <td height="45" colspan="2" align="center" scope="row" ><img src="images/webStore_lines_03.gif" width="600" height="15" alt="line" /><br />
        <a href="community-service.cfm">Service</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="Thanksgiving.cfm">Thanksgiving</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="Harvest.cfm"> Parties</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="Rollerskating.cfm">Rollerskating</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="NYTrip.cfm">NY Trip</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="Bowling.cfm">Bowling</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="in-the-news.cfm">Articles</a><img src="images/webStore_lines_06.gif" width="600" height="14" /></th>
       </tr>
      <tr>
       <td height="44" colspan="2" scope="row" class="p2"><p>A few pictures of ISE students roller skating.</p></td>
      </tr>
       <tr>
         <td height="200" class="lightBlue" scope="row"><img src="images/studentSuccess/RS1.png" width="250" height="188" border="1"/></td>
         <td class="lightBlue" scope="row"><img src="images/studentSuccess/RS2.png" width="250" height="188" border="1" /></td>
       </tr>
       <tr>
       <td width="321" height="200" class="lightBlue" scope="row"><img src="images/studentSuccess/RS3.png" width="250" height="188" border="1" /><br /></td>
       <td width="422" class="lightBlue" scope="row"><img src="images/studentSuccess/RS4.png" width="250" height="188" border="1" /></span></td>
      </tr>
     </table>
     <br />
    </div>
    <!-- end whtMiddle --></div>
   <div class="whtBottom"></div>
   <!-- end lead --></div>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">