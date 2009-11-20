<?php /* Smarty version 2.5.0, created on 2007-01-15 21:55:27
         compiled from my_cerberus.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'my_cerberus.tpl.php', 1, false),)); ?><?php echo $this->_plugins['function']['assign'][0](array('var' => 'col_span','value' => '1'), $this) ; ?>

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
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("keyboard_shortcuts_jscript.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<script language="javascript" type="text/javascript" src="includes/scripts/listbox.js?v=<?php echo @constant('GUI_BUILD'); ?>
"></script>

</head>

<body bgcolor="#FFFFFF" OnLoad="load_init();" <?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->keyboard_shortcuts): ?>onkeypress="doShortcutsIE(window,event);"<?php endif; ?>>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("header.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<br>

<?php if ($this->_tpl_vars['mode'] == 'assign'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_assign.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'notification'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_notification.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'tasks'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_tasks.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'preferences'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_preferences.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'layout'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_layout.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'messages'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_messages.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php else: ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/tabs/my_cerberus_dashboard.tpl.php", array());
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