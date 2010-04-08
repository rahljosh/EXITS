<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" type="text/css" href="../smg.css">
<title>SEVIS HISTORY</title>
</head>

<body>

<cfif not IsDefined('url.unqid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfquery name="get_history" datasource="MySql">
	SELECT hist.studentid, hist.batchid, hist.hostid, hist.school_name, hist.start_date, hist.end_date,
		sevis.datecreated, sevis.type,
		s.firstname, s.familylastname,
		h.familylastname as hostlastname,
		c.companyshort
	FROM smg_sevis_history hist
	INNER JOIN smg_students s ON s.studentid = hist.studentid
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	LEFT JOIN smg_sevis sevis ON sevis.batchid = hist.batchid
	LEFT JOIN smg_hosts h ON h.hostid = hist.hostid
	WHERE s.uniqueid = <cfqueryparam value="#url.unqid#" cfsqltype="cf_sql_char">
</cfquery>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>#get_history.companyshort#</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>SEVIS History for #get_history.firstname# #get_history.familylastname# (###get_history.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=3 cellspacing=1 class="section">
	<tr>
		<th>Type</th>
		<th>Batch ID</th>		
		<th>Sent Date</th>
		<th>Host Family</th>
		<th>School</th>
		<th>DS2019 Start</th>
		<th>DS2019 End</th>
	</tr>
	<cfloop query="get_history">
		<tr bgcolor="<cfif currentrow MOD 2 EQ 0>##ffffe6<cfelse>##e2efc7</cfif>">
			<td>#type#</td>
			<td>###batchid#</td>
			<td>#DateFormat(datecreated, 'mm/dd/yyyy')#</td>
			<td>#hostlastname# (###hostid#)</td>
			<td>#school_name#</td>
			<td>#DateFormat(start_date, 'mm/dd/yyyy')#</td>
			<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>
		</tr>
	</cfloop>
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