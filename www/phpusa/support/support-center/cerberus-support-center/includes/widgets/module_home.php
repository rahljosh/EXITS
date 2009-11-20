<?php
if($pubgui->settings["pub_mod_welcome"]) { 
	include("home/box_welcome.php");
}

//if($pubgui->settings["pub_mod_welcome"]) { 
	include("home/box_home_menu.php");
//}

if($pubgui->settings["pub_mod_kb"]) { 
	include("shared/box_most_viewed_kb.php");
}
?>
