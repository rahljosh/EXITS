<?php
$module_urls = array(
			"home" => BASE_URL . "&mod_id=" . MODULE_HOME,
			"kb_tree" => BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE,
			"my_account" => BASE_URL . "&mod_id=" . MODULE_MY_ACCOUNT,
			"open_ticket" => BASE_URL . "&mod_id=" . MODULE_OPEN_TICKET,
			"track_tickets" => BASE_URL . "&mod_id=" . MODULE_TRACK_TICKETS,
			"company_tickets" => BASE_URL . "&mod_id=" . MODULE_COMPANY_TICKETS
		);

?>
<table cellpadding="0" cellspacing="0" border="0" width='100%' id="box">
	<tr>
		<td class="boxtitle">Main Menu</td>
	</tr>
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_home.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><a href="<?php echo $module_urls["home"]; ?>" class="menuitem">Home</a><br>
		</td>
	</tr>
	
	<?php if($pubgui->settings["pub_mod_open_ticket"]) { ?>
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_open_ticket.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><a href="<?php echo $module_urls["open_ticket"]; ?>" class="menuitem">Open a Ticket</a><br>
		</td>
	</tr>
	<?php } ?>
	
	<?php if($pubgui->settings["pub_mod_track_tickets"]) { ?>
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_ticket_history.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><a href="<?php echo $module_urls["track_tickets"]; ?>" class="menuitem">My Ticket History</a><br>
		</td>
	</tr>
	<?php } ?>

	<!--- Company Ticket History --->
	<?php if($pubgui->settings["pub_mod_track_tickets"] && $cer_session->public_access_level == 5) { ?>
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_company_history.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><a href="<?php echo $module_urls["company_tickets"]; ?>" class="menuitem">Company Ticket History</a><br>
		</td>
	</tr>
	<?php } ?>
	
	<?php if($pubgui->settings["pub_mod_kb"]) { ?>
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_knowledgebase.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><a href="<?php echo $module_urls["kb_tree"]; ?>" class="menuitem">Browse Knowledgebase</a><br>
		</td>
	</tr>
	<?php } ?>
	
	<?php if($pubgui->settings["pub_mod_my_account"]) { ?>
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_my_account.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="4" height="1"><a href="<?php echo $module_urls["my_account"]; ?>" class="menuitem">My Account</a><br>
		</td>
	</tr>
	<?php } ?>
	
	<tr>
		<td class="box_menu_cell">
			<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="2" height="3">
		</td>
	</tr>
	
</table>
<br>
