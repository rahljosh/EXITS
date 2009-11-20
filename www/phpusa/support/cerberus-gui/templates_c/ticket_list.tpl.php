<?php /* Smarty version 2.5.0, created on 2007-01-15 18:54:13
         compiled from ticket_list.tpl.php */ ?>
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
<link rel="stylesheet" href="includes/cerberus_2006.css" type="text/css">
<link rel="stylesheet" href="skins/fresh/cerberus-theme.css" type="text/css">
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
<script type="text/javascript" src="includes/scripts/yahoo/animation.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/autocomplete.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dragdrop.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/container.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>

<script type="text/javascript" src="includes/scripts/cerb3/dashboard.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/quickworkflow.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/searchbuilder.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/knowledgebase.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>

<?php echo '
<script type="text/javascript">
	search_on = new Image;
	search_on.src = "includes/images/tab_search_on.gif";
	search_off = new Image;
	search_off.src = "includes/images/tab_search_off.gif";

	function toggleSearchBox() {
		if (document.getElementById) {
			if(document.getElementById("search").style.display=="block") {
				document.getElementById("search").style.display="none";
				document.getElementById("search_tab").src=search_off.src;
				document.formSaveLayout.layout_home_show_search.value = 0;
			}
			else {
				document.getElementById("search").style.display="block";
				document.getElementById("search_tab").src=search_on.src;
				document.formSaveLayout.layout_home_show_search.value = 1;
			}
		}
	}

	function init_home(e, obj) {
		load_init();
	}
	
	function savePageLayout() {
		// [JAS]: Force submit the form
		document.formSaveLayout.submit();
	}

	YAHOO.util.Event.addListener(window,"load",init_home);
</script>
'; ?>


</head>

<body bgcolor="#FFFFFF" <?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->keyboard_shortcuts): ?>onkeypress="doShortcutsIE(window,event);"<?php endif; ?>>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("header.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<table width="100%" cellspacing="1" cellpadding="3" border="0">
<form action="ticket_list.php" name="formSaveLayout" method="post" style="margin:0px;">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="form_submit" value="save_layout">
	
	<input type="hidden" name="layout_view_options_sv" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_view_options_sv']; ?>
">
	<input type="hidden" name="layout_home_show_queues" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_home_show_queues']; ?>
">
	<input type="hidden" name="layout_home_show_search" value="<?php echo $this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_home_show_search']; ?>
">
</form>
  <tr> 
    <td valign="top" width="0%" nowrap> 
		
		<span id="search_searchCriteriaList"></span>
		<script type="text/javascript">
			<?php echo '
			YAHOO.util.Event.addListener(window,"load",function() {
				doSearchCriteriaList(\'search\');
			});
			'; ?>

		</script>
		
	</td>
    <td valign="top" width="100%">
    	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("search/search_builder.tpl.php", array('label' => 'search'));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
    	<br>
    	
    	
    	
		<a name="results"></a>
		<span class="cer_display_header"><?php echo @constant('LANG_WORD_SEARCH_RESULTS'); ?>
</span>&nbsp;&nbsp;
		<span class="cer_maintable_text">Matched <?php echo $this->_tpl_vars['s_view']->show_of; ?>
 Tickets</span>&nbsp;&nbsp;
		<a href="#mass_actions" class="cer_maintable_text">Jump to Mass Actions</a>
		
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("views/ticket_view.tpl.php", array('view' => $this->_tpl_vars['s_view'],'col_span' => $this->_tpl_vars['s_view']->view_colspan));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<a name="mass_actions"></a>
    </td>
   </tr>
</table>

<br>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</body>
</html>