<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../smg.css" type="text/css">
<title>SEVIS - Virtual Folder</title>
</head>

<script language="JavaScript">
<!--
function areYouSure() { 
   if(confirm("You are about to delete this file. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
// -->
</script>

<body>
<!----
<cfif NOT IsDefined('url.type')>
	An error has ocurred. Please contact your system administrator.
	<cfabort>
</cfif>
---->
<!--- VIRTUAL FOLDER --->
<cfquery name="get_company" datasource="MySQL">
    SELECT 
        companyID,
        companyName,
        companyshort,
        companyshort_nocolor,
        sevis_userid,
        iap_auth,
        team_id
    FROM 
        smg_companies
    WHERE 
        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
</cfquery>


<cfoutput>

<cfset currentDirectory = "#APPLICATION.PATH.sevis##get_company.companyshort_nocolor#/#url.type#">
<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(currentDirectory)>
   An error has ocurred. Please contact your system administrator.
   <cfabort>
</cfif>

<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC">
<!--- HEADER OF TABLE --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/helpdesk.gif"></td>
		<td background="../pics/header_background.gif"><h2>SEVIS - XML #url.type# - Virtual Folder</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section"><br>
<!--- UPLOADING FILES --->
<table width=660 cellpadding=6 cellspacing=1 border=0 align="center">
	<tr><th bgcolor="e2efc7">U P L O A D I N G &nbsp; F I L E S </th></tr>
	<cfform method="post" action="xml_upload_file.cfm" name="Upload" enctype="multipart/form-data" onSubmit="return ProcessForm()">
	<cfinput type="hidden" name="directory" value="#currentDirectory#">
	<cfinput type="hidden" name="type" value="#url.type#">
	<tr><td>Please upload your file here:</td></tr>
	<tr>
		<td> 
			Browse for the file..<br>
			<cfinput type="file" name="UploadFile" size="40" required="yes"><br>
		</td>
	</tr>
	<tr><td align="center"><cfinput name="submit" type="image" src="../virtualfolder/vfolderupload.gif" alt="Upload File"></td></tr>
	 </cfform>
</tr>
</table><br>

<table width=660 cellpadding=6 cellspacing=1 border=0 align="center">
	<tr bgcolor="e2efc7">
	  <th>Name</th>
	  <th>Size</th>
	  <th>Modified</th>
	  <th>View</th>
	  <cfif client.usertype EQ '8' OR client.usertype LTE '4'>
	  <th>Delete</th>
	  </cfif>
	</tr>
	<cfif mydirectory.recordcount EQ '0'>
	<tr><td colspan="5">No file has been created/uploaded.</td></tr>
	</cfif>
	
	<cfloop query="mydirectory">
	<tr bgcolor="#iif(mydirectory.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
	  <td><a href="/internal/uploadedfiles/sevis/#get_company.companyshort_nocolor#/#url.type#/#name#" target="_blank">#mydirectory.name#</a></td>
	  <td>#mydirectory.size#</td>
	  <td>#mydirectory.dateLastModified#</td>
	  <td align="center"><a href="/internal/uploadedfiles/sevis/#get_company.companyshort_nocolor#/#url.type#/#name#" target="_blank"><img src="../virtualfolder/vfolderview.gif" border="0" alt="View File"></img></a></td>
	  <cfif client.usertype LTE '4'>
	  <td align="center">
		<cfform method="post" action="xml_delete_file.cfm" name="Delete">
			<cfinput type="hidden" name="type" value="#url.type#">
			<cfinput type="hidden" name="directory" value="#currentDirectory#">
			<cfinput type="hidden" name="DeleteFile" value="#mydirectory.name#">
			<cfinput type="hidden" name="filesize" value="#mydirectory.size#">
			<cfinput type="image" name="submit" src="../virtualfolder/vfolderdelete.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
		</cfform>				
	  </td>
	  </cfif>	
	</tr>
	</cfloop>
</table><br>
</div>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom"><td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table><br>
</cfoutput>
<!---- END VIRTUAL FOLDER ---->

</body>
</html>