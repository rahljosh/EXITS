<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/display_ticket_active_modules.tpl.php */ ?>


<?php if (isset($this->_foreach['module'])) unset($this->_foreach['module']);
$this->_foreach['module']['name'] = 'module';
$this->_foreach['module']['total'] = count((array)$this->_tpl_vars['user_layout']->layout_pages['display']->params['display_modules']);
$this->_foreach['module']['show'] = $this->_foreach['module']['total'] > 0;
if ($this->_foreach['module']['show']):
$this->_foreach['module']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['user_layout']->layout_pages['display']->params['display_modules'] as $this->_tpl_vars['module']):
        $this->_foreach['module']['iteration']++;
        $this->_foreach['module']['first'] = ($this->_foreach['module']['iteration'] == 1);
        $this->_foreach['module']['last']  = ($this->_foreach['module']['iteration'] == $this->_foreach['module']['total']);
?>

	<?php if ($this->_tpl_vars['module'] == 'workflow'): ?>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_workflow.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['module'] == 'history'): ?>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_history.tpl.php", array('col_span' => 7));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
	
		
		
	
	
	<?php if ($this->_tpl_vars['module'] == 'suggestions'): ?>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_suggestion.tpl.php", array('col_span' => 7));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['module'] == 'log'): ?>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_audit_log.tpl.php", array('col_span' => 3));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>

	<?php if ($this->_tpl_vars['module'] == 'fields'): ?>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_custom_fields.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['module'] == 'threads'): ?>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_threads.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>

<?php endforeach; endif; ?>