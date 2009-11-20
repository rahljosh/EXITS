
<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">Enter a Confirmation Code</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<form action="<?php echo BASE_URL; ?>" name="register_confirm">
				<input type="hidden" name="form_submit" value="register_confirm">
				<input type="hidden" name="mod_id" value="<?php echo MODULE_REGISTER; ?>">
				
				<?php if(!empty($error_confirm)) { ?>
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><span class="fail"><?php echo $error_confirm; ?></span></td>
				</tr>
				<?php } ?>
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						If you received a confirmation code by e-mail, please enter it below.  If you haven't 
						registered yet, please enter your e-mail address in the section above.
					</td>
				</tr>
				
				<tr>
					<td valign="top" colspan="3"><img src="includes/images/spacer.gif" height="10" width="1"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>E-mail Address:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text"><input type="text" name="register_email" size="40" value="<?php echo @$register_email; ?>"></td>
				</tr>
				
				<tr>
					<td valign="top" class="box_content_text"><B>Confirmation Code:</B></td>
					<td><img src="includes/images/spacer.gif" width="10" height="1"></td>
					<td class="box_content_text">
						<input type="text" name="register_code" size="19" maxlength="19" value="<?php echo $register_code; ?>">
					</td>
				</tr>
				
				<tr>
					<td valign="top" colspan="3" class="box_content_text"><B>Note:</B> In your confirmation code,  'O' will always be the be the letter O, not zero.</td>
				</tr>
			
			</table>
			
			<table cellpadding="4" cellspacing="1" border="0" class="white_back" width='100%'>
				<tr>
					<td class="white_back" align="right"><input type="submit" class="button_style" value="Confirm E-mail Address"></td>
				</tr>
			</table>		
		
		</td>
	</tr>
	
</table>

</form>
