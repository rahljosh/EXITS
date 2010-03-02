<link rel="stylesheet" href="../../smg.css" type="text/css">
<body onload="opener.location.reload()">
<cfif isDefined('url.confirmed')>
	<cfif url.confirmed is 'pdf'>
		<cfquery name="delete_letter" datasource="mysql">
		delete from smg_users letter
		where studentid = #client.userid#	
		</cfquery>
	<cfelse>
		<cffile action="delete" file='#expandPath("../uploadedfiles/web-students/#client.studentid#.jpg")#'>
	</cfif>
	<body onload="opener.location.reload()">
				
				<cftry>
						<!----Upload File---->
						<cffile 
						   action = "upload"
						   fileField = "form.student_pic"
						   destination = "c:\websites\nsmg\uploadedfiles\web-students\"
						   nameConflict = "MakeUnique"
						   accept = "image/jpg, image/gif, image/jpeg"
						  >
						  <!----Check Image Size--->
						  <CFIF cffile.FileSize gt 300000>
							<cfthrow type="sizeerror" message="File is to large. Images can not be more then 300k.  Please resize the image and resubmit.">
						  </cfif>
						  <cfif cffile.ClientFileExt is "gif" or cffile.ClientFileExt is  "jpg" or cffile.ClientFileExt is  "jpeg"  >
						  <cfelse>
							<CFTHROW type="exterror" message="Only images that are .gif, .jpg, or .jpeg can be uploaded.  Please re-save in the appropriate format, and resubmit.">
						  </cfif>
						  <cfcatch type="sizeerror">
							<cfabort showerror="#cfcatch.message#">
						  </cfcatch>
							<cfcatch type="exterror">
							<cfabort showerror="#cfcatch.message#">
						  </cfcatch>
				  </cftry>
				 
				<cffile	
					action="Move" 
					source="c:\websites\nsmg\uploadedfiles\web-students\#CFFILE.ServerFile#" 
					destination="c:\websites\nsmg\uploadedfiles\web-students\#client.studentid#.#cffile.clientfileext#"
				  > 
				
				<script language="JavaScript"><!--
				function load(file,target) {
					if (target != '')
						target.window.location.href = '?curdoc=section1/page1&id=1&p=1';
					else
						window.location.href = '?curdoc=section1/page1&id=1&p=1';
				}
				//-->
				</script>
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
					<tr valign=middle height=24>
						<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
						<td width=26 background="../pics/header_background.gif"><img src="../../pics/students.gif"></td>
						<td background="../pics/header_background.gif"><h2>Letter Deleted Successfully</h2></td>
						<td width=17 background="../pics/header_rightcap.gif"></td>
					</tr>
				</table>
				<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
										<tr>
											<td style="line-height:20px;" valign="top" colspan=3>
											<br>
				
				<div align = center>
				<h2>Your letter was Successfully  deleted. Cose this window to continue your application.</h2><br>
				<input type="image" value="close window" src="../../pics/close.gif" onClick="javascript:window.close()">
				
				</div>
				</td>
				</tr>
				</table>
				<table width=100% cellpadding=0 cellspacing=0 border=0>
													<tr valign=bottom >
														<td width=9 valign="top" height=12><img src="../../pics/footer_leftcap.gif" ></td>
														<td width=100% background="../../pics/header_background_footer.gif"></td>
														<td width=9 valign="top"><img src="../../pics/footer_rightcap.gif"></td>
													</tr>
												</table>	
<cfelse>



<table width="100%" cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../../pics/header_background.gif"><img src="../../pics/students.gif"></td>
		<td background="../../pics/header_background.gif"><h2>[2] - Student Letter of Introduction</h2></td>
		<td width=17 background="../../pics/header_rightcap.gif"></td>
	</tr>
</table>
<table width="100%" border=0 cellpadding=0 cellspacing=0 align="center" class="section">



	<tr><td><br>
<div align="center"><h2>Are you sure that you want to delete your letter of introduction?</h2><br>
<br>
<img src="../../pics/yes.gif"> &nbsp;&nbsp;&nbsp;&nbsp; <img src="../../pics/no.gif">
</div>


		</td>
	</tr>
</table>
<table width=100% border=0 cellpadding=0 cellspacing=0 class="section">
	<tr>
		<td align="center"></td>
	</tr>
</table>

<!----footer of table ---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../../pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfif>