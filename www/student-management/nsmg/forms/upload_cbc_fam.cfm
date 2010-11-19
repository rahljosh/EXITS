<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../../app.css">
	<title>Upload File</title>
</head>
<body>

<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"></td>
							<td background="pics/header_background.gif"><h2>Upload CBC Form for Household Members</td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>

<div class="section"><br>

<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3><br>
			<cfform action="querys/upload_file_cbc_fam.cfm?id=#url.id#&userid=#url.userid#" method="post" enctype="multipart/form-data" preloader="no">
			Please upload your file here. PDF or Image files accepted. <br>
			If you upload the wrong file, just upload the correct file and the wrong file will be removed. 
			<br><br>
			
			<div align="center">
			Browse for the file.. <cfinput type="file" name="file_upload" size=35 required="yes" enctype="multipart/form-data" message="Please specify a file.">
			<br><br>
			<input type="image" src="pics/uploadpage.gif" alt="Upload File to Server"><br><Br>
			</div>
			</cfform>
		</td>
	</tr>
</table>

</div>

<!--- FOOTER OF TABLE --->
<cfinclude template="../table_footer.cfm">

</body>
</html>