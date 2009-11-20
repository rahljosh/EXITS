<?php /* Smarty version 2.5.0, created on 2007-01-15 18:46:31
         compiled from knowledgebase.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'knowledgebase.tpl.php', 60, false),
array('modifier', 'cer_href', 'knowledgebase.tpl.php', 61, false),)); ?><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<link rel="stylesheet" href="includes/css/container.css?v=<?php echo @constant('GUI_BUILD'); ?>
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
<script type="text/javascript" src="includes/scripts/yahoo/autocomplete.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dragdrop.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/container.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>

<script type="text/javascript" src="includes/scripts/cerb3/quickworkflow.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/knowledgebase.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/kbsearchbuilder.js?v=<?php echo @constant('GUI_BUILD'); ?>
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

<br>

<!---
Tags:<br>
<span class="searchdiv">
<textarea name="tag_input" id="tag_input" class="search_input" style="width:300px;height:80px;"></textarea>
<div class="searchshadow"><div id="searchcontainer" class="searchcontainer"></div></div>
</span>
<br>
--->

<span class="cer_display_header"><?php echo @constant('LANG_WORD_KNOWLEDGEBASE'); ?>
</span><br>
<form style="margin:0px">
<input type="hidden" name="form_submit" value="kb_search">
<img src="includes/images/icone/16x16/view.gif"> <b>Search:</b> <input type="text" name="kb_keywords" value="<?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['kb_keyword_string']); ?>
" size="45"><input type="submit" value="Go!"> <!---(<a href="#">advanced search</a>)--->
<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_KB_EDIT'))): ?><input type="button" onclick="document.location='<?php echo $this->_run_mod_handler('cer_href', true, "knowledgebase.php?mode=edit_entry&kbid=0"); ?>
';" value="Add Article"><?php endif; ?>
<br>
</form>


<?php if ($this->_tpl_vars['mode'] == 'browse'): ?>
	
	
	
	<br>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_category_table.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_resource_list.tpl.php", array('resources' => $this->_tpl_vars['kb_root']->getResources(500)));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php endif; ?>


<?php if ($this->_tpl_vars['mode'] == 'keyword_results'): ?>
	<br>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_article_results.tpl.php", array('articles' => $this->_tpl_vars['articles']));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php endif; ?>


<?php if ($this->_tpl_vars['mode'] == 'create'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_article_edit.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php endif; ?>
		


<?php if ($this->_tpl_vars['mode'] == 'edit_entry'): ?>
	<?php if ($this->_tpl_vars['kb']->show_article_edit !== false): ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_article_edit.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
<?php endif; ?>


<?php if ($this->_tpl_vars['mode'] == 'view_entry'): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_article_view.tpl.php", array());
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
<span id="dynamicKbResource" style="visibility:hidden">
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