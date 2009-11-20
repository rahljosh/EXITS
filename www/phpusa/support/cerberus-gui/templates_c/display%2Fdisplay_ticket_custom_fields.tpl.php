<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:13
         compiled from display/display_ticket_custom_fields.tpl.php */ ?>
<?php echo '
<script type="text/javascript">
	function toggleDisplayFields() {
		if (document.getElementById) {
			if(document.getElementById("ticket_display_fields").style.display=="block") {
				document.getElementById("ticket_display_fields").style.display="none";
				document.getElementById("ticket_display_fields_icon").src=icon_expand.src;
				document.formSaveLayout.layout_display_show_fields.value = 0;
			}
			else {
				document.getElementById("ticket_display_fields").style.display="block";
				document.getElementById("ticket_display_fields_icon").src=icon_collapse.src;
				document.formSaveLayout.layout_display_show_fields.value = 1;
			}
		}
	}
</script>
'; ?>


<a href="#" onclick="javascript:toggleDisplayFields();"><img alt="Display Custom Fields" id="ticket_display_fields_icon" src="includes/images/<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_fields']): ?>icon_collapse.gif<?php else: ?>icon_expand.gif<?php endif; ?>" width="16" height="16" border="0"></a>
<img alt="A Green Form" src="includes/images/icone/16x16/form_green.gif" width="16" height="16">
<span class="link_ticket"><?php echo @constant('LANG_CONFIG_CUSTOM_FIELDS'); ?>
</span><br>
<table cellspacing="0" cellpadding="0" width="100%"><tr><td bgcolor="#DDDDDD"><img alt="" src="includes/images/spacer.gif" height="1" width="1"></td></tr></table>
<div id="ticket_display_fields" style="display:<?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->page_layouts['layout_display_show_fields']): ?>block<?php else: ?>none<?php endif; ?>;">
<form action="display.php" method="post" name="display_custom_fields" style="margin:0px;">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="ticket_display_table">
<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
<input type="hidden" name="ticket" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
">
<input type="hidden" name="qid" value="<?php echo $this->_tpl_vars['o_ticket']->ticket_queue_id; ?>
">
<input type="hidden" name="mode" value="edit_custom_fields">
<input type="hidden" name="form_submit" value="edit_custom_fields">

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/tabs/display_custom_fields.tpl.php", array('field_handler' => $this->_tpl_vars['o_ticket']->r_field_handler));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("display/tabs/display_custom_fields.tpl.php", array('field_handler' => $this->_tpl_vars['o_ticket']->t_field_handler));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	  
	<tr>
		<td colspan="2">
			<table border=0 cellspacing=0 cellpadding=1 width="100%">
				<?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_TICKET_CHANGE'))): ?>
				<tr>
					<td align="left" valign="top">
						<?php if (! empty ( $this->_tpl_vars['o_ticket']->r_field_handler->group_instances ) || ! empty ( $this->_tpl_vars['o_ticket']->t_field_handler->group_instances )): ?>
								<input type="submit" value="Save Changes">
								<span> -or- </span>
						<?php endif; ?>
						
						<span>Add Field Group </span>
						
						<select name="instantiate_gid">
							<option value="">- none -
							<?php if (isset($this->_foreach['group'])) unset($this->_foreach['group']);
$this->_foreach['group']['name'] = 'group';
$this->_foreach['group']['total'] = count((array)$this->_tpl_vars['o_ticket']->field_handler->group_templates);
$this->_foreach['group']['show'] = $this->_foreach['group']['total'] > 0;
if ($this->_foreach['group']['show']):
$this->_foreach['group']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['o_ticket']->field_handler->group_templates as $this->_tpl_vars['group']):
        $this->_foreach['group']['iteration']++;
        $this->_foreach['group']['first'] = ($this->_foreach['group']['iteration'] == 1);
        $this->_foreach['group']['last']  = ($this->_foreach['group']['iteration'] == $this->_foreach['group']['total']);
?>
								<option value="<?php echo $this->_tpl_vars['group']->group_id; ?>
"><?php echo $this->_tpl_vars['group']->group_name; ?>

							<?php endforeach; endif; ?>
						</select>
						
						<span>&nbsp;to </span>
						
						<select name="instantiate_for">
							<option value="T_<?php echo $this->_tpl_vars['o_ticket']->ticket_id; ?>
">this Ticket
							<option value="R_<?php echo $this->_tpl_vars['o_ticket']->requestor_address->address_id; ?>
">this Requester
						</select>
						
						<input type="submit" value="Save Changes">
					</td>
				</tr>
				<?php endif; ?>
			</table>
		</td>
	</tr>
</table>
</form>
</div>

<br>