<table cellpadding=2 cellspacing=4 width=100% bgcolor="##ffffe6">
				<tr><td bgcolor="##e2efc7" colspan=2><span class="get_attention"><b>:: </b></span>Student Progress Reports</td></tr>
				<tr>
					<td valign="top" colspan=2>
					<cfif current_students_status.recordcount is 0><br>
						<div align="center">You are not supervising any students, no reports to fill out.</div>
					<Cfelse>
						<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
							<tr bgcolor="ABADFC">
								<td width=35%>Student Name (id)</td><td width=13%>Oct</td><td width=13%>Dec </td><td width=13%>Feb</td><td width=13%>April</td><td width=13%>June</td><td width=13%>July</td> 	 			
							</tr>
							<Cfloop query="current_Students_Status">
							<tr>
								<td><A href="index.cfm?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname# (#studentid#)</A></td>
								<!----Oct---->
								<td>
									<!----Check for Offline Reports---->
									<cfquery name="check_oct_offline" datasource="mysql">
										select report_number
										from smg_prquestion_details
										where submit_type = 'offline' and month_of_report = 10
										and stuid = #studentid# 
									</cfquery>
									<cfif check_oct_offline.recordcount gt 0>
										<a href="?curdoc=forms/view_progress_report&number=#check_oct_offline.report_number#" title="View Report Number #check_oct_offline.report_number#">0</font>		
									<cfelse>
										<cfquery name="october_reports" datasource="MySQL">
											SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
												dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
												dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
											FROM smg_prquestion_details prquestion
											INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
											WHERE stuid = '#studentid#'
												AND dt.month_of_report = 10											
										</cfquery>
										<!--- OCT - 10M, 12M and 1st semester --->
										<cfif october_reports.recordcount EQ 0>																															
											<cfif DateFormat(now(), 'mm') GTE 8 AND dateFormat(now(), 'mm') LTE 11 AND (type EQ 1 OR type EQ 2 OR type EQ 3 OR type EQ 5 OR type EQ 24 OR type EQ 25)>
												<font color="blue"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=10">D</a></font></a>
											<cfelse>
												U
											</cfif>
										<cfelse>
											<cfif october_reports.date_rejected is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
											<cfelseif october_reports.saveonly eq 1><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">S</font></a>
											<cfelseif october_reports.ny_accepted is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
											<cfelseif october_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif october_reports.date_ra_approved is '' and client.usertype eq 6><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif october_reports.date_rd_approved is '' and client.usertype eq 6><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif october_reports.date_ra_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif october_reports.ny_accepted is  ''><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
											<cfelse><a href="" title="View Report Number #october_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
																	
								<!----Dec---->							
								<td>
									<cfquery name="december_reports" datasource="MySQL">
										SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
											dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
											dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
										FROM smg_prquestion_details prquestion
										INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
										WHERE stuid = '#studentid#'
											AND dt.month_of_report = '12'											
									</cfquery>
									<!--- DEC - 10M, 12M and 1st semester --->
									<cfif december_reports.recordcount eq 0>
										<cfif DateFormat(now(), 'mm') GTE 10 AND dateFormat(now(), 'mm') LTE 12 OR DateFormat(now(),'mm') EQ 1 AND (type EQ 1 OR type EQ 2 OR type EQ 3 OR type EQ 5 OR type EQ 24 OR type EQ 25)>
											<A href=""><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=12">D</a></font></a>
										<cfelse>
											U
										</cfif>
									<cfelse>
										<cfif december_reports.date_rejected is not ''><a href="" title="View Report Number #december_reports.report_number#"><font color="red">R</font></a>
										<cfelseif december_reports.saveonly eq 1><a href="" title="View Report Number #december_reports.report_number#"><font color="orange">S</font></a>
										<cfelseif december_reports.ny_accepted is not ''><a href="" title="View Report Number #december_reports.report_number#"><font color="green">A</font></a>
										<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
										<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 6><a href="" title="View Report Number #december_reports.report_number#"><font color="orange">W</font></a>
										<cfelseif december_reports.date_rd_approved is '' and client.usertype eq 6><a href="" title="View Report Number #december_reports.report_number#"><font color="orange">P</font></a>
										<cfelseif december_reports.date_ra_approved is '' and client.usertype eq 5><a href="" title="View Report Number #december_reports.report_number#"><font color="orange">P</font></a>
										<cfelseif december_reports.ny_accepted is  ''><a href="" title="View Report Number #december_reports.report_number#"><font color="orange">H</font></a>
										<cfelse><a href="" title="View Report Number #december_reports.report_number#"><font color="660000">P</font></a>
										</cfif>
									</cfif>			
								</td>
									
								<cfif (client.userid NEQ 8246 or client.userid NEQ 8786)>
								<!----Feb---->
								<td>
								</a>
								<!----Check for Offline Reports---->
									<cfquery name="check_feb_offline" datasource="mysql">
										select report_number
										from smg_prquestion_details
										where submit_type = 'offline' and month_of_report = 2
										and stuid = #studentid# 
									</cfquery>
									<!--- FEB - ALL PROGRAMS --->
									<cfif check_feb_offline.recordcount gt 0>
										<a href="?curdoc=forms/view_progress_report&number=#check_feb_offline.report_number#" title="View Report Number #check_feb_offline.report_number#">0</font>		
									<cfelse>
										 <Cfif DateFormat(current_students_status.startdate, 'mm') lt 7 and current_students_status.type neq 2 and current_students_status.type neq 4  and current_students_status.type neq 5>N/A<cfelse>
											  <cfquery name="february_reports" datasource="MySQL">
													SELECT DISTINCT prquestion.stuid, prquestion.report_number, 
														dt.date_submitted, dt.saveonly, dt.date_ra_approved, dt.date_rd_approved,
														dt.ny_accepted, dt.date_rejected, dt.rejected_by, dt.note
													FROM smg_prquestion_details prquestion
													INNER JOIN smg_document_tracking dt ON dt.report_number = prquestion.report_number
													WHERE stuid = '#studentid#'
														AND dt.month_of_report = 2
											  </cfquery>
											  <cfif february_reports.recordcount eq 0>
													<cfif DateFormat(now(), 'mm') is 1 or  DateFormat(now(), 'mm') is 2 or DateFormat(now(), 'mm') is 3>
														<A href="?curdoc=forms/progress_report&stu=#studentid#&month=2"><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=2">D</a></font></a>
													<cfelse>
														U 
													</cfif>
											  <cfelse>
													<cfif february_reports.ny_accepted is not ''><a href="" title="View Report Number #february_reports.report_number#"><font color="green">A</font></a>
													<cfelseif february_reports.saveonly eq 1><a href="" title="View Report Number #february_reports.report_number#"><font color="orange">S</font></a>
													<cfelseif february_reports.date_rejected is not ''><a href="" title="View Report Number #february_reports.report_number#"><font color="red">R</font></a>
													<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
													<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 6><a href="" title="View Report Number #february_reports.report_number#"><font color="orange">W</font></a>
													<cfelseif february_reports.date_rd_approved is '' and client.usertype eq 6><a href="" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>
													<cfelseif february_reports.date_ra_approved is '' and client.usertype eq 5><a href="" title="View Report Number #february_reports.report_number#"><font color="orange">P</font></a>
													<cfelseif february_reports.ny_accepted is  ''><a href="" title="View Report Number #february_reports.report_number#"><font color="orange">H</font></a>
													<cfelse><a href="" title="View Report Number #february_reports.report_number#"><font color="660000">P</font></a>
													</cfif>
											   </cfif>
										</cfif>
									</cfif>
								</td>
								<!----Apr---->
								<td>
									<Cfif DateFormat(current_students_status.startdate, 'mm') lt 7 and current_students_status.type neq 2 and current_students_status.type neq 4 and current_students_status.type neq 5>N/A<cfelse>
										<cfquery name="april_reports" datasource="MySQL">
											select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
											smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved, smg_document_tracking.saveonly,
											smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
											from smg_prquestion_details, smg_document_tracking
											where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 4
										</cfquery>
										<cfif april_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 2 or DateFormat(now(), 'mm') is 3 or DateFormat(now(), 'mm') is 4 or  DateFormat(now(), 'mm') is 5><A href=""><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=4">D</a></font></a><cfelse>U</cfif>
										<cfelse>
											<cfif april_reports.date_rejected is not ''><a href="" title="View Report Number #april_reports.report_number#"><font color="red">R</font></a>
											<cfelseif april_reports.saveonly eq 1><a href="" title="View Report Number #april_reports.report_number#"><font color="orange">S</font></a>
											<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #april_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 6><a href="" title="View Report Number #april_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif april_reports.date_rd_approved is '' and client.usertype eq 6><a href="" title="View Report Number #april_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif april_reports.date_ra_approved is '' and client.usertype eq 5><a href="" title="View Report Number #april_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif april_reports.ny_accepted is  ''><a href="" title="View Report Number #april_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif april_reports.ny_accepted is not ''><a href="" title="View Report Number #april_reports.report_number#"><font color="green">A</font></a>
											<cfelse><a href="" title="View Report Number #april_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
								<!----June---->
								<td>
									<Cfif DateFormat(current_students_status.startdate, 'mm') lt 7 and current_students_status.type neq 2 and current_students_status.type neq 4 and current_students_status.type neq 5>N/A<cfelse>
										<cfquery name="june_reports" datasource="MySQL">
											select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
											smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
											smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note, smg_document_tracking.saveonly
											from smg_prquestion_details, smg_document_tracking
											where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 6
										</cfquery>
										<cfif june_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 5 or DateFormat(now(), 'mm') is 6 or DateFormat(now(), 'mm') is 7><A href=""><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=6">D</a></font></a><cfelse>U</cfif>
										<cfelse>
											<cfif june_reports.date_rejected is not ''>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="red">R</font></a>
											<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 5>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif june_reports.saveonly eq 1>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="orange">S</font>
											<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 6>
												<a href="?curdoc=forms/view_progress_report&number=#june_reports.report_number#" title="View Report Number #june_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif june_reports.date_rd_approved is '' and client.usertype eq 6>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif june_reports.date_ra_approved is '' and client.usertype eq 5>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif june_reports.ny_accepted EQ ''>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif june_reports.ny_accepted is not ''>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="green">A</font></a>
											<cfelse>
												<a href="" title="View Report Number #june_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
								<!----August---->
								<td>
									<Cfif current_students_status.aug_report eq 0 >N/A<cfelse>
										<cfquery name="august_reports" datasource="MySQL">
											select distinct smg_prquestion_details.stuid, smg_prquestion_details.report_number, 
											smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved,
											smg_document_tracking.ny_accepted, smg_document_tracking.date_rejected, smg_document_tracking.rejected_by, smg_document_tracking.note
											from smg_prquestion_details, smg_document_tracking
											where smg_document_tracking.report_number = smg_prquestion_details.report_number and stuid = #studentid# and smg_document_tracking.month_of_report = 8
										</cfquery>
										<cfif august_reports.recordcount eq 0>
											<cfif DateFormat(now(), 'mm') is 7 or DateFormat(now(), 'mm') is 8><A href=""><font color="0000ff"><a href="?curdoc=forms/progress_report&stu=#studentid#&month=8">D</a></font></a><cfelse>U</cfif>
										<cfelse>
											<cfif august_reports.date_rejected is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="red">R</font></a>
											<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 6><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">W</font></a>
											<cfelseif august_reports.date_rd_approved is '' and client.usertype eq 6><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif august_reports.date_ra_approved is '' and client.usertype eq 5><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">P</font></a>
											<cfelseif august_reports.ny_accepted is  ''><a href="" title="View Report Number #october_reports.report_number#"><font color="orange">H</font></a>
											<cfelseif august_reports.ny_accepted is not ''><a href="" title="View Report Number #october_reports.report_number#"><font color="green">A</font></a>
											<cfelse><a href="" title="View Report Number #october_reports.report_number#"><font color="660000">P</font></a>
											</cfif>
										</cfif>
									</cfif>
								</td>
							</cfif>
							</tr>
							</cfloop>
							<tr>
								<td colspan=7 align="center"> 
									<table align="center">
										<tr>
											<td><font size=-2><u>N/A</u> - doesn't apply to student</td><td><font size=-2><u>U</u> - Reports will be due soon</td><td><font size=-2><u><font color="0000FF">D</font></u> - Reports are due; click to submit</td>
										</tr>
										<tr>
											<td><font size=-2><u><font color="660000">P</font></u> - Report is processing</td><td><font size=-2><u><font color="red">R</font></u> - Report has been rejected</td><td><font size=-2><u><font color="green">A</font></u> - Report has been approved</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>