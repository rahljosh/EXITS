<?php /* Smarty version 2.5.0, created on 2007-01-24 15:47:23
         compiled from clients/client_publicuser_list.tpl.php */ ?>

	<a name="users"></a>
	
	<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
	<span class="cer_maintable_text">
		[ <a href="<?php echo $this->_tpl_vars['urls']['contact_add']; ?>
" class="cer_maintable_heading"><?php echo @constant('LANG_CONTACTS_ADD_REGISTRED'); ?>
</a> ] 
	</span>
	<br>
	<?php endif; ?>
	
	<table border="0" cellspacing="1" cellpadding="3" bgcolor="#888888" width="100%">
		<?php if ($this->_tpl_vars['showcontrols'] && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
			<form action="clients.php">
			<input type="hidden" name="form_submit" value="company_update">
			<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
			<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
			<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['params']['id']; ?>
">
		<?php endif; ?>

		<tr>
			<td class="boxtitle_blue_glass" colspan="<?php if ($this->_tpl_vars['showcontrols']): ?>6<?php else: ?>5<?php endif; ?>"><?php echo $this->_tpl_vars['user_handler']->set_title; ?>
</td>
		</tr>
	
		<tr bgcolor="#CCCCCC">
		<?php if ($this->_tpl_vars['showcontrols'] && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?><td class="cer_maintable_headingSM" align="center"><?php echo @constant('LANG_WORD_SELECT'); ?>
</td><?php endif; ?>
			<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_MAIL'); ?>
</td>
			<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_CONTACT_NAME'); ?>
</td>
			<td class="cer_maintable_headingSM"><?php echo @constant('LANG_WORD_COMPANY'); ?>
</td>
			<td class="cer_maintable_headingSM">Self-Help Access</td>
			<td class="cer_maintable_headingSM" align="center"><?php echo @constant('LANG_CONTACTS_REGISTRED_NUMBER'); ?>
</td>
		</tr>
	
		<?php if (isset($this->_foreach['user'])) unset($this->_foreach['user']);
$this->_foreach['user']['name'] = 'user';
$this->_foreach['user']['total'] = count((array)$this->_tpl_vars['user_handler']->users_by_email);
$this->_foreach['user']['show'] = $this->_foreach['user']['total'] > 0;
if ($this->_foreach['user']['show']):
$this->_foreach['user']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['user_handler']->users_by_email as $this->_tpl_vars['email'] => $this->_tpl_vars['user']):
        $this->_foreach['user']['iteration']++;
        $this->_foreach['user']['first'] = ($this->_foreach['user']['iteration'] == 1);
        $this->_foreach['user']['last']  = ($this->_foreach['user']['iteration'] == $this->_foreach['user']['total']);
?>
	
			<tr bgcolor="#<?php if ($this->_foreach['user']['iteration'] % 2 == 0): ?>EEEEEE<?php else: ?>F5F5F5<?php endif; ?>">
				<?php if ($this->_tpl_vars['showcontrols'] && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?><td class="cer_maintable_text" align="center"><input type="checkbox" name="puids[]" value="<?php echo $this->_tpl_vars['user']->public_user_id; ?>
"></td><?php endif; ?>
				<td class="cer_maintable_text"><a href="<?php echo $this->_tpl_vars['user']->url_view; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['email']; ?>
</a></td>
				<td class="cer_maintable_text">
					<?php echo $this->_tpl_vars['user']->account_name_first; ?>
 <?php echo $this->_tpl_vars['user']->account_name_last; ?>
					
				</td>
				<td class="cer_maintable_text"><a href="<?php echo $this->_tpl_vars['user']->company_ptr->url_view; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['user']->company_ptr->company_name; ?>
</a></td>
				<td class="cer_maintable_text"><?php if ($this->_tpl_vars['user']->account_access_level == 0): ?>Contact<?php elseif ($this->_tpl_vars['user']->account_access_level == 5): ?>Manager<?php endif; ?></td>
				<td class="cer_maintable_text" align="center"><?php echo $this->_tpl_vars['user']->total_addresses; ?>
</td>
			</tr>
	
		<?php endforeach; endif; ?>
	
		<?php if ($this->_tpl_vars['showcontrols'] && ! empty ( $this->_tpl_vars['user_handler']->users_by_email ) && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
		
			<tr>
				<td colspan="6" bgcolor="#BBBBBB" align="right">
					<span class="cer_maintable_header"><?php echo @constant('LANG_CONTACTS_COMPANY_CONTACTS_WITHSELECTED'); ?>
</span>
					<select name="company_contact_action">
						<option value=""><?php echo @constant('LANG_CONTACTS_COMPANY_CONTACTS_WITHSELECTED_NOTHING'); ?>

						<option value="unassign"><?php echo @constant('LANG_CONTACTS_COMPANY_CONTACTS_WITHSELECTED_UNASSIGN'); ?>

					</select>
					<input type="submit" value="<?php echo @constant('LANG_CONTACTS_COMPANY_CONTACTS_WITHSELECTED_UPDATE'); ?>
" class="cer_button_face">
				</td>
			</tr>
		
			</form>
			
		<?php endif; ?>
		
	</table>

	<table border="0" cellspacing="0" cellpadding="3" width="100%">
	
		<tr>
			<td align="right" class="cer_maintable_text">
				<?php if ($this->_tpl_vars['user_handler']->set_url_prev): ?><a href="<?php echo $this->_tpl_vars['user_handler']->set_url_prev; ?>
" class="cer_header_loginLink">&lt;&lt; Prev</a><?php endif; ?>
				<?php echo @constant('LANG_WORD_SHOWING'); ?>
 <B><?php echo $this->_tpl_vars['user_handler']->set_from; ?>
</B> <?php echo @constant('LANG_WORD_TO'); ?>
 <B><?php echo $this->_tpl_vars['user_handler']->set_to; ?>
</B> <?php echo @constant('LANG_WORD_OF'); ?>
 <B><?php echo $this->_tpl_vars['user_handler']->set_of; ?>
</B>
				<?php if ($this->_tpl_vars['user_handler']->set_url_next): ?><a href="<?php echo $this->_tpl_vars['user_handler']->set_url_next; ?>
" class="cer_header_loginLink">Next &gt;&gt;</a><?php endif; ?>
			</td>
		</tr>
	
	</table>
	
	<br>