<script language="javascript1.2">
	function verifyChangePassword(current,pass1,pass2) {
		if(current.value == "") {
			alert ("ERROR: You must enter your current password.");
			return false;
		}
		
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

<form action="<?php echo BASE_URL; ?>" method="post" name="my_account">
<input type="hidden" name="form_submit" value="my_account">
<input type="hidden" name="mod_id" value="<?php echo MODULE_MY_ACCOUNT; ?>">

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Contact Information</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
			
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				
				<?php if(!empty($pass_account)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="success"><?php echo $pass_account; ?></span></td>
				</tr>
				<?php } ?>
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						Please make sure the following contact information is current.
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>First Name:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td>
						<input type="text" name="account_name_first" size="16" value="<?php echo htmlentities($public_user->account_name_first); ?>">
					</td>
				</tr>

				<tr>
					<td valign="top" class="box_content_text"><B>Last Name:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td>
						<input type="text" name="account_name_last" size="32" value="<?php echo htmlentities($public_user->account_name_last); ?>">
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Street Address:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td>
						<textarea name="account_address" cols="40" rows="3"><?php echo htmlentities($public_user->account_address); ?></textarea><br>
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>City:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_city" size="40" value="<?php echo htmlentities($public_user->account_city); ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>State/Province:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_state" size="40" value="<?php echo htmlentities($public_user->account_state); ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>ZIP/Postal Code:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_zip" size="40" value="<?php echo htmlentities($public_user->account_zip); ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Country:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_country" size="40" value="<?php echo htmlentities($public_user->account_country); ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Work Phone:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_phone_work" size="40" value="<?php echo htmlentities($public_user->account_phone_work); ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Home Phone:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_phone_home" size="40" value="<?php echo htmlentities($public_user->account_phone_home); ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Mobile Phone:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_phone_mobile" size="40" value="<?php echo htmlentities($public_user->account_phone_mobile); ?>"></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>Fax:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="text" name="account_phone_fax" size="40" value="<?php echo htmlentities($public_user->account_phone_fax); ?>"></td>
				</tr>
				
			</table>
			
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back" align="right"><input type="submit" class="button_style" value="Update Account"></td>
				</tr>
			</table>
		
		</td>
	</tr>
	
</table>
	

</form>

<br>

<?php if(!$pubgui->settings["login_plugin_id"]) { ?>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<form action="<?php echo BASE_URL; ?>" name="my_account_password" method="post" onsubmit="javascript:return verifyChangePassword(this.account_password,this.account_new_password,this.confirm_password);">
	<input type="hidden" name="form_submit" value="my_account_password">
	<input type="hidden" name="mod_id" value="<?php echo MODULE_MY_ACCOUNT; ?>">
	<tr>
		<td class="table_header_cell"><span class="black_heading">Change Account Password</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
					
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
			
				<?php if(!empty($pass_password)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="success"><?php echo $pass_password; ?></span></td>
				</tr>
				<?php } ?>
				
				<?php if(!empty($fail_password)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="fail"><?php echo $fail_password; ?></span></td>
				</tr>
				<?php } ?>
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						Fill in the following information to change your password.  Otherwise, leave blank.
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Current Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="password" name="account_password" size="20" value=""></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>New Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="password" name="account_new_password" size="20" value=""></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Confirm Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td><input type="password" name="confirm_password" size="20" value=""></td>
				</tr>
			</table>
			
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back" align="right"><input type="submit" class="button_style" value="Change Password"></td>
				</tr>
			</table>		
		
		</td>
	</tr>
	
</table>

</form>

<?php } /* end change pw logic */ ?>

