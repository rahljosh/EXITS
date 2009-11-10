<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.thin-border-right{ border-right: 1px solid #000000;}
</style>
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAANFl_rAJclyWp_9Y6bMJWDhSEDsPCtRvpUWwLtaizQEvthdX2QhQ75G6BPFX9RyHFn1BUqcy2XPa-mA" type="text/javascript"></script>

</head>
<cfif not structKeyExists(application, "geo") or structKeyExists(url, "reinit")>
	<cfset application.geo = createObject("component", "googlegeocode")>
</cfif>

<Cfset key = "ABQIAAAANFl_rAJclyWp_9Y6bMJWDhSEDsPCtRvpUWwLtaizQEvthdX2QhQ75G6BPFX9RyHFn1BUqcy2XPa-mA">
<cfparam name="form.street" default="">
<cfparam name="form.state" default="">
<cfparam name="form.zip" default="">
<cfparam name="form.city" default="">
<cfparam name="client.address" default="">
<cfparam name="client.street" default="">
<cfparam name="client.city" default="">
<cfparam name="client.state" default="">
<cfparam name="client.zip" default="">
<cfparam name="client.county" default="">
<cfparam name="client.lat" default="">
<cfparam name="client.long" default="">

<cfif len(trim(form.street))>
	<body onLoad="load()" onUnload="GUnload()">
<cfelse>
	<body>
</cfif>
<img src="http://www.exitgroup.org/logo/exit_logo.gif" />
<h2>Address</h2>

<cfoutput>
<p>
<cfform action="insert_Address.cfm" method="post">
Enter the address of the property. You can enter only street and zip if desired. If you don't know the zip, enter the city. <br>
<table border=1>
	<tr>
		<td valign="top" class="thin-border-right">
Please enter the address of the property.  
<table>
<tr>
	<td>Street </td><td><input type="text" name="street" value="#form.street#" size=15></td>
</tr>
<tr>
	<td>ZIP</td><td><input type="text" name="zip" value="#form.zip#" size=5></td>
</tr>
<tr>
	<td colspan=2 align="center"><b>-OR-</b></td>
</tr>
<tr>
	<td>City</td><td><input type="text" name="city" value="#form.city#" size=15></td>
</tr>
<tr>
	<td>State</td><td><input type="text" name="state" value="#form.state#" size=15></td>
</tr>

</table>
 <br><input type="submit" value="Verify Address">

   </td>
   <td valign="middle" class="thin-border-right">
 <cfset address = "#street# #city# #state# #zip#">
 <cfset form.address = "#street# #city# #state# #zip#">

   <cfif len(trim(address))>
	<cfset result = application.geo.geocode(key,trim(address))>
	
    <cfif result.statuscode eq 602>
	Please Check the address you entered.  Double check spelling.
	
	</cfif> 
	<cfset result = application.geo.geocode(key,trim(form.address))>
	


	<cfif structKeyExists(result, "latitude") and structKeyExists(result, "longitude")>
	<cfoutput>	
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=#key#" type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
       map.setCenter(new GLatLng(<cfoutput>#result.latitude#,#result.longitude#</cfoutput>), 15);
	   map.addControl(new GSmallMapControl());
		map.addControl(new GMapTypeControl());
		
				// Create our "tiny" marker icon
		var icon = new GIcon();
		icon.image = "http://www.exitgroup.org/pics/house_small.png";
		
		icon.iconSize = new GSize(30, 30);
		
		icon.iconAnchor = new GPoint(6, 12);
		icon.infoWindowAnchor = new GPoint(6, 12);
		
		// Creates a marker at the given point with the given number label
		function createMarker(point, number) {
		  var marker = new GMarker(point, icon);
		  GEvent.addListener(marker, "click", function() {
			marker.openInfoWindowHtml("#result.SUBADMINISTRATIVEAREATHOROUGHFARE#<br>#result.SUBADMINISTRATIVEAREALOCALITY# #result.administrativearea# 		      #result.SUBADMINISTRATIVEAREAPOSTALCODE#<br>#result.subadministrativearea# County");
		  });
		  
		  return marker;
		}

	    var point = new GLatLng(<cfoutput>#result.latitude#,#result.longitude#</cfoutput>);
		
		map.addOverlay(createMarker(point, 'marker'));
       }
    }
    //]]>
    </script>
    
    
	
<cfset client.address = #result.address#>
<cfset client.street = #result.SUBADMINISTRATIVEAREATHOROUGHFARE#>
<cfset  client.city = #result.SUBADMINISTRATIVEAREALOCALITY#>
<cfset client.state = #result.administrativearea#>
<cfset  client.zip = #result.SUBADMINISTRATIVEAREAPOSTALCODE#>
<cfset  client.county = #result.subadministrativearea#>
<cfset client.lat = #result.latitude#>
<cfset client.long = #result.longitude#>

use this address
<div id="map" style="width: 500px; height: 300px">LOADING...</div>	
	</cfoutput>
	</cfif>
</cfif>
</cfform>
</td>
<td>
Use this address:

</td>
</tr>
</table>
   




</cfoutput>


<a href="insert_address.cfm">Insert Information</a>
</body>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
</body>
</html>
