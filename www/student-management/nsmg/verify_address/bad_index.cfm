
<cfif not structKeyExists(application, "geo") or structKeyExists(url, "reinit")>
	<cfset application.geo = createObject("component", "googlegeocode")>
</cfif>

<cfparam name="form.address" default="">


<cfif len(trim(form.address))>
	<body onLoad="load()" onUnload="GUnload()">
<cfelse>
	<body>
</cfif>

<h2>EXIT Group Real Estate Management System</h2>

<cfoutput>
<p>
<form action="test_public.cfm" method="post">
Enter the address of the property. You can enter only street and zip if desired. If you don't know the zip, enter the city. <input type="text" name="address" value="#form.address#"> <input type="submit" value="Geocode!">
</form>
</p>
</cfoutput>
Please verify the information below, and click on Next:<br>
<cfif len(trim(form.address))>
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

	    var point = new GLatLng(<cfoutput>#result.latitude#,#result.longitude#</cfoutput>);
		map.addOverlay(new GMarker(point));
       }
    }
    //]]>
    </script>
    
    <div id="map" style="width: 500px; height: 300px">Loading....</div>	
	
<cfset session.prop_details.address = #result.address#>
<cfset session.prop_details.street = #result.SUBADMINISTRATIVEAREATHOROUGHFARE#>
<cfset  session.prop_details.city = #result.SUBADMINISTRATIVEAREALOCALITY#>
<cfset session.prop_details.state = #result.administrativearea#>
<cfset  session.prop_details.zip = #result.SUBADMINISTRATIVEAREAPOSTALCODE#>
<cfset  session.prop_details.county = #result.subadministrativearea#>
<cfset session.prop_details.lat = #result.latitude#>
<cfset session.prop_details.long = #result.longitude#>
Full Address Information:<br>
#session.prop_Details.street#<br>
#session.prop_details.city# #session.prop_details.state# #session.prop_Details.zip#<br>
#session.prop_Details.county# County
	</cfoutput>
	</cfif>
</cfif>

<a href="insert_address.cfm">Insert Information</a>
</body>

