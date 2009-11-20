<?php /* Smarty version 2.5.0, created on 2007-01-15 18:46:32
         compiled from knowledgebase/kb_resource_list.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'math', 'knowledgebase/kb_resource_list.tpl.php', 25, false),)); ?><span class="cer_display_header"><?php if (isset ( $this->_tpl_vars['kb_root'] ) && 0 == $this->_tpl_vars['kb_root']->id): ?>Uncategorized <?php endif; ?>Resources:</span><br>

<?php if (count ( $this->_tpl_vars['resources'] ) > 0): ?>
	<table width="100%" border="0" cellspacing="1" cellpadding="1" class="ticket_display_table">
    	<tr> 
	        <td width="100%"><b><?php echo @constant('LANG_KB_SUMMARY'); ?>
</b></td>
	        <td width="0%" align="center" nowrap><B>User Rating</B></td>
       	</tr>
	    	
 		<?php if (isset($this->_foreach['resources'])) unset($this->_foreach['resources']);
$this->_foreach['resources']['name'] = 'resources';
$this->_foreach['resources']['total'] = count((array)$this->_tpl_vars['resources']);
$this->_foreach['resources']['show'] = $this->_foreach['resources']['total'] > 0;
if ($this->_foreach['resources']['show']):
$this->_foreach['resources']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['resources'] as $this->_tpl_vars['resource']):
        $this->_foreach['resources']['iteration']++;
        $this->_foreach['resources']['first'] = ($this->_foreach['resources']['iteration'] == 1);
        $this->_foreach['resources']['last']  = ($this->_foreach['resources']['iteration'] == $this->_foreach['resources']['total']);
?>
        <tr <?php if (0 != $this->_foreach['resources']['iteration'] % 2): ?>class="ticket_display_table_odd"<?php endif; ?>>
          <td width="100%"> 
          	<table cellpadding="0" cellspacing="0" border="0">
          		<tr>
          			<td valign="middle" align="center"><img alt="" src="includes/images/spacer.gif" width="4" height="1"><img alt="A document" src="includes/images/icone/16x16/document.gif" width="16" height="16" align="middle" title="An article"><img alt="" src="includes/images/spacer.gif" width="6" height="1"></td>
          			<td valign="top">
						<a href="javascript:popupResource(<?php echo $this->_tpl_vars['resource']->id; ?>
);" class="link_ticket_cmd"><?php echo $this->_tpl_vars['resource']->name; ?>
</a><br>
			         		
         			</td>
         		</tr>
         	</table>
			</td>
			<td width="0%" valign="middle" align="center" nowrap>
				<?php if ($this->_tpl_vars['resource']->votes != 0): ?>
				<?php echo $this->_plugins['function']['math'][0](array('assign' => 'percent','equation' => "100*(x/5)",'x' => $this->_tpl_vars['resource']->rating,'format' => "%d"), $this) ; ?>

				<?php echo $this->_plugins['function']['math'][0](array('assign' => 'percent_i','equation' => "100-x",'x' => $this->_tpl_vars['percent'],'format' => "%d"), $this) ; ?>

	         	<table cellpadding="0" cellspacing="0" width="50">
	         		<tr>
	         			<td width="<?php echo $this->_tpl_vars['percent']; ?>
%" bgcolor="#EE0000" title="<?php echo $this->_tpl_vars['resource']->rating; ?>
 / 5.0"><img alt="" src="includes/images/spacer.gif" height="3" width="1"></td>
	         			<td width="<?php echo $this->_tpl_vars['percent_i']; ?>
%" bgcolor="#AEAEAE" title="<?php echo $this->_tpl_vars['resource']->rating; ?>
 / 5.0"></td>
	         		</tr>
	         	</table>
	         	<?php else: ?>
	         		<i>n/a</i>
	     		<?php endif; ?>
			</td>
        </tr>
		<?php endforeach; endif; ?>
			
	</table>

<?php else: ?>
		<br>
		<i class="cer_knowledgebase_link"><?php echo @constant('LANG_KB_ARTICLE_NO_ARTICLES'); ?>
</i>
		<br>
<?php endif; ?>