<?php /* Smarty version 2.5.0, created on 2007-02-28 14:58:39
         compiled from display/display_ticket_threads_wscomment.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'date_format', 'display/display_ticket_threads_wscomment.tpl.php', 7, false),
array('modifier', 'short_escape', 'display/display_ticket_threads_wscomment.tpl.php', 17, false),
array('modifier', 'nl2br', 'display/display_ticket_threads_wscomment.tpl.php', 17, false),
array('modifier', 'lower', 'display/display_ticket_threads_wscomment.tpl.php', 27, false),)); ?><div id="thread_wscomment_<?php echo $this->_tpl_vars['oStep']->getId(); ?>
" style="display:block;">

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="ticket_display_comment">
  <tr>
	<td>
		<img src="includes/images/icone/16x16/note_pinned.gif" alt="Note" width="16" height="16" border="0"><b><?php echo $this->_tpl_vars['oStep']->getCreatedByAgentName(); ?>
</b> comments:<br>
		Date: <?php echo $this->_run_mod_handler('date_format', true, $this->_tpl_vars['oStep']->getDateCreated(), @constant('LANG_DATE_FORMAT_STANDARD')); ?>
<br>
		<br>
	</td>
  </tr>
	
	<tr>
		<td>
			<table width="100%" cellspacing="1" cellpadding="2" border="0">
				<tr>
					<td width="100%">
					<?php echo $this->_run_mod_handler('nl2br', true, $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['oStep']->getNote())); ?>

					</td>
				</tr>
			</table>
		</td>
	</tr>
	
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td align="right"><a href="#top" class="link_ticket_cmd"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_DISPLAY_BACK_TO_TOP')); ?>
</a></td></tr>
</table>

<br>
</div>