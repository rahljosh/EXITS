<SCRIPT>
<!--
function areYouSure() { 
   if(confirm("You are about to delete the uploaded letter. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
//-->
</script>

<cfoutput>

<cfset nsmg_directory = '/var/www/html/case/internal/uploadedfiles/letters/#doc#'>

<cfdirectory directory="#nsmg_directory#" name="file" filter="#get_student_info.studentid#.*">	

<cfif file.recordcount NEQ '0'>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><h2>You have uploaded a #Right(file.name, 3)# document for this page.</h2></td></tr>
		<tr><td>Choose one of the following to work with the page you have uploaded.</td></tr>
		<tr><td><a href="../uploadedfiles/letters/#doc#/#file.name#" target="_blank"><img src="pics/button_edit.png" border=0> View the letter you have uploaded </a></td></tr>	
		<tr><td><a href="http://upload.case-usa.org/qr_delete_letter.cfm?studentid=#client.studentid#&type=#doc#&ref=#curdoc#&id=#url.id#&p=#url.p#" onClick="return areYouSure();"><img src="pics/button_drop.png" border=0> Delete the letter that was uploaded</a></td></tr>
		<tr><td><a href="" onClick="javascript: win=window.open('http://upload.case-usa.org/form_upload_letter.cfm?studentid=#client.studentid#&type=#doc#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/docs.gif" border=0> Upload a new letter (Note: the current letter will be replaced by the new one)</a></td></tr>
	</table><br>
<cfelse>
	<!--- OPEN FROM DEV --->
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td align="center"><b>If you would like to upload a scanned letter please click on the below.</b><br><br></td></tr>
		<tr><td align="center"><a href="" onClick="javascript: win=window.open('http://upload.case-usa.org/form_upload_letter.cfm?type=#doc#&studentid=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/uploadletter.gif" border=0></img></a></td></tr>
	</table><br>
</cfif>

</cfoutput>