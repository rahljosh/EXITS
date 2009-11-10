<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Total Placements</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>
<body>

<cfif not IsDefined('form.programid')>
	<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
	<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
	Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
	<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
	</td></tr>
	</table>
	<cfabort>
</cfif>

<cfif NOT IsDefined('form.active')>
	<cfset form.active = 1>
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	p.programid, p.programname,
		c.companyshort
	FROM 	smg_programs p
	LEFT JOIN smg_program_type ON p.type = programtypeid
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE 	(<cfloop list="#form.programid#" index="prog">
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	ORDER BY c.companyshort, p.programname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE smg_students.hostid != '0'
		AND host_fam_approved <= '4'
		<cfif form.active EQ 0> <!--- inactive --->
			AND smg_students.active = '0'
		<cfelseif form.active EQ 1> <!--- active --->
			AND smg_students.active = '1'
		<cfelseif form.active EQ 2> <!--- canceled --->
			AND smg_students.canceldate IS NOT NULL
		</cfif>
		AND (<cfloop list="#form.programid#" index="prog">
			smg_students.programid = #prog# 
		<cfif prog NEQ #ListLast(form.programid)#>or</cfif>
		</cfloop> )
</cfquery>

<cfoutput>

<table width="50%" cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - TOTAL Placements</span>
</table><br>

<table width="50%" cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="get_program"><b>#companyshort# -  #programname# &nbsp; (###ProgramID#)</b><br></cfloop>
	Total of <cfif form.active EQ 0>inactive<cfelseif form.active EQ 1>active<cfelseif form.active EQ 2>canceled</cfif> Students <b>placed</b> in program: #get_total_students.recordcount#
	</td></tr>
</table><br>

<!--- table header --->
<table width="50%" cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr><th width="50%">Total of Placements</th><th width="50%" align="center">Total of Reps</th></tr>

	<cfquery name="total_placed" datasource="MySQL">
		SELECT DISTINCT count( studentid ) AS total_placed
		FROM smg_students
		LEFT JOIN smg_users u ON placerepid = userid
		WHERE smg_students.hostid != '0'
			AND host_fam_approved <= '4'
			<cfif form.active EQ 0> <!--- inactive --->
				AND smg_students.active = '0'
			<cfelseif form.active EQ 1> <!--- active --->
				AND smg_students.active = '1'
			<cfelseif form.active EQ 2> <!--- canceled --->
				AND smg_students.canceldate IS NOT NULL
			</cfif>
			AND (<cfloop list="#form.programid#" index="prog">
				smg_students.programid = #prog# 
			<cfif prog NEQ #ListLast(form.programid)#>or</cfif>
			</cfloop> )
		GROUP BY placerepid
		ORDER BY total_placed
	</cfquery>

	<cfloop query="total_placed">
		
		<cfset cur_placed = total_placed.total_placed>
		
		<cfset calc_total_reps = 0>
	 
		<cfquery name="total_per_reps" datasource="MySQL">
			SELECT DISTINCT count( studentid ) AS total_placed, userid
			FROM smg_students
			LEFT JOIN smg_users u ON placerepid = userid
			WHERE smg_students.hostid != '0'
				AND host_fam_approved <= '4'
				<cfif form.active EQ 0> <!--- inactive --->
					AND smg_students.active = '0'
				<cfelseif form.active EQ 1> <!--- active --->
					AND smg_students.active = '1'
				<cfelseif form.active EQ 2> <!--- canceled --->
					AND smg_students.canceldate IS NOT NULL
				</cfif>
				AND (<cfloop list="#form.programid#" index="prog">
					smg_students.programid = #prog# 
				<cfif prog NEQ #ListLast(form.programid)#>or</cfif>
				</cfloop> )
			GROUP BY placerepid
			ORDER BY total_placed
		</cfquery>
		
		<cfloop query="total_per_reps">
			<cfif total_per_reps.total_placed EQ cur_placed>
				<cfset calc_total_reps = calc_total_reps + 1>
			</cfif>	
		</cfloop>
		<tr><td align="center">#total_placed.total_placed#</td><td align="center">#calc_total_reps#</td></tr>
	</cfloop>
	
</table><br>

</cfoutput>

</body>
</html>