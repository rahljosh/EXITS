<?php /* Smarty version 2.5.0, created on 2007-01-16 12:27:44
         compiled from getwork.tpl.php */ ?>

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
<?php if ($this->_tpl_vars['do_meta_refresh']): ?>
<META HTTP-EQUIV="Refresh" content="<?php echo $this->_tpl_vars['refresh_sec']; ?>
;URL=<?php echo $this->_tpl_vars['refresh_url']; ?>
">
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("cerberus.css.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<link rel="stylesheet" href="includes/cerberus_2006.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="skins/fresh/cerberus-theme.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="includes/css/calendar.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("keyboard_shortcuts_jscript.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<script type="text/javascript" src="includes/scripts/yahoo/YAHOO.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/event.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/connection.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dom.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/animation.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/autocomplete.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/getwork.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/calendar.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/quickworkflow.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/ticket.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/knowledgebase.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
</head>

<body bgcolor="#FFFFFF" <?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->keyboard_shortcuts): ?>onkeypress="doShortcutsIE(window,event);"<?php endif; ?>>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("header.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<form name="spellform" method="POST" target="spellWindow" action="includes/elements/spellcheck/spellcheck.php" style="margin:0px;">
<input type="hidden" name="caller" value="">
<input type="hidden" name="spellstring" value="">
</form>

<br>
<form action="getwork.php" name="formSaveLayout" method="post">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="form_submit" value="save_layout">
</form>
<table width="100%" border="0" cellspacing="5" cellpadding="1">
  <tr> 
   <td valign="top" width="0%" nowrap> 
	</td>
    <td valign="top" width="100%">
    <form action="getwork.php" method="post">
		Work mode: 
		<select name="mode" class="box_text" onchange="this.form.submit();">
		  <option value="quickassign" <?php if ($this->_tpl_vars['mode'] == 'quickassign' || $this->_tpl_vars['mode'] == ""): ?>selected<?php endif; ?>>Quick Assign</option>
		  <option value="monitor" <?php if ($this->_tpl_vars['mode'] == 'monitor'): ?>selected<?php endif; ?>>Monitor</option>
		</select>
		<input type="submit" value="Switch" class="cer_button_face" />
		
		<a href="javascript:;" onclick="createTicket();" class="box_text">create new ticket</a>
		<br />
		</form>

		<span id="divCreateTicket"></span>
		
		<?php if ($this->_tpl_vars['mode'] == 'monitor'): ?>
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/getwork/monitor.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<?php else: ?>
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/getwork/quick_assign.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<?php endif; ?>
		
		<br>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/whos_online_box.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		
    </td>
  </tr>
</table>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php if ($this->_tpl_vars['run_cron'] === true): ?>
	<script type="text/javascript">
		YAHOO.util.Event.addListener(window,"load",runScheduledTasks);
	</script>
<?php endif; ?>
</body>
</html>