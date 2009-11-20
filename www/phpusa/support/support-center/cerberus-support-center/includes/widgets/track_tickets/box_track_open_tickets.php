<?php

if(!empty($public_user->email_addresses)) {
	$addy_ids = array_keys($public_user->email_addresses);
} else {
	$addy_ids = array(0);
}

$sql = sprintf("SELECT t.ticket_id, t.ticket_mask, t.ticket_subject, t.is_closed, t.is_deleted, t.is_waiting_on_customer, t.ticket_date, t.ticket_due, t.ticket_priority, t.ticket_time_worked, th.is_agent_message, th.thread_date ".
		"FROM (ticket t, requestor r, thread thr, thread th) ".
		"WHERE t.ticket_id = r.ticket_id AND thr.thread_id = t.min_thread_id AND th.thread_id = t.max_thread_id ".
		$track_ticket_type .
		"AND r.address_id IN (%s) ".
		"ORDER BY th.thread_date DESC ",
			implode(",",$addy_ids)
	);
$res = $cerberus_db->query($sql);

$track_tickets = array();
if($cerberus_db->num_rows($res)) {
	while($row = $cerberus_db->fetch_row($res)) {
		$ticket = new cer_TrackTicket();
			$ticket->ticket_mask = (($row["ticket_mask"]) ? $row["ticket_mask"] : $row["ticket_id"]);
			$ticket->ticket_subject = stripslashes($row["ticket_subject"]);
			$ticket->is_closed = $row["is_closed"];
			$ticket->is_deleted = $row["is_deleted"];
			$ticket->is_waiting_on_customer = $row["is_waiting_on_customer"];
			$ticket->ticket_priority = $row["ticket_priority"];
			$ticket->ticket_time_worked = $row["ticket_time_worked"];
			$ticket->ticket_date = new cer_DateTime($row["ticket_date"]);
			$ticket->ticket_due = new cer_DateTime($row["ticket_due"]);
			$ticket->activity_date = new cer_DateTime($row["thread_date"]);
			$ticket->last_reply_was_agent = $row["is_agent_message"];
		$track_tickets[] = $ticket;
	}
}


$view_ticket_url = sprintf("%s&mod_id=%d&view_type=%s",
							BASE_URL,
							MODULE_TRACK_TICKETS,
							$change_view_type
						);

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading"><?php echo $ticket_display_label; ?></span></td>
		<td class="table_header_cell" align="center" width="150"><a href="<?php echo $view_ticket_url; ?>" class="ticket_link">View <?php echo $change_view_type; ?> Tickets</a></td>
	</tr>
	
	<tr>
		<td class="white_back" colspan="2">
		
			<table cellpadding="2" cellspacing="0" border="0" class="white_back" width="100%">
			
				<tr>
					<td colspan="4" class="box_content_text">
						The following is a list of tickets you are currently a requester on.  Click on a ticket
						ID or subject for a detailed ticket history. <B>NOTE:</B> It may take a few minutes 
						for a new ticket to appear in the list.<br>
						<br>
					</td>
				</tr>
			
				<tr class="table_header_cell">
					<td class="box_content_text" nowrap>&nbsp;</td>
					<td class="box_content_text" nowrap><B>Ticket</B></td>
					<td class="box_content_text" nowrap><B>Status</B></td>
					<td class="box_content_text" nowrap><B>Updated</B></td>
				</tr>
			
			<?php
				$row = 0;
			
				if(count($track_tickets))
				foreach($track_tickets as $t) {
					if($row % 2) {
						$bg = "#FFFFFF"; }
					else {
						$bg = "#F5F5F5"; }
					
					$ticket_url = sprintf("%s&mod_id=%d&view_type=%s&ticket=%s",
							BASE_URL,
							MODULE_TRACK_TICKETS,
							$view_type,
							$t->ticket_mask
						);
			?>	
				
				<tr bgcolor="<?php echo $bg; ?>">
					<td valign="top" align="center" nowrap rowspan="2" width="1%" nowrap>
					<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="5" height="1" border="0" align="absmiddle">
					<?php if(($t->is_closed == 1 || $t->is_deleted == 1)) { ?>
						<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_ticket.gif" border="0" align="absmiddle">
					<?php } else { ?>
						<?php if($t->last_reply_was_agent) { ?>						
							<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_important.gif" border="0">
						<?php } else { ?>
							<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_ticket.gif" border="0" align="absmiddle">
						<?php } ?>
					<?php } ?>
					<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="5" height="1" border="0" align="absmiddle">
					</td>
					<td valign="top" class="box_content_text" colspan="4">
						<a href="<?php echo $ticket_url; ?>" class="ticket_link"><?php echo htmlentities($t->ticket_subject); ?></a><br>
					</td>
				</tr>
				<tr bgcolor="<?php echo $bg; ?>">
					<td valign="top" class="box_content_text" nowrap>
						<?php echo $t->ticket_mask; ?>
					</td>
					<td valign="top" class="<?php if($t->last_reply_was_agent) { ?>agent_reply<?php } else { ?>box_content_text<?php } ?>" nowrap>
						<?php 
						if($t->is_deleted) {
							echo "deleted/merged";
						} elseif($t->is_closed) {
							echo "closed";
						} else {
							echo "open";
						}
						?>
					</td>
					<td valign="top" class="box_content_text" nowrap>
						<?php echo $t->activity_date->getDate("%d-%b-%y %I:%M%p"); ?>					
					</td>
					
						<?php /*
						Priority: <?php echo getPriorityString($t->ticket_priority); ?><br>
						<?php if(!empty($t->ticket_time_worked)) { echo "Time Worked: " . $t->ticket_time_worked . " mins<br>"; } ?>
						Opened: <?php echo $t->ticket_date->getDate("%a %b %d %Y %I:%M%p"); ?><br>
						Due: <?php echo $t->ticket_due->getDate("%a %b %d %Y %I:%M%p"); ?><br>
						*/ ?>
				</tr>
			
			<?php
					$row++;
				}
			?>
				
			</table>
		
		</td>
	</tr>
	
</table>


