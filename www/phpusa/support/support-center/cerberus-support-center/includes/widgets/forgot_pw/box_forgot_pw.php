<script language="javascript1.2">
	function verifyChangePassword(pass1,pass2) {
		if(pass1.value == "" || pass2.value == "") {
			alert ("ERROR: Passwords cannot be blank.");
			return false;
		}
		
		if(pass1.value == pass2.value) {
			return true;
		}
		else {
			alert ("ERROR: Passwords do not match.");
			return false;
		}
	}
</script>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Forgot Password</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<form action="<?php echo BASE_URL; ?>" name="forgot_email">
				<input type="hidden" name="form_submit" value="forgot_email">
				<input type="hidden" name="mod_id" value="<?php echo MODULE_FORGOT_PW; ?>">
			
				<?php if(!empty($pass_email)) { ?>
				<tr>
					<td valign="top" colspan="3"><span class="success"><?php echo $pass_email; ?></span></td>
				</tr>
				<?php } ?>
				
				<?php if(!empty($fail_email)) { ?>
				<tr>
					<td valign="top" colspan="3"><span class="fail"><?php echo $fail_email; ?></span></td>
				</tr>
				<?php } ?>
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						If you've forgotten the password to your account, enter your e-mail address below.  
						You will be sent a confirmation code which will allow you to choose a new password.
					</td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>E-mail Address:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="forgot_email" size="40" value="<?php echo @$forgot_email; ?>"></td>
				</tr>
				
			</table>
			
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back" align="right"><input type="submit" class="button_style" value="Send Confirmation"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

<br>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Have a Confirmation Code?</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<form action="<?php echo BASE_URL; ?>" name="forgot_code" onsubmit="javascript:return verifyChangePassword(this.forgot_password, this.verify_password);">
				<input type="hidden" name="form_submit" value="forgot_code">
				<input type="hidden" name="mod_id" value="<?php echo MODULE_FORGOT_PW; ?>">
			
				<?php if(!empty($pass_code)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="success"><?php echo $pass_code; ?></span></td>
				</tr>
				<?php } ?>
				
				<?php if(!empty($fail_code)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="fail"><?php echo $fail_code; ?></span></td>
				</tr>
				<?php } ?>
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						If you received a confirmation code by e-mail, enter it below to choose a new
						password for your account.
					</td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>E-mail Address:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="forgot_email" size="40" value="<?php echo @$forgot_email; ?>"></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>Confirmation Code:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="forgot_code" size="19" value="<?php echo @$forgot_code; ?>"></td>
				</tr>
			
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><B>Note:</B> In your confirmation code, 'O' will always be the be the letter O, not zero.</td>
				</tr>
				
				<tr>
					<td valign="top" colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>New Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="password" name="forgot_password" size="20" value=""></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Confirm Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="password" name="verify_password" size="20" value=""></td>
				</tr>
				
			</table>
			
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back" align="right"><input type="submit" class="button_style" value="Update Password"></td>
				</tr>
			</table>		
		
		</td>
	</tr>
</table>
	

</form>
