<?php

require_once (FILESYSTEM_PATH . "includes/local-api/register/cer_ConfirmationCode.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/mail/sock_mail.function.php");

class cer_RegisterConfirmation {
	var $db;
	var $confirm_email = null;
	var $confirm_code = null;
	var $company_name = null;
	var $company_email = null;
	var $last_error_msg = null;
	
	function cer_RegisterConfirmation() {
		$this->db = Cer_Database::getInstance();
	}
	
	function sendConfirmation($to_email,$ignore_exists=0) {
		global $pubgui;
		
		$conf_code = cer_ConfirmationCode::generateConfirmationCode();
		
		if(empty($to_email) || !isset($pubgui)) {
			$this->last_error_msg = "ERROR: Not sending confirmation to an empty e-mail address.";
			return false;
		}
		
		$this->company_name = $pubgui->settings["pub_company_name"];
		$this->company_email = $pubgui->settings["pub_company_email"];
		$this->confirm_email = $to_email;
		$this->confirm_code = cer_ConfirmationCode::generateConfirmationCode();
		
		$from = $pubgui->settings["pub_company_email"];
		$subject = $this->_replaceMergeTags($pubgui->settings["pub_confirmation_subject"]);
		$content = $this->_replaceMergeTags($pubgui->settings["pub_confirmation_body"]);
		
		$headers = "From: $from\r\n".
			"Reply-to: $from\r\n".
			"Date: " . date("r");
		
		$body = $content . 
			"\r\n".
			"\r\n".
			"Registration IP: " . $_SERVER['REMOTE_ADDR'] . "\r\n";
		
		if($this->_writeCodeToDB($ignore_exists)) {
			sock_mail(SMTP_AUTH,$to_email,$subject,$body,$headers,$from);
			return true;
		}
		else {
			$this->last_error_msg = "ERROR: E-mail address is already registered.";
			return false;
		}
	}
	
	function _replaceMergeTags($text) {
		/*
		 ##site_url## - An automatically generated URL back to the Public GUI main page.
		 ##confirm_url## - An automatically generated URL back to the Public GUI confirmation screen.
		 ##confirm_email## - The e-mail address entered by the public user.
		 ##confirm_code## - The randomly generated confirmation code to send.
		 ##company_name## - The name of your company, as entered above.
		 ##company_email## - Your company's e-mail contact address, as entered above.
		*/
		
		$tags = array(
			"##site_url##",
			"##confirm_url##",
			"##confirm_email##",
			"##confirm_code##",
			"##company_name##",
			"##company_email##"
		);
				
		$url = BASE_URL;
		$base64_autoconf = base64_encode($this->confirm_email . " " . $this->confirm_code);
		
		$values = array(
			$url,
			$url . "&mod_id=" . MODULE_REGISTER . "&auto_confirm=" .  $base64_autoconf,
			$this->confirm_email,
			$this->confirm_code,
			$this->company_name,
			$this->company_email
		);
		
		return str_replace($tags,$values,$text);
	}
	
	function _writeCodeToDB($ignore_exists=0) {
		$sql = sprintf("SELECT a.address_id, a.public_user_id FROM address a WHERE a.address_address = %s",
				$this->db->escape($this->confirm_email)
			);
		$res = $this->db->query($sql);
		
		if($row = $this->db->grab_first_row($res)) {
			
			$addy_id = $row["address_id"];
			$pub_user_id = $row["public_user_id"];
						
			// [JAS]: Check if pub_user_id isn't 0 (addy already assigned + confirmed)
			if($ignore_exists || empty($pub_user_id)) {
				$sql = sprintf("UPDATE address SET confirmation_code=%s WHERE address_id = %d",
						$this->db->escape($this->confirm_code),
						$addy_id
					);
				$this->db->query($sql);
				
				return true;
			}
			
			else {
				$this->last_error_msg = "ERROR: E-mail address is already registered.";
				return false;
			}
		}
		
		else {
			$sql = sprintf("INSERT INTO address (address_address, confirmation_code) ".
					"VALUES (%s,%s)",
						$this->db->escape($this->confirm_email),
						$this->db->escape($this->confirm_code)
				);
			$this->db->query($sql);
			$addy_id = $this->db->insert_id();
			
			return true;
		}
	}
	
	function _readCodeFromDB($email,$code,$ignore_exists=0) {
		
		if(empty($code) || empty($email)) {
			$this->last_error_msg = "ERROR: Registration e-mail and confirmation code cannot be blank.";
			return false;
		}
		
		$sql = sprintf("SELECT a.address_id, a.public_user_id FROM address a ".
				"WHERE a.confirmation_code = %s AND a.address_address = %s",
					$this->db->escape($code),
					$this->db->escape($email)
			);
		$res = $this->db->query($sql);
		
		if($row = $this->db->grab_first_row($res))
			if($ignore_exists || empty($row["public_user_id"]))
				return true;
			else {
				$this->last_error_msg = "ERROR: Confirmation failed.  E-mail address has already been registered.";
				return false;
			}
		else {
			$this->last_error_msg = "ERROR: Confirmation failed.  Please check your confirmation code.";
			return false;
		}
	}
	
	function checkConfirmation($email,$code,$ignore_exists=0) {
		return $this->_readCodeFromDB($email,$code,$ignore_exists);
	}
	
	function createPublicUser($public_user) {
		
		if(!is_object($public_user))
			return false;
		
		$sql = sprintf("SELECT a.address_id, a.public_user_id FROM address a WHERE a.address_address = %s",
				$this->db->escape($public_user->account_register_email)
			);
		$res = $this->db->query($sql);
		
		if($row = $this->db->grab_first_row($res)) {
			// [JAS]: Don't re-assign any address already assigned to a public user.
			if($row["public_user_id"]) {
				$this->last_error_msg = "ERROR: E-mail address is already registered.";
				return false;
			}
		}
		
		// \todo [JAS]: This probably belongs in the cer_PublicUser.class.php file
		$sql = sprintf("INSERT INTO public_gui_users (name_first, name_last, mailing_address, mailing_city, mailing_state, 
		mailing_zip, mailing_country_old, phone_work, phone_home, phone_mobile, phone_fax, `password`) ".
				"VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) ",
					$this->db->escape($public_user->account_name_first),
					$this->db->escape($public_user->account_name_last),
					$this->db->escape($public_user->account_address),
					$this->db->escape($public_user->account_city),
					$this->db->escape($public_user->account_state),
					$this->db->escape($public_user->account_zip),
					$this->db->escape($public_user->account_country),
					$this->db->escape($public_user->account_phone_work),
					$this->db->escape($public_user->account_phone_home),
					$this->db->escape($public_user->account_phone_mobile),
					$this->db->escape($public_user->account_phone_fax),
					$this->db->escape(md5($public_user->account_password))
			);
		$this->db->query($sql) or die ("ERROR: Could not create public user.  Please alert an administrator.  Details: " . mysql_error());
		
		$public_user->public_user_id = $this->db->insert_id();
		
		if(!empty($public_user->public_user_id) && !empty($public_user->account_register_email) && !empty($public_user->account_register_code)) {
			$sql = sprintf("UPDATE address SET public_user_id = %d WHERE address_address = %s AND confirmation_code = %s",
					$public_user->public_user_id,
					$this->db->escape($public_user->account_register_email),
					$this->db->escape($public_user->account_register_code)
				);
			$this->db->query($sql) or die ("ERROR: Could not update address with public user ID.");
			
			return $public_user->public_user_id;	
		}
		
		$this->last_error_msg = "ERROR: Account creation failed.";
		return false;
	}
	
};

?>
