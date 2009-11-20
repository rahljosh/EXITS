<?php /* Smarty version 2.5.0, created on 2007-01-18 15:26:45
         compiled from clients/client_publicuser_view.tpl.php */ ?>
<span class="cer_display_header"><?php echo @constant('LANG_CONTACTS_REGISTRED_VIEW'); ?>
</span><br>
<span class="cer_maintable_text"> <?php echo @constant('LANG_CONTACTS_REGISTRED_INSTRUCTIONS'); ?>
 <?php echo @constant('LANG_CONTACTS_REGISTRED_INSTRUCTIONS_VIEW'); ?>

</span><br>
<a href="<?php echo $this->_tpl_vars['urls']['clients']; ?>
" class="cer_maintable_heading">&lt;&lt; <?php echo @constant('LANG_CONTACTS_BACK_TO_LIST'); ?>
 </a><br>
<br>

<table border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">

	<tr>
		<td valign="top">
		
			<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_details_editable.tpl.php", array('id' => $this->_tpl_vars['user']->public_user_id));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php else: ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_details_readonly.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php endif; ?>
			
		</td>
		
		<td>
			<img src="includes/images/spacer.gif" width="10" height="1" alt="">
		</td>
		
		<td valign="top">

			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_company_details.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			
			<br>
			
			<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_company_sla_details.tpl.php", array('sla' => $this->_tpl_vars['user']->company_ptr->sla_ptr));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			
			<br>
			
			<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
				<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_publicuser_assign_address.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
			<?php endif; ?>
			
		</td>
	</tr>
</table>

<br>

<div id="divCreateTicket"></div>

<table border="0" cellspacing="1" cellpadding="3" bgcolor="#888888" width="100%">
	<script type="text/javascript" src="includes/scripts/yahoo/YAHOO.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
	<script type="text/javascript" src="includes/scripts/yahoo/event.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
	<script type="text/javascript" src="includes/scripts/yahoo/connection.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
	<script type="text/javascript" src="includes/scripts/yahoo/dom.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
	<script type="text/javascript" src="includes/scripts/yahoo/autocomplete.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
	<script type="text/javascript" src="includes/scripts/cerb3/ticket.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
	
	<?php if (! empty ( $this->_tpl_vars['user']->email_addresses ) && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
		<form action="clients.php">
		<input type="hidden" name="form_submit" value="user_update">
		<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
		<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
		<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['params']['id']; ?>
">
	<?php endif; ?>

	<tr>
		<td class="boxtitle_gray_glass_dk"><?php echo @constant('LANG_CONTACTS_REGISTRED_MAILADR_HEADER'); ?>
</td>
	</tr>

	<tr bgcolor="#DDDDDD">
		<td class="cer_maintable_headingSM"><?php echo @constant('LANG_CONTACTS_MAIL'); ?>
</td>
	</tr>

	<?php if (isset($this->_foreach['email'])) unset($this->_foreach['email']);
$this->_foreach['email']['name'] = 'email';
$this->_foreach['email']['total'] = count((array)$this->_tpl_vars['user']->email_addresses);
$this->_foreach['email']['show'] = $this->_foreach['email']['total'] > 0;
if ($this->_foreach['email']['show']):
$this->_foreach['email']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['user']->email_addresses as $this->_tpl_vars['addy_id'] => $this->_tpl_vars['email']):
        $this->_foreach['email']['iteration']++;
        $this->_foreach['email']['first'] = ($this->_foreach['email']['iteration'] == 1);
        $this->_foreach['email']['last']  = ($this->_foreach['email']['iteration'] == $this->_foreach['email']['total']);
?>
		<tr bgcolor="#EEEEEE">
			<td class="cer_maintable_text">
				<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
					<input type="checkbox" name="puaids[]" value="<?php echo $this->_tpl_vars['addy_id']; ?>
">
				<?php endif; ?>
				<?php echo $this->_tpl_vars['email']; ?>

				<a href="javascript:;" onclick="createTicketWithFrom('<?php echo $this->_tpl_vars['email']; ?>
');" class="box_text">create new ticket</a>
			</td>
		</tr>
	<?php endforeach; endif; ?>
	
	<?php if (! empty ( $this->_tpl_vars['user']->email_addresses ) && $this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
		
		<tr bgcolor="#BBBBBB" align="right">
			<td>
				<span class="cer_maintable_header"><?php echo @constant('LANG_CONTACTS_REGISTRED_MAILADR_WITHSELECTED'); ?>
 </span>
				<select name="user_email_action">
					<option value=""><?php echo @constant('LANG_CONTACTS_REGISTRED_MAILADR_WITHSELECTED_NOTHING'); ?>

					<option value="unassign"><?php echo @constant('LANG_CONTACTS_REGISTRED_MAILADR_WITHSELECTED_UNASSIGN'); ?>

				</select>
				<input type="submit" value="<?php echo @constant('LANG_CONTACTS_REGISTRED_MAILADR_WITHSELECTED_UPDATE'); ?>
" class="cer_button_face">
			</td>
		</tr>
	
		</form>
	<?php endif; ?>
	
</table>

<br>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("clients/client_open_tickets.tpl.php", array('summary' => $this->_tpl_vars['user']->open_tickets));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>