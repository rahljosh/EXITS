<link rel="stylesheet" href="reports.css" type="text/css">

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<cfquery name="get_facilitators" datasource="MySql">
	SELECT 	u.userid, u.firstname, u.lastname
	FROM smg_users u
	LEFT JOIN smg_regions r ON r.regionfacilitator = u.userid
	WHERE 	r.company = '#client.companyid#'
			AND subofregion = '0'
			<cfif form.userid is not 0>AND u.userid = #form.userid#</cfif>
	GROUP BY u.userid
	ORDER BY u.firstname
</cfquery>

<cfoutput>
<table width='100%' cellpadding=4 cellspacing="0" align="center">
	<tr><td><span class="application_section_header"><cfoutput>#companyshort.companyshort# - Overall Students per Facilitator</cfoutput></span></td></tr>
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	</td></tr>
</table><br>

<cfloop query="get_facilitators">

	<cfquery name="get_students" datasource="MySql">
		SELECT 	s.studentid, s.firstname, s.familylastname, s.sex, s.dateapplication,
				u.businessname,
				c.countryname,
				r.regionname
		FROM smg_students s
		INNER JOIN smg_users u ON s.intrep = u.userid
		INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
		INNER JOIN smg_regions r ON s.regionassigned = r.regionid
		WHERE s.active = 1 
			AND r.company = '#client.companyid#' 
			AND r.regionfacilitator = '#get_facilitators.userid#'
			AND (<cfloop list=#form.programid# index='prog'>
				programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		ORDER BY s.familylastname
	</cfquery>

	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="CCCCCC">Fac. : &nbsp; #get_facilitators.firstname# #get_facilitators.lastname#</th>
			<td width="15%" align="center" bgcolor="CCCCCC"><b>#get_students.recordcount#</b></td></tr>
	</table><br>

	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
	<tr>
		<td width="25%">Student</td>
		<td align="center" width="10%">Sex</td>
		<td width="15%">Country</td>
		<td width="25%">Intl. Agent</td>
		<td width="15%">Region</td>
		<td align="center" width="10%">Entry Date</td>								
	</tr>
	</table><br>
	
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
	<cfloop query="get_students">
		<tr>
			<td width="25%">#firstname# #familylastname# (#studentid#)</td>
			<td align="center" width="10%">#sex#</td>
			<td width="15%">#countryname#</td>
			<td width="25%">#businessname#</td>
			<td width="15%">#regionname#</td>
			<td align="center" width="10%">#DateFormat(dateapplication, 'mm/dd/yyyy')#</td>								
		</tr>
	</cfloop>
	</table><br>
</cfloop>

</cfoutput>