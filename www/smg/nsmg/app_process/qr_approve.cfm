<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Approve Paper Application</title>
</head>

<body>

<cfif NOT IsDefined('url.studentid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Approve Paper Application</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border=0 cellpadding=4 cellspacing=2 align="center" class="section">
		<tr><td align="center">No student found. Please go back and try again.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<cfset client.studentid = url.studentid>

<!--- Application Approved --->
<cfset newstatus = 11>

<cfquery name="add_approval_history" datasource="MySQL">
	INSERT INTO smg_student_app_status 
		(studentid, status, approvedby)
	VALUES 
		('#client.studentid#', '#newstatus#', '#client.userid#')
</cfquery>

<cfquery name="approve_application" datasource="MySQL">
	UPDATE smg_students 
	SET dateapplication = #CreateODBCDate(now())#,
		app_current_status = '#newstatus#',
		entered_by = '#client.userid#'
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

<cfoutput>
<script language="JavaScript">
<!-- 
alert("This application has been approved. This student should show up on the unplaced list.");
	location.replace("index.cfm?curdoc=app_process/apps_received");
-->
</script>
</cfoutput>
</body>
</html>