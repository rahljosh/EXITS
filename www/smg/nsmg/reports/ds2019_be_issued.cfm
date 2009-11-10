<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>DS-2019 - Forms to be issued.</title>
</head>

<body>

<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_agent_list" datasource="MYSQL">
	SELECT DISTINCT	userid, intrep, businessname, count(studentid) as total_student
	FROM smg_students
	INNER JOIN smg_users ON smg_students.intrep = smg_users.userid 
	WHERE smg_students.active = '1'
		AND ds2019_no = ''
		AND countrybirth != '232' AND countryresident != '232' AND countrycitizen != '232'
		AND verification_received IS NOT NULL
		AND sevis_batchid = '0'
		AND onhold_approved <= '4'
		AND	( <cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	GROUP BY intrep
	ORDER BY businessname
</cfquery>

<cfquery name="get_program" datasource="MYSQL">
	SELECT DISTINCT 
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
<span class="application_section_header">#companyshort.companyshort# - DS-2019 to be Issued</span>
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
	<tr bgcolor="ededed">
		<td></td><td><b>#get_agent_list.businessname#</b></td><td align="center"><b>#get_agent_list.total_student#</b></td>
	</tr>
	<cfset total = total + #get_agent_list.total_student#>
	<cfquery name="get_students" datasource="MYSQL">
		SELECT studentid, firstname, familylastname
		FROM smg_students 
		WHERE active = '1'
			AND ds2019_no = ''
			AND countrybirth != '232' AND countryresident != '232' AND countrycitizen != '232'
			AND verification_received IS NOT NULL
			AND sevis_batchid = '0'
			AND onhold_approved <= '4'
			AND	( <cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND intrep = '#get_agent_list.userid#'
	</cfquery>	
		<cfloop query="get_students">
		<tr><td></td><td colspan="2">#firstname# #familylastname# (###studentid#)</td></tr>
		</cfloop>
	</cfloop>
	<tr><td colspan="3"><br>Total of forms to be issued: #total#</td></tr>
</Table><br>

</cfoutput>
</div>

</body>
</html>
