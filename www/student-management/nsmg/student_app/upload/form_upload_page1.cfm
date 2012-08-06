<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [01] - Upload Passport Photot</title>
</head>
<body>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
		<td width="8" class="tableside"><img src="../../pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../../pics/notes.gif"></td>
		<td class="tablecenter"><h2>Page [01] - Upload Passport Photo</h2></td>
		<td width="42" class="tableside"><img src="../../pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="500" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="line-height:20px;" valign="top" colspan=3>
			<cfform action="qr_upload_page1.cfm" method="post" enctype="multipart/form-data" preloader="no">
                <cfinput type="hidden" name="studentid" value="#url.studentid#">
                Please upload a photo of your self, preferably one smiling.  This picture should not be a picture that you will 
                upload with your family in the photo album, but a picture of you.  School pictures are a great example of the type
                of picture to include here.  
                <br />
                <br />
                <div align="center">
                	Browse for the file.. 
                    <cfinput type="file" name="passaport" size=35 required="yes" enctype="multipart/form-data" message="You must select a file in order to continue." validateat="onsubmit,onserver">
                	<br />
                    <br />
                	<cfinput type="image" name="upload" src="../pics/uploadpic.gif" alt="Upload File to Server"><br>
                </div>
			</cfform>
		</td>
	</tr>
</table>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="../../pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="../../pics/p_spacer.gif"></td>
		<td width="42"><img src="../../pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput> 

</body>
</html>