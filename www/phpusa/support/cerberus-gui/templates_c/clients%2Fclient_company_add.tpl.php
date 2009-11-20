<?php /* Smarty version 2.5.0, created on 2007-01-24 15:47:38
         compiled from clients/client_company_add.tpl.php */ ?>
<span class="cer_display_header"><?php echo @constant('LANG_CONTACTS_COMPANY_ADD'); ?>
</span><br>
<span class="cer_maintable_text"><?php echo @constant('LANG_CONTACTS_COMPANY_INSTRUCTIONS'); ?>
</span><br>
<a href="<?php echo $this->_tpl_vars['urls']['clients']; ?>
" class="cer_maintable_heading">&lt;&lt; <?php echo @constant('LANG_CONTACTS_BACK_TO_LIST'); ?>
 </a><br>
<br>

<table border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">

	<tr>
		<td valign="top">
		
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_details_editable.tpl.php", array('id' => ""));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			
		</td>
		
</table>

<br>