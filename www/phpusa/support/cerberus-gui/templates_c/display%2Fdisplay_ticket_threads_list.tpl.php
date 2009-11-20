<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:13
         compiled from display/display_ticket_threads_list.tpl.php */ ?>
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

	<?php if ($this->_tpl_vars['thread_ptr']->type == 'ws_comment'): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_threads_wscomment.tpl.php", array('oStep' => $this->_tpl_vars['thread_ptr']->ptr));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php elseif ($this->_tpl_vars['thread_ptr']->type == 'time'): ?>
		<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE')) || $this->_tpl_vars['thread_ptr']->ptr->working_agent_id == $this->_tpl_vars['session']->vars['login_handler']->user_id): ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_threads_time.tpl.php", array('oThread' => $this->_tpl_vars['thread_ptr']->ptr));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_threads_time_editable.tpl.php", array('oThread' => $this->_tpl_vars['thread_ptr']->ptr));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<?php endif; ?>
	<?php else: ?> 
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_threads_activity.tpl.php", array('oThread' => $this->_tpl_vars['thread_ptr']->ptr));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
  
<?php endforeach; endif; ?>