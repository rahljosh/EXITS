<?php /* Smarty version 2.5.0, created on 2007-01-19 08:20:41
         compiled from home/getwork/work_list.tpl.php */ ?>
<?php if (count ( $this->_tpl_vars['tickets'] )): ?>
<?php if (isset($this->_foreach['tickets'])) unset($this->_foreach['tickets']);
$this->_foreach['tickets']['name'] = 'tickets';
$this->_foreach['tickets']['total'] = count((array)$this->_tpl_vars['tickets']);
$this->_foreach['tickets']['show'] = $this->_foreach['tickets']['total'] > 0;
if ($this->_foreach['tickets']['show']):
$this->_foreach['tickets']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['tickets'] as $this->_tpl_vars['ticket']):
        $this->_foreach['tickets']['iteration']++;
        $this->_foreach['tickets']['first'] = ($this->_foreach['tickets']['iteration'] == 1);
        $this->_foreach['tickets']['last']  = ($this->_foreach['tickets']['iteration'] == $this->_foreach['tickets']['total']);
?>
<div id="getwork<?php echo $this->_tpl_vars['ticket']->id; ?>
" style="opacity:1.0;">
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/getwork/work_list_item.tpl.php", array('ticket' => $this->_tpl_vars['ticket']));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</div>
<?php endforeach; endif; ?>
<?php endif; ?>