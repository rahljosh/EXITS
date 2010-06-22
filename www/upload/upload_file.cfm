<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../app.css">
	<title>Upload File</title>
</head>
<body>
<!----
<cftry>
---->
<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#AppPath.onlineApp.imageURL#p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#AppPath.onlineApp.imageURL#notes.gif"></td>
		<td class="tablecenter"><h2>Upload File</h2></td>
		<td width="42" class="tableside"><img src="#AppPath.onlineApp.imageURL#p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3>
			<cfform action="qr_upload_file.cfm?folder=#url.folder#" method="post" enctype="multipart/form-data" preloader="no">
			Please upload your file here. <br>
			EXITS Online Application accepts the following formats: JPG, JPEG, GIF, TIF, PNG, PDF AND DOC. <br>
			<strong>Please preferably upload image files such as JPG, JPEG, GIF, TIF OR PNG FILES.</strong><br>
			If you upload the wrong file, just upload the correct file and the wrong file will be removed. <br>
			<br>
			<cfoutput>
			<input type="hidden" name="folder" value=#url.folder#>
			<input type="hidden" name="studentid" value=#url.student#>
			
			</cfoutput>
			<div align="center">
			Browse for the file.. <cfinput type="file" name="file_upload" size=35 required="yes" enctype="multipart/form-data" message="Please specify a file.">
			<br><br>
			<input type="image" src="#AppPath.onlineApp.imageURL#uploadpage.gif" alt="Upload File to Server"><br>
			</div>
			</cfform>
		</td>
	</tr>
</table>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#AppPath.onlineApp.imageURL#p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#AppPath.onlineApp.imageURL#p_spacer.gif"></td>
		<td width="42"><img src="#AppPath.onlineApp.imageURL#p_bottonright.gif" width="42"></td>
	</tr>
</table>

</body>
</html>
<!----
<cfcatch type="">
	<cfinclude template="../email_message.cfm">
</cfcatch>
</cftry>  
---->