<?php /* Smarty version 2.5.0, created on 2007-01-15 11:10:41
         compiled from updater.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'assign', 'updater.tpl.php', 1, false),)); ?><?php echo $this->_plugins['function']['assign'][0](array('var' => 'col_span','value' => '2'), $this) ; ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><?php echo @constant('LANG_HTML_TITLE'); ?>
</title>
<META HTTP-EQUIV="content-type" CONTENT="<?php echo @constant('LANG_CHARSET'); ?>
">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV="Pragma-directive" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Directive" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("cerberus.css.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<script type="text/javascript">
<?php echo '
	function selectTopScript() {
		for(e=0;document.upgrade_form.elements.length;e++) {
			if(document.upgrade_form.elements[e].type == "radio") {
				document.upgrade_form.elements[e].checked = 1;
				break;
			}
		}
	}
'; ?>

</script>

</head>

<body onload="selectTopScript();">
<img alt="Cerberus Logo" src="logo.gif"><br>
<br>
<span class="cer_display_header">Cerberus Helpdesk: Database Upgrade/Sync Tool</span><br>
<br>

<table border="0" cellspacing="0" cellpadding="0">
<form action="upgrade.php" method="post" name="upgrade_form">
<input type="hidden" name="form_submit" value="upgrade">
	<?php if (! empty ( $this->_tpl_vars['cer_updater']->ptrs_scripts_clean )): ?>
		<td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#0099FF">
			<span class="cer_maintable_header">&nbsp; Brand New Installation Scripts:</span>
		</td>

		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("upgrade/upgrade_script_list.tpl.php", array('script_list' => $this->_tpl_vars['cer_updater']->ptrs_scripts_clean));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>

	<?php if (! empty ( $this->_tpl_vars['cer_updater']->ptrs_scripts_upgrade )): ?>
		<td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#0099FF">
			<span class="cer_maintable_header">&nbsp; Upgrade Scripts:</span>
		</td>

		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("upgrade/upgrade_script_list.tpl.php", array('script_list' => $this->_tpl_vars['cer_updater']->ptrs_scripts_upgrade));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
	<?php if (! empty ( $this->_tpl_vars['cer_updater']->ptrs_scripts_verify )): ?>
		<td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#0099FF">
			<span class="cer_maintable_header">&nbsp; Database Verification Scripts:</span>
		</td>

		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("upgrade/upgrade_script_list.tpl.php", array('script_list' => $this->_tpl_vars['cer_updater']->ptrs_scripts_verify));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	<?php endif; ?>
	
	<?php if ($this->_tpl_vars['cer_updater']->active_scripts): ?>
      <tr bgcolor="#FFFFFF"> 
        <td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" align="right"><input type="submit" class="cer_button_face" value="Run Script"></td>
      </tr>
	<?php endif; ?>
	
</form>
</table>

<br>
<a href="index.php" class="cer_maintable_text">Return to Cerberus Helpdesk</a>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</body>
</html>