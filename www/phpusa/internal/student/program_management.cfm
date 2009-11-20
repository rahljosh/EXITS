<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Program Management</title>
<link rel="stylesheet" href="../phpusa.css" type="text/css">
</head>

<body>
<!--- Get Student Info by UniqueID --->
<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Get Student Info by UniqueID --->
<cfinclude template="../querys/get_student_unqid.cfm">

<cfinclude template="../querys/get_programs.cfm">

<!--- student does not exist --->
<cfif get_student_unqid.recordcount EQ 0>
	The student ID you are looking for, <cfoutput>#get_student_unqid.studentid#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the student record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the student
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<cfquery name="get_programs_assigned" datasource="MySql">
	SELECT php_stu.assignedid, php_stu.programid, php_stu.active, php_stu.canceldate, php_stu.cancelreason, php_stu.datecreated,
		p.programname,
		u.firstname, u.lastname
	FROM php_students_in_program php_stu
	LEFT JOIN smg_programs p ON p.programid = php_stu.programid
	LEFT JOIN smg_users u ON u.userid = php_stu.inputby
	WHERE php_stu.studentid = '#get_student_unqid.studentid#'
	ORDER BY php_stu.assignedid DESC
</cfquery>

<cfset program_assigned = ValueList(get_programs_assigned.programid)>

<cfoutput>

<cfform name="new_program" action="qr_program_management.cfm" method="post">
	<cfinput type="hidden" name="studentid" value="#get_student_unqid.studentid#">
	<cfinput type="hidden" name="unqid" value="#get_student_unqid.uniqueid#">
	<cfinput type="hidden" name="count" value="#get_programs_assigned.recordcount#">
	<table width="98%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
		<th bgcolor="##C2D1EF" colspan="2">P R O G R A M &nbsp; &nbsp; M A N A G E M E N T</th>
		<tr><th align="center" colspan="2">Student: #get_student_unqid.firstname# #get_student_unqid.familylastname# (###get_student_unqid.studentid#)</th></tr>
		<tr>
			<td>
				<table width="95%" align="center">
					<tr bgcolor="##C2D1EF">
						<td width="20%"><b>Program</b></td>
						<td width="15%"><b>Status</b></td>
						<th width="25%">Date Assigned</th>
						<td width="20%"><b>Created By</b></td>
						<th width="20%">Set Active</th>
					</tr>
					<cfloop query="get_programs_assigned">
						<cfinput type="hidden" name="assignedid_#currentrow#" value="#assignedid#">
						<tr bgcolor="###IIF(currentrow mod 2 eq 0, DE("e9ecf1"), DE("ffffff") )#"> <!--- C2D1EF --->
							<td>#programname#</td>
							<td><cfif active EQ 1>Active<cfelse>Inactive</cfif></td>
							<th>#DateFormat(datecreated, 'mm/dd/yy')#</th>
							<td>#firstname# #lastname#</td>
							<th><input type="checkbox" name="active_#currentrow#" <cfif active EQ 1>disabled="disabled"</cfif>></th>
						</tr>
					</cfloop>
				</table>
				<br>
				<!--- NEW PROGRAM --->
				<table width="95%" align="center">
					<tr bgcolor="##C2D1EF"><td colspan="4"><b>Insert New Program</b></td></tr>
					<tr>
						<td>Program :</td>
						<td><cfselect name="new_program">
							<option value="0"></option>
							<cfloop query="get_programs">
								<cfif listfindnocase("#program_assigned#", programid) EQ 0>
								<option value="#programid#">#programname#</option>
								</cfif>
							</cfloop>
							</cfselect>
						</td>
						<td>Status :</td>
						<td><cfselect name="new_status">
							<option value="no"></option>
							<option value="1">Active</option>
							<option value="0">Inactive</option>
							</cfselect>
						</td>
					</tr>
				</table>			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
				<cfinput type="image" name="submit" value="Update" src="../pics/update.gif" submitOnce>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfform>

</cfoutput>

</body>
</html>