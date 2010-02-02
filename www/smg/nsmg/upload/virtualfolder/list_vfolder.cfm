<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../smg.css" type="text/css">
<title>SMG - VIRTUAL FOLDER</title>

<cftry>

<script language="JavaScript">
<!--
function ProcessForm() {
   if (document.Upload.UploadFile.value == '') {
      alert("You must specify a file.");
	  document.Upload.UploadFile.focus();
	  return false;
   } else if (document.Upload.category.value == 0) {
      alert("You must select an option to upload your file.");
	  document.Upload.category.focus();
	  return false;
	} else if (document.Upload.category.value == '4' & document.Upload.other_category.value == '') {
   	  alert("You've selected 'other' as an option. You must complete the text box.");
	  document.Upload.other_category.focus();
	  return false;
    } else {
	  return true;
	}
}
function enableField()
{
	if (document.Upload.category.value == '4') {
		document.Upload.other_category.disabled=false;
		document.Upload.other_category.required=true;
		document.Upload.other_category.focus();
		document.Upload.other_category.value = '';
	} else {
		document.Upload.other_category.disabled=true;
		document.Upload.other_category.required=false;
		document.Upload.other_category.value = '';
	}
}
function areYouSure() { 
   if(confirm("You are about to delete this file. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
<!--
// print images
function PrintFile(url)
{
	newwindow=window.open(url, 'PrintFile', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
// -->
</script>
</head>

<body>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="error_message.cfm">
	<cfabort>
</cfif>
	
<cfquery name="get_student_info" datasource="MySql">
	SELECT *
	FROM smg_students
	WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char" maxlength="50">
</cfquery>

<cfquery name="virtual_category" datasource="MySql">
	SELECT categoryid, category
	FROM smg_virtualfolder_cat 
</cfquery>

<!--- EXAMPLE 1: Creating - Check that the directory exists to avoid getting a ColdFusion error message. --->
<!--- <cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath()) & "uploadedfiles\virtualfolder\#get_student_info.studentid#"> --->
<cfset currentDirectory = "/var/www/html/student-management/nsmg/uploadedfiles/virtualfolder/#get_student_info.studentid#">

<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(currentDirectory)>
   <!--- If TRUE, create the directory. --->
   <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
</cfif>

<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">
<cfoutput>
<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/helpdesk.gif"></td>
		<td background="../pics/header_background.gif"><h2>SMG - Virtual Folder &nbsp; - &nbsp; #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section"><br>
<table width=660 cellpadding=6 cellspacing=1 border=0 align="center">
	<tr><th><h2>Welcome to SMG Virtual Folder</h2></th></tr>
	<tr><td><div align="justify">In this new feature you can upload as many files as you want for your student. For each file upload notification will be sent out to inform
			the appropriate people at SMG that you have uploaded a file. <br>
			The students international representative will also receive an email with notification that a file was added the virtual folder.<br>
			Each student has his/her own Virtual Folder so please do not upload a file that does not belong in this record.<br>
			PS: There is a limit of 4mb per file.</div></td></tr>
</table><br>

<table width=660 cellpadding=6 cellspacing=1 border=0 align="center">
	<tr bgcolor="e2efc7">
	  <th>Name</th>
	  <th>Size</th>
	  <th>Modified</th>
	  <th>Category</th>
	  <th>View</th>
	  <cfif client.usertype EQ '8' OR client.usertype LTE '4'>
	  <th>Delete</th>
	  </cfif>
	</tr>
	<cfif mydirectory.recordcount EQ '0'>
	<tr><td colspan="5">No file has been uploaded.</td></tr>
	</cfif>
	
	<cfloop query="mydirectory">
		<cfquery name="get_category" datasource="MySql">
			SELECT folder.studentid, cat.category, folder.other_category
			FROM smg_virtualfolder folder
			INNER JOIN smg_virtualfolder_cat cat ON cat.categoryid = folder.categoryid
			WHERE folder.studentid = '#get_student_info.studentid#'
				AND folder.filename = '#mydirectory.name#'
				AND folder.filesize = '#mydirectory.size#' 
		</cfquery>
	<cfset newsize = #size# / '4024'>
	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
	
		<cfif Right(name, 3) EQ 'JPG' OR Right(name, 3) EQ 'PEG' OR Right(name, 3) EQ 'GIF' OR Right(name, 3) EQ 'BMP'>
			<td><a href="javascript:PrintFile('print_file.cfm?studentid=#get_student_info.studentid#&file=#name#');">#name#</a></td>
		<cfelse>
			<td align="center"><a href="../uploadedfiles/virtualfolder/#get_student_info.studentid#/#name#" target="_blank">#name#</a></td>
		</cfif>
		<td>#Round(newsize)# kb</td>
		<td>#dateLastModified#</td>
		<td>#get_category.category# <cfif get_category.other_category NEQ ''> &nbsp; - &nbsp; #get_category.other_category#</cfif></td>
	  
		<cfif Right(name, 3) EQ 'JPG' OR Right(name, 3) EQ 'PEG' OR Right(name, 3) EQ 'GIF' OR Right(name, 3) EQ 'BMP'>
			<td><a href="javascript:PrintFile('print_file.cfm?studentid=#get_student_info.studentid#&file=#name#');"><img src="vfolderview.gif" border="0" alt="View File"></img></a></td>
		<cfelse>
			<td align="center"><a href="../uploadedfiles/virtualfolder/#get_student_info.studentid#/#name#" target="_blank"><img src="vfolderview.gif" border="0" alt="View File"></img></a></td>
		</cfif>
	  
		<cfif client.usertype EQ '8' OR client.usertype LTE '4'>
		<td align="center">
		<cfform method="post" action="qr_delete_file.cfm" name="Delete">
			<cfinput type="hidden" name="directory" value="#currentDirectory#">
			<cfinput type="hidden" name="DeleteFile" value="#mydirectory.name#">
			<cfinput type="hidden" name="filesize" value="#mydirectory.size#">
			<cfinput type="hidden" name="unqid" value="#get_student_info.uniqueid#">
			<cfinput type="image" name="submit" src="vfolderdelete.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
		</cfform>				
		</td>
		</cfif>	
	</tr>
	</cfloop>
</table><br>

<!--- UPLOADING FILES --->
<table width=660 cellpadding=6 cellspacing=1 border=0 align="center">
	<tr><th bgcolor="e2efc7">U P L O A D I N G &nbsp; F I L E S </th></tr>
	<cfform method="post" action="qr_upload_file.cfm" name="Upload" enctype="multipart/form-data" onSubmit="return ProcessForm()">
	<cfinput type="hidden" name="directory" value="#currentDirectory#">
	<cfinput type="hidden" name="unqid" value="#get_student_info.uniqueid#">	
	<tr><td>Please upload your file here:</td></tr>
	<tr>
		<td> 
			Browse for the file..<br>
			<cfinput type="file" name="UploadFile" size="40" required="yes"><br>
		</td>
	</tr>
	<tr>
		<td>
			Please select a reason why are you uploading this file: (It will help our team to proccess it faster)<br>
			<cfselect name="category" onChange="enableField()">
				<option value="0">Select an Option</option>
				<cfloop query="virtual_category">
				<option value="#categoryid#">#category#</option>
				</cfloop>
			 </cfselect>
			 &nbsp; &nbsp; Other: <cfinput type="text" name="other_category" size="40" maxlength="45" value="" disabled>
	   </td>
	</tr>
	<tr><td align="center"><cfinput name="submit" type="image" src="vfolderupload.gif" alt="Upload File"></td></tr>
	 </cfform>
</tr>
</table><br>
</div>

<table width=100% cellpadding=6 cellspacing=1 border=0 align="center" class="section">
	<tr><td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>