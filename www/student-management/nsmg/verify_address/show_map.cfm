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