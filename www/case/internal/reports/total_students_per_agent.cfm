<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Total of Active Students Per Intl. Rep.</cfoutput></span>
</table>
<br>

<!--- Get total students grouped by Agent --->
<cfquery name="get_total_students" datasource="caseusa">
	SELECT DISTINCT
			count(s.studentid) as get_total_students,
			c.countryname,
			u.businessname, agent_country.countryname as agentcountry
	FROM 	smg_students s
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_countrylist agent_country ON u.country = agent_country.countryid
	WHERE 	s.canceldate IS NULL 
			AND (<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			<!--- AND u.businessname LIKE '%EF%' AND u.businessname != 'Treff' --->
	GROUP BY Businessname
	ORDER BY Businessname
</cfquery>

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
	SELECT	DISTINCT 
		p.programid, p.programname, 
		c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE 	<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>
	ORDER BY companyshort
</cfquery>

<cfoutput>

<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="left">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		Total of #get_total_students.recordcount# International Agents
		</td>
	</tr>
</table><br>

<!--- 0 students will skip the table --->
<cfif get_total_students.recordcount> 	
	<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box" border="1">	
		<tr><th width="50%">International Agent</th><th width="25%">Country</th><th width="25%">Total</th></tr>
		<!--- Country Loop --->
		<cfset total_stu = '0'>
		<cfloop query="get_total_students">
			<tr bgcolor="#iif(get_total_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#businessname#</td>
				<td align="center">#agentcountry#</td>
				<td align="center">#get_total_students#</td>
				<cfset total_stu = total_stu + #get_total_students#>
			</tr>
		</cfloop>
			<tr><th>Total of Students</th><th>&nbsp;</th><th>#total_stu#</th></tr>
	</table>
	<br><br>	
</cfif>

</cfoutput>