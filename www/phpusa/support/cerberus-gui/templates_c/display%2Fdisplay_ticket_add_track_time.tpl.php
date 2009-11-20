<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/display_ticket_add_track_time.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'display/display_ticket_add_track_time.tpl.php', 88, false),
array('function', 'html_options', 'display/display_ticket_add_track_time.tpl.php', 114, false),)); ?><div id="thread_add_time_entry" style="display:<?php if (isset ( $this->_tpl_vars['form_submit'] ) && $this->_tpl_vars['form_submit'] == 'thread_create_time_entry'): ?>block<?php else: ?>none<?php endif; ?>;">

<a name="thread_track_time"></a>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td class="cer_table_row_line"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr>
  <tr bgcolor="#6600cc">
	<td class="cer_display_thread_header">
		&nbsp;Create New Time Tracking Entry
	</td>
  </tr>
  <tr><td class="cer_table_row_line"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<form action="display.php" method="post" name="add_time_tracking_entry_form">
	<input type="hidden" name="form_submit" value="thread_time_add">
	<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">

	<tr bgcolor="#FFFFFF">
		<td class="cer_maintable_text">
			<table width="100%" cellspacing="1" cellpadding="2" border="0">
				
				<tr>
					<td colspan="2" bgcolor="#D0D0D0">Dates can be entered absolutely ('mm/dd/yy') or relatively ('now', '+2 days', '+1 week')</td>
				</tr>
			
				<tr>
					<td class="cer_custom_field_heading" bgcolor="#D0D0D0" width="1%" valign="top"  nowrap>
						<?php echo @constant('LANG_DISPLAY_TIME_TRACKING_WORK_DATE'); ?>
:
					</td>
					<td bgcolor="#E0E0E0" width="99%">
						<input type="text" name="thread_time_date" size="24" value="<?php echo $this->_tpl_vars['time_entry_defaults']['mdy']; ?>
">
					</td>
				</tr>
				
				<tr>
					<td class="cer_custom_field_heading" bgcolor="#D0D0D0" width="1%" valign="top" nowrap>
						<?php echo @constant('LANG_DISPLAY_TIME_TRACKING_DATE_BILLED'); ?>
:
					</td>
					<td bgcolor="#E0E0E0" width="99%">
						<input type="text" name="thread_time_date_billed" size="24" value="">
					</td>
				</tr>
				
				<tr>
					<td class="cer_custom_field_heading" bgcolor="#D0D0D0" width="1%" valign="top"  nowrap>
						<?php echo @constant('LANG_DISPLAY_TIME_TRACKING_WORK_AGENT'); ?>
:
					</td>
					<td bgcolor="#E0E0E0" width="99%">
						<select name="thread_time_working_agent_id">
						<?php if (isset($this->_foreach['agents'])) unset($this->_foreach['agents']);
$this->_foreach['agents']['name'] = 'agents';
$this->_foreach['agents']['total'] = count((array)$this->_tpl_vars['agents']);
$this->_foreach['agents']['show'] = $this->_foreach['agents']['total'] > 0;
if ($this->_foreach['agents']['show']):
$this->_foreach['agents']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['agents'] as $this->_tpl_vars['agentId'] => $this->_tpl_vars['agent']):
        $this->_foreach['agents']['iteration']++;
        $this->_foreach['agents']['first'] = ($this->_foreach['agents']['iteration'] == 1);
        $this->_foreach['agents']['last']  = ($this->_foreach['agents']['iteration'] == $this->_foreach['agents']['total']);
?>
							<option value="<?php echo $this->_tpl_vars['agentId']; ?>
" <?php if ($this->_tpl_vars['agentId'] == $this->_tpl_vars['session']->vars['login_handler']->user_id): ?>selected<?php endif; ?>><?php echo $this->_tpl_vars['agent']->getRealName(); ?>

						<?php endforeach; endif; ?>
						</select>
					</td>
				</tr>
				
				<tr>
					<td class="cer_custom_field_heading" bgcolor="#D0D0D0" width="1%" valign="top"  nowrap>
						<?php echo @constant('LANG_WORD_HOURS'); ?>
:<br>
						<span class="cer_footer_text">(for example: <B>1.5</B>)</span>
					</td>
					<td bgcolor="#E0E0E0" width="99%">
						<table border="0" cellpadding="1" cellspacing="0">
							<tr>
								<td><span class="cer_custom_field_heading"><?php echo @constant('LANG_WORD_WORKED'); ?>
:</span> <input name="thread_time_hrs_spent" type="text" size="5" onfocus="javascript:doTimeEntryAddHelp('time_add_help',0);">&nbsp;</td>
								<td><span class="cer_custom_field_heading"><?php echo @constant('LANG_WORD_CHARGEABLE'); ?>
:</span> <input name="thread_time_hrs_chargeable" type="text" size="5" onfocus="javascript:doTimeEntryAddHelp('time_add_help',1);">&nbsp;</td>
								<td><span class="cer_custom_field_heading"><?php echo @constant('LANG_WORD_BILLABLE'); ?>
:</span> <input name="thread_time_hrs_billable" type="text" size="5" onfocus="javascript:doTimeEntryAddHelp('time_add_help',2);">&nbsp;</td>
								<td><span class="cer_custom_field_heading"><?php echo @constant('LANG_WORD_PAYABLE'); ?>
:</span> <input name="thread_time_hrs_payable" type="text" size="5" onfocus="javascript:doTimeEntryAddHelp('time_add_help',3);">&nbsp;</td>
							</tr>
						</table>
						
						
						<div id="time_add_help_0" style="display:none;"><B><?php echo @constant('LANG_WORD_WORKED'); ?>
:</B> The actual hours worked by the agent.</div>
						<div id="time_add_help_1" style="display:none;"><B><?php echo @constant('LANG_WORD_CHARGEABLE'); ?>
:</B>The amount of hours charged to the client. (e.g.: minus lunch breaks, etc.)</div>
						<div id="time_add_help_2" style="display:none;"><B><?php echo @constant('LANG_WORD_BILLABLE'); ?>
:</B> The amount of hours originally quoted to the client (if any).</div>
						<div id="time_add_help_3" style="display:none;"><B><?php echo @constant('LANG_WORD_PAYABLE'); ?>
:</B> The amount of hours payable to the agent.</div>
					</td>
				</tr>
				
				<tr>
					<td class="cer_custom_field_heading" bgcolor="#D0D0D0" width="1%" valign="top" nowrap>
						<?php echo @constant('LANG_DISPLAY_TIME_TRACKING_WORK_SUMMARY'); ?>
:
					</td>
					<td bgcolor="#E0E0E0" width="99%">
						<textarea name="thread_time_summary" width="100%" rows="5"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['time_entry_defaults']['summary']); ?>
</textarea>
					</td>
				</tr>
				
				<?php if ($this->_tpl_vars['time_entry_defaults']['custom_gid']): ?>
				
					<input type="hidden" name="thread_time_custom_gid" value="<?php echo $this->_tpl_vars['time_entry_defaults']['custom_gid']; ?>
">
				
					<?php if (isset($this->_foreach['custom'])) unset($this->_foreach['custom']);
$this->_foreach['custom']['name'] = 'custom';
$this->_foreach['custom']['total'] = count((array)$this->_tpl_vars['time_entry_defaults']['custom_fields']->fields);
$this->_foreach['custom']['show'] = $this->_foreach['custom']['total'] > 0;
if ($this->_foreach['custom']['show']):
$this->_foreach['custom']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['time_entry_defaults']['custom_fields']->fields as $this->_tpl_vars['field']):
        $this->_foreach['custom']['iteration']++;
        $this->_foreach['custom']['first'] = ($this->_foreach['custom']['iteration'] == 1);
        $this->_foreach['custom']['last']  = ($this->_foreach['custom']['iteration'] == $this->_foreach['custom']['total']);
?>
						<tr>
							<td class="cer_custom_field_heading" bgcolor="#D0D0D0" width="1%" valign="top" nowrap>
								<?php echo $this->_tpl_vars['field']->field_name; ?>
:
							</td>
							<td bgcolor="#E0E0E0" width="99%">
			                  	<?php if ($this->_tpl_vars['field']->field_type == 'S'): ?>
			                    	<input type="text" name="thread_time_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" size="65" value="" class="cer_custom_field_text">
			                    <?php endif; ?>
			
			                  	<?php if ($this->_tpl_vars['field']->field_type == 'T'): ?>
			                    	<textarea cols="65" rows="3" name="thread_time_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" wrap="virtual" class="cer_custom_field_text"></textarea><br>
			                    	<span class="cer_footer_text">(maximum 255 characters)</span>
			                    <?php endif; ?>
			                    
			                  	<?php if ($this->_tpl_vars['field']->field_type == 'D'): ?>
			                    	<select name="thread_time_custom_<?php echo $this->_tpl_vars['field']->field_id; ?>
" class="cer_custom_field_text">
				                      <option value="">
				                      <?php echo $this->_plugins['function']['html_options'][0](array('options' => $this->_tpl_vars['field']->field_options), $this) ; ?>

			                        </select>
			                    <?php endif; ?>
							</td>
						</tr>
					<?php endforeach; endif; ?>
				<?php endif; ?>
				
				
				<tr>
					<td colspan="2" bgcolor="#BBBBBB" align="right">
						<input type="submit" value="Update" class="cer_footer_text">
						<input type="button" value="Cancel" OnClick="javascript:toggleThreadTimeEntry();" class="cer_footer_text">
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	
	</form>
	
</table>

<br>
</div>