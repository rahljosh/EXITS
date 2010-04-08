<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfsetting requesttimeout="300">

<cfif not IsDefined('form.programid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="caseusa">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog EQ #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_regions" datasource="caseusa">
	SELECT regionid, regionname
	FROM smg_regions
	WHERE company = '#client.companyid#' 
		<cfif form.regionid NEQ '0'>
			AND (<cfloop list="#form.regionid#" index='reg'>
					regionid = #reg# 
					<cfif reg EQ #ListLast(form.regionid)#><Cfelse>or</cfif>
					</cfloop> )
		</cfif>
	ORDER BY regionname
</cfquery> 

<cfoutput>
<table width='100%' cellpadding=3 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Placement Paperwork Status</span></td></tr>
</table><br>

<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
		</td>
	</tr>
	<tr><td><b>Received</b> by the facilitator and the compliance person.</td></tr>
	<tr><td><b>Overdue</b> it means that the required placement paperwork has not been received.</td></tr>
	<tr><td><b>Pending</b> it means that the paperwork has been received by the facilitator, but It has not been received by the compliance person.</td></tr>	
</table><br>

<!--- table header --->
<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
	<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table><br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>

	<Cfquery name="get_total_in_region" datasource="caseusa">
		SELECT s.studentid
		FROM smg_students s
		LEFT JOIN smg_compliance c ON s.studentid = c.studentid
		WHERE s.active = '1' 
			AND s.regionassigned = '#current_region#' 
			AND s.hostid <> '0' 
			AND (<cfloop list=#form.programid# index='prog'>
				s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			AND (c.host_application IS NULL or c.school_acceptance IS NULL or c.confidential_visit IS NULL or 
			c.reference1 IS NULL or c.reference2 IS NULL or c.host_orientation IS NULL) 	
	</cfquery> 
	
	<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="##CCCCCC">Region: &nbsp; #get_regions.regionname#</th>
			<td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td>
		</tr>
	</table><br>

	<cfif get_total_in_region.recordcount NEQ 0>

	<Cfquery name="list_repid" datasource="caseusa">
		SELECT placerepid, u.firstname as repfirstname, u.lastname as replastname, u.userid
		FROM smg_students
		LEFT JOIN smg_users u ON placerepid = userid
		WHERE smg_students.active = '1' 
			AND smg_students.regionassigned = '#get_regions.regionid#' 
			AND smg_students.companyid = '#client.companyid#' 
			AND smg_students.hostid != '0' 
			AND (<cfloop list=#form.programid# index='prog'>
				smg_students.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
		GROUP BY placerepid
		ORDER BY repfirstname
	</cfquery>
	
	<cfloop query="list_repid">

		<cfquery name="get_students_region" datasource="caseusa">
			SELECT s.studentid, s.countryresident, s.firstname, s.familylastname, s.sex, s.programid, s.placerepid, s.dateplaced, s.hostid as stuhost,
				   s.doc_full_host_app_date, s.doc_letter_rec_date, s.doc_rules_rec_date, s.doc_photos_rec_date,
				   s.doc_school_accept_date, s.doc_conf_host_rec, s.doc_ref_form_1, s.doc_ref_form_2,
				  c.hostid, c.host_application, c.school_acceptance, c.confidential_visit, c.reference1, c.reference2, c.host_orientation 
			FROM smg_students s
			LEFT JOIN smg_compliance c ON s.studentid = c.studentid
			WHERE s.active = '1' 
				AND s.regionassigned = '#current_region#' 
				AND s.hostid != '0'
				AND s.placerepid = '#list_repid.placerepid#' 
				AND (<cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
					</cfloop> )
				AND (c.host_application IS NULL OR c.school_acceptance IS NULL OR c.confidential_visit IS NULL OR 
				c.reference1 IS NULL OR c.reference2 IS NULL <!--- OR c.host_orientation IS NULL --->) 			
		</cfquery>

		<cfif get_students_region.recordcount NEQ 0> 

			<table width='100%' cellpadding=3 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					<cfif repfirstname EQ '' and replastname EQ ''>
						<font color="red">Missing or Unknown</font>
					<cfelse>
						<u>#repfirstname# #replastname# (###userid#)</u>
					</cfif>
					</td>
					<td width="15%" align="center">#get_students_region.recordcount#</td></tr>
			</table>
								
			<table width='100%' frame=below cellpadding=3 cellspacing="0" align="center" frame="border">
				<tr>
					<td ><b>Student</b></th>
					<td width="13%"><b>HF App.</b></td>
					<td width="13%"><b>School Acceptance</b></td>
					<td width="13%"><b>HF Visit</b></td>
					<td width="13%"><b>Reference ##1</b></td>
					<td width="13%"><b>Reference ##2</b></td>
					<td width="13%"><b>HF Orientation</b></td>
				</tr>	
				<cfloop query="get_students_region">			 
				<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">			
					<cfif #DateDiff('ww',dateplaced, now())# GT 2>
					 	<cfset status = 'Overdue'>
					<cfelse>
						<cfset status =  'Due #DateFormat(DateAdd('ww', 2, dateplaced), 'mm/dd/yyyy')#'>
					</cfif>
					<td>#firstname# #familylastname# (###studentid#)</td>
					<td><!--- check if has been entered by the facilitator --->
						<cfif doc_full_host_app_date EQ '' OR doc_letter_rec_date EQ '' OR doc_rules_rec_date EQ '' OR doc_photos_rec_date EQ ''>
							#status#
						<!--- check if has been entered on the compliance ---->
						<cfelseif host_application NEQ ''>
							Received  
						<cfelse>
							Pending
						</cfif>
					</td>
					<td><cfif doc_school_accept_date EQ ''> #status# <cfelseif school_acceptance NEQ ''> Received <cfelse> Pending </cfif></td>
					<td><cfif doc_conf_host_rec EQ ''> #status# <cfelseif confidential_visit NEQ ''> Received <cfelse> Pending </cfif></td>
					<td><cfif doc_ref_form_1 EQ ''> #status# <cfelseif reference1 NEQ ''> Received <cfelse> Pending </cfif></td>
					<td><cfif doc_ref_form_2 EQ ''> #status# <cfelseif reference2 NEQ ''> Received <cfelse> Pending </cfif></td>
					<td> n/a <!--- <cfif host_orientation EQ ''> #status# <cfelse> Pending </cfif> ---></td>
				</tr>								
				</cfloop>
				<!--- <tr><td colspan="7">* Not current host family.</td></tr>	 --->
			</table><br>				
		</cfif>  <!--- get_students_region.recordcount NEQ 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	<cfelse><!---  get_total_in_region.recordcount --->
		<table width='100%' cellpadding=3 cellspacing="0" align="center">
			<tr><td>There are no missing documents for this region.</td></tr>
		</table><br>
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_regions" --->

<br>
</cfoutput>