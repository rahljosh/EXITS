<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../reports/reports.css" type="text/css">
<title>Flight Arrival x Host Family CBC</title>
</head>

<body>

<cfsetting requestTimeOut = "300">

<cfif NOT IsDefined('form.programid') OR NOT IsDefined('form.regionid')>
	You must select a program and/or a Region in order to run the report.
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

<!--- get company region --->
<cfquery name="get_regions" datasource="MySQL">
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
<table width='90%' cellpadding=3 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Flight Arrival x Host Family CBC (No Relocations)</span></td></tr>
</table><br>
<table width='90%' cellpadding=3 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
</table>

<cfset break = '0'>
<cfset region_header = '0'>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>
	<cfset current_regionname = get_regions.regionname>
	
	<cfquery name="get_students_region" datasource="MySql">
		SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.placerepid, s.date_host_fam_approved, s.dateplaced, s.hostid,
			u.firstname as repfirstname, u.lastname as replastname, u.userid,
			h.familylastname as hostlastname
		FROM smg_students s
		INNER JOIN smg_users u ON u.userid = s.placerepid
		INNER JOIN smg_hosts h ON h.hostid = s.hostid
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

		<cfloop query="get_students_region">			
			<cfquery name="get_cbc" datasource="MySql">
				SELECT cbc_type, date_authorized, date_sent
				FROM smg_hosts_cbc
				WHERE hostid = '#hostid#'
				ORDER BY date_authorized
			</cfquery>
			<cfquery name="get_arrival" datasource="MySql">
                SELECT 
                    dep_date
                FROM 
                    smg_flight_info
                WHERE 
                    studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_students_region.studentid#">
                AND 
                    flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                AND
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                ORDER BY 
                    dep_date DESC
			</cfquery>		
			<cfquery name="get_relocation" datasource="MySql">
				SELECT hist.dateofchange, hist.isRelocation
				FROM smg_hosthistory hist
				WHERE hist.studentid = '#studentid#' 
					AND hist.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			</cfquery>
			
			<cfif get_arrival.dep_date LT get_cbc.date_authorized AND get_relocation.recordcount EQ '0'>					
				
				<!--- INCLUDE REGION HEADER --->
				<cfif region_header NEQ current_region><br>
					<table width='90%' cellpadding=3 cellspacing="0" align="center" frame="below">	
						<tr><th width="85%" bgcolor="##CCCCCC">Region: &nbsp; #current_regionname#</th>
							<td width="15%" align="center" bgcolor="CCCCCC"><b></b></td>
						</tr>
					</table>
					<table width='90%' frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
					<tr>
						<td width="20%"><b>Placement Rep:</b></td>
						<td width="20%"><b>Student</b></th>
						<td width="20%"><b>Arrival</b></td>
						<td width="20%"><b>Host Family</b></td>
						<td width="20%"><b>CBC Date</b></td>
					</tr>	
				</cfif>
				
				<cfif break NEQ #get_students_region.userid#>
					<tr><td colspan="6">&nbsp;</td></tr>
				</cfif>
				<cfset count = count + 1>
				<cfset break = '#get_students_region.userid#'>	
				<cfset region_header = current_region>
				<tr bgcolor="#iif(count MOD 2 ,DE("ededed") ,DE("white") )#">			
					<td><cfif repfirstname EQ '' and replastname EQ ''><font color="red">Missing or Unknown</font><cfelse><u>#repfirstname# #replastname# (###userid#)</u></cfif></td>
					<td>#firstname# #familylastname# (###studentid#)</td>
					<td><cfif get_arrival.dep_date NEQ ''>#DateFormat(get_arrival.dep_date, 'mm/dd/yyyy')#<cfelse>n/a</cfif></td>
					<td>#hostlastname# (###hostid#)</td>
					<td><cfloop query="get_cbc">
							#cbc_type# - #DateFormat(date_authorized, 'mm/dd/yyyy')#<br />
						</cfloop>
					</td>
				</tr>
			</cfif>
		</cfloop>
		<cfif region_header NEQ current_region></table></cfif>	
					
	</cfif>  <!--- get_students_region.recordcount NEQ 0 ---> 

</cfloop> <!--- cfloop query="get_regions" --->

</cfoutput>

</body>
</html>