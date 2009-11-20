<?php /* Smarty version 2.5.0, created on 2007-01-19 08:21:45
         compiled from reports/reports_home.tpl.php */ ?>
<span class="cer_display_header"><?php echo @constant('LANG_REPORTS_HEADING'); ?>
</span><br>
<span class="cer_maintable_text"><?php echo @constant('LANG_REPORTS_INSTRUCTIONS'); ?>
</span><br>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  <tr class="boxtitle_green_glass"> 
    <td>&nbsp;<?php echo @constant('LANG_REPORTS_SYSTEMREPORTS'); ?>
</td>
  </tr>
  <tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_table_row_line"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
  
  <tr bgcolor="#DDDDDD" class="cer_maintable_text">
    <td bgcolor="#DDDDDD" class="cer_maintable_text" align="left">
    
    	<table cellpadding="0" cellspacing="0" border="0" width="100%">
    		<?php if (count((array)$this->_tpl_vars['report_list']->reports)):
    foreach ((array)$this->_tpl_vars['report_list']->reports as $this->_tpl_vars['report']):
?>
    		<tr>
    			<td class="cer_maintable_text" valign="middle" align="top">
    				&nbsp;<a href="<?php echo $this->_tpl_vars['report']->report_url; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['report']->report_name; ?>
</a>
    				 -- <?php echo $this->_tpl_vars['report']->report_summary; ?>

    			</td>
    		</tr>
		  	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
		  	<?php endforeach; endif; ?>
		  	
		  	<?php if (empty ( $this->_tpl_vars['report_list']->reports )): ?>
			  	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" class="cer_maintable_text"><?php echo @constant('LANG_REPORTS_NOREPORTSAVAILABLE'); ?>
</td></tr>
			<?php endif; ?>
    	</table>
    	
    </td>
  </tr>
</table>