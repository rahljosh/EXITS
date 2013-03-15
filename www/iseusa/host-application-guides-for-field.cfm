<cfinclude template="extensions/includes/_pageHeader.cfm"> <!--- Include Page Header --->
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
    <p class="header1">Helpful Documents</p>
    

    
    <!----
    <div class="subPic"></div>
	---->
    <p class="p1">
    We have prepared a few documents to help you get comfortable with the new host family application and the process of moving through EXITS.  You will initiate the application, help the host family with any questions they may have, and then review the information online and submit it to headquarters. <br /><br />
    The Quick Start Guide is a 1 page summary of the process, while the other two guides are more in-depth on each step of the process. <br />
    <br />
    Simply select which type of host family you are interacting with and you'll be set!
    <div align="center">
	<img src="images/graphics.png" width=700 border="0" usemap="#Pictures" />
    <map name="Pictures" id="Pictures">
      <area shape="poly" coords="61,133,239,107,249,190,216,303,84,321" href="pdfs/Host App Quick Start Guide.pdf" />
      <area shape="poly" coords="281,108,457,157,407,339,228,292" href="pdfs/Area Rep Host App Instructions for Existing Host Family.pdf" />
      <area shape="poly" coords="625,115,640,310,448,321,445,227,468,155,443,143,439,129" href="pdfs/Area Rep Instructions for New Host Family.pdf" />
    </map>
    </div>
    <!----
    <Table align="center" width=80%>
    	<Tr>
        	<td colspan=2 align="Center"><h3><a href="pdfs/Host App Quick Start Guide.pdf"> Quick Start Guide</a></h3></td>
        </Tr>
        <tr>
        	<td><h3><a href="pdfs/Area Rep Instructions for New Host Family.pdf">Family has not hosted before </a></h3></td>
            <Td><h3><a href="pdfs/Area Rep Host App Instructions for Existing Host Family.pdf">Family has hosted before</a></h3></Td>
        </tr>
     </Table>
	 ---->
    </p>
<p class="p1">
</p>
<p class="p1"></p>
  <!-- end whtMiddle --></div>
  <div class="whtBottom"></div>
<!-- end lead --></div>
  <!-- end mainContent --></div>
<!-- end container --></div>

<!--- Include Page Footer --->
<cfinclude template="extensions/includes/_pageFooter.cfm">
