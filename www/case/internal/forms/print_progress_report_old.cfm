
<cfparam name="edit" default="no" >
<cfif isDefined('form.edit')>
<cfset edit=#form.edit#>
</cfif>

<Cfquery name="progress_Report" datasource="caseusa">
select *
from smg_prquestion_details
where report_number = #url.number#
</Cfquery>

<cfquery name="stu_id" datasource="caseusa">
select distinct stuid
from smg_prquestion_details
where report_number = #url.number#
</cfquery>

<cfquery name="student_host_name" datasource="caseusa">
select smg_students.firstname, smg_students.familylastname, smg_students.arearepid
from smg_students
where studentid =#stu_id.stuid#
</cfquery>

<cfquery name="tracking_info" datasource="caseusa">
select * from smg_document_tracking
where report_number = #url.number#
</cfquery>

<Cfquery name="ra" datasource="caseusa">
select smg_users.advisor_id, smg_users.firstname, smg_users.lastname, smg_users.userid, smg_students.studentid
from smg_users right join smg_students on smg_users.userid = smg_students.arearepid
where studentid = #stu_id.stuid# 
</cfquery>

<cfquery name="region" datasource="caseusa">
select smg_students.regionassigned, smg_regions.regionid
 from smg_regions right join smg_students on  smg_regions.regionid = smg_students.regionassigned
 where studentid = #stu_id.stuid#
</cfquery>

<Cfquery name="rd" datasource="caseusa">
select smg_users.firstname, smg_users.lastname, smg_users.userid
from smg_users
where usertype = 5 and regions like #region.regionid#
</Cfquery>

<Cfquery name="ia" datasource="caseusa">
select smg_users.userid, smg_users.businessname, smg_students.studentid
from smg_users right join smg_students on smg_users.userid = smg_students.intrep
where studentid = #stu_id.stuid# 
</Cfquery>
<Cfoutput>

<!----
<table border=0>
	<tr>
		
		<td width=50% valign="top">
					<table>
						<th bgcolor="CC0000"><font color="white">Status</th>
						<tr>
							<td bgcolor="ededed">
							<cfif tracking_info.date_rejected is not ''>
							Report was Rejected for the following reason:<br>
							#tracking_info.note#
							<Cfelse>
							RA Approval: <Cfif ra.advisor_id is 0>N/A<cfelseif tracking_info.date_Ra_approved is ''>Pending<cfelse>#DateFormat(tracking_info.date_ra_approved, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.date_ra_approved, 'h:mm:ss tt')#</cfif><br>
							RD Approval:<Cfif tracking_info.date_rd_approved  is ''>Pending<cfelse> #DateFormat(tracking_info.date_rd_approved, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.date_rd_approved, 'h:mm:ss tt')# </cfif><br>
							NY Accepted: <Cfif tracking_info.ny_Accepted  is ''>Pending<cfelse> #DateFormat(tracking_info.ny_Accepted, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.ny_Accepted, 'h:mm:ss tt')# </cfif><br>
							</cfif>
							</td>
					</table>
			</td>
			<td valign="top">
					
				
			
							<Table  bgcolor="ededed" border=0>
							<th bgcolor="CC0000"  colspan=3><font color="white">Options</th>
							<tr>
							
								<td bgcolor="ededed">
								<cfif tracking_info.date_Ra_approved is '' and tracking_info.date_Rd_approved is ''>
								<form action="?curdoc=forms/view_progress_report&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
								<cfelseif client.usertype is 6 and tracking_info.date_Rd_approved is ''>
								<form action="?curdoc=forms/view_progress_report&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
								<Cfelseif client.usertype is 5 and tracking_info.ny_accepted is ''>
								<form action="?curdoc=forms/view_progress_report&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
								<cfelse>
								<img src="pics/no_edit.jpg" alt="Edit"  border=0>
								</cfif>
								</td><td>
								<cfif client.usertype is 6 and tracking_info.date_Rd_approved is ''>
								<form action="?curdoc=forms/rejection_reason&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/Reject.gif" alt="Reject Report"  border=0></form></td>
								<Cfelseif client.usertype is 5 and tracking_info.ny_accepted is ''>
								<form action="?curdoc=forms/rejection_reason&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/Reject.gif" alt="Reject Report"  border=0></form></td>
								<cfelse>
								<img src="pics/no_reject.jpg" alt="Reject"  border=0>
								</cfif>
								<td><A href="print_progress_report.cfm?number=#url.number#" target=top><img src="pics/printer.gif" Alt="Print Report" border=0></A></td>
							</tr>
							
							<tr>
								<td bgcolor="ededed">
								<cfif client.usertype is 6 and tracking_info.date_Rd_approved is ''>
								<form action="?curdoc=querys/approve_progress_report&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report"  border=0></form></td>
								<Cfelseif client.usertype is 5 and tracking_info.ny_accepted is ''>
								<form action="?curdoc=querys/approve_progress_report&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report"  border=0></form></td>
								<cfelse>
								<img src="pics/no_approve.jpg" alt="Reject"  border=0>
								</cfif>
<td>
								<cfif client.usertype is 7 or client.usertype lte 2>
								<form action="?curdoc=querys/delete_progress_report&number=#url.number#" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/delete.gif" alt="Delete Report"  border=0></form></td>
								<cfelse>
								<img src="pics/no_delete.jpg" alt="Delete Report"  border=0>
								</cfif>
								<td>
								<cfif client.usertype  lte 4>
								<img src="pics/archive.gif" Alt="Archive">
								<cfelse>
								<img src="pics/no_archive.jpg" Alt="Archive">
								 </cfif></td>
								
								
							</tr>

							
				
							</Table>
				
				</td>
					
			
		
				
		</tr>
	</table>
</tr>
</table>
---->


<h2>Student Name: #student_host_name.firstname# #student_host_name.familylastname# (#stu_id.stuid#)<br>
Month of Report: 
<cfif DateFormat(#progress_report.date#, 'mm') gte 7 and DateFormat(#progress_report.date#, 'mm') lte 12>December<br> </cfif> 
<cfif DateFormat(#progress_report.date#, 'mm') is 1 or DateFormat(#progress_report.date#, 'mm') is 2>February<br> </cfif> 
<cfif DateFormat(#progress_report.date#, 'mm') gt  2 and DateFormat(#progress_report.date#, 'mm') lte 3>April<br> </cfif> 
<cfif DateFormat(#progress_report.date#, 'mm') gt  4 and DateFormat(#progress_report.date#, 'mm') lte 6>April<br> </cfif> 
</Cfoutput></h2>


<Cfoutput>

<cfquery name="contact_dates" datasource="caseusa">
select *
from smg_prdates where 
report_number =#url.number#

</cfquery>
<table>
	<tr>
		<td>Area Representitve:</td><td>#ra.firstname# #ra.lastname# (#ra.userid#)</td>
	</tr>
	<Tr>
		<td>Regional Director:</td><td>#rd.firstname# #rd.lastname# (#rd.userid#)</td>
	</Tr>
	<Tr>
		<td>International Agent:</td><td>#ia.businessname# (#ia.userid#)</td>
	</Tr>
</table>
<br>

<TABLE >
	<TR>
		<TD align="left" valign=top>
				<TABLE>
					<TR>
						<TD align="center"><b>Contact: In-Person</b></td>
					</tr>
					<tr>
						<td>
						
							<table class=nav_bar width=100% align="Center" background="pics/inperson_background.jpg">
			
								<TR>
									<td align="center">Host Family<br>(mm/dd/yy)</td><td align="center">Student<br>(mm/dd/yy)</td>
								</tr>

								<TR>
									<TD align="right">Date: <input type="Text" name="host_date_inperson" align="LEFT"  required="No" size="8" maxlength="10" <Cfif edit is 'no'>readonly</Cfif> value=#DateFormat(contact_dates.hipdate1, 'mm/dd/yyyy')# ></td><TD align="right">Date: <input type="Text" name="stu_date_inperson" align="LEFT" <Cfif edit is 'no'>readonly</Cfif> required="No" size="8" maxlength="10" value=#DateFormat(contact_dates.sipdate1, 'mm/dd/yyyy')# ></td>
								</tr>
								<tr>
									<TD align="right">Date: <input type="Text" name="host_date_inperson2" align="LEFT"  required="No" size="8" maxlength="10" <Cfif edit is 'no'>readonly</Cfif> value=#DateFormat(contact_dates.hipdate2, 'mm/dd/yyyy')#></td><td align="right">Date: <input type="Text" name="stu_date_inperson2" align="LEFT" <Cfif edit is 'no'>readonly</Cfif> required="No" size="8" maxlength="10" value=#DateFormat(contact_dates.sipdate2, 'mm/dd/yyyy')#></td>
								</tr>
								<tr>
									<TD align="right">Date: <input type="Text" name="host_date_inperson3" align="LEFT"  required="No" size="8" maxlength="10" <Cfif edit is 'no'>readonly</Cfif> value=#DateFormat(contact_dates.hipdate3, 'mm/dd/yyyy')#></td><td align="right">Date: <input type="Text" name="stu_date_inperson3" align="LEFT" <Cfif edit is 'no'>readonly</Cfif> required="No" size="8" maxlength="10" value=#DateFormat(contact_dates.sipdate3, 'mm/dd/yyyy')#></td>
								</tr>

							</TABLE>
						</td>
					</tr>
				</table>
		</TD>
		<TD align="right" valign=top>
		
				<TABLE>
					<TR>
						<TD align="center"><b>Contact: By Telephone</b></td>
					</tr>
					<tr>
						<td>
						
							<table class=nav_bar width=100% align="Center"  background="pics/phone_background.jpg">
	
			
								<TR>
									<td align="center">Host Family<br>(mm/dd/yy)</td><td align="center">Student<br>(mm/dd/yy)</td>
								</tr>
								<TR>
									<TD>Date: <input type="Text" name="host_date_phone" align="LEFT"  required="No" size="8" maxlength="10" <Cfif edit is 'no'>readonly</Cfif> value=#DateFormat(contact_dates.hbtdate1, 'mm/dd/yyyy')#></td><TD>Date: <input type="Text" name="stu_date_phone" align="LEFT"  required="No" size="8" <Cfif edit is 'no'>readonly</Cfif> maxlength="10" value=#DateFormat(contact_dates.sbtdate1, 'mm/dd/yyyy')#></td>
								</tr>
								<tr>
									<TD>Date: <input type="Text" name="host_date_phone2" align="LEFT"  required="No" size="8" maxlength="10" <Cfif edit is 'no'>readonly</Cfif> value=#DateFormat(contact_dates.hbtdate2, 'mm/dd/yyyy')#></td><td>Date: <input type="Text" name="stu_date_phone2" align="LEFT"  required="No" size="8" <Cfif edit is 'no'>readonly</Cfif> maxlength="10" value=#DateFormat(contact_dates.sbtdate2, 'mm/dd/yyyy')#></td>
								</tr>
								<tr>
									<TD>Date: <input type="Text" name="host_date_phone3" align="LEFT"  required="No" size="8" maxlength="10" <Cfif edit is 'no'>readonly</Cfif> value=#DateFormat(contact_dates.hbtdate3, 'mm/dd/yyyy')#></td><td>Date: <input type="Text" name="stu_date_phone3" align="LEFT"  required="No" size="8" <Cfif edit is 'no'>readonly</Cfif> maxlength="10" value=#DateFormat(contact_dates.sbtdate3, 'mm/dd/yyyy')#></td>
								</tr>

							</TABLE>
						</td>
					</tr>
				</table>
			
		</TD>

	</TR>
</TABLE>



<br>
<TABLE width=95%>

<Cfloop query="progress_Report">
<cfquery name="questions" datasource="caseusa">
select * from smg_prquestions
where id = #question_number#
order by id
</cfquery>
	<TR>
		<TD>#questions.text#</td>
		
		<td></td><td> <cfif progress_Report.yn is 'yes'>Yes</cfif><cfif progress_Report.yn is 'no'>No</cfif></td>
		
	</tr>
	<tr>
		<td colspan=3>Comments:<br>#progress_Report.response#</td>
	</tr>
	<tr>
		<td colspan=3 align="Center"><hr width=70%></td>
	</tr>
	
	</cfloop>
</table>
<Br>
</cfoutput>