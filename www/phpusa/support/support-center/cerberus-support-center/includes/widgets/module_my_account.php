<?php

$form_submit = isset($_REQUEST["form_submit"]) ? $_REQUEST["form_submit"] : "";

$account_password = isset($_REQUEST["account_password"]) ? $_REQUEST["account_password"] : "";
$account_new_password = isset($_REQUEST["account_new_password"]) ? $_REQUEST["account_new_password"] : "";
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

@$pass_account = null;
@$pass_password = null;
@$fail_password = null;

//function get_country_list() {
//	global $cerberus_db;
//	$country_list = array();
//	
//	$sql = "SELECT cou.country_id, cou.country_name FROM country cou ORDER BY cou.country_name";
//	$res = $cerberus_db->query($sql);
//	
//	if($cerberus_db->num_rows($res)) {
//		while($row = $cerberus_db->fetch_row($res)) {
//			$country_list[$row["country_id"]] = $row["country_name"];
//		}
//	}
//	
//	return $country_list;
//}
//
//$country_list = get_country_list();

if($cer_session->is_logged_in) {

	if(!empty($form_submit)) {
		
		switch($form_submit) {
			
			case "my_account": {
				
				$sql = sprintf("UPDATE public_gui_users SET name_first=%s, name_last=%s, mailing_address=%s, mailing_city=%s, ".
						"mailing_state=%s, mailing_zip=%s, mailing_country_old=%s, phone_work=%s, phone_home=%s, phone_mobile=%s, ".
						"phone_fax=%s ".
						"WHERE public_user_id = %d",
							$cerberus_db->escape($account_name_first),
							$cerberus_db->escape($account_name_last),
							$cerberus_db->escape($account_address),
							$cerberus_db->escape($account_city),
							$cerberus_db->escape($account_state),
							$cerberus_db->escape($account_zip),
							$cerberus_db->escape($account_country),
							$cerberus_db->escape($account_phone_work),
							$cerberus_db->escape($account_phone_home),
							$cerberus_db->escape($account_phone_mobile),
							$cerberus_db->escape($account_phone_fax),
							$cer_session->user_id
					);
				$cerberus_db->query($sql) or die("Error updating user information.");
				
				$pass_account = "Success!  Contact information updated.";
				
				break;
			}
			
			case "my_account_password": {

				// [JAS]: Change Password doesn't exist if we're using a plugin
				if($pubgui->settings["login_plugin_id"])
					break;
				
				$user_handler = new cer_PublicUserHandler();
				$id = $cer_session->user_id;
				$user_handler->loadUsersByIds(array($id));
				
				$public_user = &$user_handler->users[$id];
				
				if($public_user->account_password == md5($account_password)) {
					$sql = sprintf("UPDATE public_gui_users SET `password` = %s ".
							"WHERE public_user_id = %d",
								$cerberus_db->escape(md5($account_new_password)),
								$id
						);
					$cerberus_db->query($sql);
					
					$pass_password = "Success!  Password updated.";
				}
				else {
					$fail_password = "ERROR: Current password invalid.";
				}
								
				break;
			}
			
		}
		
	}
	
	// [JAS]: This should probably be part of the session all the time?
	//	Make sure we're using the most up to date account information
	$user_handler = new cer_PublicUserHandler();
	$id = $cer_session->user_id;
	$user_handler->loadUsersByIds(array($id));
	
	// pointer to selected user
	$public_user = &$user_handler->users[$id];
	
	require_once ("my_account/box_my_account.php");
}

else {
	require_once ("shared/box_not_logged_in.php");
}



?>
