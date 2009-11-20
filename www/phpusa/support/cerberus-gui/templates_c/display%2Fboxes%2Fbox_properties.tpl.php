<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:10
         compiled from display/boxes/box_properties.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'math', 'display/boxes/box_properties.tpl.php', 59, false),
array('function', 'assign', 'display/boxes/box_properties.tpl.php', 61, false),
array('modifier', 'string_format', 'display/boxes/box_properties.tpl.php', 67, false),
array('modifier', 'short_escape', 'display/boxes/box_properties.tpl.php', 119, false),)); ?><?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
<form id="workflowForm" name="workflowForm" action="display.php" style="margin:0px;">
<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['ticket']; ?>
">
<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
<input type="hidden" name="form_submit" value="ticket_modify_workflow">

<table border="0" cellpadding="2" cellspacing="0" class="table_green" width="100%">
      <tr>
        <td class="bg_green"><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><span class="text_title_white"><img src="includes/images/icone/16x16/folder_gear.gif" alt="A gear" width="16" height="16" /> Properties
              </span></td>
              </tr>
        </table></td>
      </tr>
      <tr>
        <td bgcolor="#F5FBEE"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="green_heading"><?php echo @constant('LANG_WORD_STATUS'); ?>
:</td>
              </tr>
              <tr>
                <td>
                <select name="ticket_status">
                	<option value="open" <?php if (! $this->_tpl_vars['wsticket']->is_closed && ! $this->_tpl_vars['wsticket']->is_deleted): ?>selected<?php endif; ?>>open
                	<option value="closed" <?php if ($this->_tpl_vars['wsticket']->is_closed && ! $this->_tpl_vars['wsticket']->is_deleted): ?>selected<?php endif; ?>>closed
                	<option value="deleted" <?php if ($this->_tpl_vars['wsticket']->is_deleted): ?>selected<?php endif; ?>>deleted
                </select>
                </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading"><?php echo @constant('LANG_WORD_PRIORITY'); ?>
:</td>
              </tr>
              <tr>
                <td class="green_heading">
                	<table cellpadding="0" cellspacing="0">
                		<tr>
                			<td align="center"><label for="priority0"><img src="includes/images/icone/16x16/star_alpha.gif" width="16" height="16" border="0" title="None" alt="No Priority"></label></td>
                			<td align="center"><label for="priority1"><img src="includes/images/icone/16x16/star_grey.gif" width="16" height="16" border="0" title="Lowest" alt="Lowest Priority"></label></td>
                			<td align="center"><label for="priority2"><img src="includes/images/icone/16x16/star_blue.gif" width="16" height="16" border="0" title="Low" alt="Low Priority"></label></td>
                			<td align="center"><label for="priority3"><img src="includes/images/icone/16x16/star_green.gif" width="16" height="16" border="0" title="Moderate" alt="Moderate Priority"></label></td>
                			<td align="center"><label for="priority4"><img src="includes/images/icone/16x16/star_yellow.gif" width="16" height="16" border="0" title="High" alt="High Priority"></label></td>
                			<td align="center"><label for="priority5"><img src="includes/images/icone/16x16/star_red.gif" width="16" height="16" border="0" title="Highest" alt="Highest Priority"></label></td>
                		</tr>
                		<tr>
                			<td align="center"><input id="priority0" type="radio" name="ticket_priority" value="0" <?php if (empty ( $this->_tpl_vars['wsticket']->priority )): ?>checked<?php endif; ?>></td>
                			<td align="center"><input id="priority1" type="radio" name="ticket_priority" value="25" <?php if ($this->_tpl_vars['wsticket']->priority > 0 && $this->_tpl_vars['wsticket']->priority <= 25): ?>checked<?php endif; ?>></td>
                			<td align="center"><input id="priority2" type="radio" name="ticket_priority" value="50" <?php if ($this->_tpl_vars['wsticket']->priority > 25 && $this->_tpl_vars['wsticket']->priority <= 50): ?>checked<?php endif; ?>></td>
                			<td align="center"><input id="priority3" type="radio" name="ticket_priority" value="75" <?php if ($this->_tpl_vars['wsticket']->priority > 50 && $this->_tpl_vars['wsticket']->priority <= 75): ?>checked<?php endif; ?>></td>
                			<td align="center"><input id="priority4" type="radio" name="ticket_priority" value="90" <?php if ($this->_tpl_vars['wsticket']->priority > 75 && $this->_tpl_vars['wsticket']->priority <= 90): ?>checked<?php endif; ?>></td>
                			<td align="center"><input id="priority5" type="radio" name="ticket_priority" value="100" <?php if ($this->_tpl_vars['wsticket']->priority > 90 && $this->_tpl_vars['wsticket']->priority <= 100): ?>checked<?php endif; ?>></td>
                		</tr>
                	</table>
              	 </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading"><?php echo @constant('LANG_WORD_SPAM_PROBABILITY'); ?>
:</td>
              </tr>
              <?php if ($this->_tpl_vars['wsticket'] && $this->_tpl_vars['wsticket']->spam_probability): ?>
              		<?php echo $this->_plugins['function']['math'][0](array('assign' => 'spam_rating','equation' => "100*x",'x' => $this->_tpl_vars['wsticket']->spam_probability), $this) ; ?>

              	<?php else: ?>
              		<?php echo $this->_plugins['function']['assign'][0](array('var' => 'spam_rating','value' => '0'), $this) ; ?>

              <?php endif; ?>
              <tr>
                <td>
			 			<table border="0" cellpadding="2" cellspacing="0">
				 			<tr>
				 				<td bgcolor="#<?php if ($this->_tpl_vars['spam_rating'] > 90): ?>FF0000<?php else: ?>00BB00<?php endif; ?>"><font color="white"><b><?php echo $this->_run_mod_handler('string_format', true, $this->_tpl_vars['spam_rating'], "%0.2f"); ?>
%</b></font></td>
				 				<td>
				 				<?php if ($this->_tpl_vars['wsticket']->spam_trained == 0): ?>
				 				<select name="ticket_spam" class="cer_footer_text">
		 							<option value="spam" <?php if ($this->_tpl_vars['spam_rating'] >= 90): ?>selected<?php endif; ?>><?php echo @constant('LANG_TICKET_SPAM_TRAINING_IS'); ?>

		 							<option value="notspam" <?php if ($this->_tpl_vars['spam_rating'] < 90): ?>selected<?php endif; ?>><?php echo @constant('LANG_TICKET_SPAM_TRAINING_NOT'); ?>

		 						</select>
		 						<?php else: ?>
		 							<?php if ($this->_tpl_vars['wsticket']->spam_trained == 1): ?><?php echo @constant('LANG_TICKET_IS_HAM'); ?>
<?php else: ?><?php echo @constant('LANG_TICKET_IS_SPAM'); ?>
<?php endif; ?>
		 						<?php endif; ?>
				 				</td>
				 			</tr>
			 			</table>
                </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading">Mailbox:</td>
              </tr>
              <tr>
                <td nowrap>
                	<select name="ticket_queue">
                	<?php if (count((array)$this->_tpl_vars['queues'])):
    foreach ((array)$this->_tpl_vars['queues'] as $this->_tpl_vars['queueId'] => $this->_tpl_vars['queue']):
?>
                		<option value="<?php echo $this->_tpl_vars['queueId']; ?>
" <?php if ($this->_tpl_vars['wsticket']->queue_id == $this->_tpl_vars['queueId']): ?>selected<?php endif; ?>><?php echo $this->_tpl_vars['queue']->queue_name; ?>

                	<?php endforeach; endif; ?>
                	</select>
                </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading"><?php echo @constant('LANG_DISPLAY_DUE'); ?>
:</td>
              </tr>
              <tr>
                <td nowrap>
		          	<input type="text" name="ticket_due" value="<?php if ($this->_tpl_vars['wsticket']->date_due->mktime_datetime): ?><?php echo $this->_tpl_vars['wsticket']->date_due->getUserDate(); ?>
<?php endif; ?>" size="24">
						<a href="javascript:;" onclick="drawTicketDueCalendar(<?php echo $this->_tpl_vars['wsticket']->id; ?>
);"><img src="includes/images/icon_calendar.gif" border="0" align="middle" alt="<?php echo @constant('LANG_DISPLAY_SHOW_CALENDAR'); ?>
"></a>
						<div id="duecal"></div>
                </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading">Hide From Quick Assign Until:</td>
              </tr>
              <tr>
                <td nowrap>
		          	<input type="text" name="ticket_delay" value="<?php if ($this->_tpl_vars['wsticket']->date_delay->mktime_datetime): ?><?php echo $this->_tpl_vars['wsticket']->date_delay->getUserDate(); ?>
<?php endif; ?>" size="24">
						<a href="javascript:;" onclick="drawTicketDelayCalendar(<?php echo $this->_tpl_vars['wsticket']->id; ?>
);"><img src="includes/images/icon_calendar.gif" border="0" align="middle" alt="<?php echo @constant('LANG_DISPLAY_SHOW_CALENDAR'); ?>
"></a>
						<div id="delaycal"></div>
                </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading"><?php echo @constant('LANG_DISPLAY_PROPS_TICKET_SUBJECT'); ?>
:</td>
              </tr>
              <tr>
                <td nowrap>
						<input type="text" name="ticket_subject" size="24" value="<?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['wsticket']->subject); ?>
">
                </td>
              </tr>
              <tr>
                <td style="padding-top:3px;" class="green_heading">Waiting On Customer Reply:</td>
              </tr>
              <tr>
                <td nowrap>
						<label><input type="radio" name="ticket_waiting_on_customer" value="1" <?php if ($this->_tpl_vars['wsticket']->is_waiting_on_customer): ?>checked<?php endif; ?>>Yes</label>
						<label><input type="radio" name="ticket_waiting_on_customer" value="0" <?php if (! $this->_tpl_vars['wsticket']->is_waiting_on_customer): ?>checked<?php endif; ?>>No</label>
                </td>
              </tr>
              <tr>
              	<td align="right"><input type="submit" value="Save Changes" class='cer_button_face'></td>
              </tr>
          </table></td>
      </tr>
    </table>
    
</form>
<?php endif; ?>
<br>