<cfif not client.usertype LTE 4>
	<h3>You do not have access to this page.</h3>
    <cfabort>
</cfif>

<cfparam name="form.report_id" default="">
<cfif form.report_id EQ "">
	<!--- only global can add a report because you also need to add the ColdFusion template. --->
    <cfif not client.usertype EQ 1>
        you do not have access to add a report.
        <cfabort>
    </cfif>
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(form.report_id)>
        a numeric report_id is required to edit a report category.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'report_name,report_description,report_template,report_active,fk_usertype,fk_report_category'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<!--- checkboxes aren't defined if not checked. --->
    <cfparam name="form.report_active" default="0">

	<cfif trim(form.report_name) EQ ''>
		<cfset errorMsg = "Please enter the Report Name.">
	<cfelseif trim(form.report_template) EQ ''>
		<cfset errorMsg = "Please enter the Template.">
    <cfelse>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_reports (fk_usertype, fk_report_category, report_name, report_description, report_active, report_template)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_usertype#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_report_category#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_description#" null="#yesNoFormat(trim(form.report_description) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#form.report_active#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_template#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_reports SET
                fk_usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_usertype#">,
                fk_report_category = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_report_category#">,
                report_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_name#">,
                report_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_description#" null="#yesNoFormat(trim(form.report_description) EQ '')#">,
                report_active = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.report_active#">,
                report_template = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_template#">
				WHERE report_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_id#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=reports" addtoken="no">
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM smg_reports
		WHERE report_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_id#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
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
	<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
	<td background="pics/header_background.gif"><h2>Report</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=tools/report_form" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="report_id" value="#form.report_id#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Level: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_usertypes" datasource="#application.dsn#">
                SELECT usertypeid, usertype
                FROM smg_usertype
                WHERE usertypeid >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
                AND usertypeid <= 9
                ORDER BY usertypeid
            </cfquery>
            Reports Available for
            <cfselect name="fk_usertype" query="get_usertypes" value="usertypeid" display="usertype" selected="#form.fk_usertype#" />
            and Above
        </td>
    </tr>
    <tr>
    	<td class="label">Category: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_categories" datasource="#application.dsn#">
                SELECT *
                FROM smg_report_categories
                ORDER BY report_category_name
            </cfquery>
            <cfselect name="fk_report_category" query="get_categories" value="report_category_id" display="report_category_name" selected="#form.fk_report_category#" />
        </td>
    </tr>
    <tr>
    	<td class="label">Report Name: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="report_name" value="#form.report_name#" size="65" maxlength="100" required="yes" validate="noblanks" message="Please enter the Report Name."></td>
    </tr>
    <tr>
    	<td class="label">Description:</td>
        <td><cftextarea name="report_description" value="#form.report_description#" cols="50" rows="6" /></td>
    </tr>
    <tr>
    	<td class="label">Active:</td>
        <td><cfinput type="checkbox" name="report_active" value="1" checked="#yesNoFormat(form.report_active EQ 1)#"></td>
    </tr>
<cfif client.usertype EQ 1>
    <tr>
    	<td class="label">Template: <span class="redtext">*</span></td>
        <td>
        	<cfinput type="text" name="report_template" value="#form.report_template#" size="20" maxlength="50" required="yes" validate="noblanks" message="Please enter the Template.">
            .cfm
        </td>
    </tr>
<cfelse>
	<cfinput type="hidden" name="report_template" value="#form.report_template#">
</cfif>
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