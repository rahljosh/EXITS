<?php /* Smarty version 2.5.0, created on 2007-01-15 18:54:16
         compiled from search/rpc/builder/criteria_list.tpl.php */ ?>
<table cellpadding="2" cellspacing="0" border="0" class="table_green" bgcolor="#FFFFFF">
	<tr>
		<td colspan="2" class="bg_green" nowrap> <img src="includes/images/icone/16x16/find.gif" width="16" height="16" alt="Find"> <span class="text_title_white">Search Criteria </span></td>
	</tr>
	
	<tr>
		<td colspan="2">
		&nbsp; <a href="javascript:;" onclick="doSearchCriteriaReset('<?php echo $this->_tpl_vars['label']; ?>
');" class="cer_footer_text">reset criteria</a>
		| <a href="javascript:;" onclick="doSearchCriteriaGetSave('<?php echo $this->_tpl_vars['label']; ?>
');" class="cer_footer_text">save</a>
		| <a href="javascript:;" onclick="doSearchCriteriaGetLoad('<?php echo $this->_tpl_vars['label']; ?>
');" class="cer_footer_text">load</a>
		</td>
	</tr>
	
	<tr>
		<td colspan="2">
		<form name="<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaIOForm" id="<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaIOForm" style="margin:0px;">
			<input type="hidden" name="label" value="<?php echo $this->_tpl_vars['label']; ?>
">
			<span id="<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaIO"></span>
		</form>
		</td>
	</tr>
	
	<?php if (isset($this->_foreach['criterion'])) unset($this->_foreach['criterion']);
$this->_foreach['criterion']['name'] = 'criterion';
$this->_foreach['criterion']['total'] = count((array)$this->_tpl_vars['search_builder']->criteria);
$this->_foreach['criterion']['show'] = $this->_foreach['criterion']['total'] > 0;
if ($this->_foreach['criterion']['show']):
$this->_foreach['criterion']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['search_builder']->criteria as $this->_tpl_vars['criteriaName'] => $this->_tpl_vars['criteria']):
        $this->_foreach['criterion']['iteration']++;
        $this->_foreach['criterion']['first'] = ($this->_foreach['criterion']['iteration'] == 1);
        $this->_foreach['criterion']['last']  = ($this->_foreach['criterion']['iteration'] == $this->_foreach['criterion']['total']);
?>

		<?php if ($this->_tpl_vars['criteriaName'] == 'status'): ?>
			<tr><td nowrap="nowrap">
			<img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Status is <b>
			<?php if ($this->_tpl_vars['criteria']['status'] == 0): ?>
				Any Status
			<?php elseif ($this->_tpl_vars['criteria']['status'] == 1): ?>
				Any Active Status
			<?php elseif ($this->_tpl_vars['criteria']['status'] == 2): ?>
				Open
			<?php elseif ($this->_tpl_vars['criteria']['status'] == 3): ?>
				Closed
			<?php elseif ($this->_tpl_vars['criteria']['status'] == 4): ?>
				Deleted
			<?php endif; ?>
			</b>
			</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'waiting'): ?>
			<tr><td nowrap="nowrap">
			<img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Waiting on Customer is <b>
			<?php if ($this->_tpl_vars['criteria']['waiting'] == 0): ?>
				false
			<?php elseif ($this->_tpl_vars['criteria']['waiting'] == 1): ?>
				true
			<?php endif; ?>
			</b>
			</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			
		
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'requester'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Requester contains:</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"><b><?php echo $this->_tpl_vars['criteria']['requester']; ?>
</b></td></tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'mask'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Ticket ID/Mask: <b><?php echo $this->_tpl_vars['criteria']['mask']; ?>
</b></td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'subject'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Subject matches:</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"><b><?php echo $this->_tpl_vars['criteria']['subject']; ?>
</b></td></tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'content'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Content matches:</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"><b><?php echo $this->_tpl_vars['criteria']['content']; ?>
</b></td></tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'company'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Company contains '<b><?php echo $this->_tpl_vars['criteria']['company']; ?>
</b>'</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
		
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'queue'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Mailbox is any:</td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			
			<?php if (count ( $this->_tpl_vars['criteria']['queues'] )): ?>
				<?php if (isset($this->_foreach['queues'])) unset($this->_foreach['queues']);
$this->_foreach['queues']['name'] = 'queues';
$this->_foreach['queues']['total'] = count((array)$this->_tpl_vars['criteria']['queues']);
$this->_foreach['queues']['show'] = $this->_foreach['queues']['total'] > 0;
if ($this->_foreach['queues']['show']):
$this->_foreach['queues']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['criteria']['queues'] as $this->_tpl_vars['queueId'] => $this->_tpl_vars['queue']):
        $this->_foreach['queues']['iteration']++;
        $this->_foreach['queues']['first'] = ($this->_foreach['queues']['iteration'] == 1);
        $this->_foreach['queues']['last']  = ($this->_foreach['queues']['iteration'] == $this->_foreach['queues']['total']);
?>
					<tr><td nowrap="nowrap">&nbsp; &nbsp;- <b><?php echo $this->_tpl_vars['queue']; ?>
</b></td>
					<td valign="top">
						<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','queues','<?php echo $this->_tpl_vars['queueId']; ?>
');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
					</td>
					</tr>
				<?php endforeach; endif; ?>
			<?php endif; ?>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'flag'): ?>
			<?php if ($this->_tpl_vars['criteria']['flag_mode']): ?>
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Flagged By:</td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
				<?php if (count ( $this->_tpl_vars['criteria']['flags'] )): ?>
					<?php if (isset($this->_foreach['flags'])) unset($this->_foreach['flags']);
$this->_foreach['flags']['name'] = 'flags';
$this->_foreach['flags']['total'] = count((array)$this->_tpl_vars['criteria']['flags']);
$this->_foreach['flags']['show'] = $this->_foreach['flags']['total'] > 0;
if ($this->_foreach['flags']['show']):
$this->_foreach['flags']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['criteria']['flags'] as $this->_tpl_vars['flagId'] => $this->_tpl_vars['flag']):
        $this->_foreach['flags']['iteration']++;
        $this->_foreach['flags']['first'] = ($this->_foreach['flags']['iteration'] == 1);
        $this->_foreach['flags']['last']  = ($this->_foreach['flags']['iteration'] == $this->_foreach['flags']['total']);
?>
						<tr><td nowrap="nowrap">&nbsp; &nbsp;- <b><?php echo $this->_tpl_vars['flag']; ?>
</b></td>
						<td valign="top">
							<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','flags','<?php echo $this->_tpl_vars['flagId']; ?>
');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
						</td>
						</tr>
					<?php endforeach; endif; ?>
				<?php endif; ?>
			<?php else: ?>
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Flagged By: <b>Nobody</b></td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
			<?php endif; ?>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'priority'): ?>
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Priority in any:</b></td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
				<tr><td valign="top" colspan="2">
					<?php if (count((array)$this->_tpl_vars['criteria']['priorities'])):
    foreach ((array)$this->_tpl_vars['criteria']['priorities'] as $this->_tpl_vars['priorityId'] => $this->_tpl_vars['priority']):
?>
						&nbsp; &nbsp;- <b><?php echo $this->_tpl_vars['priority']; ?>
</b><br>
					<?php endforeach; endif; ?>
				</td></tr>
			

		<?php elseif ($this->_tpl_vars['criteriaName'] == 'tags'): ?>
				
			<?php if (count ( $this->_tpl_vars['criteria']['tags'] )): ?>
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Tags <a href="javascript:;" onclick="doSearchCriteriaToggle('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','tags_match');" class="workflow_item"><?php if (! $this->_tpl_vars['criteria']['tags_match']): ?>match any<?php elseif ($this->_tpl_vars['criteria']['tags_match'] == 1): ?>match all<?php else: ?>match none<?php endif; ?></a>:</td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','tags','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
			
				<?php if (isset($this->_foreach['tags'])) unset($this->_foreach['tags']);
$this->_foreach['tags']['name'] = 'tags';
$this->_foreach['tags']['total'] = count((array)$this->_tpl_vars['criteria']['tags']);
$this->_foreach['tags']['show'] = $this->_foreach['tags']['total'] > 0;
if ($this->_foreach['tags']['show']):
$this->_foreach['tags']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['criteria']['tags'] as $this->_tpl_vars['tagId'] => $this->_tpl_vars['tag']):
        $this->_foreach['tags']['iteration']++;
        $this->_foreach['tags']['first'] = ($this->_foreach['tags']['iteration'] == 1);
        $this->_foreach['tags']['last']  = ($this->_foreach['tags']['iteration'] == $this->_foreach['tags']['total']);
?>
					<tr><td nowrap="nowrap">&nbsp; &nbsp;- <b><?php echo $this->_tpl_vars['tag']; ?>
</b></td>
					<td valign="top">
						<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','tags','<?php echo $this->_tpl_vars['tagId']; ?>
');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
					</td>
					</tr>
				<?php endforeach; endif; ?>
			<?php endif; ?>
				
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'workflow'): ?>
<!--			<tr><td nowrap="nowrap">Workflow matches (any|all) <b><?php echo $this->_tpl_vars['criteria']['workflow']; ?>
</b></td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
-->
			
			

			<?php if (count ( $this->_tpl_vars['criteria']['agents'] )): ?>
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Agents <a href="javascript:;" onclick="doSearchCriteriaToggle('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','agents_match');" class="workflow_item"><?php if (! $this->_tpl_vars['criteria']['agents_match']): ?>match any<?php elseif ($this->_tpl_vars['criteria']['agents_match'] == 1): ?>match all<?php else: ?>match none<?php endif; ?></a>:</td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','agents','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
			
				<?php if (isset($this->_foreach['agents'])) unset($this->_foreach['agents']);
$this->_foreach['agents']['name'] = 'agents';
$this->_foreach['agents']['total'] = count((array)$this->_tpl_vars['criteria']['agents']);
$this->_foreach['agents']['show'] = $this->_foreach['agents']['total'] > 0;
if ($this->_foreach['agents']['show']):
$this->_foreach['agents']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['criteria']['agents'] as $this->_tpl_vars['agentId'] => $this->_tpl_vars['agent']):
        $this->_foreach['agents']['iteration']++;
        $this->_foreach['agents']['first'] = ($this->_foreach['agents']['iteration'] == 1);
        $this->_foreach['agents']['last']  = ($this->_foreach['agents']['iteration'] == $this->_foreach['agents']['total']);
?>
					<tr><td nowrap="nowrap">&nbsp; &nbsp;- <b><?php echo $this->_tpl_vars['agent']; ?>
</b></td>
					<td valign="top">
						<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','agents','<?php echo $this->_tpl_vars['agentId']; ?>
');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
					</td>
					</tr>
				<?php endforeach; endif; ?>
			<?php endif; ?>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'created'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Created from <b><?php echo $this->_tpl_vars['criteria']['from']; ?>
</b></td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"> to <b><?php echo $this->_tpl_vars['criteria']['to']; ?>
</b></td></tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'last_updated'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Updated from <b><?php echo $this->_tpl_vars['criteria']['from']; ?>
</b></td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"> to <b><?php echo $this->_tpl_vars['criteria']['to']; ?>
</b></td></tr>
			
		<?php elseif ($this->_tpl_vars['criteriaName'] == 'due'): ?>
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> Due from <b><?php echo $this->_tpl_vars['criteria']['from']; ?>
</b></td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"> to <b><?php echo $this->_tpl_vars['criteria']['to']; ?>
</b></td></tr>
			
		<?php elseif (substr ( $this->_tpl_vars['criteriaName'] , 0 , 12 ) == 'custom_field'): ?>
			<?php if ($this->_tpl_vars['criteria']['type'] == 'D'): ?> 
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> <?php echo $this->_tpl_vars['criteria']['name']; ?>
 in any:</b></td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
				<tr><td valign="top" colspan="2">
					<?php if (count((array)$this->_tpl_vars['criteria']['options'])):
    foreach ((array)$this->_tpl_vars['criteria']['options'] as $this->_tpl_vars['optId'] => $this->_tpl_vars['opt']):
?>
						&nbsp; &nbsp;- <b><?php echo $this->_tpl_vars['opt']; ?>
</b><br>
					<?php endforeach; endif; ?>
				</td></tr>
			<?php elseif ($this->_tpl_vars['criteria']['type'] == 'E'): ?> 
			<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> <?php echo $this->_tpl_vars['criteria']['name']; ?>
 from <b><?php echo $this->_tpl_vars['criteria']['from']; ?>
</b></td>
			<td valign="top">
				<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
			</td>
			</tr>
			<tr><td valign="top" colspan="2"> to <b><?php echo $this->_tpl_vars['criteria']['to']; ?>
</b></td></tr>
			<?php else: ?> 
				<tr><td nowrap="nowrap"><img src="includes/images/icone/16x16/data_find.gif" width="16" height="16" border="0" alt="Criteria" align="absmiddle"> <?php echo $this->_tpl_vars['criteria']['name']; ?>
 contains </b></td>
				<td valign="top">
					<a href="javascript:;" onclick="doSearchCriteriaRemove('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['criteriaName']; ?>
','','');" title="Remove"><b><img src="includes/images/icone/16x16/data_error.gif" width="16" height="16" border="0" alt="Remove"></b></a>
				</td>
				</tr>
				<tr><td valign="top" colspan="2">'<b><?php echo $this->_tpl_vars['criteria']['value']; ?>
</b>'</td></tr>
			<?php endif; ?>
			
		<?php endif; ?>
		
	</tr>
	<?php endforeach; endif; ?>
	
	<?php if ($this->_tpl_vars['label'] == 'search'): ?>
	<tr>
		<td colspan="2" align="right" valign="middle" bgcolor="#DDDDDD" nowrap="nowrap">
			<form action="ticket_list.php" style="margin:0px;">
			<input type="hidden" name="search_submit" value="yes">
			<span class="cer_footer_text">Results per page:</span> <input type="text" name="search_limit" value="<?php if ($this->_tpl_vars['filter_rows']): ?><?php echo $this->_tpl_vars['filter_rows']; ?>
<?php else: ?>50<?php endif; ?>" size="3" maxlength="4"><input type="submit" value="Search" onclick="">
			</form>
		</td>
	</tr>
	<?php else: ?>
	<tr>
		<td colspan="2" align="right" bgcolor="#DDDDDD">
			<form action="index.php" style="margin:0px;">
			<input type="hidden" name="view_submit" value="yes">
			<input type="hidden" name="view_submit_mode" value="2">
			<input type="hidden" name="label" value="<?php echo $this->_tpl_vars['label']; ?>
">
			<input type="submit" value="Set Criteria" onclick="">
			</form>
		</td>
	</tr>
	<?php endif; ?>
	
</table>