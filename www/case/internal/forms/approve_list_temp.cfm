<cfif not isDefined('url.rmonth')>
	<cfset url.rmonth = 12>
</cfif>
<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.form.sele_region.options[document.form.sele_region.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>


<!--- OFFICE - GET ALL REGIONS --->
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="caseusa"> 
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = list_regions.regionid></cfif>
<!--- FIELD - GET USERS REGION --->
<cfelse>	
	<cfquery name="list_regions" datasource="caseusa"> 
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' AND user_access_rights.companyid = '#client.companyid#'
		ORDER BY default_region DESC, regionname
	</cfquery>
	<!--- getting correct usertype for the region choosen --->
	<cfset client.usertype = list_regions.usertype>
	<cfif NOT IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
</cfif>

<!----Next N records---->
<cfset maxr=5>
<cfparam name="client.page.previous5start" default="1">

<cfparam name="client.page.next5start" default="1">

<cfif client.page.next5start gt 1>
	<cfset client.page.previous5start = #client.page.next5start#>
</cfif>



<span class="application_section_header">Progress Report Status</span><br><br>


<!--- OFFICE --->		
<cfif client.usertype LTE 4>
	<!--- get active students FROM region selected (if any) and FROM active programs --->
	<Cfquery name="rd_students" datasource="caseusa">
		SELECT s.studentid, s.regionassigned, s.familylastname, s.firstname, s.programid,  
				u.firstname as rep_firstname, u.lastname as rep_lastname, u.userid,
				p.startdate, ADDDATE(p.enddate, INTERVAL 2 MONTH ) AS enddate, p.type, pt.aug_report
		FROM smg_students s
		INNER JOIN smg_users u ON s.arearepid = u.userid
		INNER JOIN smg_programs p ON s.programid = p.programid
		inner join smg_program_type pt ON pt.programtypeid = p.type
		WHERE s.active =1 
			AND s.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
			<cfif url.regionid is "All"><cfelse>
				AND s.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			</cfif>
			AND p.startdate < #now()# 
		  	AND ADDDATE(p.enddate, INTERVAL 2 MONTH ) > #now()# 
		ORDER BY u.lastname, u.userid, s.familylastname
	</cfquery>
<!--- FIELD --->
<cfelse>
	<Cfquery name="rd_students" datasource="caseusa">
		SELECT s.studentid, s.regionassigned, s.familylastname, s.firstname, s.programid,  
			   u.firstname as rep_firstname, u.lastname as rep_lastname, u.userid,
			   p.startdate, ADDDATE(p.enddate, INTERVAL 2 MONTH ) AS enddate, p.type, pt.aug_report
		FROM smg_students s
		INNER JOIN smg_users u ON s.arearepid = u.userid
		INNER JOIN smg_programs p ON s.programid = p.programid
		inner join smg_program_type pt ON pt.programtypeid = p.type
		WHERE s.active = '1'
			AND u.usertype < 8
			AND s.companyid = '#client.companyid#'
			AND p.startdate < #now()# 
		  	AND ADDDATE(p.enddate, INTERVAL 2 MONTH ) > #now()#  
			<cfif url.regionid is "All"><cfelse>
				AND s.regionassigned = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif client.usertype EQ 6>
				<cfquery name="get_reps" datasource="caseusa">
					SELECT DISTINCT userid 
					FROM user_access_rights
					WHERE advisorid = '#client.userid#' AND companyid = '#client.companyid#'
				</cfquery>
				<cfif get_reps.recordcount NEQ '0'>
				AND (s.arearepid = 
					<cfloop query="get_reps">
					#userid# <cfif get_reps.currentrow eq #get_reps.recordcount#><cfelse> or s.arearepid = </cfif>
					</cfloop>)
				<cfelse>
					AND s.arearepid = '#client.userid#'
				</cfif>
			</cfif>
		ORDER BY u.lastname, u.userid, s.familylastname 
	</Cfquery> 
	<!--- GET USERTYPE --->
	<cfquery name="get_user_region" datasource="caseusa"> 
		SELECT user_access_rights.regionid, user_access_rights.usertype, u.usertype as user_access
		FROM user_access_rights
		INNER JOIN smg_usertype u ON  u.usertypeid = user_access_rights.usertype
		WHERE user_access_rights.regionid = <cfqueryparam value="#url.regionid#" cfsqltype="cf_sql_integer">
			  AND userid = '#client.userid#'
	</cfquery>  
	<cfset client.usertype = #get_user_region.usertype#>
</cfif>



<!--- Number of rows to display per Next/Back page --->
<cfset rowsPerPage = 5>

<!--- What row to start at? Assume first by default --->
<cfparam name="URL.startRow" default="1" type="numeric">

<!--- We know the total number of rows from query --->
<cfset totalRows = rd_students.recordCount>

<!--- Last row is 10 rows past the starting row, or --->
<!--- total number of query rows, whichever is less --->
<cfset endRow = min(URL.startRow + rowsPerPage - 1, totalRows)>

<!--- Next button goes to 1 past current end row --->
<cfset startRowNext = endRow + 1>

<!--- Back button goes back N rows from start row --->
<cfset startRowBack = URL.startRow - rowsPerPage>



<!----Filter for month---->
<cfoutput>
	<form name="formmonth">
		Limit Report to the following month:<br>
		<select name="month" onChange="javascript:formHandler2()">
		
		<option value="?curdoc=forms/approve_list&rmonth=0&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '0'>selected</cfif>>All</option>
		<option value="?curdoc=forms/approve_list&rmonth=10&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '10'>selected</cfif>>October</option>
		<option value="?curdoc=forms/approve_list&rmonth=12&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '12'>selected</cfif>>December</option>
		<option value="?curdoc=forms/approve_list&rmonth=2&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '2'>selected</cfif>>February</option>
		<option value="?curdoc=forms/approve_list&rmonth=4&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '4'>selected</cfif>>April</option>
		<option value="?curdoc=forms/approve_list&rmonth=6&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '6'>selected</cfif>>June</option>
		<option value="?curdoc=forms/approve_list&rmonth=8&regionid=#regionid#&RequstTimeout=300" <cfif url.rmonth is '8'>selected</cfif>>August</option>
		</select>
	</form>
	</cfoutput>
<!--- REGIONS DROP DOWN LIST --->
<cfoutput>
<cfif list_regions.recordcount lte 1><Cfelse>
	<form name="form">
		You have access to multiple regions filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '3'>
		<option value="?curdoc=forms/approve_list&regionid=all&month=#url.rmonth#&RequstTimeout=300" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=forms/approve_list&regionid=#regionid#&month=#url.rmonth#&RequstTimeout=300" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
		</cfloop>
		</select>
	</form>
</cfif> 
	<cfif client.usertype GTE 5> &nbsp; &nbsp; Access Level : &nbsp; #get_user_region.user_access#  </cfif><br>
</cfoutput>

<cfif #url.rmonth# eq 0>

			<table cellpadding = 2 cellspacing = 4 width=100%>
			<tr><td bgcolor="CCCCCC" colspan=2><span class="get_attention"><b>></b></span> Progress Reports to Approve</u></td></tr>
			<tr>
				<td valign="top" colspan=2>
				<cfif rd_students.recordcount is 0>
					<div align="center">There are no placed students under your supervision. #url.rmonth#</div>
				<cfelse>
					<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
						<tr bgcolor="ABADFC">
							<td width="2%">&nbsp;</td>
							<td width="38%">Student Name (id)</td>
							<td width="10%">Oct </td>
							<td width="10%">Dec </td>
							<td width="10%">Feb</td>
							<td width="10%">April</td>
							<td width="10%">June</td>
							<td width="10%">Aug</td> 			
						</tr>
						<cfoutput query="rd_students" group="userid" maxrows="#maxr#" startrow="#url.startrow#">
						<Cfset prevrep = 0>
						<Cfset currentrep = #userid#>
						<cfif currentrep NEQ #prevrep#>
							<tr><td colspan=8 bgcolor="F0F0F0">#rep_firstname# #rep_lastname#</td></tr>
							<cfoutput>
							<tr>
								<td>&nbsp;</td>
								<td><a href="student_profile.cfm?studentid=#rd_students.studentid#" target=top>#firstname# #familylastname# (#studentid#)</a></td>
								<!----Oct---->
								<td>
									<cfquery name="october_reports" datasource="caseusa">
										SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
											doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly,
											doc.month_of_report as docmonth, prquestion.month_of_report as questionmonth
										FROM smg_prquestion_details prquestion
										INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
										WHERE prquestion.stuid = '#studentid#'
											AND (doc.month_of_report = '10' or prquestion.month_of_report = '10')
										ORDER BY prquestion.submit_type DESC 
									</cfquery>		
									<cfif october_reports.submit_type EQ 'offline'>
										<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#">0</font></a>	
									<cfelse>
										<cfif rd_students.type EQ 4 or rd_students.type EQ 5>
											N/A
										<Cfelseif DateFormat(rd_students.startdate, 'mm') gt 9 and DateFormat(rd_students.startdate, 'mm') lt 11 and (rd_students.type neq 2 and rd_students.type neq 4)>
											N/A
										<cfelse>
											<cfif october_reports.recordcount EQ 0>
												<cfif DateFormat(now(), 'mm') EQ 9 OR DateFormat(now(), 'mm') EQ 10 OR DateFormat(now(), 'mm') is 11>
													<font color="blue">D</font>
												<cfelse>
													U
												</cfif>
											<cfelse>
												<cfif october_reports.date_rejected is not ''>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
												<cfelseif october_reports.ny_accepted is not ''>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
												<cfelseif october_reports.date_rd_approved is not ''>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></font></a>
												<cfelseif october_reports.date_rd_approved is '' and client.usertype EQ 5>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif october_reports.date_ra_approved is '' and client.usertype EQ 6>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif october_reports.date_rd_approved is '' and client.usertype EQ 6>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif october_reports.date_ra_approved is '' and client.usertype EQ 5>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif october_reports.ny_accepted is '' and october_reports.date_rd_approved EQ ''>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
												<cfelse>
													<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #october_reports.report_number#"><font color="660000">P</font></a>
												</cfif>
											</cfif>
										</cfif>
									</cfif>
								</td>
								
								<!----Dec---->
								<td>
									<cfquery name="december_reports" datasource="caseusa">
										SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
											doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly,
											doc.month_of_report as docmonth, prquestion.month_of_report as questionmonth
										FROM smg_prquestion_details prquestion
										INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
										WHERE prquestion.stuid = '#studentid#'
											AND (doc.month_of_report = '12' or prquestion.month_of_report = '12')
										ORDER BY prquestion.submit_type DESC 
									</cfquery>
									<cfif december_reports.submit_type EQ 'offline'>
										<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#">0</font>		
									<cfelse>
										<cfif rd_students.type EQ 4 or rd_students.type EQ 5>
											N/A
										<cfelseif DateFormat(rd_students.startdate, 'mm') gte 11 and (rd_students.type neq 2 and rd_students.type neq 4)>
											N/A
										<cfelse>
											<cfif december_reports.recordcount EQ 0>
												<cfif DateFormat(now(), 'mm') is 11 or dateFormat(now(), 'mm') is 12 or dateFormat(now(), 'mm') is 1>
													<font color="blue">D</font>
												<cfelse>
													U
												</cfif>
											<cfelse>
												<cfif december_reports.date_rejected is not ''>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="red">R</font></a>
												<cfelseif december_reports.ny_accepted is not ''>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="green">A</font></a>
												<cfelseif december_reports.date_rd_approved is not ''>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></a></font>
												<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 5>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 6>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 6>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 5>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif december_reports.ny_accepted is '' and december_reports.date_rd_approved is ''>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="orange">P</font></a>
												<cfelse>
													<a href="?curdoc=forms/view_progress_report&number=#december_reports.report_number#&regionid=#regionid#" title="View Report Number #december_reports.report_number#"><font color="660000">P</font></a>
												</cfif>
											</cfif>
										</cfif>
									</cfif>									
								</td>
								
								<!----Feb---->
								<td>
									<Cfif DateFormat(rd_students.startdate, 'mm') lt 7 and rd_students.aug_report eq 0>
										N/A
									<cfelse>
										<cfquery name="february_reports" datasource="caseusa">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
												doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
											WHERE prquestion.stuid = '#studentid#'
												AND doc.month_of_report = '2'
										</cfquery>				
									<cfif february_reports.submit_type EQ 'offline'>
										<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#">0</font>	
									<cfelse>	
										<cfif february_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 1 or dateFormat(now(), 'mm') is 2><font color="blue">D</font></a><cfelseif (rd_students.type neq 2 and rd_students.type neq 4)>N/A<cfelse>U</cfif>
										<cfelse>
											<cfif february_reports.saveonly eq 1>
												S
											<cfelseif february_reports.date_rejected is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="red">R</font></a>
											<cfelseif february_reports.ny_accepted is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="green">A</font></a>
											<cfelseif february_reports.date_rd_approved is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></a></font>
											<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif february_reports.ny_accepted is '' and february_reports.date_rd_approved is ''>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>
											<cfelse>
												<a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
											<!----
											<cfif february_reports.saveonly eq 1>S
											<cfelseif february_reports.date_rejected is not ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="red">R</font></a>
											<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
											<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">W</font>
											<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 6><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font>
											<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 5><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">P</font>
											<cfelseif february_reports.ny_accepted is  ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif february_reports.ny_accepted is not ''><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="green">A</font></a>
											<cfelse><a href="?curdoc=forms/view_progress_report&number=#february_reports.report_number#&regionid=#regionid#" title="View Report Number #february_reports.report_number#"><font color="660000">P</font>
												</cfif>
											---->
										</cfif>
									</cfif>
								</cfif>
								</td>
								
								<!----April---->
								<td>
									<Cfif DateFormat(rd_students.startdate, 'mm') lt 7 and (rd_students.type neq 4 and rd_students.type neq 2 and rd_students.type neq 5)>
										N/A
									<cfelse>
										<cfquery name="april_reports" datasource="caseusa">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
												doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
											WHERE prquestion.stuid = '#studentid#'
												AND doc.month_of_report = '4'
										</cfquery>
										<cfif april_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 3 or dateFormat(now(), 'mm') is 4 or dateFormat(now(), 'mm') is 5>
												<font color="blue">D</font></a>
											<cfelse>
												U
											</cfif>
										<cfelse>
											<cfif april_reports.date_rejected is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="red">R</font></a>
											<cfelseif april_reports.saveonly eq 1>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#"><font color="orange">S</font>
												
											<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif april_reports.ny_accepted is  ''>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif april_reports.ny_accepted is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#&regionid=#regionid#" title="View Report Number #april_reports.report_number#"><font color="green">A</font></a>
											<cfelse>
												<a href="?curdoc=forms/view_progress_report&number=#april_reports.report_number#" title="View Report Number #april_reports.report_number#&regionid=#regionid#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
								
								<!----June---->
								<td>
								
									<Cfif DateFormat(rd_students.startdate, 'mm') lte 7 and (rd_students.type neq 4 and rd_students.type neq 2 and rd_students.type neq 5)>N/A<cfelse>
										<cfquery name="june_reports" datasource="caseusa">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
												doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
											WHERE prquestion.stuid = #studentid#
												AND doc.month_of_report = '6'
										</cfquery>
									<cfif june_reports.submit_type EQ 'offline'>
										<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#">0</font>	
									<cfelse>	
										<cfif june_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 6 or dateFormat(now(), 'mm') is 7>
												<font color="blue">D</font></a>
											<cfelse>
												U 
											</cfif>
										<cfelse>
											<cfif june_reports.date_rejected is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="red">R</font></a>
											<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#october_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif june_reports.saveonly eq 1>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">S</font>
												
											<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif june_reports.ny_accepted is  ''>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif june_reports.ny_accepted is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="green">A</font></a>
											<cfelse>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#&regionid=#regionid#" title="View Report Number #june_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>		
								</cfif>			
								</td>
								
								<!----Aug---->
								<td>
								<Cfif rd_students.type neq 2>N/A<cfelse>
									<Cfif DateFormat(rd_students.startdate, 'mm') lt 7 or rd_students.type neq 2>N/A<cfelse>
										<cfquery name="august_reports" datasource="caseusa">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
												doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
											WHERE prquestion.stuid = '#studentid#'
												AND doc.month_of_report = '8'
										</cfquery>
										<cfif august_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 7 or dateFormat(now(), 'mm') is 8>
												<font color="blue">D</font></a>
											<cfelse>
												U
											</cfif>
										<cfelse>
											<cfif august_reports.date_rejected is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="red">R</font></a>
											<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="orange">W</font>
											<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="orange">W</font>
											<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="orange">P</font>
											<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="orange">P</font>
											<cfelseif august_reports.ny_accepted is  ''>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif august_reports.ny_accepted is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="green">A</font></a>
											<cfelse>
												<a href="?curdoc=forms/view_progress_report&number=#august_reports.report_number#&regionid=#regionid#" title="View Report Number #august_reports.report_number#"><font color="660000">P</font>
											</cfif>
										</cfif>
									</cfif>
								</cfif>
								</td> 			
							</tr>
							</cfoutput>
						</cfif> 	
						</cfoutput>	
					</table>
				</cfif>
				</td>
			</table>

<cfelse>
<cfif url.rmonth eq 10>
	<cfset rmonth="October">
<cfelseif url.rmonth eq 12>
	<cfset rmonth="December">
<cfelseif url.rmonth eq 2>
	<cfset rmonth="February">
<cfelseif url.rmonth eq 4>
	<cfset rmonth="April">
<cfelseif url.rmonth eq 6>
	<cfset rmonth="June">
<cfelseif url.rmonth eq 8>
	<cfset rmonth="August">
</cfif>

<cfset next_month=#url.rmonth# +1>


			<table cellpadding = 2 cellspacing = 4 width=100%>
			<tr><td bgcolor="CCCCCC" colspan=2><span class="get_attention"><b>></b></span> Progress Reports to Approve</u></td></tr>
			<tr>
				<td valign="top" colspan=2>
				<cfif rd_students.recordcount is 0>
					<div align="center">There are no placed students under your supervision. <cfoutput>#rmonth# #url.rmonth#</cfoutput></div>
				<cfelse>
					<cfoutput>
					<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
						<tr bgcolor="ABADFC">
							<td width="2%">&nbsp;</td>
							<td width="38%">Student Name (id)</td>
							<td width="10%">#rmonth#</td>
							<td width="10%"> </td>
							<td width="10%"></td>
							<td width="10%"></td>
							<td width="10%"></td>
							<td width="10%"></td> 			
						</tr>
						</cfoutput>
						<cfoutput query="rd_students" group="userid" maxrows="#maxr#" startrow="#url.startrow#">
						<Cfset prevrep = 0>
						<Cfset currentrep = #userid#>
						<cfif currentrep NEQ #prevrep#>
							<tr><td colspan=8 bgcolor="F0F0F0">#rep_firstname# #rep_lastname#</td></tr>
							<cfoutput>
							<tr>
								<td>&nbsp;</td>
								<td><a href="student_profile.cfm?studentid=#rd_students.studentid#" target=top>#firstname# #familylastname# (#studentid#)</a></td>
								<!----Reports---->
								<td>
							<cfif rd_students.aug_report neq 1 and url.rmonth eq 7>N/A<cfelse>
								<Cfif DateFormat(rd_students.startdate, 'mm') lt 7 and (rd_students.type neq 4 and rd_students.type neq 2 and rd_students.type neq 5)>
										N/A 
									<cfelse>
										<cfquery name="single_reports" datasource="caseusa">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
												doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
											WHERE prquestion.stuid = '#studentid#'
												AND doc.month_of_report = '#url.rmonth#'
										</cfquery>
										<cfif single_reports.submit_type EQ 'offline'>
										<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#">0</font>	
									<cfelse>	
										<cfif single_reports.recordcount eq 0>
										<cfif #url.rmonth# eq 1>
											<cfset prev_month = 12>
										<cfelse>
											<cfset prev_month = #url.rmonth# - 1>
										</cfif>
										
										
											<cfif DateFormat(now(), 'mm') is #url.rmonth# or dateFormat(now(), 'mm') is #next_month# or DateFormat(now(), 'mm') is #prev_month#>
												<font color="blue">D</font></a>
											<cfelse>
												U
											</cfif>
										<cfelse>
										
																			
										
										
										
											<cfif single_reports.date_rejected is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="red">R</font></a>
											<cfelseif single_reports.saveonly eq 1>
												<font color="orange">S</font>
											<cfelseif single_reports.ny_accepted is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="green">A</font></a>
											<cfelseif single_reports.date_rd_approved is not ''>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></a></font>
											<cfelseif single_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif single_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif single_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif single_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif single_reports.ny_accepted is  ''>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">H</font></a>
											
											<cfelse>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#" title="View Report Number #single_reports.report_number#&regionid=#regionid#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</cfif>
								</cfif><cfset client.page.next5start = #rd_students.currentrow# +1>
									</td> 			
							</tr>
							</cfoutput>
						</cfif> 	
						</cfoutput>	
					</table>
				</cfif>
			
				</td>
			</table>
</cfif>

<!--- Provide Next/Back links --->
<cfoutput>
 
 <!--- Show link for Back, if appropriate --->
 <cfif startRowBack gt 0>
  <a href="index.cfm?curdoc=forms/approve_list&regionid=#url.regionid#&month=#url.month#&startrow=#client.page.previous5start#">

 <img src="../images/BrowseBack.gif" 
 alt="Previous #rowsPerPage# Reps" border="0" align="left"></a>
 </cfif>
 
 <!--- Show link for Next, if appropriate --->
 <cfif startRowNext lte totalRows>
 <a href="index.cfm?curdoc=forms/approve_list&regionid=#url.regionid#&month=#url.month#&startrow=#client.page.next5start#&previous=#client.page.previous5start#">
 <img src="http://www.student-mangement.com/nsmg/pics/next_record.gif" 
 alt="Next #rowsPerPage# Reps" border="0" align="right"></a>
 </cfif>
</cfoutput>
<cfif rd_students.recordcount NEQ '0'>
<br><div align="center">Click on Status icon to view report.  Depending on status, various options will be available.</div><br>
<table align="center" cellspacing=0 cellpadding="2">
	<th align="center" colspan=2 bgcolor="CC0000"><font color="white">Status Icon Key</th>
	<tr>
		<td valign="top" bgcolor="ededed"><font size=-2><u>N/A</u> - doesn't apply to student<br>
			<u>U</u> - Reports will be due soon<br>
			<u>D</u> - Reports is Due, has not been submitted <br>
			<u><font color="660000">P</font></u> - Report is waiting for approval<br>
			<u>O</u> - Report was submitted offline</td>
		<td valign="top" bgcolor="ededed">
			<font size=-2>
			<u><font color="orange">W</font></u> - You need to approve this report <br>
			<u><font color="orange">H</font></u> - Headquarters needs to approve <br>
			<u><font color="green">A</font></u> - Report has been approved<br>
			<u><font color="red">R</font></u> - Report has been rejected<br>
			<u>S</u> - info recorded; not ready for approval.
			</font>
		</td>
	</tr>
</table><br>
</cfif>		