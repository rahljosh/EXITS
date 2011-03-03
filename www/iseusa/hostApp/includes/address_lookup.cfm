<!--- this is included by: forms/school_form.cfm, forms/host_fam_form.cfm, forms/user_form.cfm --->

<script src="http://maps.google.com/maps?file=api&v=2&sensor=false&key=ABQIAAAANFl_rAJclyWp_9Y6bMJWDhSEDsPCtRvpUWwLtaizQEvthdX2QhQ75G6BPFX9RyHFn1BUqcy2XPa-mA" type="text/javascript"></script>
<script type="text/javascript">
var geocoder;
function initialize() {
 geocoder = new GClientGeocoder();
}
// addAddressToMap() is called when the geocoder returns an answer.
function addAddressToMap(response) {
 document.my_form.lookup_success.value = 0;
 document.my_form.address.value = '';
 document.my_form.city.value = '';
 document.my_form.state.value = '';
 document.my_form.zip.value = '';
 if (!response || response.Status.code != 200) {
    alert("Sorry, we were unable to lookup that address.");
 } else {
   place = response.Placemark[0];
   // address level accuracy = 8
   if (place.AddressDetails.Accuracy == 8) {
	document.my_form.lookup_success.value = 1;
    document.my_form.address.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.Thoroughfare.ThoroughfareName;
    document.my_form.city.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.LocalityName;
    document.my_form.state.value = place.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName;
    document.my_form.zip.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
   	alert("This entered address is valid.  Please verify that the address, city, state, and zip fields below are correct.");
   }
   else {
   	alert("This address is not accurate to the address level.");
   }
 }
}
// showLocation() is called when you click on the Search button
// in the form.  It geocodes the address entered into the form.
function showLocation() {
 var address =  document.my_form.lookup_address.value;
 geocoder.getLocations(address, addAddressToMap);
}
</script>

<body onLoad="initialize();" onUnload="GUnload()">