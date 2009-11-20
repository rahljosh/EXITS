<cfparam name="form.prdate_id" default="">
<cfif form.prdate_id EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(form.prdate_id)>
        a numeric prdate_id is required to edit a progress report date.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'prdate_date,prdate_comments,fk_prdate_type,fk_prdate_contact'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif not isDate(trim(form.prdate_date))>
		<cfset errorMsg = "Please enter a valid Date.">
	<cfelseif trim(form.fk_prdate_type) EQ ''>
		<cfset errorMsg = "Please select the Type.">
	<cfelseif trim(form.fk_prdate_contact) EQ ''>
		<cfset errorMsg = "Please select the Contact.">
	<cfelseif len(trim(form.prdate_comments)) GT 200>
		<cfset errorMsg = "Please enter Comments 200 characters or less.">
    <cfelse>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO progress_report_dates (fk_progress_report, prdate_date, prdate_comments, fk_prdate_type, fk_prdate_contact)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.pr_id#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.prdate_date#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.prdate_comments#" null="#yesNoFormat(trim(form.prdate_comments) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_prdate_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_prdate_contact#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE progress_report_dates SET
                prdate_date = <cfqueryparam cfsqltype="cf_sql_date" value="#form.prdate_date#">,
                prdate_comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.prdate_comments#" null="#yesNoFormat(trim(form.prdate_comments) EQ '')#">,
                fk_prdate_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_prdate_type#">,
                fk_prdate_contact = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_prdate_contact#">
				WHERE prdate_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prdate_id#">
			</cfquery>
		</cfif>
        <form action="index.cfm?curdoc=lists/progress_report_info" method="post" name="theForm" id="theForm">
        <input type="hidden" name="pr_id" value="<cfoutput>#form.pr_id#</cfoutput>">
        </form>
        <script>
        document.theForm.submit();
        </script>
	</cfif>

<!--- add --->
<cfelseif new>

	<cfparam name="form.pr_id" default="">
	<cfif not isNumeric(form.pr_id)>
        a numeric pr_id is required to add a new progress report date.
        <cfabort>
	</cfif>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM progress_report_dates
		WHERE prdate_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prdate_id#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- pr_id is passed in for a new date, but set it for edit. --->
    <cfset form.pr_id = get_record.fk_progress_report>

</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<script type="text/javascript">
function checkForm() {
	if (document.my_form.fk_prdate_type.value.length == 0) {alert("Please select the Type."); return false; }
	if (document.my_form.fk_prdate_contact.value.length == 0) {alert("Please select the Contact."); return false; }
	return true;
}
</script>

<cfform action="index.cfm?curdoc=forms/pr_date_form" method="post" name="my_form" onSubmit="return checkForm();">

<br />
<!--- outside table --->
<table cellpadding="5" align="center" bgcolor="#ffffff" class="box">
    <tr bgcolor="#C2D1EF">
        <td><span class="get_attention"><b>::</b> Contact Date</span></td>
    </tr>
    <tr>
        <td>

<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="prdate_id" value="#form.prdate_id#">
<cfinput type="hidden" name="pr_id" value="#form.pr_id#">

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Date: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="prdate_date" value="#dateFormat(form.prdate_date, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" required="yes" validate="date" message="Please enter a valid Date."> mm/dd/yyyy</td>
    </tr>
    <tr>
    	<td class="label">Type: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_types" datasource="#application.dsn#">
                SELECT *
                FROM prdate_types
                ORDER BY prdate_type_id
            </cfquery>
            <cfselect name="fk_prdate_type" query="get_types" value="prdate_type_id" display="prdate_type_name" selected="#form.fk_prdate_type#" queryPosition="below">
                <option></option>
            </cfselect>
        </td>
    </tr>
    <tr>
    	<td class="label">Contact: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_contacts" datasource="#application.dsn#">
                SELECT *
                FROM prdate_contacts
                ORDER BY prdate_contact_id
            </cfquery>
            <cfselect name="fk_prdate_contact" query="get_contacts" value="prdate_contact_id" display="prdate_contact_name" selected="#form.fk_prdate_contact#" queryPosition="below">
                <option></option>
            </cfselect>
        </td>
    </tr>
    <tr>
    	<td class="label">Comments:</td>
        <td><cftextarea name="prdate_comments" value="#form.prdate_comments#" cols="35" rows="6" maxlength="200" validate="maxlength" message="Please enter Comments 200 characters or less." /></td>
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
