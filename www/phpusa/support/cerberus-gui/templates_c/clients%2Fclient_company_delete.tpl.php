<?php /* Smarty version 2.5.0, created on 2007-01-24 15:48:31
         compiled from clients/client_company_delete.tpl.php */ ?>
<?php if (empty ( $this->_tpl_vars['company']->num_public_users )): ?>
<?php echo '
<script language="javascript" type="text/javascript">
	function verifyCompanyDelete(f)
	 {
		if(confirm("[Cerberus]: Are you sure you want to permanently remove this company record?"))
			return true;
		else
			return false;
	}
</script>
'; ?>


<form action="clients.php" onsubmit="javascript:return verifyCompanyDelete(this);" style="margin:0px;">
<table border="0" cellpadding="3" cellspacing="1" bgcolor="#000000" width="100%">
	<tr>
		<td class="boxtitle_gray_glass">
			<input type="hidden" name="form_submit" value="company_delete">
			<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
			<input type="hidden" name="mode" value="<?php echo $this->_tpl_vars['params']['mode']; ?>
">
			<input type="hidden" name="id" value="<?php echo $this->_tpl_vars['company']->company_id; ?>
">
			Remove Company Record
		</td>
	</tr>

	<tr bgcolor="#EEEEEE">
		<td class="cer_maintable_text">
			<input type="submit" value="Delete Company Record" class="cer_button_face">
		</td>
	</tr>
</table>	
</form>
<br>
<?php endif; ?>