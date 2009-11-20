<?php
// [JAS]: Pre-populate the e-mail address confirmation.
if(empty($register_email) && !empty($_SESSION["remote_email"])) {
	$register_email = $_SESSION["remote_email"];
}
?>

<script language="javascript1.2">
	function verifyEmail(pass1,pass2) {
		if(pass1.value == "" || pass2.value == "") {
			alert ("ERROR: E-mail addresses cannot be blank.");
			return false;
		}
		
		if(pass1.value == pass2.value) {
			return true;
		}
		else {
			alert ("ERROR: E-mail addresses do not match.");
			return false;
		}
	}
</script>

<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Confirm an E-mail Address</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<form action="<?php echo BASE_URL; ?>" name="register" onsubmit="javascript:return verifyEmail(this.register_email, this.confirm_email);">
				<input type="hidden" name="form_submit" value="register_email">
				<input type="hidden" name="mod_id" value="<?php echo MODULE_REGISTER; ?>">
				
				<?php if(!empty($error_email)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="fail"><?php echo $error_email; ?></span></td>
				</tr>
				<?php } ?>
			
				<?php if(!empty($pass_email)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="success"><?php echo $pass_email; ?></span></td>
				</tr>
				<?php } ?>
				
			<?php if(empty($pass_email)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						Enter the e-mail address you would like to add to your account.  You will be sent a confirmation 
						code which needs to be entered in the section below.
					</td>
				</tr>
				
				<tr>
					<td valign="top" colspan="3"><img src="includes/images/spacer.gif" height="10" width="1"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>IP:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><?php echo $_SERVER['REMOTE_ADDR']; ?></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>E-mail Address:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="register_email" size="40" value="<?php echo @$register_email; ?>"></td>
				</tr>
			
				<tr>
					<td valign="top" class="box_content_text"><B>Confirm E-mail:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="confirm_email" size="40" value="<?php echo @$register_email; ?>"></td>
				</tr>
			<?php } ?>
				
			</table>
		
			<?php if(empty($pass_email)) { ?>
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back" align="right" class="box_content_text"><input type="submit" class="button_style" value="Send Confirmation"></td>
				</tr>
			</table>
			<?php } ?>

		</td>
	</tr>
	
</table>

</form>

<br>

