<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [22] Upload Supplements</title>
</head>

<body>

<cftry>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#AppPath.onlineApp.URL#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#AppPath.onlineApp.URL#pics/notes.gif"></td>
		<td class="tablecenter"><h2>Page [22] - Upload Supplements</h2></td>
		<td width="42" class="tableside"><img src="#AppPath.onlineApp.URL#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3>
			<cfform action="qr_upload_page22.cfm?referrer=#URL.referrer#" name="upload_form" method="post" enctype="multipart/form-data" preloader="no">
			<cfinput type="hidden" name="studentid" value="#url.studentid#">
			Please upload your file here. <br>
			EXITS Online Application accepts the following formats: JPG, JPEG, GIF, PDF AND DOC. <br>
			<strong>PLEASE UPLOAD PREFERABLY JPEG, JPG OR GIF FILES.</strong><br>
			If you upload the wrong file, just upload the correct file and the wrong file will be removed. <br><br>
			<div align="center">
			Browse for the file.. <cfinput type="file" name="file_upload" size=35 required="yes" enctype="multipart/form-data" message="You must select a file in order to continue." validateat="onsubmit,onserver">
			<br><br>
			<cfinput type="image" name="upload" src="#AppPath.onlineApp.URL#pics/uploadpage.gif" alt="Upload File to Server"><br>
			</div>
			</cfform>
		</td>
	</tr>
</table>

</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#AppPath.onlineApp.URL#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#AppPath.onlineApp.URL#pics/p_spacer.gif"></td>
		<td width="42"><img src="#AppPath.onlineApp.URL#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>  

</body>
</html>