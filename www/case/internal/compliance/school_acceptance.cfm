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

<cfif NOT IsDefined('form.programid') OR NOT IsDefined('form.regionid')>
	You must select a program and/or a Region in order to run the report.
	<!--- <cfinclude template="../forms/error_message.cfm"> --->
	<cfabort>
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
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

<!--- get company region --->
<cfquery name="get_regions" datasource="caseusa">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE company = '#client.companyid#' 
		<cfif form.regionid NEQ '0'>
			AND (<cfloop list="#form.regionid#" index='reg'>
					regionid = #reg# 
					<cfif reg EQ #ListLast(form.regionid)#><Cfelse>or</cfif>
					</cfloop> )
		</cfif>
	ORDER BY regionname
</cfquery> 

<cfoutput>
<table width='100%' cellpadding=3 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Flight Arrival x School Acceptance</span></td></tr>
</table><br>

<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td>PS: It shows all students that are missing acceptance letter checked by the compliance person 
			<b>OR</b> 
			students that acceptance letter was received after the arrival date.
		</td>
	</tr>
</table><br>

<!--- table header --->
<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
	<tr><td width="85%">Placing Representative</td><td width="15%" align="center"></td></tr>
</table><br>

<cfset break = '0'>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>

	<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="##CCCCCC">Region: &nbsp; #get_regions.regionname#</th>
			<td width="15%" align="center" bgcolor="CCCCCC"><b></b></td>
		</tr>
	</table><br>
	<cfquery name="get_students_region" datasource="caseusa">
		SELECT DISTINCT s.studentid, s.countryresident, s.firstname, s.familylastname, s.sex, s.programid, s.placerepid,
			  s.dateplaced, s.hostid as stuhost,
			  c.school_acceptance,
			  u.firstname as repfirstname, u.lastname as replastname, u.userid
		FROM smg_students s
		LEFT JOIN smg_compliance c ON s.studentid = c.studentid
		INNER JOIN smg_users U on u.userid = s.placerepid
		WHERE s.active = '1' 
			AND s.regionassigned = '#current_region#' 
			AND s.hostid != '0'
			AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )	
		ORDER BY repfirstname
	</cfquery>
	
	<cfif get_students_region.recordcount NEQ 0>
			<cfset count = '0'> 
			<table width='100%' frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
			<tr>
				<td width="20%"><b>Placement Rep:</b></td>
				<td width="20%"><b>Student</b></th>
				<td width="25%"><b>Original Placement Date</b></td>
				<td width="10%"><b>Relocated</b></td>
				<td width="10%"><b>Arrival Date</b></td>
				<td width="15%"><b>First School Acceptance</b></td>
			</tr>	
			<cfloop query="get_students_region">			
			<cfquery name="get_arrival" datasource="caseusa">
				SELECT DISTINCT dep_date
				FROM smg_flight_info
				WHERE studentid = '#get_students_region.studentid#'
					AND flight_type = 'arrival'
				ORDER BY dep_date DESC
			</cfquery>
			<cfquery name="first_acceptance" datasource="caseusa">
				SELECT hostid, school_acceptance
				FROM smg_compliance
				WHERE studentid = '#get_students_region.studentid#'
			</cfquery>
			<cfquery name="get_place_date" datasource="caseusa">
				SELECT hist.dateofchange, hist.relocation
				FROM smg_hosthistory hist
				WHERE hist.studentid = '#get_students_region.studentid#' 
					AND hist.hostid = '#first_acceptance.hostid#' 
				GROUP BY hist.studentid 
			</cfquery>
			<cfquery name="get_relocation" datasource="caseusa">
				SELECT hist.dateofchange, hist.relocation
				FROM smg_hosthistory hist
				WHERE hist.studentid = '#get_students_region.studentid#' 
					AND hist.hostid = '#first_acceptance.hostid#'
					AND hist.relocation = 'yes'
				GROUP BY hist.studentid 
			</cfquery>
			<cfif first_acceptance.school_acceptance GT get_arrival.dep_date OR first_acceptance.school_acceptance EQ ''>					
				<cfif break NEQ '#get_students_region.userid#'>
				<tr><td colspan="6">&nbsp;</td></tr>
				</cfif>
				<cfset count = count + 1>
				<tr bgcolor="#iif(count MOD 2 ,DE("ededed") ,DE("white") )#">			
					<td><cfif repfirstname EQ '' and replastname EQ ''><font color="red">Missing or Unknown</font><cfelse><u>#repfirstname# #replastname# (###userid#)</u></cfif></td>
					<td>#firstname# #familylastname# (###studentid#)</td>
					<td><cfif get_place_date.dateofchange NEQ ''>#DateFormat(get_place_date.dateofchange, 'mm/dd/yyyy')#<cfelse>Not Available - Current #DateFormat(dateplaced, 'mm/dd/yyyy')#</cfif></td>
					<td><cfif get_relocation.relocation EQ 'yes'>yes<cfelse>no</cfif></td>
					<td><cfif get_arrival.dep_date NEQ ''>#DateFormat(get_arrival.dep_date, 'mm/dd/yyyy')#<cfelse>No flight info</cfif></td>
					<td><cfif first_acceptance.school_acceptance NEQ ''>#DateFormat(first_acceptance.school_acceptance, 'mm/dd/yyyy')#<cfelse>No school acceptance date</cfif></td>
				</tr>
				<cfset break = '#get_students_region.userid#'>				
			</cfif>
			</cfloop>
			<!--- <tr><td colspan="7">* Not current host family.</td></tr>	 --->
		</table><br>				
	</cfif>  <!--- get_students_region.recordcount NEQ 0 ---> 
	
</cfloop> <!--- cfloop query="get_regions" --->

<br>
</cfoutput>

</body>
</html>