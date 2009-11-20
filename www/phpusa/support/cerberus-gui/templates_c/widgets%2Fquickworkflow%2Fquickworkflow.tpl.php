<?php /* Smarty version 2.5.0, created on 2007-01-15 18:54:15
         compiled from widgets/quickworkflow/quickworkflow.tpl.php */ ?>
<input type="hidden" name="quickworkflow_string" value="">
<table border="0" cellpadding="2" cellspacing="0" class="quickworkflow_table">
	<tr>
		<td bgcolor="#FF8000"><span class="quickworkflow_title"> <img src="includes/images/icone/16x16/bookmark.gif" alt="Workflow" width="16" height="16" />&nbsp;Quick Workflow</span></td>
	</tr>
	<tr>
		<td>
			<span id="searchmodes_<?php echo $this->_tpl_vars['label']; ?>
">
			<?php if (! $this->_tpl_vars['no_tags']): ?>
				<label><input name="category" type="radio" value="tag" onclick="<?php echo $this->_tpl_vars['jvar']; ?>
.setMode(0);">Add Tags</label>
			<?php endif; ?>
			
			<?php if (! $this->_tpl_vars['no_flags']): ?>
				<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_REMOVE_ANY_FLAGS'),@constant('BITGROUP_2'))): ?>
					<label><input name="category" type="radio" value="flag" onclick="<?php echo $this->_tpl_vars['jvar']; ?>
.setMode(1);">Assign Agents</label>
				<?php endif; ?>
			<?php endif; ?>
			
			<?php if (! $this->_tpl_vars['no_suggestions']): ?>
				<label><input name="category" type="radio" value="agent" onclick="<?php echo $this->_tpl_vars['jvar']; ?>
.setMode(1);">Suggest Agents</label>
			<?php endif; ?>
			</span>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap">
			<span id="quickWorkflowMode0_<?php echo $this->_tpl_vars['label']; ?>
" style="display:none;">
			<table cellpadding="0" cellspacing="0" width="100%" border="0">
				<tr>
					<td>
					<b>Enter tags separated by commas:</b><br>
			            <div class="searchdiv">
		                    <div class="searchautocomplete">
		                        <input name="tag_input" id="tag_input_<?php echo $this->_tpl_vars['label']; ?>
" size="45" />
		                        <div id="searchcontainer_<?php echo $this->_tpl_vars['label']; ?>
" class="searchcontainer"></div>
		                    </div>
			            </div>
					</td>
				</tr>
				<?php if (! $this->_tpl_vars['hide_submit']): ?>
				<tr>
					<td align="right"><input type="button" onclick="<?php echo $this->_tpl_vars['jvar']; ?>
.tagAction();" value="+ Apply" class="cer_button_face" /></td>
				</tr>
				<?php endif; ?>
			</table>
			</span>
			
			<span id="quickWorkflowMode1_<?php echo $this->_tpl_vars['label']; ?>
" style="display:none;">
			<table cellpadding="0" cellspacing="0" width="100%" border="0">
				<tr>
					<td nowrap="nowrap"><img src="includes/images/icone/16x16/find.gif" alt="Find text" title="Find text" width="16" height="16" />
					<input name="keyword" type="text" value="" size="35" onkeypress="return <?php echo $this->_tpl_vars['jvar']; ?>
.handleEnter(this, event);" /><input type="button" name="find" onclick="<?php echo $this->_tpl_vars['jvar']; ?>
.search();" value="Find" title="Search" /></td>
				</tr>
				<tr>
					<td>
						<span id="quickWorkflowResults_<?php echo $this->_tpl_vars['label']; ?>
">You can find workflow items by category or keywords.<br>
						Clicking 'Find' with no search criteria will quickly list all items.</span>
					</td>
				</tr>
				<?php if (! $this->_tpl_vars['hide_submit']): ?>
				<tr>
					<td align="right"><input type="button" onclick="<?php echo $this->_tpl_vars['jvar']; ?>
.resultsAction();" value="+ Add" class="cer_button_face" /></td>
				</tr>
				<?php endif; ?>
			</table>
			</span>
		</td>
	</tr>
</table>