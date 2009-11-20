<!----Scripts for reloading page based on selections---->

<cfquery name="programs" datasource="mysql">
    select programname, programid
    from smg_programs
    where companyid = 6
    and active = 1
    ORDER BY programid DESC
</cfquery>

<cfparam default="#programs.programid#" name="url.programid">
<cfparam default=3 name="url.status">
<cfparam default=9 name="url.month">


<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler(form){
var URL = document.formstatus.status.options[document.formstatus.status.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.formprog.programs.options[document.formprog.programs.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler3(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>
<cfquery name="agents_schools" datasource="mysql">
    select schoolid
    from  php_schools
    where supervising_rep = #client.userid#
</cfquery>


<cfquery name="reports_to_approve" datasource="mysql">
select distinct smg_prquestion_details.report_number, smg_students.familylastname, smg_students.firstname, smg_students.studentid, smg_document_tracking.date_submitted,
smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved, smg_document_tracking.ny_accepted,smg_document_tracking.date_rejected,smg_document_tracking.saveonly,
php_students_in_program.programid, smg_programs.programname
from smg_students
LEFT JOIN php_students_in_program on php_students_in_program.studentid = smg_students.studentid
LEFT JOIN smg_prquestion_details on php_students_in_program.studentid = smg_prquestion_details.stuid
LEFT JOIN smg_document_tracking on smg_prquestion_details.report_number = smg_document_tracking.report_number
LEFT JOIN smg_programs on php_students_in_program.programid = smg_programs.programid
where  smg_students.companyid = 6
<!----
<cfloop query=agents_schools>
and smg_students.schoolid = #schoolid#
</cfloop>
---->
and php_students_in_program.active = '1' 
<cfif url.programid neq 0>
and php_students_in_program.programid = <cfqueryparam value="#url.programid#" cfsqltype="cf_sql_integer"> 
</cfif>
<!----
<cfif url.status eq 1>
and smg_document_tracking.date_ra_approved IS NULL  
</cfif>
<cfif url.status eq 2>
and smg_document_tracking.date_ra_approved IS NOT NULL and smg_document_tracking.ny_accepted IS NULL 
</cfif>
<cfif url.status eq 3>
and smg_document_tracking.ny_accepted IS  NULL  and smg_document_tracking.date_rd_approved IS NOT NULL
</cfif>
<cfif url.status eq 4>
and smg_document_tracking.ny_accepted IS NOT NULL  
</cfif>
<cfif url.status eq 5>
and smg_document_tracking.date_submitted IS NOT NULL
</cfif>
---->
order by familylastname
</cfquery>

<table align="center" width=90% cellpadding=0 cellspacing=0 border=0>
    <tr>
        <td><font size="4"><strong>Progress Reports submitted prior to 09/16/2009</strong></font></td>
        <td align="right"><a href="index.cfm?curdoc=lists/progress_reports">Current Progress Reports</a></td>
    </tr>
</table>

<cfoutput>
<Table width=90% align="center">
	<Tr>
		<th align="left">Filter Options</th>
	</Tr>
	<tr>
		<TD>Program:</TD>
		<td>
	<form name="formprog">
		<select name="programs" onChange="javascript:formHandler2()">
		<option value="?curdoc=lists/agent_approve_list&programid=0&status=#url.status#" <cfif url.programid eq 0>selected</cfif>>All</option>
		<cfloop query="programs">
			<option value="?curdoc=lists/agent_approve_list&programid=#programid#&status=#url.status#" <cfif url.programid eq #programid#>selected</cfif>>#programname#</option>
		</cfloop>
		</select>
	</form>
		</td>
	</tr>
	<tr>
	<tr>
		<TD>Report Status:</TD>
		<td>
	<form name="formstatus">
		<select name="status" onChange="javascript:formHandler()">
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=0" <cfif url.status eq 0>selected</cfif>>All</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=5" <cfif url.status eq 5>selected</cfif>>Submitted, no approvals.</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=1" <cfif url.status eq 1>selected</cfif>>Waiting on Agent</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=2" <cfif url.status eq 2>selected</cfif>>Approved by Agent</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=3" <cfif url.status eq 3>selected</cfif>>Waiting on HQ</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=4" <cfif url.status eq 4>selected</cfif>>Approved by HQ</option>
		
		</select>
	</form>
		</td>
	</tr>
	<tr>
<TD>Month of Report:</TD>
		<td>
	<form name="formmonth">
		<select name="month" onChange="javascript:formHandler3()">
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=#url.status#&month=9" <cfif url.month eq 9>selected</cfif>>September</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=#url.status#&month=12" <cfif url.month eq 12>selected</cfif>>December</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=#url.status#&month=2" <cfif url.month eq 2>selected</cfif>>February</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=#url.status#&month=4" <cfif url.month eq 4>selected</cfif>>April</option>
		<option value="?curdoc=lists/agent_approve_list&programid=#url.programid#&status=#url.status#&month=6" <cfif url.month eq 6>selected</cfif>>June</option>

		
		</select>
	</form>
		</td>
	</tr>
</Table>
<Table width=90% align="center">
	<tr>
		<th>Name</th><th>Program</th><th>Submitted</th><th>Rep Approved</th><th>HQ Approved</th><th>Saved</th>
	</tr>
<cfif reports_to_approve.recordcount eq 0>
<tr >
	<td colspan="6" align="center">No records found that match your criteria.</td>
</tr>
<cfelse>

	<Cfloop query="reports_to_approve">
		<tr <cfif reports_to_approve.currentrow mod 2>bgcolor="##ffffff"</cfif>>
			<td>#firstname# #familylastname# (#studentid#)</td>
            <td>#programname#</td>
            <td><A href="?curdoc=forms/view_progress_report&number=#report_number#">#DateFormat(date_submitted, 'mmm dd, yy')#  #TimeFormat(date_submitted, 'h:mm tt')#</A></td>
            <td><A href="?curdoc=forms/view_progress_report&number=#report_number#">#DateFormat(date_rd_approved, 'mmm dd, yy')# #TimeFormat(date_rd_approved, 'h:mm tt')#</A></td>
            <td><A href="?curdoc=forms/view_progress_report&number=#report_number#">#DateFormat(ny_accepted, 'mmm dd, yy')# #TimeFormat(ny_accepted, 'h:mm tt')#</A></td>
            <td><cfif saveonly is 1>YES<CFELSE>NO</cfif></td>
		</tr>
	</Cfloop>
	
</cfif>
</Table>
</cfoutput>



