<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:11
         compiled from display/display_ticket_threads.tpl.php */ ?>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
  <tr bgcolor="#FFFFFF"> 
    <td class="text_heading" colspan="2">
    	<?php echo @constant('LANG_DISPLAY_THREAD'); ?>

    	
    	
    	<br>
    	<span class="cer_footer_text">
    	
    	<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
    		<a href="javascript:toggleThreadTimeEntry();" class="cer_footer_text"><?php echo @constant('LANG_DISPLAY_THREAD_ADD_TIME'); ?>
</a> 
    		 | 
    	<?php endif; ?>
    	
    	<a href="javascript:toggleThreadsActivity();" class="cer_footer_text"><?php echo @constant('LANG_DISPLAY_THREAD_TOGGLE_ACTIVITY'); ?>
</a>
    	 | 
    	<a href="javascript:toggleThreadsTime();" class="cer_footer_text"><?php echo @constant('LANG_DISPLAY_THREAD_TOGGLE_TIME'); ?>
</a>
    	</span>
    	
    	
    </td>
  </tr>
</table>
<br>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_add_track_time.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/display_ticket_threads_list.tpl.php", array('suppress_links' => false));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>