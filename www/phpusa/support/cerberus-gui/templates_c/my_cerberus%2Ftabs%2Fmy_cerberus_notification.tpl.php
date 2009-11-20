<?php /* Smarty version 2.5.0, created on 2007-01-15 21:55:33
         compiled from my_cerberus/tabs/my_cerberus_notification.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'my_cerberus/tabs/my_cerberus_notification.tpl.php', 1, false),)); ?><?php echo $this->_plugins['function']['assign'][0](array('var' => 'uid','value' => $this->_tpl_vars['session']->vars['login_handler']->user_id), $this) ; ?>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form action="my_cerberus.php" method="post">
<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
<input type="hidden" name="mode" value="notification">
<input type="hidden" name="form_submit" value="notification">

  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_blue_dk"> 
    <td>&nbsp;<?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_HEADER'); ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr bgcolor="#DDDDDD"> 
    <td bgcolor="#DDDDDD">
    
    	<table width="100%" cellpadding="2" cellspacing="1" border="0" bgcolor="#FFFFFF">
    	
    		<tr bgcolor="#DDDDDD">
	    		<td colspan="2" class="cer_maintable_text">
	    			<?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_INSTRUCTIONS'); ?>
</span><br>
					<br>
					<?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_TOKENS_INSTRUCTIONS'); ?>
<br>
					
					<B>##ticket_id##</B> - Ticket ID or Mask<br>
					<B>##ticket_subject##</B> - Ticket Subject<br>
					<B>##ticket_status##</B> - Ticket Status (new, closed, deleted)<br>
					<B>##first_email##</B> - The Body of the Original Ticket Email<br>
					<B>##latest_email##</B> - The Body of the Latest Ticket Email<br>
					<B>##queue_name##</B> - Ticket Queue Name (Support, etc.)<br>
					<B>##requester_address##</B> - The Email Address that Opened the Ticket.<br>
					<br>
					You can also create a direct link to a ticket by modifying the URL below to match the URL in your browser:<br>
					<i>http://localhost/cerberus-gui/</i>display.php?ticket=<b>##ticket_id##</b><br>
				</td>
	    	</tr>
	    	
    		<tr class="boxtitle_blue_glass">
	    		<td colspan="2"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_EVENT_NEWTICKET_HEADER'); ?>
</td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" class="cer_maintable_heading" valign="top">
	    			Teams:
	    			<span class="cer_footer_text">(notify me of tickets created for these teams)</span>
	    		</td>
	    		<td width="99%">
	    		
	    			<table cellpadding="2" cellspacing="1" border="0" bgcolor="#FFFFFF">
	    				<tr bgcolor="#666666">
	    					<td class="cer_maintable_header">Team</td>
	    					<td class="cer_maintable_header"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_SENDTO'); ?>
 <?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_SENDTO_COMMADELIMITED'); ?>
</td>
	    				</tr>
	    				
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
		    				<?php if ($this->_tpl_vars['acl']->teams[$this->_tpl_vars['teamId']]): ?>
		    				<tr bgcolor="#DDDDDD">
		    					<td class="cer_maintable_heading">
		    						<label><input type="checkbox" name="notify_new_enabled[]" value="<?php echo $this->_tpl_vars['teamId']; ?>
" <?php if (isset ( $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_new_ticket->teams_send_to[$this->_tpl_vars['teamId']] )): ?>checked<?php endif; ?>> <b><?php echo $this->_tpl_vars['team']->name; ?>
</b></label>
		    					</td>
		    					<td>
		    						<input type="text" name="notify_new_emails[]" size="45" maxlength="255" value="<?php echo $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_new_ticket->teams_send_to[$this->_tpl_vars['teamId']]; ?>
">
		    						<input type="hidden" name="notify_new_teams[]" value="<?php echo $this->_tpl_vars['teamId']; ?>
">
		    					</td>
		    				</tr>
		    				<?php endif; ?>
	    				<?php endforeach; endif; ?>
	    				
	    			</table>
	    		</td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_EMAILTEMPLATE'); ?>
</td>
	    		<td width="99%"><textarea name="notify_new_template" rows="10" cols="100%"><?php echo $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_new_ticket->template; ?>
</textarea></td>
	    	</tr>
	    	
	    	
    		<tr class="boxtitle_blue_glass">
	    		<td colspan="2"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_EVENT_ASSIGNMENT_HEADER'); ?>
</td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_ENABLED'); ?>
</td>
	    		<td width="99%"><input name="notify_assigned_enabled" type="checkbox" value="1" <?php if ($this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_assignment->enabled): ?>checked<?php endif; ?>></td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_SENDTO'); ?>
</td>
	    		<td width="99%">
	    			<input name="notify_assigned_emails" type="text" size="64" maxlength="255" value="<?php echo $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_assignment->send_to; ?>
">
	    			<span class="cer_footer_text"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_SENDTO_COMMADELIMITED'); ?>
</span>
	    		</td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_EMAILTEMPLATE'); ?>
</td>
	    		<td width="99%"><textarea name="notify_assigned_template" rows="10" cols="100%"><?php echo $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_assignment->template; ?>
</textarea></td>
	    	</tr>

    		<tr class="boxtitle_blue_glass">
	    		<td colspan="2"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_EVENT_CLIENTREPLY_HEADER'); ?>
</td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_ENABLED'); ?>
</td>
	    		<td width="99%"><input name="notify_client_reply_enabled" type="checkbox" value="1" <?php if ($this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_client_reply->enabled): ?>checked<?php endif; ?>></td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_SENDTO'); ?>
</td>
	    		<td width="99%">
	    			<input name="notify_client_reply_emails" type="text" size="64" maxlength="255" value="<?php echo $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_client_reply->send_to; ?>
">
	    			<span class="cer_footer_text"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_SENDTO_COMMADELIMITED'); ?>
</span>
	    		</td>
	    	</tr>
    		<tr bgcolor="#DDDDDD">
	    		<td width="1%" nowrap class="cer_maintable_heading" valign="top"><?php echo @constant('LANG_MYCERBERUS_NOTIFICATIONS_EMAILTEMPLATE'); ?>
:</td>
	    		<td width="99%"><textarea name="notify_client_reply_template" rows="10" cols="100%"><?php echo $this->_tpl_vars['notification']->users[$this->_tpl_vars['uid']]->n_client_reply->template; ?>
</textarea></td>
	    	</tr>

    	</table>

	</td>
  </tr>
  
  <tr>
  	<td style="padding-right:2px;padding-top:2px;padding-bottom:2px" bgcolor="#BBBBBB" align="right"><input type="submit" value="<?php echo @constant('LANG_BUTTON_SUBMIT'); ?>
" class="cer_button_face"></td>
  </tr>
  
</form>
  
</table>

<br>