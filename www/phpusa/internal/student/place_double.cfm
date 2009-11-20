<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - Double Placement</title>
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

<!--- CHECK CANCELED STUDENT --->
<cfif get_student_unqid.canceldate NEQ ''> 
	<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
		<tr bgcolor="##C2D1EF"><td align="center"><b>High School</b></td></tr>
		<tr><td>#get_student_unqid.firstname# #get_student_unqid.familylastname# was canceled on #DateFormat(get_student_unqid.canceldate, 'mmm dd, yyyy')#. &nbsp; You can not place them with a school.</td></tr>
		<tr><td align="center"><font size=-1><Br>&nbsp;&nbsp; <input type="image" value="close window" src="../pics/close.gif" onclick="javascript:window.close()"></font></td></tr>
	</table><br><br>
	<cfabort>
</cfif>

</td></tr>
</table>

</cfoutput>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>

</body>
</html>