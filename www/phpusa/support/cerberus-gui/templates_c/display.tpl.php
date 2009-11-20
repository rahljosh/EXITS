<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:06
         compiled from display.tpl.php */ ?>
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
<link rel="stylesheet" href="skins/fresh/cerberus-theme.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="includes/cerberus_2006.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="includes/css/calendar.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="includes/css/container.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css"> 

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("keyboard_shortcuts_jscript.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<script type="text/javascript" src="includes/scripts/yahoo/YAHOO.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dom.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/event.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/logger.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/connection.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/autocomplete.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dragdrop.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/container.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/display.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/knowledgebase.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/calendar.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/quickworkflow.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>

<script language="javascript" type="text/javascript" src="includes/scripts/tiny_mce/tiny_mce.js?v=<?php echo @constant('GUI_BUILD'); ?>
"></script>

<?php echo '
<script language="javascript" type="text/javascript">
	tinyMCE.init({
		theme : "advanced",
		editor_selector : "mceEditor"
	});
</script>
'; ?>


</head>

<body bgcolor="#FFFFFF" <?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->keyboard_shortcuts): ?>onkeypress="doShortcutsIE(window,event);"<?php endif; ?>>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("header.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<script type="text/javascript">
<?php echo '
	function savePageLayout() {
		// [JAS]: Force submit the form
		document.formSaveLayout.submit();
	}
'; ?>

	
var ticketWorkflow = new CerQuickWorkflow('<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
','frmQuickWorkflowSearch_<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
');
<?php echo '
ticketWorkflow.postResultsAction = function() {
	this.refresh();
}
ticketWorkflow.postAddTagAction = function() {
	getFnrSuggestions(\''; ?>
<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
<?php echo '\');
}

// Overload!
doPostRemoveTagAction = function(id) {
	if(null == getFnrSuggestions) return;
	getFnrSuggestions(id);
}
'; ?>

</script>

<form name="spellform" method="POST" target="spellWindow" action="includes/elements/spellcheck/spellcheck.php" style="margin:0px;">
<input type="hidden" name="caller" value="">
<input type="hidden" name="spellstring" value="">
</form>

<br>

<a name="top"></a>

<form action="display.php" name="formSaveLayout" method="post">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="form_submit" value="save_layout">
	<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
">
	<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['mode']; ?>
">
	<input type="hidden" name="layout_display_show_log" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_log']; ?>
">
	<input type="hidden" name="layout_display_show_suggestions" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_suggestions']; ?>
">
	<input type="hidden" name="layout_display_show_history" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_history']; ?>
">
	<input type="hidden" name="layout_display_show_workflow" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_workflow']; ?>
">
	<input type="hidden" name="layout_display_show_contact" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_contact']; ?>
">
	<input type="hidden" name="layout_display_show_fields" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_fields']; ?>
">
  	<input type="hidden" name="layout_view_options_bv" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_view_options_bv']; ?>
">
</form>

<?php if ($this->_tpl_vars['mode'] == 'tkt_fields' || $this->_tpl_vars['mode'] == 'properties'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

	<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/tabs/display_ticket_merge.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>

<?php elseif ($this->_tpl_vars['mode'] == 'anti_spam'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/tabs/display_ticket_antispam.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'batch'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/tabs/display_ticket_batch.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php elseif ($this->_tpl_vars['mode'] == 'log'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/tabs/display_ticket_log.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php else: ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<form style="margin:0px;" id="fnrResourceForm">
<span id="dynamicKbResource" style="visibility:visible">
		<div class="hd"></div>
		<div class="bd"></div>
		<div class="ft"></div>
</span>
</form>

<span id="dynamicKbCategories" style="visibility:hidden">
		<div class="hd"></div>
		<div class="bd"></div>
		<div class="ft"></div>
</span>

</body>
</html>