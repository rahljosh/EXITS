<style>
.style2 {
	font-family:Verdana;
	color:#FFF;
	size:10em;
	font-weight:bold:
}
.style1 {
	font-family:Verdana;
	color:#000;
	size:10em;
}


</style>

<cfoutput>
      <cfset currentDirectory = "/var/www/html/csb-usa/job-description/spring2009">
      <cfdirectory action="List" directory="#currentDirectory#" name="DirList" sort="name asc" filter="*.pdf">
      <div align="right"><a href="http://www.adobe.com/products/acrobat/readstep.html" target="_blank"><img src="../getacro.gif" width="88" height="31" alt="Download Adobe Acrobat Reader" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		  <br>
      <table width="95%" border="0" align="center" cellpadding="1" cellspacing="1" class="section">
        <tr  bgcolor="##ffffe6">
          <td height="25" bgcolor="##022E9C" class="style2"><strong>&nbsp;&nbsp;Name</strong></td>
          <td height="25" bgcolor="##022E9C" class="style2"><strong>&nbsp;&nbsp;Last Modified</strong></td>
          <td height="25" bgcolor="##022E9C" class="style2"><strong>&nbsp;&nbsp;Size</strong></td>
        </tr>
        <cfloop query="DirList">
          <cfset newsize = #size# / '1024'>
          <tr bgcolor="#iif(DirList.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
            <td height="22" class="style1"><a href="#name#" target="_blank">#name#</a></td>
            <td align="" class="style1">#DateFormat(datelastmodified, 'mm/dd/yyyy')#</td>
            <td align="" class="style1">#Round(newsize)# kb</td>
          </tr>
        </cfloop>
      </table>
      		</cfoutput>