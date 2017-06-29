<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../smg.css">
	<title>Student's Program Hold History</title>
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

	<cfquery name="qGetStudentHoldStatuses" datasource="#APPLICATION.DSN#">
      SELECT 
          shs.student_id, shs.hold_status_id, shs.area_rep_id, shs.host_family_id, shs.create_date, shs.create_by,
          u.firstname AS AreaRepFirstName, u.lastname AreaRepLastName, u.userid AS AreaRepID,
          h.familylastname AS HostFamilyName, h.fatherfirstname AS HostFatherName, h.motherfirstname AS HostMotherName, h.hostID,
          s.schoolname, s.city AS schoolcity, s.state AS schoolstate, s.schoolid,
          su.firstname AS CreatorFirstName, su.lastname CreatorLastName, su.userid AS CreatorID,
          hs.name AS StatusName
      FROM smg_student_hold_status shs
      LEFT OUTER JOIN smg_users u ON (shs.area_rep_id = u.userid)
      LEFT OUTER JOIN smg_hosts h ON (shs.host_family_id = h.hostID)
      LEFT OUTER JOIN smg_schools s ON (shs.school_id = s.schoolID)
      LEFT OUTER JOIN smg_users su ON (shs.create_by = su.userid)
      LEFT OUTER JOIN smg_hold_status hs ON (hs.id = shs.hold_status_id)
      WHERE 
          student_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.studentID)#">
      ORDER BY 
          shs.id DESC
  </cfquery>


	<cfoutput query="get_student_info">
		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
				<td background="../pics/header_background.gif"><h2>#companyshort#</h2></td>
				<td align="right" background="../pics/header_background.gif"><h2>Placement Hold Status History for #firstname# #familylastname# (#studentid#)</h2></td>
				<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
			</tr>
		</table>

		<table width="100%" border=0 cellpadding=1 cellspacing=0 class="section">
			<tr>
				<th>Assigned On</th>
				<th>Status</th>
				<th>Area Rep.</th>
				<th>Host Family</th>
				<th>School</th>
				<th>Assigned By</th>
			</tr>
			<cfif qGetStudentHoldStatuses.recordcount EQ '0'>
			<tr><td colspan="6" align="center">There is no Program Hol History for this student.</td></tr>
			<cfelse>
				<cfloop query="qGetStudentHoldStatuses">
					<tr>
						<td>#DateTimeFormat(qGetStudentHoldStatuses.create_date, 'm/d/YYYY hh:nn tt')#</td>
						<td>#qGetStudentHoldStatuses.StatusName#</td>
						<td>
							<cfif VAL(qGetStudentHoldStatuses.AreaRepID)>
								#qGetStudentHoldStatuses.AreaRepFirstName# #qGetStudentHoldStatuses.AreaRepLastName# (###qGetStudentHoldStatuses.AreaRepID#)
							<cfelse>
								-
							</cfif>
						</td>
						<td>
							<cfif VAL(qGetStudentHoldStatuses.hostID)>
								#qGetStudentHoldStatuses.HostFamilyName# - #qGetStudentHoldStatuses.HostFatherName# and #qGetStudentHoldStatuses.HostMotherName# (###qGetStudentHoldStatuses.hostID#)
							<cfelse>
								-
							</cfif>
						</td>
						<td>
							<cfif VAL(qGetStudentHoldStatuses.schoolID)>
								#qGetStudentHoldStatuses.SchoolName# - #qGetStudentHoldStatuses.SchoolCity# / #qGetStudentHoldStatuses.SchoolState# (###qGetStudentHoldStatuses.schoolID#)
							<cfelse>
								-
							</cfif>
						</td>
						<td>
							<cfif VAL(qGetStudentHoldStatuses.CreatorID)>
								#qGetStudentHoldStatuses.CreatorFirstName# #qGetStudentHoldStatuses.CreatorLastName# (###qGetStudentHoldStatuses.CreatorID#)
							<cfelse>
								-
							</cfif>
						</td>
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