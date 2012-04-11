<link rel="stylesheet" href="../phpusa.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>

<title>Progress Reports</title>

<cfquery name="get_studentid" datasource="#application.dsn#">
    SELECT studentid
    FROM smg_students
    WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.unqid#">
</cfquery>

<br />
<!--- outside table --->
<table cellpadding="5" align="center" bgcolor="#ffffff" class="box">
    <tr bgcolor="#C2D1EF">
        <td><span class="get_attention"><b>::</b> Progress Reports</span></td>
    </tr>
    <tr>
        <td>

<cfquery name="get_progress_reports" datasource="#application.dsn#">
    SELECT progress_reports.*, smg_programs.programname
    FROM progress_reports
    INNER JOIN smg_programs ON progress_reports.fk_program = smg_programs.programid
    WHERE fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_studentid.studentid#">
    ORDER BY pr_id DESC
</cfquery>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
    	<td colspan=6><span class="get_attention"><b>></b> <u>Reports Received</u></span></td>
    </tr>
    <cfif get_progress_reports.recordCount EQ 0>
        <tr>
            <td colspan=6>There are no reports.</td>
        </tr>
    <cfelse>
        <tr align="left">
            <th>&nbsp;</th>
            <th>Program</th>
            <th>SR Approved</th>
            <th>SSR Approved</th>
            <th>NY Approved</th>
            <th>Rejected</th>
        </tr>
        <cfoutput query="get_progress_reports">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td>
					<!--- restrict view of report until the supervising rep approves it.
					(we're intentionally not including the other checks to only allow SR, RA, etc. to view like on the progress report list) --->
                    <cfif pr_sr_approved_date EQ '' and fk_sr_user NEQ client.userid>
                        Pending
                    <cfelse>
                    	<cfif CLIENT.usertype EQ 8>
                            <form action="../lists/progress_report_info.cfm" method="post" name="theForm_#pr_id#" id="theForm_#pr_id#" target="_blank">
                            <input type="hidden" name="pr_id" value="#pr_id#">
                            </form>
                            <a href="javascript:document.theForm_#pr_id#.submit();">View</a>
                        <cfelse>
                            <form action="../index.cfm?curdoc=lists/progress_report_info" method="post" name="theForm_#pr_id#" id="theForm_#pr_id#" target="_blank">
                            <input type="hidden" name="pr_id" value="#pr_id#">
                            </form>
                            <a href="javascript:document.theForm_#pr_id#.submit();">View</a>
                        </cfif>
                    </cfif>
                </td>
                <td>#programname#</td>
                <td>#dateFormat(pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                <td>
					<cfif fk_ssr_user EQ ''>
                       N/A
                    <cfelse>
                        #dateFormat(pr_ssr_approved_date, 'mm/dd/yyyy')#
                    </cfif>
                </td>
                <td>#DateFormat(pr_ny_approved_date, 'mm/dd/yyyy')#</td>
                <td>#DateFormat(pr_rejected_date, 'mm/dd/yyyy')#</td>
            </tr>	
        </cfoutput>
    </cfif>
</table>

<cfquery name="get_old_progress_reports" datasource="#application.dsn#">
    SELECT distinct smg_prquestion_details.report_number, smg_prquestion_details.submit_type,
        smg_document_tracking.date_submitted, smg_document_tracking.date_ra_approved, smg_document_tracking.date_rd_approved, smg_document_tracking.ny_accepted
    FROM smg_prquestion_details
    INNER JOIN smg_document_tracking ON smg_prquestion_details.report_number = smg_document_tracking.report_number
    WHERE smg_prquestion_details.stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_studentid.studentid#">
    ORDER BY smg_prquestion_details.report_number DESC
</cfquery>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
    	<td colspan=5><span class="get_attention"><b>></b> <u>Reports Received prior to 09/16/2009</u></span></td>
    </tr>
    <cfif get_old_progress_reports.recordCount EQ 0>
        <tr>
            <td colspan=5>There are no reports.</td>
        </tr>
    <cfelse>
        <tr align="left">
            <th>&nbsp;</th>
            <th>Submitted</th>
            <th>Rep Approved</th>
            <th>HQ Approved</th>
            <th>Type</th>
        </tr>
        <cfoutput query="get_old_progress_reports">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><a href="../index.cfm?curdoc=forms/view_progress_report&number=#report_number#" target="_blank">View</a></td>
                <td>#DateFormat(date_submitted, 'mm/dd/yyyy')#</td>
                <td>#DateFormat(date_rd_approved, 'mm/dd/yyyy')#</td>
                <td>#DateFormat(ny_accepted, 'mm/dd/yyyy')#</td>
                <td>#submit_type#</td>
            </tr>	
        </cfoutput>
    </cfif>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="center"><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td>
    </tr>
</table>

    </td>
  </tr>
</table>
<!--- outside table --->