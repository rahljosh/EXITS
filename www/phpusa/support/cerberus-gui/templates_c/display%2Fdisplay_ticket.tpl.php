<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:10
         compiled from display/display_ticket.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'display/display_ticket.tpl.php', 150, false),
array('modifier', 'cat', 'display/display_ticket.tpl.php', 156, false),
array('modifier', 'cer_href', 'display/display_ticket.tpl.php', 156, false),)); ?><?php if ($this->_tpl_vars['o_ticket']->writeable): ?>
<script type="text/javascript">
tkt = <?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
;

<?php echo '
	function doClone()
  	{
      if(confirm("This will create an identical copy of this ticket\'s threads, comments, attachments and properties to a new ticket id.\\r\\nAfter the ticket is cloned a change to one ticket will not affect the other.\\r\\nAre you sure you want to clone this ticket?"))
      	{
			document.location=formatURL("display.php?form_submit=clone&ticket=" + tkt);				     	
        }
    }
    
	icon_expand = new Image;
	icon_expand.src = "includes/images/icon_expand.gif";
	
	icon_collapse = new Image;
	icon_collapse.src = "includes/images/icon_collapse.gif";

	function toggleThread(th) {
		if (document.getElementById) {
			if(document.getElementById("thread_" + th).style.display=="block") {
				document.getElementById("thread_" + th).style.display="none";
			}
			else {
				document.getElementById("thread_" + th).style.display="block";
			}
		}
	}
	
	function toggleThreadTime(th) {
		if (document.getElementById) {
			if(document.getElementById("thread_track_time_" + th).style.display=="block") {
				document.getElementById("thread_track_time_" + th).style.display="none";
				document.getElementById("thread_track_time_" + th + "_edit").style.display="block";
			}
			else {
				document.getElementById("thread_track_time_" + th).style.display="block";
				document.getElementById("thread_track_time_" + th + "_edit").style.display="none";
			}
		}
	}
	
	function toggleThreadTimeEntry() {
		if (document.getElementById) {
			if(document.getElementById("thread_add_time_entry").style.display=="block") {
				document.getElementById("thread_add_time_entry").style.display="none";
			}
			else {
				document.getElementById("thread_add_time_entry").style.display="block";
			}
		}
	}

	function doTimeEntryAddHelp(prefix,fld) {
		if (document.getElementById) {
			document.getElementById(prefix + "_0").style.display="none";
			document.getElementById(prefix + "_1").style.display="none";
			document.getElementById(prefix + "_2").style.display="none";
			document.getElementById(prefix + "_3").style.display="none";
			
			document.getElementById(prefix + "_" + fld).style.display="block";
		}
	}
	
	var threads_activity_enabled = 1;
	var threads_time_enabled = 1;
	
	function toggleThreadsActivity() {
		
		if(threads_activity_enabled) {
			toggle_to = "none";
			threads_activity_enabled = 0;
		}
		else {
			toggle_to = "block";
			threads_activity_enabled = 1;
		}
		
		if (document.getElementById) {
			'; ?>

				<?php if (count((array)$this->_tpl_vars['o_ticket']->threads)):
    foreach ((array)$this->_tpl_vars['o_ticket']->threads as $this->_tpl_vars['thread_ptr']):
?>
					<?php if ($this->_tpl_vars['thread_ptr']->type == 'email' || $this->_tpl_vars['thread_ptr']->type == 'comment'): ?>
						document.getElementById("thread_<?php echo $this->_tpl_vars['thread_ptr']->ptr->thread_id; ?>
").style.display=toggle_to;
					<?php endif; ?>	
				<?php endforeach; endif; ?>
			<?php echo '
		}
	}
	
	function toggleThreadsTime() {
		
		if(threads_time_enabled) {
			toggle_to = "none";
			threads_time_enabled = 0;
		}
		else {
			toggle_to = "block";
			threads_time_enabled = 1;
		}
		
		if (document.getElementById) {
			'; ?>

				<?php if (count((array)$this->_tpl_vars['o_ticket']->threads)):
    foreach ((array)$this->_tpl_vars['o_ticket']->threads as $this->_tpl_vars['thread_ptr']):
?>
					<?php if ($this->_tpl_vars['thread_ptr']->type == 'time'): ?>
						document.getElementById("thread_track_time_<?php echo $this->_tpl_vars['thread_ptr']->ptr->thread_time_id; ?>
").style.display=toggle_to;
						document.getElementById("thread_track_time_<?php echo $this->_tpl_vars['thread_ptr']->ptr->thread_time_id; ?>
_edit").style.display="none";
					<?php endif; ?>	
				<?php endforeach; endif; ?>
			<?php echo '
		}
	}
	
	function toggleThreadOptions(th) {
		if (document.getElementById) {
			if(document.getElementById("thread_" + th + "_options").style.display=="block") {
				document.getElementById("thread_" + th + "_options").style.display="none";
			}
			else {
				document.getElementById("thread_" + th + "_options").style.display="block";
			}
		}
	}

	
	function calendarPopUp(time,label_id,field_id)
	{
		'; ?>

		url = formatURL("calendar_popup.php?show_time=1&timestamp=" + time + "&label=" + label_id + "&field=" + field_id);
		<?php echo '
		window.open(url,"calendarWin","width=300,height=220,resizable=1");		
	}
	
'; ?>


</script>
<?php endif; ?>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td width="0%" nowrap valign="top" style="padding-right:5px;">
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/boxes/box_properties.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/boxes/box_contact.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/boxes/box_requesters.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		</td>
		<td width="100%" valign="top">
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_heading.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<?php echo $this->_plugins['function']['assign'][0](array('var' => 'uid','value' => $this->_tpl_vars['session']->vars['login_handler']->user_id), $this) ; ?>

			<?php if ($this->_tpl_vars['o_ticket']->writeable): ?>
				<tr>
					<td colspan="2" valign="top" align="right">
					
					<?php if (! isset ( $this->_tpl_vars['wsticket']->flags[$this->_tpl_vars['uid']] ) && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
						[ <a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "display.php?form_submit=take&ticket=", $this->_tpl_vars['wsticket']->id)); ?>
" class="link_navmenu">Take Ticket</a> ]&nbsp;
					<?php endif; ?>
					
					
					<?php if (isset ( $this->_tpl_vars['wsticket']->flags[$this->_tpl_vars['uid']] ) && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
						[ <a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "display.php?form_submit=release&ticket=", $this->_tpl_vars['wsticket']->id)); ?>
" class="link_navmenu">Release Ticket</a> ]&nbsp;
					<?php endif; ?>
					
					
					
					<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
						[ <a href="<?php echo $this->_tpl_vars['urls']['tab_merge']; ?>
" class="link_navmenu"><?php echo @constant('LANG_ACTION_MERGE'); ?>
</a> ]&nbsp;
					<?php endif; ?>
					
					
					<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
						[ <a href="javascript:doClone();" class="link_navmenu"><?php echo @constant('LANG_ACTION_CLONE'); ?>
</a> ]&nbsp;
					<?php endif; ?>
					
			 		
			 		[ <a href="javascript: printTicket('<?php echo $this->_tpl_vars['urls']['print_ticket']; ?>
');" class="link_navmenu"><?php echo @constant('LANG_ACTION_PRINT'); ?>
</a> ]
			    	</td>
				</tr>
			<?php else: ?>
				<tr>
					<td colspan=2>&nbsp;</td>
				</tr>
			<?php endif; ?>
			</table>
			
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_active_modules.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		
		</td>
	</tr>
</table>