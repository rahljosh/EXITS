<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Put Applicaton On Hold</title>
</head>

<body>

<cfoutput>

<cfif form.onhold_reasonid EQ 0>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Application On Hold Information</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border=0 cellpadding=4 cellspacing=2 align="center" class="section">
		<tr><td align="center">You must select a reason. Please go back and try again.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<!--- English Interview --->
<cfif form.onhold_reasonid EQ 2 AND (form.onhold_interview_date EQ '' OR form.onhold_interview_time EQ '')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Application On Hold Information</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border=0 cellpadding=4 cellspacing=2 align="center" class="section">
		<tr><td align="center">You selected English Interview. You must enter an interview date and time in order to proceed.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<!--- Missing Application Documents --->
<cfif form.onhold_reasonid EQ 3 AND NOT IsDefined('form.onhold_docs')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
			<td background="pics/header_background.gif"><h2>Application On Hold Information</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table width="100%" border=0 cellpadding=4 cellspacing=2 align="center" class="section">
		<tr><td align="center">You selected Missing Application Documents as a reason. You must select at least one document that is missing. Please go back and try again.</td></tr>
		<tr><td align="center"><input name="back" type="image" src="pics/back.gif" border=0 onClick="javascript:history.back()"></td></tr>
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<!--- SET APP ON HOLD --->
<cfquery name="update" datasource="caseusa">
	UPDATE smg_students
	SET onhold_reasonid = '#form.onhold_reasonid#',
		onhold_notes = '#form.onhold_notes#',
		onhold_docs = <cfif IsDefined('form.onhold_docs')>'#form.onhold_docs#'<cfelse>'0'</cfif>,
		onhold_interview_date = <cfif IsDefined('form.onhold_interview_date') AND form.onhold_interview_date NEQ ''>#CreateODBCDate(form.onhold_interview_date)#<cfelse>NULL</cfif>,
		onhold_interview_time = <cfif IsDefined('form.onhold_interview_time') AND form.onhold_interview_time NEQ ''>#CreateODBCTime(form.onhold_interview_time)#<cfelse>NULL</cfif>
	WHERE studentid = '#form.studentid#'
	LIMIT 1
</cfquery>

<cflocation url="?curdoc=app_process/app_onhold_info&studentid=#form.studentid#" addtoken="no">

</cfoutput>

</body>
</html>