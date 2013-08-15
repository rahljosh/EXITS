<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
<style type="text/css">
<!--
-->
</style>
<link href="css/projectHelp_theme.css" rel="stylesheet" type="text/css" />
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
    
    <div class="column1"><div class="PJslideshow"><cfinclude template="project-help-slideshow.cfm"></div>
    <h1>Project H.E.L.P</h1>
    <p>ISE believes that exchange students are a source of inspiration and 
pride for the communities in which they live during their program. To 
that point, ISE has developed a program of Community Service so 
that exchange students can demonstrate their good will and positive 
influence on neighborhoods. The program is called H.E.L.P. and 
provides an outline for students to use to experience a variety of 
service and enhance their American experience. H.E.L.P. stands for:</p>
<ul style="margin-left: -30px">
<li><span class="boldBlue">H: </span>Health and Human Issues</li>
<li><span class="boldBlue">E:</span> Environment, Education and Emergencies</li>
<li><span class="boldBlue">L:</span> Local Events, Festivals and Needs</li>
<li><span class="boldBlue">P:</span> Politics, National Programs and NGO's</li>
</ul>
</div>
  <div class="blueLine">How It Works</div>
    <div class="clearfix"></div>
  
<div class="column2">
<ul>
<li>Our students complete 5 or more hours of community service during their program</li>
<li>Opportunities to get involved are available through schools, churches and local community organizations</li>
<li>Our local representatives and regional managers help coordinate these projects throughout the year</li></ul>
</div>
<div class="column2">
<ul>
<li>Students can volunteer through one of our national groups: Red Cross or the Ronald McDonald House</li>
<li>Students can choose projects from multiple categories</li>
<li>We encourge our host families to volunteer along with the students</li>
</ul></div>
 <div class="clearfixPH"></div>
  <div class="blueLine">Work With One Of Our National Partners - Volunteer here!</div>
    <div class="clearfix"></div>
  
<div class="column2" style="padding-top: 25px;">
  <div align="center"><a href="student-exchange-project-help-redcross.cfm"><img src="images/projectHelp/RedCross_buttonHZ.jpg" width="284" height="100" alt="Project HELP RedCross Student Exchange"/></a></div><div style="text-align:center; padding-top: 10px;"><a href="student-exchange-project-help-redcross.cfm" class="myButton">Click Here to volunteer</a><br /><br />
Red Cross Week is<br />
<strong>November 11th -15th </strong></div> 
  </div>
<div class="column2" style="border-left-width: thin; border-left-style: solid;
	border-left-color: #CCC;">
<div align="center"><a href="student-exchange-project-help-ronaldMcDonald.cfm"><img src="images/projectHelp/RMHC-logo.jpg" width="250" height="131" alt="Project HELP RedCross Student Exchange"/></a></div><div style="text-align:center;"><a href="student-exchange-project-help-ronaldMcDonald.cfm" class="myButton">Click Here to volunteer</a><br /><br />
Ronald McDonald Week is<br />
<strong>Febraury 24th - 28th</strong></div> 
</div>
 <div class="clearfixPH"></div>
 <div class="blueLine">Other Ways To Help Out Your Community</div>
  <table width="680" border="0" align="center">
  <tr>
    <td width="153"><ul>
<li>Cultural Centers</li>
<li>Art/ Music Events</li>
<li>Season Festivals</li>
</ul><br />
      <img src="images/projectHelp/pumpkin-carving-project-HELP.jpg" alt="Host Student Pumpkin Carving" width="150" height="112" class="picIMG" /></td>
    <td width="188" align="center" valign="top"><ul>
<li>Habitat for Humanity</li>
<li>Animal Rescue Leagues</li>
<li>4-H Clubs</li>
</ul><br/>
<img src="images/projectHelp/moving-boxes-project-HELP.jpg" alt="Host Student Pumpkin Carving" width="150" height="112" class="picIMG" /></td>
    <td width="159" align="center"><ul>
<li>Nursing Homes</li>
<li>Elderly Citizens</li>
<li>Visting Hospitals</li>
</ul><br />
<img src="images/projectHelp/project-help-crafts.jpg" alt="Host Student Pumpkin Carving" width="150" height="112" class="picIMG" /></td>
    <td width="162" align="center"><ul>
<li>Holiday Food Drives</li>
<li>Toy Drives</li>
<li>And Many More!</li>
</ul><br />
<img src="images/projectHelp/Project-HELP-Gardening.jpg" alt="Host Student Pumpkin Carving" width="150" height="112" class="picIMG" /></td>
  </tr>
</table>
<div class="clearfix"></div>
 <div class="blueLine">Student Feed Back</div>
 <table width="650" border="0" align="center" cellpadding="13">
  <tr>
    <td><img src="images/projectHelp/studentFeedback1.jpg" alt="Foreign Exchange Student Feedback" width="250" height="188" class="picIMG" /></td>
    <td><div style="background-color: #FFC; padding: 10px; font-style: italic; font-size: 10px;">
	<cfset randNumb = RandRange(1,4)>
	<Cfif randNumb eq 1>
    <p>"The community service added to my pleasure of being in America.  It was a really nice experience."</p>
<cfelseif randNumb eq 2>
<p>"These projects are a good opportunity for all the exchange students to get together, have fun, share our cultures and also help people.  We had really good times."</p>
<cfelseif randNumb eq 3>
<p>"It felt good to know we helped a lot of people."</p>
<cfelseif randNumb eq 4>
<p>"It was cool to do good things with nice people and have fun at the same time."</p>
</cfif>
</div>







</td>
  </tr>
</table>     
     <div class="clearfix"> </div>

     <div class="clearfix"> </div>
  <!-- end whtMiddle --></div>
  <div class="whtBottom"></div>
<!-- end lead --></div>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">