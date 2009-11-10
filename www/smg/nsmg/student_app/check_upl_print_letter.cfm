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

<cfinclude template="querys/get_latest_status.cfm">

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles/letters/#doc#'>

<cfdirectory directory="#nsmg_directory#" name="file" filter="#client.studentid#.*">	

<cfoutput>

<cfif file.recordcount NEQ '0'>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><br><h2>You have uploaded a #Right(file.name, 3)# document for this file.</h2></td></tr>
		<tr><td><a href="../uploadedfiles/letters/#doc#/#file.name#" target="_blank"><img src="pics/button_edit.png" border=0> View the file you have uploaded </a></td></tr>
	</table><br>
<cfelse>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td align="center"><b>If you would like to upload a scanned letter please click on the below.</b></td></tr>
		<tr><td align="center"><a href="" onClick="javascript: win=window.open('http://upload.student-management.com/form_upload_letter.cfm?type=#doc#&studentid=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/uploadpage.gif" border=0></img></a></td></tr>
	</table><br>
</cfif>

</cfoutput>