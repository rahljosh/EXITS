<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfparam name="edit" default="no" >
<cfif isDefined('form.edit')>
<cfset edit=#form.edit#>
</cfif>

<Cfquery name="progress_Report" datasource="MySQL">
select *
from smg_prquestion_details
where report_number = #url.number#
</Cfquery>

<cfquery name="stu_id" datasource="MySQL">
select distinct stuid
from smg_prquestion_details
where report_number = #url.number#
</cfquery>

<cfquery name="student_host_name" datasource="MySQL">
select smg_students.firstname, smg_students.familylastname, smg_students.arearepid, hostid, companyid, programid
from smg_students
where studentid = #stu_id.stuid#
</cfquery>

<cfquery name="program_name" datasource="MySQL">
select programname
from smg_programs
where programid = #student_host_name.programid#
</cfquery>

<cfquery name="tracking_info" datasource="mysql">
select * from smg_document_tracking
where report_number = #url.number#
</cfquery>

<Cfquery name="ra" datasource="MySQL">
select smg_users.advisor_id, smg_users.firstname, smg_users.lastname, smg_users.userid, smg_students.studentid
from smg_users right join smg_students on smg_users.userid = smg_students.arearepid
where studentid = #stu_id.stuid# 
</cfquery>

<cfquery name="region" datasource="mysql">
select smg_students.regionassigned, smg_regions.regionid
 from smg_regions right join smg_students on  smg_regions.regionid = smg_students.regionassigned
 where studentid = #stu_id.stuid#
</cfquery>

<Cfquery name="rd" datasource="MySQL">
select smg_users.firstname, smg_users.lastname, smg_users.userid
from smg_users right join user_access_rights on smg_users.userid = user_access_rights.userid
where user_access_rights.usertype = 5 and regionid = #region.regionid#
</Cfquery>

<Cfquery name="ia" datasource="MySQL">
select smg_users.userid, smg_users.businessname, smg_students.studentid
from smg_users right join smg_students on smg_users.userid = smg_students.intrep
where studentid = #stu_id.stuid# 
</Cfquery>

<!-----Company Information----->
<Cfquery name="companyshort" datasource="MySQL">
select *
from smg_companies
where companyid = #student_host_name.companyid#
</Cfquery>

<cfquery name="hf" datasource="MySql">
SELECT fatherfirstname, familylastname, motherfirstname, hostid
FROM smg_hosts
WHERE hostid = #student_host_name.hostid#
</cfquery>

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


<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
<tr><td align="right"><font size="-1">International Agent: &nbsp; <u><b><Cfoutput>#ia.businessname#</cfoutput> (# <cfoutput>#ia.userid#</cfoutput>)</font></b></u></td></tr>
</table>

<Cfoutput>
<table cellspacing="2" cellpadding="2" border="0" width="650" align="center" class="box">
<tr>
    <td><img src="../pics/logos/#companyshort.companyid#.gif"  alt="" border="0" align="left" border="0"></td>
	 <td  align="left">
		<font size="+3">Student Progress Report for 
			<cfif tracking_info.month_of_report eq 10>October<br> </cfif> 
			<cfif tracking_info.month_of_report eq 12>December<br> </cfif> 
			<cfif tracking_info.month_of_report eq 2>February<br></cfif> 
			<cfif tracking_info.month_of_report eq 4>April<br></cfif> 
			<cfif tracking_info.month_of_report eq 6>June<br></cfif> 
			<cfif tracking_info.month_of_report eq 8>August<br> </cfif> </font><br>
		<font size="+1">Student Name: #student_host_name.firstname# #student_host_name.familylastname# ( #stu_id.stuid# )</font> #program_name.programname# (#student_host_name.programid#)
	</td>
</tr>
</table>

<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
<hr>
</table>
</Cfoutput>

<Cfoutput>
<cfquery name="contact_dates" datasource="MySQL">
select *
from smg_prdates where 
report_number =#url.number#

</cfquery>
<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
	<Tr>
		<td>Host Family: </td><td><cfif hf.fatherfirstname is not ''>#hf.fatherfirstname#</cfif>
								<cfif hf.motherfirstname is not '' and hf.fatherfirstname is not ''>and #hf.motherfirstname#</cfif> 
								<cfif hf.motherfirstname is not '' and hf.fatherfirstname is ''>#hf.motherfirstname#</cfif> 
								#hf.familylastname# (#hf.hostid#)
		</td>
	</Tr>
	<tr>
		<td width="20%">Area Representitve: </td><td>#ra.firstname# #ra.lastname# (#ra.userid#)</td>
	</tr>
	<Tr>
		<td>Regional Director: </td><td>#rd.firstname# #rd.lastname# (#rd.userid#)</td>
	</Tr>
</table>
<br>

<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
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
<table cellspacing="2" cellpadding="2" border="0" width="650" align="center">
<Cfloop query="progress_Report">
<cfquery name="questions" datasource="MySQL">
select * from smg_prquestions
where id = #question_number#
order by id
</cfquery>
	<TR>
		<TD width="75%"><div align="justify">#questions.text#</div></td>
		<td width="10%"></td>
		<td width="15%"><cfif progress_Report.yn is 'yes'>Yes</cfif><cfif progress_Report.yn is 'no'>No</cfif></td>
	</tr>
	<tr>
		<td colspan=3>Comments:</td>
	</tr>
		<tr>
		<td colspan=3><div align="justify">#progress_Report.response#</div></td>
	</tr>
	<tr>
		<td colspan=3 align="Center"><hr width=80%></td>
	</tr>
</cfloop>
</table>
<Br>
</cfoutput>