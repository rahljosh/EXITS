<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfsetting requesttimeout="500">

<!--- CREATES EXTENSION OR EARLY RETURN DATA --->
<cfif NOT IsDefined('form.programid') OR NOT IsDefined('form.extensiondate')>
	You must select a program and / or enter a new extension date. Please go back and try again.
	<cfabort>
</cfif>

<!--- GET STUDENTS WITH CAREMED ON FILE --->
<cfquery name="get_students" datasource="MySql">
	SELECT DISTINCT s.firstname, s.familylastname, s.sex, s.dob, s.studentid, s.termination_date,
		 u.businessname
	FROM 	smg_students s
	INNER JOIN smg_users u ON s.intrep = u.userid 
	INNER JOIN smg_insurance insu ON s.studentid = insu.studentid	
	INNER JOIN smg_programs p ON s.programid = p.programid
	WHERE s.active = '1'
		AND cancelinsurancedate IS NULL
		AND insu.sent_to_caremed IS NOT NULL
		AND (<cfloop list="#form.programid#" index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>)
	ORDER BY u.businessname, s.firstname
</cfquery>

<cfoutput>

<cfset totalnew = 0>
<cfset totalextension = 0>
<cfset totalearly = 0>
<cfset totalmanualext = 0>

<table width="80%" align="center" frame="box">
	<tr>
		<td>Intl. Agent </td>
		<td>Student</td>
		<td>Insurance Start Date</td>
		<td>Insurance End Date</td>
	</tr>

<cfloop query="get_students">
	<Cfquery name="get_history" datasource="MySQL">
		SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, sent_to_caremed, 
		org_code, policy_code, transtype
		FROM smg_insurance
		WHERE studentid = <cfqueryparam value="#get_students.studentid#" cfsqltype="cf_sql_integer">
		ORDER BY insuranceid DESC
	</cfquery>
	<cfquery name="get_flight" datasource="MySql">
		SELECT studentid, dep_date, flight_type
		FROM smg_flight_info
		WHERE studentid = <cfqueryparam value="#get_students.studentid#" cfsqltype="cf_sql_integer">
			AND flight_type = 'departure'
		ORDER BY dep_date
	</cfquery>

		<!--- TERMINATION DATE ---->
		<cfif termination_date NEQ ''>
				<cfset newenddate = #DateFormat(termination_date, 'mm/dd/yyyy')#>

				<!--- EXTENSION ACCORDING TO TERMINATION DATE --->
				<cfif newenddate GT get_history.end_date AND newenddate GT now()>
					<tr>
						<td>#get_students.businessname#</td>
						<td>#get_history.firstname#  #get_history.lastname# (###get_history.studentid#)</td>
						<td>#DateFormat(get_history.new_date, 'mm/dd/yyyy')#</td>
						<td>#DateFormat(get_history.end_date, 'mm/dd/yyyy')#</td>
					</tr>
					<!--- INSURANCE EXPIRED --->
					<cfif get_history.end_date LT now()>
						<cfset ext_startdate = #DateFormat(now(),'mm/dd/yyyy')#>
						<cfset totalnew = totalnew + 1>
						<tr><td colspan="4"><font color="red">*** INSURANCE EXPIRED ***</font> &nbsp; <font color="0000CC">NEW TRANSACTION - Termination date #DateFormat(newenddate, 'mm/dd/yyyy')# &nbsp; Insurance: Start Date: #DateFormat(ext_startdate,'mm/dd/yyyy')# &nbsp; End Date: #DateFormat(newenddate,'mm/dd/yyyy')#</font></td></tr>
						<cfquery name="insert_extension" datasource="MySql">
							INSERT INTO smg_insurance
								(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
							VALUES
								('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
								#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(ext_startdate)#,
								#CreateODBCDate(newenddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'new');	
						</cfquery>
					<cfelse>
						<cfset ext_startdate = #DateFormat(DateAdd('y', 1, get_history.end_date), 'mm/dd/yyyy')#>
						<cfset totalextension = totalextension + 1>
						<tr><td align="right" colspan="4"><font color="0000CC">Extension termination date #DateFormat(newenddate, 'mm/dd/yyyy')#</font></td><td></td>
						<cfquery name="insert_extension" datasource="MySql">
							INSERT INTO smg_insurance
								(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
							VALUES
								('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
								#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(ext_startdate)#,
								#CreateODBCDate(newenddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'extension');	
						</cfquery>
					</cfif>
				<!--- EARLY RETURN ACCORDING TO TERMINATION DATE --->
				<cfelseif newenddate LT get_history.end_date AND #Abs(DateDiff('d', get_history.end_date, newenddate))# GT '5' AND get_history.end_date GT now()>
					<cfset totalearly = totalearly + 1>
					<tr>
						<td>#get_students.businessname#</td>
						<td>#get_history.firstname#  #get_history.lastname# (###get_history.studentid#)</td>
						<td>#DateFormat(get_history.new_date, 'mm/dd/yyyy')#</td>
						<td>#DateFormat(get_history.end_date, 'mm/dd/yyyy')#</td>
					</tr>
					<tr>
						<td align="right" colspan="4">
								<font color="0000CC">Early Return flight departure date #DateFormat(newenddate, 'mm/dd/yyyy')#</font>
								<cfif newenddate LT now()>
									<cfset newenddate = now()> - New Early Return on File #DateFormat(newenddate, 'mm/dd/yyyy')#
								</cfif>
						</td>
					</tr>					
					<cfquery name="insert_early_return" datasource="MySql">
						INSERT INTO smg_insurance
							(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
						VALUES
							('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
							#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(newenddate)#,
							#CreateODBCDate(get_history.end_date)#, '#get_history.org_code#', '#get_history.policy_code#', 'early return');	
					</cfquery>
				</cfif>		
		
		
		
		
		<!--- FLIGHT DEPARTURE --->
		<cfelseif get_flight.dep_date NEQ ''>
				<cfset newenddate = #DateFormat(get_flight.dep_date, 'mm/dd/yyyy')#>

				<!--- EXTENSION ACCORDING TO FLIGHT INFORMATION --->
				<cfif newenddate GT get_history.end_date AND newenddate GT now()>
					<tr>
						<td>#get_students.businessname#</td>
						<td>#get_history.firstname#  #get_history.lastname# (###get_history.studentid#)</td>
						<td>#DateFormat(get_history.new_date, 'mm/dd/yyyy')#</td>
						<td>#DateFormat(get_history.end_date, 'mm/dd/yyyy')#</td>
					</tr>
					<!--- INSURANCE EXPIRED --->
					<cfif get_history.end_date LT now()>
						<cfset ext_startdate = #DateFormat(now(),'mm/dd/yyyy')#>
						<cfset totalnew = totalnew + 1>
						<tr><td colspan="4"><font color="red">*** INSURANCE EXPIRED ***</font>&nbsp;<font color="0000CC">NEW TRANSACTION - Flight date #DateFormat(newenddate, 'mm/dd/yyyy')# &nbsp; Insurance: Start: #DateFormat(ext_startdate,'mm/dd/yyyy')# &nbsp; End: #DateFormat(newenddate,'mm/dd/yyyy')#</font></td></tr>
						<cfquery name="insert_extension" datasource="MySql">
							INSERT INTO smg_insurance
								(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
							VALUES
								('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
								#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(ext_startdate)#,
								#CreateODBCDate(newenddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'new');	
						</cfquery>						
					<cfelse>
						<cfset totalextension = totalextension + 1>
						<cfset ext_startdate = #DateFormat(DateAdd('y', 1, get_history.end_date), 'mm/dd/yyyy')#>
						<tr><td align="right" colspan="4"><font color="0000CC">Extension flight departure date #DateFormat(newenddate, 'mm/dd/yyyy')#</font></td><td></td>
						<cfquery name="insert_extension" datasource="MySql">
							INSERT INTO smg_insurance
								(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
							VALUES
								('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
								#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(ext_startdate)#,
								#CreateODBCDate(newenddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'extension');	
						</cfquery>
					</cfif>
				
				<!--- EARLY RETURN ACCORDING TO FLIGHT INFORMATION --->
				<cfelseif newenddate LT get_history.end_date AND #Abs(DateDiff('d', get_history.end_date, newenddate))# GT '5' AND get_history.end_date GT now()>
					<cfset totalearly = totalearly + 1>
					<tr>
						<td>#get_students.businessname#</td>
						<td>#get_history.firstname#  #get_history.lastname# (###get_history.studentid#)</td>
						<td>#DateFormat(get_history.new_date, 'mm/dd/yyyy')#</td>
						<td>#DateFormat(get_history.end_date, 'mm/dd/yyyy')#</td>
					</tr>
					<tr>
						<td align="right" colspan="4">
							<font color="0000CC">Early Return flight departure date #DateFormat(newenddate, 'mm/dd/yyyy')#</font>
							<cfif newenddate LT now()>
								<cfset newenddate = now()> - New Early Return on File #DateFormat(newenddate, 'mm/dd/yyyy')#
							</cfif>
						</td>
					</tr>
					<cfquery name="insert_early_return" datasource="MySql">
						INSERT INTO smg_insurance
							(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
						VALUES
							('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
							#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(newenddate)#,
							#CreateODBCDate(get_history.end_date)#, '#get_history.org_code#', '#get_history.policy_code#', 'early return');	
					</cfquery>
				</cfif>
		
		
		
		
		<!--- CREATE EXTENSION FILE USING A PRE-DEFINED DATE IF THERE IS NO FLIGHT INFORMATION ON FILE --->
		<cfelseif IsDefined('form.manual') AND form.extensiondate GT get_history.end_date>
				<tr>
					<td>#get_students.businessname#</td>
					<td>#get_history.firstname#  #get_history.lastname# (###get_history.studentid#)</td>
					<td>#DateFormat(get_history.new_date, 'mm/dd/yyyy')#</td>
					<td>#DateFormat(get_history.end_date, 'mm/dd/yyyy')#</td>
				</tr>
				
				<!--- INSURANCE EXPIRED --->
				<cfif get_history.end_date LT now()>
					<cfset ext_startdate = #DateFormat(now(),'mm/dd/yyyy')#>
					<cfset totalnew = totalnew + 1>
					<tr><td colspan="4"><font color="red">*** INSURANCE EXPIRED ***</font>&nbsp;<font color="0000CC">NEW TRANSACTION - Start Date: #DateFormat(ext_startdate,'mm/dd/yyyy')# &nbsp; End Date: #DateFormat(newenddate,'mm/dd/yyyy')#</font></td></tr>
					<cfquery name="insert_extension" datasource="MySql">
						INSERT INTO smg_insurance
							(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
						VALUES
							('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
							#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(ext_startdate)#,
							#CreateODBCDate(newenddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'new');	
					</cfquery>
				<cfelse>
					<cfset ext_startdate = #DateFormat(DateAdd('y', 1, get_history.end_date), 'mm/dd/yyyy')#>
					<cfset newenddate = #DateFormat(form.extensiondate, 'mm/dd/yyyy')#>
					<cfset totalmanualext = totalmanualext + 1>
					<tr><td align="right" colspan="4"><font color="0000CC">Pre defined extension date #DateFormat(newenddate, 'mm/dd/yyyy')#</font></td><td></td>
					<cfquery name="insert_extension" datasource="MySql">
						INSERT INTO smg_insurance
							(studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, org_code, policy_code, transtype)
						VALUES
							('#get_history.studentid#', '#get_history.firstname#', '#get_history.lastname#', '#get_history.sex#', 
							#CreateODBCDate(get_history.dob)#, '#get_history.country_code#', #CreateODBCDate(ext_startdate)#,
							#CreateODBCDate(newenddate)#, '#get_history.org_code#', '#get_history.policy_code#', 'extension');	
					</cfquery>
				</cfif>
		</cfif>
</cfloop>

	<cfset total = totalextension + totalearly + totalnew>
	<tr><td colspan="2">Total of students </td><td colspan="2">#get_students.recordcount#</td></tr>
	<tr><td colspan="2">Total of new transactions: </td><td colspan="2">#totalnew#</td></tr>
	<tr><td colspan="2">Total of extensions: </td><td colspan="2">#totalextension#</td></tr>
	<tr><td colspan="2">Total of early returns: </td><td colspan="2">#totalearly#</td></tr>
	<tr><td colspan="2">Total of students with new flight Information this time: </td><td colspan="2">#total#</td></tr>
	<tr><td colspan="2">Total of manually extended: </td><td colspan="2">#totalmanualext#</td></tr>
</table>
</cfoutput>

</body>
</html>