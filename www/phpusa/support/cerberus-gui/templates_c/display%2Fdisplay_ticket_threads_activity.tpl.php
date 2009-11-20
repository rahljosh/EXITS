<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:13
         compiled from display/display_ticket_threads_activity.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'display/display_ticket_threads_activity.tpl.php', 20, false),
array('modifier', 'replace', 'display/display_ticket_threads_activity.tpl.php', 20, false),
array('modifier', 'makehrefs', 'display/display_ticket_threads_activity.tpl.php', 20, false),
array('modifier', 'regex_replace', 'display/display_ticket_threads_activity.tpl.php', 20, false),
array('modifier', 'nl2br', 'display/display_ticket_threads_activity.tpl.php', 20, false),
array('modifier', 'lower', 'display/display_ticket_threads_activity.tpl.php', 170, false),)); ?><?php if ($this->_tpl_vars['oThread']->thread_id == $this->_tpl_vars['o_ticket']->max_thread_id): ?><a name="latest"></a><?php endif; ?>

<div id="thread_<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
" style="display:block;">

<a name="thread_<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
"></a>
		<!---
		&nbsp;<?php echo $this->_tpl_vars['oThread']->thread_display_date; ?>
 
		<?php echo @constant('LANG_WORD_BY'); ?>
 
		<?php echo $this->_tpl_vars['oThread']->thread_display_author; ?>
 (<?php echo $this->_tpl_vars['oThread']->thread_type; ?>
) 
		<?php if ($this->_tpl_vars['oThread']->thread_author->address_banned): ?> (BLOCKED) <?php endif; ?>
		<?php if ($this->_tpl_vars['oThread']->thread_time_worked): ?> (<?php echo @constant('LANG_DISPLAY_TIME_WORKED'); ?>
: <?php echo $this->_tpl_vars['oThread']->thread_time_worked; ?>
)<?php endif; ?>
		--->
  
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#666666" class="table_comment">
      <tr>
        <td>
<img alt="An inbox" src="includes/images/crystal/16x16/<?php if ($this->_tpl_vars['oThread']->is_agent_message): ?>outbox.gif<?php else: ?>inbox.gif<?php endif; ?>" width="16" height="16"> <b><?php echo @constant('LANG_WORD_FROM'); ?>
: <?php echo $this->_tpl_vars['oThread']->thread_display_author; ?>
</b><br>
<?php if (empty ( $this->_tpl_vars['oThread']->thread_subject )): ?>
<?php echo @constant('LANG_WORD_SUBJECT'); ?>
: <?php echo $this->_run_mod_handler('nl2br', true, $this->_run_mod_handler('regex_replace', true, $this->_run_mod_handler('makehrefs', true, $this->_run_mod_handler('replace', true, $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['o_ticket']->ticket_subject), '  ', "&nbsp;&nbsp;"), true, 'cer_display_emailText'), "/(\n|^) /", "\n&nbsp;")); ?>
<br>
<?php else: ?>
<?php echo @constant('LANG_WORD_SUBJECT'); ?>
: <?php echo $this->_run_mod_handler('nl2br', true, $this->_run_mod_handler('regex_replace', true, $this->_run_mod_handler('makehrefs', true, $this->_run_mod_handler('replace', true, $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['oThread']->thread_subject), '  ', "&nbsp;&nbsp;"), true, 'cer_display_emailText'), "/(\n|^) /", "\n&nbsp;")); ?>
<br>
<?php endif; ?>

<?php if (! empty ( $this->_tpl_vars['oThread']->thread_to ) && ! $this->_tpl_vars['oThread']->is_agent_message): ?>
To: <?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['oThread']->thread_to); ?>
<br>
<?php endif; ?>
<?php if (! empty ( $this->_tpl_vars['oThread']->thread_cc )): ?>
Cc: <?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['oThread']->thread_cc); ?>
<br>
<?php endif; ?>

<?php if (! empty ( $this->_tpl_vars['oThread']->thread_replyto ) && ! $this->_tpl_vars['acl']->has_restriction(@constant('REST_EMAIL_ADDY'),@constant('BITGROUP_2'))): ?>
Reply-To: <?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['oThread']->thread_replyto); ?>
<br>
<?php endif; ?>

Date: <?php echo $this->_tpl_vars['oThread']->thread_date_rfc; ?>
<br>

<br>
<?php echo $this->_run_mod_handler('nl2br', true, $this->_run_mod_handler('regex_replace', true, $this->_run_mod_handler('makehrefs', true, $this->_run_mod_handler('replace', true, $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['oThread']->thread_content), '  ', "&nbsp;&nbsp;"), true, 'cer_display_emailText'), "/(\n|^) /", "\n&nbsp;")); ?>

		</td>
      </tr>
		<tr>
			<td>
			  <?php if ($this->_tpl_vars['suppress_links'] === false): ?>
			  
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  
			  	
				  <tr>
					<td align="left">
						<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
								<!---&nbsp;[ <a href="<?php echo $this->_tpl_vars['oThread']->url_reply; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_REPLY'); ?>
</a> ]--->
			
								[ <a href="javascript:;" onclick="displayReply(<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
);" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_REPLY'); ?>
</a> ]
								
								<?php if ($this->_tpl_vars['o_ticket']->properties->show_forward_thread === true): ?>
									[ <a href="javascript:;" onclick="displayForward(<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
);" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_FORWARD'); ?>
</a> ]
								<?php endif; ?>
								
							&nbsp;[ <a href="javascript:;" onclick="displayComment(<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
);" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_COMMENT'); ?>
</a> ]
						<?php endif; ?>
						
						[ <a href="javascript:toggleThreadOptions(<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
);" class="link_ticket_cmd">More Options...</a> ]
					</td>
			   	  </tr>
			    </table>
			   	    
				<div id="thread_<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
_options" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="left">
						&nbsp;<span>options: </span>
						<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
						
								<?php if ($this->_tpl_vars['o_ticket']->properties->show_forward_thread === true): ?>
									<!---[ <a href="<?php echo $this->_tpl_vars['oThread']->url_forward; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_FORWARD'); ?>
</a> ]--->
									[ <a href="<?php echo $this->_tpl_vars['oThread']->url_bounce; ?>
" class="link_ticket_cmd">Redirect</a> ]
								<?php endif; ?>
							
							<?php if ($this->_tpl_vars['oThread']->url_add_req): ?>
								[ <a href="<?php echo $this->_tpl_vars['oThread']->url_add_req; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_ADD_TO_REQUESTERS'); ?>
</a> ]
							<?php endif; ?>
				
							<?php if ($this->_tpl_vars['oThread']->url_block_sender): ?>
								[ <a href="<?php echo $this->_tpl_vars['oThread']->url_block_sender; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_BLOCK_SENDER'); ?>
</a> ]
							<?php endif; ?>
				
							<?php if ($this->_tpl_vars['oThread']->url_unblock_sender): ?>
								[ <a href="<?php echo $this->_tpl_vars['oThread']->url_unblock_sender; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_UNBLOCK_SENDER'); ?>
</a> ]
							<?php endif; ?>
				
							[ <a href="<?php echo $this->_tpl_vars['oThread']->url_strip_html; ?>
" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_STRIP_HTML'); ?>
</a> ]
							
							[ <a href="<?php echo $this->_tpl_vars['oThread']->url_track_time_entry; ?>
" class="link_ticket_cmd">Add Time Worked</a> ]
							
						<?php endif; ?>
			            
						[ <a href="javascript: printTicket('<?php echo $this->_tpl_vars['oThread']->print_thread; ?>
');" class="link_ticket_cmd"><?php echo @constant('LANG_THREAD_PRINT'); ?>
</a> ]
						
					</td>
			   	  </tr>
			    </table>
				</div>
				
			  <?php endif; ?> 
			  
			  	<?php if (! empty ( $this->_tpl_vars['thread_action'] ) && isset ( $this->_tpl_vars['thread'] ) && $this->_tpl_vars['oThread']->thread_id == $this->_tpl_vars['thread']): ?>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<?php if ($this->_tpl_vars['thread_action'] == 'forward'): ?>
			  			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/actions/thread_action_forward.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
					<?php endif; ?>
			   		<?php if ($this->_tpl_vars['thread_action'] == 'bounce'): ?>  
			   			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/actions/thread_action_bounce.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			 		<?php endif; ?>
					<?php if ($this->_tpl_vars['thread_action'] == 'strip_html'): ?>
						<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/actions/thread_action_strip_html.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
					<?php endif; ?>
			    </table>
			   	<?php endif; ?>
			
			</td>
		</tr>

    
    <?php if (count ( $this->_tpl_vars['oThread']->thread_errors )): ?>
    	<tr>
    		<td>
	        	&nbsp;Message Errors:&nbsp;
	        	<?php if ($this->_tpl_vars['suppress_links'] === false): ?>
	        		<a href="<?php echo $this->_tpl_vars['oThread']->url_clear_errors; ?>
">Clear</a>
	        	<?php endif; ?>
    		</td>
    	</tr>
      <tr>
    	<td>
		    <?php if (isset($this->_sections['error'])) unset($this->_sections['error']);
$this->_sections['error']['name'] = 'error';
$this->_sections['error']['loop'] = is_array($this->_tpl_vars['oThread']->thread_errors->errors) ? count($this->_tpl_vars['oThread']->thread_errors->errors) : max(0, (int)$this->_tpl_vars['oThread']->thread_errors->errors);
$this->_sections['error']['show'] = true;
$this->_sections['error']['max'] = $this->_sections['error']['loop'];
$this->_sections['error']['step'] = 1;
$this->_sections['error']['start'] = $this->_sections['error']['step'] > 0 ? 0 : $this->_sections['error']['loop']-1;
if ($this->_sections['error']['show']) {
    $this->_sections['error']['total'] = $this->_sections['error']['loop'];
    if ($this->_sections['error']['total'] == 0)
        $this->_sections['error']['show'] = false;
} else
    $this->_sections['error']['total'] = 0;
if ($this->_sections['error']['show']):

            for ($this->_sections['error']['index'] = $this->_sections['error']['start'], $this->_sections['error']['iteration'] = 1;
                 $this->_sections['error']['iteration'] <= $this->_sections['error']['total'];
                 $this->_sections['error']['index'] += $this->_sections['error']['step'], $this->_sections['error']['iteration']++):
$this->_sections['error']['rownum'] = $this->_sections['error']['iteration'];
$this->_sections['error']['index_prev'] = $this->_sections['error']['index'] - $this->_sections['error']['step'];
$this->_sections['error']['index_next'] = $this->_sections['error']['index'] + $this->_sections['error']['step'];
$this->_sections['error']['first']      = ($this->_sections['error']['iteration'] == 1);
$this->_sections['error']['last']       = ($this->_sections['error']['iteration'] == $this->_sections['error']['total']);
?>
		      <?php echo $this->_tpl_vars['oThread']->thread_errors->errors[$this->_sections['error']['index']]; ?>

		    <?php endfor; endif; ?>
    	 	<br>
    	</td>
	  </tr>
    <?php endif; ?>

    
    
    <?php if (count ( $this->_tpl_vars['oThread']->file_attachments )): ?>
    	<tr>
    		<td>
    		<span><b><?php echo @constant('LANG_DISPLAY_ATTACHMENTS'); ?>
</b>: </span>
    		<?php if (isset($this->_sections['file'])) unset($this->_sections['file']);
$this->_sections['file']['name'] = 'file';
$this->_sections['file']['loop'] = is_array($this->_tpl_vars['oThread']->file_attachments) ? count($this->_tpl_vars['oThread']->file_attachments) : max(0, (int)$this->_tpl_vars['oThread']->file_attachments);
$this->_sections['file']['show'] = true;
$this->_sections['file']['max'] = $this->_sections['file']['loop'];
$this->_sections['file']['step'] = 1;
$this->_sections['file']['start'] = $this->_sections['file']['step'] > 0 ? 0 : $this->_sections['file']['loop']-1;
if ($this->_sections['file']['show']) {
    $this->_sections['file']['total'] = $this->_sections['file']['loop'];
    if ($this->_sections['file']['total'] == 0)
        $this->_sections['file']['show'] = false;
} else
    $this->_sections['file']['total'] = 0;
if ($this->_sections['file']['show']):

            for ($this->_sections['file']['index'] = $this->_sections['file']['start'], $this->_sections['file']['iteration'] = 1;
                 $this->_sections['file']['iteration'] <= $this->_sections['file']['total'];
                 $this->_sections['file']['index'] += $this->_sections['file']['step'], $this->_sections['file']['iteration']++):
$this->_sections['file']['rownum'] = $this->_sections['file']['iteration'];
$this->_sections['file']['index_prev'] = $this->_sections['file']['index'] - $this->_sections['file']['step'];
$this->_sections['file']['index_next'] = $this->_sections['file']['index'] + $this->_sections['file']['step'];
$this->_sections['file']['first']      = ($this->_sections['file']['iteration'] == 1);
$this->_sections['file']['last']       = ($this->_sections['file']['iteration'] == $this->_sections['file']['total']);
?>
    				
		    	<a href="<?php echo $this->_tpl_vars['oThread']->file_attachments[$this->_sections['file']['index']]->file_url; ?>
">
		    	<?php echo $this->_tpl_vars['oThread']->file_attachments[$this->_sections['file']['index']]->file_name; ?>
 (<?php echo $this->_tpl_vars['oThread']->file_attachments[$this->_sections['file']['index']]->display_size; ?>
)</a>&nbsp;&nbsp;
		    <?php endfor; endif; ?>
    		</td>
    	</tr>
    <?php endif; ?>
    
    </table>

   <form id="displayreply<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
" action="display.php" enctype="multipart/form-data" method="post">
		<input type="hidden" name="form_submit" value="reply">
		<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['ticket']; ?>
">
		<input type="hidden" name="ticketId" value="<?php echo $this->_tpl_vars['ticket']; ?>
">
		<input type="hidden" name="threadId" value="<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
">
		<span id="reply_<?php echo $this->_tpl_vars['oThread']->thread_id; ?>
"></span>
	</form>

    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="right"><a href="#top" class="link_ticket_cmd"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_DISPLAY_BACK_TO_TOP')); ?>
</a></td></tr>
	</table>

	<br>
	
	</div>