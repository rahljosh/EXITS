<span class="application_section_header">Progress Report</span><br>

<cfquery name="student_host_name" datasource="caseusa">
select smg_students.firstname, smg_students.familylastname, smg_students.arearepid
from smg_students
where studentid =#url.stu#
</cfquery>
<Cfoutput>
<table>
	<tr>
		<td>Student Name: #student_host_name.firstname# #student_host_name.familylastname# <br>
Month of Report: 
<cfif url.month eq 10>October<br> <font size=-2>Due Oct <cfif client.companyid EQ 1>15th<cfelse>1st</cfif> - include information from arrival thru Oct <cfif client.companyid EQ 1>15<cfelse>1</cfif></font></cfif> 
<cfif url.month eq 12>December<br> <font size=-2>Due Dec <cfif client.companyid EQ 1>15th<cfelse>1st</cfif> - include information from Oct <cfif client.companyid EQ 1>15<cfelse>1</cfif> thru Dec <cfif client.companyid EQ 1>15<cfelse>1</cfif></font></cfif> 
<cfif url.month eq 2>February<br> <font size=-2>Due Feb <cfif client.companyid EQ 1>15th<cfelse>1st</cfif> - include information from  Dec <cfif client.companyid EQ 1>15<cfelse>1</cfif> thru <cfif client.companyid is 2>Feb<cfelse>Jan</cfif> <cfif client.companyid EQ 1>15<cfelse>1</cfif></font></cfif> 
<cfif url.month eq 4>April<br> <font size=-2>Due April <cfif client.companyid EQ 1>15th<cfelse>1st</cfif> - include information from Feb <cfif client.companyid EQ 1>15<cfelse>1</cfif>  thru <cfif client.companyid is 2>March<cfelse>April</cfif> <cfif client.companyid EQ 1>15<cfelse>1</cfif></font></cfif> 
<cfif url.month eq 6>June<br> <font size=-2>Due June <cfif client.companyid EQ 1>15th<cfelse>1st</cfif> - include information from April  <cfif client.companyid EQ 1>15<cfelse>1</cfif>  thru <cfif client.companyid is 2>June<cfelse>May</cfif>  <cfif client.companyid EQ 1>15<cfelse>1</cfif></font></cfif> 
<cfif url.month eq 8>August<br> <font size=-2>Due August <cfif client.companyid is 7>31st<cfelse>1st</cfif> - include information from June  <cfif client.companyid is 7>15<cfelse>1</cfif> thru <cfif client.companyid is 2>July<cfelse>July</cfif>  <cfif client.companyid is 2>15<cfelse>31</cfif></font></cfif> 

</td><td width=40%>ANY REPORT RECEIVED MORE THAN 30 DAYS LATE IN ARRIVING WILL NOT BE ACCEPTED FOR PAYMENT.</td>
	</tr>
</table>
</Cfoutput>
<br>
 Contact Dates: <font size=-2>Each report must show monthly contact & bimonthly in-person contact.</font><br>
 <Cfoutput><cfform method="post" action="querys/insert_progress_report.cfm?stuid=#url.stu#">
 <input type="hidden" value=#url.month# name="month_of_report">
<TABLE >
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
									<TD align="right">Date: <input type="Text" name="host_date_inperson" align="LEFT"  required="No" size="8" maxlength="10" ></td><TD align="right">Date: <input type="Text" name="stu_date_inperson" align="LEFT"  required="No" size="8" maxlength="10" ></td>
								</tr>
								<tr>
									<TD align="right">Date: <input type="Text" name="host_date_inperson2" align="LEFT"  required="No" size="8" maxlength="10" ></td><td align="right">Date: <input type="Text" name="stu_date_inperson2" align="LEFT"  required="No" size="8" maxlength="10" ></td>
								</tr>
								<tr>
									<TD align="right">Date: <input type="Text" name="host_date_inperson3" align="LEFT"  required="No" size="8" maxlength="10" ></td><td align="right">Date: <input type="Text" name="stu_date_inperson3" align="LEFT"  required="No" size="8" maxlength="10" ></td>
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
									<TD>Date: <input type="Text" name="host_date_phone" align="LEFT"  required="No" size="8" maxlength="10" ></td><TD>Date: <input type="Text" name="stu_date_phone" align="LEFT"  required="No" size="8" maxlength="10" ></td>
								</tr>
								<tr>
									<TD>Date: <input type="Text" name="host_date_phone2" align="LEFT"  required="No" size="8" maxlength="10" ></td><td>Date: <input type="Text" name="stu_date_phone2" align="LEFT"  required="No" size="8" maxlength="10" ></td>
								</tr>
								<tr>
									<TD>Date: <input type="Text" name="host_date_phone3" align="LEFT"  required="No" size="8" maxlength="10" ></td><td>Date: <input type="Text" name="stu_date_phone3" align="LEFT"  required="No" size="8" maxlength="10" ></td>
								</tr>

							</TABLE>
						</td>
					</tr>
				</table>
			
		</TD>

	</TR>
</TABLE>
<cfquery name="questions" datasource="caseusa">
select * from smg_prquestions
where companyid = #client.companyid# 
and active = 1 and month = #url.month#
</cfquery>
<input type="hidden" name="number_questions" value=#questions.recordcount#>

<br>
<cfif questions.recordcount eq 0>
<div align="center"><h1>Questions have not been submitted for the time period of this report, please check back later.</h1></div>
</cfif>
<TABLE width=65%>

<Cfloop query="questions">

	<TR>
		<TD>#text#<input type="hidden" name="#questions.currentrow#_question_number" value=#id#></td>
		
		<td><cfif yn is 'yes'>Yes <input type=radio name="#questions.currentrow#_yn" value="Yes" checked></td><td>No<input type=radio name="#questions.currentrow#_yn" value="No" ></td></cfif>
		
	</tr>
	<tr>
		<td colspan=3>Comments:<br><cftextarea  name="#questions.currentrow#_answer" cols="60" rows="5" wrap="VIRTUAL"></cftextarea></td>
	</tr>
	</cfloop>
</table>
<Br>
<table align="center">
	<tr>
		<td colspan=2>To save this information so you can edit it later, check the box below and click next.<br>  If you are ready 
		for the report to be submitted for review, don not check box and click next.</td>
	</tr>
	<tr>
		<td align="center"><input type="checkbox" name="save" value=1>Check to Save report, will not process.<br><input type="image" src="pics/next.gif" border=0 alt="next"></td>
	</tr>
</table>
Please click Next only once...
<br><br>
<a href="../index.cfm">Back to student report list</a>
</cfform>
</cfoutput>