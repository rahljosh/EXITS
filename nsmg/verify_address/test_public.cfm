
			<div align="Center">
				 Pleae wait, calculating logitude & latitude.<br />
					<img src="details/ajax-loader.gif" />
					</div>
	
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAANFl_rAJclyWp_9Y6bMJWDhQ_kXTztNyAymUuoBQeMRDGqpE5ZBTNzU4c5ebJKX575Cq0LB3kPx650g" type="text/javascript"></script>




<cfif not structKeyExists(application, "geo") or structKeyExists(url, "reinit")>
	<cfset application.geo = createObject("component", "googlegeocode")>
</cfif>

<cfset key ="ABQIAAAANFl_rAJclyWp_9Y6bMJWDhQ_kXTztNyAymUuoBQeMRDGqpE5ZBTNzU4c5ebJKX575Cq0LB3kPx650g">
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

    <cfset key ="ABQIAAAANFl_rAJclyWp_9Y6bMJWDhTLXyHgqAU_Q_Mf7jGB_k2gnJgv2hRjUF1ienTNhruou0Z-mFAhhraNVg">
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
		icon.image = "http://www.bricks-sticks.com/details/house_small.png";
		
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
	</cfoutput>
	</cfif>

	</cfif>
    
	
<cfset client.address = #result.address#>
<cfset client.street = #form.address#>
<cfset  client.city = #result.SUBADMINISTRATIVEAREALOCALITY#>
<cfset client.state = #result.administrativearea#>
<cfset  client.zip = #result.SUBADMINISTRATIVEAREAPOSTALCODE#>
<cfset  client.county = #result.subadministrativearea#>
<cfset client.lat = #result.latitude#>
<cfset client.long = #result.longitude#>

<cfdump var="#client#">


<!----


<cfquery name="insert_long" datasource="bricks">
insert into addresses (address, city, state, zip, latitude, longitude, county)
			values     ('#client.street#','#client.city#','#client.state#','#client.zip#', '#client.lat#','#client.long#','#client.county#')

</cfquery>
<cflocation url="index.cfm?curdoc=user_info&user=#url.user#" addtoken="no">
---->


