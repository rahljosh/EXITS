<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:46
         compiled from clients/client_publicuser_assign_address.tpl.php */ ?>
<table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000" width="100%">
	<form action="clients.php">
	<input type="hidden" name="form_submit" value="user_add_address">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
	<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['user']->public_user_id; ?>
">

	<tr>
		<td class="boxtitle_gray_glass">
			<?php echo @constant('LANG_CONTACTS_REGISTRED_MAILASSIGN_HEADER'); ?>

		</td>
	</tr>

	<?php if (! empty ( $this->_tpl_vars['user_email_pass_msg'] )): ?>
	<tr bgcolor="#EEEEEE">
		<td class="cer_configuration_success"><?php echo $this->_tpl_vars['user_email_pass_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<?php if (! empty ( $this->_tpl_vars['user_email_fail_msg'] )): ?>
	<tr bgcolor="#EEEEEE">
		<td class="cer_configuration_updated"><?php echo $this->_tpl_vars['user_email_fail_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<tr bgcolor="#EEEEEE">
		<td>
			<span class="cer_maintable_text">
			<?php echo @constant('LANG_CONTACTS_REGISTRED_MAILASSIGN_INSTRUCTIONS'); ?>

			</span>
			<input type="text" name="user_add_address" value="" size="20" maxlength="64">
			<input type="submit" value="<?php echo @constant('LANG_CONTACTS_REGISTRED_MAILASSIGN_SUBMIT'); ?>
" class="cer_button_face"><br>
		</td>
	</tr>
	
	</form>
		
</table>		