<?php
require_once (FILESYSTEM_PATH . "cerberus-api/public-gui/cer_PublicGUISettings.class.php");
require_once (FILESYSTEM_PATH . "cerberus-api/utility/sort/cer_PointerSort.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/mail/send_internal_mail.function.php");

//print_r($pubgui->settings);

$t = isset($_REQUEST["t"]) ? $_REQUEST["t"] : "";
$nt_tid = isset($_REQUEST["nt_tid"]) ? $_REQUEST["nt_tid"] : "";
$nt_from = isset($_REQUEST["nt_from"]) ? $_REQUEST["nt_from"] : "";
$nt_subject = isset($_REQUEST["nt_subject"]) ? $_REQUEST["nt_subject"] : "";
$nt_content = isset($_REQUEST["nt_content"]) ? $_REQUEST["nt_content"] : "";
$field_ids = isset($_REQUEST["field_ids"]) ? $_REQUEST["field_ids"] : "";

// [JAS]: Are we requiring a login to make tickets?
if($pubgui->settings["pub_mod_open_ticket_locked"] && !$cer_session->is_logged_in) {
	require_once ("shared/box_not_logged_in.php");
}
else { // guess not

	// [JAS]: Check to see if we have only one queue in our profile.
	//		If so, automatically select it for the user.
	if(count($pubgui->mailboxes) == 1) {
		$keys = array_keys($pubgui->mailboxes);
		$t = $keys[0];
	}
	
	if(!empty($nt_tid)) { // Sending a ticket email
		include (FILESYSTEM_PATH . "includes/local-api/mail/open_ticket.include.php");
		require_once ("tickets/box_new_ticket_confirmation.php");
	}
	elseif(empty($t)) { // choosing a destination queue
		require_once ("tickets/box_choose_queue.php");
	}
	else { // Filling in the ticket fields
		require_once ("tickets/box_new_ticket.php");
	}
	
}

?>