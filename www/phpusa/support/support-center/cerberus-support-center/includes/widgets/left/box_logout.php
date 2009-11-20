<table width="100%"  border="0" cellspacing="0" cellpadding="0" id="box">
  <tr>
    <td class="boxtitle">Logged In</td>
  </tr>
	
	<form action="<?php echo DIRECTORY_NAME . "/do_login.php" ?>" method="post">
	<input type="hidden" name="form_submit" value="do_logout">
	<input type="hidden" name="return_url" value="<?php echo FULL_URL; ?>">
	<tr>
		<td align="center" class="box_content_cell"><input type="submit" class="home_button" value="Log out" style="width:100%"></td>
	</tr>
	</form>
</table>

<br>
