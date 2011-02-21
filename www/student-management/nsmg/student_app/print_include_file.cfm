<cfoutput>

<cfdirectory directory="#AppPath.onlineApp.inserts#/#doc#" name="file" filter="#client.studentid#.*">	

<cfif ListFind("jpg,peg,gif,tif,png", LCase(Right(file.name, 3)))>
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