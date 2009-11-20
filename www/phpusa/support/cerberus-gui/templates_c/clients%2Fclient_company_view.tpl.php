<?php /* Smarty version 2.5.0, created on 2007-01-24 15:48:31
         compiled from clients/client_company_view.tpl.php */ ?>
<span class="cer_display_header"><?php echo $this->_tpl_vars['company']->company_name; ?>
</span><br>
<span class="cer_maintable_text"><?php echo @constant('LANG_CONTACTS_COMPANY_INSTRUCTIONS'); ?>
 <?php echo @constant('LANG_CONTACTS_COMPANY_INSTRUCTIONS_VIEW'); ?>

</span><br>
<a href="<?php echo $this->_tpl_vars['urls']['clients']; ?>
" class="cer_maintable_heading">&lt;&lt; <?php echo @constant('LANG_CONTACTS_BACK_TO_LIST'); ?>
 </a><br>
<br>

<table border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">

	<tr>
		<td valign="top">
		
			<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_details_editable.tpl.php", array('id' => $this->_tpl_vars['company']->company_id));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php else: ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_details_readonly.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php endif; ?>
			
			<br>
			
		</td>
		
		<td>
			<img src="includes/images/spacer.gif" width="10" height="1" alt="">
		</td>
		
		<td valign="top">
			
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_sla_details.tpl.php", array('sla' => $this->_tpl_vars['company']->sla_ptr));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			
			<br>
			
			<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_assign_contact.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
				<br>
			<?php endif; ?>
			
			<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_delete.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php endif; ?>

		</td>
	</tr>
</table>

<br>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_list.tpl.php", array('showcontrols' => true));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_open_tickets.tpl.php", array('summary' => $this->_tpl_vars['company']->open_tickets));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>