<link rel="stylesheet" href="../reports/reports.css" type="text/css">

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

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT DISTINCT 
		s.studentid, s.countryresident, s.firstname, s.familylastname, s.intrep, s.programid, s.sex, s.dateapplication,
		s.sevis_batchid, s.sevis_bulkid, s.insurance,
		u.userid, u.businessname, u.email, u.accepts_sevis_fee,
		p.programid, p.programname,
		r.regionname, r.regionid,
		c.countryname,
		sevis.datecreated as sevisdate,
		fee.datecreated as feedate		
	FROM smg_students s 
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_programs p	ON s.programid = p.programid
	INNER JOIN smg_countrylist c ON s.countryresident = c.countryid
	LEFT OUTER JOIN	smg_regions r ON s.regionassigned = r.regionid 
	LEFT OUTER JOIN smg_sevis sevis ON s.sevis_batchid = sevis.batchid
	LEFT OUTER JOIN smg_sevisfee fee ON s.sevis_bulkid = fee.bulkid
	WHERE s.active = '1' 
		AND s.companyid = '#client.companyid#' 
		<cfif form.intrep is 0><cfelse>AND s.intrep = #form.intrep#</cfif>
		AND  ( <cfloop list=#form.programid# index='prog'>
		 	    s.programid = #prog# 
			   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		   </cfloop> )
	ORDER BY u.businessname, s.firstname, s.familylastname
</cfquery>  

<table width='97%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# -  SEVIS Batch Report per International Rep.</cfoutput></span>
</table>
<br>

<table width='97%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	<cfoutput query="get_program"><b>Program: #programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
   	<cfoutput>Total of Students in program(s): #get_students..recordcount#</cfoutput>
	</td></tr>
</table>
<br>

<table width='97%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="75%">International Representative</th> <th width="25%">Total</th></tr>
</table><br>

<cfoutput query="get_students" group="intrep">
	<table width='97%' cellpadding=4 cellspacing="0" align="center" frame="box">	
	<tr><th width="75%"><a href="mailto:#email#">#businessname#</a></th>
		<cfquery name="get_total" datasource="MYSQL">
		SELECT intrep, count(studentid) as total_stu
		FROM smg_students
		WHERE intrep = #intrep# 
			AND active = '1' 
			AND companyid = #client.companyid#  
			AND  ( <cfloop list=#form.programid# index='prog'>
						programid = #prog# 
					   <cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				 </cfloop> )
		GROUP BY IntRep
		</cfquery>
		<td width="25%" align="center">#get_total.total_stu#</td></tr>
	</table>
	<table width='97%' frame="below" cellpadding=4 cellspacing="0" align="center">
		<tr><td width="6%" align="center"><b>ID</b></th>
			<td width="22%"><b>Student</b></td>
			<td width="10%" align="center"><b>Sex</b></td>
			<td width="12%"><b>Country</b></td>
			<td width="10%" align="center"><b>Batch ID</b></td>
			<td width="10%" ><b>Batch Date</b></td>
			<td width="10%" align="center"><b>Bulk ID</b></td>
			<td width="10%"><b>Bulk Date</b></td>
			<td width="10%"><b>Insured on:</b></td></tr>
	 <cfoutput>					
		<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td align="center">#studentid#</td>
			<td>#firstname# #familylastname#</td>
			<td align="center">#sex#</td>
			<td>#countryname#</td>
			<td align="center"><cfif sevis_batchid is '0'><font color="FF0000">not issued</font><cfelse>#sevis_batchid#</cfif></td>
			<td><cfif sevisdate is ''><font color="FF0000">not issued</font><cfelse>#DateFormat(sevisdate, 'mm/dd/yyyy')#</cfif></td>
			<td align="center">
				<cfif accepts_sevis_fee is '0'>none
				<cfelse>  
					<cfif sevis_bulkid is 0><font color="FF0000">not issued</font>
					<cfelse>#sevis_bulkid#</cfif>  
				</cfif></td>
			<td>
				<cfif accepts_sevis_fee is '0'>none
				<cfelse>  
					<cfif feedate is ''><font color="FF0000">not issued</font>
					<cfelse>#DateFormat(feedate, 'mm/dd/yyyy')#</cfif>
				</cfif></td>
			<td>
            	<!--- Insurance --->
            </td></tr>							
	</cfoutput>	
	</table><br>
</cfoutput><br>