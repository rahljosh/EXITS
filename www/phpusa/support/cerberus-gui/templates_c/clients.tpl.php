<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:45
         compiled from clients.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'clients.tpl.php', 1, false),)); ?><?php echo $this->_plugins['function']['assign'][0](array('var' => 'col_span','value' => '1'), $this) ; ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><?php echo @constant('LANG_HTML_TITLE'); ?>
</title>
<META HTTP-EQUIV="content-type" CONTENT="<?php echo @constant('LANG_CHARSET'); ?>
">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV="Pragma-directive" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Directive" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("cerberus.css.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<link rel="stylesheet" href="skins/fresh/cerberus-theme.css" type="text/css">
<link rel="stylesheet" href="includes/cerberus_2006.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("keyboard_shortcuts_jscript.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

</head>

<body bgcolor="#FFFFFF" <?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->keyboard_shortcuts): ?>onkeypress="doShortcutsIE(window,event);"<?php endif; ?>>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("header.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<br>

<?php if (! empty ( $this->_tpl_vars['params']['mode'] ) && $this->_tpl_vars['params']['mode'] != 'search'): ?>

	<?php if ($this->_tpl_vars['params']['mode'] == 'c_view' && ! empty ( $this->_tpl_vars['params']['id'] )): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_view.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php elseif ($this->_tpl_vars['params']['mode'] == 'u_view' && ! empty ( $this->_tpl_vars['params']['id'] )): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_view.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php elseif ($this->_tpl_vars['params']['mode'] == 'c_add'): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_add.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php elseif ($this->_tpl_vars['params']['mode'] == 'u_add'): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_add.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
<?php else: ?>
	<span class="cer_display_header"><?php echo @constant('LANG_CONTACTS_HEADER'); ?>
</span><br>
	<span class="cer_maintable_text"><?php echo @constant('LANG_CONTACTS_INSTRUCTIONS'); ?>
</span><br>
	<br>
	
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_contact_search.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_list.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_list.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</body>
</html>