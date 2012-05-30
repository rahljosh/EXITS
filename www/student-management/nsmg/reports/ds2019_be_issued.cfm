<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>#CLIENT.DSFormName# - Forms to be issued.</title>
</head>

<body>

<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="qGetIntlReps" datasource="MYSQL">
	SELECT DISTINCT	
    	userid, 
        intrep, 
        businessname, 
        count(studentid) as total_student
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_users ON s.intrep = smg_users.userid 
	WHERE 
    	s.active = '1'
	<!--- SHOW ONLY APPS APPROVED --->
    AND
        s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
	AND 
    	s.ds2019_no = ''
	AND 
    	s.countrybirth != '232' 
    AND 
    	s.countryresident != '232' 
    AND 
    	s.countrycitizen != '232'
	AND 
    	s.verification_received IS NOT NULL
	AND 
    	s.sevis_batchid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">		
    AND 
    	s.onhold_approved <= '4'
    AND	
    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )

	<cfif CLIENT.companyID EQ 5>
        AND 
            s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
    <cfelse>
        AND 
            s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfif>
        
	GROUP BY 
    	intrep
	ORDER BY 
    	businessname
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
<span class="application_section_header">#companyshort.companyshort# - #CLIENT.DSFormName# to be Issued</span>
</table><br>

<table width='80%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of #qGetIntlReps.recordcount# agent(s).</div>
</td></tr>
</table><br>

<hr width=80% color="000000"><br>

<Table width=80% frame=below cellpadding=6 cellspacing="0" align="center">
	<tr>
		<td width=5></td>
		<td><u>International Representative</td><td align="center"><u>Total of Student(s)</td>
  	</tr>
	<cfloop query="qGetIntlReps">
	<tr bgcolor="ededed">
		<td></td><td><b>#qGetIntlReps.businessname#</b></td><td align="center"><b>#qGetIntlReps.total_student#</b></td>
	</tr>
	<cfset total = total + #qGetIntlReps.total_student#>
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
			AND intrep = '#qGetIntlReps.userid#'
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
