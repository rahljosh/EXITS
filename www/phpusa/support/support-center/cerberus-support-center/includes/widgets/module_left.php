<?php 
include("left/box_menu.php");

require_once (FILESYSTEM_PATH . "cerberus-api/login/cer_LoginPluginHandler.class.php");

if($cer_session->is_logged_in) {
	include("left/box_logout.php");
}
else {
	$login_string = "E-mail";
	$password_string = "Password";	
	
	// [JAS]: Get Login/Pass strings if a plugin is used
	$plugin_id = $pubgui->settings["login_plugin_id"];
	
	// [JAS]: If we haven't cached the plugin this session, grab its info.
	if($plugin_id && !isset($_SESSION["plugin_cache"][$plugin_id])) {
		$login_mgr = new cer_LoginPluginHandler();
		require_once(PATH_LOGIN_PLUGINS . $login_mgr->getPluginFile($plugin_id));
		$params = array();
		$plugin = $login_mgr->instantiatePlugin($plugin_id,$params);
		
		$login_string = $plugin->login_string;
		$password_string = $plugin->password_string;

		// [JAS]: Cache the plugin details so we don't have to instantiate it every time we need them.
		$_SESSION["plugin_cache"] = array();
		$_SESSION["plugin_cache"][$plugin_id] = array();
		$_SESSION["plugin_cache"][$plugin_id][0] = $login_string;
		$_SESSION["plugin_cache"][$plugin_id][1] = $password_string;
	}
	
	// [JAS]: If we have a plugin cache, use it for the meta data.
	if($plugin_id && isset($_SESSION["plugin_cache"][$plugin_id])) {
		$login_string = $_SESSION["plugin_cache"][$plugin_id][0]; 
		$password_string = $_SESSION["plugin_cache"][$plugin_id][1];
	}
	
	include("left/box_login.php");
}

if($pubgui->settings["pub_mod_kb"]) {
	include("shared/box_kb_search.php");
}

if($pubgui->settings["pub_mod_contact"]) { 
	include("home/box_contact.php");
}

?>