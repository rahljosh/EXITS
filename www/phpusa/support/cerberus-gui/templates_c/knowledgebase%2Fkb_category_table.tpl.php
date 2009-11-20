<?php /* Smarty version 2.5.0, created on 2007-01-15 18:46:31
         compiled from knowledgebase/kb_category_table.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'knowledgebase/kb_category_table.tpl.php', 6, false),
array('function', 'math', 'knowledgebase/kb_category_table.tpl.php', 19, false),
array('modifier', 'cat', 'knowledgebase/kb_category_table.tpl.php', 9, false),
array('modifier', 'cer_href', 'knowledgebase/kb_category_table.tpl.php', 9, false),)); ?><span class="cer_display_header">Categories:</span> 
<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_KB_EDIT'))): ?><span class=""><a href="javascript:popupResourceCategories();">manage</a><?php endif; ?>
<br>


<?php echo $this->_plugins['function']['assign'][0](array('var' => 'ancestors','value' => $this->_tpl_vars['kb_root']->getAncestors(1)), $this) ; ?>

<?php if (count((array)$this->_tpl_vars['ancestors'])):
    foreach ((array)$this->_tpl_vars['ancestors'] as $this->_tpl_vars['ans_id'] => $this->_tpl_vars['ans']):
?>
	<?php if ($this->_tpl_vars['ans_id']): ?>
		<a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "knowledgebase.php?root=", $this->_tpl_vars['ans_id'])); ?>
" class="cer_knowledgebase_link"><?php echo $this->_tpl_vars['kb']->flat_categories[$this->_tpl_vars['ans_id']]->name; ?>
</a> : 
	<?php else: ?>
		<a href="knowledgebase.php?root=0" class="cer_knowledgebase_link">Top</a> ::  
	<?php endif; ?>
<?php endforeach; endif; ?>

<table cellpadding="0" cellspacing="10" border="0" width="100%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="1" cellspacing="0" border="0" style="padding-right:2px;border-right:1px dashed #dddddd">
				<?php echo $this->_plugins['function']['math'][0](array('assign' => 'middle','equation' => "ceil(x/2)",'x' => $this->_tpl_vars['kb_root']->getChildCount()), $this) ; ?>

				<?php if (0 != count ( $this->_tpl_vars['kb_root']->children )): ?>
				<?php if (isset($this->_foreach['categories'])) unset($this->_foreach['categories']);
$this->_foreach['categories']['name'] = 'categories';
$this->_foreach['categories']['total'] = count((array)$this->_tpl_vars['kb_root']->children);
$this->_foreach['categories']['show'] = $this->_foreach['categories']['total'] > 0;
if ($this->_foreach['categories']['show']):
$this->_foreach['categories']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['kb_root']->children as $this->_tpl_vars['category_id'] => $this->_tpl_vars['category']):
        $this->_foreach['categories']['iteration']++;
        $this->_foreach['categories']['first'] = ($this->_foreach['categories']['iteration'] == 1);
        $this->_foreach['categories']['last']  = ($this->_foreach['categories']['iteration'] == $this->_foreach['categories']['total']);
?>
					<tr>
						<td colspan="2"><img src="includes/images/icone/16x16/folder.gif" align="absmiddle"><img src="includes/images/spacer.gif" width="5" height="1" align="absmiddle"><a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "knowledgebase.php?root=", $this->_tpl_vars['category']->id)); ?>
" class="kb_category"><b><?php echo $this->_tpl_vars['category']->name; ?>
</b></a> (<?php echo $this->_tpl_vars['category']->hits; ?>
)</td>
					</tr>
					
					
					<?php echo $this->_plugins['function']['assign'][0](array('var' => 'articles','value' => $this->_tpl_vars['category']->getMostViewedArticles(5)), $this) ; ?>

					<?php if (count((array)$this->_tpl_vars['articles'])):
    foreach ((array)$this->_tpl_vars['articles'] as $this->_tpl_vars['article_id'] => $this->_tpl_vars['article']):
?>
					<tr>
						<td width="100%"><img src="includes/images/icone/16x16/document.gif" align="absmiddle" alt="article"> <a href="javascript:popupResource(<?php echo $this->_tpl_vars['article']->id; ?>
);" class="cer_knowledgebase_link"><?php echo $this->_tpl_vars['article']->name; ?>
</a></td>
						<td align="right" width="0%" nowrap="nowrap">&nbsp;</td>
					</tr>
					<?php endforeach; endif; ?>
					
					<tr>
						<td width="100%">&nbsp;</td>
						<td width="0%">&nbsp;</td>
					</tr>
					
					
					<?php if ($this->_foreach['categories']['iteration'] == $this->_tpl_vars['middle']): ?>
							</table>
						</td>
						<td width="50%" valign="top">
							<table cellpadding="1" cellspacing="0" border="0" style="padding-right:2px;border-right:1px dashed #dddddd">
					<?php endif; ?>
				<?php endforeach; endif; ?>
				
				<?php else: ?>
					<tr>
						<td width="100%"><span class="cer_knowledgebase_link"><i>Category <b><?php echo $this->_tpl_vars['kb_root']->name; ?>
</b> has no subcategories.</i></span></td>
						<td width="0%">&nbsp;</td>
					</tr>
				
				<?php endif; ?>
			
			</table>
		</td>
	</tr>
</table>