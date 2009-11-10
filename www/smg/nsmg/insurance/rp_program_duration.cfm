<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Program Duration</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE <cfloop list=#form.programid# index='prog'>
			p.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>

<!--- get agents --->
<cfquery name="get_agents" datasource="MySQL">
	SELECT userid, businessname
	FROM smg_users
	INNER JOIN smg_students ON smg_students.intrep = smg_users.userid
	WHERE smg_students.active = '1'
		 AND smg_users.insurance_typeid > '1'
		<cfif form.agentid is 0><cfelse>AND userid = '#form.agentid#'</cfif>
	GROUP BY businessname
	ORDER BY businessname
</cfquery>

<cfoutput>
<table width='95%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Program Duration</span>
</table>
<br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop></td></tr>
</table><br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">International Agent</th> <th width="25%">Total Assigned</th></tr>
</table><br>

<cfloop query="get_agents">
	<!--- Get Students By Agent --->
	<Cfquery name="get_students" datasource="MySQL">
	SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.dateplaced, s.termination_date,
			u.businessname, u.insurance_typeid,
			p.type, 
			sch.year_ends 
	from smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid 
	INNER JOIN smg_school_dates sch ON (sch.schoolid = s.schoolid AND sch.seasonid = p.seasonid)
	WHERE s.canceldate IS NULL
		AND s.intrep = '#get_agents.userid#'
		AND u.insurance_typeid > '1'
	 	AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
		   	<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		   </cfloop>)
	ORDER BY s.studentid
	</cfquery>  <!--- PS: PROGRAM TYPE = 3 - 1ST SEMESTER --->
	
	<cfif get_students.recordcount NEQ 0>
		<table width='95%' cellpadding=4 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%">#get_agents.businessname# &nbsp; &nbsp; &nbsp; Total of #get_students.recordcount# student(s)</th><td width="25%" align="center"><!--- #get_students.recordcount# ---></td></tr>
		</table>
		<table width='95%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
			<tr><td width="6%"><b>ID</b></th>
				<td width="28%"><b>Student</b></td>
				<td width="14%"><b>Placement Date</b></td>
				<td width="14%"><b>Arrival Date</b></td>
				<td width="24%"><b>Leaving USA Date</b></td>
				<td width="14%" align="center"><b>Prog. Duration (weeks)</b></td>
			</tr>	
			<cfloop query="get_students">			
				<cfquery name="get_arrival" datasource="MySql">
					SELECT DISTINCT dep_date
					FROM smg_flight_info
					WHERE studentid = #get_students.studentid#
						AND flight_type = 'arrival'
				</cfquery>
				<cfquery name="get_departure" datasource="MySql">
					SELECT DISTINCT dep_date
					FROM smg_flight_info
					WHERE studentid = #get_students.studentid#
						AND flight_type = 'departure'
				</cfquery>
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td>#DateFormat(dateplaced, 'mm/dd/yyyy')#</td>
					<td><cfif get_arrival.dep_date EQ ''><font color="FF0000">Arrival missing</font><cfelse>#DateFormat(get_arrival.dep_date, 'mm/dd/yyyy')#</cfif></td>
					<td>
						<cfif get_departure.dep_date EQ '' AND termination_date EQ ''>
							<font color="FF0000">Departure flight / Termination missing</font>
							<cfset leaving_date = ''>
						<cfelseif get_departure.dep_date NEQ ''>
							#DateFormat(get_departure.dep_date, 'mm/dd/yyyy')# &nbsp; Flight Info.
							<cfset leaving_date = #get_departure.dep_date#>
						<cfelseif termination_date NEQ ''>
							#DateFormat(termination_date, 'mm/dd/yyyy')# &nbsp; Termination Date
							<cfset leaving_date = #termination_date#>
						</cfif>
					</td>
					<td align="center">
						<cfif get_arrival.dep_date NEQ '' AND leaving_date NEQ ''>
						#DateDiff('ww',get_arrival.dep_date, leaving_date)#
						</cfif>
					</td>
				</tr>
			</cfloop>
		</table><br>
	</cfif>
</cfloop>

</cfoutput>

</body>
</html>
