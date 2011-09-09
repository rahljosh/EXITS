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
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_sr_user#">
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_rep.email)>
        </cfif>
		<!--- school supervising rep (fk_ssr_user can be null in database so check just in case) --->
        <cfif get_report.fk_ssr_user NEQ '' and get_report.pr_ssr_approved_date NEQ ''>
            <cfquery name="get_school_rep" datasource="#application.dsn#">
                SELECT email
                FROM smg_users
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ssr_user#">
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_school_rep.email)>
        </cfif>
		<!--- NY --->
        <cfif get_report.pr_ny_approved_date NEQ ''>
            <cfquery name="get_ny" datasource="#application.dsn#">
                SELECT email
                FROM smg_users
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ny_user#">
            </cfquery>
	        <cfset email_to = listAppend(email_to, get_ny.email)>
        </cfif>
        <cfif email_to NEQ ''>
            <cfquery name="get_student" datasource="#application.dsn#">
                SELECT studentid, firstname, familylastname
                FROM smg_students
                WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_student#">
            </cfquery>
            <cfsavecontent variable="email_message">
            <cfoutput>				
                <p>A progress report has been rejected.</p>
                <p>Student: #get_student.firstname# #get_student.familylastname# (#get_student.studentid#)</p>
                <p>Rejection Reason:<br />
                #replaceList(form.pr_rejection_reason, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</p>
            </cfoutput>
            </cfsavecontent>
            <cfinvoke component="internal.extensions.components.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#email_to#">
                <cfinvokeargument name="email_replyto" value="#client.email#">
                <cfinvokeargument name="email_subject" value="PHP - Progress Report Rejected">
                <cfinvokeargument name="email_message" value="#email_message#">
            </cfinvoke>
        </cfif>

        <cfquery datasource="#application.dsn#">
            UPDATE progress_reports SET
            pr_rejection_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pr_rejection_reason#">,
            pr_rejected_date = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
            fk_rejected_by_user = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
            pr_sr_approved_date = NULL,
            pr_ssr_approved_date = NULL,
            pr_ny_approved_date = NULL
            WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
        </cfquery>
        
		<cflocation url="index.cfm?curdoc=lists/progress_reports" addtoken="no">
        
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

<cfform action="index.cfm?curdoc=forms/pr_reject" method="post">

<br />
<!--- outside table --->
<table cellpadding="5" align="center" bgcolor="#ffffff" class="box">
    <tr bgcolor="#C2D1EF">
        <td><span class="get_attention"><b>::</b> Reject Progress Report</span></td>
    </tr>
    <tr>
        <td>

<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="pr_id" value="#form.pr_id#">

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Rejection Reason: <span class="redtext">*</span></td>
        <td><cftextarea name="pr_rejection_reason" value="#form.pr_rejection_reason#" cols="70" rows="10" required="yes" validate="noblanks" message="Please enter the Rejection Reason." /></td>
    </tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
    <tr>
        <td><font color="FF0000">
            On rejection the following will occur:
            <ul>
                <p><li>The status will return to Pending, and only the Supervising Rep will be able to view this report.</li></p>
                <p><li>An email will be sent to those who have approved the report.</li></p>
            </ul>
        </font></td>
    </tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100%>
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0 onclick="return confirm('Are you sure you want to reject this report?')"></td>
	</tr>
</table>

    </td>
  </tr>
</table>
<!--- outside table --->

</cfform>
