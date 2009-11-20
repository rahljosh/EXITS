<link rel="stylesheet" href="../../smg.css" type="text/css">

<h2>Photo Upload</h2>

<table width=80% cellpadding=4 cellspacing=0 border=0 class="section" >
						<tr>
							<td style="line-height:20px;" valign="top" colspan=3>
							<br>
<cfform action="../querys/upload_ext_school_pic.cfm?school=#url.school#" method="post" enctype="multipart/form-data" preloader="no">
Use this form to assign the picture that will show on the school profile page.  Picture must be in .JPG format.
<br><br>

<div align="center">
Browse for the file..<input type="file" name="school_pic" size=35  enctype="multipart/form-data"><br>
*image type needs to be a .jpg
<br><br>
<Input type="image" src="../pics/uploadpic.gif" alt="Upload Picture to Server">
</div>
</td>
</tr>
</table>
<!----footer of table ---->


</cfform>