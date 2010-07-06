<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_agent_list" datasource="MYSQL">
	SELECT DISTINCT	
    	s.intrep, 
        u.businessname, 
        count(s.studentid) as total_student
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_users u ON s.intrep = u.userid 
	WHERE 
    	s.ds2019_no = ''
    AND 
    	s.verification_received IS null 
    AND 
    	s.active = '1'
    AND 
    	s.onhold_approved <= '4'
    AND	
    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
	<cfif CLIENT.companyID EQ 5>
		AND          
        	s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
    <cfelse>
		AND          
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
    </cfif>
	GROUP BY 
    	s.intrep
	ORDER BY 
    	u.businessname
</cfquery>

<cfquery name="get_program" datasource="MYSQL">
	SELECT DISTINCT 
		p.programid, 
        p.programname, 
		c.companyshort
	FROM
    	smg_programs p
	INNER JOIN 
    	smg_companies c ON c.companyid = p.companyid
	WHERE 	
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
</cfquery>

<cfset total = '0'>

<cfoutput>
<table width='80%' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - DS-2019 Verification Report not Received</span>
</table><br>

<table width='80%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of #get_agent_list.recordcount# agent(s).</div>
</td></tr>
</table><br>

<hr width=80% color="000000"><br>

<Table width=80% frame=below cellpadding=6 cellspacing="0" align="center">
	<tr>
		<td width=5></td>
		<td><u>International Representative</u></td>
        <td align="center"><u>Total of Student(s)</u></td>
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