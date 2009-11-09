<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_programs" datasource="MYSQL">
SELECT	DISTINCT 
	p.programid, p.programname, 
	c.companyshort
FROM 	smg_programs p
INNER JOIN smg_companies c ON c.companyid = p.companyid
WHERE 	<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop>
</cfquery>

<!--- get total of students in programs --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT  count(studentid) as total
	FROM	smg_students s
	WHERE 	s.canceldate IS NULL
			AND	( <cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!--- ( active = '1' OR canceldate > '2005-08-03') --->

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Total of Students Per Country</cfoutput></span>
</table>
<br>

<!--- Country list and total of student per Country --->
<cfquery name="get_country" datasource="MySql">
	SELECT u.country, c.countryname, count(s.studentid) as total_students
	FROM smg_users u
	LEFT JOIN smg_countrylist c ON c.countryid = u.country
	INNER JOIN smg_students s ON s.intrep = u.userid
	WHERE s.canceldate IS NULL
		AND	( <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	GROUP BY c.countryname
	ORDER BY c.countryname
</cfquery>

<!--- 0 students will skip the table --->
<cfif get_country.recordcount>
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr><td colspan="2"><div align="center">Program(s) Included in this Report:</div><br>
		<cfoutput query="get_programs"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
		<div align="center"><cfoutput>Total of #get_total_students.total# Students</cfoutput></div>
	</td></tr>
	<tr><th width="75%">Country</th> <th width="25%">Total of Students</th></tr>
	</table><br>
	<!--- Country Loop --->
		<cfoutput query="get_country">
		<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
		<tr bgcolor='ededed'>
			<th width="75%">#countryname#</th>
			<th width="25%" align="center">#total_students#</th>
		</tr>
		</table><br>
	
		<cfquery name="get_agents" datasource="MySql">
			SELECT u.businessname, count(s.studentid) as total
			FROM smg_students s
			INNER JOIN smg_users u ON u.userid = s.intrep
			WHERE s.canceldate IS NULL
				  AND u.country = '#get_country.country#'
				  AND	( <cfloop list=#form.programid# index='prog'>
							s.programid = #prog# 
							<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
						  </cfloop> )
			GROUP BY businessname 
		</cfquery>
		<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
		<cfloop query="get_agents">
			<cfif get_agents.recordcount is '0'><cfelse>
			<tr bgcolor="#iif(get_agents.currentrow MOD 2 ,DE("white") ,DE("ededed") )#">
				<td width="75%">#get_agents.businessname#</td><td width="25%" align="center">#total#</td></tr>
			</cfif>
		</cfloop>	
		</table><br>
		</cfoutput>
	<br><br>	
</cfif>