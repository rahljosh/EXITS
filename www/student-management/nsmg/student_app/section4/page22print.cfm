<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- OPENING FROM PHP - AXIS --->
    <cfif IsDefined('URL.user')>
        <cfset CLIENT.usertype = URL.user>
    </cfif>
    
    <cfif isDefined('URL.unqid')>
        <!----Get student id  for office folks linking into the student app---->
        <cfquery name="get_student_id" datasource="#APPLICATION.DSN#">
            select studentid from smg_students
            where uniqueid = <cfqueryparam value="#URL.unqid#" cfsqltype="cf_sql_char">
        </cfquery>
        <cfset CLIENT.studentid = #get_student_id.studentid#>
    </cfif>
    
    <cfif LEN(URL.curdoc) OR IsDefined('URL.path')>
        <cfset path = "">
    <cfelseif IsDefined('URL.exits_app')>
        <cfset path = "nsmg/student_app/">
    <cfelse>
        <cfset path = "../">
    </cfif>
    
    <cfparam name="fileURL" default="..">

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
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

<cfif IsDefined('URL.studentid')>
	<cfset CLIENT.studentid = URL.studentid>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [22] - Supplements</h2></td>
		<cfif LEN(URL.curdoc)>
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
	<cfif NOT VAL(mydirectory.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfloop query="mydirectory">
		<cfset newsize = size / '1024'>
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("white") ,DE("CCCCCC") )#">
			<cfif ListFind("jpg,peg,gif,tif,png", Right(name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page22&file=#URLEncodedFormat(jsStringFormat(name))#');">#name#</a></td>
			<cfelse>
				<td><b>*</b> <a href="../#fileURL#/uploadedfiles/virtualfolder/#get_student_info.studentid#/page22/#name#" target="_blank">#name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#DateFormat(dateLastModified, 'mm/dd/yyyy  hh:mm:ss')#</td>
		</tr>
		</cfloop>
	</cfif>

	<tr><td colspan="3"><h2>Other Attachments</h2></td></tr>

	<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="studentletter" filter="#get_student_info.studentid#.*">
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 05 - Student's Letter</b></td></tr>
	<cfif NOT VAL(studentletter.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = studentletter.size / '1024'>
		<tr><td><a href="../#fileURL#/uploadedfiles/letters/students/#studentletter.name#" target="_blank">#studentletter.name#</a></td>
			<td>#Round(newsize)# kb</td>
			<td>#studentletter.dateLastModified#</td>
		</tr>
	</cfif>

	<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="parentletter" filter="#get_student_info.studentid#.*">
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 06 - Parent's Letter</b></td></tr>
	<cfif NOT VAL(parentletter.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = parentletter.size / '1024'>
		<tr><td><a href="../#fileURL#/uploadedfiles/letters/parents/#parentletter.name#" target="_blank">#parentletter.name#</a></td>
			<td>#Round(newsize)# kb</td>
			<td>#parentletter.dateLastModified#</td>
		</tr>
	</cfif>
	
	<cfloop list="07,08,09,10,12,13,14,15,16,17,18,19,20,21" index="x">
		<cfdirectory directory="#AppPath.onlineApp.inserts#page#x#" name="page#x#" filter="#get_student_info.studentid#.*">	
	</cfloop>
    
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 07 - School Information</b></td></tr>
	<cfif NOT VAL(page07.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page07.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page07.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page07&file=#URLEncodedFormat(page07.name)#');">#page07.name#</a></td>
			<cfelse>
				<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page07/#page07.name#" target="_blank">#page07.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page07.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 08 - Transcript of Grades</b></td></tr>
	<cfif NOT VAL(page08.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page08.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page08.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page08&file=#URLEncodedFormat(page08.name)#');">#page08.name#</a></td>
			<cfelse>
				<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page08/#page08.name#" target="_blank">#page08.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page08.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 09 - Language Evaluation</b></td></tr>
	<cfif NOT VAL(page09.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page09.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page09.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page09&file=#URLEncodedFormat(page09.name)#');">#page09.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page09/#page09.name#" target="_blank">#page09.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page09.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 10 - Social Skills</b></td></tr>
	<cfif NOT VAL(page10.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page10.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page10.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page10&file=#URLEncodedFormat(page10.name)#');">#page10.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page10/#page10.name#" target="_blank">#page10.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page10.dateLastModified#</td>
		</tr>
	</cfif>		
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 12 - Clinical Evaluation</b></td></tr>
	<cfif NOT VAL(page12.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page12.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page12.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page12&file=#URLEncodedFormat(page12.name)#');">#page12.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page12/#page12.name#" target="_blank">#page12.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page12.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 13 - Immunization Record</b></td></tr>
	<cfif NOT VAL(page13.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page13.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page13.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page13&file=#URLEncodedFormat(page13.name)#');">#page13.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page13/#page13.name#" target="_blank">#page13.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page13.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 14 - Authorization to Treat a Minor</b></td></tr>
	<cfif NOT VAL(page14.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page14.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page14.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page14&file=#URLEncodedFormat(page14.name)#');">#page14.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page14/#page14.name#" target="_blank">#page14.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page14.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 15 - Program Agreement</b></td></tr>
	<cfif NOT VAL(page15.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page15.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page15.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page15&file=#URLEncodedFormat(page15.name)#');">#page15.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page15/#page15.name#" target="_blank">#page15.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page15.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 16 - Liability Release</b></td></tr>
	<cfif NOT VAL(page16.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page16.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page16.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page16&file=#URLEncodedFormat(page16.name)#');">#page16.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page16/#page16.name#" target="_blank">#page16.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page16.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 17 - Travel Authorization</b></td></tr>
	<cfif NOT VAL(page17.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page17.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page17.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page17&file=#URLEncodedFormat(page17.name)#');">#page17.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page17/#page17.name#" target="_blank">#page17.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page17.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 18 - Private School</b></td></tr>
	<cfif NOT VAL(page18.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page18.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page18.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page18&file=#URLEncodedFormat(page18.name)#');">#page18.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page18/#page18.name#" target="_blank">#page18.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page18.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 19 - Intl. Rep. Questionnaire</b></td></tr>
	<cfif NOT VAL(page19.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page19.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page19.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page19&file=#URLEncodedFormat(page19.name)#');">#page19.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page19/#page19.name#" target="_blank">#page19.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page19.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 20 - Region Preference</b></td></tr>
	<cfif NOT VAL(page20.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page20.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page20.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page20&file=#URLEncodedFormat(page20.name)#');">#page20.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page20/#page20.name#" target="_blank">#page20.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page20.dateLastModified#</td>
		</tr>
	</cfif>
	<tr bgcolor="##CCCCCC"><td colspan="3"><b>Page 21 - State Preference</b></td></tr>
	<cfif NOT VAL(page21.recordcount)>
		<tr><td colspan="3">No file has been uploaded.</td></tr>
	<cfelse>
		<cfset newsize = page21.size / '1024'>
		<tr>
			<cfif ListFind("jpg,peg,gif,tif,png", Right(page21.name, 3))>
				<td><a href="javascript:PrintFile('page22printfile.cfm?studentid=#get_student_info.studentid#&page=page21&file=#URLEncodedFormat(page21.name)#');">#page21.name#</a></td>
			<cfelse>
		  		<td><b>*</b> <a href="../#fileURL#/uploadedfiles/online_app/page21/#page21.name#" target="_blank">#page21.name#</a></td>
			</cfif>
			<td>#Round(newsize)# kb</td>
			<td>#page21.dateLastModified#</td>
		</tr>
	</cfif>
</table><br>		

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