<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/display_ticket_suggestion.tpl.php */ ?>
<?php echo '
<script type="text/javascript">
	function toggleDisplaySuggestions() {
		if (document.getElementById) {
			if(document.getElementById("ticket_display_suggestions").style.display=="block") {
				document.getElementById("ticket_display_suggestions").style.display="none";
				document.getElementById("ticket_display_suggestions_icon").src=icon_expand.src;
				document.formSaveLayout.layout_display_show_suggestions.value = 0;
			}
			else {
				document.getElementById("ticket_display_suggestions").style.display="block";
				document.getElementById("ticket_display_suggestions_icon").src=icon_collapse.src;
				document.formSaveLayout.layout_display_show_suggestions.value = 1;
			}
		}
	}
</script>
'; ?>


<a href="#" onclick="javascript:toggleDisplaySuggestions();"><img alt="Toggle" id="ticket_display_suggestions_icon" src="includes/images/<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_suggestions']): ?>icon_collapse.gif<?php else: ?>icon_expand.gif<?php endif; ?>" width="16" height="16" border="0"></a>
<img alt="A document" src="includes/images/icone/16x16/document.gif" width="16" height="16">
<span class="link_ticket"><?php echo @constant('LANG_FNR_TITLE'); ?>
</span><br>
<table cellspacing="0" cellpadding="0" width="100%"><tr><td bgcolor="#DDDDDD"><img alt="" src="includes/images/spacer.gif" height="1" width="1"></td></tr></table>
<div id="ticket_display_suggestions" style="display:<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_suggestions']): ?>block<?php else: ?>none<?php endif; ?>;">
<?php if (! empty ( $this->_tpl_vars['fnrArticles'] )): ?>
	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("knowledgebase/kb_article_list2.tpl.php", array('articles' => $this->_tpl_vars['fnrArticles']));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php else: ?>
	No matching articles.  Try adding some tags to this ticket.
<?php endif; ?>
</div>
<br>