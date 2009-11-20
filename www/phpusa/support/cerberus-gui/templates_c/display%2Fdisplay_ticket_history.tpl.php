<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/display_ticket_history.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'display/display_ticket_history.tpl.php', 33, false),)); ?><?php if (count ( $this->_tpl_vars['o_ticket']->support_history->history )): ?>

<?php echo '
<script type="text/javascript">
	function toggleDisplayHistory() {
		if (document.getElementById) {
			if(document.getElementById("ticket_display_history").style.display=="block") {
				document.getElementById("ticket_display_history").style.display="none";
				document.getElementById("ticket_display_history_icon").src=icon_expand.src;
				document.formSaveLayout.layout_display_show_history.value = 0;
			}
			else {
				document.getElementById("ticket_display_history").style.display="block";
				document.getElementById("ticket_display_history_icon").src=icon_collapse.src;
				document.formSaveLayout.layout_display_show_history.value = 1;
			}
		}
	}
</script>
'; ?>


<a href="#" onclick="javascript:toggleDisplayHistory();"><img alt="Toggle" id="ticket_display_history_icon" src="includes/images/<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_history']): ?>icon_collapse.gif<?php else: ?>icon_expand.gif<?php endif; ?>" width="16" height="16" border="0"></a>
<img alt="A scroll" src="includes/images/icone/16x16/scroll_view.gif" width="16" height="16">
<span class="link_ticket"><?php echo @constant('LANG_DISPLAY_CUST_HISTORY'); ?>
</span><br>
<table cellspacing="0" cellpadding="0" width="100%"><tr><td bgcolor="#DDDDDD"><img src="includes/images/spacer.gif" height="1" width="1" alt=""></td></tr></table>
<div id="ticket_display_history" style="display:<?php if (! empty ( $this->_tpl_vars['hp'] ) || $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_history']): ?>block<?php else: ?>none<?php endif; ?>;">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="ticket_display_table">
  	<?php if (isset($this->_sections['item'])) unset($this->_sections['item']);
$this->_sections['item']['name'] = 'item';
$this->_sections['item']['loop'] = is_array($this->_tpl_vars['o_ticket']->support_history->history) ? count($this->_tpl_vars['o_ticket']->support_history->history) : max(0, (int)$this->_tpl_vars['o_ticket']->support_history->history);
$this->_sections['item']['show'] = true;
$this->_sections['item']['max'] = $this->_sections['item']['loop'];
$this->_sections['item']['step'] = 1;
$this->_sections['item']['start'] = $this->_sections['item']['step'] > 0 ? 0 : $this->_sections['item']['loop']-1;
if ($this->_sections['item']['show']) {
    $this->_sections['item']['total'] = $this->_sections['item']['loop'];
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
		<td width="0%" nowrap class="td_small" align="right"><img alt="An envelope" src="includes/images/icone/16x16/mail2.gif" width="16" height="16" align="middle"></td>
		<td width="0%" nowrap class="td_small" align="right"><?php echo $this->_tpl_vars['o_ticket']->support_history->history[$this->_sections['item']['index']]->ticket_mask; ?>
</td>
		<td class="td_small" width="100%" style="padding-left: 2px; padding-right: 2px;">
			<a href="<?php echo $this->_tpl_vars['o_ticket']->support_history->history[$this->_sections['item']['index']]->ticket_url; ?>
" class="link_ticket_cmd"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['o_ticket']->support_history->history[$this->_sections['item']['index']]->ticket_subject); ?>
</a> 
			(<?php echo $this->_tpl_vars['o_ticket']->support_history->history[$this->_sections['item']['index']]->ticket_status; ?>
)
		</td>
		<td class="td_small" width="0%" nowrap align="right"><?php echo $this->_tpl_vars['o_ticket']->support_history->history[$this->_sections['item']['index']]->ticket_date; ?>
</td>
	</tr>
 	<?php endfor; endif; ?>
  
	<tr>
		<td colspan="4" align="right" class="td_small">
			<?php if ($this->_tpl_vars['o_ticket']->support_history->url_prev): ?>
				<a href="<?php echo $this->_tpl_vars['o_ticket']->support_history->url_prev; ?>
" class="link_ticket_cmd">&lt;&lt; <?php echo @constant('LANG_WORD_PREV'); ?>
 </a>
			<?php endif; ?>
			( <?php echo @constant('LANG_WORD_SHOWING'); ?>
 <?php echo $this->_tpl_vars['o_ticket']->support_history->history_from; ?>
-<?php echo $this->_tpl_vars['o_ticket']->support_history->history_to; ?>

			  <?php echo @constant('LANG_WORD_OF'); ?>
 <?php echo $this->_tpl_vars['o_ticket']->support_history->history_total; ?>
 )
			<?php if ($this->_tpl_vars['o_ticket']->support_history->url_next): ?>
				<a href="<?php echo $this->_tpl_vars['o_ticket']->support_history->url_next; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_WORD_NEXT'); ?>
 &gt;&gt;</a>
			<?php endif; ?>
		</td>
	</tr>
</table>
</div>
  
<br>
<?php endif; ?>
