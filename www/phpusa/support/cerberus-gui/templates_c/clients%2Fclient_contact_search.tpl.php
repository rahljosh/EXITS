<?php /* Smarty version 2.5.0, created on 2007-01-24 15:47:23
         compiled from clients/client_contact_search.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'escape', 'clients/client_contact_search.tpl.php', 11, false),)); ?>
<form action="clients.php" style="margin:0px;">
	<input type="hidden" name="mode" value="search">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<table border="0" cellspacing="1" cellpadding="3" bgcolor="#888888" width="100%">
		<tr>
			<td class="boxtitle_gray_glass"><?php echo @constant('LANG_CONTACTS_SEARCH_CAPTION'); ?>
</td>
		</tr>
		<tr>
			<td align="left" bgcolor="#EEEEEE">
			<input type="text" name="contact_search" size="40" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['params']['contact_search'], 'htmlall'); ?>
">
			<input type="submit" value="<?php echo @constant('LANG_WORD_SEARCH'); ?>
" class="cer_button_face"><br>
			<span class="cer_footer_text"><?php echo @constant('LANG_CONTACTS_SEARCH_INSTRUCTIONS'); ?>
</span>
			</td>
		</tr>
	</table>
</form>
	<br>