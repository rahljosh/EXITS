<?php /* Smarty version 2.5.0, created on 2007-01-15 11:11:18
         compiled from login.tpl.php */ ?>
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
<link rel="stylesheet" href="skins/fresh/cerberus-theme.css" type="text/css">

<?php echo '
<script type="text/javascript">
function focusLogin() {
	document.loginForm.CER_AUTH_USER.focus();
}
</script>
'; ?>


</head>

<body bgcolor="#FFFFFF" onload="javascript:focusLogin();">

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td align="center"><img alt="Cerberus Logo" src="logo.gif"></td>
	</tr>
</table>
<br>


<?php if (! empty ( $this->_tpl_vars['failed'] )): ?>
<table width="400" border="0" cellspacing="0" cellpadding="2" align="center">
	<tr>
		<td><span class="cer_configuration_updated"><?php echo @constant('LANG_LOGIN_FAILED'); ?>
</span></td>
	</tr>
</table>
<?php endif; ?>

<table width="400" border="0" cellspacing="0" cellpadding="2" align="center" style="border: 1px solid #BBBBBB;">
  <form name="loginForm" method="post" action="do_login.php">
  <input type="hidden" name="redir" value="<?php echo $this->_tpl_vars['redir']; ?>
">
  <input type="hidden" name="form_submit" value="login">
  <tr class="boxtitle_orange_glass"> 
  	<td colspan="2"><?php echo @constant('LANG_LOGIN_LOGIN'); ?>
</td>
  </tr>
  <tr bgcolor="#DDDDDD"> 
  	<td width="1%" nowrap align="right"  class="cer_maintable_heading"><?php echo @constant('LANG_LOGIN_LOGIN'); ?>
: </td>
  	<td width="99%" align="left" nowrap><input type="text" name="CER_AUTH_USER" size="30" maxlength="64" style="width: 99%;"></td>
  </tr>
  <tr bgcolor="#DDDDDD"> 
  	<td width="1%" nowrap align="right" class="cer_maintable_heading"><?php echo @constant('LANG_LOGIN_PW'); ?>
: </td>
  	<td width="99%" align="left" nowrap><input type="password" name="CER_AUTH_PASS" size="30" maxlength="64" style="width: 99%;"></td>
  </tr>
  
  <tr bgcolor="#DDDDDD">
  	<td colspan="2">
  	 	<table width="100%" cellpadding="0" cellspacing="0">
  	 		<tr>
				<td width="1%" nowrap align="left"><a href="forgot_pw.php" class="cer_footer_text"><?php echo @constant('LANG_LOGIN_PW_LOST1'); ?>
</a></td>
		  		<td width="99%" align="right" nowrap><input type="submit" class="cer_button_face" value="<?php echo @constant('LANG_LOGIN_SUBMIT'); ?>
"></td>
		  	</tr>
		</table>
  	</td>
  </tr>
  </form>
</table>  

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</body>
</html>