<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Students End of the Program Dates</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	programid, programname, type, c.companyshort
	FROM smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	INNER JOIN smg_companies c ON smg_programs.companyid = c.companyid
	WHERE <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		  </cfloop>
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT s.studentid, s.firstname, s.familylastname, u.businessname
	FROM smg_students s
	INNER JOIN smg_users u ON u.userid = intrep
	WHERE s.active = '1' 
		<cfif IsDefined('form.caremed')>AND u.insurance_typeid > '1' </cfif>
		AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
			   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		   </cfloop>)
</cfquery>

<cfoutput>
<table width='95%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Students Termination Date</span>
</table><br>

<table width='95%' cellpadding=4 cellspacing="0" align="center" bgcolor="FFFFFF" frame="box">
	<tr><td class="style3"><b>Program(s) :</b><br> 
	<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop>
	Total of Students: #get_total_students.recordcount#</td></tr>
</table><br>

	<Cfquery name="get_students" datasource="MySQL">
		SELECT s.studentid, s.firstname, s.familylastname, s.termination_date,
			   u.businessname, 
			   p.type,
			   dates.semester_ends, dates.year_ends,
			   u.insurance_typeid
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.intrep
		INNER JOIN smg_programs p ON p.programid = s.programid
		LEFT JOIN smg_schools school ON school.schoolid = s.schoolid
		LEFT JOIN smg_school_dates dates ON (dates.seasonid = p.seasonid AND dates.schoolid = school.schoolid)
		WHERE 	s.active = '1' 
				AND s.regionassigned = '#get_region.regionid#' 
				<cfif IsDefined('form.caremed')>AND u.insurance_typeid > '1' </cfif>
				AND (<cfloop list=#form.programid# index='prog'>
						s.programid = #prog# 
					   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
					</cfloop>)
		ORDER BY s.studentid
	</cfquery>
	
	<cfif #get_students.recordcount# NEQ 0>
			<table width='95%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr><td width="8%"><b>ID</b></th>
					<td width="28%"><b>Sudent</b></td>
					<td width="28%"><b>Intl. Agent</b></td>
					<td width="22%"><b>School End Date</b></td>
					<td width="14%"><b>Return Date</b></td>
				</tr>	
				<cfloop query="get_students">
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
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td>#businessname#</td>
					<!--- program type 3 = ayp 1st semester --->
					<td><cfif get_students.type is '3'>#DateFormat(semester_ends, 'mm/dd/yyyy')#<cfelse>#DateFormat(year_ends, 'mm/dd/yyyy')#</cfif></td>
					<cfif termination_date EQ '' AND get_flight.recordcount EQ '0'>
						<td></td>
					<cfelseif termination_date NEQ ''>
						<td>#DateFormat(termination_date, 'mm/dd/yyyy')# - Termination</td>
					<cfelseif get_flight.dep_date NEQ ''>
						<td>#DateFormat(get_flight.dep_date, 'mm/dd/yyyy')# - Flight</td>
					</cfif>
				</tr>							
				</cfloop>	
			</table><br>
	</cfif>

</cfoutput>

</body>
</html>
