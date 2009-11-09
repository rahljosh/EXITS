<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
SELECT	*
FROM 	smg_programs 
LEFT OUTER JOIN smg_program_type
ON type = programtypeid
WHERE ( <cfloop list=#form.programid# index='prog'>
	 	    programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is 0><cfelse>AND regionid = '#form.regionid#'</cfif>
	ORDER BY regionname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid
	FROM 	smg_students
	INNER JOIN smg_countrylist c ON countryresident = c.countryid
	INNER JOIN smg_iff ON iffid = iffschool
	WHERE companyid = #client.companyid# 
		AND active = '1'
		<cfif form.regionid is 0><cfelse>AND regionassigned = '#form.regionid#'</cfif>
		<cfif form.status is 1>AND hostid <> '0'</cfif>
		<cfif form.status is 2>	AND hostid = '0'</cfif>
		AND ( <cfloop list=#form.programid# index='prog'>
	 	    programid = #prog# 
		   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   </cfloop> )
</cfquery>

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - IFF Students per Region</cfoutput></span>
</table>
<br>


<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<cfoutput query="get_program"><b>Program: (#ProgramID#) #programname#</b><br></cfoutput>
   	<cfoutput>Total of IFF Students <cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in program(s): #get_total_students.recordcount#
	</td></tr>
</table>
</cfoutput>
<br>

<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">Region</th> <th width="25%">Total Assigned</th></tr>
</table>

<br>
<cfloop query="get_region">
	<!--- Get Students By Region --->
	<Cfquery name="get_students" datasource="MySQL">
	SELECT DISTINCT s.studentid, s.firstname, s.familylastname, s.sex, iffschool,
	c.countryname,
	u.businessname,
	name
	from smg_students s
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_iff ON iffid = iffschool
	WHERE s.regionassigned = '#get_region.regionid#'
		AND s.companyid = #client.companyid# 
		AND s.active = '1'
		<cfif form.status is 1>AND s.hostid <> '0'</cfif>
		<cfif form.status is 2>	AND s.hostid = '0'</cfif>
		AND ( <cfloop list=#form.programid# index='prog'>
	 	    	s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
	   		</cfloop> )
	Order by s.firstname
	</cfquery>  

	<cfif #get_students.recordcount# is 0><cfelse>
		<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
		<tr><th width="75%"><cfoutput>#get_region.regionname#</th><td width="25%" align="center">#get_students.recordcount#</td></cfoutput></tr>
		</table>
			<table width='650' frame=below cellpadding=6 cellspacing="0" align="center" frame="border">
				<tr><td width="8%"><b>ID</b></th>
					<td width="20%"><b>First Name</b></td>
					<td width="20%"><b>Last Name</b></td>
					<td width="12%"><b>Gender</b></td>
					<td width="20%"><b>Country</b></td>
					<td width="20%"><b>Iff School</b></td></tr>	
				<cfoutput query="get_students">
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td>#studentid#</td>
					<td>#firstname#</td>
					<td>#familylastname#</td>
					<td>#sex#</td>
					<td>#countryname#</td>
					<td>#name#</td></tr>							
				</cfoutput>	
		   </table>
	<br>
	</cfif>
</cfloop>