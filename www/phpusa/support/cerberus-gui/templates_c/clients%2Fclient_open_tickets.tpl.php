<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:46
         compiled from clients/client_open_tickets.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'clients/client_open_tickets.tpl.php', 9, false),)); ?>
<?php if (! empty ( $this->_tpl_vars['summary']->tickets )): ?>

	<a name="tickets"></a>
	
	<table border="0" cellspacing="1" cellpadding="3" bgcolor="#888888" width="100%">

		<tr>
			<td class="boxtitle_blue_glass_pale" colspan="6"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['summary']->summary_title); ?>
</td>
		</tr>
	
		<tr bgcolor="#CCCCCC">
			<td class="cer_maintable_headingSM">#</td>
			<td class="cer_maintable_headingSM">Subject</td>
			<td class="cer_maintable_headingSM">Queue</td>
			<td class="cer_maintable_headingSM">Last Wrote</td>
			<td class="cer_maintable_headingSM">Age</td>
			<td class="cer_maintable_headingSM">Due</td>
		</tr>
	
		<?php if (isset($this->_foreach['ticket'])) unset($this->_foreach['ticket']);
$this->_foreach['ticket']['name'] = 'ticket';
$this->_foreach['ticket']['total'] = count((array)$this->_tpl_vars['summary']->tickets);
$this->_foreach['ticket']['show'] = $this->_foreach['ticket']['total'] > 0;
if ($this->_foreach['ticket']['show']):
$this->_foreach['ticket']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['summary']->tickets as $this->_tpl_vars['ticket_id'] => $this->_tpl_vars['ticket']):
        $this->_foreach['ticket']['iteration']++;
        $this->_foreach['ticket']['first'] = ($this->_foreach['ticket']['iteration'] == 1);
        $this->_foreach['ticket']['last']  = ($this->_foreach['ticket']['iteration'] == $this->_foreach['ticket']['total']);
?>
	
			<tr bgcolor="#<?php if ($this->_foreach['ticket']['iteration'] % 2 == 0): ?>EEEEEE<?php else: ?>F5F5F5<?php endif; ?>">
				<td class="cer_footer_text">#<?php echo $this->_tpl_vars['ticket']->ticket_mask; ?>
</td>
				<td class="cer_maintable_text"><a href="<?php echo $this->_tpl_vars['ticket']->ticket_url; ?>
" class="cer_maintable_heading"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['ticket']->ticket_subject); ?>
</a></td>
				<td class="cer_footer_text"><a href="<?php echo $this->_tpl_vars['ticket']->queue_url; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['ticket']->queue_name; ?>
</a></td>
				<td class="cer_footer_text"><?php echo $this->_tpl_vars['ticket']->ticket_last_wrote_address; ?>
</td>
				<td class="cer_maintable_text"><?php echo $this->_tpl_vars['ticket']->ticket_age; ?>
</td>
				<td class="cer_maintable_text"><?php echo $this->_tpl_vars['ticket']->ticket_due; ?>
</td>
			</tr>
	
		<?php endforeach; endif; ?>
	
	</table>

	<br>
	
<?php endif; ?>