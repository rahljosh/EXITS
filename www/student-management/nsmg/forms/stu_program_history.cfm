<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../smg.css">
	<title>Program Assigment History</title>
</head>
<body>

<cfif not IsDefined('url.unqid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfquery name="get_student_info" datasource="MySql">
	SELECT studentid, firstname, familylastname, smg_companies.companyname, smg_companies.companyshort
	FROM smg_students
	INNER JOIN smg_companies ON smg_companies.companyid = smg_students.companyid
	WHERE uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
</cfquery>

<cfquery name="program_history" datasource="MySql">
	SELECT  programhistoryid, studentid, reason, changedby, date,
			p.programname, p.programid,
			u.firstname, u.lastname, u.userid
	FROM smg_programhistory
	LEFT JOIN smg_programs p ON p.programid = smg_programhistory.programid
	LEFT JOIN smg_users u ON u.userid = smg_programhistory.changedby
	WHERE studentid = '#get_student_info.studentid#'
	ORDER BY programhistoryid
</cfquery>

<cfoutput query="get_student_info">
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>#companyshort#</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>Program Assigment History for #firstname# #familylastname# (#studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=1 cellspacing=0 class="section">
	<tr><th>Assigned On</th>
		<th>Program</th>
		<th>Reason</th>
		<th>Assigned By</th>
	</tr>
	<cfif program_history.recordcount EQ '0'>
	<tr><td colspan="6" align="center">There is no Program History for this student. Feature added to EXITS on 01/14/2006.</td></tr>
	<cfelse>
		<cfloop query="program_history">
			<tr bgcolor="#iif(program_history.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
				<td align="center">#DateFormat(date, 'mm/dd/yyyy')#</td>
				<td align="center"><cfif programname EQ ''>Unassigned<cfelse>#programname# (###programid#)</cfif></td>
				<td align="center">#reason#</td>
				<td align="center">#firstname# #lastname# (#userid#)</td>
			</tr>
		</cfloop>
	</cfif>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>
</cfoutput>

</body>
</html>