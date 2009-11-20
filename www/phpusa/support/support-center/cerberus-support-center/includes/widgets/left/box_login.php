<table width="100%"  border="0" cellspacing="0" cellpadding="0" id="box">
  <tr>
    <td class="boxtitle">Login</td>
  </tr>

	<?php
	$last_error_msg = $cer_session->last_error_msg;
	if (!empty($last_error_msg)) {
	?>
	<tr class="white_back">
		<td class="box_content_text"><span class="fail"><?php echo $last_error_msg; ?></span></td>
	</tr>
	<?php } ?>
  
  <tr>
    <td class="box_content_cell"><table cellpadding="3" cellspacing="0" border="0" width='100%'>
            <form action="<?php echo DIRECTORY_NAME . "/do_login.php" ?>" method="post">
        <input type="hidden" name="form_submit" value="do_login">
        <input type="hidden" name="return_url" value="<?php echo FULL_URL; ?>">
        <tr>
          <td width="40%" class="box_content_text">&nbsp;<?php echo $login_string; ?>:</td>
          <td width="60%"><input type="text" name="auth_user" value="" class="home_input"></td>

        </tr>
        <tr>
          <td class="box_content_text">&nbsp;<?php echo $password_string; ?>:</td>
          <td><input type="password" name="auth_pass" class="home_input"></td>
        </tr>
        <tr align="center">
          <td colspan="2"><input name="submit" type="submit" class="home_button" value="Log in" style="width:98%"></td>
          </tr>

      </form>      
      <tr>
           <td align="center" colspan="2" class="box_content_text">
			   <?php if(!$pubgui->settings["login_plugin_id"] && $pubgui->settings["pub_mod_registration"]) { ?>
			   		<a href="<?php echo BASE_URL . "&mod_id=" . MODULE_REGISTER; ?>"  class='url'>Register</a>
			   		<?php if(!$pubgui->settings["login_plugin_id"]) { ?> | <?php } ?>
			   <?php } ?>
		       <?php if(!$pubgui->settings["login_plugin_id"]) { ?>
		       		<a href="<?php echo BASE_URL . "&mod_id=" . MODULE_FORGOT_PW; ?>" class='url'>Forgot Password?</a>
			   <?php } ?>
           </td>
      </tr>  
    </table></td>
  </tr>
</table>

<br>
