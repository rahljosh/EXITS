<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_agent_list" datasource="caseusa">
	SELECT DISTINCT	intrep, businessname, count(studentid) as total_student
	FROM smg_students 
	INNER JOIN smg_users ON smg_students.intrep = smg_users.userid 
	WHERE verification_received IS NOT NULL
		AND smg_students.active = '1'
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

<div id="pagecell_reports">
<hr width=80% color="000000">
<cfoutput>
<div align="center"><h3>#companyshort.companyshort# - DS-2019 Printed</h3></div>
<div align="center"><h4>Total of #get_agent_list.recordcount# agent(s).</h4></b></div>
<div align="center"><h4>Program: <cfloop query="get_program">(#programid#) #programname# <br/></cfloop></h4></b></div>
</cfoutput>
<hr width=80% color="000000">

<br>
<Table width=80% frame=below cellpadding=6 cellspacing="0" align="center">
	<tr>
		<td width=5></td>
		<td><u>International Representative</td><td align="center"><u>Total of Student(s)</td>
  	</tr>
	<cfoutput query="get_agent_list">
	<tr bgcolor="#iif(get_agent_list.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
		<td></td>
		<td>#get_agent_list.businessname#</td><td align="center">#get_agent_list.total_student#</td>
	</tr>
	</cfoutput>
</Table>
<br>
</div>