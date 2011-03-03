<!--- see application.cfm for the templates this is included on. --->
<!----ISE.LOCAL key ABQIAAAAJKd5F0qhm5iwTQ_RUwW87RSZ3eowe84jhdCqG6p5-VBQ1NT-oxTUanED__FKh0fHC16VE5BWSb5KWg---->
<!----SMG KEY: ABQIAAAANFl_rAJclyWp_9Y6bMJWDhSEDsPCtRvpUWwLtaizQEvthdX2QhQ75G6BPFX9RyHFn1BUqcy2XPa-mA---->
<script src="http://maps.google.com/maps/api/js?sensor=true" type="text/javascript"></script>
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
 var address =  document.my_form.address.value + ' ' + document.my_form.city.value + ' ' + document.my_form.state.value + ' ' + document.my_form.zip.value;
 geocoder.getLocations(address, addAddressToMap);
}
</script>

<body onLoad="initialize();" onUnload="GUnload()">