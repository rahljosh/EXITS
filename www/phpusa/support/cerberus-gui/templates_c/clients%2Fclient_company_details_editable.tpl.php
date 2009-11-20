<?php /* Smarty version 2.5.0, created on 2007-01-24 15:47:39
         compiled from clients/client_company_details_editable.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'escape', 'clients/client_company_details_editable.tpl.php', 22, false),
array('modifier', 'short_escape', 'clients/client_company_details_editable.tpl.php', 130, false),
array('function', 'html_options', 'clients/client_company_details_editable.tpl.php', 70, false),
array('function', 'assign', 'clients/client_company_details_editable.tpl.php', 119, false),)); ?><form action="clients.php" method="post" name="clients_company" style="margin:0px;">
	<input type="hidden" name="form_submit" value="<?php if (! empty ( $this->_tpl_vars['id'] )): ?>company_edit<?php else: ?>company_add<?php endif; ?>">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
	<?php if (! empty ( $this->_tpl_vars['id'] )): ?>
		<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['id']; ?>
">
	<?php endif; ?>
<table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
	<?php if ($this->_tpl_vars['record_edit_pass_msg']): ?>
	<tr>
		<td bgcolor="#FFFFFF" colspan="2" class="cer_configuration_success"><?php echo $this->_tpl_vars['record_edit_pass_msg']; ?>
</td>
	</tr>
	<?php endif; ?>
	
	<tr>
		<td class="boxtitle_orange_glass" colspan="2"><?php echo @constant('LANG_CONTACTS_COMPANY_EDIT_HEADER'); ?>
</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_NAME'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_name" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_name, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_ACCOUNT_NUM'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_account_number" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_account_number, 'htmlall'); ?>
"><br>
			<?php if (empty ( $this->_tpl_vars['id'] )): ?>
				<input type="checkbox" name="company_account_number_auto" value="1" checked> 
				<span class="cer_maintable_text">Automatically Assign Account Number</span>
			<?php endif; ?>
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_STREET'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<textarea name="company_mailing_address" cols="45" rows="3" maxlength="128"><?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_mailing_address, 'htmlall'); ?>
</textarea><br>
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_CITY'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_mailing_city" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_mailing_city, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_STATE'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_mailing_state" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_mailing_state, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_ZIP'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_mailing_zip" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_mailing_zip, 'htmlall'); ?>
">
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COUNTRY'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<select name="company_mailing_country_id">
				<option value="0">
				<?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['country_list'],'selected' => $this->_tpl_vars['company']->company_mailing_country_id), $this) ; ?>

			</select>
			
			<?php if (! empty ( $this->_tpl_vars['company']->company_mailing_country_old )): ?>
			<br>
			<span class="cer_footer_text">
			Pre-MajorCRM value: <?php echo $this->_tpl_vars['company']->company_mailing_country_old; ?>

			</span>
			<?php endif; ?>
		</td>
	</tr>

	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_PHONE'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_phone" size="32" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_phone, 'htmlall'); ?>
">
		</td>
	</tr>
	
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_FAX'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_fax" size="32" maxlength="32" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_fax, 'htmlall'); ?>
">
		</td>
	</tr>
		
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_MAIL_SHORT'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_email" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_email, 'htmlall'); ?>
">
		</td>
	</tr>
		
	<tr>
		<td bgcolor="#DDDDDD" class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_WEBSITE'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<input type="text" name="company_website" size="45" maxlength="64" value="<?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['company']->company_website, 'htmlall'); ?>
">
		</td>
	</tr>
	
	
	<?php if ($this->_tpl_vars['company_entry_defaults']['custom_fields'] || $this->_tpl_vars['company']->custom_fields): ?>

	<tr>
		<td bgcolor="#EEEEEE" colspan="2">&nbsp;</td>
	</tr>
	
	<?php if (empty ( $this->_tpl_vars['id'] )): ?>
		<input type="hidden" name="company_custom_gid" value="<?php echo $this->_tpl_vars['company_entry_defaults']['custom_gid']; ?>
">
		<?php echo $this->_plugins['function']['assign'][0](array('var' => 'ptr','value' => $this->_tpl_vars['company_entry_defaults']['custom_fields']), $this) ; ?>

	<?php else: ?>
		<input type="hidden" name="company_custom_inst_id" value="<?php echo $this->_tpl_vars['company']->custom_fields->group_instance_id; ?>
">
		<?php echo $this->_plugins['function']['assign'][0](array('var' => 'ptr','value' => $this->_tpl_vars['company']->custom_fields), $this) ; ?>

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
                	<input type="text" name="company_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" size="45" value="<?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_value); ?>
" class="cer_custom_field_text">
                <?php endif; ?>

              	<?php if ($this->_tpl_vars['field']->field_type == 'E'): ?>
					<input type="text" name="company_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" maxlength="8" size="8" value="<?php echo $this->_tpl_vars['field']->field_value; ?>
">
		          	<span class="cer_footer_text">
						(enter <b><i>mm/dd/yy</i></b>)
		          	</span>
                <?php endif; ?>
                
              	<?php if ($this->_tpl_vars['field']->field_type == 'T'): ?>
                	<textarea cols="45" rows="3" name="company_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" wrap="virtual" class="cer_custom_field_text"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['field']->field_value); ?>
</textarea><br>
                	<span class="cer_footer_text">(maximum 255 characters)</span>
                <?php endif; ?>
                
              	<?php if ($this->_tpl_vars['field']->field_type == 'D'): ?>
                	<select name="company_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
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
</table>
</form>