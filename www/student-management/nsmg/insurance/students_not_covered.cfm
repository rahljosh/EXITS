<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../reports/reports.css" type="text/css">
<title>Students not covered</title>
</head>

<body>

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

<cfoutput>
<table width='95%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Caremed Extensions</span>
</table>
<br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop></td></tr>
</table><br>

<cfset insureddate = '2006/06/30'>

<!--- Get Students By Agent --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.termination_date,
			u.businessname,
			p.type, p.seasonid,
			type.programtypeid,
			u.insurance_typeid,
			sch.year_ends, sch.schoolid,
			c.companyshort
	from smg_students s
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = s.programid
	INNER JOIN smg_program_type type ON p.type = type.programtypeid
	INNER JOIN smg_school_dates sch ON (sch.schoolid = s.schoolid AND sch.seasonid = p.seasonid)
	INNER JOIN smg_companies c ON c.companyid = s.companyid
	WHERE s.active = '1'
		AND u.insurance_typeid > '1'
		<cfif form.agentid is 0><cfelse>AND s.intrep = '#form.agentid#'</cfif>
		AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		   </cfloop>)
	ORDER BY u.businessname, c.companyshort, s.firstname
</cfquery>  <!--- PS: PROGRAM TYPE = 3 - 1ST SEMESTER --->

<cfif get_students.recordcount NEQ 0>
	<table width='95%' frame="box" cellpadding=3 cellspacing="0" align="center">
		<tr><td width="6%"><b>Company</b></td>
			<td width="10%"><b>Agent</b></td>
			<td width="6%"><b>ID</b></th>
			<td width="20%"><b>Student</b></td>
			<td width="14%"><b>Program End Date</b></td>
			<td width="17%"><b>Leaving USA Date</b></td>
			<td width="15%"><b>Last Day Insured</b></td>
			<td width="12%"><b>Extra Insurance</b></td>
		</tr>	
		<cfloop query="get_students">
		<!--- 2nd semester program is on the 2007 season need to get previous school date --->
		<cfif get_students.programtypeid EQ '4'>
			<cfset previous_season = #get_students.seasonid# - 1>
			<cfquery name="get_school_date" datasource="MySql">
				SELECT DISTINCT year_ends
				FROM smg_school_dates
				WHERE schoolid = '#get_students.schoolid#' AND seasonid = '#previous_season#'
			</cfquery>
			<cfset end_date = #get_school_date.year_ends#>
		<cfelse>
			<cfset end_date = #get_students.year_ends#>
		</cfif>
		
		<cfquery name="get_last_insurance" datasource="MySql">
			SELECT max(insuranceid), end_date
			FROM smg_insurance
			WHERE studentid = '#studentid#'
			GROUP BY insuranceid
			ORDER BY insuranceid DESC 
		</cfquery>

		<!--- TERMINATION DATE ON FILE --->
		<cfif termination_date NEQ ''>
			<cfif termination_date GT get_last_insurance.end_date AND termination_date GTE now()>
			<tr>	
				<td>#companyshort#</td>
				<td>#get_students.businessname#</td>
				<td>#studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td><cfif end_date NEQ ''>#DateFormat(end_date, 'mm/dd/yyyy')#<cfelse><font color="FF0000">Missing School End Date</font></cfif></td>
				<td>#DateFormat(termination_date, 'mm/dd/yyyy')# &nbsp; Termination Date</td>
				<td>#DateFormat(get_last_insurance.end_date, 'mm/dd/yyyy')#</td>
				<td></td>
			</tr>					
			</cfif>

		<!--- NO TERMINATION DATE - GET FLIGHT INFO --->	
		<cfelse>					
			<cfquery name="get_flight" datasource="MySql">
				SELECT DISTINCT 
                	dep_date
				FROM 
                	smg_flight_info
				WHERE 
                	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_students.studentid#">
				AND 
                	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
				AND 
                	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                    
			</cfquery>
			<cfif get_flight.dep_date GT get_last_insurance.end_date AND get_flight.dep_date GTE now()>
			<tr>
				<td>#companyshort#</td>
				<td>#get_students.businessname#</td>
				<td>#studentid#</td>
				<td>#firstname# #familylastname#</td>
				<td><cfif end_date NEQ ''>#DateFormat(end_date, 'mm/dd/yyyy')#<cfelse><font color="FF0000">Missing School End Date</font></cfif></td>
				<td>#DateFormat(get_flight.dep_date, 'mm/dd/yyyy')# &nbsp; Flight Departure</td>
				<td>#DateFormat(get_last_insurance.end_date, 'mm/dd/yyyy')#</td>
				<td></td>
			</tr>
			</cfif>
		</cfif>
		</cfloop>
	</table><br>
</cfif>

</cfoutput>

</body>
</html>