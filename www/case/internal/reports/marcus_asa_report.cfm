<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
SELECT	*
FROM 	smg_programs 
LEFT OUTER JOIN smg_program_type
ON type = programtypeid
WHERE (programid = '75' or programid = '90' or programid = '100')
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="caseusa">
	SELECT 
		s.studentid, s.countryresident, s.firstname, s.familylastname, s.intrep, s.programid, s.sex, s.dateapplication,
		u.userid, u.businessname, u.email, s.ds2019_no, s.dob,
		p.programid, p.programname,
		r.regionname, r.regionid,
		countryname,
		h.familylastname as hostfamily
	FROM smg_students s 
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_programs p	ON s.programid = p.programid
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	LEFT OUTER JOIN smg_regions r ON s.regionassigned = r.regionid 
	LEFT OUTER JOIN smg_hosts h ON s.hostid = h.hostid		
	WHERE s.active = '1' and s.companyid = '#client.companyid#'
		AND ds2019_no like 'N%' AND u.accepts_sevis_fee = '1'
		AND (s.programid = '75' or s.programid = '90' or s.programid = '100')
	ORDER BY u.businessname, s.firstname, s.familylastname
</cfquery>  

<table width='650' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# -  Students per International Rep.</cfoutput></span>
</table>
<br>

<cfoutput> 
<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<cfloop query="get_program"><b>Program: (#ProgramID#) #programname#</b><br></cfloop>
	Total of Students in all programs: &nbsp; #get_students.recordcount#
	</td></tr>
</table>
</cfoutput>
<br>

<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">International Representative</th> <th width="25%">Total</th></tr>
</table><br>

	<cfoutput query="get_students" group="intrep">
			<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%"><a href="mailto:#email#">#businessname#</a></th>
				<cfquery name="get_total" datasource="caseusa">
				SELECT intrep, count(s.studentid) as total_stu
				FROM smg_students s
				INNER JOIN smg_users u ON s.intrep = u.userid
				WHERE s.intrep = #intrep# and s.active = '1' and s.companyid = #client.companyid# 
				AND ds2019_no like 'N%'
				AND u.accepts_sevis_fee = '1' AND (s.programid = '75' or s.programid = '90' or s.programid = '100')
				GROUP BY s.IntRep
				</cfquery>
				<td width="25%" align="center">#get_total.total_stu#</td></tr>
			</table>
			<table width='650' frame="below" cellpadding=6 cellspacing="0" align="center">
				<tr><td width="6%" align="center"><b>ID</b></th>
					<td width="35%"><b>Student</b></td>
					<td width="8%" align="center"><b>Sex</b></td>
					<td width="20%"><b>Country</b></td>
					<td width="16%"><b>DS 2019</b></td>
					<td width="15%"><b>DOB</b></td></tr>
			 <cfoutput>					
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td align="center">#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td align="center">#sex#</td>
					<td>#countryname#</td>
					<td>#ds2019_no#</td>		
					<td>#DateFormat(dob, 'mm/dd/yyyy')#</td></tr>							
			</cfoutput>	
			</table><br>
	</cfoutput><br>			

