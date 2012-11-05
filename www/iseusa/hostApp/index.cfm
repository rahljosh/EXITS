<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange S</title>
<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<link href="../css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="chosen/chosen.css" />
<link rel="stylesheet" href="../css/wiki.css" />
<link rel="stylesheet" href="../css/colorbox2.css" />
<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="../linked/js/jquery.colorbox.js"></script>
<script type="text/javascript">
//<![CDATA[
	function ShowHide(){
	$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
	}
//]]>
</script>
        
	<script>

        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
                onClosed:function(){ location.reload(false); } });

            
        });

    </script>


</head>

<body class="oneColFixCtr">
<!----
<cfinclude template="../slidingLogin.cfm">
---->
<Cfparam name="url.page" default="hello">

<cfquery name="hostInfo" datasource="mysql">
SELECT shl.firstname, shl.lastname, shl.address, shl.address2, shl.city, shl.stateID, shl.zipCode, shl.email, shl.phone, smg_states.state
FROM smg_host_lead shl
LEFT JOIN smg_states on smg_states.id = shl.stateID
where email = '#client.email#'
</cfquery>
<cfoutput>
<div id="topBar">

<cfinclude template="../topBarLinks.cfm">
<div id="logoBoxB">
  <div class="blueBox">
  <a href="../index.cfm"><img src="../images/logo_21.png" width="214" height="165" alt="ISE logo" border="0" /></a>
<cfif url.page is not 'hostLogin'>
	<cfinclude template="includes/leftMenu.cfm">
</cfif>
<!--logoBoxB --></div>
<div class="blueBtm"></div>
<!--blueBox --></div>

<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><!-- end title --></div>
<div class="tabsBar"><!-- end tabsBar --></div>
<div id="mainContent">
<div id="subPages">
      <div class="whtTop"></div>
  <div class="whtMiddletours2">
        <div class="hostApp">
     		<div class="app_spacing">
            
       			 <cfinclude template="#url.page#.cfm">
       		</div>
        <div id="main" class="clearfix"></div>
      <!-- endtripTours --></div>
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
</cfoutput>
</body>
</html>
