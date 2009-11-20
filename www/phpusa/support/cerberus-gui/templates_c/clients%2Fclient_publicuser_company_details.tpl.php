<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:46
         compiled from clients/client_publicuser_company_details.tpl.php */ ?>
<table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000" width="100%">

	<tr>
		<td class="boxtitle_orange_glass" colspan="2">
			<?php echo @constant('LANG_CONTACTS_REGISTRED_COMPANY_HEADER'); ?>

		</td>
	</tr>

<?php if (! empty ( $this->_tpl_vars['user']->company_ptr )): ?>
	
	<tr bgcolor="#DDDDDD">
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_WORD_COMPANY'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<a href="<?php echo $this->_tpl_vars['user']->company_ptr->url_view; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['user']->company_ptr->company_name; ?>
</a>
		</td>
	</tr>
	
	<?php if ($this->_tpl_vars['user']->company_ptr->sla_ptr->sla_name): ?>
	<tr bgcolor="#DDDDDD">
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_REGISTRED_COMPANY_SLAPLAN'); ?>
:</td>
		<td bgcolor="#EEEEEE">
			<span class="cer_maintable_text">
					<?php echo $this->_tpl_vars['user']->company_ptr->sla_ptr->sla_name; ?>

			</span>
		</td>
	</tr>
	<?php endif; ?>

<?php else: ?>

	<tr bgcolor="#EEEEEE">
		<td colspan="2">
			<span class="cer_maintable_text">
			<?php echo @constant('LANG_CONTACTS_REGISTRED_INSTRUCTIONS_NOCOMPANY'); ?>

			</span>
		</td>
	</tr>
		
<?php endif; ?>
	
</table>		