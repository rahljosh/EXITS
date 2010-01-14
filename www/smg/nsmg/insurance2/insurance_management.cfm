<link rel="stylesheet" href="../smg.css" type="text/css">
<cfinclude template="../querys/get_company_short.cfm">

<Cfquery name="get_student_info" datasource="MySQL">
	SELECT  s.familylastname, s.firstname, s.studentid, s.hostid, s.flight_info_notes, s.cancelinsurancedate,
			s.insurance, u.insurance_typeid , u.businessname,
			p.insurance_startdate, p.insurance_enddate
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE studentid =  <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>#companyshort.companyshort# - Insurance Management</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>#get_student_info.firstname# #get_student_info.familylastname# (#get_student_info.studentid#)</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<div class="section">
<cfif (get_student_info.insurance_typeid EQ 0 OR get_student_info.insurance_typeid EQ 1)> 
	<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
		<tr><td>This Agent does not take Insurance or the Insurance Policy Type is Missing.</td></tr>
	</table>
	<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
	</table>
	<cfabort>
</cfif>	

<cfquery name="ins_info" datasource="mysql">
select * 
from smg_insurance_batch
where studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>
<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
		<tr>
			<td>Date Submitted</td><td>Type</td><td>Start Date</td><td>End Date</td>
		<tr>
<cfloop query="ins_info">
		<tr>
			<td>#DateFormat(date, 'mm/dd/yyyy')#</td><td><cfif #type# is 'N'>Initial<cfelse>Update</cfif></td>
			<td>#DateFormat(startdate, 'mm/dd/yyyy')#</td><td></td>
			
		</tr>
</cfloop>
		<tr>
			<td colspan=5>Insurance infomation is calculated off school end date, and flight infomation.  Batchs run weekly on thurday nights.
</table>
<table width=100% cellpadding=0 cellspacing=0 border=0>
<tr valign="bottom">
	<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
	<td width=100% background="../pics/header_background_footer.gif"></td>
	<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>
</cfoutput>