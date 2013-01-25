<cfset errorMsg = ''>

<cfquery name="get_record" datasource="#application.dsn#">
    SELECT fk_intrep_user
    FROM progress_reports
    WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
</cfquery>

<cfparam name="FORM.automatic" default="0">
<cfif VAL(FORM.automatic)>
	<cfset FORM.submitted = 1>
    <cfset FORM.email_to = CLIENT.userID & "," & get_record.fk_intrep_user>
</cfif>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif not isDefined("form.email_to")>
		<cfset errorMsg = "Please select at least one Recipient.">
    <cfelse>
    
    	<!--- delete old files. --->
        <cfdirectory directory="#APPLICATION.PATH.temp#" action="list" name="get_files">
        <cfloop query="get_files">
        	<!--- delete older than 2 days. --->
            <cfif dateDiff("d", dateLastModified, now()) GTE 2>
            	<cffile action="delete" file="#APPLICATION.PATH.temp##name#">
            </cfif>
        </cfloop>
        
        <cfset file_path = "#APPLICATION.PATH.temp#progress_report_#form.pr_id#.pdf">

    	<cfdocument format="PDF" filename="#file_path#" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="../phpusa.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <!---<cfset form.pdf = 1>--->
            <!--- This variable is to display the images properly if coming from this file --->
            <cfset form.email = "email">
            <cfinclude template="../lists/progress_report_info.cfm">
        </cfdocument>
                
        <cfsavecontent variable="email_message">
        <cfoutput>				
            <p>This progress report was sent from the PHP website.</p>
            <p>Please reference the attached PDF file.</p>
        </cfoutput>
        </cfsavecontent>
        
        <cfquery name="get_emails" datasource="#application.dsn#">
            SELECT email
            FROM smg_users
            WHERE userid IN (#form.email_to#)
        </cfquery>
        
        <cfinvoke component="internal.extensions.components.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#valueList(get_emails.email)#">
            <cfinvokeargument name="email_replyto" value="#client.email#">
            <cfinvokeargument name="email_subject" value="PHP - Progress Report">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#file_path#">
        </cfinvoke>
      	
        <cfif VAL(FORM.automatic)>
			<script type="text/javascript">
                $(document).ready(function() {
					window.open('', '_self', ''); 
					window.close();
                });
            </script>
        <cfelse>               
            <form action="index.cfm?curdoc=lists/progress_report_info" method="post" name="theForm" id="theForm">
            	<input type="hidden" name="pr_id" value="<cfoutput>#form.pr_id#</cfoutput>">
            </form>
            <script>
            	document.theForm.submit();
            </script>
     	</cfif>
        
	</cfif>
        
<!--- edit --->
<cfelse>

	<cfparam name="form.pr_id" default="">
	<cfif not isNumeric(form.pr_id)>
        a numeric pr_id is required to reject a progress report.
        <cfabort>
	</cfif>

    <cfset form.fk_intrep_user = get_record.fk_intrep_user>
     
</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<!--- Don't display anything if this is the automatic email version --->
<cfif NOT VAL(FORM.automatic)>

    <cfform action="index.cfm?curdoc=forms/pr_email" method="post">
    
    <br />
    <!--- outside table --->
    <table cellpadding="5" align="center" bgcolor="#ffffff" class="box">
        <tr bgcolor="#C2D1EF">
            <td><span class="get_attention"><b>::</b> Email Progress Report</span></td>
        </tr>
        <tr>
            <td>
    
    <input type="hidden" name="submitted" value="1">
    <cfinput type="hidden" name="pr_id" value="#form.pr_id#">
    <cfinput type="hidden" name="fk_intrep_user" value="#form.fk_intrep_user#">
    
    <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
    <table border=0 cellpadding=4 cellspacing=0>
        <tr>
            <td class="label">Recipients: <span class="redtext">*</span></td>
            <td>
                <cfquery name="get_international_rep" datasource="#application.dsn#">
                    SELECT businessname
                    FROM smg_users
                    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_intrep_user#">
                </cfquery>
                <cfoutput>
                <cfinput type="checkbox" name="email_to" value="#client.userid#" required="yes" message="Please select at least one Recipient."> #client.firstname# #client.lastname#<br />
                <cfinput type="checkbox" name="email_to" value="#form.fk_intrep_user#"> International Agent <!---#get_international_rep.businessname#---><br />
                </cfoutput>
            </td>
        </tr>
    </table>
    
    <table border=0 cellpadding=4 cellspacing=0 width=100%>
        <tr>
            <td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
        </tr>
    </table>
    
        </td>
      </tr>
    </table>
    <!--- outside table --->
    
    </cfform>

</cfif>