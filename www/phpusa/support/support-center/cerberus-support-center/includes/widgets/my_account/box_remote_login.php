<table cellpadding="4" cellspacing="1" border="0" class="main_table" width='100%'>
	<tr>
		<td class="table_header_cell"><span class="black_heading">New E-mail Address Confirmed!</span></td>
	</tr>
	
	<tr>
		<td class="white_back">
		
			<table cellpadding="2" cellspacing="1" border="0" class="white_back">
				<tr>
					<td valign="top" colspan="3" class="box_content_text">
						Congratulations!  Your e-mail address has been added to your account.<br>
						<br>
						<a href="<?php echo BASE_URL; ?>" class='url'>Click here to automatically log in.</a><br>
						<br>
						<b>You will be logged in automatically in 5 seconds!</b><br>
						<br>
					</td>
				</tr>
			</table>
		
		</td>	
	</tr>
</table>

<script>
function remoteConfirmLogin() {
	document.location = "<?php echo BASE_URL; ?>";
}
setTimeout("remoteConfirmLogin();", 5000);
</script>
