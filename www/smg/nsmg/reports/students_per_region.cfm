<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	DISTINCT 
		p.programid, p.programname, 
		c.companyshort
	FROM 	smg_programs p
	INNER JOIN smg_companies c ON c.companyid = p.companyid
	WHERE 	
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Students By Region --->
<Cfquery name="get_students" datasource="MySQL">
	select s.studentid, s.firstname, s.familylastname, s.sex, s.dob, s.regionassigned,
	c.countryname,
	u.businessname,
	r.regionid, r.regionname,
	english.name as englishcamp, 
	orientation.name as orientationcamp
	FROM smg_students s
	INNER JOIN smg_countrylist c ON countryresident = c.countryid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_regions r ON r.regionid = s.regionassigned
	LEFT JOIN smg_aypcamps english ON s.aypenglish = english.campid
	LEFT JOIN smg_aypcamps orientation ON s.ayporientation = orientation.campid
	WHERE 
    	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    AND	
	    s.active = '1' 
		AND s.onhold_approved <= '4'
		<cfif form.regionid NEQ 0>
			AND s.regionassigned = '#form.regionid#'
		</cfif>
		<cfif form.status EQ 1>
			AND hostid != '0' AND host_fam_approved <= '4'
		<cfelseif form.status EQ 2>
			AND s.hostid = '0'
		</cfif>
		<cfif form.continent NEQ 0>
			AND continent = '#form.continent#'
		</cfif>
		<cfif form.preayp is 'all'>
			AND (s.aypenglish = english.campid OR s.ayporientation = orientation.campid)
		<cfelseif form.preayp is 'english'>
			AND s.aypenglish = english.campid
		<cfelseif form.preayp is 'orientation'>
			AND s.ayporientation = orientation.campid
		</cfif>
		<cfif IsDefined('form.usa')>
			AND s.ds2019_no NOT LIKE 'N%'
			AND (s.countryresident = '232' or s.countrycitizen = '232' or s.countrybirth = '232') 
		</cfif>
		AND	
			s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.programid#" list="yes"> )            
	Order by 
    	r.regionname, 
        s.familylastname
</cfquery> 


<table width='90%' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Students per Region</cfoutput></span>
</table>
<br>

<cfoutput>
<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of Students <cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in report: #get_students.recordcount#</div>
	<cfif form.continent NEQ 0>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Continent: &nbsp; <b>#form.continent#</b></cfif>
	<cfif form.preayp NEQ 'none'><br>Pre-AYP #form.preayp# camp students</cfif>
</td></tr>
</table>
</cfoutput>
<br>

<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">Region</th> <th width="25%">Total Assigned</th></tr>
</table>

<br>
<cfoutput query="get_students" group="regionid">
	<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
	<tr>
		<th width="75%">#regionname#</th>
		<cfquery name="get_total" dbtype="query">
		   SELECT studentid
		   FROM get_students
		   WHERE regionassigned = #regionid#
		</cfquery>			
		<td width="25%" align="center">#get_total.recordcount#</td>
	</tr>
	</table>
	<cfif form.preayp EQ 'none'>
		<table width='90%' frame=below cellpadding=6 cellspacing="0" align="center" frame="border">
			<tr><td width="6%"><b>ID</b></th>
				<td width="18%"><b>First Name</b></td>
				<td width="18%"><b>Last Name</b></td>
				<td width="12%"><b>Gender</b></td>
				<td width="12%"><b>DOB</b></td>
				<td width="16%"><b>Country</b></td>
				<td width="18%"><b>Intl. Agent</b></td>
			</tr>	
			<cfoutput>
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#studentid#</td>
				<td>#firstname#</td>
				<td>#familylastname#</td>
				<td>#sex#</td>
				<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
				<td>#countryname#</td>
				<td>#businessname#</td>
			</tr>							
			</cfoutput>	
		</table>
	<cfelse><!--- pre ayp cfif --->
		<table width='90%' frame=below cellpadding=6 cellspacing="0" align="center" frame="border">
			<tr><td width="8%"><b>ID</b></th>
				<td width="18%"><b>First Name</b></td>
				<td width="18%"><b>Last Name</b></td>
				<td width="10%"><b>Gender</b></td>
				<td width="12%"><b>DOB</b></td>
				<td width="18%"><b>Country</b></td>
				<td width="16%"><b>Pre-AYP Camp</b></td></tr>	
			<cfoutput>
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#studentid#</td>
				<td>#firstname#</td>
				<td>#familylastname#</td>
				<td>#sex#</td>
				<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
				<td>#countryname#</td>
				<td>#englishcamp# #orientationcamp#</td>
			</tr>							
			</cfoutput>	
		</table>
	</cfif> <!--- pre ayp cfif --->
	<br>
</cfoutput>

<br>
<cfif form.continent NEQ 0>
	<cfquery name="get_list_countries" datasource="MySql">
		SELECT *
		FROM smg_countrylist
		WHERE continent = '#form.continent#' 
		ORDER BY countryname
	</cfquery>
	<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center" bgcolor="ededed">
	<cfoutput><cfif form.continent is 'Europe'>European<cfelse>#form.continent#n</cfif> countries included in this report:</cfoutput></td></tr>	
	<tr><td><cfoutput query="get_list_countries">#get_list_countries.countryname# &nbsp; &nbsp;</cfoutput></td></tr>
	<tr><td><font size="-3"><i>If you would like to add/delete countries, please go to Tools -> Countries</i></font></td></tr>	
	</table>
</cfif>