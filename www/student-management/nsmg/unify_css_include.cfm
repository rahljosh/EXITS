<!-- CSS Global Compulsory -->


	<link rel="stylesheet" href="assets/css/bootstrap.min.css">
	<link rel="stylesheet" href="assets/css/style.css">


	<!-- CSS Header and Footer -->
	<link rel="stylesheet" href="assets/css/headers/header-default.css">
	<link rel="stylesheet" href="assets/css/footers/footer-v3.css">

	<!-- CSS Implementing Plugins -->
	<link rel="stylesheet" href="assets/plugins/animate.css">
	<link rel="stylesheet" href="assets/plugins/line-icons/line-icons.css">
	<script src="https://use.fontawesome.com/b474fc74fd.js"></script>
<!--	<link rel="stylesheet" href="assets/plugins/font-awesome/css/font-awesome.min.css">-->

	<!-- CSS Page Style -->
	<!----<link rel="stylesheet" href="assets/css/pages/page_log_reg_v1.css">---->
	<!----Profile---->
	<link rel="stylesheet" href="assets/css/pages/profile.css">
	<link rel="stylesheet" href="assets/plugins/scrollbar/css/jquery.mCustomScrollbar.css">

	<!----Form Elements---->
	<link rel="stylesheet" href="assets/plugins/sky-forms-pro/skyforms/css/sky-forms.css">
	<link rel="stylesheet" href="assets/plugins/sky-forms-pro/skyforms/custom/custom-sky-forms.css">

	
	<!-- CSS Theme -->
	<link rel="stylesheet" href="assets/css/theme-colors/blue.css" id="style_color">
	<link rel="stylesheet" href="assets/css/theme-skins/dark.css">

	<!-- CSS Customization -->
	<link rel="stylesheet" href="assets/css/custom.css">
	<!--Format Date Picker-->	
	  <script type="text/javascript">
	   $(function() {
			   $("#datepicker").datepicker({ dateFormat: "yy-mm-dd" }).val()
	   });
	  </script>
		<!--Smarty Streets-->
		

		<script src="//d79i1fxsrar4t.cloudfront.net/jquery.liveaddress/3.2/jquery.liveaddress.min.js"></script>
		<script> var liveaddress = jQuery.LiveAddress({
					key: '19728119051131453',
					autocomplete: 5,
					metadata:[{
						latitude: '#latitdue',
						longitude: '#longitude'
					}],
					addresses: [{
						address1: '#address',
						address2: '#address2',	// Not all these fields are required
						locality: '#city',
						administrative_area: '#state',
						postal_code: '#zip'
					}]
				});
	</script>
	
	
	<script>
	$(document).ready(function(){
		$('.phone').mask('(000) 000-0000');
	}
	</script>