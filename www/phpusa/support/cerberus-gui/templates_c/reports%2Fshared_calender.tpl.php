<?php /* Smarty version 2.5.0, created on 2007-02-20 16:35:04
         compiled from reports/shared_calender.tpl.php */ ?>
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td valign="top">
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_dashboard_calendar.tpl.php", array('cal' => $this->_tpl_vars['report_list']->report->report_data->cal));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		</td>
		<td><img alt="" src="includes/images/spacer.gif" width="10" height="1"></td>
		<td valign="top">
			<span class="cer_maintable_heading">Use the calendar to the left to choose which month or day to display a report for, or choose a quick option below.</span><br>
			<br>
			<?php if (isset($this->_sections['link'])) unset($this->_sections['link']);
$this->_sections['link']['name'] = 'link';
$this->_sections['link']['loop'] = is_array($this->_tpl_vars['report_list']->report->report_data->quick_links) ? count($this->_tpl_vars['report_list']->report->report_data->quick_links) : max(0, (int)$this->_tpl_vars['report_list']->report->report_data->quick_links);
$this->_sections['link']['show'] = true;
$this->_sections['link']['max'] = $this->_sections['link']['loop'];
$this->_sections['link']['step'] = 1;
$this->_sections['link']['start'] = $this->_sections['link']['step'] > 0 ? 0 : $this->_sections['link']['loop']-1;
if ($this->_sections['link']['show']) {
    $this->_sections['link']['total'] = $this->_sections['link']['loop'];
    if ($this->_sections['link']['total'] == 0)
        $this->_sections['link']['show'] = false;
} else
    $this->_sections['link']['total'] = 0;
if ($this->_sections['link']['show']):

            for ($this->_sections['link']['index'] = $this->_sections['link']['start'], $this->_sections['link']['iteration'] = 1;
                 $this->_sections['link']['iteration'] <= $this->_sections['link']['total'];
                 $this->_sections['link']['index'] += $this->_sections['link']['step'], $this->_sections['link']['iteration']++):
$this->_sections['link']['rownum'] = $this->_sections['link']['iteration'];
$this->_sections['link']['index_prev'] = $this->_sections['link']['index'] - $this->_sections['link']['step'];
$this->_sections['link']['index_next'] = $this->_sections['link']['index'] + $this->_sections['link']['step'];
$this->_sections['link']['first']      = ($this->_sections['link']['iteration'] == 1);
$this->_sections['link']['last']       = ($this->_sections['link']['iteration'] == $this->_sections['link']['total']);
?>
				<a class="cer_maintable_heading" href="<?php echo $this->_tpl_vars['report_list']->report->report_data->quick_links[$this->_sections['link']['index']]->link_url; ?>
"><?php echo $this->_tpl_vars['report_list']->report->report_data->quick_links[$this->_sections['link']['index']]->link_name; ?>
</a><br>
			<?php endfor; endif; ?>
			<br>
			<input type="hidden" name="mo_m" value="">
			<input type="hidden" name="mo_d" value="">
			<input type="hidden" name="mo_y" value="">
			<span class="cer_maintable_heading">Enter Date Range:</span>
			
			<input type="text" name="from_date" value="<?php echo $this->_tpl_vars['report_list']->report->report_dates->from_date_calender; ?>
" size="8" maxlength="8">
			
			<span class="cer_maintable_text">to</span>
			
			<input type="text" name="to_date" value="<?php echo $this->_tpl_vars['report_list']->report->report_dates->to_date_calender; ?>
" size="8" maxlength="8">
			<span class="cer_footer_text">(enter as mm/dd/yy)</span>
			
		</td>
		
	</tr>
</table>