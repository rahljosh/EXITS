<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [22] - Supplements</title>
</head>
<body>

<script type="text/javascript">
<!--
function areYouSure() { 
   if(confirm("You are about to delete this file. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
var newwindow;
function OpenApp(url)
{ 
	newwindow=window.open(url, 'ViewFile', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

<Cfset doc = 'page22'>

<cfinclude template="../querys/get_student_info.cfm">

<cfquery name="get_intl_rep" datasource="MySql">
	SELECT businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.intrep#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset currentDirectory = "/var/www/html/student-management/nsmg/uploadedfiles/virtualfolder/#get_student_info.studentid#/page22">
<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(currentDirectory)>
   <!--- If TRUE, create the directory. --->
   <cfdirectory action = "create" directory = "#currentDirectory#" mode="777">
</cfif>

<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">

<cfoutput>
<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [22] - Supplements</h2></td>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page22print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>		
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td>Use the feature below to upload supplemental documents required by #get_intl_rep.businessname#.<br>
		Supplements may include (but not be limited to) the SLEP Test Answer Sheet (including the score) and English Certificates.
		    <br>
	      You can upload as many files as you wish in the following formats JPG, peg, GIF, PDF, DOC. <br>
	      <strong>PLEASE UPLOAD PREFERABLY JPEG, JPG OR GIF FILES.</strong><br>
	      Files must not be bigger than 2mb.
		</td>
	</tr>
</table><br>

<!--- UPLOADING FILES --->
<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td align="center">
			<a href="" onClick="javascript: win=window.open('http://upload.student-management.com/form_upload_page22.cfm?studentid=#client.studentid#', 'UploadFiles', 'height=310, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="pics/upload-file.gif" border=0></a>
		</td>
	</tr>
</table><br>

<hr class="bar"></hr><br>

<table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr>
	  <td><em>Name</em></td>
	  <td><em>Size</em></td>
	  <td><em>Modified</em></td>
	  <td><em>View</em></td>
	  <td><em>Delete</em></td>
	</tr>
	<cfif mydirectory.recordcount EQ '0'>
	<tr><td colspan="5">No file has been uploaded.</td></tr>
	</cfif>

	<cfloop query="mydirectory">
	<cfset newsize = #mydirectory.size# / '1024'>
	<tr bgcolor="#iif(mydirectory.currentrow MOD 2 ,DE("white") ,DE("CCCCCC") )#">
	  <td><a href="javascript:OpenApp('../uploadedfiles/virtualfolder/#get_student_info.studentid#/page22/#name#');">#mydirectory.name#</a></td>
	  <td>#Round(newsize)# kb</td>
	  <td>#mydirectory.dateLastModified#</td>
	  <td>
	  	<cfif Right(name, 3) EQ 'jpg' OR Right(name, 3) EQ 'gif' OR Right(name, 3) EQ 'peg' OR Right(name, 3) EQ 'JPG' OR Right(name, 3) EQ 'GIF' OR Right(name, 3) EQ 'PEG'>
			<a href="javascript:OpenApp('section4/page22printfile.cfm?studentid=#get_student_info.studentid#&page=page22&file=#name#');"><img src="pics/view-file.gif" border="0" alt="View File"></img></a>
		<cfelse>
	  		<a href="javascript:OpenApp('../uploadedfiles/virtualfolder/#get_student_info.studentid#/page22/#name#');"><img src="pics/view-file.gif" border="0" alt="View File"></img></a>
		</cfif>
	  </td>	
	  <td>
		<cfform method="post" name="page22delete" action="http://upload.student-management.com/qr_delete_page22.cfm">
			<cfinput type="hidden" name="deletefile" value="#mydirectory.name#">
			<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
			<cfinput type="image" name="submit" src="pics/delete.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
		</cfform>
	  </td>
	</tr>
	</cfloop>
</table><br><br>
</div>

<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
	<tr>
		<td align="center" valign="bottom" class="buttontop">
			<a href="index.cfm?curdoc=check_list&id=cl"><img src="pics/next.gif" border="0"></a>
		</td>
	</tr>
</table>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</body></html>

</cftry>


<!---
<!--- CREATE NEW FOLDER AND MOVE FILES --->
<cfif client.userid EQ 510>
<cfoutput>
Create Folders and Move Files <br>
<cfset oldfolder = "/var/www/html/student-management/nsmg/uploadedfiles/online_app/page22">
<cfdirectory directory="#oldfolder#" name="mydirectory2" sort="name" filter="*.*">
<cfloop query="mydirectory2">
File Name: #name# &nbsp; left: #Left(name, 4)#<br>
<cfset newfolder = "/var/www/html/student-management/nsmg/uploadedfiles/virtualfolder/#Left(name, 4)#\page22">
<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(newfolder)>
   <!--- If TRUE, create the directory. --->
   <cfdirectory action = "create" directory = "#newfolder#">
</cfif>
<cffile	action="Move" 
				source="#oldfolder#\#name#" 
				destination="#newfolder#\#name#">
	
</cfloop>
</cfoutput>
</cfif>
--->