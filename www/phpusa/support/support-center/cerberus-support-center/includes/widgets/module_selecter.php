<?php
$mod_id = isset($_REQUEST["mod_id"]) ? $_REQUEST["mod_id"] : "";

switch($mod_id)
{
	case MODULE_KNOWLEDGEBASE: {
		if($pubgui->settings["pub_mod_kb"]) {
			require_once ("module_knowledgebase.php");
		}
		break;
	}
	
	case MODULE_OPEN_TICKET: {
		if($pubgui->settings["pub_mod_open_ticket"]) {
			require_once ("module_open_ticket.php");
		}
		break;
	}
	
	case MODULE_TRACK_TICKETS: {
		if($pubgui->settings["pub_mod_track_tickets"]) {
			require_once ("module_track_tickets.php");
		}
		break;
	}
	
	case MODULE_COMPANY_TICKETS: {
		if($pubgui->settings["pub_mod_track_tickets"]) {
			require_once ("module_company_tickets.php");
		}
		break;
	}
	
	case MODULE_MY_ACCOUNT: {
		if($pubgui->settings["pub_mod_my_account"]) {
			require_once ("module_my_account.php");
		}
		break;
	}
	
	case MODULE_ADD_EMAIL: {
			require_once ("module_add_email.php");
		break;
	}
	
	case MODULE_REGISTER: {
		if($pubgui->settings["login_plugin_id"] || $pubgui->settings["pub_mod_registration"]) {
			require_once ("module_register.php");
		}
		break;
	}
	
	case MODULE_FORGOT_PW: {
		//if($pubgui->settings["pub_mod_kb"]) {
			require_once ("module_forgot_pw.php");
//		}
		break;
	}
	
	default: {
		require_once ("module_home.php");
		break;
	}
}

?>