<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_agent_list" datasource="caseusa">
	SELECT DISTINCT	intrep, businessname, count(studentid) as total_student
	FROM smg_students 
	INNER JOIN smg_users ON smg_students.intrep = smg_users.userid 
	WHERE ds2019_no = ''
		AND verification_received IS null 
		AND smg_students.active = '1'
		AND onhold_approved <= '4'
		AND	( <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	GROUP BY intrep
	ORDER BY businessname
</cfquery>

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
</cfquery>

<cfset total = '0'>

<cfoutput>
<table width='80%' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - DS-2019 Verification Report not Received</span>
</table><br>

<table width='80%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of #get_agent_list.recordcount# agent(s).</div>
</td></tr>
</table><br>

<hr width=80% color="000000"><br>

<Table width=80% frame=below cellpadding=6 cellspacing="0" align="center">
	<tr>
		<td width=5></td>
		<td><u>International Representative</td><td align="center"><u>Total of Student(s)</td>
  	</tr>
	<cfloop query="get_agent_list">
	<tr bgcolor="#iif(get_agent_list.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
		<td></td>
		<td>#get_agent_list.businessname#</td><td align="center">#get_agent_list.total_student#</td>
	</tr>
	<cfset total = total + #get_agent_list.total_student#>
	</cfloop>
	<tr><td colspan="3"><br>Total of forms to be issued: #total#</td></tr>
</Table><br>

</cfoutput>
</div>