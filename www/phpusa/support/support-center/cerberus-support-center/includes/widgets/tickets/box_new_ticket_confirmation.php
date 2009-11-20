<?php

if(!$pubgui->mailboxes[$t]) {
	echo "ERROR: Invalid destination.";
	exit;
}

@$team_name = $pubgui->mailboxes[$t]['mailbox_alias'];

?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Confirmation of New Ticket Creation</span></td>
	</tr>

	
	<tr class="white_back">
		<td class="box_content_text">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
			
				<tr>
					<td valign="top" class="box_content_text"><B>IP:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo $_SERVER['REMOTE_ADDR']; ?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>To:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo $team_name; ?></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>From:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo stripslashes($nt_from); ?></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Subject:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo stripslashes($nt_subject); ?></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>Timestamp:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo date("r"); ?></td>
				</tr>
				
			</table>
			
			<br>
			
			Your new ticket has been sent successfully.  Thanks for contacting us!<br>
			
			<br>
			
		</td>
	</tr>	
	
</table>


<br>
