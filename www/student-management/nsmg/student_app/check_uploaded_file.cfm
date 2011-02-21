<SCRIPT>
<!--
	function areYouSure() { 
	   if(confirm("You are about to delete the uploaded file. Click OK to continue")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
//-->
</script>

<cfoutput>

<cfdirectory directory="#AppPath.onlineApp.inserts##doc#" name="file" filter="#CLIENT.studentid#.*">	

<cfif VAL(file.recordcount)>
	<table width="600px" border="0" cellpadding="3" cellspacing="0" align="center" style="border-bottom:1px solid ##cfcfcf; padding-bottom:10px; margin-bottom:15px; margin-top:5px;">
		<tr><td><h2>You have uploaded a #Right(file.name, 3)# document for this page.</h2></td></tr>
		<tr><td>Choose one of the following to work with the page you have uploaded.</td></tr>
		<tr>
        	<td>
            	<a href="../uploadedfiles/online_app/#doc#/#file.name#" target="_blank">
                	<img src="pics/button_edit.png" border="0"> View the file you have uploaded
                </a>
            </td>
        </tr>
		<tr>
        	<td>
                <a href="#AppPath.onlineApp.uploadURL#delete_inserts.cfm?referrer=#CGI.HTTP_HOST#&doc=#doc#&ref=#curdoc#&id=#url.id#&p=#url.p#&student=#client.studentid#" onClick="return areYouSure(this);">
                    <img src="pics/button_drop.png" border="0"> Delete file that was uploaded
                </a>
           	</td>
        </tr>
		<tr>
        	<td>
            	<a href="" onClick="javascript: win=window.open('#AppPath.onlineApp.uploadURL#upload_file.cfm?referrer=#CGI.HTTP_HOST#&folder=#doc#&student=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
	                <img src="pics/docs.gif" border="0"> Upload a new document (Note: the current file will be replaced by the new one)
                </a>
            </td>
        </tr>
	</table>
<cfelse>
	<table width="600px" border="0" cellpadding="3" cellspacing="0" align="center" style="border-bottom:1px solid ##cfcfcf; padding-bottom:10px; margin-bottom:15px; margin-top:5px;">
		<tr><th><b>Note: &nbsp; This page needs to be uploaded.</b></th></tr>
		<tr><th><b> Please print, sign, scan and upload this page. Click on the link below to upload this page.</b></th></tr>
		<tr>
        	<td align="center">
            	<a href="" onClick="javascript: win=window.open('#AppPath.onlineApp.uploadURL#upload_file.cfm?referrer=#CGI.HTTP_HOST#&folder=#doc#&student=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">
                	<img src="pics/uploadpage.gif" border="0"><br />
				</a>
			</td>
		</tr>
	</table>
</cfif>

</cfoutput>