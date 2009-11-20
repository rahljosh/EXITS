<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:45
         compiled from clients/client_publicuser_details_editable.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'escape', 'clients/client_publicuser_details_editable.tpl.php', 28, false),
array('modifier', 'short_escape', 'clients/client_publicuser_details_editable.tpl.php', 164, false),
array('function', 'assign', 'clients/client_publicuser_details_editable.tpl.php', 153, false),
array('function', 'html_options', 'clients/client_publicuser_details_editable.tpl.php', 182, false),)); ?><table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
	<form action="clients.php" method="post" name="clients_contact">
	<input type="hidden" name="form_submit" value="<?php if (! empty ( $this->_tpl_vars['id'] )): ?>user_edit<?php else: ?>user_add<?php endif; ?>">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
	<?php if (! empty ( $this->_tpl_vars['params']['add_to'] )): ?> <input type="hidden" name="add_to" value="<?php echo $this->_tpl_vars['params']['add_to']; ?>
"> <?php endif; ?>
	<?php if (! empty ( $this->_tpl_vars['id'] )): ?> <input type="hidden" name="id" value="<?php echo $this->_tpl_vars['id']; ?>
"> <?php endif; ?>
	
	<?php if ($this->_tpl_vars['user_add_error_msg']): ?>
	<tr>
		<td bgcolor="#FFFFFF" colspan="2" class="cer_configuration_updated"><?php echo $this->_tpl_vars['user_add_error_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['record_edit_pass_msg']): ?>
	<tr>
		<td bgcolor="#FFFFFF" colspan="2" class="cer_configuration_success"><?php echo $this->_tpl_vars['record_edit_pass_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<tr>
		<td class="boxtitle_blue_glass" colspan="2"><?php echo @constant('LANG_CONTACTS_CONTACT_EDIT_HEADER'); ?>
</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM">First Name:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_name_first" size="16" maxlength="16" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_name_first, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM">Last Name:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_name_last" size="32" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_name_last, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM">Self-Help Access:</td>
		<td bgcolor="#EEEEEE">
			<select name="account_access_level">
				<option value="0" <?php if ($this->_tpl_vars['user']->account_access_level == 0): ?>selected<?php endif; ?>>Contact (can only view own ticket history)
				<option value="5" <?php if ($this->_tpl_vars['user']->account_access_level == 5): ?>selected<?php endif; ?>>Manager (can view entire company's ticket history)
			</select>
		</td>
	</tr>
	
	
	<?php if (empty ( $this->_tpl_vars['id'] )): ?>
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM">E-mail Address:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_email_address" size="45" maxlength="64" value="<?php echo $this->_tpl_vars['params']['add_email']; ?>
">
		</td>
	</tr>
	<?php endif; ?>
	
	<?php if (! empty ( $this->_tpl_vars['params']['add_to'] ) && ! empty ( $this->_tpl_vars['company'] )): ?>
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM">Company:</td>
		<td bgcolor="#EEEEEE" class="cer_maintable_text">
			<input type="checkbox" name="account_company_id" value="<?php echo $this->_tpl_vars['params']['add_to']; ?>
" checked> 
			Assign to: <?php echo $this->_tpl_vars['company']->company_name; ?>

		</td>
	</tr>
	<?php endif; ?>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_STREET'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<TEXTAREA name="account_mailing_address" cols="45" rows="3" maxlength="128"><?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_address, 'htmlall'); ?>
</TEXTAREA><br>
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_CITY'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_mailing_city" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_city, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_STATE'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_mailing_state" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_state, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_ZIP'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_mailing_zip" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_zip, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COUNTRY'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_mailing_country" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_country, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_PHONE_WORK'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_phone_work" size="45" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_phone_work, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_PHONE_HOME'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_phone_home" size="45" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_phone_home, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_PHONE_MOBILE'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_phone_mobile" size="45" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_phone_mobile, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_FAX'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_phone_fax" size="45" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['user']->account_phone_fax, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#EEEEEE" colspan="2">&nbsp;</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php if (! empty ( $this->_tpl_vars['id'] )): ?><?php echo @constant('LANG_CONTACTS_REGISTRED_RESET_PW'); ?>
<?php else: ?><?php echo @constant('LANG_CONTACTS_REGISTRED_SET_PW'); ?>
<?php endif; ?>:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="account_password" size="35" maxlength="32" value="">
			<?php if (! empty ( $this->_tpl_vars['id'] )): ?><br><span class="cer_footer_text"><?php echo @constant('LANG_CONTACTS_REGISTRED_PW_NOTE'); ?>
</span><?php endif; ?>
		</td>
	</tr>
	
	
	<?php if ($this->_tpl_vars['contact_entry_defaults']['custom_fields'] || $this->_tpl_vars['user']->custom_fields): ?>

	<tr>
		<td bgcolor="#EEEEEE" colspan="2">&nbsp;</td>
	</tr>
	
	<?php if (empty ( $this->_tpl_vars['id'] )): ?>
		<input type="hidden" name="contact_custom_gid" value="<?php echo $this->_tpl_vars['contact_entry_defaults']['custom_gid']; ?>
">
		<?php echo $this->_plugins['function']['assign'][0](array('var' => 'ptr','value' => $this->_tpl_vars['contact_entry_defaults']['custom_fields']), $this) ; ?>

	<?php else: ?>
		<input type="hidden" name="contact_custom_inst_id" value="<?php echo $this->_tpl_vars['user']->custom_fields->group_instance_id; ?>
">
		<?php echo $this->_plugins['function']['assign'][0](array('var' => 'ptr','value' => $this->_tpl_vars['user']->custom_fields), $this) ; ?>

	<?php endif; ?>
	
	<?php if (isset($this->_foreach['custom'])) unset($this->_foreach['custom']);
$this->_foreach['custom']['name'] = 'custom';
$this->_foreach['custom']['total'] = count((array)$this->_tpl_vars['ptr']->fields);
$this->_foreach['custom']['show'] = $this->_foreach['custom']['total'] > 0;
if ($this->_foreach['custom']['show']):
$this->_foreach['custom']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['ptr']->fields as $this->_tpl_vars['field']):
        $this->_foreach['custom']['iteration']++;
        $this->_foreach['custom']['first'] = ($this->_foreach['custom']['iteration'] == 1);
        $this->_foreach['custom']['last']  = ($this->_foreach['custom']['iteration'] == $this->_foreach['custom']['total']);
?>
		<tr>
			<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo $this->_tpl_vars['field']->field_name; ?>
:</td>
			<td bgcolor="#EEEEEE" class="cer_maintable_text">
              	<?php if ($this->_tpl_vars['field']->field_type == 'S'): ?>
                	<input type="text" name="contact_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" size="45" value="<?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_value); ?>
" class="cer_custom_field_text">
                <?php endif; ?>
                
              	<?php if ($this->_tpl_vars['field']->field_type == 'E'): ?>
					<input type="text" name="contact_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" maxlength="8" size="8" value="<?php echo $this->_tpl_vars['field']->field_value; ?>
">
		          	<span class="cer_footer_text">
						(enter <b><i>mm/dd/yy</i></b>)
		          	</span>
                <?php endif; ?>

              	<?php if ($this->_tpl_vars['field']->field_type == 'T'): ?>
                	<textarea cols="45" rows="3" name="contact_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" wrap="virtual" class="cer_custom_field_text"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_value); ?>
</textarea><br>
                	<span class="cer_footer_text">(maximum 255 characters)</span>
                <?php endif; ?>
                
              	<?php if ($this->_tpl_vars['field']->field_type == 'D'): ?>
                	<select name="contact_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" class="cer_custom_field_text">
                      <option value="">
                      <?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['field']->field_options,'selected' => $this->_tpl_vars['field']->field_value), $this) ; ?>

                    </select>
                <?php endif; ?>
			</td>
		</tr>
	<?php endforeach; endif; ?>
	
	<?php endif; ?>
	
	<tr>
		<td bgcolor="#EEEEEE" class="cer_maintable_headingSM" colspan="2" align="right">
			<input type="submit" value="<?php echo @constant('LANG_WORD_SAVE_CHANGES'); ?>
" class="cer_button_face">
		</td>
	</tr>
	
	</form>
</table>

<br>