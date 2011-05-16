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

<cfset currentDirectory = "#APPLICATION.PATH.pdfDocs##companyshort.companyshort#">

<cfdirectory action="List" directory="#currentDirectory#" name="DirList" sort="name asc">

<!--- <cfdirectory action="List" directory="#currentDirectory#" name="DirList" sort="name asc" filter="*.pdf"> --->

<table width=100%>
	<tr>
	<td> <h2><img src="pics/docs.gif">PDF Documents</td>
	<td>
	<div align="right"><a href="http://www.adobe.com/products/acrobat/readstep.html" target="_blank"><img src="pics/getacro.gif" width="88" height="31" alt="Download Adobe Acrobat Reader" border="0"></a></div> 

	</td>
	</tr>
</table>
<Table width=90% align="center" cellpadding="1" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing =0>
	<tr  bgcolor="##8d8d8d">
		<th background="images/back_menu2.gif" align="left">Name</td>
		<th background="images/back_menu2.gif" align="left">Last Modified</td>
		<th background="images/back_menu2.gif" align="left">Size</td> 
		<cfif client.usertype LTE '3'>
		<th background="images/back_menu2.gif" align="left">Delete</th>
		</cfif>
	</tr>
	<cfloop query="DirList">
	<cfset newsize = #size# / '1024'>
	<tr bgcolor="#iif(DirList.currentrow MOD 2 ,DE("cfcfcf") ,DE("white") )#">
		<Td>&nbsp; <a href="http://www.student-management.com/nsmg/uploadedfiles/pdf_docs/#companyshort.companyshort#/#name#" target="_blank">#name#</a></td>
		<td align="">#DateFormat(datelastmodified, 'mm/dd/yyyy')#</td>
		<td align="">#Round(newsize)# kb</td>
		<cfif client.usertype LTE '3'>
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
	<tr><td>&nbsp;</td></tr>
	<cfif client.usertype LTE '3'>
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
<br />

<!--- 	<cfftp action="close" connection="RemoteSite" stoponerror="yes">  --->

</cfoutput>