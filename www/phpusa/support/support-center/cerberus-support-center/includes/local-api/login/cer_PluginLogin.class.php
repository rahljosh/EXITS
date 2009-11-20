<?php

class cer_PluginLogin
{
	var $db = null;
	
	function cer_PluginLogin() {
		$this->db = Cer_Database::getInstance();
	}
	
	function localizeRemoteUser($remote_user_id,$plugin_id,$email) {
		global $cer_session;
		
		$public_user_id = null;
		
		if(empty($cer_session)) {
			$cer_session = @unserialize($_SESSION["cer_login_serialized"]);		
		}
		
		unset($_SESSION["remote_user_id"]);
		unset($_SESSION["remote_user"]);
		unset($_SESSION["remote_pass"]);
		
		$sql = sprintf("SELECT a.address_id, a.public_user_id FROM address a WHERE a.address_address = %s",
				$this->db->escape($email)
			);
		$res = $this->db->query($sql);
		
		// [JAS]: If this e-mail address wasn't already in our Cerberus Helpdesk 
		//	installation then we need to add it.
		if(!$row = $this->db->grab_first_row($res)) {
			$sql = sprintf("INSERT INTO address (address_address) VALUES (%s) ",
					$this->db->escape($email)	
				);
			$this->db->query($sql);
			
			$address_id = $this->db->insert_id();
		}
		else { // existing address ID
			$address_id = $row["address_id"];
		}
		
		// If the address doesn't have a public user assigned, make one
		if(!$row["public_user_id"]) {
			$sql = sprintf("INSERT INTO public_gui_users (name_first, name_last) ".
					"VALUES ('','')"
				);
			$this->db->query($sql);
			
			$public_user_id = $this->db->insert_id();
			
			$sql = sprintf("UPDATE address SET public_user_id = %d WHERE address_id = %d",
					$public_user_id,
					$address_id
				);
			$this->db->query($sql);
		}
		else { // existing pub user id
			$public_user_id = $row["public_user_id"];
		}
		
		// [JAS]: Add to the remote->plugin->local matrix table
		$sql = sprintf("REPLACE INTO public_gui_users_to_plugin (public_user_id,plugin_id,remote_user_id) ".
				"VALUES (%d,%d,%d)",
					$public_user_id,
					$plugin_id,
					$remote_user_id
			);
		$this->db->query($sql);
		
		// [JAS]: If we set up a local public user, let it take over the session.
		if(isset($public_user_id)) {
			if(!empty($cer_session)) {
				$cer_session->user_id = $public_user_id;
				$cer_session->user_email = $email;
				$cer_session->is_logged_in = true;
				$cer_session->last_error_msg = "";
				$_SESSION["cer_login_serialized"] = serialize($cer_session);
			}
			
			return true;
		}
		
		return false;
	}
};

?>