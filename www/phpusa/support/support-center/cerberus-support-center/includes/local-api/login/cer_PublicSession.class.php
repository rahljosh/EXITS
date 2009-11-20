<?php
require_once (FILESYSTEM_PATH . "includes/local-api/login/cer_PluginLogin.class.php");

class cer_Public_Session {
	var $user_id = 0;					// from `address`.address_id
	var $user_email = "";				// from `address`.address_address
	var $user_ip = null;				// IP tracking for session security
	var $public_access_level = null;
	var $user_company_id = null;
	var $viewed_articles = array();		// Articles we've viewed this session
	var $is_logged_in = false;			// boolean for login logic
	var $last_error_msg = null;
	
	// Constructor
	function cer_Public_Session() {
		$this->user_ip = $_SERVER['REMOTE_ADDR'];  // session security check
	}
	
	// [JAS]: Check if we have a login plugin defined or not, handle accordingly.
	function doLogin($user,$pass,$auto_register=false,$email=null) {
		global $pubgui;
		
		if($pubgui->settings["login_plugin_id"]) {
			$this->doPluginLogin($user,$pass,$auto_register,$email);
		}
		else {
			$this->doLocalLogin($user,$pass);
		}
	}
	
	function doPluginLogin($user,$pass,$auto_register=false,$email=null) {
		global $pubgui;

		$cerberus_db = Cer_Database::getInstance();
		
		$plugin_id = $pubgui->settings["login_plugin_id"];
		$row = null;
		
		$login_mgr = new cer_LoginPluginHandler();
		
		$params = array("username" => $user,
						"password" => $pass
				  );
		
		// [JAS]: Clear any previous remote user attempts.
		unset($_SESSION["remote_user_id"]);
		unset($_SESSION["remote_user"]);
		unset($_SESSION["remote_pass"]);
				  
		require_once(PATH_LOGIN_PLUGINS . $login_mgr->getPluginFile($plugin_id));
		$plugin = $login_mgr->instantiatePlugin($plugin_id,$params);
		$remote_user_id = $plugin->getRemoteUserId();

                // [JSJ]: Reconnect to Cerberus DB to make sure the plugin handler didn't hijack our connection
                // [JAS]: This needs more testing w/ new Singleton DB pattern
                $cerberus_db->connect();
		
		if(!$remote_user_id) {
			$this->last_error_msg = "ERROR: Login invalid.";
			return false;
		}
		
		// [JAS]: If auto register is enabled we need to bypass the two-step e-mail
		//	validation step and simply add the e-mail address to the remote_to_local 
		//	table.
		if($auto_register && $remote_user_id && $plugin_id && !empty($email)) {
			$plugin_login = new cer_PluginLogin();
			$plugin_login->localizeRemoteUser($remote_user_id,$plugin_id,$email);
		}

        // [JSJ]: Reconnect to Cerberus DB to make sure the plugin handler didn't hijack our connection
        // [JAS]: This needs more testing with the new Singleton DB pattern
        $cerberus_db->connect();
		
		$sql = sprintf("SELECT rto.public_user_id, rto.plugin_id, rto.remote_user_id, addr.address_address, pu.public_access_level, pu.company_id ".
					"FROM (public_gui_users_to_plugin rto) ".
					"LEFT JOIN address addr ON (rto.public_user_id = addr.public_user_id) ".
					"LEFT JOIN public_gui_users pu ON (rto.public_user_id = pu.public_user_id) ".
					"WHERE rto.remote_user_id = %d AND rto.plugin_id = %d",
						$remote_user_id,
						$plugin_id
				);
		$res = $cerberus_db->query($sql);
		
		if($row = $cerberus_db->grab_first_row($res)) {
			if(!$row["public_user_id"])
				return false;
				
			// [JAS]: Remote user already associated with a public user
			$this->user_id = $row["public_user_id"];
			$this->user_email = $row["address_address"];
			$this->public_access_level = $row["public_access_level"];
			$this->user_company_id = $row["company_id"];

			if(!empty($email)) $this->user_email = $email;
			$this->is_logged_in = true;
			
			return true;
		}
		else {
			$_SESSION["remote_user_id"] = $remote_user_id;
			$_SESSION["remote_user"] = $user;
			$_SESSION["remote_pass"] = $pass;
			$_SESSION["remote_email"] = (!empty($params["email"]) ? $params["email"] : "");
			
			$this->last_error_msg = "You need to confirm your e-mail address.";
			return false;
		}
	}
	
	// Attempt a login
	function doLocalLogin($user,$pass) {

		$cerberus_db = Cer_Database::getInstance();
		
		$sql = sprintf("SELECT pu.public_user_id, pu.password, pu.public_access_level, pu.company_id, a.address_id, a.address_address ".
					"FROM (`address` a, `public_gui_users` pu) ".
					"WHERE pu.public_user_id = a.public_user_id ".
					"AND a.address_address = %s AND pu.password = '%s'",
						$cerberus_db->escape($user),
						md5($pass)
				);
		$res = $cerberus_db->query($sql);
		
		// [JAS]: We have a winner
		if($cerberus_db->num_rows($res)) {
			$row = $cerberus_db->grab_first_row($res);
			
			$this->user_id = $row["public_user_id"];
			$this->user_email = $row["address_address"];
			$this->public_access_level = $row["public_access_level"];
			$this->user_company_id = $row["company_id"];
			
			$this->is_logged_in = true;
			
			return true;
		}
		else { // no matching logins
			$this->last_error_msg = "ERROR: Login invalid.";
			return false;
		}
	}
	
	// Session security check
	function securityCheck() {
		if($_SERVER['REMOTE_ADDR'] != $this->user_ip) {
			return false;  // destroy us if we're not safe
		}
		
		return true;
	}
	
};

?>