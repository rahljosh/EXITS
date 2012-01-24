<link rel="stylesheet" href="reports.css" type="text/css">

<cfif not IsDefined('form.programid')>
	<table width='100%' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
	<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
	Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
	<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
	</td></tr>
	</table>
	<cfabort>
</cfif>

<cfif NOT IsDefined('form.active')>
	<cfset form.active = 1>
</cfif>

<!--- Get Program --->
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
	INNER JOIN smg_regions r ON r.regionfacilitator = u.userid
	WHERE 	r.company = '#client.companyid#'
			AND subofregion = '0'
			<cfif form.userid is not 0>AND u.userid = #form.userid#</cfif>
	GROUP BY u.userid
	ORDER BY u.firstname
</cfquery>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid, smg_users.firstname, smg_users.lastname
	FROM smg_regions
	LEFT JOIN smg_users ON smg_regions.regionfacilitator = smg_users.userid
	WHERE company = '#client.companyid#'
		<cfif form.userid is not 0>
			and regionfacilitator = #form.userid#
		</cfif>
		<cfif client.usertype GT 4>
			and regionid like '#client.regions#'
		</cfif>
	ORDER BY smg_users.firstname
</cfquery>

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# and active = '1'
		AND onhold_approved <= '4'
		AND hostid <> '0' AND doubleplace <> '0'
		AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<table width='100%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#companyshort.companyshort# - Missing Double Placement Documents Report</cfoutput></span>
</table>
<br>


<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfoutput query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
	<cfoutput>Total of Students <b>placed</b> in program: #get_total_students.recordcount#</cfoutput>
	</td></tr>
</table>

<br> <!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table>
<br>

<cfloop query="get_region">
	
	<cfset current_region = get_region.regionid>
	
	<Cfquery name="list_repid" datasource="MySQL">
	SELECT placerepid, u.firstname, u.userid, u.lastname
	FROM smg_students
	LEFT JOIN smg_users u ON placerepid = userid
	where smg_students.active = '1' AND smg_students.regionassigned = '#get_region.regionid#'
		AND onhold_approved <= '4'
		AND smg_students.hostid <> '0' AND doubleplace <> '0'
			AND (<cfloop list=#form.programid# index='prog'>
			smg_students.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
	Group by placerepid
	Order by u.firstname
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="MySQL">
		select studentid
		from smg_students
		where active = '1' AND regionassigned = '#get_region.regionid#' 
			AND onhold_approved <= '4'
			AND hostid != '0' AND doubleplace != '0'
			AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
			AND (dblplace_doc_stu IS NULL OR dblplace_doc_fam IS NULL OR dblplace_doc_host IS NULL OR dblplace_doc_school IS NULL <!--- OR dblplace_doc_dpt IS NULL --->)	
	</cfquery> 
	
	<cfif get_total_in_region.recordcount NEQ 0>
	
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="#CCCCCC"><cfoutput>Fac. : &nbsp; #get_region.firstname# #get_region.lastname# &nbsp; - &nbsp; #get_region.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td></cfoutput></tr>
	</table>
	<br>

	<cfloop query="list_repid">

		<Cfquery name="get_students_region" datasource="MySQL">
			select studentid, countryresident, firstname, smg_students.familylastname, sex, programid, placerepid,
				datePlaced, dblplace_doc_stu, dblplace_doc_fam, dblplace_doc_host, dblplace_doc_school, dblplace_doc_dpt,
				h.familylastname as hostname, h.hostid
			from smg_students
			LEFT JOIN smg_hosts h ON h.hostid = smg_students.hostid
			where smg_students.active = '1' AND regionassigned = '#current_region#'
				 AND onhold_approved <= '4'
				 AND placerepid = '#list_repid.placerepid#' AND smg_students.hostid <> '0' 
				 AND doubleplace <> '0' 
				 AND (<cfloop list=#form.programid# index='prog'>
					programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
					</cfloop> )
					AND (dblplace_doc_stu IS NULL OR dblplace_doc_fam IS NULL OR dblplace_doc_host IS NULL OR dblplace_doc_school IS NULL <!--- OR dblplace_doc_dpt IS NULL --->)	
		</cfquery> 
		
		<cfif get_students_region.recordcount is not 0> 
			<cfoutput>
			<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					&nbsp; <cfif firstname is '' and lastname is ''><font color="red">Missing or Unknown</font><cfelse>
					#firstname# #lastname#</u></cfif>
					</td>
					<td width="15%" align="center">#get_students_region.recordcount#</td></tr>
			</table>
			</cfoutput>
								
			<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="8%">ID</th>
					<td width="20%">Student</td>
					<td width="14%">Host Family</td>
					<td width="10%">Placement</td>
					<td width="48%">Missing Documents</td>
				</tr>	
				<cfoutput query="get_students_region">			 
					<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td>#hostname# (###hostid#)</td>
						<td>#DateFormat(datePlaced, 'mm/dd/yyyy')#</td>
						<td align="left"><i><font size="-2">
							<cfif dblplace_doc_stu is ''>Student &nbsp; &nbsp; &nbsp;</cfif>
							<cfif dblplace_doc_fam is ''>Natural Family &nbsp; &nbsp; &nbsp;</cfif>
							<cfif dblplace_doc_host is ''>Host Family &nbsp; &nbsp; &nbsp;</cfif>
							<cfif dblplace_doc_school is ''>School &nbsp; &nbsp; &nbsp;</cfif>
							<!--- <cfif dblplace_doc_dpt is ''>Department of State &nbsp; &nbsp; &nbsp;</cfif> --->
						</font></i></td>		
					</tr>								
				</cfoutput>	
			</table>
			<br>				
		</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	</cfif> <!---  get_total_in_region.recordcount --->
</cfloop> <!--- cfloop query="get_region" --->
<br>