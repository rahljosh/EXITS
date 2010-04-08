<cftry>

<!--- <cfdocument format="pdf"> --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>EXITS - Print Attached Files</title>
</head>

<body onLoad="print()">

<cfif NOT IsDefined('url.studentid') AND NOT IsDefined('url.page') AND NOT IsDefined('url.file')>
	Sorry, an error has occurred. Please try again.<br>
	If this error persists please contact the system administrator support@case-usa.org
</cfif><cfoutput><cfif url.page EQ 'page22'>
	<table width="680" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="../../uploadedfiles/virtualfolder/#url.studentid#/#url.page#/#url.file#" width="680" height="860"></td></tr>
	</table>
<cfelse>
	<table width="680" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="../../uploadedfiles/online_app/#url.page#/#url.file#" width="680" height="860"></td></tr>
	</table>
</cfif>

</cfoutput>

</body>
</html>

<!--- </cfdocument> --->

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>