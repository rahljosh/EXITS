<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/boxes/box_quick_workflow.tpl.php */ ?>
<form id="frmQuickWorkflowSearch_<?php echo $this->_tpl_vars['ticketId']; ?>
" name="frmQuickWorkflowSearch_<?php echo $this->_tpl_vars['ticketId']; ?>
" action="#" method="POST" style="margin:0px;">
<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['ticketId']; ?>
">
<input type="hidden" name="cmd" value="workflow_set">
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("widgets/quickworkflow/quickworkflow.tpl.php", array('jvar' => 'ticketWorkflow','label' => $this->_tpl_vars['ticketId']));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</form>