<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:10
         compiled from display/display_ticket_heading.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'display/display_ticket_heading.tpl.php', 4, false),
array('modifier', 'lower', 'display/display_ticket_heading.tpl.php', 23, false),)); ?><table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td colspan="2" valign="top">
    	<span class="text_title">Ticket #<?php echo $this->_tpl_vars['o_ticket']->ticket_mask_id; ?>
: <?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['wsticket']->subject); ?>
</span>
    	<br>
    	<b>Status:</b> 
	    <?php if (! $this->_tpl_vars['wsticket']->is_closed && ! $this->_tpl_vars['wsticket']->is_deleted): ?>open
	    <?php elseif ($this->_tpl_vars['wsticket']->is_closed && ! $this->_tpl_vars['wsticket']->is_deleted): ?>closed
	    <?php elseif ($this->_tpl_vars['wsticket']->is_deleted): ?>deleted<?php endif; ?>
	    &nbsp; &nbsp;
	   <b>Priority:</b> 
    	<?php if (empty ( $this->_tpl_vars['wsticket']->priority )): ?><img src="includes/images/icone/16x16/star_alpha.gif" width="16" height="16" border="0" title="None" alt="No Priority"> None
    	<?php elseif ($this->_tpl_vars['wsticket']->priority > 0 && $this->_tpl_vars['wsticket']->priority <= 25): ?><img src="includes/images/icone/16x16/star_grey.gif" width="16" height="16" border="0" title="Lowest" alt="Lowest Priority"> Lowest
    	<?php elseif ($this->_tpl_vars['wsticket']->priority > 25 && $this->_tpl_vars['wsticket']->priority <= 50): ?><img src="includes/images/icone/16x16/star_blue.gif" width="16" height="16" border="0" title="Low" alt="Low Priority"> Low
    	<?php elseif ($this->_tpl_vars['wsticket']->priority > 50 && $this->_tpl_vars['wsticket']->priority <= 75): ?><img src="includes/images/icone/16x16/star_green.gif" width="16" height="16" border="0" title="Moderate" alt="Moderate Priority"> Moderate
    	<?php elseif ($this->_tpl_vars['wsticket']->priority > 75 && $this->_tpl_vars['wsticket']->priority <= 90): ?><img src="includes/images/icone/16x16/star_yellow.gif" width="16" height="16" border="0" title="High" alt="High Priority"> High
    	<?php elseif ($this->_tpl_vars['wsticket']->priority > 90 && $this->_tpl_vars['wsticket']->priority <= 100): ?><img src="includes/images/icone/16x16/star_red.gif" width="16" height="16" border="0" title="Highest" alt="Highest Priority"> Highest
    	<?php endif; ?>
    	&nbsp; &nbsp;
	   <b>Due:</b> 
    	<?php if ($this->_tpl_vars['wsticket']->date_due->mktime_datetime): ?><?php echo $this->_tpl_vars['wsticket']->date_due->getUserDate(); ?>
<?php else: ?>Not set<?php endif; ?>
    	<br>
    	<a href="<?php echo $this->_tpl_vars['urls']['tab_display']; ?>
#latest" class="cer_footer_text"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_DISPLAY_JUMP_TO_LATEST')); ?>
</a>
    	
   		  | <a href="my_cerberus.php?mode=layout#layout_display" class="cer_footer_text"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_DISPLAY_CUSTOMIZE_LAYOUT')); ?>
</a>
   	
    </td>
  </tr>
  <tr> 
    <td valign="top">
    <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_navbar.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	</td>
  </tr>
</table>