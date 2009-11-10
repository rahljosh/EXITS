<cfoutput>

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles'>

<cfdirectory directory="#nsmg_directory#/letters/#doc#" name="letter" filter="#get_student_info.studentid#.*">	

<cfif letter.recordcount NEQ '0' AND (#Right(letter.name, 3)# EQ 'jpg' OR #Right(letter.name, 3)# EQ 'peg' OR #Right(letter.name, 3)# EQ 'gif' OR #Right(letter.name, 3)# EQ 'tif' OR #Right(letter.name, 3)# EQ 'png' OR #Right(letter.name, 3)# EQ 'bmp')>
	<div style="page-break-after:always;"></div><br>
	<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="#path#../uploadedfiles/letters/#doc#/#letter.name#" width="660" height="820"></td></tr>
	</table>
</cfif>
</cfoutput>