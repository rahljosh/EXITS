<?php
require_once ("config.php");
require_once ("session.php");

require_once(FILESYSTEM_PATH . "cerberus-api/public-gui/cer_PublicGUISettings.class.php");

$pubgui = new cer_PublicGUISettings(PROFILE_ID);
$return_url = isset($_REQUEST["return_url"]) ? urldecode($_REQUEST["return_url"]) : BASE_URL;

if(isset($_REQUEST["form_submit"])) {

	switch($_REQUEST["form_submit"]) {
		
		case "do_login": {
			$cer_session->doLogin($_REQUEST["auth_user"],$_REQUEST["auth_pass"]);
			
			// [JAS]: If we didn't log in but we're a pending remote user, shift focus to the
			//	add e-mail module.
			if(!$cer_session->is_logged_in && !empty($_SESSION["remote_user_id"])) {
                if(strpos($return_url, "mod_id") !== FALSE) {                            
					$return_url = preg_replace("/mod_id=\d+/", "mod_id=" . MODULE_REGISTER, $return_url);       
                }                        
                else {                   
					$return_url .= "&mod_id=" . MODULE_REGISTER;                     
                } 
			}
			
			$_SESSION["cer_login_serialized"] = serialize($cer_session);
			
			break;
		}
		
		case "do_logout": {
			unset($_COOKIE[session_name()]);
			session_unset();
			session_destroy();
			break;
		}
	}
}
// Anti header injection (ObiJan)
$return_url = preg_replace('/\s+/', ' ', $return_url);
session_write_close();
header("Location: " . $return_url);
exit;
?>
