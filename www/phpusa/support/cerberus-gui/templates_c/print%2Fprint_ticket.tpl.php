<?php /* Smarty version 2.5.0, created on 2007-02-28 15:01:44
         compiled from print/print_ticket.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'print/print_ticket.tpl.php', 1, false),
array('modifier', 'short_escape', 'print/print_ticket.tpl.php', 10, false),
array('modifier', 'replace', 'print/print_ticket.tpl.php', 48, false),
array('modifier', 'nl2br', 'print/print_ticket.tpl.php', 48, false),)); ?><?php echo $this->_plugins['function']['assign'][0](array('var' => 'show_r_fields','value' => $this->_tpl_vars['o_ticket']->r_field_handler->group_instances), $this) ; ?>

<?php echo $this->_plugins['function']['assign'][0](array('var' => 'show_t_fields','value' => $this->_tpl_vars['o_ticket']->t_field_handler->group_instances), $this) ; ?>

<center><form><input type=button onClick="javascript: window.print();" value="<?php echo @constant('LANG_ACTION_PRINT_SUBMIT'); ?>
">&nbsp;&nbsp;<input type=button onClick="javascript: window.close();" value="<?php echo @constant('LANG_ACTION_PRINT_CLOSE_WINDOW'); ?>
"><?php if ($this->_tpl_vars['show_r_fields'] || $this->_tpl_vars['show_t_fields']): ?>&nbsp;&nbsp;<input type=button onClick="javascript: toggleCustomFields();" value="<?php echo @constant('LANG_ACTION_PRINT_HIDE_CUSTOM_FIELDS'); ?>
"><?php endif; ?></form></center>
<center><h1>Ticket #<?php echo $this->_tpl_vars['o_ticket']->ticket_mask_id; ?>
</h1></center>
<hr size=5 color=black>
<table>
<tr><td align=left><b><?php echo @constant('LANG_WORD_FROM'); ?>
:&nbsp;&nbsp;</b></td><td><?php if (isset($this->_sections['address'])) unset($this->_sections['address']);
$this->_sections['address']['name'] = 'address';
$this->_sections['address']['loop'] = is_array($this->_tpl_vars['o_ticket']->requesters->addresses) ? count($this->_tpl_vars['o_ticket']->requesters->addresses) : max(0, (int)$this->_tpl_vars['o_ticket']->requesters->addresses);
$this->_sections['address']['show'] = true;
$this->_sections['address']['max'] = $this->_sections['address']['loop'];
$this->_sections['address']['step'] = 1;
$this->_sections['address']['start'] = $this->_sections['address']['step'] > 0 ? 0 : $this->_sections['address']['loop']-1;
if ($this->_sections['address']['show']) {
    $this->_sections['address']['total'] = $this->_sections['address']['loop'];
    if ($this->_sections['address']['total'] == 0)
        $this->_sections['address']['show'] = false;
} else
    $this->_sections['address']['total'] = 0;
if ($this->_sections['address']['show']):

            for ($this->_sections['address']['index'] = $this->_sections['address']['start'], $this->_sections['address']['iteration'] = 1;
                 $this->_sections['address']['iteration'] <= $this->_sections['address']['total'];
                 $this->_sections['address']['index'] += $this->_sections['address']['step'], $this->_sections['address']['iteration']++):
$this->_sections['address']['rownum'] = $this->_sections['address']['iteration'];
$this->_sections['address']['index_prev'] = $this->_sections['address']['index'] - $this->_sections['address']['step'];
$this->_sections['address']['index_next'] = $this->_sections['address']['index'] + $this->_sections['address']['step'];
$this->_sections['address']['first']      = ($this->_sections['address']['iteration'] == 1);
$this->_sections['address']['last']       = ($this->_sections['address']['iteration'] == $this->_sections['address']['total']);
?><?php echo $this->_tpl_vars['o_ticket']->requesters->addresses[$this->_sections['address']['index']]->address_address; ?>
; <?php endfor; endif; ?></td></tr> 
<tr><td align=left><b>Queue:&nbsp;&nbsp;</b></td><td><?php echo $this->_tpl_vars['o_ticket']->ticket_queue_name; ?>
</td></tr>
<tr><td align=left><b><?php echo @constant('LANG_WORD_DATE'); ?>
:&nbsp;&nbsp;</b></td><td><?php echo $this->_tpl_vars['o_ticket']->ticket_date; ?>
</td></tr>
<tr><td align=left><b><?php echo @constant('LANG_WORD_SUBJECT'); ?>
:&nbsp;&nbsp;</b></td><td><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['o_ticket']->ticket_subject); ?>
</td></tr>
<?php if ($this->_tpl_vars['show_r_fields'] || $this->_tpl_vars['show_t_fields']): ?>
<?php echo '
<script type="text/javascript">
	function toggleCustomFields() {
		if (document.getElementById) {
			if(document.getElementById("ticket_custom_fields").style.display=="block") {
				document.getElementById("ticket_custom_fields").style.display="none";
			}
			else {
				document.getElementById("ticket_custom_fields").style.display="block";
			}
		}
	}
</script>
'; ?>

<tr><td colspan=2>
<div id="ticket_custom_fields" style="display:block">
<br>
<hr size=3 color=black>
<table width="100%">
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("print/print_custom_fields.tpl.php", array('field_handler' => $this->_tpl_vars['o_ticket']->r_field_handler));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php if ($this->_tpl_vars['show_r_fields'] && $this->_tpl_vars['show_t_fields']): ?>
<tr><td colspan=2><hr size=3 color=black></td></tr>
<?php endif; ?>
<?php if ($this->_tpl_vars['show_t_fields']): ?>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("print/print_custom_fields.tpl.php", array('field_handler' => $this->_tpl_vars['o_ticket']->t_field_handler));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php endif; ?>
</table>
<hr size=3 color=black>
</div>
</td></tr>
<?php endif; ?>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td colspan=2>&nbsp;</td></tr>
</table><table>
<?php if (isset($this->_foreach['thread'])) unset($this->_foreach['thread']);
$this->_foreach['thread']['name'] = 'thread';
$this->_foreach['thread']['total'] = count((array)$this->_tpl_vars['o_ticket']->threads);
$this->_foreach['thread']['show'] = $this->_foreach['thread']['total'] > 0;
if ($this->_foreach['thread']['show']):
$this->_foreach['thread']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['o_ticket']->threads as $this->_tpl_vars['thread_ptr']):
        $this->_foreach['thread']['iteration']++;
        $this->_foreach['thread']['first'] = ($this->_foreach['thread']['iteration'] == 1);
        $this->_foreach['thread']['last']  = ($this->_foreach['thread']['iteration'] == $this->_foreach['thread']['total']);
?>
	<?php if ($this->_tpl_vars['thread_ptr']->type == 'email' || $this->_tpl_vars['thread_ptr']->type == 'comment'): ?>
		<tr><td>&nbsp;</td><td><hr color=black size=1><b><?php echo $this->_tpl_vars['thread_ptr']->ptr->thread_display_author; ?>
 - </b><br><br><?php echo $this->_run_mod_handler('nl2br', true, $this->_run_mod_handler('replace', true, $this->_run_mod_handler('replace', true, $this->_tpl_vars['thread_ptr']->ptr->thread_content, "<", "&lt;"), ">", "&gt;")); ?>
<br><hr color=black size=1></td></tr>
	<?php endif; ?>
<?php endforeach; endif; ?>
</table>
<BR>
<BR>
<BR>
<BR>
<hr size=5 color=black>

