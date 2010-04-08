<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
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

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="caseusa">
	SELECT s.studentid, s.countryresident, s.firstname, s.familylastname, s.intrep, s.programid, s.sex, s.dateapplication, s.dob,
		u.userid, u.businessname, u.email, 
		p.programid, p.programname,
		r.regionname, r.regionid,
		countryname,
		h.familylastname as hostfamily,
		english.name as englishcamp, 
		orientation.name as orientationcamp
	FROM smg_students s
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_programs p	ON s.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	LEFT JOIN smg_regions r ON s.regionassigned = r.regionid 
	LEFT JOIN smg_hosts h ON s.hostid = h.hostid		
	LEFT JOIN smg_aypcamps english ON s.aypenglish = english.campid
	LEFT JOIN smg_aypcamps orientation ON s.ayporientation = orientation.campid
	WHERE 1 = 1
		<cfif form.active EQ 1> <!--- active --->
			AND s.active = '#form.active#'
		<cfelseif form.active EQ '0'> <!--- inactive --->
			AND canceldate IS NULL
		<cfelseif form.active EQ '2'> <!--- canceled --->
			AND canceldate IS NOT NULL
		</cfif>  
		<cfif form.intrep NEQ 0>AND s.intrep = #form.intrep#</cfif>
		<cfif form.status is 1>
			AND s.hostid != '0' AND s.host_fam_approved <= '4' <!--- placed --->
		<cfelseif form.status EQ 2>
			AND s.hostid = '0' <!--- unplaced --->
		</cfif>
		<cfif form.preayp is 'all'>
			AND (s.aypenglish = english.campid OR s.ayporientation = orientation.campid)
		<cfelseif form.preayp is 'english'>
			AND s.aypenglish = english.campid
		<cfelseif form.preayp is 'orientation'>
			AND s.ayporientation = orientation.campid
		</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	ORDER BY u.businessname, s.firstname, s.familylastname
</cfquery>  

<table width='90%' cellpadding=6 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# -  Students per International Rep.</cfoutput></span>
</table>
<br>

<cfoutput>
<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<div align="center">Program(s) Included in this Report:</div><br>
	<cfloop query="get_program"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	<div align="center">Total of <cfif form.active EQ 1>Active<cfelseif form.active EQ '0'>Inactive<cfelseif form.active EQ '2'>Canceled</cfif> Students 
	<cfif form.status is 1><b>placed</b></cfif><cfif form.status is 2><b>unplaced</b></cfif> in report: &nbsp; #get_students.recordcount#</div>
	<cfif form.preayp is not 'none'><br>Pre-AYP #form.preayp# camp students</cfif>
</td></tr>
</table>
</cfoutput><br>

<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">International Representative</th> <th width="25%">Total</th></tr>
</table><br>

<cfif form.preayp is 'none'>		
	<cfoutput query="get_students" group="intrep">
		<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%"><a href="mailto:#email#">#businessname#</a></th>
				<cfquery name="get_total" dbtype="query">
				   SELECT studentid
				   FROM get_students
				   WHERE intrep = #intrep#
				 </cfquery>					
				<td width="25%" align="center">#get_total.recordcount#</td></tr>
			</table>
			<table width='90%' frame="below" cellpadding=6 cellspacing="0" align="center">
				<tr><td width="6%" align="center"><b>ID</b></th>
					<td width="25%"><b>Student</b></td>
					<td width="8%" align="center"><b>Sex</b></td>
					<td width="12" align="center"><b>DOB</b></td>
					<td width="18%"><b>Country</b></td>
					<cfif form.status is 1>
						<td width="16%"><b>Family</b></td>
					<cfelse>
						<td width="16%"><b>Region</b></td>
					</cfif>			
					<td width="15%"><b>Entry Date</b></td></tr>
			 <cfoutput>					
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td align="center">#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td align="center">#sex#</td>
					<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
					<td>#countryname#</td>
					<cfif form.status is 1>
						<td>#hostfamily#</td>	
					<cfelse>
						<td>#regionname#</td>	
					</cfif>					
					<td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td></tr>							
			</cfoutput>	
			</table><br>
	</cfoutput><br>
<cfelse><!--- pre ayp cfif --->
	<cfoutput query="get_students" group="intrep">
			<table width='90%' cellpadding=6 cellspacing="0" align="center" frame="box">	
			<tr><th width="75%"><a href="mailto:#email#">#businessname#</a></th>
				<cfquery name="get_total" dbtype="query">
				   SELECT studentid
				   FROM get_students
				   WHERE intrep = #intrep#
				 </cfquery>					
				<td width="25%" align="center">#get_total.recordcount#</td></tr>
			</table>
			<table width='90%' frame="below" cellpadding=6 cellspacing="0" align="center">
				<tr><td width="6%" align="center"><b>ID</b></th>
					<td width="20%"><b>Student</b></td>
					<td width="8%" align="center"><b>Sex</b></td>
					<td width="12" align="center"><b>DOB</b></td>
					<td width="16%"><b>Country</b></td>
					<cfif form.status is 1>
						<td width="11%"><b>Family</b></td>
					<cfelse>
						<td width="11%"><b>Region</b></td>
					</cfif>			
					<td width="12%"><b>Entry Date</b></td>
					<td width="%15%"><b>Pre-AYP Camp</b></td></tr>
			 <cfoutput>					
				<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
					<td align="center">#studentid#</td>
					<td>#firstname# #familylastname#</td>
					<td align="center">#sex#</td>
					<td>#DateFormat(DOB, 'mm/dd/yyyy')#</td>
					<td>#countryname#</td>
					<cfif form.status is 1>
						<td>#hostfamily#</td>	
					<cfelse>
						<td>#regionname#</td>	
					</cfif>					
					<td>#DateFormat(dateapplication, 'mm/dd/yyyy')#</td>
					<td>#englishcamp# #orientationcamp#</td></tr>							
			</cfoutput>	
			</table><br>
	</cfoutput><br>			
</cfif><!--- pre ayp cfif --->
			

