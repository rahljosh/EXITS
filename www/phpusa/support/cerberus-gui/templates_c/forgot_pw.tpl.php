<?php /* Smarty version 2.5.0, created on 2007-01-15 19:07:00
         compiled from forgot_pw.tpl.php */ ?>
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
</head>

<body bgcolor="#FFFFFF">

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td align="center"><img alt="Cerberus Logo" src="logo.gif"></td>
	</tr>
</table>
<br>

<?php if (! empty ( $this->_tpl_vars['pemail'] )): ?><span class="cer_configuration_updated"><?php echo @constant('LANG_LOGIN_PW_SENT'); ?>
</span><br><?php endif; ?>
<?php if (! empty ( $this->_tpl_vars['pemail_verify'] )): ?><span class="cer_configuration_updated"><?php echo @constant('LANG_LOGIN_PW_VERIFY'); ?>
</span><br><?php endif; ?>
<table width="400" border="0" cellspacing="0" cellpadding="2" align="center" style="border: 1px solid #BBBBBB;">
  <form name="loginForm_lost1" method="post" action="do_login.php">
  <input type="hidden" name="form_submit" value="email">
  <tr class="boxtitle_green_glass"> 
  	<td colspan="2"><?php echo @constant('LANG_LOGIN_PW_LOST1'); ?>
</td>
  </tr>
  <tr>
    <td colspan="2" valign="top" align="left" bgcolor="#DDDDDD"> 
        <table width="100%" border="0" cellspacing="2" cellpadding="0">
          <tr> 
            <td width="1%" nowrap class="cer_maintable_heading">E-mail Address:</td>
            <td width="99%"><input type="text" name="email_address" size="30" style="width:100%;" maxlength="128"></td>
          </tr>
          <tr>
          	<td colspan="2" align="right"><input type="submit" class="cer_button_face" value="<?php echo @constant('LANG_LOGIN_PW_LOST_SEND'); ?>
"></td>
          </tr>
        </table>
    </td>
  </form>
  </tr>
</table>
<br>

<table width="400" border="0" cellspacing="0" cellpadding="2" align="center" style="border: 1px solid #BBBBBB;">
  <form name="loginForm_lost2" method="post" action="do_login.php">
  <input type="hidden" name="form_submit" value="email_verify">
  <tr class="boxtitle_blue_glass"> 
  	<td colspan="2"><?php echo @constant('LANG_LOGIN_PW_LOST2'); ?>
</td>
  </tr>
  <tr>
    <td width="1%" nowrap class="cer_maintable_heading" bgcolor="#DDDDDD"><?php echo @constant('LANG_LOGIN_PW_LOST2_IE'); ?>
:</td>
    <td width="99%" nowrap align="left" bgcolor="#DDDDDD">
    	<input type="text" name="email_verify" size="9" maxlength="12">
    	<input type="submit" class="cer_button_face" value="<?php echo @constant('LANG_BUTTON_SUBMIT'); ?>
">
    </td>
  </tr>
  </form>
</table>
<br>

<div align="center"><a href="login.php" class="cer_footer_text">Return to Login Form</a></div>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
</body>
</html>