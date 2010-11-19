<cfinclude template="../querys/get_student_info.cfm">
<cfoutput query="get_student_info">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Student Letter of Introduction</h2></td>
		<td align="right" background="pics/header_background.gif"> Student: #firstname# #familylastname# (#studentid#) &nbsp; <span class="edit_link">[ <a href="?curdoc=student_info&studentid=#studentid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfif left(remote_addr,6) is '10.1.1'>
	<!--- body of a table --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="80%">
			<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
				<tr><td>Since you are located in the head office building, you do not need to enter the letter information, the letter will show up for this student when it is scanned.</td></tr>			
				<tr><td>You have finished imputing this students app.</td></tr>
			</table>
		</td>
		<td width="20%" align="right" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="../student_app_menu.cfm"></td></tr>
			</table> 		
		</td>
		</tr>
	</table>
<cfelse>			
	<!--- body of a table --->
	<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td width="80%">
			<table border=0 cellpadding=2 cellspacing=0 align="left" width="100%">
				<tr><td>Files are automatically renamed to work with the system, regardless of what you name them upon upload.<br><br></td></tr>
				<tr><td>To upload a scanned letter, click browse.  Once you have selected the item, click 'Upload'<br><br></td></tr>
				<cfform method="post" action="?curdoc=querys/upload_parents_letter" enctype="multipart/form-data">
				<tr><td><span class="get_attention"><b>></b></span><u>Parents Letter</u><br>
					 	Location of parents letter: <input type="file" name="parents_letter" size= "15">
				</td></tr>
				<tr><td align="center"><input type="submit" value="Upload Parents Letter"></td></tr>
				</cfform>
				<cfform method="post" action="?curdoc=querys/upload_student_letter" enctype="multipart/form-data">
				<tr bgcolor="e2efc7"><td><span class="get_attention"><b>></b></span><u>Students Letter</u><br>
					 	Location of students letter: <input type="file" name="stu_letter" size= "15">
				</td></tr>
				<tr bgcolor="e2efc7"><td align="center"><input type="submit" value="Upload Students Letter"></td></tr>
				</cfform>			
				<cfform method="post" action="?curdoc=querys/upload_students_picture" enctype="multipart/form-data">
				<tr><td><span class="get_attention"><b>></b></span><u>Students Picture</u><br>
					 	Location of students picture: <input type="file" name="stu_picture" size= "15">
				</td></tr>
				<tr><td align="center"><input type="submit" value="Upload Students Picture"></td></tr>
				</cfform>					
				<tr><td>When you have all files upload, please click Next</td></tr>
				<tr><td><div align="justify">
						You can't over write a file once it is uploaded, if you upload the wrong document, place write to 
						<a href="mailto:support@student-management.com">support@student-management.com</a> and indicate student
						or parent letter, or student pic and the students ID number. </div>				
				</td></tr>		
			</table>
		</td>
		<td width="20%" align="right" valign="top">
			<table border=0 cellpadding=3 cellspacing=0 align="right">
				<tr><td align="right"><cfinclude template="../student_app_menu.cfm"></td></tr>
			</table> 		
		</td>
		</tr>
	</table>
</cfif>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<cfform method="post" action="?curdoc=student_info">
	<tr><td align="center"><input name="Submit" type="image" src="pics/next.gif" border="0" value="  next  "></td></tr>
	</cfform>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>