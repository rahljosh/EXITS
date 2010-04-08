<link rel="stylesheet" href="../smg.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>

<Title>Progress Reports</title>

<cfquery name="get_progress_reports" datasource="caseusa">
select distinct report_number, date, submit_type 
from smg_prquestion_details
where stuid = #client.studentid#
</cfquery>

<br>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Progress Reports</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td colspan=3><span class="get_attention"><b>></b></span><u>Reports Received</u></td></tr>
	<tr>
		<Td width=10%>ID</Td><td width=20%>Submitted</td><td width=20%>RA</td><Td width=20%>RD</Td><td width=20%>NY</td><td width=10%>Type</td>
	</tr>
	<cfoutput query="get_progress_reports">
	<cfquery name="get_report_status" datasource="caseusa">
		select *
		from smg_document_tracking
		where report_number = #report_number#
	</cfquery>
	<cfif client.usertype eq 8 and get_report_status.ny_accepted is ''>
	<cfelse>
	<tr>
		<td>#get_progress_reports.report_number#</td><Td><a href="../index.cfm?curdoc=forms/view_progress_report&number=#get_progress_reports.report_number#" target="main_win">#DateFormat(get_progress_reports.date, 'mm/dd/yyyy')#</a></Td><td><cfif get_report_status.date_ra_approved is ''>N/A<cfelse>#DateFormat(get_report_status.date_ra_approved, 'mm/dd/yyyy')#</cfif></td><td>#DateFormat(get_report_status.date_rd_approved, 'mm/dd/yyyy')#</td><td>#DateFormat(get_report_status.ny_accepted, 'mm/dd/yyyy')#</td><td>#submit_type#</td>
	</tr>	
	</cfif>
	</cfoutput>
	
	<tr><td colspan="6">
	<cfif client.usertype neq 8>
		Received a progress report that wasn't submitted online?  Fill out this area to submit a record of a report received off-line.
	</cfif>
	</td></tr>
	<form action="../querys/insert_offline_progress_report.cfm" method="post">
	<tr><td colspan="8">
	<cfif client.usertype lte 4>
		<Table>
		<tr><td valign="top">								
				<TABLE>
				<TR>
					<TD align="center"><b>Month of Report</b></td>
				</tr>
				<tr>
					<td><cfoutput><select name="month_report">
						<option value=0></option>
						<option value=10>October</option>		
						<option value=12>December</option>
						<option value=02>February</option>
						<option value=04>April</option>
						<option value=06>June</option>
						<option value=08>August</option>
						</cfoutput>
						</select><br><br>
						You MUST input at least two contact dates that are on the report. </td>
				</tr>
				</table>
			<td>
				<TABLE>
				<TR><TD align="left" valign=bottom>
							<TABLE>
							<TR><TD align="center"><b>Contact: In-Person</b></td></tr>
							<tr><td>
									<table class=nav_bar align="Center" background="pics/inperson_background.jpg">
									<TR><td align="center">Host<br>(mm/dd/yy)</td><td align="center">Student<br>(mm/dd/yy)</td></tr>
									<TR><TD align="left">Date: <input type="Text" name="host_date_inperson" align="LEFT"  required="No" size="5" maxlength="10" ></td><TD align="left">Date: <input type="Text" name="stu_date_inperson" align="LEFT"  required="No" size="5" maxlength="10"  ></td></tr>
									<tr><TD align="left">Date: <input type="Text" name="host_date_inperson2" align="LEFT"  required="No" size="5" maxlength="10" ></td><td align="left">Date: <input type="Text" name="stu_date_inperson2" align="LEFT"  required="No" size="5" maxlength="10"></td></tr>
									<tr><TD align="left">Date: <input type="Text" name="host_date_inperson3" align="LEFT"  required="No" size="5" maxlength="10" ></td><td align="left">Date: <input type="Text" name="stu_date_inperson3" align="LEFT"  required="No" size="5" maxlength="10"></td></tr>
									</TABLE>
							</td></tr>
							</table>
					</TD>
					<TD align="right" valign=bottom>
							<TABLE>
							<TR><TD align="center"><b>Contact: By Telephone</b></td></tr>
							<tr><td>
									<table class=nav_bar align="Center"  background="pics/phone_background.jpg">
									<TR><td align="center">Host<br>(mm/dd/yy)</td><td align="center">Student<br>(mm/dd/yy)</td></tr>
									<TR><TD>Date: <input type="Text" name="host_date_phone" align="LEFT"  required="No" size="5" maxlength="10" ></td><TD>Date: <input type="Text" name="stu_date_phone" align="LEFT"  required="No" size="5"  maxlength="10" ></td></tr>
									<tr><TD>Date: <input type="Text" name="host_date_phone2" align="LEFT"  required="No" size="5" maxlength="10" ></td><td>Date: <input type="Text" name="stu_date_phone2" align="LEFT"  required="No" size="5"  maxlength="10"></td></tr>
									<tr><TD>Date: <input type="Text" name="host_date_phone3" align="LEFT"  required="No" size="5" maxlength="10" ></td><td>Date: <input type="Text" name="stu_date_phone3" align="LEFT"  required="No" size="5"  maxlength="10" ></td></tr>
									</TABLE>
							</td></tr>
							</table>
				</TD></TR>
				</TABLE>
		</td></tr>
		</Table>
	</td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="right" width="50%"><input name="Submit" type="image" src="../pics/update.gif" border=0 alt=" update ">&nbsp;</td>
		<td align="left" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>
</form>
</cfif>
</td>
</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>