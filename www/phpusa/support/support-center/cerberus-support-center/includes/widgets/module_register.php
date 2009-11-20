<?php
require_once (FILESYSTEM_PATH . "includes/local-api/register/cer_RegisterConfirmation.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/login/cer_PluginLogin.class.php");

$form_submit = isset($_REQUEST["form_submit"]) ? $_REQUEST["form_submit"] : "";
$register_email = isset($_REQUEST["register_email"]) ? $_REQUEST["register_email"] : "";
$register_code = isset($_REQUEST["register_code"]) ? $_REQUEST["register_code"] : "";
$auto_confirm = isset($_REQUEST["auto_confirm"]) ? $_REQUEST["auto_confirm"] : "";

$account_password = isset($_REQUEST["account_password"]) ? $_REQUEST["account_password"] : "";
$account_name_first = isset($_REQUEST["account_name_first"]) ? $_REQUEST["account_name_first"] : "";
$account_name_last = isset($_REQUEST["account_name_last"]) ? $_REQUEST["account_name_last"] : "";
$account_address = isset($_REQUEST["account_address"]) ? $_REQUEST["account_address"] : "";
$account_city = isset($_REQUEST["account_city"]) ? $_REQUEST["account_city"] : "";
$account_state = isset($_REQUEST["account_state"]) ? $_REQUEST["account_state"] : "";
$account_zip = isset($_REQUEST["account_zip"]) ? $_REQUEST["account_zip"] : "";
$account_country = isset($_REQUEST["account_country"]) ? $_REQUEST["account_country"] : "";
$account_phone_work = isset($_REQUEST["account_phone_work"]) ? $_REQUEST["account_phone_work"] : "";
$account_phone_home = isset($_REQUEST["account_phone_home"]) ? $_REQUEST["account_phone_home"] : "";
$account_phone_mobile = isset($_REQUEST["account_phone_mobile"]) ? $_REQUEST["account_phone_mobile"] : "";
$account_phone_fax = isset($_REQUEST["account_phone_fax"]) ? $_REQUEST["account_phone_fax"] : "";

$error_email = null;
$pass_confirm = null;
$error_confirm = null;

// [JAS]: Confirmation e-mail registration mode
if($pubgui->settings["pub_mod_registration_mode"] == "pass") {
	
	// [JAS]: If we're autoconfirming for the user, fill the values like the form was submitted.
	if (!empty($auto_confirm)) {
		list($register_email,$register_code) = explode(" ",base64_decode($auto_confirm));
		$form_submit = "register_confirm";
	}
	
	if (!empty($form_submit)) {
		
		$reg = new cer_RegisterConfirmation();
		
		switch($form_submit) {
			
			case "register_email": {
				$is_plugin_login = ($pubgui->settings["login_plugin_id"]) ? 1 : 0;
				
				if(!$reg->sendConfirmation($register_email,$is_plugin_login)) {
					$error_email = $reg->last_error_msg;
					require_once ("register/box_register_pass_step1.php");
				}
				else {
					$pass_confirm = "Success! A confirmation e-mail has been sent to your address.";
					require_once ("register/box_register_pass_step2.php");
				}
				break;
			}
				
			case "register_confirm": {
				$is_plugin_login = ($pubgui->settings["login_plugin_id"]) ? 1 : 0;
				
				if($reg->checkConfirmation($register_email,$register_code,$is_plugin_login)) { // pass
				
					// [JAS]: We've confirmed the e-mail provided for a remote user login
					if(!empty($_SESSION["remote_user_id"]) && $is_plugin_login) {
						$plugin_login = new cer_PluginLogin();
						$plugin_login->localizeRemoteUser($_SESSION["remote_user_id"],$pubgui->settings["login_plugin_id"],$register_email);
						require_once ("my_account/box_remote_login.php");						
					}
					// [JAS]: If we're creating a public user through the traditional Support Center
					//	login system, let the user create their account at this point.
					else {
						require_once ("register/box_register_pass_step3.php");
					}
					
				}
				else { // fail
					$error_confirm = $reg->last_error_msg;
					require_once ("register/box_register_pass_step2.php");
				}
				
				break;
			}
			
			case "register_account": {
				
				if($reg->checkConfirmation($register_email,$register_code)) { // pass
				
					$public_user = new cer_PublicUser();
						$public_user->account_name_first = $account_name_first;
						$public_user->account_name_last = $account_name_last;
						$public_user->account_register_email = $register_email;
						$public_user->account_register_code = $register_code;
						$public_user->account_password = $account_password;
						$public_user->account_address = $account_address;
						$public_user->account_city = $account_city;
						$public_user->account_state = $account_state;
						$public_user->account_zip = $account_zip;
						$public_user->account_country = $account_country;
						$public_user->account_phone_work = $account_phone_work;
						$public_user->account_phone_home = $account_phone_home;
						$public_user->account_phone_mobile = $account_phone_mobile;
						$public_user->account_phone_fax = $account_phone_fax;
					
					if($public_user_id = $reg->createPublicUser($public_user)) {
						require_once ("register/box_account_created.php");
					}
					else {
						require_once ("register/box_register_pass_step3.php");
					}
					
				}
				
				break;
			}
			
		} // end switch
	}
	
	else {
		require_once ("register/box_register_pass_step1.php");
		require_once ("register/box_register_pass_step2.php");
	}
	
}

// [JAS]: SLA, etc. mode
else {
	
}
	
?>
