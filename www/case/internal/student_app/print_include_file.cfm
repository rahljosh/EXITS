<cfoutput>

<cfset nsmg_directory = '/var/www/html/student-management/nsmg/uploadedfiles'>

<cfdirectory directory="#nsmg_directory#/online_app/#doc#" name="file" filter="#get_student_info.studentid#.*">	

<cfif Right(file.name, 3) EQ 'jpg' OR Right(file.name, 4) EQ 'jpeg' OR Right(file.name, 3) EQ 'gif' OR Right(file.name, 3) EQ 'bmp'>
	<table width="660" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="#path#../uploadedfiles/online_app/#doc#/#file.name#" width="660" height="820"></td></tr>
	</table>
	<cfset printpage = 'no'>
	<!--- ADD PAGE BREAK - PRINT ONLY ATTACHED FILE --->
 	<cfif doc EQ 'page14' OR doc EQ 'page15' OR doc EQ 'page16' OR doc EQ 'page17' OR doc EQ 'page18' OR doc EQ 'page20'>
		<div style="page-break-after:always;"></div><br>
	</cfif>
<cfelse>
	<cfset printpage = 'yes'>
</cfif>

</cfoutput>