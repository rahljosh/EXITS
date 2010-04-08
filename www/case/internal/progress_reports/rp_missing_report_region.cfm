<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Missing Progress Reports by Region</title>
<link rel="stylesheet" href="../reports.css" type="text/css">
</head>

<body>

<cfsetting requesttimeout="500">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
	SELECT	*
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE <cfloop list="#form.programid#" index="prog">
			p.programid = #prog# 
			<cfif prog IS #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>

<cfquery name="get_region" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid NEQ 0>AND regionid = '#form.regionid#'</cfif>
	ORDER BY regionname
</cfquery>

<cfoutput>

<table width="90%" cellpadding="2" cellspacing="0" align="center" frame="box">
	<th><span class="application_section_header">#companyshort.companyshort# - Missing #MonthAsString(form.rmonth)# Progress Reports</span></th>
	<tr>
		<td><b>Program(s) :</b><br> 
			<cfloop query="get_program"><i>#get_program.companyshort# &nbsp; #get_program.programname#</i><br></cfloop>
		</td>
	</tr>
</table><br>

<!--- REPORTS PER PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
	
	10 MONTH PRIVATE - PROGRAM END DATE 06/31
	12 MONTH PRIVATE - PROGRAM END DATE 12/31
	1ST SEMESTER PRIVATE - PROGRAM END DATE 06/31
	2ND SEMESTER PRIVATE - PROGRAM END DATE 01/15
	USE #DateFormat(current_students_status.enddate, 'mm')# EQ '12'
---->

<cfset form.prtype1 = "10,12,2,4,6"> <!--- 10 month ---->
<cfset form.prtype2 = "2,4,8,10,12"> <!--- 12 month ---->
<cfset form.prtype3 = "10,12,2"> <!--- 1st semester ---->
<cfset form.prtype4 = "2,4,6"> <!--- 2nd semester ---->
<cfset form.prtype5 = "">

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>

	<cfquery name="get_students" datasource="caseusa">
		SELECT s.studentid, s.firstname, s.familylastname, s.active, 
			p.type, p.programname, p.startdate, p.enddate,
			u.userid, u.firstname as userfirst, u.lastname
		FROM smg_students s
		INNER JOIN smg_programs p ON p.programid = s.programid
		INNER JOIN smg_users u ON u.userid = s.arearepid
		WHERE s.active = '1'
			AND s.hostid != '0'
			AND s.regionassigned = '#current_region#'
			AND (<cfloop list="#form.programid#" index="prog">
					s.programid = '#prog#' <cfif prog NEQ #ListLast(form.programid)#>or</cfif>
				</cfloop>)
		ORDER BY u.lastname, s.familylastname
	</cfquery>

	<cfif get_students.recordcount>
		<table width="90%" cellpadding="2" cellspacing="0" align="center" frame="box">
			<tr><th colspan="4">#get_region.regionname#</th></tr>
			<tr>
				<td width="25%"><b>Super Rep.</b></td>
				<td width="40%"><b>Student</b></td>
				<td width="20%"><b>Program</b></td>
				<td width="15%"><b>Missing Report</b></td>
			</tr>			
			<cfloop query="get_students">		

				<cfquery name="month_report" datasource="caseusa">
					SELECT DISTINCT stuid 
					FROM smg_prquestion_details 
					WHERE stuid = '#studentid#'
						AND month_of_report = '#form.rmonth#' 
				</cfquery>
	
				<cfif month_report.recordcount EQ 0>  
				
					<!--- private high school type = 5 --->
					<cfif type EQ 5 AND #DateFormat(enddate, 'mm')# EQ 06 AND DateDiff("m", startdate, enddate) EQ 11>
						<cfset prtype5 = "10,12,2,4,6"><!--- 10 month ---->
					<cfelseif type EQ 5 AND #DateFormat(enddate, 'mm')# EQ 06 AND DateDiff("m", startdate, enddate) EQ 5>
						<cfset prtype5 = "2,4,6"><!--- 2nd semester ---->
					<cfelseif type EQ 5 AND #DateFormat(enddate, 'mm')# EQ 12>
						<cfset prtype5 = "2,4,8,10,12"> <!--- 12 month ----> 
					<cfelseif type EQ 5 AND #DateFormat(enddate, 'mm')# EQ 01>
						<cfset prtype5 = "10,12,2"> <!--- 1st semester ---->
					</cfif>
					<tr>
						<td>#userfirst# #lastname# (###userid#)</td>
						<td>#firstname# #familylastname# (###studentid#)</td>
						<td>#programname#</td>
						<td>
							<cfif ListFind(form["prtype" & type], form.rmonth)>
								#MonthAsString(form.rmonth)#
							<cfelse>
								n/a
							</cfif> 
						</td>
					</tr>
				</cfif>
			</cfloop>
		</table><br />
	</cfif>
	
</cfloop>

<table width="90%" cellpadding="2" cellspacing="0" align="center" frame="box">
	<th colspan="2">Reports Per Program</th>
	<tr>
		<td width="50%">
			10 Month -> October - December - February - April - June  <br />
			12 Month -> February - April - August - October - December
		</td>
		<td width="50%">
			1st Semester -> October - December - February <br />
			2nd Semester -> February - April - June
		</td>
	</tr>
</table><br>

</cfoutput>

</body>
</html>

<!--- IT TAKES TOO LONG --->
<!---
<cfquery name="get_students" datasource="caseusa">
	SELECT DISTINCT s.studentid, s.firstname, s.familylastname
	FROM smg_students s
	WHERE s.active = '1'
		AND s.regionassigned = '#current_region#'
		AND <cfloop list="#form.programid#" index="prog">
				s.programid = '#prog#' <cfif prog IS #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>
		AND s.studentid NOT IN ( SELECT prquest.stuid FROM smg_document_tracking rp INNER JOIN smg_prquestion_details prquest ON prquest.report_number = rp.report_number WHERE prquest.stuid = s.studentid AND rp.month_of_report = '#form.rmonth#')
</cfquery>
--->
 
<!--- ALL MONTHS --->
<!---
	<cfset type1 = "10,12,2,4,6">
	<cfset type2 = "2,4,8,10,12">
	<cfset type3 = "10,12,2">
	<cfset type4 = "2,4,6">

	<!--- ALL MONTHS --->
	<cfloop list="#form["prtype" & type]#" index="i">
		<cfquery name="month_#i#" datasource="caseusa">
			SELECT DISTINCT stuid 
			FROM smg_prquestion_details 
			WHERE stuid = '#studentid#'
				AND month_of_report = '#i#' 
		</cfquery>
		<cfif #Evaluate("month_"& i &".recordcount")# EQ 0>
			#i# &nbsp; &nbsp;
		</cfif>
	</cfloop>
--->