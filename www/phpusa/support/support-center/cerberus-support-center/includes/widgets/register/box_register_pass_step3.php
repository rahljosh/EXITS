
<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Create Your Login</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<form action="<?php echo BASE_URL; ?>" name="register_account">
				<input type="hidden" name="form_submit" value="register_account">
				<input type="hidden" name="mod_id" value="<?php echo MODULE_REGISTER; ?>">
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						You will use your e-mail address and this password to log in to your account.
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>E-mail:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<input type="hidden" name="register_email" size="40" value="<?php echo $register_email; ?>">
						<?php echo $register_email; ?>
					</td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>Confirmation Code:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<input type="hidden" name="register_code" size="40" value="<?php echo $register_code; ?>">
						<?php echo $register_code; ?>
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Choose a Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="password" name="account_password" size="20" value="<?php echo @$account_password; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Confirm Password:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="password" name="confirm_password" size="20" value=""></td>
				</tr>
			</table>
		
		</td>
	</tr>
	
</table>

<br>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Contact Information</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						Please provide the following information to finalize your account.
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>First Name:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<input type="text" name="account_name_first" size="16" value="<?php echo @$account_name_first; ?>">
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Last Name:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<input type="text" name="account_name_last" size="32" value="<?php echo @$account_name_last; ?>">
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Street Address:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<input type="text" name="account_address" size="40" value="<?php echo @$account_address; ?>"><br>
					</td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>City:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_city" size="40" value="<?php echo @$account_city; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>State/Province:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_state" size="40" value="<?php echo @$account_state; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>ZIP/Postal Code:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_zip" size="40" value="<?php echo @$account_zip; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Country:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_country" size="40" value="<?php echo @$account_country; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Work Phone:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_phone_work" size="40" value="<?php echo @$account_phone_work; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Home Phone:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_phone_home" size="40" value="<?php echo @$account_phone_home; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Mobile Phone:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_phone_mobile" size="40" value="<?php echo @$account_phone_mobile; ?>"></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>Fax:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="account_phone_fax" size="40" value="<?php echo @$account_phone_fax; ?>"></td>
				</tr>
				
			</table>		
		
		</td>
	</tr>
	
</table>
	
<br>

<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
	<tr>
		<td class="white_back" align="right"><input type="submit" class="button_style" value="Create Account"></td>
	</tr>
</table>
</form>
