<?php /* Smarty version 2.5.0, created on 2007-01-16 09:17:17
         compiled from display/actions/thread_action_bounce.tpl.php */ ?>
<tr>
	
<form action="display.php" method="post">
	<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
">
	<input type="hidden" name="thread" value="<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
">
	<input type="hidden" name="form_submit" value="bounce">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	
	<td align="left" valign="middle">
			&nbsp;>Bounce to address: 
			<input type="input" name="forward_to" size="35" value=""> 
			<input type="checkbox" name="add_to_req" value="1"> Add to Ticket Requesters 
			<input type="submit" value="Send">
	</td>
	
	</form>
</tr>