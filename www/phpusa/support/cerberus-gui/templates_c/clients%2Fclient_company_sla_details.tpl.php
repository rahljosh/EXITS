<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:46
         compiled from clients/client_company_sla_details.tpl.php */ ?>
<table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000" width="100%">

	<tr>
		<td class="boxtitle_green_glass" colspan="4">
			<?php if (! empty ( $this->_tpl_vars['sla'] )): ?>
				<?php echo $this->_tpl_vars['sla']->sla_name; ?>

			<?php else: ?>
				<?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_HEADERIFEMPTY'); ?>

			<?php endif; ?>
		</td>
	</tr>

<?php if (! empty ( $this->_tpl_vars['sla'] )): ?>
	
	<tr bgcolor="#CCCCCC">
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_TABLE_QUEUE'); ?>
</td>
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_TABLE_QUEUEMODE'); ?>
</td>
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_TABLE_SLASCHEDULE'); ?>
</td>
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_TABLE_TARGETRESPONSETIME'); ?>
</td>
	</tr>


	<?php if (isset($this->_foreach['queue'])) unset($this->_foreach['queue']);
$this->_foreach['queue']['name'] = 'queue';
$this->_foreach['queue']['total'] = count((array)$this->_tpl_vars['sla']->queues);
$this->_foreach['queue']['show'] = $this->_foreach['queue']['total'] > 0;
if ($this->_foreach['queue']['show']):
$this->_foreach['queue']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['sla']->queues as $this->_tpl_vars['qid'] => $this->_tpl_vars['queue']):
        $this->_foreach['queue']['iteration']++;
        $this->_foreach['queue']['first'] = ($this->_foreach['queue']['iteration'] == 1);
        $this->_foreach['queue']['last']  = ($this->_foreach['queue']['iteration'] == $this->_foreach['queue']['total']);
?>
		<tr bgcolor="#F5F5F5">
			<td class="cer_maintable_heading"><?php echo $this->_tpl_vars['queue']->queue_name; ?>
</td>
			<td class="cer_maintable_text"><?php echo $this->_tpl_vars['queue']->queue_mode; ?>
</td>
			<td class="cer_maintable_text"><?php echo $this->_tpl_vars['queue']->queue_schedule_name; ?>
</a></td>
			<td class="cer_maintable_text" align="center"><?php echo $this->_tpl_vars['queue']->queue_response_time; ?>
<?php echo @constant('LANG_DATE_SHORT_HOURS_ABBR'); ?>
</td>
		</tr>
	<?php endforeach; endif; ?>

	<form name="company_sla_update" action="clients.php">
	<input type="hidden" name="form_submit" value="company_sla_update">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
	<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['company']->company_id; ?>
">
		
	<?php if ($this->_tpl_vars['params']['mode'] == 'c_view' && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
		<tr bgcolor="#E5E5E5">
			<td colspan="4" class="cer_maintable_text">
				<span class="cer_maintable_heading"><?php echo @constant('LANG_WORD_EXPIRES'); ?>
:</span>
					<input type="text" name="company_sla_expire" maxlength="8" size="8" value="<?php if ($this->_tpl_vars['company']->sla_expire_date): ?><?php echo $this->_tpl_vars['company']->sla_expire_date->getUserDate("%m/%d/%y"); ?>
<?php endif; ?>">
		          	<span class="cer_footer_text">
		          	<?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_CALENDAR'); ?>

		          	</span>				
			</td>
		</tr>
	<?php elseif ($this->_tpl_vars['params']['mode'] == 'u_view'): ?>
		<tr bgcolor="#E5E5E5">
			<td colspan="4" class="cer_maintable_text">
				<span class="cer_maintable_heading"><?php echo @constant('LANG_WORD_EXPIRES'); ?>
:</span>
				<?php if ($this->_tpl_vars['user']->company_ptr->sla_expire_date): ?><?php echo $this->_tpl_vars['user']->company_ptr->sla_expire_date->getUserDate("%m/%d/%y"); ?>
<?php endif; ?>
			</td>
		</tr>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['params']['mode'] == 'c_view' && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
		<tr bgcolor="#F5F5F5">
			<td colspan="4" align="right">
				<input type="checkbox" name="company_remove_sla" value="1">
				<span class="cer_maintable_text"><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_REMOVEPLAN'); ?>
</span>
				<input type="submit" value="<?php echo @constant('LANG_WORD_UPDATE'); ?>
" class="cer_button_face">
			</td>
		</tr>
	<?php endif; ?>
	
	</form>
	
<?php else: ?>

	<form name="company_add_sla" action="clients.php">
	<input type="hidden" name="form_submit" value="company_add_sla">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
	<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['company']->company_id; ?>
">

	<tr>
		<td bgcolor="#EEEEEE" colspan="4">
			<span class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_NOPLAN'); ?>
</span><br>
		</td>
	</tr>
	
	<?php if ($this->_tpl_vars['params']['mode'] == 'c_view' && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
		<tr bgcolor="#EEEEEE">
			<td colspan="4">
					<span class="cer_maintable_text"><B><?php echo @constant('LANG_CONTACTS_REGISTRED_COMPANY_SLAPLAN'); ?>
:</B> </span>
					<select name="company_add_sla">
						<option value=""><?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_SELECTPLAN_NONE'); ?>

						<?php if (isset($this->_foreach['plan'])) unset($this->_foreach['plan']);
$this->_foreach['plan']['name'] = 'plan';
$this->_foreach['plan']['total'] = count((array)$this->_tpl_vars['company_handler']->sla_handler->plans);
$this->_foreach['plan']['show'] = $this->_foreach['plan']['total'] > 0;
if ($this->_foreach['plan']['show']):
$this->_foreach['plan']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['company_handler']->sla_handler->plans as $this->_tpl_vars['plan']):
        $this->_foreach['plan']['iteration']++;
        $this->_foreach['plan']['first'] = ($this->_foreach['plan']['iteration'] == 1);
        $this->_foreach['plan']['last']  = ($this->_foreach['plan']['iteration'] == $this->_foreach['plan']['total']);
?>
							<option value="<?php echo $this->_tpl_vars['plan']->sla_id; ?>
"><?php echo $this->_tpl_vars['plan']->sla_name; ?>

						<?php endforeach; endif; ?>
					</select>
			</td>
		</tr>
		<tr bgcolor="#EEEEEE">
			<td colspan="4">
					<span class="cer_maintable_text"><B><?php echo @constant('LANG_WORD_EXPIRES'); ?>
:</B></span>
					<input type="text" name="company_sla_expire" maxlength="8" size="8" value="">
		          	<span class="cer_footer_text">
		          	<?php echo @constant('LANG_CONTACTS_COMPANY_SLABOX_CALENDAR'); ?>

		          	</span>
			</td>
		</tr>
		<tr>
			<td bgcolor="#EEEEEE" colspan="4" align="right"><input type="submit" value="<?php echo @constant('LANG_WORD_ADD'); ?>
" class="cer_button_face"></td>
		</tr>
	<?php endif; ?>
	
	</form>
		
<?php endif; ?>
	
</table>		