<?php /* Smarty version 2.5.0, created on 2007-01-24 15:47:23
         compiled from clients/client_company_list.tpl.php */ ?>

	<a name="companies"></a>
	
	<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
	<span class="cer_maintable_text">
		[ <a href="<?php echo $this->_tpl_vars['urls']['company_add']; ?>
" class="cer_maintable_heading"><?php echo @constant('LANG_CONTACTS_ADD_COMPANY'); ?>
</a> ] 
	</span>
	<br>
	<?php endif; ?>
	
	<table border="0" cellspacing="1" cellpadding="3" bgcolor="#888888" width="100%">

		<tr>
			<td class="boxtitle_orange_glass" colspan="5"><?php echo @constant('LANG_CONTACTS_HEADER_COMPANIES'); ?>
</td>
		</tr>
	
		<tr bgcolor="#CCCCCC">
			<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_COMPANY_NAME'); ?>
</td>
			<td class="cer_maintable_headingSM">Service Level (SLA) Plan</td>
			<td class="cer_maintable_headingSM"><?php echo @constant('LANG_WORD_EXPIRES'); ?>
</td>
			<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_PHONE'); ?>
</td>
			<td class="cer_maintable_headingSM" align="center"><?php echo @constant('LANG_CONTACTS_COMPANY_NUMBER'); ?>
</td>
		</tr>
	
		<?php if (isset($this->_foreach['company'])) unset($this->_foreach['company']);
$this->_foreach['company']['name'] = 'company';
$this->_foreach['company']['total'] = count((array)$this->_tpl_vars['company_handler']->companies);
$this->_foreach['company']['show'] = $this->_foreach['company']['total'] > 0;
if ($this->_foreach['company']['show']):
$this->_foreach['company']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['company_handler']->companies as $this->_tpl_vars['company']):
        $this->_foreach['company']['iteration']++;
        $this->_foreach['company']['first'] = ($this->_foreach['company']['iteration'] == 1);
        $this->_foreach['company']['last']  = ($this->_foreach['company']['iteration'] == $this->_foreach['company']['total']);
?>
	
			<tr bgcolor="#<?php if ($this->_foreach['company']['iteration'] % 2 == 0): ?>DFDFDF<?php else: ?>EAEAEA<?php endif; ?>">
				<td class="cer_maintable_text"><a href="<?php echo $this->_tpl_vars['company']->url_view; ?>
" class="cer_maintable_heading"><?php echo $this->_tpl_vars['company']->company_name; ?>
</a></td>
				<td class="cer_maintable_text"><?php echo $this->_tpl_vars['company']->sla_ptr->sla_name; ?>
</td>
				<td class="cer_maintable_text"><?php if ($this->_tpl_vars['company']->sla_expire_date): ?><?php echo $this->_tpl_vars['company']->sla_expire_date->getUserDate("%m/%d/%y"); ?>
<?php endif; ?></td>
				<td class="cer_maintable_text"><?php echo $this->_tpl_vars['company']->company_phone; ?>
</td>
				<td class="cer_maintable_text" align="center"><?php echo $this->_tpl_vars['company']->num_public_users; ?>
</td>
			</tr>
	
		<?php endforeach; endif; ?>
	
	</table>
	
	<table border="0" cellspacing="0" cellpadding="3" bgcolor="#888888" width="100%">
	
		<tr bgcolor="#FFFFFF">
			<td align="right" class="cer_maintable_text">
			<?php if ($this->_tpl_vars['company_handler']->set_url_prev): ?><a href="<?php echo $this->_tpl_vars['company_handler']->set_url_prev; ?>
" class="cer_header_loginLink">&lt;&lt; Prev</a><?php endif; ?>
			<?php echo @constant('LANG_WORD_SHOWING'); ?>
 <B><?php echo $this->_tpl_vars['company_handler']->set_from; ?>
</B> <?php echo @constant('LANG_WORD_TO'); ?>
 <B><?php echo $this->_tpl_vars['company_handler']->set_to; ?>
</B> <?php echo @constant('LANG_WORD_OF'); ?>
 <B><?php echo $this->_tpl_vars['company_handler']->set_of; ?>
</B>
			<?php if ($this->_tpl_vars['company_handler']->set_url_next): ?><a href="<?php echo $this->_tpl_vars['company_handler']->set_url_next; ?>
" class="cer_header_loginLink">Next &gt;&gt;</a><?php endif; ?>
			</td>
		</tr>
	
	</table>
	
	<br>