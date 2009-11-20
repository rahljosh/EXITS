<cfsetting requesttimeout="300">

<cfif NOT isDefined('url.rmonth')>
<!--- SET THE CURRENT PROGRESS REPORT --->
	<cfif DateFormat(now(), 'mm') EQ 8 OR dateFormat(now(), 'mm') EQ 9> 
		<cfset url.rmonth = 9> <!--- SEPT --->
	<cfelseif DateFormat(now(), 'mm') EQ 11 OR dateFormat(now(), 'mm') EQ 12> 
		<cfset url.rmonth = 12> <!--- DEC --->

	<cfelseif DateFormat(now(), 'mm') eq 3 OR dateFormat(now(), 'mm') EQ 4> 
		<cfset url.rmonth = 4> <!--- APRIL --->

	</cfif>
</cfif>

<!--- REPORTS PER PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 1
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 2
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 3
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 4
	
	PRIVATE HIGH SCHOOL PROGRAM
	10 MONTH - OCT - DEC - FEB - APRIL - JUNE - TYPE = 5
	12 MONTH - FEB - APRIL - AUG - OCT - DEC - TYPE = 24
	1ST SEMESTER - OCT - DEC - FEB - TYPE = 25
	2ND SEMESTER - FEB - APRIL - JUNE - TYPE = 26
---->

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


<!----
<!----Next N records---->
<cfif isDefined('url.sas')>
	<cfset maxr = 500>
<cfelse>
	<cfset maxr=5>
</cfif>

<cfif isDefined('url.clearpage')>
	<cfset next5start = 1>
	<cfset previous5start = 1>
</cfif>
<cfparam name="previous5start" default="1">

<cfparam name="next5start" default="1">

<cfif next5start gt 1>
	<cfset previous5start = #next5start#>
</cfif>
---->
<span class="application_section_header">Progress Report Status</span><br><br>



<!----
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
<cfif maxr eq 500>
	<a href="?curdoc=forms/approve_list&RequestTimeout=240">Show in groups of 5</a>
<cfelse>
<a href="?curdoc=forms/approve_list&RequestTimeout=240&sas">Show all reps</a>
</cfif>
---->
<cfoutput>
	<form name="formmonth">
		Limit Report to the following month:<br>
		<select name="month" onChange="javascript:formHandler2()">
		<option value="?curdoc=forms/approve_list&rmonth=0&clearpage=0" <cfif url.rmonth is '0'>selected</cfif>>All</option>
		<option value="?curdoc=forms/approve_list&rmonth=9&clearpage=0" <cfif url.rmonth is '9'>selected</cfif>>September</option>
		<option value="?curdoc=forms/approve_list&rmonth=12&clearpage=0" <cfif url.rmonth is '12'>selected</cfif>>December</option>

		<option value="?curdoc=forms/approve_list&rmonth=4&clearpage=0" <cfif url.rmonth is '4'>selected</cfif>>April</option>

		</select>
	</form>
</cfoutput>
<cfoutput>

<cfquery name="rd_students" datasource="mysql">

</cfquery>

<!--- REGIONS DROP DOWN LIST --->

<!----
<cfoutput>
<cfif list_regions.recordcount GT 1>
	<form name="form">
		You have access to multiple regions filter by region:
		<select name="sele_region" onChange="javascript:formHandler()">
		<cfif client.usertype LTE '3'>
		<option value="?curdoc=forms/approve_list&regionid=all&rmonth=#url.rmonth#" <cfif url.regionid is 'all'>selected</cfif>>All</option>
		</cfif>
		<cfloop query="list_regions">
			<option value="?curdoc=forms/approve_list&regionid=#regionid#&rmonth=#url.rmonth#" <cfif url.regionid is #regionid#>selected</cfif>>#regionname#</option>
		</cfloop>
		</select>
	</form>
</cfif> 
	<cfif client.usertype GTE 5> &nbsp; &nbsp; Access Level : &nbsp; #get_user_region.user_access#  </cfif><br>
</cfoutput>
---->
<!--- ALL --->
<cfif url.rmonth EQ 0>
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
						<td width="38%">Student Name (ID)</td>
						<td width="10%">Oct </td>
						<td width="10%">Dec </td>
						<td width="10%">Feb</td>
						<td width="10%">April</td>
						<td width="10%">June</td>
						<td width="10%">Aug</td> 			
					</tr>
					
				
					<Cfset prevrep = 0>
					<Cfset currentrep = #userid#>
					<cfif currentrep NEQ #prevrep#>
						<tr><td colspan=8 bgcolor="F0F0F0">#rep_firstname# #rep_lastname#</td></tr>
						<cfoutput>
						<tr>
							<td>&nbsp;</td>
							<td><a href="student_profile.cfm?uniqueid=#rd_students.uniqueid#" target="top">#firstname# #familylastname# (#studentid#)</a></td>
							<!----Oct---->
							<td>
								<cfquery name="october_reports" datasource="MySQL">
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
										n/a
									<Cfelseif DateFormat(rd_students.startdate, 'mm') gt 9 and DateFormat(rd_students.startdate, 'mm') lt 11 and (rd_students.type neq 2 and rd_students.type neq 4)>
										n/a
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
								<cfquery name="december_reports" datasource="MySQL">
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
										n/a
									<cfelseif DateFormat(rd_students.startdate, 'mm') gte 11 and (rd_students.type neq 2 and rd_students.type neq 4)>
										n/a
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
							
						
							
							<!----April---->
							<td>
								<Cfif DateFormat(rd_students.startdate, 'mm') lt 7 and (rd_students.type neq 4 and rd_students.type neq 2 and rd_students.type neq 5)>
									n/a
								<cfelse>
									<cfquery name="april_reports" datasource="MySQL">
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
							
						
						</tr>
						</cfoutput>
					</cfif> 	
					</cfoutput>	
				</table>
			</cfif>
			</td>
		</table>

<!--- ONE REPORT ONLY --->
<cfelse>
	
	<!----
	<cfif client.userid eq 10211>
	<cfdump var="#rd_students#">
	<cfdump var="#client#">
	<cfdump var="#get_reps#">
	</cfif>
	---->
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
			<cfif rd_students.recordcount EQ 0>
				<div align="center">There are no placed students under your supervision. </div>
			<cfelse>
				<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
					<cfoutput>
					<tr bgcolor="ABADFC">
						<td width="2%">&nbsp;</td>
						<td width="38%">Student Name (id)</td>
						<td width="10%">#rmonth#</td>
						<td width="10%"></td>
						<td width="10%"></td>
						<td width="10%"></td>
						<td width="10%"></td>
						<td width="10%"></td> 			
					</tr>
					</cfoutput>
					<cfoutput query="rd_students" group="userid">
						<Cfset prevrep = 0>
						<Cfset currentrep = userid>
						
						<cfif currentrep NEQ prevrep>
							<tr><td colspan=8 bgcolor="F0F0F0">#rep_firstname# #rep_lastname# #usertype#</td></tr>
							<cfoutput>
							<tr>
								<td>&nbsp;</td>
								<td><a href="student_profile.cfm?uniqueid=#rd_students.uniqueid#" target=top>#firstname# #familylastname# (#studentid#)</a></td>
								<!----Reports---->
								<td>
									<!--- OCT / DEC - 10M, 12M and 1st semester --->
									<cfif (url.rmonth EQ 10 OR url.rmonth EQ 12) AND (type NEQ 1 AND type NEQ 2 AND type NEQ 3 AND type NEQ 5 AND type NEQ 24 AND type NEQ 25)>									
										n/a
									<!--- FEB - ALL PROGRAMS --->
									
									<!--- APRIL / JUNE - 10M, 12M and 2nd Semester --->
									<cfelseif (url.rmonth EQ 4 OR url.rmonth EQ 5) AND (type NEQ 1 AND type NEQ 2 AND type NEQ 4 AND type NEQ 5 AND type NEQ 24 AND type NEQ 26)>
										n/a
									<!--- AUG - 12M --->
									<cfelseif url.rmonth EQ 8 AND (type NEQ 2 AND type NEQ 24)>
										n/a
									<cfelse>
										<cfquery name="single_reports" datasource="MySQL">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, prquestion.submit_type,
												doc.date_ra_approved, doc.date_rd_approved, doc.ny_accepted, doc.date_rejected, doc.saveonly,
												doc.month_of_report as docmonth, prquestion.month_of_report as questionmonth
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking doc ON doc.report_number = prquestion.report_number
											WHERE prquestion.stuid = '#studentid#'
												AND (doc.month_of_report = '#url.rmonth#' or prquestion.month_of_report = '#url.rmonth#')
											ORDER BY prquestion.submit_type DESC											
										</cfquery>
										<cfif single_reports.submit_type EQ 'offline'>
											<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><cfif single_reports.ny_accepted NEQ ''>A<cfelse>O</cfif></a>	
										<cfelse>	
											<cfif single_reports.recordcount EQ 0>
												<cfif url.rmonth EQ 1>
													<cfset prev_month = 12>
												<cfelse>
													<cfset prev_month = url.rmonth - 1>
												</cfif>
												<cfif DateFormat(now(), 'mm') EQ url.rmonth OR dateFormat(now(), 'mm') EQ next_month OR DateFormat(now(), 'mm') EQ prev_month OR DateFormat(now(), 'mm') EQ 12>
													<font color="blue">D</font></a>
												<cfelse>
													U
												</cfif>
											<cfelse>
												<cfif single_reports.date_rejected NEQ ''>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="red">R</font></a>
												<cfelseif single_reports.saveonly EQ 1>
													<font color="orange">S</font>
												<cfelseif single_reports.ny_accepted NEQ ''>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="green">A</font></a>
												<cfelseif single_reports.date_rd_approved NEQ ''>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange"><cfif client.usertype eq 4>W<cfelse>H</cfif></a></font>
												<cfelseif single_reports.date_rd_approved EQ '' and client.usertype EQ 5>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif single_reports.date_ra_approved EQ '' and client.usertype EQ 6>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">W</font></a>
												<cfelseif single_reports.date_rd_approved EQ '' and client.usertype EQ 6>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">P</font></a>
												<cfelseif single_reports.date_ra_approved EQ '' and client.usertype EQ 5>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">P</font></a>
												<!--- HEADQUARTERS WERE APPROVING THAN BEFORE THE RD'S APPROVAL.											
												<cfelseif single_reports.ny_accepted EQ ''>
												<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#&regionid=#regionid#" title="View Report Number #single_reports.report_number#"><font color="orange">H</font></a>
												--->
												<cfelse>
													<a href="?curdoc=forms/view_progress_report&number=#single_reports.report_number#" title="View Report Number #single_reports.report_number#&regionid=#regionid#"><font color="660000">P</font></a>
												</cfif>
											</cfif>
										</cfif>
									</cfif>
								<cfset next5start = #rd_students.currentrow# +1>
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
<!----
<!--- Provide Next/Back links --->
<cfoutput>
 
 <!--- Show link for Back, if appropriate --->
 <cfif startRowBack gt 0>
  <a href="index.cfm?curdoc=forms/approve_list&regionid=#url.regionid#&rmonth=#url.rmonth#&startrow=#previous5start#">

 <img src="pics/prev5.jpg" 
 alt="Previous #rowsPerPage# Reps" border="0" align="left"></a>
 </cfif>
 
 <!--- Show link for Next, if appropriate --->
 
 <cfif maxr eq 500>
	<a href="?curdoc=forms/approve_list&RequestTimeout=240">Show in groups of 5</a>
<cfelse>

 <cfif startRowNext lte totalRows>
 <a href="index.cfm?curdoc=forms/approve_list&regionid=#url.regionid#&rmonth=#url.rmonth#&startrow=#next5start#&previous=#previous5start#">
 <img src="http://www.student-management.com/nsmg/pics/next5.jpg" 
 alt="Next #rowsPerPage# Reps" border="0" align="right"></a>
 </cfif>
</cfif>
</cfoutput>
---->
<cfif rd_students.recordcount NEQ '0'>
<br><div align="center">Click on Status icon to view report.  Depending on status, various options will be available.</div><br>
<table align="center" cellspacing=0 cellpadding="2">
	<th align="center" colspan=2 bgcolor="CC0000"><font color="white">Status Icon Key</th>
	<tr>
		<td valign="top" bgcolor="ededed"><font size=-2><u>n/a</u> - doesn't apply to student<br>
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