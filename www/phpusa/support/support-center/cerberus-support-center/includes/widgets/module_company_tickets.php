<?php
require_once (FILESYSTEM_PATH . "cerberus-api/utility/datetime/cer_DateTime.class.php");
require_once (FILESYSTEM_PATH . "includes/local-api/mail/send_internal_mail.function.php");

$ticket = isset($_REQUEST["ticket"]) ? $_REQUEST["ticket"] : "";
$reply_from = isset($_REQUEST["reply_from"]) ? $_REQUEST["reply_from"] : "";
$reply_body = isset($_REQUEST["reply_body"]) ? $_REQUEST["reply_body"] : "";
$form_submit = isset($_REQUEST["form_submit"]) ? $_REQUEST["form_submit"] : "";
$view_type = isset($_REQUEST["view_type"]) ? $_REQUEST["view_type"] : "Open";

if(!empty($ticket)) {
	$sql = sprintf("SELECT t.ticket_id FROM ticket t WHERE t.ticket_mask = %s",
			$cerberus_db->escape($ticket)
		);
	$tres = $cerberus_db->query($sql);
	if(!$trow = $cerberus_db->grab_first_row($tres)) {
		$sql = sprintf("SELECT t.ticket_id FROM ticket t WHERE t.ticket_id = %d",
				$ticket
			);
		$tres2 = $cerberus_db->query($sql);
		if($trow2 = $cerberus_db->grab_first_row($tres2)) {
			$ticket_id = $trow2["ticket_id"];
		}
		else {
			die("Unrecoverable error on ticket lookup.");
		}
	}
	else {
		$ticket_id = $trow["ticket_id"];
	}
}
else {
	
	// [TAR]: Added to view Open vs Closed Tickets
		if($view_type == "Closed"){
			$track_ticket_type = "AND t.is_closed = 1 ";
			$ticket_display_label = "Company Closed Ticket History";
			$change_view_type = "Open";
		} else {
			$track_ticket_type = "AND t.is_closed = 0 AND t.is_deleted = 0 ";
			$ticket_display_label = "Company Open Tickets";
			$change_view_type = "Closed";
		}
	
}

function getPriorityString($pri) {
	$str = "";
	
	switch($pri) {
		case 0:
			$str = "unassigned";
			break;
		case 5:
			$str = "none";
			break;
		case 25:
			$str = "low";
			break;
		case 50:
			$str = "medium";
			break;
		case 75:
			$str = "high";
			break;
		case 90:
			$str = "critical";
			break;
		case 100:
			$str = "emergency";
			break;
	}
	
	return $str;
}

class cer_TrackTicket {
	var $ticket_mask = null;
	var $ticket_subject = null;
	var $is_closed = 0;
	var $is_deleted = 0;
	var $is_waiting_on_customer = 0;
	var $ticket_date = null;
	var $activity_date = null;
	var $requester_address_id = null;
	var $requester_address = null;
	var $queue_prefix = null;
	var $queue_address = null;
	var $last_reply_was_agent = 0;
}

if($cer_session->is_logged_in) {

	$user_handler = new cer_PublicUserHandler();
	$id = $cer_session->user_id;
	$user_handler->loadUsersByIds(array($id));
	
	$public_user = &$user_handler->users[$id];

	if(!empty($ticket_id)) {
		$addy_ids = array_keys($public_user->email_addresses);
		
		if(!$cer_session->user_company_id)
			return;
		
		// [JAS]: Pull up any tickets from the same company as this public user.
		$sql = sprintf("SELECT t.ticket_id, t.ticket_mask, t.ticket_subject, t.is_closed, t.is_deleted, t.is_waiting_on_customer, t.ticket_due, t.ticket_date, t.ticket_priority, t.ticket_time_worked, thr.is_agent_message, th.thread_date, a.address_address as requester_address, a.address_id as requester_address_id, q.queue_name, q.queue_prefix, q.queue_reply_to ".
				"FROM (ticket t, requestor r, thread thr, thread th, address a, queue q, public_gui_users pu) ".
				"WHERE t.ticket_id = r.ticket_id AND thr.thread_id = t.min_thread_id AND th.thread_id = t.max_thread_id AND a.address_id = r.address_id ".
				(!empty($track_ticket_type) ? $track_ticket_type : "") .
				"AND a.public_user_id = pu.public_user_id AND pu.company_id = %d ".
				"AND t.ticket_id = %d ".
				"ORDER BY th.thread_date DESC ",
					$cer_session->user_company_id,
					$ticket_id
			);
		$res = $cerberus_db->query($sql);
		
		$track_ticket = null;
		
		if($cerberus_db->num_rows($res)) {
			while($row = $cerberus_db->fetch_row($res)) {
				$track_ticket = new cer_TrackTicket();
					$track_ticket->ticket_mask = (($row["ticket_mask"]) ? $row["ticket_mask"] : $row["ticket_id"]);
					$track_ticket->ticket_subject = stripslashes($row["ticket_subject"]);
					$track_ticket->is_closed = $row["is_closed"];
					$track_ticket->is_deleted = $row["is_deleted"];
					$track_ticket->is_waiting_on_customer = $row["is_waiting_on_customer"];
					$track_ticket->ticket_priority = $row["ticket_priority"];
					$track_ticket->ticket_date = new cer_DateTime($row["ticket_date"]);
					$track_ticket->ticket_due = new cer_DateTime($row["ticket_due"]);
					$track_ticket->ticket_time_worked = $row["ticket_time_worked"];
					$track_ticket->requester_address_id = $row["requester_address_id"];
					$track_ticket->requester_address = $row["requester_address"];
					$track_ticket->queue_prefix = $row["queue_prefix"];
					$track_ticket->queue_address = $row["queue_reply_to"];
					$track_ticket->activity_date = new cer_DateTime($row["thread_date"]);
					$track_ticket->last_reply_was_agent = $row["is_agent_message"];
			}
		} else {
			die("Access denied.");
		}
	}
	
	if(!empty($form_submit)) {
		switch($form_submit) {
			case "add_reply": {
				
				if(empty($track_ticket) || empty($reply_body) || empty($reply_from)) {
					require ("company_tickets/box_track_ticket_view.php");
					break;
				}
				
					$from = @$public_user->email_addresses[$reply_from];
					if(empty($from)) die("Invalid FROM address.");
					
					$subject = sprintf("[%s #%s]: %s",
							$track_ticket->queue_prefix,
							$ticket,
							$track_ticket->ticket_subject
						);
					$content = stripslashes($reply_body);
					
					$headers = "From: $from\r\n".
						"Reply-to: $from\r\n".
						"Date: " . date("r");
					
					$body = $content . 
						"\r\n".
						"\r\n".
						"Client IP: " . $_SERVER['REMOTE_ADDR'] . "\r\n";
					
					// Added file attachment support    [JSJ]
					$attachments = array();
					if(is_array($_FILES)) {
						foreach($_FILES as $file) {
							$attachment = array();
							$attachment['file_name'] = $file['name'];
							$attachment['file_type'] = $file['type'];
							$attachment['data'] = @file_get_contents($file['tmp_name']);
							if(strlen($attachment['data']) > 0 && $file['name']) {
								$attachments[] = $attachment;
							}
						}
					}

				send_internal_mail($track_ticket->queue_address,$subject,$body,$from,$attachments);
				
				require ("track_tickets/box_reply_sent.php");
				break;
			}
		}
	}
	elseif(!empty($ticket)) {
		require ("company_tickets/box_track_ticket_view.php");
	}
	else {
		require ("company_tickets/box_track_open_tickets.php");
	}
}
else {
	require ("shared/box_not_logged_in.php");
}

?>
