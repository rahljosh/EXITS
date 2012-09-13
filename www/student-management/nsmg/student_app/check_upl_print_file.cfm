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

<cfscript>
	// These are used to set the vStudentAppRelativePath directory for images nsmg/student_app/pics and uploaded files nsmg/uploadedFiles/
	// Param Variables
	param name="vStudentAppRelativePath" default="";
	param name="vUploadedFilesRelativePath" default="../";
	
	if ( LEN(URL.curdoc) ) {
		vStudentAppRelativePath = "";
		vUploadedFilesRelativePath = "../";
	}
</cfscript>

<cfoutput>

<cfdirectory directory="#AppPath.onlineApp.inserts#/#doc#" name="file" filter="#client.studentid#.*">	

<cfif file.recordcount NEQ '0'>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td><br><h2>You have uploaded a #Right(file.name, 3)# file for this page.</h2></td></tr>
		<tr><td><a href="#vUploadedFilesRelativePath#uploadedfiles/online_app/#doc#/#file.name#" target="_blank"><img src="pics/button_edit.png" border=0> View the file you have uploaded </a></td></tr>
	</table><br>
<cfelse>
	<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
		<tr><td align="center"><b>Note: &nbsp; This page needs to be uploaded.</b></td></tr>
		<tr><td align="center"><b> Please print, sign, scan and upload this page. Click on the link below to upload this page.</b></td></tr>
		<tr><td align="center"><a href="" onClick="javascript: win=window.open('upload/upload_file.cfm?referrer=#CGI.HTTP_HOST#&folder=#doc#&student=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/uploadpage.gif" border=0></img></a></td></tr>
	</table><br>
</cfif>

</cfoutput>