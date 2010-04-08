<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

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

<!----
 <cfftp action="open" username="anonymous" password="" server="ftp.student-management.com" connection="RemoteSite" stoponerror="yes" >
<cfftp action="GetCurrentDir"  stoponerror="yes"connection="RemoteSite">
<cfftp connection="RemoteSite" action="ListDir" directory="/smg/asai/intranet/intradocs/pdf_docs/" Name="DirList" Stoponerror="Yes"> 
---->
<cfoutput>

<cfset editDirectory = "/var/www/html/case/internal/uploadedfiles/editable/#companyshort.companyshort#">

<cfset currentDirectory = "/var/www/html/case/internal/uploadedfiles/pdf_docs/#companyshort.companyshort#">

<div align="right"><a href="http://www.adobe.com/products/acrobat/readstep.html" target="_blank"><img src="pics/getacro.gif" width="88" height="31" alt="Download Adobe Acrobat Reader" border="0"></a></div> 
<br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/docs.gif"></td>
		<td background="pics/header_background.gif"><h2>#companyshort.companyshort# PDF Documents</td><td background="pics/header_background.gif" align="right">
		</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<Table width="100%" align="center" class="section">
<tr><th bgcolor="e2efc7" colspan="4">E D I T A B L E &nbsp; &nbsp; F I L E S &nbsp; </th></tr>
	<tr  bgcolor="##ffffe6">
		<td>Name</td>
		<td>Last Modified</td>
		<td>Size</td> 
		<cfif client.usertype LTE '3'>
		<th>Delete</th>
		</cfif>
	</tr> 

	
<cfdirectory action="List" directory="#editDirectory#" name="editDirList" sort="name asc" filter="*.pdf">

<cfloop query="editDirList">
	<cfset newsize = #size# / '1024'>
	<tr bgcolor="#iif(editDirList.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<Td><a href="uploadedfiles/editable/#companyshort.companyshort#/#name#" target="_blank">#name#</a></td>
		<td align="">#DateFormat(datelastmodified, 'mm/dd/yyyy')#</td>
		<td align="">#Round(newsize)# kb</td>
	</tr>
</cfloop> 

<cfdirectory action="List" directory="#currentDirectory#" name="DirList" sort="name asc" filter="*.pdf">
<tr><th bgcolor="e2efc7" colspan="4">P R I N T A B L E &nbsp; &nbsp; F I L E S &nbsp; </th></tr>
	<tr  bgcolor="##ffffe6">
		<td>Name</td>
		<td>Last Modified</td>
		<td>Size</td> 
		<cfif client.usertype LTE '3'>
		<th>Delete</th>
		</cfif>
	</tr> 
	<cfloop query="DirList">
	<cfset newsize = #size# / '1024'>
	<tr bgcolor="#iif(DirList.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<Td><a href="uploadedfiles/pdf_docs/#companyshort.companyshort#/#name#" target="_blank">#name#</a></td>
		<td align="">#DateFormat(datelastmodified, 'mm/dd/yyyy')#</td>
		<td align="">#Round(newsize)# kb</td>
		<cfif client.usertype LTE '4'>
		<td align="center">
			<cfform method="post" action="?curdoc=pdf_docs/delete_file" name="Delete">
			<cfinput type="hidden" name="directory" value="#currentDirectory#">
			<cfinput type="hidden" name="DeleteFile" value="#name#">
			<cfinput type="image" name="submit" src="pics/deletex.gif" alt="Delete this file" onclick="return areYouSure(this);"> 
			</cfform>				
		</td>	
		</cfif>
	</tr>
 	</cfloop> 
	<!--- UPLOADING FILES --->
	<cfif client.usertype LTE 4>
		<tr><th bgcolor="e2efc7" colspan="4">U P L O A D I N G &nbsp; F I L E S &nbsp; (Only Office Users Can Upload/Delete PDF Docs)</th></tr>
		<cfform method="post" action="?curdoc=pdf_docs/upload_file" name="Upload" enctype="multipart/form-data" onSubmit="return ProcessForm()">
		<cfinput type="hidden" name="directory" value="#currentDirectory#">
		<tr><td colspan="4">Please upload your file here:</td></tr>
		<tr>
			<td colspan="4"> 
				Browse for the file..<br>
				<cfinput type="file" name="UploadFile" size="40" required="yes"><br>
			</td>
		</tr>
		<tr><td align="center" colspan="4"><cfinput name="submit" type="image" src="pics/submit.gif" alt="Upload File"></td></tr>
		 </cfform>
	</tr>
	</cfif>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
<!--- 	<cfftp action="close" connection="RemoteSite" stoponerror="yes">  --->

</cfoutput>