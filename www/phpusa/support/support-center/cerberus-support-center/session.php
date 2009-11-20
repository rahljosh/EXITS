<?php

if(!defined('E_STRICT')) {
	define('E_STRICT', 2048);
}

// Remove any PHP Notices as they shouldn't be shown in a production environment
error_reporting(error_reporting() & ~E_NOTICE & ~E_STRICT);

$path_info = pathinfo(__FILE__);
include_once ($path_info["dirname"] . "/config.php");

require_once (FILESYSTEM_PATH . "cerberus-api/public-gui/cer_PublicUser.class.php");
require_once (FILESYSTEM_PATH . "cerberus-api/login/cer_LoginPluginHandler.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/login/cer_PublicSession.class.php");

session_name("CerberusPublicGUI");
session_set_cookie_params(0,"/",$_SERVER["HTTP_HOST"],false);
session_start();

// [JAS]: See if we can find any current login data in the session
if(!isset($_SESSION["cer_login_serialized"])) {
	$cer_session = new cer_Public_Session();
	$_SESSION["cer_login_serialized"] = serialize($cer_session);
}
else {
	// [JAS]: Make sure the IP matches when the session was created, or destroy and start over.
	$cer_session = unserialize($_SESSION["cer_login_serialized"]);
	if(!$cer_session->securityCheck()) {
		setcookie( session_name() ,"",0,"/");
		session_unset();
		session_destroy();
		session_name("CerberusPublicGUI");
		session_set_cookie_params(0,"/",$_SERVER["HTTP_HOST"],false);
		session_start();
		$cer_session = new cer_Public_Session();
		$_SESSION["cer_login_serialized"] = serialize($cer_session);
	}
}

?>
