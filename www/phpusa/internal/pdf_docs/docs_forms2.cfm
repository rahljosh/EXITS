<!-----Company Information----->


<!----
 <cfftp action="open" username="anonymous" password="" server="ftp.student-management.com" connection="RemoteSite" stoponerror="yes" >
<cfftp action="GetCurrentDir"  stoponerror="yes"connection="RemoteSite">

<cfftp connection="RemoteSite" action="ListDir" directory="/smg/asai/intranet/intradocs/pdf_docs/" Name="DirList" Stoponerror="Yes"> 
---->
<cfoutput>

<cfdirectory action="List" directory="#APPLICATION.PATH.pdfDocs##companyshort.companyshort#" name="DirList" sort="name asc" filter="*.pdf">
<table width=100%>
	<tr>
	<td> <h2><img src="pics/docs.gif">PDF Documents</td>
	<td>
	<div align="right"><a href="http://www.adobe.com/products/acrobat/readstep.html" target="_blank"><img src="pics/getacro.gif" width="88" height="31" alt="Download Adobe Acrobat Reader" border="0"></a></div> 

	</td>
	</tr>
</table>
<br>

		
<Table width="100%" align="center" class="section">
	<tr  bgcolor="##ffffe6">
		<td>Name</td>
		<td>Last Modified</td>
		<td>Size</td> 
	</tr> 
	<cfloop query="DirList">

	<tr bgcolor="#iif(DirList.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<Td><a href="uploadedfiles/pdf_docs/#name#" target="_blank">#name#</a></td>
		<td align="">#DateFormat(datelastmodified, 'mm/dd/yyyy')#</td>
		<td align="">#size#</td>
	</tr>
<!--- 	<tr bgcolor="#iif(dirlist.currentrow MOD 2 ,DE("CACED8") ,DE("white") )#">
		<td><A href="#dirList.url#">#DirList.name#</a></td><td>#DateFormat(DirList.lastmodified)#</td><td>#dirlist.length#</td>
	</tr>
 --->	
 	</cfloop> 
</table>
<br>
<!--- 	<cfftp action="close" connection="RemoteSite" stoponerror="yes">  --->

</cfoutput>