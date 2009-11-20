<?php /* Smarty version 2.5.0, created on 2007-01-15 18:54:15
         compiled from views/mass_actions.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'cat', 'views/mass_actions.tpl.php', 109, false),)); ?><?php if ($this->_tpl_vars['view']->show_mass || $this->_tpl_vars['view']->show_modify): ?>
	<tr valign="middle">
		<td align="left" colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" nowrap>
		
			<script type="text/javascript">
				var massWorkflow<?php echo $this->_tpl_vars['view']->view_slot; ?>
 = new CerQuickWorkflow('<?php echo $this->_tpl_vars['view']->view_slot; ?>
','viewform_<?php echo $this->_tpl_vars['view']->view_slot; ?>
');
				
				massWorkflow<?php echo $this->_tpl_vars['view']->view_slot; ?>
.post = function() <?php echo '{'; ?>

				<?php echo '}'; ?>

			</script>
		
			<table cellpadding="3" cellspacing="0" border="0">
			
			<tr>
				<td valign="top" nowrap>
					<select name="mass_action" class="cer_footer_text" onchange="changeMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.value);">
						<option value="">- Perform action? -
						<option value="status">Set status:
						<option value="priority">Set priority:
						<option value="queue">Set mailbox:
						<option value="due">Set due date:
						<option value="spam">Set spam training:
						<option value="waiting">Set waiting on customer:
						<option value="blocked">Set blocked sender:
						<option value="merge">Merge tickets into:
						<option value="flag">Take/release:
						<option value="tag">Apply tags:
						<option value="workflow">Assign/suggest agents:
					</select>	
				</td>
				
				<td valign="top" nowrap>
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_status" style="display:none;">
						<select name="ma_status" class="cer_footer_text">
						  <option value="open">open
						  <option value="closed">closed
						  <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_DELETE'))): ?>
						  	<option value="deleted">deleted
						  <?php endif; ?>
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_status);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_priority" style="display:none;">
						<select name="ma_priority" class="cer_footer_text">
						  <option value="0">none
						  <option value="25">lowest
						  <option value="50">low
						  <option value="75">moderate
						  <option value="90">high
						  <option value="100">highest
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_priority);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_due" style="display:none;">
						<input type="text" name="ma_due" value="+24 hours" size="24">
						<!---<span id="mass_due_cal">[[ calendar ]]</span>--->
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_due);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_spam" style="display:none;">
						<select name="ma_spam" class="cer_footer_text">
						  <option value="1">spam
						  <option value="0">not spam
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_spam);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_waiting" style="display:none;">
						<select name="ma_waiting" class="cer_footer_text">
						  <option value="1">yes
						  <option value="0">no
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_waiting);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_blocked" style="display:none;">
						<select name="ma_blocked" class="cer_footer_text">
						  <option value="1">yes
						  <option value="0">no
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_blocked);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_merge" style="display:none;">
						<input type="text" name="ma_merge" value="" size="24">
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_merge);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_queue" style="display:none;">
						<select name="ma_queue" class="cer_footer_text">
						<?php if (count((array)$this->_tpl_vars['queues'])):
    foreach ((array)$this->_tpl_vars['queues'] as $this->_tpl_vars['queueId'] => $this->_tpl_vars['queue']):
?>
						  <option value="<?php echo $this->_tpl_vars['queueId']; ?>
"><?php echo $this->_tpl_vars['queue']->queue_name; ?>

					   <?php endforeach; endif; ?>
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_queue);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_flag" style="display:none;">
						<select name="ma_flag" class="cer_footer_text">
						  <option value="1">Take
						  <option value="0">Release
						</select>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_flag);">
					</span>

					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_workflow" style="display:none;">
						<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("widgets/quickworkflow/quickworkflow.tpl.php", array('jvar' => $this->_run_mod_handler('cat', true, 'massWorkflow', $this->_tpl_vars['view']->view_slot),'label' => $this->_tpl_vars['view']->view_slot,'hide_submit' => true,'no_tags' => true));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
						<label><input type="radio" name="workflow_mode" value="1" checked> Add</label> 
						<label><input type="radio" name="workflow_mode" value="0"> Remove</label>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,null);">
					</span>
					
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_tag" style="display:none;">
						<b>Enter tags separated by commas:</b><br>
			            <div class="searchdiv">
		                    <div class="searchautocomplete">
		                        <input name="ma_tags" id="tag_input<?php echo $this->_tpl_vars['view']->view_slot; ?>
" size="45" />
		                        <div id="searchcontainer<?php echo $this->_tpl_vars['view']->view_slot; ?>
" class="searchcontainer"></div>
		                    </div>
			            </div>
						<input type="button" value=" &gt;&gt " onclick="javascript:addMassAction('<?php echo $this->_tpl_vars['view']->view_slot; ?>
',this.form,this.form.ma_tags);">
					</span>
				</td>
				
				<td valign="top">
					<span id="<?php echo $this->_tpl_vars['view']->view_slot; ?>
_mass_commit" style="display:none;">
						<b>With selected tickets:</b><br>
						<select size="5" name="mass_commit"></select><br>
						<!---<input type="button" class="cer_button_face" value="Echo" onclick="echoMassAction(this.form);">--->
						<input type="button" class="cer_button_face" value="Cancel" onclick="cancelMassAction(this.form,'<?php echo $this->_tpl_vars['view']->view_slot; ?>
');">
						<input type="button" class="cer_button_face" value="Remove Selected" onclick="removeMassAction(this.form);">
						<input type="hidden" name="mass_commit_list" value="">
						<input type="button" class="cer_button_face" value="<?php echo @constant('LANG_WORD_COMMIT'); ?>
" onclick="commitMassActions(this.form);">
					</span>
				</td>
				
			</tr>
			
			</table>
			
		</td>
	</tr>
	
	<script>
		YAHOO.util.Event.addListener(document.body, "load", autoTags("tag_input<?php echo $this->_tpl_vars['view']->view_slot; ?>
","searchcontainer<?php echo $this->_tpl_vars['view']->view_slot; ?>
"));
	</script>
<?php endif; ?>