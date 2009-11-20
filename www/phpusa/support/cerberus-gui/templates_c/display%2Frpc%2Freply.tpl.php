<?php /* Smarty version 2.5.0, created on 2007-01-15 22:05:14
         compiled from display/rpc/reply.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'cat', 'display/rpc/reply.tpl.php', 37, false),
array('modifier', 'quote', 'display/rpc/reply.tpl.php', 38, false),)); ?><input type="hidden" name="threadId" value="<?php echo $this->_tpl_vars['threadId']; ?>
">
<table border="0" width="100%" cellpadding="0" cellspacing="0" class="table_reply">
	<tr>
		<td colspan="2" class="text_title_white">Reply</td>
	</tr>
	<tr>
		<td colspan="2">
			<a href="javascript:;" onclick="doDisplaySpellCheck('replytext<?php echo $this->_tpl_vars['threadId']; ?>
');"><img src="includes/images/icone/16x16/document_check.gif" width="16" height="16" border="0" align="middle" onmouseover="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'Spellcheck');" onmouseout="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'');" alt="Spellcheck"></a>
			<a href="javascript:;" onclick="doTemplate(<?php echo $this->_tpl_vars['ticketId']; ?>
,'replytext<?php echo $this->_tpl_vars['threadId']; ?>
');"><img src="includes/images/icone/16x16/document.gif" width="16" height="16" border="0" align="middle" onmouseover="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'Insert E-mail Template');" onmouseout="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'');" alt="Document"></a>
			<a href="javascript:;" onclick="displayGetSig('replytext<?php echo $this->_tpl_vars['threadId']; ?>
');"><img src="includes/images/icone/16x16/mail_write.gif" width="16" height="16" border="0" align="middle" onmouseover="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'Append Signature');" onmouseout="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'');" alt="Envelope with Pen"></a>
			<!---<a href="javascript:;"><img src="includes/images/icone/16x16/book_blue_view.gif" width="16" height="16" border="0" align="middle" onmouseover="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'Spellcheck');" onmouseout="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'');"></a>--->
			<a href="javascript:;" onclick="displayReplyAddAttach(<?php echo $this->_tpl_vars['threadId']; ?>
);"><img src="includes/images/icone/16x16/document_attachment.gif" width="16" height="16" border="0" align="middle" onmouseover="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'Add Attachment');" onmouseout="displayReplyToolTip(<?php echo $this->_tpl_vars['threadId']; ?>
,'');" alt="Attachment"></a>
			<span id="displayreplytip<?php echo $this->_tpl_vars['threadId']; ?>
"class="box_text" style="border:1px solid #f5f5f5;padding:2px;color:#ffffff;background-color:#0000b5;visibility:hidden;"></span>
		</td>
	</tr>
	<tr>
		<td align="right" width="0%" nowrap="nowrap"><b>From:&nbsp</b></td>
		<td width="100%"><?php echo $this->_tpl_vars['wsticket']->queue_reply_to; ?>
</td>
	</tr>
	<tr>
		<td align="right" width="0%" nowrap="nowrap"><b>To:&nbsp</b></td>
		<td width="100%"><?php if (isset($this->_foreach['reqs'])) unset($this->_foreach['reqs']);
$this->_foreach['reqs']['name'] = 'reqs';
$this->_foreach['reqs']['total'] = count((array)$this->_tpl_vars['wsticket']->getRequesters());
$this->_foreach['reqs']['show'] = $this->_foreach['reqs']['total'] > 0;
if ($this->_foreach['reqs']['show']):
$this->_foreach['reqs']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['wsticket']->getRequesters() as $this->_tpl_vars['reqId'] => $this->_tpl_vars['req']):
        $this->_foreach['reqs']['iteration']++;
        $this->_foreach['reqs']['first'] = ($this->_foreach['reqs']['iteration'] == 1);
        $this->_foreach['reqs']['last']  = ($this->_foreach['reqs']['iteration'] == $this->_foreach['reqs']['total']);
?>
			<?php echo $this->_tpl_vars['req']; ?>
<?php if (! $this->_foreach['reqs']['last']): ?>, <?php endif; ?>
		<?php endforeach; endif; ?>
		</td>
	</tr>
	<tr>
		<td align="right" width="0%" nowrap="nowrap" valign="top"><b>Cc:&nbsp</b></td>
		<td width="100%"><textarea name="reply_cc" cols="64" rows="2"></textarea></td>
	</tr>
	<tr>
		<td align="right" width="0%" nowrap="nowrap" valign="top"><b>Bcc:&nbsp</b></td>
		<td width="100%"><textarea name="reply_bcc" cols="64" rows="2"></textarea></td>
	</tr>
	<tr><!--- &gt; On <?php echo $this->_tpl_vars['date']; ?>
, <?php echo $this->_tpl_vars['sender']; ?>
 wrote: --->
		<td colspan="2"><textarea id="replytext<?php echo $this->_tpl_vars['threadId']; ?>
" name="reply" cols="50" rows="10" class="input_reply">
<?php if ($this->_tpl_vars['sig_auto'] && $this->_tpl_vars['sig_pos'] == 1): ?><?php echo $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cat', true, "\r\n", $this->_tpl_vars['sig']), "\r\n\r\n"); ?>
<?php endif; ?>
<?php echo $this->_run_mod_handler('quote', true, $this->_tpl_vars['text']); ?>

<?php if ($this->_tpl_vars['sig_auto'] && $this->_tpl_vars['sig_pos'] == 0): ?><?php echo $this->_tpl_vars['sig']; ?>
<?php endif; ?>
</textarea></td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="0%" nowrap><b><label>Actions:</label> </b></td>
					<td valign="top" width="100%"><div id="replyaction<?php echo $this->_tpl_vars['threadId']; ?>
" style="display:block;">
					<label>Set priority to </label>
						<label><input type="radio" name="reply_action_priority" value="0" <?php if (empty ( $this->_tpl_vars['wsticket']->priority )): ?>checked<?php endif; ?>><img src="includes/images/icone/16x16/star_alpha.gif" width="16" height="16" border="0" title="None" alt="No Priority"></label>
						<label><input type="radio" name="reply_action_priority" value="25" <?php if ($this->_tpl_vars['wsticket']->priority > 0 && $this->_tpl_vars['wsticket']->priority <= 25): ?>checked<?php endif; ?>><img src="includes/images/icone/16x16/star_grey.gif" width="16" height="16" border="0" title="Lowest" alt="Lowest Priority"></label>
						<label><input type="radio" name="reply_action_priority" value="50" <?php if ($this->_tpl_vars['wsticket']->priority > 25 && $this->_tpl_vars['wsticket']->priority <= 50): ?>checked<?php endif; ?>><img src="includes/images/icone/16x16/star_blue.gif" width="16" height="16" border="0" title="Low" alt="Low Priority"></label>
						<label><input type="radio" name="reply_action_priority" value="75" <?php if ($this->_tpl_vars['wsticket']->priority > 50 && $this->_tpl_vars['wsticket']->priority <= 75): ?>checked<?php endif; ?>><img src="includes/images/icone/16x16/star_green.gif" width="16" height="16" border="0" title="Moderate" alt="Moderate Priority"></label>
						<label><input type="radio" name="reply_action_priority" value="90" <?php if ($this->_tpl_vars['wsticket']->priority > 75 && $this->_tpl_vars['wsticket']->priority <= 90): ?>checked<?php endif; ?>><img src="includes/images/icone/16x16/star_yellow.gif" width="16" height="16" border="0" title="High" alt="High Priority"></label>
						<label><input type="radio" name="reply_action_priority" value="100" <?php if ($this->_tpl_vars['wsticket']->priority > 90 && $this->_tpl_vars['wsticket']->priority <= 100): ?>checked<?php endif; ?>><img src="includes/images/icone/16x16/star_red.gif" width="16" height="16" border="0" title="Highest" alt="Highest Priority"></label>
					<br>
					<label>Set status to </label>
						<label><input type="radio" name="reply_action_status" value="open" <?php if ($this->_tpl_vars['wsticket']->is_deleted == 0 && $this->_tpl_vars['wsticket']->is_closed == 0): ?>checked<?php endif; ?>>open</label>
						<label><input type="radio" name="reply_action_status" value="closed" <?php if ($this->_tpl_vars['wsticket']->is_closed == 1 && $this->_tpl_vars['wsticket']->is_deleted == 0): ?>checked<?php endif; ?>>closed</label>
						<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_DELETE'))): ?>
						<label><input type="radio" name="reply_action_status" value="deleted" <?php if ($this->_tpl_vars['wsticket']->is_deleted == 1): ?>checked<?php endif; ?>>deleted</label>
						<?php endif; ?>
					<br>
					<label><input type="checkbox" value="1" name="reply_action_release"> Release flag on ticket</label><br>
					<label><input type="checkbox" value="1" name="reply_action_waiting"> Set Waiting on Customer</label><br>
					</div></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="button" onclick="form.submit();" class="cer_button_face" value="Send">
			<input type="button" onclick="displayClearThread('<?php echo $this->_tpl_vars['threadId']; ?>
');" class="cer_button_face" value="Discard">
		</td>
	</tr>
</table>