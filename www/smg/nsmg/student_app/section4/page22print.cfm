<cftry>

<!--- OPENING FROM PHP - AXIS --->
<cfif IsDefined('url.user')>
	<cfset client.usertype = url.user>
</cfif>

<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="MySQL">
		select studentid from smg_students
		where uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
	</cfquery>
	<cfset client.studentid = #get_student_id.studentid#>
</cfif>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [22] - Supplements</title>
</head>
<body>

<SCRIPT>
<!--
// open online application 
function PrintFile(url)
{
	newwindow=window.open(url, 'PrintFile', 'height=580, width=790, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</SCRIPT>

<cfif IsDefined('url.studentid')>
	<cfset client.studentid = #url.studentid#>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [22] - Supplements</h2></td>
		<cfif IsDefined('url.curdoc')>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page22print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>	

<cfset currentDirectory = "#AppPath.onlineApp.virtualFolder##get_student_info.studentid#/page22">
<!--- Check to see if the Directory exists. --->
<cfif NOT DirectoryExists(currentDirectory)>
   <!--- If TRUE, create the directory. --->
   <cfdirectory action = "create" directory = "#currentDirectory#">
</cfif>

<cfdirectory directory="#currentDirectory#" name="mydirectory" sort="datelastmodified DESC" filter="*.*">

<div class="section"><br>

<table width="300" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td colspan="3"><b>* Note: </b>PDF and DOC files are NOT included in the print complete application option. You must print these files separately.</td></tr>
	<tr>
	  <td><em>Name</em></td>
	  <td><em>Size</em></td>
	  <td><em>Modified</em></td>
	</tr>
	<cfif mydirectory.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfloop query="mydirectory">
		<cfset newsize = size / '1024'>
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("CCCCCC") )#">
			<cfif ListFind("jpg,peg,gif,tif,png", Right(name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page22&file=#URLEncodedFormat(name)#');">#name#</a></td>
			<cfelse>
				<td><b>*</b> <a href="../../uploadedfiles/virtualfolder/#get_student_info.studentid#/page22/#name#" target="_blank">#name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#DateFormat(dateLastModified, 'mm/dd/yyyy  hh:mm:ss')#</td>
		</tr>
		</cfloop>
	</cfif>

	<tr><td colspan="3"><h2>Other Attachments</h2></td></tr>

	<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="studentletter" filter="#get_student_info.studentid#.*">
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 05 - Student's Letter</b></td></tr>
	<cfif studentletter.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = studentletter.size / '1024'>
		<tr><td><a href="../../uploadedfiles/letters/students/#studentletter.name#" target="_blank">#studentletter.name#</a></td>
			<td>#Round(newsize)# kb</td>
			<td>#studentletter.dateLastModified#</td>
		</tr>
	</cfif>

	<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="parentletter" filter="#get_student_info.studentid#.*">
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 06 - Parent's Letter</b></td></tr>
	<cfif parentletter.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = parentletter.size / '1024'>
		<tr><td><a href="../../uploadedfiles/letters/parents/#parentletter.name#" target="_blank">#parentletter.name#</a></td>
			<td>#Round(newsize)# kb</td>
			<td>#parentletter.dateLastModified#</td>
		</tr>
	</cfif>
	
	<cfloop list="07,08,09,10,12,13,14,15,16,17,18,19,20,21" index="x">
		<cfdirectory directory="#AppPath.onlineApp.inserts#page#x#" name="page#x#" filter="#get_student_info.studentid#.*">	
	</cfloop>
    
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 07 - School Information</b></td></tr>
	<cfif page07.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page07.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page07.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page07&file=#URLEncodedFormat(page07.name)#');">#page07.name#</a></td>
			<cfelse>
				<td><b>*</b> <a href="../../uploadedfiles/online_app/page07/#page07.name#" target="_blank">#page07.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page07.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 08 - Transcript of Grades</b></td></tr>
	<cfif page08.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page08.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page08.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page08&file=#URLEncodedFormat(page08.name)#');">#page08.name#</a></td>
			<cfelse>
				<td><b>*</b> <a href="../../uploadedfiles/online_app/page08/#page08.name#" target="_blank">#page08.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page08.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 09 - Language Evaluation</b></td></tr>
	<cfif page09.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page09.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page09.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page09&file=#URLEncodedFormat(page09.name)#');">#page09.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page09/#page09.name#" target="_blank">#page09.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page09.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 10 - Social Skills</b></td></tr>
	<cfif page10.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page10.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page10.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page10&file=#URLEncodedFormat(page10.name)#');">#page10.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page10/#page10.name#" target="_blank">#page10.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page10.dateLastModified#</td>
		</tr>
	</cfif>		
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 12 - Clinical Evaluation</b></td></tr>
	<cfif page12.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page12.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page12.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page12&file=#URLEncodedFormat(page12.name)#');">#page12.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page12/#page12.name#" target="_blank">#page12.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page12.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 13 - Immunization Record</b></td></tr>
	<cfif page13.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page13.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page13.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page13&file=#URLEncodedFormat(page13.name)#');">#page13.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page13/#page13.name#" target="_blank">#page13.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page13.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 14 - Authorization to Treat a Minor</b></td></tr>
	<cfif page14.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page14.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page14.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page14&file=#URLEncodedFormat(page14.name)#');">#page14.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page14/#page14.name#" target="_blank">#page14.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page14.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 15 - Program Agreement</b></td></tr>
	<cfif page15.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page15.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page15.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page15&file=#URLEncodedFormat(page15.name)#');">#page15.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page15/#page15.name#" target="_blank">#page15.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page15.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 16 - Liability Release</b></td></tr>
	<cfif page16.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page16.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page16.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page16&file=#URLEncodedFormat(page16.name)#');">#page16.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page16/#page16.name#" target="_blank">#page16.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page16.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 17 - Travel Authorization</b></td></tr>
	<cfif page17.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page17.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page17.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page17&file=#URLEncodedFormat(page17.name)#');">#page17.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page17/#page17.name#" target="_blank">#page17.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page17.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 18 - Private School</b></td></tr>
	<cfif page18.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page18.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page18.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page18&file=#URLEncodedFormat(page18.name)#');">#page18.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page18/#page18.name#" target="_blank">#page18.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page18.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 19 - Intl. Rep. Questionnaire</b></td></tr>
	<cfif page19.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page19.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page19.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page19&file=#URLEncodedFormat(page19.name)#');">#page19.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page19/#page19.name#" target="_blank">#page19.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page19.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 20 - Region Guarantee</b></td></tr>
	<cfif page20.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page20.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page20.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page20&file=#URLEncodedFormat(page20.name)#');">#page20.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page20/#page20.name#" target="_blank">#page20.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page20.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 21 - State Guarantee</b></td></tr>
	<cfif page21.recordcount EQ '0'>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page21.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page21.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page21&file=#URLEncodedFormat(page21.name)#');">#page21.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../../uploadedfiles/online_app/page21/#page21.name#" target="_blank">#page21.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page21.dateLastModified#</td>
		</tr>
	</cfif>
</table><br>		

<!----
<cfloop list="08,09,10,12,13,14,15,16,17,18,19,20,21" index="i">

</cfloop>
<table width="300" border=0 cellpadding=3 cellspacing=0 align="center">
	<tr><td colspan="4"><h2>Other Attached Files</h2></td></tr>
	<tr><td width="15%">Pages</td><td width="30%">File Type</td><td width="10%">&nbsp;</td><td width="15%">Page</td><td width="30%">File Type</td></tr>
	<tr><td><cfif page08.recordcount><a href="../../uploadedfiles/online_app/page08/#get_student_info.studentid#.#page08.filetype#" target="_blank">08</a></td><td>#page08.filetype#<cfelse>08</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td><cfif page16.recordcount><a href="../../uploadedfiles/online_app/page16/#get_student_info.studentid#.#page16.filetype#" target="_blank">16</a></td><td>#page08.filetype#<cfelse>16</td><td>no file attached</td></cfif></tr>
	<tr><td><cfif page09.recordcount><a href="../../uploadedfiles/online_app/page09/#get_student_info.studentid#.#page09.filetype#" target="_blank">09</a></td><td>#page08.filetype#<cfelse>09</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td><cfif page17.recordcount><a href="../../uploadedfiles/online_app/page17/#get_student_info.studentid#.#page17.filetype#" target="_blank">17</a></td><td>#page17.filetype#<cfelse>17</td><td>no file attached</td></cfif></tr>
	<tr><td><cfif page10.recordcount><a href="../../uploadedfiles/online_app/page10/#get_student_info.studentid#.#page10.filetype#" target="_blank">10</a></td><td>#page10.filetype#<cfelse>10</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td><cfif page18.recordcount><a href="../../uploadedfiles/online_app/page18/#get_student_info.studentid#.#page18.filetype#" target="_blank">18</a></td><td>#page18.filetype#<cfelse>18</td><td>no file attached</td></cfif></tr>	
	<tr><td><cfif page12.recordcount><a href="../../uploadedfiles/online_app/page12/#get_student_info.studentid#.#page12.filetype#" target="_blank">12</a></td><td>#page12.filetype#<cfelse>12</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td><cfif page19.recordcount><a href="../../uploadedfiles/online_app/page19/#get_student_info.studentid#.#page19.filetype#" target="_blank">19</a></td><td>#page19.filetype#<cfelse>19</td><td>no file attached</td></cfif></tr>			
	<tr><td><cfif page13.recordcount><a href="../../uploadedfiles/online_app/page13/#get_student_info.studentid#.#page13.filetype#" target="_blank">13</a></td><td>#page13.filetype#<cfelse>13</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td><cfif page20.recordcount><a href="../../uploadedfiles/online_app/page20/#get_student_info.studentid#.#page20.filetype#" target="_blank">20</a></td><td>#page20.filetype#<cfelse>20</td><td>no file attached</td></cfif></tr>
	<tr><td><cfif page14.recordcount><a href="../../uploadedfiles/online_app/page14/#get_student_info.studentid#.#page14.filetype#" target="_blank">14</a></td><td>#page14.filetype#<cfelse>14</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td><cfif page21.recordcount><a href="../../uploadedfiles/online_app/page21/#get_student_info.studentid#.#page21.filetype#" target="_blank">21</a></td><td>#page21.filetype#<cfelse>21</td><td>no file attached</td></cfif></tr>
	<tr><td><cfif page15.recordcount><a href="../../uploadedfiles/online_app/page15/#get_student_info.studentid#.#page15.filetype#" target="_blank">15</a></td><td>#page15.filetype#<cfelse>15</td><td>no file attached</td></cfif><td>&nbsp;</td>
		<td>&nbsp;</td></tr>
</table><br>
--->
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>
</cfoutput>

</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>