<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif not isDefined("form.email_to")>
		<cfset errorMsg = "Please select at least one Recipient.">
    <cfelse>
    
    	<!--- delete old files. --->
        <cfdirectory directory="#AppPath.temp#" action="list" name="get_files">
        <cfloop query="get_files">
        	<!--- delete older than 2 days. --->
            <cfif dateDiff("d", dateLastModified, now()) GTE 2>
            	<cffile action="delete" file="#AppPath.temp##name#">
            </cfif>
        </cfloop>
        
    	<cfdocument format="PDF" filename="#AppPath.temp#progress_report_#form.pr_id#.pdf" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="../progress_report_info.cfm">
        </cfdocument>
                
        <cfsavecontent variable="email_message">
        <cfoutput>				
            <p>This progress report was sent from the SMG website.</p>
            <p>Please reference the attached PDF file.</p>
        </cfoutput>
        </cfsavecontent>
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#form.email_to#">
            <cfinvokeargument name="email_replyto" value="#client.email#">
            <cfinvokeargument name="email_subject" value="SMG - Progress Report">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#file_path#">
        </cfinvoke>
                        
        <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm" id="theForm">
        <input type="hidden" name="pr_id" value="<cfoutput>#form.pr_id#</cfoutput>">
        </form>
        <script>
        document.theForm.submit();
        </script>
        
	</cfif>
        
<!--- edit --->
<cfelse>

	<cfparam name="form.pr_id" default="">
	<cfif not isNumeric(form.pr_id)>
        a numeric pr_id is required to reject a progress report.
        <cfabort>
	</cfif>

	<cfquery name="get_record" datasource="#application.dsn#">
        SELECT fk_intrep_user
        FROM progress_reports
        WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">
	</cfquery>
    <cfset form.fk_intrep_user = get_record.fk_intrep_user>
    
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
	<td background="pics/header_background.gif"><h2>Email Progress Report</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/pr_email" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="pr_id" value="#form.pr_id#">
<cfinput type="hidden" name="fk_intrep_user" value="#form.fk_intrep_user#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Recipients: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_international_rep" datasource="#application.dsn#">
                SELECT email, businessname
                FROM smg_users
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_intrep_user#">
            </cfquery>
        	<cfoutput>
        	<cfinput type="checkbox" name="email_to" value="#client.email#" required="yes" message="Please select at least one Recipient.">#client.name#<br />
        	<cfinput type="checkbox" name="email_to" value="#get_international_rep.email#">#get_international_rep.businessname#<br />
			</cfoutput>
        </td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
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
