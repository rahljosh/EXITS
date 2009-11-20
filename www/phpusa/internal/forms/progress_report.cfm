<h1>Progress Report</h1>

<cfquery name="student_host_name" datasource="MySQL">
select smg_students.firstname, smg_students.familylastname, smg_students.arearepid
from smg_students
where studentid =#url.stu#
</cfquery>
<Cfoutput>

<table>
	<tr>
		<td>Student Name: #student_host_name.firstname# #student_host_name.familylastname# <br>
Month of Report: 
<cfif url.month eq 9>September<br> <font size=-2>Due September 15th - include information from arrival thru September 15</font></cfif> 
<cfif url.month eq 12>December<br> <font size=-2>Due December 15th - include information from September 15 thru December 15</font></cfif> 
<cfif url.month eq 2>February<br> <font size=-2>Due February 15th - include information from December 15 thru February 15</font></cfif> 
<cfif url.month eq 4>April<br> <font size=-2>Due April 15th - include information from December 15 thru April 15</font></cfif> 
<cfif url.month eq 6>June<br> <font size=-2>Due June 15th - include information from April 15 thru June 15</font></cfif> 



	</tr>
</table>
</Cfoutput>
 <Cfoutput><cfform method="post" action="querys/insert_progress_report.cfm?stuid=#url.stu#">

<cfquery name="questions" datasource="MySQL">
select * from smg_prquestions
where companyid = #client.companyid# 
and active = 1 and month = #url.month#
</cfquery>
<input type="hidden" name="number_questions" value=#questions.recordcount#>
<input type="hidden" name="month_of_report" value=#url.month# />

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
		<td align="center"><input type="checkbox" name="save" value=1>Check to Save report, will not process.<br><input type="image" src="pics/next.gif" border=0 alt="next"><br />Please click Next only once...</td>
	</tr>
</table>

<br><br>
<a href="../index.cfm">Back to student report list</a>
</cfform>
</cfoutput>