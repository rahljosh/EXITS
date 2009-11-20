<?php
require_once (FILESYSTEM_PATH . "cerberus-api/utility/sort/cer_PointerSort.class.php");

//$sorted_teams = array();
//
//if(!empty($pubgui->teams))
//	$sorted_teams = cer_PointerSort::pointerSortCollection($pubgui->teams,"team_mask");\
	
$mailboxes = $pubgui->mailboxes;
?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Open a Ticket</span></td>
	</tr>

	<tr>
		<td class="white_back">
		
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back"><span class="black_heading">Choose Destination:</span></td>
				</tr>
				
				<?php
					foreach($mailboxes as $mbox) {
					?>
						<tr>
							<td class="white_back"><img src="includes/images/spacer.gif" width="5" height="1">- <a href="<?php echo BASE_URL . sprintf("&mod_id=%d&t=%d",MODULE_OPEN_TICKET,$mbox['id']); ?>" class='url'><?php echo $mbox['mailbox_alias']; ?></a></td>
						</tr>
					<?php
					}
				?>
				
			</table>
		
		</td>
	</tr>
	
	
</table>


<br>
