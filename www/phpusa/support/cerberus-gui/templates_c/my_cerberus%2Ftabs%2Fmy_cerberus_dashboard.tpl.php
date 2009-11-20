<?php /* Smarty version 2.5.0, created on 2007-01-15 21:55:28
         compiled from my_cerberus/tabs/my_cerberus_dashboard.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'string_format', 'my_cerberus/tabs/my_cerberus_dashboard.tpl.php', 32, false),
array('modifier', 'short_escape', 'my_cerberus/tabs/my_cerberus_dashboard.tpl.php', 32, false),)); ?><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td width="1%" nowrap valign="top">
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_dashboard_calendar.tpl.php", array('cal' => $this->_tpl_vars['dashboard']->cal));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	</td>
	<td width="1%" nowrap><img alt="" src="includes/images/spacer.gif" width="10" height="1"></td>
	<td valign="top" width="98%">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	  <tr class="boxtitle_green_glass"> 
	    <td>&nbsp;<?php echo @constant('LANG_MYCERBERUS_DASHBOARD_MYPERFORMANCE'); ?>
</td>
	  </tr>
	  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	  <tr bgcolor="#DDDDDD" class="cer_maintable_text"> 
	    <td bgcolor="#DDDDDD" class="cer_maintable_text" align="left"> 
		<table cellspacing="0" cellpadding="0" width="100%" border="0">
			<tr>
				<td width="1%" nowrap class="cer_maintable_heading" bgcolor="#CCCCCC">&nbsp;<?php echo @constant('LANG_MYCERBERUS_DASHBOARD_ASSIGNEDACTIVE'); ?>
:&nbsp;</td>
				<td width="99%" class="cer_maintable_text"><b><?php echo $this->_tpl_vars['dashboard']->stats['active_tickets_assigned']; ?>
</b>
				<span class="cer_footer_text">
					(<a href="<?php echo $this->_tpl_vars['dashboard']->urls['my_tickets']; ?>
" class="cer_footer_text"><?php echo @constant('LANG_MYCERBERUS_DASHBOARD_LISTMYACTIVE'); ?>
:</a>) 
					<b><?php echo $this->_tpl_vars['dashboard']->stats['my_percentage']; ?>
%</b> (<?php echo $this->_tpl_vars['dashboard']->stats['active_tickets_assigned']; ?>
 <?php echo @constant('LANG_WORD_OF'); ?>
 <?php echo $this->_tpl_vars['dashboard']->stats['active_tickets']; ?>
 <?php echo @constant('LANG_MYCERBERUS_DASHBOARD_OFACTIVETICKETS'); ?>
)
				</span>
				</td>
			</tr>
			<tr><td colspan="2" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
			
			<?php if ($this->_tpl_vars['dashboard']->stats['latest_ticket_id'] != 0): ?>
			<tr>
				<td width="1%" nowrap class="cer_maintable_heading" bgcolor="#CCCCCC">&nbsp;<?php echo @constant('LANG_MYCERBERUS_DASHBOARD_OLDESTASSIGNED'); ?>
:&nbsp;</td>
				<td class="cer_footer_text">[<a href="<?php echo $this->_tpl_vars['dashboard']->urls['latest_ticket']; ?>
" class="cer_footer_text">#<?php echo $this->_run_mod_handler('string_format', true, $this->_tpl_vars['dashboard']->stats['latest_ticket_id'], "%05d"); ?>
</a>]: <?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['dashboard']->stats['latest_ticket_subject']); ?>
 (<b><?php echo $this->_tpl_vars['dashboard']->stats['latest_ticket_age']; ?>
</b> <?php echo @constant('LANG_WORD_OLD'); ?>
)</span></td>
			</tr>
			<tr><td colspan="2" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
			<?php endif; ?>
			
			<tr>
				<td width="1%" nowrap class="cer_maintable_heading" bgcolor="#CCCCCC" valign="top">&nbsp;<?php echo @constant('LANG_MYCERBERUS_DASHBOARD_7DAYACTIVITY'); ?>
&nbsp;<br>
				<span class="cer_footer_text">&nbsp;<?php echo @constant('LANG_MYCERBERUS_DASHBOARD_7DAYACTIVITY_REPLIESCOMMENTS'); ?>
</span></td>
				<td class="cer_footer_text">
				<table border="0" cellpadding="0" cellspacing="1">
					<?php if (count ( $this->_tpl_vars['dashboard']->snapshot )): ?>
						<tr>
							<td class="cer_footer_text" align="left"></td>
							<td class="cer_footer_text" align="center">&nbsp;<B><?php echo @constant('LANG_MYCERBERUS_DASHBOARD_7DAYACTIVITY_EMAIL'); ?>
</B>&nbsp;</td>
							<td class="cer_footer_text" align="center">&nbsp;<B><?php echo @constant('LANG_MYCERBERUS_DASHBOARD_7DAYACTIVITY_COMMENTS'); ?>
</B>&nbsp;</td>
						</tr>
					<?php endif; ?>
					<?php if (isset($this->_sections['day'])) unset($this->_sections['day']);
$this->_sections['day']['name'] = 'day';
$this->_sections['day']['loop'] = is_array($this->_tpl_vars['dashboard']->snapshot) ? count($this->_tpl_vars['dashboard']->snapshot) : max(0, (int)$this->_tpl_vars['dashboard']->snapshot);
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
						<tr>
							<td class="cer_footer_text" bgcolor="#D0D0D0" align="left"><b><?php echo $this->_tpl_vars['dashboard']->snapshot[$this->_sections['day']['index']]->day_str; ?>
:</b></td>
							<td class="cer_footer_text" align="center"><?php echo $this->_tpl_vars['dashboard']->snapshot[$this->_sections['day']['index']]->day_email_count; ?>
</td>
							<td class="cer_footer_text" align="center"><?php echo $this->_tpl_vars['dashboard']->snapshot[$this->_sections['day']['index']]->day_comment_count; ?>
</td>
						</tr>
					<?php endfor; else: ?>
						<tr><td class="cer_footer_text"><?php echo @constant('LANG_MYCERBERUS_DASHBOARD_7DAYACTIVITY_NODATA'); ?>
</td></tr>
					<?php endif; ?>
				</table>
				</td>
			</tr>
			
		</table>
	    </td>
	  </tr>
	  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
	</table>
	</td>
</tr>
</table>

<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_orange_glass"> 
    <td>&nbsp;<?php echo $this->_tpl_vars['dashboard']->last_actions_title; ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="cer_maintable_text"> 
    <td bgcolor="#FFFFFF" class="cer_maintable_text" align="left"> 
	<table cellspacing="0" cellpadding="0" width="100%" border="0">
		<?php if (isset($this->_sections['row'])) unset($this->_sections['row']);
$this->_sections['row']['name'] = 'row';
$this->_sections['row']['loop'] = is_array($this->_tpl_vars['dashboard']->last_actions) ? count($this->_tpl_vars['dashboard']->last_actions) : max(0, (int)$this->_tpl_vars['dashboard']->last_actions);
$this->_sections['row']['show'] = true;
$this->_sections['row']['max'] = $this->_sections['row']['loop'];
$this->_sections['row']['step'] = 1;
$this->_sections['row']['start'] = $this->_sections['row']['step'] > 0 ? 0 : $this->_sections['row']['loop']-1;
if ($this->_sections['row']['show']) {
    $this->_sections['row']['total'] = $this->_sections['row']['loop'];
    if ($this->_sections['row']['total'] == 0)
        $this->_sections['row']['show'] = false;
} else
    $this->_sections['row']['total'] = 0;
if ($this->_sections['row']['show']):

            for ($this->_sections['row']['index'] = $this->_sections['row']['start'], $this->_sections['row']['iteration'] = 1;
                 $this->_sections['row']['iteration'] <= $this->_sections['row']['total'];
                 $this->_sections['row']['index'] += $this->_sections['row']['step'], $this->_sections['row']['iteration']++):
$this->_sections['row']['rownum'] = $this->_sections['row']['iteration'];
$this->_sections['row']['index_prev'] = $this->_sections['row']['index'] - $this->_sections['row']['step'];
$this->_sections['row']['index_next'] = $this->_sections['row']['index'] + $this->_sections['row']['step'];
$this->_sections['row']['first']      = ($this->_sections['row']['iteration'] == 1);
$this->_sections['row']['last']       = ($this->_sections['row']['iteration'] == $this->_sections['row']['total']);
?>
		<tr bgcolor="#DDDDDD">
			<td width="1%" nowrap class="cer_footer_text" bgcolor="#CCCCCC" style="padding-left: 1px;" class="cer_footer_text">#<?php echo $this->_run_mod_handler('string_format', true, $this->_tpl_vars['dashboard']->last_actions[$this->_sections['row']['index']]->ticket_id, "%05d"); ?>
:</td>
			<td width="1%" nowrap style="padding-left: 5px;"><a href="<?php echo $this->_tpl_vars['dashboard']->last_actions[$this->_sections['row']['index']]->ticket_url; ?>
" class="cer_maintable_heading"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['dashboard']->last_actions[$this->_sections['row']['index']]->ticket_subject); ?>
</a></td>
			<td width="98%" class="cer_footer_text" style="padding-left: 5px;"><?php echo $this->_tpl_vars['dashboard']->last_actions[$this->_sections['row']['index']]->ticket_status; ?>
</td>
		  	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
		</tr>
		<?php endfor; else: ?>
		<tr>
			<td bgcolor="#DDDDDD" class="cer_footer_text"><?php echo @constant('LANG_MYCERBERUS_DASHBOARD_TICKETHISTORY_NO'); ?>
</td>
		</tr>
	  	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
		<?php endif; ?>
	</table>
    </td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
</table>
<br>