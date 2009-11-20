<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:10
         compiled from display/boxes/box_contact.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'short_escape', 'display/boxes/box_contact.tpl.php', 14, false),
array('modifier', 'lower', 'display/boxes/box_contact.tpl.php', 56, false),)); ?><table border="0" cellpadding="2" cellspacing="0" class="table_blue" bgcolor="#F0F0FF" width="100%">
      <tr>
        <td class="bg_blue"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><span class="text_title_white"><img src="includes/images/icone/16x16/businessman2.gif" alt="contact" width="16" height="16"/> Contact</span></td>
        </tr>
        </table></td>
      </tr>
      <?php if ($this->_tpl_vars['o_ticket']->sla->pub_user): ?>
	      <tr>
	        <td valign="top" class="orange_heading"> Name:</td>
	      </tr>
	      <tr>
	        <td valign="top"><a href="<?php echo $this->_tpl_vars['o_ticket']->sla->pub_user->url_view; ?>
" class="link_ticket_cmd"><?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['o_ticket']->sla->pub_user->account_name_first); ?>
<?php if ($this->_tpl_vars['o_ticket']->sla->pub_user->account_name_last): ?> <?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['o_ticket']->sla->pub_user->account_name_last); ?>
<?php endif; ?></a></td>
	      </tr>
	      <tr>
	        <td valign="top" class="orange_heading">Company:</td>
	      </tr>
	      <tr>
	        <td valign="top"><a href="#" class="link_ticket_cmd">
				<?php if (! empty ( $this->_tpl_vars['o_ticket']->sla->pub_user->company_ptr )): ?>
					<a href="<?php echo $this->_tpl_vars['o_ticket']->sla->pub_user->company_ptr->url_view; ?>
" class="link_ticket_cmd"><?php echo $this->_tpl_vars['o_ticket']->sla->pub_user->company_ptr->company_name; ?>
</a>
				<?php else: ?>
					<?php echo @constant('LANG_DISPLAY_NO_COMPANY'); ?>

				<?php endif; ?>
	        </td>
	      </tr>
	      <tr>
	        <td valign="top" class="orange_heading">SLA:</td>
	      </tr>
	      <tr>
	        <td valign="top">
		      <?php if (! empty ( $this->_tpl_vars['o_ticket']->sla->sla_plan )): ?>
		      	<?php echo $this->_run_mod_handler('short_escape', true, $this->_tpl_vars['o_ticket']->sla->sla_plan->sla_name); ?>

		      <?php else: ?>
		      	<span><?php echo @constant('LANG_DISPLAY_NO_SLA_PLAN'); ?>
</span>
		      <?php endif; ?>
	       </td>
	      </tr>
	      
	   <?php else: ?> 
			<tr> 
		      <td>
		      	<b>This address isn't assigned<br>to a contact or company.</b><br>
		      </td>
		    </tr>
			<tr> 
		      <td valign="middle">
		      	<a href="<?php echo $this->_tpl_vars['urls']['clients']; ?>
" target="_blank"><?php echo @constant('LANG_DISPLAY_ADDRESS_NOT_ASSIGNED_SEARCH'); ?>
</a><br>
		      </td>
		   </tr>
		   <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE'))): ?>
			<tr> 
		      <td valign="middle">
		      	<a href="<?php echo $this->_tpl_vars['urls']['contact_add']; ?>
" target="_blank" title="<?php if (! $this->_tpl_vars['acl']->has_restriction(@constant('REST_EMAIL_ADDY'),@constant('BITGROUP_2'))): ?><?php echo $this->_tpl_vars['o_ticket']->requestor_address->address; ?>
<?php endif; ?>"><?php echo @constant('LANG_DISPLAY_ADDRESS_NOT_ASSIGNED_CREATE'); ?>
<br>
		      	<?php echo $this->_run_mod_handler('lower', true, @constant('LANG_WORD_REQUESTER')); ?>
</a><br>
		      </td>
		    </tr>
		   <?php endif; ?>
      <?php endif; ?>
</table>
<br>