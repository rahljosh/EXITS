<?php /* Smarty version 2.5.0, created on 2007-01-24 15:48:31
         compiled from clients/client_company_assign_contact.tpl.php */ ?>
<form action="clients.php" style="margin:0px;">
<table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000" width="100%">
	<tr>
		<td class="boxtitle_gray_glass">
			<input type="hidden" name="form_submit" value="company_add_contact">
			<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
			<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
			<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['company']->company_id; ?>
">
			<?php echo @constant('LANG_CONTACTS_COMPANY_ASIGNCONTACT_HEADER'); ?>

		</td>
	</tr>

	<?php if (! empty ( $this->_tpl_vars['add_contact_pass_msg'] )): ?>
	<tr bgcolor="#EEEEEE">
		<td class="cer_configuration_success"><?php echo $this->_tpl_vars['add_contact_pass_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<?php if (! empty ( $this->_tpl_vars['add_contact_fail_msg'] )): ?>
	<tr bgcolor="#EEEEEE">
		<td class="cer_configuration_updated"><?php echo $this->_tpl_vars['add_contact_fail_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<tr bgcolor="#EEEEEE">
		<td>
			<span class="cer_maintable_text">
			<?php echo @constant('LANG_CONTACTS_COMPANY_ASIGNCONTACT_INSTRUCTIONS'); ?>

			</span>
			<input type="text" name="company_add_contact" value="" size="20" maxlength="64">
			<input type="submit" value="<?php echo @constant('LANG_CONTACTS_COMPANY_ASIGNCONTACT_SUBMIT'); ?>
" class="cer_button_face"><br>
		</td>
	</tr>
</table>
</form>