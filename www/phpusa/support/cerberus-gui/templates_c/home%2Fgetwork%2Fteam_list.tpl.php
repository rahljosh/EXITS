<?php /* Smarty version 2.5.0, created on 2007-01-16 12:27:48
         compiled from home/getwork/team_list.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'home/getwork/team_list.tpl.php', 16, false),)); ?><form action="index.php" method="post" name="formGetWork">
<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
<input type="hidden" name="cmd" value="getwork_teams">
<input type="hidden" name="form_submit" value="getwork_pull">
<table width="100%" border="0" cellpadding="3" cellspacing="0" class="table_green">
	<!---<input type="hidden" name="getwork_team" value="">--->
   <tr>
     <td nowrap="nowrap" class="bg_green"><img alt="A folder" src="includes/images/icone/16x16/folder_gear.gif" width="16" height="16" /><span class="text_title_white">My Teams</span> <a href="javascript:;" onclick="getTeamWorkloads();" class="link_box_edit">reload</a></td>
   </tr>
   <tr>
     <td nowrap="nowrap" bgcolor="#F0F0FF" class="orange_heading">Assign from these teams:  </td>
   </tr>
   <tr>
     <td nowrap="nowrap" bgcolor="#F0F0FF">
		<?php if (isset($this->_foreach['teams'])) unset($this->_foreach['teams']);
$this->_foreach['teams']['name'] = 'teams';
$this->_foreach['teams']['total'] = count((array)$this->_tpl_vars['teams']);
$this->_foreach['teams']['show'] = $this->_foreach['teams']['total'] > 0;
if ($this->_foreach['teams']['show']):
$this->_foreach['teams']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['teams'] as $this->_tpl_vars['teamId'] => $this->_tpl_vars['team']):
        $this->_foreach['teams']['iteration']++;
        $this->_foreach['teams']['first'] = ($this->_foreach['teams']['iteration'] == 1);
        $this->_foreach['teams']['last']  = ($this->_foreach['teams']['iteration'] == $this->_foreach['teams']['total']);
?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'uid','value' => $this->_tpl_vars['session']->vars['login_handler']->user_id), $this) ; ?>

			<?php if (isset ( $this->_tpl_vars['team']->agents[$this->_tpl_vars['user_id']] )): ?> <!--- <input type="checkbox" name="getwork_teams[]" value="<?php echo $this->_tpl_vars['teamId']; ?>
" /> --->
				<label><input type="checkbox" name="getwork_teams[]" value="<?php echo $this->_tpl_vars['teamId']; ?>
"> <img alt="A team" src="includes/images/icone/16x16/businessmen.gif" width="16" height="16" />&nbsp;<strong><?php echo $this->_tpl_vars['team']->name; ?>
</strong> (<?php echo $this->_tpl_vars['team']->workload_hits; ?>
)</label>
				<br />
			<?php endif; ?>
      <?php endforeach; endif; ?>
      
      
   </tr>
   
   <!---
   <tr>
     <td nowrap="nowrap" bgcolor="#F0F0FF" class="orange_heading">Filters: </td>
   </tr>
   <tr>
     <td nowrap="nowrap" bgcolor="#F0F0FF" class="box_text">
     	<label><input type="checkbox" name="getwork_show_flagged" value="1">Show Flagged Tickets</label>
     </td>
   </tr>
   --->
   
   <tr>
     <td nowrap="nowrap" bgcolor="#F0F0FF" class="orange_heading">How many tickets? </td>
   </tr>
   <tr>
     <td nowrap="nowrap" bgcolor="#F0F0FF"><!---<select name="getwork_order" class="box_text">
       <option value="priority" <?php if ($this->_tpl_vars['order'] == 'priority'): ?>selected="selected"<?php endif; ?>>Highest Priority</option>
       <option value="due" <?php if ($this->_tpl_vars['order'] == 'due'): ?>selected="selected"<?php endif; ?>>Most Overdue</option>
       <option value="latest" <?php if ($this->_tpl_vars['order'] == 'latest'): ?>selected="selected"<?php endif; ?>>Most Recent Reply</option>
     </select>---><select name="getwork_limit" class="box_text">
       <option value="1" <?php if ($this->_tpl_vars['limit'] == '1'): ?>selected="selected"<?php endif; ?>>1</option>
       <option value="5" <?php if ($this->_tpl_vars['limit'] == '5'): ?>selected="selected"<?php endif; ?>>5</option>
       <option value="10" <?php if ($this->_tpl_vars['limit'] == '10'): ?>selected="selected"<?php endif; ?>>10</option>
       <option value="25" <?php if ($this->_tpl_vars['limit'] == '25'): ?>selected="selected"<?php endif; ?>>25</option>
     </select><input type="button" value="Assign" onclick="getWork();">
     <!---<span class="box_text"><label><input type="checkbox" name="getwork_show_flagged" value="1" <?php if ($this->_tpl_vars['show_flagged']): ?>checked<?php endif; ?>>Include Flagged Tickets</label></span>--->
     </td>
   </tr>

<!---
   <tr>
     <td align="right" nowrap="nowrap" bgcolor="#F0F0FF"><input type="button" value="Get Work" onclick="javascript:getWork();" class="cer_button_face" /></td>
   </tr>
--->
   
</table>
</form>