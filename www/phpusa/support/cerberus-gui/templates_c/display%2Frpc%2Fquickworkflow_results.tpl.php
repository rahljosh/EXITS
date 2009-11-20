<?php /* Smarty version 2.5.0, created on 2007-01-15 22:00:45
         compiled from display/rpc/quickworkflow_results.tpl.php */ ?>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><span class="quickworkflow_item"><b>Found:</b></span></td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="quickworkflow_results">
	
	<?php if (isset($this->_foreach['tags'])) unset($this->_foreach['tags']);
$this->_foreach['tags']['name'] = 'tags';
$this->_foreach['tags']['total'] = count((array)$this->_tpl_vars['tags']);
$this->_foreach['tags']['show'] = $this->_foreach['tags']['total'] > 0;
if ($this->_foreach['tags']['show']):
$this->_foreach['tags']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['tags'] as $this->_tpl_vars['tag']):
        $this->_foreach['tags']['iteration']++;
        $this->_foreach['tags']['first'] = ($this->_foreach['tags']['iteration'] == 1);
        $this->_foreach['tags']['last']  = ($this->_foreach['tags']['iteration'] == $this->_foreach['tags']['total']);
?>
	<tr>
	 <td><table width="100%" border="0" cellpadding="2" cellspacing="0" style="border-bottom:1px solid #DDDDDD;">
	   <tr title="">
	     <td width="0%" align="center" nowrap="nowrap" bgcolor="#FF8000"><img src="includes/images/icone/16x16/folder_network.gif" alt="A folder" width="16" height="16" /></td>
	     <td width="100%" align="left" valign="top" nowrap="nowrap" class="quickworkflow_item"><label><input type="checkbox" name="workflow[]" value="t_<?php echo $this->_tpl_vars['tag']->id; ?>
" title="Tag: <?php echo $this->_tpl_vars['tag']->name; ?>
" /> <?php echo $this->_tpl_vars['tag']->name; ?>
 <i>(<?php echo $this->_tpl_vars['tag']->parent->name; ?>
)</i></label></td>
	 </tr>
	 </table></td>
	</tr>
	<?php endforeach; endif; ?>
	
	<?php if (isset($this->_foreach['teams'])) unset($this->_foreach['teams']);
$this->_foreach['teams']['name'] = 'teams';
$this->_foreach['teams']['total'] = count((array)$this->_tpl_vars['teams']);
$this->_foreach['teams']['show'] = $this->_foreach['teams']['total'] > 0;
if ($this->_foreach['teams']['show']):
$this->_foreach['teams']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['teams'] as $this->_tpl_vars['team']):
        $this->_foreach['teams']['iteration']++;
        $this->_foreach['teams']['first'] = ($this->_foreach['teams']['iteration'] == 1);
        $this->_foreach['teams']['last']  = ($this->_foreach['teams']['iteration'] == $this->_foreach['teams']['total']);
?>
	<tr>
	 <td><table width="100%" border="0" cellpadding="2" cellspacing="0" style="border-bottom:1px solid #DDDDDD;">
	   <tr title="">
	     <td width="0%" align="center" nowrap="nowrap" bgcolor="#00DD37"><img src="includes/images/icone/16x16/businessmen.gif" alt="A Team" width="16" height="16" /></td>
	     <td width="100%" align="left" valign="top" nowrap="nowrap" class="quickworkflow_item"><label><input type="checkbox" name="workflow[]" value="g_<?php echo $this->_tpl_vars['team']->getId(); ?>
" title="Team: <?php echo $this->_tpl_vars['team']->getName(); ?>
" /> <?php echo $this->_tpl_vars['team']->getName(); ?>
</label></td>
	 </tr>
	 </table></td>
	</tr>
	<?php endforeach; endif; ?>
	
	<?php if (isset($this->_foreach['agents'])) unset($this->_foreach['agents']);
$this->_foreach['agents']['name'] = 'agents';
$this->_foreach['agents']['total'] = count((array)$this->_tpl_vars['agents']);
$this->_foreach['agents']['show'] = $this->_foreach['agents']['total'] > 0;
if ($this->_foreach['agents']['show']):
$this->_foreach['agents']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['agents'] as $this->_tpl_vars['agent']):
        $this->_foreach['agents']['iteration']++;
        $this->_foreach['agents']['first'] = ($this->_foreach['agents']['iteration'] == 1);
        $this->_foreach['agents']['last']  = ($this->_foreach['agents']['iteration'] == $this->_foreach['agents']['total']);
?>
	<tr>
	 <td><table width="100%" border="0" cellpadding="2" cellspacing="0" style="border-bottom:1px solid #DDDDDD;">
	   <tr title="">
	     <td width="0%" align="center" nowrap="nowrap" bgcolor="#00DD37"><img src="includes/images/icone/16x16/hand_paper.gif" alt="An Agent" width="16" height="16" /></td>
	     <td width="100%" align="left" valign="top" nowrap="nowrap" class="quickworkflow_item"><label><input type="checkbox" name="workflow[]" value="a_<?php echo $this->_tpl_vars['agent']->getId(); ?>
" title="Agent: <?php echo $this->_tpl_vars['agent']->getRealName(); ?>
" /> <?php echo $this->_tpl_vars['agent']->getRealName(); ?>
</label></td>
	 </tr>
	 </table></td>
	</tr>
	<?php endforeach; endif; ?>

	<?php if (isset($this->_foreach['flags'])) unset($this->_foreach['flags']);
$this->_foreach['flags']['name'] = 'flags';
$this->_foreach['flags']['total'] = count((array)$this->_tpl_vars['flagAgents']);
$this->_foreach['flags']['show'] = $this->_foreach['flags']['total'] > 0;
if ($this->_foreach['flags']['show']):
$this->_foreach['flags']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['flagAgents'] as $this->_tpl_vars['flag']):
        $this->_foreach['flags']['iteration']++;
        $this->_foreach['flags']['first'] = ($this->_foreach['flags']['iteration'] == 1);
        $this->_foreach['flags']['last']  = ($this->_foreach['flags']['iteration'] == $this->_foreach['flags']['total']);
?>
	<tr>
	 <td><table width="100%" border="0" cellpadding="2" cellspacing="0" style="border-bottom:1px solid #DDDDDD;">
	   <tr title="">
	     <td width="0%" align="center" nowrap="nowrap" bgcolor="#CCCCCC"><img src="includes/images/icone/16x16/flag_red.gif" alt="A Flag" width="16" height="16" /></td>
	     <td width="100%" align="left" valign="top" nowrap="nowrap" class="quickworkflow_item"><label><input type="checkbox" name="workflow[]" value="f_<?php echo $this->_tpl_vars['flag']->getId(); ?>
" title="Flag: <?php echo $this->_tpl_vars['flag']->getRealName(); ?>
" /> <?php echo $this->_tpl_vars['flag']->getRealName(); ?>
</label></td>
	 </tr>
	 </table></td>
	</tr>
	<?php endforeach; endif; ?>
	
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><img src="includes/images/spacer.gif" height="3" width="1" border="0"></td>
	</tr>
	<!---
	<?php if ($this->_tpl_vars['actionSet'] == 'article'): ?>
			<tr>
				<td align="right"><input type="button" name="" value="+ Add to Favorites" class="cer_button_face" /><input type="button" onclick="kbQuickWorkflow.addResultsToArticle();" value="+ Add to Article" class="cer_button_face" /></td>
			</tr>	  
	<?php elseif ($this->_tpl_vars['actionSet'] == 'search'): ?>
			<tr>
				<td align="right"><input type="button" name="" value="Add &gt;&gt;" class="cer_button_face" onclick="this.form.cmd.value='search_set_criteria';doSearchCriteriaSet(this.form.label.value);" /></td>
			</tr>	  
	<?php else: ?>
			<tr>
				<td align="right"><input type="button" name="" value="+ Add to Favorites" class="cer_button_face" /><input type="button" onclick="doPostQuickWorkflow(<?php echo $this->_tpl_vars['id']; ?>
);" value="+ Add to Ticket" class="cer_button_face" /></td>
			</tr>	  
	<?php endif; ?>
	--->
</table>