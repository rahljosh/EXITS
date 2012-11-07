<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>(ISE) International Student Exchange - Foreign Exchange</title>
<style type="text/css">
<!--
-->
</style>

<link href="../css/ISEstyle.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
#footer3 {
	clear: both;
	height: 40%;
	margin: 0;
	background-color: #000;
	padding-top: 0;
	padding-right: 0;
	padding-bottom: 0;
	padding-left: 0;
	bottom: -8px;
	display: block;
}
.tripsTours {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	width: 675px;
	margin-left: 35px;
	margin-top: 10px;
	padding: 0px;
	text-align: left;
}
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
.Boxx {
	border: 2px dashed #000066;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #000066;
}
.Titles {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 14px;
}
.TitlesLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #000066;
	font-weight: bold;
	font-size: 20px;
}
.SubTitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 12px;
}
.SubTitleLG {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #2E4F7A;
	font-weight: bold;
	font-size: 16px;
}
.BottonText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 9px;
	font-style: normal;
	line-height: normal;
	font-weight: lighter;
	font-variant: normal;
	color: #6B8098;
	background-image: url(file:///JW%20BACKUP/SMG/ISE/site/trips/images/botton.gif);
	background-repeat: no-repeat;
	background-position: center center;
	text-align: center;
	vertical-align: middle;
}
.RegularText {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color:#000000;
	font-style: normal;
	font-weight: normal;
}
.style1 {color: #FFFFFF}
.style2 {font-size: 12px}
.style4 {font-size: 12}
.style5 {color: #FFFFFF; font-weight: bold; }
.style6 {
	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	}
.image-right {
border:solid 1px;
margin-right: 0px;
margin-left: 15px;
}
.image-left {
border:solid 1px;
margin-right: 15px;
margin-left: 0px;
}
.whtMiddletours2{
	background-image: url(../images/whtBoxMiddle.png);
	background-repeat: repeat-y;
	margin: 0px;
	text-align: justify;
	padding-top: 20px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
}
.bBackground {
	background-color: #C5DCEA;
	border: thin solid #000;
	text-align: center;
}
.border{border:solid 1px;}
h3{text-indent:10px;}	
-->
</style>

</head>




<body class="oneColFixCtr">
<div id="topBar">
<cfinclude template="../topBarLinks.cfm">
<div id="logoBox"><a href="/"><img src="../images/ISElogo.png" width="214" height="165" alt="ISE logo" border="0" /></a></div>
<!-- end topBar --></div>
<div id="container">
<div class="spacer2"></div>
<div class="title"><!-- end title --></div>
<div class="tabsBar">
  <cfinclude template="../tabsBar.cfm">
  <!-- end tabsBar --></div>
<div id="mainContent">
<div id="subPages">
      <div class="whtTop"></div>
  <div class="whtMiddletours2">
        <div class="tripsTours">
       
   
        <cfquery name="hostAddress" datasource="mysql">
        select smg_hosts.address, smg_hosts.city, smg_hosts.zip, smg_states.state
        from smg_hosts
        left join smg_states on smg_states.id = smg_hosts.state
        where hostid = #client.hostid#
        </cfquery>
        
		<!----ISE.LOCAL key ABQIAAAAJKd5F0qhm5iwTQ_RUwW87RSZ3eowe84jhdCqG6p5-VBQ1NT-oxTUanED__FKh0fHC16VE5BWSb5KWg---->
        <!----SMG KEY: ABQIAAAANFl_rAJclyWp_9Y6bMJWDhSEDsPCtRvpUWwLtaizQEvthdX2QhQ75G6BPFX9RyHFn1BUqcy2XPa-mA---->
    <cfoutput>
        <script src="http://maps.google.com/maps?file=api&v=2&sensor=false&key=ABQIAAAAJKd5F0qhm5iwTQ_RUwW87RSZ3eowe84jhdCqG6p5-VBQ1NT-oxTUanED__FKh0fHC16VE5BWSb5KWg" type="text/javascript"></script>
        <script type="text/javascript">
        var geocoder;
        function initialize() {
         geocoder = new GClientGeocoder();
        }
        // addAddressToMap() is called when the geocoder returns an answer.
        function addAddressToMap(response) {
         document.my_form.lookup_success.value = 0;
         if (!response || response.Status.code != 200) {
            alert("Sorry, we were unable to lookup that address.");
         } else {
           place = response.Placemark[0];
           document.my_form.lookup_address.value = place.address;
           // address level accuracy = 8
           if (place.AddressDetails.Accuracy == 8) {
            document.my_form.lookup_success.value = 1;
            alert("The address displayed in Lookup Address is valid.");
           }
           else {
            alert("This address is not accurate to the address level.");
           }
         }
        }
        // showLocation() is called when you click on the Search button
        // in the form.  It geocodes the address entered into the form.
        function showLocation() {
         var address =  #hostAddress.address# + ' ' + #hostAddress.city# + ' ' + #hostAddress.state# + ' ' + #hostAddress.zip#;
         geocoder.getLocations(address, addAddressToMap);
        }
        </script>
        </cfoutput>
        	<br />
          	<cfinclude template="includes/address_lookup_1.cfm">
            <h2>Address Verification</h2> 
            <h2>We use the Google API to verify addresses that are input into the system.</h2>
      <Cfoutput>
      	#showLocation#
	</Cfoutput>
	
    


<div id="map_canvas" style="width:100%; height:100%"></div>


    
    
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
</body>
</html>
