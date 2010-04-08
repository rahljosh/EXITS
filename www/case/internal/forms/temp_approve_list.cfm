<span class="application_section_header">Progress Report Status </span><br><br>

<Cfquery name="get_fac_regions" datasource="caseusa">
select regions from smg_users 
where userid = #client.userid#
</Cfquery>

<Cfoutput>
<cfloop list=#get_fac_regions.regions# index=x>

<Cfquery name=rd_students datasource="caseusa">
select smg_students.studentid, smg_students.regionassigned, smg_students.familylastname, smg_students.firstname, smg_students.programid,  smg_users.firstname as rep_firstname, smg_users.lastname as rep_lastname, smg_users.userid
from smg_students right join smg_users on smg_students.arearepid = smg_users.userid
where smg_students.regionassigned = #x#
<cfif client.usertype is 6>
and smg_users.advisor_id = #client.userid#
</cfif>
and smg_students.companyid = #client.companyid#
order by rep_lastname
</Cfquery> 


<!----<cfquery name="rd_students" datasource="caseusa">
select smg_students.studentid, smg_students.regionassigned, smg_students.familylastname, smg_students.firstname, smg_students.programid  from smg_students where regionassigned = #client.regions# and companyid = #client.companyid#
</cfquery>
---->
<Cfquery name="regionname" datasource="caseusa">
select regionname
from smg_regions
where regionid = #x#
</Cfquery>
<table cellpadding = 2 cellspacing = 4 width=100%>
	<tr>
		<td bgcolor="##CCCCCC" colspan=2><span class="get_attention"><b>></b></span>Progress Reports to Approve in the #regionname.regionname# region.</u></td>
	</tr>
	<tr>
		<td valign="top" colspan=2>
		<cfif rd_students.recordcount is 0>
		<div align="center">There are no placed students under your supervision.</div>
		<cfelse>
		
		<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
			<tr bgcolor="ABADFC">
				<td></td><td width=35%>Student Name (id)</td><td width=13%>Oct </td><td width=13%>Dec </td><td width=13%>Feb</td><td width=13%>April</td><td width=13%>June</td> 			
			</tr>

		<Cfset prevrep = 0>
		<Cfloop query="rd_students">
			<Cfset currentrep = #userid#>
			<cfif currentrep is #prevrep#>
			<cfelse>
		 	<tr>
				<td colspan=7 bgcolor="F0F0F0">#rep_firstname# #rep_lastname#</td>
			</tr>
			</cfif> 
			<cfif rd_students.recordcount is 0>
			<cfelse>
			<cfquery name="program_date" datasource="caseusa">
			select startdate, enddate
			from smg_programs 
			where programid = #rd_students.programid#
			</cfquery>
			<cfquery name="reports" datasource="caseusa">
			select distinct date, report_number 
			from smg_prquestion_Details
			where stuid = #rd_students.studentid#
			</cfquery>
			<tr>
			
			
				<td></td><td><a href="student_profile.cfm?studentid=#rd_students.studentid#" target=top>#rd_students.firstname# #rd_students.familylastname# (#rd_students.studentid#)</a></td>
				<!----Oct---->
				<td><Cfif DateFormat(program_date.startdate, 'mm') lt 7>N/A<cfelse>
				<cfif reports.recordcount is 0>
					<cfif DateFormat(now(), 'mm') is 9 or dateFormat(reports.date, 'mm') is 10><font color="blue">D</font></a><cfelse>U</cfif>
				<cfelse>
					<cfloop query=reports>
					<cfif dateFormat(reports.date, 'mm') is 9 or dateFormat(reports.date, 'mm') is 10>
						<cfquery name="get_status" datasource="caseusa">
						select date_ra_Approved, date_rd_approved, date_rejected
						from smg_document_tracking 
						where report_number = #report_number#
						</cfquery>
						<Cfif get_Status.recordcount is not  0>
							<Cfif get_Status.date_ra_approved is ''><a href="" title="View Report Number #report_number#"><font color="660000">P</font></a><Cfelseif get_Status.date_rd_approved is ''><a href="" title="Approve/Reject Report Number #report_number#"><font color="orange">W</font></a> <cfelseif get_Status.date_rd_approved is not ''><a href="" title="View Report Number #report_number#"><font color="green">A</font></a><cfelseif get_Status.date_rejected is not ''>R</Cfif>
						<cfelse>
							<cfif DateFormat(now(), 'mm') is 9 or DateFormat(now(), 'mm') is 10><a href="" title="Approve/Reject Report Number #report_number#">D</a><cfelse>U</cfif>
						</cfif>
					</cfif>
					</cfloop>
				</cfif></cfif></td>
				
				
				<!----Dec---->
				<td>
				<Cfif DateFormat(program_date.startdate, 'mm') lt 10>N/A<cfelse>
				<cfif reports.recordcount is 0>
					<cfif DateFormat(now(), 'mm') is 12><font color="blue">D</font></a><cfelse>U</cfif>
				<cfelse>
					<cfloop query=reports>
					<cfif dateFormat(reports.date, 'mm') is 11 or dateFormat(reports.date, 'mm') is 12>
						<cfquery name="get_status" datasource="caseusa">
						select date_ra_Approved, date_rd_approved, date_rejected
						from smg_document_tracking 
						where report_number = #report_number#
						</cfquery>
						<Cfif get_Status.recordcount is not  0>
							<Cfif get_Status.date_ra_approved is ''><a href="" title="View Report Number #report_number#"><font color="660000">P</font></a><Cfelseif get_Status.date_rd_approved is ''><a href="" title="Approve/Reject Report Number #report_number#"><font color="orange">W</font></a> <cfelseif get_Status.date_rd_approved is not ''><a href="" title="View Report Number #report_number#"><font color="green">A</font></a><cfelseif get_Status.date_rejected is not ''>R</Cfif>
						<cfelse>
							<cfif DateFormat(now(), 'mm') is 12><a href="" title="Approve/Reject Report Number #report_number#">D</a><cfelse>U</cfif>
						</cfif>
					</cfif>
					</cfloop>
				</cfif></cfif></td>
				
				
				
				<!----Feb---->
				<td>
				<Cfif DateFormat(program_date.startdate, 'mm') gt 7>N/A<cfelse>
				<cfif reports.recordcount is 0>
					<cfif DateFormat(now(), 'mm') is 1 or dateFormat(reports.date, 'mm') is 2><font color="blue">D</font></a><cfelse>U</cfif>
				<cfelse>
					<cfloop query=reports>
					<cfif dateFormat(reports.date, 'mm') is 1 or dateFormat(reports.date, 'mm') is 2>
						<cfquery name="get_status" datasource="caseusa">
						select date_ra_Approved, date_rd_approved, date_rejected
						from smg_document_tracking 
						where report_number = #report_number#
						</cfquery>
						<Cfif get_Status.recordcount is not  0>
							<Cfif get_Status.date_ra_approved is ''><a href="" title="View Report Number #report_number#"><font color="660000">P</font></a><Cfelseif get_Status.date_rd_approved is ''><a href="" title="Approve/Reject Report Number #report_number#"><font color="orange">W</font></a> <cfelseif get_Status.date_rd_approved is not ''><a href="" title="View Report Number #report_number#"><font color="green">A</font></a><cfelseif get_Status.date_rejected is not ''>R</Cfif>
						<cfelse>
							<cfif DateFormat(now(), 'mm') is 1 or dateFormat(reports.date, 'mm') is 2><a href="" title="Approve/Reject Report Number #report_number#">D</a><cfelse>U</cfif>
						</cfif>
					</cfif>
					</cfloop>
				</cfif></cfif></td>
				
				
				
				<!----Apr---->
				<td>
				<Cfif DateFormat(program_date.startdate, 'mm') gt 7>N/A<cfelse>
				<cfif reports.recordcount is 0>
					<cfif DateFormat(now(), 'mm') is 3 or dateFormat(reports.date, 'mm') is 4><font color="blue">D</font></a><cfelse>U</cfif>
				<cfelse>
					<cfloop query=reports>
					<cfif dateFormat(reports.date, 'mm') is 3 or dateFormat(reports.date, 'mm') is 4>
						<cfquery name="get_status" datasource="caseusa">
						select date_ra_Approved, date_rd_approved, date_rejected
						from smg_document_tracking 
						where report_number = #report_number#
						</cfquery>
						<Cfif get_Status.recordcount is not  0>
							<Cfif get_Status.date_ra_approved is ''><a href="" title="View Report Number #report_number#"><font color="660000">P</font></a><Cfelseif get_Status.date_rd_approved is ''><a href="" title="Approve/Reject Report Number #report_number#"><font color="orange">W</font></a> <cfelseif get_Status.date_rd_approved is not ''><a href="" title="View Report Number #report_number#"><font color="green">A</font></a><cfelseif get_Status.date_rejected is not ''>R</Cfif>
						<cfelse>
							<cfif DateFormat(now(), 'mm') is 3 or dateFormat(reports.date, 'mm') is 4><a href="" title="Approve/Reject Report Number #report_number#">D</a><cfelse>U</cfif>
						</cfif>
					</cfif>
					</cfloop>
				</cfif></cfif>
				</td>
				
				
				
				<!----June---->
				<td>
								<Cfif DateFormat(program_date.startdate, 'mm') gt 7>N/A<cfelse>
				<cfif reports.recordcount is 0>
					<cfif DateFormat(now(), 'mm') is 5 or dateFormat(reports.date, 'mm') is 6><font color="blue">D</font></a><cfelse>U</cfif>
				<cfelse>
					<cfloop query=reports>
					<cfif dateFormat(reports.date, 'mm') is 5 or dateFormat(reports.date, 'mm') is 6>
						<cfquery name="get_status" datasource="caseusa">
						select date_ra_Approved, date_rd_approved, date_rejected
						from smg_document_tracking 
						where report_number = #report_number#
						</cfquery>
						<Cfif get_Status.recordcount is not  0>
							<Cfif get_Status.date_ra_approved is ''><a href="" title="View Report Number #report_number#"><font color="660000">P</font></a><Cfelseif get_Status.date_rd_approved is ''><a href="" title="Approve/Reject Report Number #report_number#"><font color="orange">W</font></a> <cfelseif get_Status.date_rd_approved is not ''><a href="" title="View Report Number #report_number#"><font color="green">A</font></a><cfelseif get_Status.date_rejected is not ''>R</Cfif>
						<cfelse>
							<cfif DateFormat(now(), 'mm') is 5 or dateFormat(reports.date, 'mm') is 6><a href="" title="Approve/Reject Report Number #report_number#">D</a><cfelse>U</cfif>
						</cfif>
					</cfif>
					</cfloop>
				</cfif></cfif>
				
				</td>				
			
			</tr>
			</cfif>
			<cfset prevrep = #userid#>
		</cfloop>
		</table>
		<Cfif client.usertype is 3>
		<Cfelse>
		<br>
<div align="center">Click on Status icon to view report.  Depending on status, various options will be available.</div>
<br>
				<table align="center" cellspacing=0 cellpadding="2">
				<th align="center" colspan=2 bgcolor="CC0000"><font color="white">Status Icon Key</th>
					<tr>
						<td valign="top" bgcolor="ededed"><font size=-2><u>N/A</u> - doesn't apply to student<br>
							<u>U</u> - Reports will be due soon<br>
							<u><font color="0000FF">D</font></u> - Reports is Due, has not been submitted <br>
							<u><font color="660000">P</font></u> - Report is waiting for RA to approve</td>
						<td valign="top" bgcolor="ededed">
							<font size=-2><u><font color="red">R</font></u> - Report has been rejected<br>
							<u><font color="orange">W</font></u> - You need to approve this report <br>
							 <u><font color="green">A</font></u> - Report has been approved
						</td>
					</tr>
				</table>
		</Cfif>

			
	</cfif>

</table>

</cfloop>
		<Cfif client.usertype is 3>
				<br>
<div align="center">Click on Status icon to view report.  Depending on status, various options will be available.</div>
<br>
				<table align="center" cellspacing=0 cellpadding="2">
				<th align="center" colspan=2 bgcolor="CC0000"><font color="white">Status Icon Key</th>
					<tr>
						<td valign="top" bgcolor="ededed"><font size=-2><u>N/A</u> - doesn't apply to student<br>
							<u>U</u> - Reports will be due soon<br>
							<u><font color="0000FF">D</font></u> - Reports is Due, has not been submitted <br>
							<u><font color="660000">P</font></u> - Report is waiting for RA to approve</td>
						<td valign="top" bgcolor="ededed">
							<font size=-2><u><font color="red">R</font></u> - Report has been rejected<br>
							<u><font color="orange">W</font></u> - You need to approve this report <br>
							 <u><font color="green">A</font></u> - Report has been approved
						</td>
					</tr>
				</table>
		<Cfelse>

		</Cfif>
</Cfoutput>