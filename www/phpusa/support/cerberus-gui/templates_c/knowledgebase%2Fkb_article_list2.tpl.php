<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:58
         compiled from knowledgebase/kb_article_list2.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'strip_tags', 'knowledgebase/kb_article_list2.tpl.php', 18, false),
array('modifier', 'short_escape', 'knowledgebase/kb_article_list2.tpl.php', 18, false),
array('modifier', 'truncate', 'knowledgebase/kb_article_list2.tpl.php', 18, false),)); ?><?php if (count ( $this->_tpl_vars['articles'] ) > 0): ?>
	<table width="100%" border="0" cellspacing="1" cellpadding="1" class="ticket_display_table">
    		<tr> 
	        <td width="0%" nowrap></td>
	        <td width="100%"><b><?php echo @constant('LANG_KB_SUMMARY'); ?>
</b></td>
	        <td width="0%" nowrap><b>Relevance</b></td>
       	</tr>
	    	
 			<?php if (isset($this->_foreach['articles'])) unset($this->_foreach['articles']);
$this->_foreach['articles']['name'] = 'articles';
$this->_foreach['articles']['total'] = count((array)$this->_tpl_vars['articles']);
$this->_foreach['articles']['show'] = $this->_foreach['articles']['total'] > 0;
if ($this->_foreach['articles']['show']):
$this->_foreach['articles']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['articles'] as $this->_tpl_vars['article']):
        $this->_foreach['articles']['iteration']++;
        $this->_foreach['articles']['first'] = ($this->_foreach['articles']['iteration'] == 1);
        $this->_foreach['articles']['last']  = ($this->_foreach['articles']['iteration'] == $this->_foreach['articles']['total']);
?>
        <tr>
          <td width="0%" align="right" nowrap>&nbsp;</td>
          <td width="100%"> 
          	<table cellpadding="0" cellspacing="0" border="0">
          		<tr>
          			<td valign="middle" align="center"><img alt="" src="includes/images/spacer.gif" width="4" height="1"><img alt="A document" src="includes/images/icone/16x16/document.gif" width="16" height="16" align="middle"><img alt="" src="includes/images/spacer.gif" width="6" height="1"></td>
          			<td valign="top">
						<a href="javascript:popupResource(<?php echo $this->_tpl_vars['article']->article_id; ?>
);" class="link_ticket_cmd"><?php echo $this->_tpl_vars['article']->article_title; ?>
</a><br>
			         		<?php echo $this->_run_mod_handler('truncate', true, $this->_run_mod_handler('short_escape', true, $this->_run_mod_handler('strip_tags', true, $this->_tpl_vars['articles'][$this->_sections['article']['index']]->article_brief)), 150); ?>

         			</td>
         		</tr>
         	</table>
			</td>
			<td width="0%" valign="middle" align="center" nowrap><?php echo $this->_tpl_vars['article']->article_relevance; ?>
%</td>
        </tr>
			<?php endforeach; endif; ?>
			
	</table>

<?php else: ?>
		<br>
		<i><?php echo @constant('LANG_KB_ARTICLE_NO_ARTICLES'); ?>
</i>
		<br>
<?php endif; ?>