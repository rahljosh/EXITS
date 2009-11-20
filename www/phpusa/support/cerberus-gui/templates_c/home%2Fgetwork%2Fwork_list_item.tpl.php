<?php /* Smarty version 2.5.0, created on 2007-01-19 08:20:44
         compiled from home/getwork/work_list_item.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'home/getwork/work_list_item.tpl.php', 10, false),
array('modifier', 'cat', 'home/getwork/work_list_item.tpl.php', 28, false),
array('modifier', 'cer_href', 'home/getwork/work_list_item.tpl.php', 28, false),
array('modifier', 'htmlentities', 'home/getwork/work_list_item.tpl.php', 28, false),
array('modifier', 'date_format', 'home/getwork/work_list_item.tpl.php', 35, false),)); ?><a name="ticket<?php echo $this->_tpl_vars['ticket']->id; ?>
"></a>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
   <tr>
     <td colspan="2"><table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td bgcolor="#eeeeee"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr></table></td>
   </tr>

	<tr>
     <td width="0%" nowrap valign="top">
		<?php if ($this->_tpl_vars['ticket']->priority <= 0): ?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'priority_icon','value' => "star_alpha.gif"), $this) ; ?>

		<?php elseif ($this->_tpl_vars['ticket']->priority <= 25): ?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'priority_icon','value' => "star_grey.gif"), $this) ; ?>

		<?php elseif ($this->_tpl_vars['ticket']->priority <= 50): ?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'priority_icon','value' => "star_blue.gif"), $this) ; ?>

		<?php elseif ($this->_tpl_vars['ticket']->priority <= 75): ?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'priority_icon','value' => "star_green.gif"), $this) ; ?>

		<?php elseif ($this->_tpl_vars['ticket']->priority <= 90): ?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'priority_icon','value' => "star_yellow.gif"), $this) ; ?>

		<?php else: ?>
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'priority_icon','value' => "star_red.gif"), $this) ; ?>

		<?php endif; ?>
     
		<img alt="Priority" src="includes/images/icone/16x16/<?php echo $this->_tpl_vars['priority_icon']; ?>
" width="16" height="16" border="0" align="middle" />
		<?php if (count ( $this->_tpl_vars['ticket']->flags ) > 0 && $this->_tpl_vars['show_flags']): ?><img alt="A flag" title="Flagged" src="includes/images/icone/16x16/flag_red.gif" width="16" height="16" border="0" align="middle"> <?php endif; ?>
		<?php if ($this->_tpl_vars['ticket']->is_waiting_on_customer): ?><img alt="Waiting on Customer" title="Waiting on Customer" src="includes/images/icone/16x16/alarmclock_pause.gif" width="16" height="16" border="0" align="middle"> <?php endif; ?>
     </td>
     <td width="100%" style="background-color:#fff">
     	<a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "display.php?ticket=", $this->_tpl_vars['ticket']->id)); ?>
" class="text_ticket_subject"><?php echo $this->_run_mod_handler('htmlentities', true, $this->_tpl_vars['ticket']->subject); ?>
</a> <span class="box_text">#<?php echo $this->_tpl_vars['ticket']->mask; ?>
</span>
     </td>
   </tr>
   
   <tr>
   	<td></td>
   	<td style="background-color:#fff" class="box_text">
			Updated <?php echo $this->_run_mod_handler('date_format', true, $this->_tpl_vars['ticket']->date_latest_reply); ?>
 by <?php if (! $this->_tpl_vars['acl']->has_restriction(@constant('REST_EMAIL_ADDY'),@constant('BITGROUP_2'))): ?><?php echo $this->_run_mod_handler('htmlentities', true, $this->_tpl_vars['ticket']->address_latest_reply); ?>
<?php else: ?>email<?php endif; ?> 
   	</td>
   </tr>
   
   <tr>
     <td></td>
     <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
       <tr>
         <td style="background-color:#fff"><span id="getworkpre<?php echo $this->_tpl_vars['ticket']->id; ?>
" style="display:none;padding:5px;"></span></td>
       </tr></table></td>
   </tr>

   <tr>
     <td></td>
     <td>
			<a href="javascript:;" onclick="getWorkShowPreview(<?php echo $this->_tpl_vars['ticket']->id; ?>
);" class="link_navmenu"><img alt="Preview" src="includes/images/icone/16x16/window_view.gif" width="16" height="16" border="0" align="middle" style="padding-right:2px;" onmouseover="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'Preview the latest message');" onmouseout="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'');"></a>
     
   		<?php if ($this->_tpl_vars['show_workflow'] && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
	   	<a href="javascript:void(0);" onclick="getWorkWorkflow(<?php echo $this->_tpl_vars['ticket']->id; ?>
);" class="link_navmenu"><img alt="Workflow" src="includes/images/icone/16x16/gear.gif" width="16" height="16" border="0" align="middle" style="padding-right:2px;" onmouseover="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'Set teams, tags and agents workflow');" onmouseout="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'');"></a>
	   	<?php endif; ?>

	   	<?php if ($this->_tpl_vars['show_take'] && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
	   		<?php if (! isset ( $this->_tpl_vars['ticket']->flags[$this->_tpl_vars['user_id']] )): ?>
	   			<a href="javascript:void(0);" onclick="preWorkTake(<?php echo $this->_tpl_vars['ticket']->id; ?>
);" class="link_navmenu"><img alt="Flag" src="includes/images/icone/16x16/flag_green.gif" width="16" height="16" border="0" align="middle" style="padding-right:2px;" onmouseover="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'Flag this ticket in My Tickets');" onmouseout="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'');"></a>
	   		<?php else: ?>
		   		
					<a href="javascript:void(0);" onclick="toggleDiv('getworkrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
');" class="link_navmenu"><img alt="Release" src="includes/images/icone/16x16/document_down.gif" width="16" height="16" border="0" align="middle" style="padding-right:2px;" onmouseover="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'Release my flag on ticket');" onmouseout="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'');"></a>
	   		<?php endif; ?>
	   	<?php endif; ?>
	   	
	   	<?php if ($this->_tpl_vars['show_close'] && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
	   	<a href="javascript:;" onclick="getWorkShowClose(<?php echo $this->_tpl_vars['ticket']->id; ?>
);" class="link_navmenu"><img alt="Close" src="includes/images/icone/16x16/document_error.gif" width="16" height="16" border="0" align="middle" style="padding-right:2px;" onmouseover="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'Close this ticket (with reason)');" onmouseout="getWorkToolTip(<?php echo $this->_tpl_vars['ticket']->id; ?>
,'');"></a>
	   	<?php endif; ?>
	   	
	   	<span id="getworktip<?php echo $this->_tpl_vars['ticket']->id; ?>
" class="box_text" style="border:1px solid #dddddd;padding:2px;background-color:#f5f5f5;visibility:hidden;"></span>
     </td>
   </tr>

   <tr>
     <td></td>
     <td><span id="getworkopts<?php echo $this->_tpl_vars['ticket']->id; ?>
"></span></td>
   </tr>

   <tr>
   	<td></td>
   	<td><span id="getworkrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
" style="display:none;">
   		<form style="margin:0px;" action="javascript:;" onsubmit="return false;" id="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
" name="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
">
   		<input type="hidden" name="cmd" value="getwork_release_delay">
   		<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['ticket']->id; ?>
">
			<b>How soon should this ticket be suggested to you again?</b><br>
			<input type="text" name="release_delay" size="24" value=""><input type="button" value="Release Ticket" onclick="getWorkReleaseDelay('<?php echo $this->_tpl_vars['ticket']->id; ?>
');"><br>
			<br>
			<b>Quick Set:</b> 
			<a href="javascript:;" onclick="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
.release_delay.value='now';getWorkReleaseDelay('<?php echo $this->_tpl_vars['ticket']->id; ?>
');">now</a> 
			| <a href="javascript:;" onclick="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
.release_delay.value='+15 minutes';getWorkReleaseDelay('<?php echo $this->_tpl_vars['ticket']->id; ?>
');">15 minutes</a> 
			| <a href="javascript:;" onclick="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
.release_delay.value='+30 minutes';getWorkReleaseDelay('<?php echo $this->_tpl_vars['ticket']->id; ?>
');">30 minutes</a> 
			| <a href="javascript:;" onclick="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
.release_delay.value='+1 hour';getWorkReleaseDelay('<?php echo $this->_tpl_vars['ticket']->id; ?>
');">1 hour</a> 
			| <a href="javascript:;" onclick="frmrelease<?php echo $this->_tpl_vars['ticket']->id; ?>
.release_delay.value='+1 day';getWorkReleaseDelay('<?php echo $this->_tpl_vars['ticket']->id; ?>
');">1 day</a> 
			<br>
			<br>
			<span class="cer_footer_text"><i>(dates can be entered relatively "+3 hours", "+15 minutes", "Monday", "Next Thursday" or absolutely "2006-12-31 08:00")</i></span>
			</form>
   	</span></td>
   </tr>
   
   <tr>
   	<td></td>
   	<td><span id="getworkclose<?php echo $this->_tpl_vars['ticket']->id; ?>
" style="display:none;">
			<b>Reason for closing?</b>
			<a href="javascript:;" onclick="getWorkClose('<?php echo $this->_tpl_vars['ticket']->id; ?>
');" class="link_navmenu"><img alt="Close Ticket" src="includes/images/icone/16x16/document_ok.gif" width="16" height="16" border="0" align="middle" onmouseover="getWorkToolTip('<?php echo $this->_tpl_vars['ticket']->id; ?>
','Mark ticket as Resolved');" onmouseout="getWorkToolTip('<?php echo $this->_tpl_vars['ticket']->id; ?>
','');" /></a> 
			<a href="javascript:;" onclick="getWorkSpam('<?php echo $this->_tpl_vars['ticket']->id; ?>
');" class="link_navmenu"><img alt="Report Spam" src="includes/images/icone/16x16/spam.gif" width="16" height="16" border="0" align="middle" onmouseover="getWorkToolTip('<?php echo $this->_tpl_vars['ticket']->id; ?>
','Report ticket as Spam');" onmouseout="getWorkToolTip('<?php echo $this->_tpl_vars['ticket']->id; ?>
','');" /></a> 
			<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_DELETE'))): ?>
				<a href="javascript:;" onclick="getWorkTrash('<?php echo $this->_tpl_vars['ticket']->id; ?>
');" class="link_navmenu"><img alt="Send to Trash" src="includes/images/icone/16x16/garbage_empty.gif" width="16" height="16" border="0" align="middle" onmouseover="getWorkToolTip('<?php echo $this->_tpl_vars['ticket']->id; ?>
','Send ticket to Trash');" onmouseout="getWorkToolTip('<?php echo $this->_tpl_vars['ticket']->id; ?>
','');" /></a>   	
			<?php endif; ?>
   	</span></td>
   </tr>
   
   <tr>
     <td></td>
     <td><img src="includes/images/spacer.gif" width="1" height="5" alt=""></td>
   </tr>
   
</table>