<cfsilent>
	
    <!--- Param URL Variables --->
	<cfparam name="URL.studentID" default="0">
	<cfparam name="URL.page" default="">
    <cfparam name="URL.file" default="">

	<!--- Decode URL --->
	<cfset URL.file = URLDecode(URL.file)>

</cfsilent>

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

<cfif NOT VAL(URL.studentid) OR NOT LEN(URL.page) OR NOT LEN(URL.file)>
	Sorry, an error has occurred. Please try again.<br>
	If this error persists please contact the system administrator support@student-management.com
	<cfabort>
</cfif>

<cfoutput>

<!--- page 22 virtual folder --->
<cfif URL.page EQ 'page22'>
	<table width="680" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="../../uploadedfiles/virtualfolder/#URL.studentid#/#URL.page#/#URL.file#" width="680" height="860"></td></tr>
	</table>
<cfelse>
	<table width="680" border="0" cellpadding="3" cellspacing="0" align="center">
		<tr><td><img src="../../uploadedfiles/online_app/#URL.page#/#URL.file#" width="680" height="860"></td></tr>
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