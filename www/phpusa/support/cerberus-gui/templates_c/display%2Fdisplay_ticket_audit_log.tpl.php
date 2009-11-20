<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/display_ticket_audit_log.tpl.php */ ?>
<?php if (count ( $this->_tpl_vars['o_ticket']->log->entries )): ?>

<?php echo '
<script type="text/javascript">
	function toggleDisplayLog() {
		if (document.getElementById) {
			if(document.getElementById("ticket_display_log").style.display=="block") {
				document.getElementById("ticket_display_log").style.display="none";
				document.getElementById("ticket_display_log_icon").src=icon_expand.src;
				document.formSaveLayout.layout_display_show_log.value = 0;
			}
			else {
				document.getElementById("ticket_display_log").style.display="block";
				document.getElementById("ticket_display_log_icon").src=icon_collapse.src;
				document.formSaveLayout.layout_display_show_log.value = 1;
			}
		}
	}
</script>
'; ?>


<a href="javascript:toggleDisplayLog();"><img id="ticket_display_log_icon" border="0" alt="Display Log" src="includes/images/<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_log']): ?>icon_collapse.gif<?php else: ?>icon_expand.gif<?php endif; ?>" width="16" height="16"></a>
<img src="includes/images/icone/16x16/document_info.gif" width="16" height="16" alt="Document">
<span class="link_ticket"><?php echo @constant('LANG_AUDIT_LOG_TITLE_LATEST_5'); ?>
</span><br>
<table cellspacing="0" cellpadding="0" width="100%"><tr><td bgcolor="#DDDDDD"><img src="includes/images/spacer.gif" height="1" width="1" alt=""></td></tr></table>
<div id="ticket_display_log" style="display:<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_log']): ?>block<?php else: ?>none<?php endif; ?>;">
<table cellspacing="1" cellpadding="1" width="100%" border="0" class="ticket_display_table">
	<?php if (isset($this->_sections['item'])) unset($this->_sections['item']);
$this->_sections['item']['name'] = 'item';
$this->_sections['item']['loop'] = is_array($this->_tpl_vars['o_ticket']->log->entries) ? count($this->_tpl_vars['o_ticket']->log->entries) : max(0, (int)$this->_tpl_vars['o_ticket']->log->entries);
$this->_sections['item']['max'] = (int)5;
$this->_sections['item']['show'] = true;
if ($this->_sections['item']['max'] < 0)
    $this->_sections['item']['max'] = $this->_sections['item']['loop'];
$this->_sections['item']['step'] = 1;
$this->_sections['item']['start'] = $this->_sections['item']['step'] > 0 ? 0 : $this->_sections['item']['loop']-1;
if ($this->_sections['item']['show']) {
    $this->_sections['item']['total'] = min(ceil(($this->_sections['item']['step'] > 0 ? $this->_sections['item']['loop'] - $this->_sections['item']['start'] : $this->_sections['item']['start']+1)/abs($this->_sections['item']['step'])), $this->_sections['item']['max']);
    if ($this->_sections['item']['total'] == 0)
        $this->_sections['item']['show'] = false;
} else
    $this->_sections['item']['total'] = 0;
if ($this->_sections['item']['show']):

            for ($this->_sections['item']['index'] = $this->_sections['item']['start'], $this->_sections['item']['iteration'] = 1;
                 $this->_sections['item']['iteration'] <= $this->_sections['item']['total'];
                 $this->_sections['item']['index'] += $this->_sections['item']['step'], $this->_sections['item']['iteration']++):
$this->_sections['item']['rownum'] = $this->_sections['item']['iteration'];
$this->_sections['item']['index_prev'] = $this->_sections['item']['index'] - $this->_sections['item']['step'];
$this->_sections['item']['index_next'] = $this->_sections['item']['index'] + $this->_sections['item']['step'];
$this->_sections['item']['first']      = ($this->_sections['item']['iteration'] == 1);
$this->_sections['item']['last']       = ($this->_sections['item']['iteration'] == $this->_sections['item']['total']);
?>
	    <tr>
	      <td width="0%" align="right" style="padding-left: 2px; padding-right: 2px;" nowrap class="box_text">
	      	<?php echo $this->_tpl_vars['o_ticket']->log->entries[$this->_sections['item']['index']]->log_timestamp; ?>
:
	      </td>
	      <td width="100%" style="padding-left: 2px;"><?php echo $this->_tpl_vars['o_ticket']->log->entries[$this->_sections['item']['index']]->log_text; ?>
</td>
	    </tr>
  	<?php endfor; endif; ?>
</table>
</div>
<br>
<?php endif; ?>