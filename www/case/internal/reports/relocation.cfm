<link rel="stylesheet" href="reports.css" type="text/css">

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	LEFT JOIN smg_companies c ON c.companyid = smg_programs.companyid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
		programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="caseusa">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is  not 0>
			AND regionid = '#form.regionid#'	
		</cfif>
	ORDER BY regionname
</cfquery>

<cfquery name="total_stu_relocated" datasource="caseusa">
	SELECT hist.historyid, s.firstname, s.familylastname, s.regionassigned
	FROM smg_hosthistory hist
	INNER JOIN smg_students s ON s.studentid = hist.studentid
	WHERE s.active = '1' 
		AND hist.relocation = 'yes' 
		AND (<cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	   <cfif IsDefined('form.dates') AND form.date1 NEQ '' AND form.date2 NEQ ''>
	   AND (s.dateplaced between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
	   </cfif>			
	GROUP BY s.studentid 
</cfquery>


<cfoutput>

<table width='90%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header">#companyshort.companyshort# - Relocation Report</span>
</table><br>

<table width='90%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="get_program"><b>#companyshort# - #programname# &nbsp; (#programID#)</b><br></cfloop>
	Total of Students <b>relocated</b> in program: #total_stu_relocated.recordcount#
	</td></tr>
</table>

<br> <!--- table header --->
<table width='90%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
</table>
<br>

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>
	
	<cfquery name="get_students_in_region" datasource="caseusa">
		SELECT hist.historyid, s.firstname, s.familylastname, s.regionassigned, s.studentid
		FROM smg_hosthistory hist
		INNER JOIN smg_students s ON s.studentid = hist.studentid
		WHERE s.active = '1' 
			AND hist.relocation = 'yes' 
			AND s.regionassigned = '#get_region.regionid#'
			AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		   <cfif IsDefined('form.dates') AND form.date1 NEQ '' AND form.date2 NEQ ''>
		   AND (s.dateplaced between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(form.date2)#) 
		   </cfif>			
		GROUP BY s.studentid 
	</cfquery>
		
	<cfif get_students_in_region.recordcount is not 0>
	<table width='90%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="CCCCCC">#get_region.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_students_in_region.recordcount#</b></td></tr>
	</table>
	<br>
	
	<table border="1" align="center" width='90%' bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
		<tr>
			<td width="10%" align="center"><b>ID</b></th>
			<td width="90%"><b>Student</b></td>
		</tr>
	<cfloop query="get_students_in_region">
		<tr bgcolor="#iif(get_students_in_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
			<td align="center">#studentid#</td>
			<td>#firstname# #familylastname# &nbsp; (#studentid#)</td>
		</tr>
		<cfquery name="get_history" datasource="caseusa">
			SELECT hist.hostid, hist.reason, hist.dateofchange, h.familylastname, h.address, h.city, h.state, h.zip, h.phone,
					u.firstname, u.lastname, u.userid
			FROM smg_hosthistory hist
			LEFT JOIN smg_hosts h ON hist.hostid = h.hostid
			LEFT JOIN smg_users u ON hist.changedby = u.userid
			WHERE hist.studentid = #get_students_in_region.studentid# 
				AND relocation = 'yes'
			ORDER BY hist.dateofchange desc, hist.historyid DESC
		</cfquery>
		<tr bgcolor="#iif(get_students_in_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#"><td colspan="2">
			<b>Relocation History</b><br>
			<cfloop query="get_history">
			&nbsp; &nbsp; &nbsp; <p><u> #get_history.currentrow# - Host Family: &nbsp; &nbsp; #familylastname# (#hostid#)</u><br>
			&nbsp; &nbsp; &nbsp; Reason: &nbsp; &nbsp; #reason# &nbsp; &nbsp; Changed on: &nbsp; &nbsp;#DateFormat(dateofchange, 'mm/dd/yyyy')#  &nbsp; &nbsp; By:  &nbsp; &nbsp; #firstname# #lastname# (#userid#)<br>
			</cfloop>
			<cfquery name="get_current_hf" datasource="caseusa">
				SELECT h.familylastname, h.address, h.city, h.state, h.zip, h.phone, s.hostid
				FROM smg_students s
				LEFT JOIN smg_hosts h ON s.hostid = h.hostid
				WHERE s.studentid = #get_students_in_region.studentid#
			</cfquery>
			<cfif get_current_hf.recordcount NEQ '0'>
				&nbsp; &nbsp; &nbsp; <p><u> Current Host Family: &nbsp; &nbsp; #get_current_hf.familylastname# (#get_current_hf.hostid#)</u><br>
			<cfelse>
				&nbsp; &nbsp; &nbsp; <p><u> This student is currently UNPLACED.</u><br>
			</cfif>
		</td></tr>
	</cfloop>			
	</table><br>
	</cfif> <!---  get_students_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_region" --->
</cfoutput>
<br>