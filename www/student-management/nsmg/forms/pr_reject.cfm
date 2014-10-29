<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif trim(form.pr_rejection_reason) EQ ''>
		<cfset errorMsg = "Please enter the Rejection Reason.">
    <cfelse>
		<!--- send email to users who have approved the report. --->
        <cfset email_to = ''>
        <cfquery name="get_report" datasource="#application.dsn#">
            SELECT *
            FROM progress_reports
            WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
        </cfquery>
		<!--- supervising rep --->
        <cfif get_report.pr_sr_approved_date NEQ ''>
            <cfquery name="get_rep" datasource="#application.dsn#">
                SELECT email
                FROM smg_users
                WHERE userid = 
                <Cfif get_report.fk_reportType eq 2>
             	  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_secondVisitRep#">
                <Cfelse>
               	 <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_sr_user#">
            	</Cfif>
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_rep.email)>
        </cfif>
		<!--- regional advisor (fk_ra_user can be null in database so check just in case) --->
        <cfif get_report.fk_ra_user NEQ '' and get_report.pr_ra_approved_date NEQ ''>
            <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
                SELECT email
                FROM smg_users
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ra_user#">
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_advisor_for_rep.email)>
        </cfif>
    	<!--- regional director (fk_rd_user can be null in database so check just in case) --->
	    <cfif get_report.fk_rd_user NEQ '' and get_report.pr_rd_approved_date NEQ ''>
            <cfquery name="get_regional_director" datasource="#application.dsn#">
                SELECT email
                FROM smg_users
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_rd_user#">
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_regional_director.email)>
        </cfif>
		<!--- facilitator --->
        <cfif get_report.pr_ny_approved_date NEQ ''>
            <cfquery name="get_facilitator" datasource="#application.dsn#">
                SELECT email
                FROM smg_users
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ny_user#">
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_facilitator.email)>
        </cfif>
        <cfif LEN(email_to)>
            <cfquery name="get_student" datasource="#application.dsn#">
                SELECT studentid, firstname, familylastname
                FROM smg_students
                WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_student#">
            </cfquery>
            <cfsavecontent variable="email_message">
            <cfoutput>				
                <p>A report has been rejected.</p>
                <p>Student: #get_student.firstname# #get_student.familylastname# (#get_student.studentid#)</p>
                <p>Rejection Reason:<br />
                #replaceList(form.pr_rejection_reason, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</p>
            </cfoutput>
            </cfsavecontent>
            <cfset emailSubject = "SMG - Report Rejected">
			<cfif get_report.fk_reportType EQ 1>
            	<cfset emailSubject = "SMG - Progress Report Rejected">
            <cfelseif get_report.fk_reportType EQ 2>
            	<cfset emailSubject = "SMG - Second Visit Report Rejected ">
            <cfelse>
            	<cfset emailSubject = "SMG - Confidential Host Family Visit Report Rejected">
            </cfif>
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#email_to#">
                <cfinvokeargument name="email_replyto" value="#client.email#">
                <cfinvokeargument name="email_subject" value="#emailSubject#">
                <cfinvokeargument name="email_message" value="#email_message#">
            </cfinvoke>
        </cfif>

        <cfquery datasource="#application.dsn#">
            UPDATE progress_reports SET
            pr_rejection_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pr_rejection_reason#">,
            pr_rejected_date = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
            fk_rejected_by_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
            pr_sr_approved_date = NULL,
            pr_ra_approved_date = NULL,
            pr_rd_approved_date = NULL,
            pr_ny_approved_date = NULL
            WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
        </cfquery>
        
		<cflocation url="index.cfm?curdoc=progress_reports" addtoken="no">
        
	</cfif>
        
<!--- edit --->
<cfelse>

	<cfparam name="form.pr_id" default="">
	<cfif not isNumeric(form.pr_id)>
        a numeric pr_id is required to reject a progress report.
        <cfabort>
	</cfif>

	<cfquery name="get_record" datasource="#application.dsn#">
        SELECT pr_rejection_reason
        FROM progress_reports
        WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
	</cfquery>
    <cfset form.pr_rejection_reason = get_record.pr_rejection_reason>
    
</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/current_items.gif"></td>
	<td background="pics/header_background.gif"><h2>Reject Report</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/pr_reject" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="pr_id" value="#form.pr_id#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Rejection Reason: <span class="redtext">*</span></td>
        <td><cftextarea name="pr_rejection_reason" value="#form.pr_rejection_reason#" cols="70" rows="10" required="yes" validate="noblanks" message="Please enter the Rejection Reason." /></td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
        <td><font color="FF0000">
            On rejection the following will occur:
            <ul>
                <p><li>The status will return to Pending, and only the Submitting  Rep will be able to view this report.</li></p>
                <p><li>An email will be sent to those who have approved the report.</li></p>
            </ul>
        </font></td>
    </tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0 onclick="return confirm('Are you sure you want to reject this report?')"></td>
	</tr>
</table>

</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- this table is so the form is not 100% width. --->
