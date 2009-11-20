<?php /* Smarty version 2.5.0, created on 2007-02-28 15:01:44
         compiled from print/printdisplay.tpl.php */ ?>
<html>
<head>
<title><?php echo @constant('LANG_ACTION_PRINT_TITLE'); ?>
</title>
<META HTTP-EQUIV="content-type" CONTENT="<?php echo @constant('LANG_CHARSET'); ?>
">
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("cerberus.css.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</head>

<body bgcolor="#FFFFFF">
<br>
<?php if ($this->_tpl_vars['printlevel'] == 'ticket'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("print/print_ticket.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
        <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("print/printfooter.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php elseif ($this->_tpl_vars['printlevel'] == 'thread'): ?>	
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("print/print_thread.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
        <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("print/printfooter.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php else: ?>
	<?php echo '
	  <script language="javascript" type="text/javascript">
		window.close();
	  </script>
	'; ?>

<?php endif; ?>

</body>
</html>