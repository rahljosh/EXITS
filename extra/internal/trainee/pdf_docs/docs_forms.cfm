<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Help Desk</title>

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

</head>

<body>
<cftry>

<cfoutput>

<cfinclude template="../querys/get_company.cfm">

<cfset link7 = 'trainee'>
<cfset link8 = 'wat'>
<cfset link9 = 'h2b'>

<cfset currentDirectory = "/var/www/html/student-management/extra/internal/uploadedfiles/pdf_docs/#Evaluate("link" & get_company.companyid)#">

<cfdirectory action="List" directory="#currentDirectory#" name="DirList" sort="name asc" filter="*.pdf">

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp; PDF Documents </td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#dirlist.recordcount# document(s) found</td>
				<td width="2%" bgcolor="##E4E4E4">&nbsp;</td>
			</tr>
			<tr><td colspan="3" align="right"><a href="http://www.adobe.com/products/acrobat/readstep.html" target="_blank"><img src="../pics/getacro.gif" width="88" height="31" alt="Download Adobe Acrobat Reader" border="0"></a></td></tr>			
		</table>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr>
				<td bgcolor="4F8EA4" class="style2">Name</td>
				<td bgcolor="4F8EA4" class="style2">Last Modified</td>
				<td bgcolor="4F8EA4" class="style2">Size</td>
				<cfif client..usertype LTE 3>	
					<td bgcolor="4F8EA4" class="style2">Delete</td>
				</cfif>
			</tr>
			<cfloop query="DirList">
			<cfset newsize = size / 1024>
			<cfform method="post" action="?curdoc=pdf_docs/delete_file" name="Delete">
			<cfinput type="hidden" name="directory" value="#currentDirectory#">
			<cfinput type="hidden" name="DeleteFile" value="#name#">
			<tr bgcolor="#iif(DirList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5">
				<td><a href="../uploadedfiles/pdf_docs/#Evaluate("link" & get_company.companyid)#/#name#" class="style4">#name#</a></td>
				<td>#DateFormat(datelastmodified, 'mm/dd/yyyy')#</td>
				<td>#Round(newsize)# kb</td>
				<td><cfinput type="image" name="submit" src="../pics/deletex.gif" alt="Delete this file" onclick="return areYouSure(this);" height="12" width="12"></td>
			</tr>
			</cfform>
			</cfloop>
		</table>
		<br>
		<cfif client..usertype LTE 3>		
		<!--- UPLOAD PDF FILES --->
		<table cellpadding=3 cellspacing=3 border=1 align="center" width="80%" bordercolor="C7CFDC" bgcolor="ffffff">
			<tr>
				<td bordercolor="FFFFFF">
					<table width="100%" cellpadding=3 cellspacing=0 border=0>
						<tr bgcolor="C2D1EF">
							<td  class="style2" bgcolor="8FB6C9" valign="top">&nbsp;:: Upload PDF File</td>
						</tr>
						<tr>
							<td>
								<cfform method="post" action="?curdoc=pdf_docs/upload_file" name="Upload" enctype="multipart/form-data" onSubmit="return ProcessForm()">
								<cfinput type="hidden" name="directory" value="#currentDirectory#">
								<table width="100%" cellpadding=3 cellspacing=0 border=0>
									<tr><td class="style1">Please upload your file here:</td></tr>
									<tr>
										<td class="style1"> 
											Browse for the file..<br>
											<cfinput type="file" name="UploadFile" size="40" required="yes">
										</td>
									</tr>
									<tr><td align="center"><cfinput name="submit" type="image" src="../pics/save.gif" alt="Upload File"></td></tr>
								</table>
								</cfform>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table><br>
		</cfif>		
	</td>
  </tr>
</table>
</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry>
</body>
</html>