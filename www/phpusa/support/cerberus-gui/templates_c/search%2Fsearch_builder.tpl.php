<?php /* Smarty version 2.5.0, created on 2007-01-15 18:54:14
         compiled from search/search_builder.tpl.php */ ?>
<table border="0" cellpadding="2" cellspacing="0" class="table_orange" width="100%">
	<tr>
	  <td class="bg_orange"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	      <td width="100%"><span class="text_title_white"> Search Builder</span></td>
	  </tr>
	  </table></td>
	</tr>
</table>

<script type="text/javascript">
	var searchWorkflow<?php echo $this->_tpl_vars['label']; ?>
 = new CerQuickWorkflow('<?php echo $this->_tpl_vars['label']; ?>
','<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaForm');
	
	searchWorkflow<?php echo $this->_tpl_vars['label']; ?>
.tagAction = function() <?php echo '{'; ?>

//		this.post();
		var tagDiv = document.getElementById("tag_input_" + this.label);
		if(null == tagDiv) return;

		<?php echo '
//		YAHOO.util.Connect.setForm(this.frm);
		var cObj = YAHOO.util.Connect.asyncRequest(\'GET\', \'rpc.php?cmd=search_set_criteria&label=\' + this.label + \'&criteria=tags&tags=\' + escape(tagDiv.value), {
			success: function(o) {
//				o.argument.caller.postResultsAction();
				o.argument.tagDiv.value = \'\';
				o.argument.tagDiv.focus();
				o.argument.caller.refresh();
				o.argument.caller.postAddTagAction();
			},
			failure: handleWorkflowFailure,
			argument: {caller:this,tagDiv:tagDiv}
		});
		'; ?>

		
	<?php echo '}'; ?>

	
	searchWorkflow<?php echo $this->_tpl_vars['label']; ?>
.postResultsAction = function() <?php echo '{'; ?>

		doSearchCriteriaList(this.label);
	<?php echo '}'; ?>

	
	searchWorkflow<?php echo $this->_tpl_vars['label']; ?>
.postAddTagAction = function() <?php echo '{'; ?>

		doSearchCriteriaList(this.label);
	<?php echo '}'; ?>

</script>

<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr bgcolor="#F0F0FF">
		<td valign="top" width="0%" nowrap="nowrap">
			<form action="#" name="<?php echo $this->_tpl_vars['label']; ?>
_searchBuilderForm" id="<?php echo $this->_tpl_vars['label']; ?>
_searchBuilderForm" style="margin:0px;">
			<input type="hidden" name="label" value="<?php echo $this->_tpl_vars['label']; ?>
">
			<input type="hidden" name="cmd" value="search_show_criteria">
			Criteria: <select name="criteria" onchange="doGetCriteria('<?php echo $this->_tpl_vars['label']; ?>
');">
				<option value="">-- select a criteria --
				<optgroup label="Ticket Fields">
					<option value="mask">Ticket ID/Mask
					<option value="status">Ticket Status
					<option value="waiting">Waiting on Customer
					<option value="requester">Requester
					<option value="subject">Subject
					<option value="content">Content
					<option value="company">Company
					<option value="queue">Mailbox
					<option value="flag">Flagged by
					<option value="priority">Priority
					<option value="tags">Tags
					<option value="workflow">Suggested Agents
					<!---<option value="has_teams">Has Teams Assigned--->
					<option value="created">Created
					<option value="last_updated">Last Updated
					<option value="due">Due
				</optgroup>
				<?php if (! empty ( $this->_tpl_vars['customfields']->group_templates )): ?>
					<?php if (count((array)$this->_tpl_vars['customfields']->group_templates)):
    foreach ((array)$this->_tpl_vars['customfields']->group_templates as $this->_tpl_vars['group']):
?>
					<optgroup label="<?php echo $this->_tpl_vars['group']->group_name; ?>
">
						<?php if (count((array)$this->_tpl_vars['group']->fields)):
    foreach ((array)$this->_tpl_vars['group']->fields as $this->_tpl_vars['field']):
?>
							<option value="custom_field<?php echo $this->_tpl_vars['field']->field_id; ?>
"><?php echo $this->_tpl_vars['field']->field_name; ?>

						<?php endforeach; endif; ?>
					</optgroup>
					<?php endforeach; endif; ?>
				<?php endif; ?>
			</select>
			<br>
			</form>
		</td>
		<td valign="top" width="0%" nowrap="nowrap">
			<form action="#" name="<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaForm" id="<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaForm" style="margin:0px;">
			<input type="hidden" name="label" value="<?php echo $this->_tpl_vars['label']; ?>
">
			<span id="<?php echo $this->_tpl_vars['label']; ?>
_searchCriteriaOptions"></span>
			</form>
		</td>
		<td width="100%"></td>
	</tr>
</table>