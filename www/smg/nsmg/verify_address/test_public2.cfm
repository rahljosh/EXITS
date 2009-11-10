<cfapplication name="googlegeocode">

<cfif not structKeyExists(application, "geo") or structKeyExists(url, "reinit")>
	<cfset application.geo = createObject("component", "googlegeocode")>
</cfif>

<cfparam name="form.address" default="">

<cfset key = "ABQIAAAANFl_rAJclyWp_9Y6bMJWDhQ_kXTztNyAymUuoBQeMRDGqpE5ZBTNzU4c5ebJKX575Cq0LB3kPx650g">

<cfif len(trim(form.address))>
	<body onLoad="load()" onUnload="GUnload()">
<cfelse>
	<body>
</cfif>

<h2>Google Geocode Demo</h2>

<cfoutput>
<p>
<form action="test_public2.cfm" method="post">
Enter an address: <input type="text" name="address" value="#form.address#"> <input type="submit" value="Geocode!">
</form>
</p>
</cfoutput>

<cfif len(trim(form.address))>
	<cfset result = application.geo.geocode(key,trim(form.address))>
	
	<cfdump var="#result#" label="Geocode Information">

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
    
    <div id="map" style="width: 500px; height: 300px"></div>	
	</cfoutput>
	</cfif>
</cfif>

</body>

