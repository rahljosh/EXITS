<?php

require_once (FILESYSTEM_PATH . "cerberus-api/ticket/cer_ThreadContent.class.php");

$tickets_url = sprintf("%s&mod_id=%d&view_type=%s",
							BASE_URL,
							MODULE_COMPANY_TICKETS,
							$view_type
						);

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Company Ticket Details</span></td>
		<td class="table_header_cell" align="center" width="150"><a href="<?php echo $tickets_url; ?>" class="url">Back to <?php echo $view_type; ?> Company Tickets</a></td>
	</tr>
	
	<tr>
		<td bgcolor="#F8F8F8" colspan="2">

			<table cellpadding="2" cellspacing="0" border="0" bgcolor="#F8F8F8">
				<tr>
					<td colspan="3"><span class="ticket_subject_text"><?php echo htmlentities($track_ticket->ticket_subject); ?></span></td>
				</tr>
			
				<tr>
					<td colspan="3"><img src="includes/images/spacer.gif" height="5" width="1"></span></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>ID:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php echo $track_ticket->ticket_mask; ?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Status:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php 
						if($track_ticket->is_deleted) {
							echo "deleted/merged";
						} elseif($track_ticket->is_closed) {
							echo "closed";
						} else {
							echo "open";
						}
					?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Priority:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php echo getPriorityString($track_ticket->ticket_priority); ?></td>
				</tr>
				
				<?php if(!empty($track_ticket->ticket_time_worked)) { ?>
				<tr>
					<td valign="top" class="box_content_text"><B>Time Worked:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php echo $track_ticket->ticket_time_worked; ?> mins</td>
				</tr>
				<?php } ?>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Opened:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php echo $track_ticket->ticket_date->getDate("%d-%b-%y %I:%M%p"); ?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Last Msg:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php echo $track_ticket->activity_date->getDate("%d-%b-%y %I:%M%p"); ?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Due:</B></td>
					<td><img src="includes/images/spacer.gif" width="5" height="1"></td>
					<td class="box_content_text"><?php echo $track_ticket->ticket_due->getDate("%d-%b-%y %I:%M%p"); ?></td>
				</tr>
				
			</table>
			
		</td>
	</tr>
</table>

<br>

<?php
$thread_handler = new cer_ThreadContentHandler();
$thread_handler->loadTicketContentDB($ticket_id);

$sql = sprintf("SELECT th.thread_id, th.thread_date, th.thread_subject, th.thread_cc, th.is_agent_message, a.address_address ".
			"FROM (ticket t, thread th, address a) ".
			"WHERE th.ticket_id = t.ticket_id AND th.ticket_id = %d AND a.address_id = th.thread_address_id ".
			"AND th.thread_type = 'email' ".
			"ORDER BY th.thread_id ASC ",
				$ticket_id
		);
$res = $cerberus_db->query($sql);

if($cerberus_db->num_rows($res)) {
	while($row = $cerberus_db->fetch_row($res)) {	
		if($row["is_agent_message"]) {
			$address = $track_ticket->queue_address;
			$body = "#F8F8F8";
		}
		else {
			$address = $row["address_address"];
			$body = "#FFFFFF";
		}

                // Check for file attachments (don't show message_source.xml)  [JSJ]
		$has_attachments = FALSE;
                $file_attachments = array();
                $sql = sprintf("SELECT file_id, file_name, file_size FROM `thread_attachments` WHERE thread_id = '%d' AND " .
					"file_name != 'message_source.xml'", $row["thread_id"]);
		$attach_res = $cerberus_db->query($sql);
		if($cerberus_db->num_rows($attach_res)) {
			$has_attachments = TRUE;
			while($attach_row = $cerberus_db->fetch_row($attach_res)) {
				$file_attachments[] = $attach_row;
			}
		}	

		$date = new cer_DateTime($row["thread_date"]);
?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading"><?php echo $date->getDate("%a %b %d %Y %I:%M%p"); ?> by <?php echo $address; ?></span></td>
	</tr>
	
	<?php
	$content = $thread_handler->threads[$row["thread_id"]]->content;
	$content = str_replace(array(">","<"),array("&gt;","&lt;"),$content);
	?>
	<tr>
		<td bgcolor="<?php echo $body; ?>">
			<span class="ticket_body_text"><?php echo nl2br($content); ?></span><br>
		</td>
	</tr>

        <?php

	// Show file attachments if there is any [JSJ]
        if($has_attachments == TRUE) {
        ?>
		<tr>
			<td bgcolor='#ECECEC' class="box_content_text"><span class="black_heading">Attachment(s):
        <?php
		foreach($file_attachments AS $attachment) {
			$file_size = sprintf("%d",$attachment["file_size"]/1024);
			if($file_size == 0) $file_size = "&lt;1";
			if($file_size >= 1024) { $file_size = sprintf("%0.2f",$file_size/1024); $in_MB = true; } else { $in_MB = FALSE; } // turn to MB
			$display_size = sprintf("%s%s",(is_numeric($file_size)?sprintf("%0.1f",$file_size):$file_size), (($in_MB)?"MB":"KB"));
			printf("<a href='%s/attachment_send.php?file_id=%d&thread_id=%d' class='url'>%s (%s)</a>&nbsp;&nbsp;", DIRECTORY_NAME,
				$attachment["file_id"], $row["thread_id"], $attachment["file_name"], $display_size);
		}
        ?>
		</tr>
        <?php 
        }
        ?>
        

</table>

<br>

<?php
	}
}

// Added file attachment support. [JSJ] 

// If you want additional upload fields just duplicate the input fields below
// The code will automatically add as many files as are uploaded.

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<form enctype="multipart/form-data" action="" method="post">
	<input type="hidden" name="form_submit" value="add_reply">
	<input type="hidden" name="ticket" value="<?php echo $track_ticket->ticket_mask; ?>">
	<input type="hidden" name="reply_from" value="<?php echo $track_ticket->requester_address_id; ?>">
	<tr>
		<td class="table_header_cell"><span class="black_heading">Reply to Ticket</span></td>
	</tr>
	<tr bgcolor="#FAFAFA">
		<td class="box_content_text">
			<B>From:</B> <?php echo $track_ticket->requester_address; ?><br>
			<B>IP:</B> <?php echo $_SERVER['REMOTE_ADDR']; ?><br>
			<br>
			<textarea rows="15" cols="70" name="reply_body"></textarea><br>
			<br>
			File attachment #1:&nbsp;<input name="file1" type="file" /><br />
			File attachment #2:&nbsp;<input name="file2" type="file" /><br />			
			<B>NOTE:</B> New ticket replies may take a few minutes to appear in the ticket history.
		</td>
	</tr>
</table>

<table cellpadding="0" cellspacing="0" border="0" class="white_back" width='100%'>
	<tr><td><img src="images/spacer.gif" height="4" width="1"></td></tr>
	<tr>
		<td class="white_back" align="right"><input type="submit" class="button_style" value="Send Reply"></td>
	</tr>
</table>

</form>

