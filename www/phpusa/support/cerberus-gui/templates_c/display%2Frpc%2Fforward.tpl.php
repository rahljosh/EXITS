<?php /* Smarty version 2.5.0, created on 2007-01-22 14:48:40
         compiled from display/rpc/forward.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'quote', 'display/rpc/forward.tpl.php', 20, false),)); ?><table border="0" width="100%" cellpadding="0" cellspacing="0" class="table_reply">
	<tr>
		<td class="text_title_white">Forward</td>
	</tr>
	<tr>
		<td>
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
		<td nowrap="nowrap"><b>To:</b><br><input type="text" name="reply_to" size="64" style="width:98%;" /></td>
	</tr>
	<tr><!--- &gt; On <?php echo $this->_tpl_vars['date']; ?>
, <?php echo $this->_tpl_vars['sender']; ?>
 wrote: --->
		<td><textarea id="replytext<?php echo $this->_tpl_vars['threadId']; ?>
" name="reply" cols="50" rows="10" class="input_reply">
<?php if ($this->_tpl_vars['sig_auto'] && $this->_tpl_vars['sig_pos'] == 1): ?><?php echo $this->_tpl_vars['sig']; ?>
<?php endif; ?>
<?php echo $this->_run_mod_handler('quote', true, $this->_tpl_vars['text']); ?>

<?php if ($this->_tpl_vars['sig_auto'] && $this->_tpl_vars['sig_pos'] == 0): ?><?php echo $this->_tpl_vars['sig']; ?>
<?php endif; ?>
</textarea></td>
	</tr>
	<tr>
		<td>
			<input type="button" onclick="form.submit();" class="cer_button_face" value="Send">
			<input type="button" onclick="displayClearThread('<?php echo $this->_tpl_vars['threadId']; ?>
');" class="cer_button_face" value="Discard">
		</td>
	</tr>
</table>