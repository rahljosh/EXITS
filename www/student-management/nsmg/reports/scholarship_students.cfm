<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
SELECT	*
FROM 	smg_programs 
LEFT OUTER JOIN smg_program_type ON type = programtypeid
WHERE ( <cfloop list=#form.programid# index='prog'>
	 	    programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT regionid, regionname, companyid
	FROM smg_students
	INNER JOIN smg_regions r ON r.regionid = regionassigned
	WHERE 1=1
		<cfif form.regionid is 0><cfelse>AND regionid = '#form.regionid#'</cfif>
		AND ( <cfloop list=#form.programid# index='prog'>
	 	    programid = #prog# 
		   	<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		  </cfloop> )		
	GROUP BY regionid
	ORDER BY companyid, regionname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	countryname
	FROM 	smg_students
	INNER JOIN smg_countrylist c ON countryresident = c.countryid
	WHERE active = '1'
		AND scholarship = '1'
		<cfif form.regionid is 0><cfelse>AND regionassigned = '#form.regionid#'</cfif>
		<cfif form.status is 1>AND hostid <> '0'</cfif>
		<cfif form.status is 2>	AND hostid = '0'</cfif>
		AND ( <cfloop list=#form.programid# index='prog'>
	 	    	programid = #prog# 
		   		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		   </cfloop> )
        AND 
        	smg_students.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">		
</cfquery>

<table width='680' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Scholarship Students per Region</cfoutput></span>
</table>
<br>

<table width='680' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<cfoutput query="get_program"><b>Program: (#ProgramID#) #programname#</b><br></cfoutput>
   	<cfoutput>Total of Scholarship Students <cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in program(s): #get_total_students.recordcount#</cfoutput>
	</td></tr>
</table>
<br>

<table width='680' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">Region</th> <th width="25%">Total Assigned</th></tr>
</table>

<br>
<cfloop query="get_region">
	<!--- Get Students By Region --->
	<Cfquery name="get_students" datasource="MySQL">
	SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.sex,
	c.countryname,
	u.businessname,
	h.city, h.state
	from smg_students s
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	INNER JOIN smg_users u ON u.userid = s.intrep
	LEFT JOIN smg_hosts h ON h.hostid = s.hostid
	WHERE s.regionassigned = '#get_region.regionid#'
		AND s.active = '1'
		AND s.scholarship = '1'
		<cfif form.status is 1>AND s.hostid <> '0'</cfif>
		<cfif form.status is 2>	AND s.hostid = '0'</cfif>
		AND ( <cfloop list=#form.programid# index='prog'>
	 	    s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   		</cfloop> )
	Order by s.firstname
	</cfquery>  

	<cfif #get_students.recordcount# is 0><cfelse>
		<table width='680' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><th width="75%"><cfoutput>#get_region.regionname#</th><td width="25%" align="center">#get_students.recordcount#</td></cfoutput></tr>
		</table>
		<table width='680' frame=below cellpadding=6 cellspacing="0" align="center" frame="border">
			<tr><td width="7%"><b>ID</b></th>
				<td width="16%"><b>First Name</b></td>
				<td width="20%"><b>Last Name</b></td>
				<td width="10%"><b>Gender</b></td>
				<td width="10%"><b>HF City</b></td>
				<td width="7%"><b>HF State</b></td>
				<td width="15%"><b>Country</b></td>
				<td width="15%"><b>Intl. Agent</b></td></tr>	
			<cfoutput query="get_students">
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#studentid#</td>
				<td>#firstname#</td>
				<td>#familylastname#</td>
				<td>#sex#</td>
				<td>#city#</td>
				<td>#state#</td>				
				<td>#countryname#</td>
				<td>#businessname#</td></tr>					
			</cfoutput>	
	   </table>
	<br>
	</cfif>
</cfloop>