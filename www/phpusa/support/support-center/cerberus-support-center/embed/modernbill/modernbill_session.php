<?php
require_once (CER_MB_FILESYSTEM_PATH . "config.php");

require_once (FILESYSTEM_PATH . "cerberus-api/public-gui/cer_PublicGUISettings.class.php");
$pubgui = new cer_PublicGUISettings(PROFILE_ID);

require_once (FILESYSTEM_PATH . "cerberus-api/public-gui/cer_PublicUser.class.php");
require_once (FILESYSTEM_PATH . "cerberus-api/login/cer_LoginPluginHandler.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/login/cer_PublicSession.class.php");

if(!$pubgui->checkProfileID(PROFILE_ID)) {
	echo "Cerberus Support Center [ERROR]: The PROFILE_ID in config.php is not valid.  Check the [Configuration]->Public GUI Profiles area in the Cerberus GUI.";
	exit;
}

// [JAS]: See if we can find any current login data in the session
if(!isset($_SESSION["cer_login_serialized"])) {
	$cer_session = new cer_Public_Session();
	$_SESSION["cer_login_serialized"] = serialize($cer_session);
}
else {
	// [JAS]: Make sure the IP matches when the session was created, or destroy and start over.
	$cer_session = unserialize($_SESSION["cer_login_serialized"]);
}

if(!$cer_session->is_logged_in) {
	$login_user = $_SESSION["this_user"]["client_email"]; 
	$login_pass = $_SESSION["this_user"]["client_real_pass"];
	$login_email = $_SESSION["this_user"]["client_email"]; 
	
	if(!empty($login_email) 
		&& !empty($login_pass)) {
			$cer_session->doLogin($login_email,$login_pass,true, $login_email);
	}
	
	$_SESSION["cer_login_serialized"] = serialize($cer_session);
}

?>