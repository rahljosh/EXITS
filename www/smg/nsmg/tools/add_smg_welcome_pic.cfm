<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add New Welcome Picture</title>
</head>

<body>

<cfform name="add_pictures" method="post" action="?curdoc=tools/add_smg_welcome_pic_qr" enctype="multipart/form-data" preloader="no">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>New Welcome Pictures</h2></td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table cellpadding="3" cellspacing="2" bgcolor="ffffe6" width=100% class="section">
	<tr><td>&nbsp;</td></tr>
	<tr><td valign="top"><b>Title:</b> <br> <cfinput type="text" name="title" size="70" required="yes" message="Please enter a Title"></td></tr>
	<tr><td valign="top"><b>Description:</b> <br> <textarea name="description" cols="70" rows="7"></textarea></td></tr>
	<tr><td valign="top"><b>Image:</b> <br> <cfinput type="file" name="file_upload" size=50 required="yes" enctype="multipart/form-data" message="Please specify a file."></td></tr>
	<tr><td><b>* Image must be in jpg format. Suggested image size: 240 x 162 pixels.</b></td></tr>
	<tr><td><b>Status:</b> <br>
			<cfselect name="active">
				<option value="1">Active</option>
				<option value="0">Inactive</option>
			</cfselect>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><cfinput name="Submit" type="image" src="pics/update.gif" border=0></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
</cfform>

<!----footer tale---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</body>
</html>
