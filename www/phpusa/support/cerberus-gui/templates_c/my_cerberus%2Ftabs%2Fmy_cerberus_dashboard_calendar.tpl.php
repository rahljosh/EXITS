<?php /* Smarty version 2.5.0, created on 2007-01-15 21:55:29
         compiled from my_cerberus/tabs/my_cerberus_dashboard_calendar.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'my_cerberus/tabs/my_cerberus_dashboard_calendar.tpl.php', 1, false),)); ?><?php echo $this->_plugins['function']['assign'][0](array('var' => 'col_span','value' => 7), $this) ; ?>

<table cellpadding=0 cellspacing=0 border=0 style="border: 1px solid #888888;">
	
	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	<tr class="boxtitle_blue_glass">
		<td align="center"><a href="<?php echo $this->_tpl_vars['cal']->urls['prev_mo']; ?>
" class="cer_maintable_header">&lt;</a></td>
		<td colspan='5' align=center>
			<?php echo $this->_tpl_vars['cal']->cal_month_name; ?>
 <?php echo $this->_tpl_vars['cal']->cal_year; ?>

		</td>
		<td align="center"><a href="<?php echo $this->_tpl_vars['cal']->urls['next_mo']; ?>
" class="cer_maintable_header">&gt;</a></td>
	</tr>
	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	
	<tr class='cer_footer_text' bgcolor='#bbbbbb'>
		<td width="15%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_SUN'); ?>
&nbsp;</B></td>
		<td width="14%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_MON'); ?>
&nbsp;</B></td>
		<td width="14%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_TUE'); ?>
&nbsp;</B></td>
		<td width="14%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_WED'); ?>
&nbsp;</B></td>
		<td width="14%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_THU'); ?>
&nbsp;</B></td>
		<td width="14%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_FRI'); ?>
&nbsp;</B></td>
		<td width="15%"><B>&nbsp;<?php echo @constant('LANG_CHOOSEDATE_SAT'); ?>
&nbsp;</B></td>
	</tr>
	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>

	<?php if (isset($this->_sections['week'])) unset($this->_sections['week']);
$this->_sections['week']['name'] = 'week';
$this->_sections['week']['loop'] = is_array($this->_tpl_vars['cal']->cal_matrix) ? count($this->_tpl_vars['cal']->cal_matrix) : max(0, (int)$this->_tpl_vars['cal']->cal_matrix);
$this->_sections['week']['show'] = true;
$this->_sections['week']['max'] = $this->_sections['week']['loop'];
$this->_sections['week']['step'] = 1;
$this->_sections['week']['start'] = $this->_sections['week']['step'] > 0 ? 0 : $this->_sections['week']['loop']-1;
if ($this->_sections['week']['show']) {
    $this->_sections['week']['total'] = $this->_sections['week']['loop'];
    if ($this->_sections['week']['total'] == 0)
        $this->_sections['week']['show'] = false;
} else
    $this->_sections['week']['total'] = 0;
if ($this->_sections['week']['show']):

            for ($this->_sections['week']['index'] = $this->_sections['week']['start'], $this->_sections['week']['iteration'] = 1;
                 $this->_sections['week']['iteration'] <= $this->_sections['week']['total'];
                 $this->_sections['week']['index'] += $this->_sections['week']['step'], $this->_sections['week']['iteration']++):
$this->_sections['week']['rownum'] = $this->_sections['week']['iteration'];
$this->_sections['week']['index_prev'] = $this->_sections['week']['index'] - $this->_sections['week']['step'];
$this->_sections['week']['index_next'] = $this->_sections['week']['index'] + $this->_sections['week']['step'];
$this->_sections['week']['first']      = ($this->_sections['week']['iteration'] == 1);
$this->_sections['week']['last']       = ($this->_sections['week']['iteration'] == $this->_sections['week']['total']);
?>
	
			<tr bgcolor='<?php if ($this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->is_this_week === true): ?>#6CC8FC<?php else: ?>#eeeeee<?php endif; ?>'>
			
			<?php if (isset($this->_sections['day'])) unset($this->_sections['day']);
$this->_sections['day']['name'] = 'day';
$this->_sections['day']['loop'] = is_array($this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days) ? count($this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days) : max(0, (int)$this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days);
$this->_sections['day']['show'] = true;
$this->_sections['day']['max'] = $this->_sections['day']['loop'];
$this->_sections['day']['step'] = 1;
$this->_sections['day']['start'] = $this->_sections['day']['step'] > 0 ? 0 : $this->_sections['day']['loop']-1;
if ($this->_sections['day']['show']) {
    $this->_sections['day']['total'] = $this->_sections['day']['loop'];
    if ($this->_sections['day']['total'] == 0)
        $this->_sections['day']['show'] = false;
} else
    $this->_sections['day']['total'] = 0;
if ($this->_sections['day']['show']):

            for ($this->_sections['day']['index'] = $this->_sections['day']['start'], $this->_sections['day']['iteration'] = 1;
                 $this->_sections['day']['iteration'] <= $this->_sections['day']['total'];
                 $this->_sections['day']['index'] += $this->_sections['day']['step'], $this->_sections['day']['iteration']++):
$this->_sections['day']['rownum'] = $this->_sections['day']['iteration'];
$this->_sections['day']['index_prev'] = $this->_sections['day']['index'] - $this->_sections['day']['step'];
$this->_sections['day']['index_next'] = $this->_sections['day']['index'] + $this->_sections['day']['step'];
$this->_sections['day']['first']      = ($this->_sections['day']['iteration'] == 1);
$this->_sections['day']['last']       = ($this->_sections['day']['iteration'] == $this->_sections['day']['total']);
?>
				<td align="center" valign="middle" style="padding:2px;"><?php if ($this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days[$this->_sections['day']['index']]->day != 0): ?><a href="<?php echo $this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days[$this->_sections['day']['index']]->day_url; ?>
" class='<?php if ($this->_tpl_vars['cal']->is_this_month === true && $this->_tpl_vars['cal']->cur_day == $this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days[$this->_sections['day']['index']]->day): ?>cer_maintable_header<?php else: ?>cer_footer_text<?php endif; ?>'><?php echo $this->_tpl_vars['cal']->cal_matrix[$this->_sections['week']['index']]->days[$this->_sections['day']['index']]->day; ?>
</a><?php endif; ?></td>
			<?php endfor; endif; ?>
			
			</tr>

	<?php endfor; endif; ?>

	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
		
</table>