<?php /* Smarty version 2.5.0, created on 2007-01-16 11:45:40
         compiled from my_cerberus/tabs/my_cerberus_tasks_project_list.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'my_cerberus/tabs/my_cerberus_tasks_project_list.tpl.php', 31, false),)); ?><br>
<span class="cer_knowledgebase_heading"><?php echo @constant('LANG_MYCERBERUS_PROJECTS_HEADER'); ?>
</span><br>
<br>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form action="my_cerberus.php" method="post">
<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
<input type="hidden" name="mode" value="tasks">
<input type="hidden" name="form_submit" value="projects_filter">

  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_orange_glass"> 
    <td>&nbsp;<?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_HEADER'); ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr bgcolor="#DDDDDD" class="cer_maintable_text"> 
    <td bgcolor="#DDDDDD" class="cer_maintable_text" align="left"> 
	<table cellspacing="0" cellpadding="0" width="100%" border="0">
	<?php if (! empty ( $this->_tpl_vars['dashboard']->tasks )): ?>
		<tr bgcolor="#BBBBBB">
			<td class="cer_maintable_heading">&nbsp;<?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_NAME'); ?>
</td>
			<td class="cer_maintable_heading" align="center"><?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_TOTAL'); ?>
</td>
			<td class="cer_maintable_heading" align="center"><?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_INCOMPLETE'); ?>
</td>
			<td class="cer_maintable_heading" align="center"><?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_COMPLETE'); ?>
</td>
			<td class="cer_maintable_heading" align="left"><?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_MANAGER'); ?>
</td>
		</tr>
		<tr><td colspan="5" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
		<?php if (isset($this->_foreach['project'])) unset($this->_foreach['project']);
$this->_foreach['project']['name'] = 'project';
$this->_foreach['project']['total'] = count((array)$this->_tpl_vars['dashboard']->tasks->projects);
$this->_foreach['project']['show'] = $this->_foreach['project']['total'] > 0;
if ($this->_foreach['project']['show']):
$this->_foreach['project']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['dashboard']->tasks->projects as $this->_tpl_vars['key'] => $this->_tpl_vars['project']):
        $this->_foreach['project']['iteration']++;
        $this->_foreach['project']['first'] = ($this->_foreach['project']['iteration'] == 1);
        $this->_foreach['project']['last']  = ($this->_foreach['project']['iteration'] == $this->_foreach['project']['total']);
?>
		<tr class="<?php if ($this->_foreach['project']['iteration'] % 2 == 0): ?>cer_maintable_text_1<?php else: ?>cer_maintable_text_2<?php endif; ?>">
			<td>
			<a href="<?php echo $this->_tpl_vars['project']->project_url; ?>
" class="cer_maintable_heading"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['project']->project_name); ?>
</a>
			</td>
			<td class="cer_footer_text" align="center">
				<?php echo $this->_tpl_vars['project']->task_count; ?>

			</td>
			<td class="cer_footer_text" align="center">
				<?php echo $this->_tpl_vars['project']->tasks_incomplete; ?>

			</td>
			<td class="cer_footer_text" align="center">
				<?php echo $this->_tpl_vars['project']->tasks_complete; ?>

			</td>
			<td class="cer_footer_text" align="left">
				<?php echo $this->_tpl_vars['project']->project_manager_name; ?>
 (<b><?php echo $this->_tpl_vars['project']->project_manager_login; ?>
</b>)
			</td>
		</tr>
		<tr><td colspan="5" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
		<?php endforeach; endif; ?>
	<?php else: ?>
		<tr>
			<td><span class="cer_maintable_text">
			No projects defined.</span>
			</td>
		</tr>
	<?php endif; ?>
	</table>

	<table border=0 cellspacing=0 cellpadding=0 width="100%">
		<tr bgcolor="#B0B0B0" class="cer_maintable_text">
        	<td align="right">
        		<input type="checkbox" name="filter_hide_completed_projects" value="1" <?php if ($this->_tpl_vars['dashboard']->tasks->project_prefs['filter_hide_completed_projects']): ?>checked<?php endif; ?>> <span class="cer_maintable_header"><B><?php echo @constant('LANG_MYCERBERUS_PROJECTS_ACTIVE_HIDECOMPLETED'); ?>
</B></span>
        		<input type="submit" class="cer_button_face" value="<?php echo @constant('LANG_WORD_FILTER'); ?>
">
        	</td>
      	</tr>
	</table>

    </td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
</table>
<br>

</form>