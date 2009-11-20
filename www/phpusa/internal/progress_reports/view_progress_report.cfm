<SCRIPT>
<!--
// opens letters in a defined format
function OpenLetter(url) {
	newwindow=window.open(url, 'Application', 'height=280, width=700, location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>

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
	select smg_students.firstname, smg_students.familylastname, smg_students.arearepid, smg_students.arearepid, smg_students.intrep
	from smg_students
	where studentid =#stu_id.stuid#
</cfquery>

<cfquery name="tracking_info" datasource="mysql">
	select * from smg_document_tracking
	where report_number = #url.number#
</cfquery>

<cfquery name="region" datasource="mysql">
	select smg_students.regionassigned, smg_regions.regionid
	 from smg_regions right join smg_students on  smg_regions.regionid = smg_students.regionassigned
	 where studentid = #stu_id.stuid#
</cfquery>

<Cfquery name="ra" datasource="MySQL">
	select smg_users.advisor_id, smg_students.studentid, smg_users.firstname, smg_users.lastname
	from smg_users right join smg_students on smg_users.userid = smg_students.arearepid
	where studentid = #stu_id.stuid# 
</cfquery>
<cfquery name="ra2" datasource="MySQL">
	select user_access_rights.advisorid 
	from user_access_rights 
	where userid = #student_host_name.arearepid# 
	and companyid = #client.companyid# and regionid = #region.regionid#
</cfquery>

<!----
<Cfquery name="ra1" datasource="MySQL">
	select smg_users.advisor_id, smg_students.studentid, smg_users.firstname, smg_users.lastname
	from smg_users right join smg_students on smg_users.userid = smg_students.arearepid
	where studentid = #stu_id.stuid# 
</cfquery>
---->
<Cfquery name="ra1" datasource="MySQL">
	select distinct user_access_rights.advisorid as advisor_id, smg_users.firstname, smg_users.lastname
	from user_access_rights left join smg_users on smg_users.userid = user_Access_rights.advisorid
	where user_access_rights.userid  = #ra.advisor_id# 
</cfquery>

<Cfquery name="rd" datasource="MySQL">
	select smg_users.firstname, smg_users.lastname, smg_users.userid
	from smg_users right join user_access_rights on smg_users.userid = user_access_rights.userid
	where user_access_rights.usertype = 5 and regionid = #region.regionid#
</Cfquery>


<cfif client.usertype gt 4>
<cfquery name="rep_on_report" datasource="MySQL">
select distinct userid
from smg_prquestion_details
where report_number=#url.number#
</cfquery>
<cfquery name="get_region" datasource="MySQL">
select regionid 
from user_access_rights
where userid = #client.userid# and companyid = #client.companyid#
</cfquery>
<cfquery name="get_advisor_for_rep" datasource="mysql">
select advisorid
from user_access_rights
where userid = #rep_on_report.userid# and companyid = #client.companyid# and regionid = '#client.regions#'
</cfquery>

<cfif not isDefined('client.page.previous5start')>
	<cfset client.page.previous5start = 1>
</cfif> 

	<cfif client.userid eq #get_advisor_for_rep.advisorid# or client.userid eq #rd.userid# or client.userid eq #ra1.advisor_id# or client.userid eq  #student_host_name.arearepid# or client.userid eq #ra2.advisorid# or client.userid eq #student_host_name.intrep#>
	<cfelse>

		<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
			<tr valign=middle height=24>
				<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
				<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
				<td background="pics/header_background.gif"><h2>Report View - Error </h2></td>
				<td width=17 background="pics/header_rightcap.gif">&nbsp;</td></tr>
		</table>
		<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
		<tr><td align="center"><br><div align="justify"><img src="pics/error_exclamation.gif" align="left"><h3>
		<cfoutput>
							<p>You are not allowed to view this report.</p>
							<p>Only HQ Staff, the Area Representative, Regional Advisor, and Regional Manager of a student can view that students report. </p></h3>
							If you feel you have receivd this in error and should be able to see the report, please contact <a href="mailto:support@student-management.com">support@student-management.com</a> and reference report id #url.number# along with your name. 
							</div>
							<a href="index.cfm">Home</a> :: <a href="index.cfm?curdoc=forms/approve_list">Back to Report List</a>
							<br><br>
							<font size=-2>
							Support Use Only<br>
							u:#client.userid# rd:#rd.userid#  ra:#ra.advisor_id# ar:#student_host_name.arearepid# ra1:#ra1.advisor_id# ra2:#ra2.advisorid#
							
							</font>
							</cfoutput></td></tr>
		<tr><td align="center"></td></tr>
		</table>
		<table width=100% cellpadding=0 cellspacing=0 border=0>
			<tr valign="bottom"><td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
				<td width=100% background="pics/header_background_footer.gif"></td>
				<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td></tr>
		</table>
		<cfabort>
	</cfif>
</cfif>
<Cfoutput>
<!----header---->
					<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
							<td background="pics/header_background.gif"><h2>Progress Report for #student_host_name.firstname# #student_host_name.familylastname# </td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
				<!----Sizing Table---->	
  <table border=0 width=100% cellspacing=0 border=0 class="section" >

	<tr>
		<td align="center">					
									
				<table border=0 width=100%>
					<tr>
						
						<td width=50% valign="top" align="left">
									<!--- STATUS <table>
										<th bgcolor="CC0000"><font color="white">Status</th>
										<tr>
											<td bgcolor="ededed">
											RA Approval: <Cfif ra.advisor_id is 0>N/A<cfelseif ra.advisor_id eq rd.userid>N/A<cfelseif tracking_info.date_Ra_approved is ''>Pending<cfelse>#DateFormat(tracking_info.date_ra_approved, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.date_ra_approved, 'h:mm:ss tt')#</cfif><br>
											RD Approval:<Cfif tracking_info.date_rd_approved  is ''>Pending<cfelse> #DateFormat(tracking_info.date_rd_approved, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.date_rd_approved, 'h:mm:ss tt')# </cfif><br>
											NY Accepted: <Cfif tracking_info.ny_Accepted  is ''>Pending<cfelse> #DateFormat(tracking_info.ny_Accepted, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.ny_Accepted, 'h:mm:ss tt')# </cfif><br>
																		
											<cfif tracking_info.date_rejected is not ''>
											Rejected: #DateFormat(tracking_info.date_rejected, 'mm/dd/yyyy')# @ #TimeFormat(tracking_info.date_rejected, 'h:mm:ss tt')#<br>
											<hr width=30%>
											Report was rejected for the following reason(s):<br>
											#tracking_info.note#
											<Cfelse>
											</cfif>
											</td>
									</table> --->
							</td>
							<td valign="top" align="right">
									
											<Table  bgcolor="ededed" border=0>
											<th bgcolor="CC0000"  colspan=3><font color="white">Options</th>
											<tr>
											
												<td bgcolor="ededed">
												<cfif client.usertype eq 8>
												<img src="pics/no_edit.jpg" alt="Edit"  border=0>		
												<cfelseif tracking_info.date_Ra_approved is '' and tracking_info.date_Rd_approved is ''>
												<form action="?curdoc=forms/view_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
												<cfelseif client.usertype is 6 and tracking_info.date_Rd_approved is ''>
												<form action="?curdoc=forms/view_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
												<Cfelseif client.usertype is 5 and tracking_info.ny_accepted is ''>
												<form action="?curdoc=forms/view_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
												<cfelseif client.usertype lt 5 and tracking_info.date_Rd_approved is not ''>
												<form action="?curdoc=forms/view_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
												<cfelseif client.usertype lte 4>
												<form action="?curdoc=forms/view_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/edit.gif" alt="Edit"  border=0></form>
												<cfelse>
												<img src="pics/no_edit.jpg" alt="Edit"  border=0>
												</cfif>
												
												</td><td>
												<cfif client.usertype eq 8>
												<img src="pics/no_reject.jpg" alt="Reject"  border=0>
												<cfelseif client.usertype is 6 and tracking_info.date_Rd_approved is ''>
												<form action="?curdoc=forms/rejection_reason&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/Reject.gif" alt="Reject Report"  border=0></form></td>
												<Cfelseif client.usertype is 5 and tracking_info.ny_accepted is ''>
												<form action="?curdoc=forms/rejection_reason&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/Reject.gif" alt="Reject Report"  border=0></form></td>
												<cfelseif client.usertype lt 5 and tracking_info.date_Rd_approved is not  ''>
												<form action="?curdoc=forms/rejection_reason&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/Reject.gif" alt="Reject Report"  border=0></form></td>
												<cfelseif client.usertype lte 4>
												<form action="?curdoc=forms/rejection_reason&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/Reject.gif" alt="Reject Report"  border=0></form></td>
												
												<cfelse>
												<img src="pics/no_reject.jpg" alt="Reject"  border=0>
												</cfif>
												<td><A href="forms/print_progress_report.cfm?number=#url.number#" target=top><img src="pics/printer.gif" Alt="Print Report" border=0></A></td>
											</tr>
											
											<tr>
												<td bgcolor="ededed">
												<cfif client.usertype eq 8>
												<img src="pics/no_approve.jpg" alt="Reject"  border=0>
												<cfelseif client.usertype is 6 and tracking_info.date_Rd_approved is ''>
												<form action="?curdoc=querys/approve_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report"  border=0></form></td>
												<Cfelseif client.usertype is 5 and tracking_info.ny_accepted is ''>
												<form action="?curdoc=querys/approve_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report"  border=0></form></td>
												<cfelseif client.usertype lt 5 and tracking_info.date_Rd_approved is not  ''>
												<form action="?curdoc=querys/approve_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report"  border=0></form></td>
												<cfelseif client.usertype lte 4>
												<form action="?curdoc=querys/approve_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/approve.gif" alt="Approve Report"  border=0></form></td>
												<cfelse>
												<img src="pics/no_approve.jpg" alt="Reject"  border=0>
												</cfif>
												<td>
												<cfif client.usertype eq 8>
												<img src="pics/no_delete.jpg" alt="Delete Report"  border=0>
												<cfelseif client.usertype is 7 or client.usertype lte 2>
												<form action="?curdoc=querys/delete_progress_report&number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>" method="post"><input type="hidden" name="edit" value="yes"><input name="Submit" type="image" src="pics/delete.gif" alt="Delete Report"  border=0></form></td>
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
											<cfif client.usertype LTE '4'> 
											<tr>
												<td>&nbsp; <a href="javascript:OpenLetter('../nsmg/reports/email_progress_report.cfm?number=#url.number#');"><img src="pics/email.gif" border="0" alt="Email Progress Report"> Email</a></td>
											</tr>
											</cfif>
										</Table>
								</td>
						</tr>
					</table>
				
				
				<h2>Student Name: #student_host_name.firstname# #student_host_name.familylastname# <br>
				Month of Report: 
<cfif progress_Report.month_of_report eq 10>October<br>
	 <font size=-2>Due Oct <cfif client.companyid EQ 1 OR client.companyid EQ 3>15th<cfelse>1st</cfif> - include information from arrival thru Oct <cfif client.companyid EQ 1 OR
	  client.companyid EQ 3>15<cfelse>1</cfif></font>
</cfif> 

<cfif progress_Report.month_of_report eq 12>December<br> <font size=-2>Due Dec <cfif client.companyid EQ 1 OR client.companyid EQ 3>15th<cfelse>1st</cfif> - include information from Oct <cfif client.companyid EQ 1 OR client.companyid EQ 3>15<cfelse>1</cfif> thru Dec <cfif client.companyid EQ 1 OR client.companyid EQ 3>15<cfelse>1</cfif></font></cfif> 

<cfif progress_Report.month_of_report eq 2>February<br> <font size=-2>Due Feb <cfif client.companyid EQ 1 OR client.companyid EQ 3>15th<cfelse>1st</cfif> - include information from  Dec 1 thru <cfif client.companyid is 2>Feb<cfelse>Jan</cfif> <cfif client.companyid EQ 1 OR client.companyid EQ 3>31<cfelse>1</cfif></font></cfif> 

<cfif progress_Report.month_of_report eq 4>April<br> <font size=-2>Due April <cfif client.companyid EQ 1 OR client.companyid EQ 3>15th<cfelse>1st</cfif> - include information from Feb <cfif client.companyid EQ 1 OR client.companyid EQ 3>15<cfelse>1</cfif>  thru <cfif client.companyid is 2>April<cfelse>March</cfif> <cfif client.companyid EQ 1 OR client.companyid EQ 3>15<cfelse>1</cfif></font></cfif> 

<cfif progress_Report.month_of_report eq 6>June<br> <font size=-2>Due June <cfif client.companyid EQ 1 OR client.companyid EQ 3>15th<cfelse>1st</cfif> - include information from April 1 thru <cfif client.companyid is 2>June<cfelse>May</cfif>  <cfif client.companyid EQ 1 OR client.companyid EQ 3>31<cfelse>1</cfif></font></cfif> 


<cfif progress_Report.month_of_report eq 8>August<br> <font size=-2>Due August <cfif client.companyid is 7>31st<cfelse>1st</cfif> - include information from June  <cfif client.companyid is 7>15<cfelse>1</cfif> thru <cfif client.companyid is 2>July<cfelse>July</cfif>  <cfif client.companyid is 2>15<cfelse>31</cfif></font></cfif> 
</h2>
				</Cfoutput>
				
				
				 Contact Dates: <font size=-2>Each report must show monthly contact & bimonthly in-person contact.</font><br>
				 <Cfoutput>
				
				Supervising Representative: #ra.firstname# #ra.lastname#  :: Regional Director: #rd.firstname# #rd.lastname#
				<cfquery name="contact_dates" datasource="MySQL">
				select *
				from smg_prdates where 
				report_number =#url.number#
				
				</cfquery>
				<cfif edit is 'no'>
				<cfelse>
				<form method="post" action="querys/update_progress_report.cfm?number=#url.number#<cfif IsDefined('url.regionid')>&regionid=#url.regionid#</cfif>">
				</cfif>
				<TABLE>
					<TR>
						<TD align="left" valign=bottom>
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
						<TD align="right" valign=bottom>
						
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
				<TABLE width=65%>
				
				<Cfloop query="progress_Report">
				<cfquery name="questions" datasource="MySQL">
				select * from smg_prquestions
				where id = #question_number#
				order by id
				</cfquery>
					<TR>
						<TD>#questions.text#</td>
						
						<td>Yes <input type=radio <Cfif edit is 'no'>disabled</Cfif> name="#progress_Report.id#_yn" value="Yes" <cfif progress_Report.yn is 'yes'>checked</cfif>></td><td>No<input type=radio name="#progress_Report.id#_yn" value="No" <cfif progress_Report.yn is 'no'>checked</cfif> <Cfif edit is 'no'>disabled</Cfif>></td>
						
					</tr>
					<tr>
						<td colspan=3>Comments:<br><textarea <Cfif edit is 'no'>readonly</Cfif> cols="60" rows="5" name="#progress_Report.id#_answer" wrap="VIRTUAL" >#progress_Report.response#</textarea></td>
					</tr>
					</cfloop>
				</table>
				<!----End of Sizing Table---->
		</td>
	</tr>
</table>
						<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>		

<Br>
<cfif edit is 'no'>

<cfelse>
<table align="center">
	<tr>
		<td colspan=2>To save this information so you can edit it later, click 'Save Only'.  If you are ready 
		for the report to be submitted for review, click 'Process'.</td>
	</tr>
	<tr>
		<td align="center"><input name="save" type="image" value="save" src="pics/save_only.gif" border=0></td><td align="center"><cfif tracking_info.date_rejected is not ''><font size=-2><input type="checkbox" name="unreject" checked> Remove rejection so report will be reprocessed.</font><br></cfif><input type="image" src="pics/process.gif" border=0>
</td>
	</tr>
</table>
</form></div>
</cfif>


</form>
</cfoutput>