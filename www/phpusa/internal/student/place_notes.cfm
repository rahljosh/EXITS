<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - Notes</title>
</head>

<body>

<cftry>

<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- get student info by uniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfoutput>

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="##e9ecf1"> 
<tr><td>

<!--- include template page header --->
<cfinclude template="place_menu_header.cfm">

</td></tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>

