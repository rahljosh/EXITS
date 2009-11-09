<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload Family Picture</title>
</head>

<!---
<body onLoad="window.Application.reload()">

window.opener.reload() -> object doesn't support this property or object.
opener.location.reload() -> permission denied
--->

<!---
<script language="javascript">
myURL = window.opener.location.href
if (myURL == "http://www.student-management.com/")
{
window.opener.location.reload()
}
</script>
--->

<script language="JavaScript">
<!--
function refreshParent() {
window.opener.location.href = window.opener.location.href;
if (window.opener.progressWindow)
window.opener.progressWindow.close()
}
window.close();
}
//-->
</script>

<body onUnload="refreshParent()">

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="http://www.student-management.com/nsmg/pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="http://www.student-management.com/nsmg/student_app/pics/notes.gif"></td>
		<td class="tablecenter"><h2>Upload Pictures</h2></td>
		<td width="42" class="tableside"><img src="http://www.student-management.com/nsmg/student_app/pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>

<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3>
		<cfform action="qr_upload_family_picture.cfm?student=#url.student#" method="post" name="upload_letter" enctype="multipart/form-data" preloader="no">
			Please upload recent pictures (within 2 years) of you, your family, and friends.  
			Once you have uploaded your pictures, you will be able to add a description for them. <br> 
			PS: Pictures should be either <b> jpeg, jpg or gif </b>.<br>
			Please make sure the size of each photo is 2mb or less. You can upload up to ten (10) photos.<br><br>
			<div align="center">
			Browse for the file.. <cfinput type="file" name="family_pic" size=35 required="yes" enctype="multipart/form-data" message="Please specify a file.">
			<cfinput name="file_name" type="hidden"  value=""/>
			<cfinput type="hidden" name="student" value="#url.student#">
			<br><br>
			<input type="image" src="http://www.student-management.com/nsmg/student_app/pics/uploadpic.gif" alt="Upload Picture to Server"><br>
			</div>
			</cfform>
		</td>
	</tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="http://www.student-management.com/nsmg/student_app/pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="http://www.student-management.com/nsmg/student_app/pics/p_spacer.gif"></td>
		<td width="42"><img src="http://www.student-management.com/nsmg/student_app/pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</body>
</html>