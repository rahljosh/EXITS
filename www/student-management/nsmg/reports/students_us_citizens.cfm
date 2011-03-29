<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>US Citizens</title>
</head>

<body>

<cfif NOT IsDefined('FORM.programid')>
	Please select a program in order to run this report.
	<cfabort>
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	
    	programid, 
        programname, 
        companyshort
	FROM 	
    	smg_programs 
	LEFT JOIN 
    	smg_program_type ON type = programtypeid
	LEFT JOIN 
    	smg_companies c ON c.companyid = smg_programs.companyid
	WHERE 
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
</cfquery>

<cfquery name="get_us_citizens" datasource="MySql">
	SELECT 
    	s.studentid, 
        s.firstname, 
        s.familylastname, 
        s.sex, 
        s.dob, 
        s.studentid, 
        u.businessname,
		birth.countryname as countrybirth,		
		citizen.countryname as countrycitizen,
		resident.countryname as countryresident
	FROM 
    	smg_students s
	INNER JOIN 
    	smg_users u ON u.userid = s.intrep
	INNER JOIN 
    	smg_programs p ON s.programid = p.programid
	INNER JOIN 
    	smg_companies co ON s.companyid = co.companyid
	LEFT JOIN 
    	smg_countrylist birth ON s.countrybirth = birth.countryid
	LEFT JOIN 
    	smg_countrylist citizen ON s.countrycitizen = citizen.countryid
	LEFT JOIN 
    	smg_countrylist resident ON s.countryresident = resident.countryid
	WHERE 
	<cfif CLIENT.companyID EQ 5>
          s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
    <cfelse>
          s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
    </cfif>
    AND
	    s.canceldate IS NULL
	AND
    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )	
	AND 
    	(
            s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="232"> 
        OR 
            s.countrycitizen = <cfqueryparam cfsqltype="cf_sql_integer" value="232"> 
        OR
            s.countrybirth = <cfqueryparam cfsqltype="cf_sql_integer" value="232"> 
        )
	ORDER BY 
    	u.businessname, 
        s.firstname
</cfquery>

<cfoutput>

<table width="90%" cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><th>US Citizens Students</th></tr>
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="get_program"><b>#programname# &nbsp; (#programID#)</b><br></cfloop>
	Total of students &nbsp; <i>#get_us_citizens.recordcount#</i>
	</td></tr>
</table><br />

<table width="90%" cellpadding=2 cellspacing="0" align="center" frame="box">	
	<tr>
		<th width="26%">Intl. Agent</th>
		<th width="20%">Student</th>
		<th width="18%">Country of Birth</th>
		<th width="18%">Country of Citizenship</th>
		<th width="18%">Country of Residence</th>
	</tr>
	<cfif get_us_citizens.recordcount>
	<cfloop query="get_us_citizens">
		<tr bgcolor="#iif(get_us_citizens.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td>#businessname#</td>
			<td>#firstname# #familylastname# (###studentid#)</td>
			<td>#countrybirth#</td>
			<td>#countrycitizen#</td>
			<td>#countryresident#</td>
		</tr>
	</cfloop>
	<cfelse>
		<tr><td colspan="5">0 US Students</td></tr>
	</cfif>
</table>

</cfoutput>

</body>
</html>
