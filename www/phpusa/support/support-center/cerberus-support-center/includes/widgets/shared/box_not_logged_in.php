<table cellpadding="2" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr class="white_back">
		<td class="box_content_text">
				<span class="black_heading">Currently Not Logged In</span><br>
				A feature on this page may require that you log in to the Support Center.
				To log in, please enter your login details in the box to the left.<br>
				<?php if(!$pubgui->settings["login_plugin_id"] && $pubgui->settings["pub_mod_registration"]) { ?>
				<br>
				If you do not have a support account, <a href="<?php echo BASE_URL . "&mod_id=" . MODULE_REGISTER; ?>" class='url'>Register a New Account</a>.
				<?php } ?>
		</td>
	</tr>
</table>

<br>
