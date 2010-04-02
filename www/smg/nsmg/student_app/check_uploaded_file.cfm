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

<cfdirectory directory="#AppPath.onlineApp.inserts##doc#" name="file" filter="#get_student_info.studentid#.*">	

<cfif file.recordcount NEQ '0'>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><br><h2>You have uploaded a #Right(file.name, 3)# document for this page.</h2></td></tr>
		<tr><td>Choose one of the following to work with the page you have uploaded.</td></tr>
		<tr><td><a href="../uploadedfiles/online_app/#doc#/#file.name#" target="_blank"><img src="pics/button_edit.png" border=0> View the file you have uploaded </a></td></tr>
		<tr><td><a href="#AppPath.onlineApp.uploadURL#delete_inserts.cfm?doc=#doc#&ref=#curdoc#&id=#url.id#&p=#url.p#&student=#client.studentid#" onClick="return areYouSure(this);"><img src="pics/button_drop.png" border=0> Delete file that was uploaded</a></td></tr>
		<tr><td><a href="" onClick="javascript: win=window.open('#AppPath.onlineApp.uploadURL#upload_file.cfm?folder=#doc#&student=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/docs.gif" border=0> Upload a new document (Note: the current file will be replaced by the new one)</a></td></tr>
	</table><br>
<cfelse>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td align="center"><b>Note: &nbsp; This page needs to be uploaded.</b></td></tr>
		<tr><td align="center"><b> Please print, sign, scan and upload this page. Click on the link below to upload this page.</b></td></tr>
		<tr><td align="center"><a href="" onClick="javascript: win=window.open('#AppPath.onlineApp.uploadURL#upload_file.cfm?folder=#doc#&student=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/uploadpage.gif" border=0></img></a></td></tr>
	</table><br>
	<!---
        <table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
            <tr><td align="center"><b>Note: &nbsp; This page needs to be uploaded.</b></td></tr>
            <tr><td align="center"><b> Please print, sign, scan and upload this page. Click on the link below to upload this page.</b></td></tr>
            <tr><td align="center"><a href="" onClick="javascript: win=window.open('upload/upload_file.cfm?folder=#doc#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/uploadpage.gif" border=0></img></a></td></tr>
        </table><br>
    --->
</cfif>

</cfoutput>