<?php /* Smarty version 2.5.0, created on 2007-01-15 21:55:27
         compiled from my_cerberus/my_cerberus_heading.tpl.php */ ?>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td colspan="2" valign="top" class="cer_display_header"><?php echo @constant('LANG_MYCERBERUS'); ?>
 
    	<span class="cer_maintable_text"><?php echo @constant('LANG_MYCERBERUS_CUSTOMSETTINGSFOR'); ?>
 <b><?php echo $this->_tpl_vars['user_login']; ?>
</b></span>
    </td>
  </tr>
  <tr> 
    <td valign="top">
    <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("my_cerberus/my_cerberus_navbar.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	</td>
  </tr>
</table>