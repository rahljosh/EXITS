<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Upload Letter</title>
</head>
<body>

<cftry>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="http://www.student-management.com/nsmg/pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="http://www.student-management.com/nsmg/student_app/pics/notes.gif"></td>
		<td class="tablecenter"><h2>Upload Letter</h2></td>
		<td width="42" class="tableside"><img src="http://www.student-management.com/nsmg/student_app/pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3><br>
			<cfform action="qr_upload_letter.cfm" method="post" name="upload_letter" enctype="multipart/form-data" preloader="no">
			<cfinput type="hidden" name="type" value="#url.type#">
			<cfinput type="hidden" name="studentid" value="#url.studentid#">
			Please upload your letter here. <br />
			<strong>PLEASE UPLOAD PREFERABLY JPEG, JPG OR GIF FILES.</strong> <br>
			If you upload the wrong letter, just upload the correct file and the wrong file will be removed. 
			<br>
			<div align="center">
			Browse for the file.. <cfinput type="file" name="letter" size=35 required="yes" enctype="multipart/form-data" message="You must select a file in order to continue." validateat="onsubmit,onserver">
			<br><br>
			<cfinput type="image" name="upload" src="http://www.student-management.com/nsmg/student_app/pics/uploadletter.gif" alt="Upload Letter to Server"><br>
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

<cfcatch type="any">
	<cfinclude template="error_message.cfm">	
</cfcatch>
</cftry>

</body>
</html>