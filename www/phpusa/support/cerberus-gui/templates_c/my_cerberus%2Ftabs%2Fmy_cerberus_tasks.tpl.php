<?php /* Smarty version 2.5.0, created on 2007-01-16 11:45:40
         compiled from my_cerberus/tabs/my_cerberus_tasks.tpl.php */ ?>
<?php if (! empty ( $this->_tpl_vars['dashboard']->tasks->active_project ) && ! empty ( $this->_tpl_vars['dashboard']->tasks->active_project->active_task )): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_tasks_view.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php elseif (! empty ( $this->_tpl_vars['dashboard']->tasks->active_project )): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_tasks_project_focus.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_tasks_create.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php else: ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_tasks_list.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_tasks_create_project.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php endif; ?>