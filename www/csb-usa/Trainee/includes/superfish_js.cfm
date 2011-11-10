		<link rel="stylesheet" type="text/css" href="../css/superfish.css" media="screen">
        <!---Library from google, this just code you never touch---->
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
        <!---Does the things that hapen when you mouse over, never need to touch---->
		<script type="text/javascript" src="../js/hoverIntent.js"></script>
        <!---Menu Items---->
		<script type="text/javascript" src="../js/superfish.js"></script>
        <!----This handles the long menu items---->
        <script type="text/javascript" src="../js/supersubs.js"></script>
		
		<!----short menu---->
        <!----
		<script type="text/javascript">

		// initialise plugins
		jQuery(function(){
			jQuery('ul.sf-menu').superfish();
		});

		</script>
        ---->
        <!----Long Menu---->
        <script> 
		 
			$(document).ready(function(){ 
				$("ul.sf-menu").supersubs({ 
					minWidth:    12,   // minimum width of sub-menus in em units 
					maxWidth:    27,   // maximum width of sub-menus in em units 
					extraWidth:  1     // extra width can ensure lines don't sometimes turn over 
									   // due to slight rounding differences and font-family 
				}).superfish();  // call supersubs first, then superfish, so that subs are 
								 // not display:none when measuring. Call before initialising 
								 // containing tabs for same reason. 
			}); 
		 
		</script>