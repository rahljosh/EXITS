<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload Family Picture</title>
</head>

<cftry>

<script language="javascript">
<!--//
function GetFile() { 
   document.upload.file_name.value = document.upload.family_pic.value;
}
//--->
</script>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="http://www.exitsapplication.com/exits/pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="http://www.exitsapplication.com/exits/student_app/pics/notes.gif"></td>
		<td class="tablecenter"><h2>Upload Family Album</h2></td>
		<td width="42" class="tableside"><img src="http://www.exitsapplication.com/exits/student_app/pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3>
		<cfform action="qr_upload_album.cfm" method="post" name="upload" enctype="multipart/form-data" preloader="no">
			<cfinput name="file_name" type="hidden"  value=""/>
			<cfinput type="hidden" name="studentid" value="#url.studentid#">
			Please upload recent pictures (within 2 years) of you, your family, and friends.  
			Once you have uploaded your pictures, you will be able to add a description for them. <br> 
			<strong>PICTURES SHOULD BE EITHER JPEG, JPG OR GIF. </strong><br>
			Please make sure the size of each photo is 2mb or less. You can upload up to ten (10) photos.<br><br>
			<div align="center">
			Browse for the file.. <cfinput type="file" name="family_pic" size=35 required="yes" enctype="multipart/form-data" message="You must select a file in order to continue." validateat="onsubmit,onserver">
			<br><br>
			<cfinput type="image" name="upload" src="http://www.exitsapplication.com/exits/student_app/pics/uploadpic.gif" alt="Upload Picture to Server" onClick="GetFile()"><br>
			</div>
		</cfform>
		</td>
	</tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="http://www.exitsapplication.com/exits/student_app/pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="http://www.exitsapplication.com/exits/student_app/pics/p_spacer.gif"></td>
		<td width="42"><img src="http://www.exitsapplication.com/exits/student_app/pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

<cfcatch type="any">
	<cfinclude template="error_message.cfm">	
</cfcatch>
</cftry>

</body>
</html>