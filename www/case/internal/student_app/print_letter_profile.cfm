<!--- <cfdocument format="pdf"> --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>EXITS - Print Letters</title>
</head>

<body onLoad="print()">

<p>&nbsp;</p>
<cfif NOT IsDefined('url.studentid') AND NOT IsDefined('url.letter')>
	<table width="680" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td>
			Sorry, an error has occurred. Please try again.<br>
			If this error persists please contact the system administrator support@case-usa.org		
		</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<cfoutput>

<cfdirectory directory="/var/www/html/case/internal/uploadedfiles/letters/#url.letter#/" name="letter" filter="#studentid#.*">
<table width="680" border="0" cellpadding="3" cellspacing="0" align="center">
<cfif letter.recordcount>	
	<tr><td><img src="../uploadedfiles/letters/#url.letter#/#letter.name#" width="680" height="860"></td></tr>
<cfelse>
	<tr><td>Letter not found. Please try again.<br> If this error persists please contact the system administrator support@case-usa.org</td></tr>
</cfif>
</table>

</cfoutput>

</body>
</html>

<!--- </cfdocument>  --->