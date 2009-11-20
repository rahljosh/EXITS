<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:20
         compiled from display/boxes/box_ticket_tags.tpl.php */ ?>
<table border="0" cellpadding="0" cellspacing="0" class="table_orange" width="100%">
   <tr>
     <td class="bg_orange"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td><span class="text_title_white"><img src="includes/images/icone/16x16/bookmark.gif" alt="A tag" width="16" height="16" /> Workflow </span></td>
         </tr>
     </table></td>
   </tr>
   <tr>
     <td bgcolor="#F0F0FF"><span class="box_text">
			<table border="0" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" width="100%">
				<?php if (empty ( $this->_tpl_vars['wsticket']->tags ) && empty ( $this->_tpl_vars['wsticket']->teams ) && empty ( $this->_tpl_vars['wsticket']->agents ) && empty ( $this->_tpl_vars['wsticket']->flags )): ?>
					<tr>
						<td bgcolor="#F0F0FF">No workflow applied.</td>
					</tr>
				<?php endif; ?>
				<?php if (isset($this->_foreach['tags'])) unset($this->_foreach['tags']);
$this->_foreach['tags']['name'] = 'tags';
$this->_foreach['tags']['total'] = count((array)$this->_tpl_vars['wsticket']->tags);
$this->_foreach['tags']['show'] = $this->_foreach['tags']['total'] > 0;
if ($this->_foreach['tags']['show']):
$this->_foreach['tags']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['wsticket']->tags as $this->_tpl_vars['tagId'] => $this->_tpl_vars['tag']):
        $this->_foreach['tags']['iteration']++;
        $this->_foreach['tags']['first'] = ($this->_foreach['tags']['iteration'] == 1);
        $this->_foreach['tags']['last']  = ($this->_foreach['tags']['iteration'] == $this->_foreach['tags']['total']);
?>
		        <tr>
		          <td><table width="100%" border="0" cellpadding="3" cellspacing="0" bgcolor="#F0F0FF">
		            <tr title="">
		              <td width="0%" align="center" nowrap="nowrap" bgcolor="#FF8000"><img src="includes/images/icone/16x16/folder_network.gif" alt="A folder" width="16" height="16" /></td>
		              <td width="100%" align="left" nowrap="nowrap" class="quickworkflow_item"><?php echo $this->_tpl_vars['tag']['name']; ?>
</td>
		              <td width="0%" align="right" nowrap="nowrap"><a href="javascript:;" onclick="doDisplayRemoveWorkflow('<?php echo $this->_tpl_vars['wsticket']->id; ?>
','t','<?php echo $this->_tpl_vars['tagId']; ?>
');" class="text_ticket_links" title="Remove tag from ticket"><b>X</b></a></td>
		          </tr>
		          </table></td>
		        </tr>
				<?php endforeach; endif; ?>
				
				
				
				<?php if (isset($this->_foreach['agents'])) unset($this->_foreach['agents']);
$this->_foreach['agents']['name'] = 'agents';
$this->_foreach['agents']['total'] = count((array)$this->_tpl_vars['wsticket']->agents);
$this->_foreach['agents']['show'] = $this->_foreach['agents']['total'] > 0;
if ($this->_foreach['agents']['show']):
$this->_foreach['agents']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['wsticket']->agents as $this->_tpl_vars['agentId'] => $this->_tpl_vars['agent']):
        $this->_foreach['agents']['iteration']++;
        $this->_foreach['agents']['first'] = ($this->_foreach['agents']['iteration'] == 1);
        $this->_foreach['agents']['last']  = ($this->_foreach['agents']['iteration'] == $this->_foreach['agents']['total']);
?>
		        <tr>
		          <td><table width="100%" border="0" cellpadding="3" cellspacing="0" bgcolor="#F0F0FF">
		            <tr>
		              <td width="0%" align="center" nowrap="nowrap" bgcolor="#00DD37"><img src="includes/images/icone/16x16/hand_paper.gif" alt="A suggested ticket" width="16" height="16" /></td>
		              <td width="100%" align="left" nowrap="nowrap" class="quickworkflow_item"><?php echo $this->_tpl_vars['agent']; ?>
</td>
		              <td width="0%" align="right" nowrap="nowrap"><a href="javascript:;" onclick="doDisplayRemoveWorkflow('<?php echo $this->_tpl_vars['wsticket']->id; ?>
','a','<?php echo $this->_tpl_vars['agentId']; ?>
');" class="text_ticket_links" title="Remove agent from ticket"><b>X</b></a></td>
		          </tr>
		          </table></td>
		        </tr>
				<?php endforeach; endif; ?>
				<?php if (isset($this->_foreach['flags'])) unset($this->_foreach['flags']);
$this->_foreach['flags']['name'] = 'flags';
$this->_foreach['flags']['total'] = count((array)$this->_tpl_vars['wsticket']->flags);
$this->_foreach['flags']['show'] = $this->_foreach['flags']['total'] > 0;
if ($this->_foreach['flags']['show']):
$this->_foreach['flags']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['wsticket']->flags as $this->_tpl_vars['flagId'] => $this->_tpl_vars['flag']):
        $this->_foreach['flags']['iteration']++;
        $this->_foreach['flags']['first'] = ($this->_foreach['flags']['iteration'] == 1);
        $this->_foreach['flags']['last']  = ($this->_foreach['flags']['iteration'] == $this->_foreach['flags']['total']);
?>
		        <tr>
		          <td><table width="100%" border="0" cellpadding="3" cellspacing="0" bgcolor="#F0F0FF">
		            <tr>
		              <td width="0%" align="center" nowrap="nowrap" bgcolor="#CCCCCC"><img src="includes/images/icone/16x16/flag_red.gif" alt="A red flag" width="16" height="16" /></td>
		              <td width="100%" align="left" nowrap="nowrap" class="quickworkflow_item"><?php echo $this->_tpl_vars['flag']; ?>
</td>
		              <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_REMOVE_ANY_FLAGS'),@constant('BITGROUP_2')) || $this->_tpl_vars['flagId'] == $this->_tpl_vars['user_id']): ?>
			              <td width="0%" align="right" nowrap="nowrap"><a href="javascript:;" onclick="doDisplayRemoveWorkflow('<?php echo $this->_tpl_vars['wsticket']->id; ?>
','f','<?php echo $this->_tpl_vars['flagId']; ?>
');" class="text_ticket_links" title="Remove flag from ticket"><b>X</b></a></td>
		              <?php else: ?>
			              <td width="0%" align="right" nowrap="nowrap"></td>
		              <?php endif; ?>
		          </tr>
		          </table></td>
		        </tr>
				<?php endforeach; endif; ?>
				<?php if ($this->_tpl_vars['wsticket']->is_waiting_on_customer): ?>
		        <tr>
		          <td><table width="100%" border="0" cellpadding="3" cellspacing="0" bgcolor="#F0F0FF">
		            <tr>
		              <td width="0%" align="center" nowrap="nowrap" bgcolor="#9EDBFE"><img src="includes/images/icone/16x16/alarmclock_pause.gif" width="16" height="16" border="0" alt="Waiting on Customer" /></td>
		              <td width="100%" align="left" nowrap="nowrap" class="quickworkflow_item">Waiting On Customer Reply</td>
		          </tr>
		          </table></td>
		        </tr>
				<?php endif; ?>
		   </table>
		</td>
	</tr>
</table>

<br>