<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../reports/reports.css" type="text/css">
<title>Flight Arrival x School Acceptance</title>
</head>

<body>

<cfsetting requestTimeOut = "300">

<cfif NOT IsDefined('form.programid')>
	You must select a program in order to run the report.
	<!--- <cfinclude template="../forms/error_message.cfm"> --->
	<cfabort>
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog EQ #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfoutput>
<table width="670" cellpadding=3 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Students with Arrival Information and  Missing School Acceptance (Place Management)</span></td></tr>
</table><br>

<table width="670" cellpadding=3 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td>PS: This report lists STUDENTS with flight arrival information that do not have school acceptance letter.</td></tr>
</table><br>

<cfset break = '0'>

	<cfquery name="get_students" datasource="MySql">
		SELECT DISTINCT s.studentid, s.countryresident, s.firstname, s.familylastname, s.sex, s.programid, s.placerepid,
			  s.dateplaced, s.hostid, s.doc_school_accept_date,
			  u.firstname as repfirstname, u.lastname as replastname, u.userid,
			  flight.dep_date
		FROM smg_students s
		LEFT JOIN smg_users U on u.userid = s.placerepid
		INNER JOIN smg_flight_info flight ON flight.studentid = s.studentid
		WHERE s.active = '1' 
			AND flight_type = 'arrival'
			AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )	
		GROUP BY s.studentid
		ORDER BY dep_date, repfirstname
	</cfquery>
	
	<cfset count = '0'> 
	<table width="670" frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
	<tr>
		<td width="25%"><b>Placement Rep:</b></td>
		<td width="30%"><b>Student</b></th>
		<td width="15%"><b>Placement Date</b></td>
		<td width="15%"><b>Arrival Date</b></td>
		<td width="15%"><b>School Acceptance</b></td>
	</tr>	
	<cfloop query="get_students">			
		<cfif doc_school_accept_date EQ ''>
			<cfset count = count + 1>
			<tr bgcolor="#iif(count MOD 2 ,DE("ededed") ,DE("white") )#">			
				<td><cfif hostid EQ 0>Unplaced <cfelseif repfirstname EQ '' and replastname EQ ''><font color="red">Missing or Unknown</font><cfelse><u>#repfirstname# #replastname# (###userid#)</u></cfif></td>
				<td>#firstname# #familylastname# (###studentid#)</td>
				<td><cfif hostid EQ 0>Unplaced<cfelse>#DateFormat(dateplaced, 'mm/dd/yyyy')#</cfif></td>
				<td><cfif dep_date NEQ ''>#DateFormat(dep_date, 'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
				<td><cfif doc_school_accept_date NEQ ''>#DateFormat(doc_school_accept_date, 'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
			</tr>
		</cfif>	
	</cfloop>
	</table><br>
	
<br>
</cfoutput>

</body>
</html>