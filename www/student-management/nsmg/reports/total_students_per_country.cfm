<link rel="stylesheet" href="reports.css" type="text/css">

<cfif NOT IsDefined('form.programid')>
	Please select a program in order to run this report.
	<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	programid, programname, companyshort
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	LEFT JOIN smg_companies c ON c.companyid = smg_programs.companyid
	WHERE 	
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
</cfquery>

<!--- get total students in each program according to the company --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT 	s.studentid
	FROM smg_students s
	WHERE 
    	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
		<cfif NOT IsDefined('form.all')>
			AND s.active = '1'
		</cfif>
		<cfif form.status EQ 1>
			AND hostid != '0'
		<cfelseif form.status EQ 2>
			AND hostid = '0'
		</cfif>
        AND	
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
        AND 
        	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
</cfquery>

<cfoutput>
<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Total of Students Per Country</span>
</table><br>

<table width='650' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#programID#)</b><br></cfloop>
	Total of students &nbsp; <cfif form.status is 1><b>placed</b><cfelseif form.status is 2><b>unplaced</b></cfif> in program <i><u>#get_total_students.recordcount#</u></i>
	<br />*<cfif NOT IsDefined('form.all')> Only Active Students <cfelse> Includes All Students (active, inactive and canceled).</cfif> 
	</td></tr>
</table><br />

	<!--- Get countries according to the program --->
	<cfquery name="get_country" datasource="MySQL">
		SELECT 	count(studentid) as total_students,
				countryname
		FROM 	smg_students
		LEFT JOIN smg_countrylist c ON countryresident = c.countryid
		WHERE 	
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND    
            active = '1' 
		<cfif form.countryid NEQ 0>AND countryresident = '#form.countryid#'</cfif>
		<cfif form.status is 1>
			AND hostid <> '0'
		<cfelseif form.status is 2>
			AND hostid = '0'
		</cfif>
        AND	
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
		GROUP BY countryname
	</cfquery>

	<!--- 0 students will skip the table --->
	<cfif get_country.recordcount NEQ 0>	
		<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr>
            	<th width="75%">Country</th>
                <th width="25%">Total</th>
            </tr>
			<!--- Country Loop --->
			<cfloop query="get_country">
				<tr bgcolor="#iif(get_country.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td width="75%">#countryname#</td>
					<td width="25%" align="center">#total_students#</td>
                </tr>
          	</cfloop>
		</table>
		<br><br>	
	</cfif>

</cfoutput>