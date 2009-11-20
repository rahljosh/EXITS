<link rel="stylesheet" href="../smg.css" type="text/css">
<cfinclude template="../querys/get_company_short.cfm">
<cfinclude template="../querys/get_student_unqid.cfm">
<Cfquery name="get_student_info" datasource="MySQL">
	SELECT  s.familylastname, s.firstname, s.studentid, s.hostid, s.flight_info_notes, s.cancelinsurancedate,
			s.insurance, u.insurance_typeid , u.businessname,
			p.insurance_startdate, p.insurance_enddate
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid
	WHERE studentid =  <cfqueryparam value="#get_student_unqid.studentid#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" bgcolor="f4f4f4">
<tr><td bordercolor="FFFFFF" valign="top">

		<!----Header Table---->
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
			<tr bgcolor="E4E4E4">
				<td class="title1">&nbsp; &nbsp; INSURANCE MANAGEMENT</td>
				<td class="title1" align="right">#get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#) &nbsp; &nbsp;</td>
			</tr>
		</table><br>
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
where studentid = <cfqueryparam value="#get_student_unqid.studentid#" cfsqltype="cf_sql_integer">
</cfquery>
<table border="0" align="center" width="100%" cellpadding="3" cellspacing="1">
		<tr>
			<td>Date Submitted</td><td>Type</td><td>Start Date</td><td>End Date</td><td>File</td>
		<tr>
<cfloop query="ins_info">
		<tr>
			<td>#DateFormat(submitted, 'mm/dd/yyyy')#</td><td><cfif #type# is 'N'>Initial<cfelse>Update</cfif></td>
			<td>#DateFormat(startdate, 'mm/dd/yyyy')#</td>
			<td>#DateFormat(enddate, 'mm/dd/yyyy')#</td><td><a href="#file#.xls">View Spreadsheet</a></td>
		</tr>
</cfloop>
		<tr>
			<td colspan=5>Insurance infomation is calculated off school end date, and flight infomation.  Batchs run weekly on thurday nights.
</table>

</cfoutput>