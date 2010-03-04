<link rel="stylesheet" href="../smg.css" type="text/css">

<style type="text/css">
table.nav_bar { font-size: 10px; background-color: #ffffff; border: 1px solid #2E5872; }
</style>

<title>Progress Reports</title>

<table width="100%" cellspacing="5">
  <tr>
    <td>
    
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
		<td background="../pics/header_background.gif"><h2>Progress Reports</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfquery name="get_progress_reports" datasource="#application.dsn#">
    SELECT *
    FROM progress_reports
    WHERE fk_student = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.stuid#">
    ORDER BY pr_id DESC
</cfquery>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
    	<td colspan=6><span class="get_attention"><b>></b></span> <u>Reports Received</u></td>
    </tr>
    <cfif get_progress_reports.recordCount EQ 0>
        <tr>
            <td colspan=6>There are no reports.</td>
        </tr>
    <cfelse>
        <tr align="left">
            <th>&nbsp;</th>
            <th>SR Approved</th>
            <th>RA Approved</th>
            <th>RD Approved</th>
            <th>Facilitator Approved</th>
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
                        <form action="../index.cfm?curdoc=progress_report_info" method="post" name="theForm_#pr_id#" id="theForm_#pr_id#" target="_blank">
                        <input type="hidden" name="pr_id" value="#pr_id#">
                        </form>
                        <a href="javascript:document.theForm_#pr_id#.submit();">View</a>
                    </cfif>
                </td>
                <td>#dateFormat(pr_sr_approved_date, 'mm/dd/yyyy')#</td>
                <td>
                    <cfif fk_ra_user EQ ''>
                        N/A
                    <cfelse>
                        #DateFormat(get_progress_reports.pr_ra_approved_date, 'mm/dd/yyyy')#
                    </cfif>
                </td>
                <td>#DateFormat(pr_rd_approved_date, 'mm/dd/yyyy')#</td>
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
    WHERE smg_prquestion_details.stuid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.stuid#">
    ORDER BY smg_prquestion_details.report_number DESC
</cfquery>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
    	<td colspan=6><span class="get_attention"><b>></b></span> <u>Reports Received prior to 09/16/2009</u></td>
    </tr>
    <cfif get_old_progress_reports.recordCount EQ 0>
        <tr>
            <td colspan=6>There are no reports.</td>
        </tr>
    <cfelse>
        <tr align="left">
            <th>&nbsp;</th>
            <th>Submitted</th>
            <th>RA</th>
            <th>RD</th>
            <th>NY</th>
            <th>Type</th>
        </tr>
        <cfoutput query="get_old_progress_reports">
            <tr bgcolor="#iif(currentRow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><a href="../index.cfm?curdoc=forms/view_progress_report&number=#report_number#" target="_blank">View</a></td>
                <td>#DateFormat(date_submitted, 'mm/dd/yyyy')#</td>
                <td><cfif date_ra_approved is ''>N/A<cfelse>#DateFormat(date_ra_approved, 'mm/dd/yyyy')#</cfif></td>
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

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>