<!----<p><span class="style1"><a href="index.cfm?curdoc=reports/unplaced_students_wt">Unplaced Students - for self and into placement</a><br>
  <br>
  <br />
    <a href="index.cfm?curdoc=reports/list_students_work_study_wt">List of Students (Work Study)</a></span>
  <br />
  <br />
  <span class="style1"> Tax Back<br />
  <br />
  <a href="index.cfm?curdoc=reports/missing_documents_wt">Missing Documents: sorted by Agent or Int. Rep</a><br />
  <br />
</p>----->

<cfquery name="candidates_expired" datasource="MySql">
	SELECT 	candidateid, enddate, companyid, status
	FROM extra_candidates
	WHERE companyid = '#client.companyid#' AND status!='canceled'
</cfquery>

<cfloop query="candidates_expired">
	<cfif enddate LT Now()> 
		
		<cfquery name="candidates_expired_update" datasource="mysql">
		UPDATE extra_candidates
		SET status='0'
		WHERE candidateid = #candidates_expired.candidateid# AND status!='canceled'
		</cfquery> 
		
	</cfif>
</cfloop>

<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
		<td class="title1">&nbsp; &nbsp; Reports</td>
	</tr>
</table>
<br>
<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
				  <td bordercolor="FFFFFF">
						<span class="style1"><strong>1. International Representative Reports</strong><br />
						<br />
						&nbsp; &nbsp; &nbsp;<a href="http://www.student-management.com/extra/internal/wat/index.cfm?curdoc=reports/all_students_enrolled_wt" class="style4">- All active students</a><br />
						<br />
						&nbsp; &nbsp; &nbsp;<a href="http://www.student-management.com/extra/internal/wat/index.cfm?curdoc=reports/all_canceled_students_enrolled_wt" class="style4">- All cancelled students</a><br />
						<br />
						&nbsp; &nbsp; &nbsp;<a href="http://www.student-management.com/extra/internal/wat/index.cfm?curdoc=reports/ds2019_verification_wt" class="style4">- DS-2019 Verification Report</a></span></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br />
<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
				  <td bordercolor="FFFFFF">
					  <span class="style1"><strong>2. Host Company Reports</strong><br />
                        <br />
                     &nbsp; &nbsp; &nbsp;<a href="http://www.student-management.com/extra/internal/wat/index.cfm?curdoc=reports/students_hired_per_company_wt" class="style4">- All active students</a><br />
                        <br />
                      &nbsp; &nbsp; &nbsp;</a><a href="http://www.student-management.com/extra/internal/wat/index.cfm?curdoc=reports/all_canceled_students_hc_wt" class="style4">- All cancelled students</a></span></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br />
<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="C7CFDC">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
				<tr>
					<td bordercolor="FFFFFF"><span class="style1">
                        <strong>3. Program Reports</strong><br />
                        <br />
						&nbsp; &nbsp; &nbsp;<a href="index.cfm?curdoc=reports/missing_documents_wt"  class="style4">- Missing Documents</a><br />
						<br />
                        &nbsp; &nbsp; &nbsp;<a href="index.cfm?curdoc=reports/unplaced_students_wt" class="style4">- List of Unplaced Students</a><br />
                        <br />
                        &nbsp; &nbsp; &nbsp;<a href="index.cfm?curdoc=reports/list_students_work_study_wt" class="style4">- List of Students for DOS</a><br />
                        <br />
                        &nbsp; &nbsp; &nbsp;<a href="index.cfm?curdoc=reports/taxback" class="style4">- Report for Taxback</a></span>
				  </td>
				</tr>
			</table>
		</td>
	</tr>
</table>
						<span class="style1"><br />
                        <br />
</span>