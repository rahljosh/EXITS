<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Reply Sent!</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="0" border="0" class="white_back" width="100%">
				<tr>
					<td colspan="3" class="box_content_text">
						Your reply has been sent!  It may take a few minutes to show up in the ticket history.<br>
						<br>
						<?php
							$ticket_url = sprintf("%s&mod_id=%d&view_type=%s&ticket=%s",
								BASE_URL,
								MODULE_TRACK_TICKETS,
								$view_type,
								$ticket
							);
						?>
						<a href="<?php echo $ticket_url; ?>" class='url'>Return to Ticket #<?php echo $ticket; ?></a>
					</td>
				</tr>
			</table>		
		
		</td>
	</tr>
	
</table>
