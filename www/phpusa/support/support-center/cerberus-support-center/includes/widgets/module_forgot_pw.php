<?php
require_once (FILESYSTEM_PATH . "includes/local-api/register/cer_ConfirmationCode.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/mail/sock_mail.function.php");

$form_submit = isset($_REQUEST["form_submit"]) ? $_REQUEST["form_submit"] : "";
$forgot_email = isset($_REQUEST["forgot_email"]) ? $_REQUEST["forgot_email"] : "";
$forgot_code = isset($_REQUEST["forgot_code"]) ? $_REQUEST["forgot_code"] : "";
$forgot_password = isset($_REQUEST["forgot_password"]) ? $_REQUEST["forgot_password"] : "";

$pass_email = null;
$fail_email = null;
$pass_code = null;
$fail_code = null;

if(!empty($form_submit)) {
	
	switch($form_submit) {
		
		case "forgot_email": {
			$sql = sprintf("SELECT a.address_address, a.public_user_id, a.address_id ".
					"FROM address a ".
					"WHERE a.address_address = %s AND a.public_user_id != 0",
						$cerberus_db->escape($forgot_email)
				);
			$res = $cerberus_db->query($sql);
			
			if($row = $cerberus_db->grab_first_row($res)) {
				if(empty($row["public_user_id"])) {
					$fail_email = "ERROR: E-mail address not registered.";
				}
				else {
					// [JAS]: Send confirmation code that will be used to verify the account.
					//...
					
					$conf_code = cer_ConfirmationCode::generateConfirmationCode();
					$from = $pubgui->settings["pub_company_email"];
					$url = "http://" . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF'] . "?mod_id=" . MODULE_FORGOT_PW;
					$subject = "Confirmation code to reset your Support Center password";
					$content = "To reset your Support Center password, please to the following:\r\n".
						"\r\n".
						"Return to the " . $pubgui->settings["pub_company_name"] . " Support Center:\r\n".
						"$url\r\n".
						"\r\n".
						"E-mail Address: " . $forgot_email . "\r\n".
						"Confirmation Code: " . $conf_code . "\r\n".
						"\r\n".
						"Choose a new password and press 'Update Password'.\r\n".
						"\r\n";
					
					$headers = "From: $from\r\n".
						"Reply-to: $from\r\n".
						"Date: " . date("r");
					
					$body = $content . 
						"\r\n".
						"\r\n".
						"Client IP: " . $_SERVER['REMOTE_ADDR'] . "\r\n";
					
					$sql = sprintf("UPDATE address SET confirmation_code = %s WHERE address_address = %s AND public_user_id != 0",
							$cerberus_db->escape($conf_code),
							$cerberus_db->escape($forgot_email)
						);
					$cerberus_db->query($sql);
						
					sock_mail(SMTP_AUTH,$forgot_email,$subject,$body,$headers,$from);
					$pass_email = "Success!  A confirmation code has been sent to you by e-mail.";
				}
			}
			else {
				$fail_email = "ERROR: E-mail address not registered.";
			}
			
			require_once ("forgot_pw/box_forgot_pw.php");
			break;
		}
		
		case "forgot_code": {
			$sql = sprintf("SELECT a.address_address, a.public_user_id, a.address_id ".
					"FROM address a ".
					"WHERE a.address_address = %s ".
					"AND a.confirmation_code = %s ".
					"AND a.public_user_id != 0",
						$cerberus_db->escape($forgot_email),
						$cerberus_db->escape($forgot_code)
				);
				
			$res = $cerberus_db->query($sql);
			
			if($row = $cerberus_db->grab_first_row($res)) {
				$sql = sprintf("UPDATE public_gui_users SET `password` = %s WHERE `public_user_id` = %d",
						$cerberus_db->escape(md5($forgot_password)),
						$row["public_user_id"]
					);
				$cerberus_db->query($sql);
				
				require_once ("forgot_pw/box_password_reset.php");
			}
			else {
				$fail_code = "ERROR: E-mail address not registered or confirmation code didn't match.";
				require_once ("forgot_pw/box_forgot_pw.php");
			}
			
			break;
		}
	}
	
}

else {
	require_once ("forgot_pw/box_forgot_pw.php");
}



?>