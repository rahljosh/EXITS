<cfif not client.usertype LTE 4>
	<h3>You do not have access to this page.</h3>
    <cfabort>
</cfif>

<cfparam name="form.report_category_id" default="">
<cfif form.report_category_id EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(form.report_category_id)>
        a numeric report_category_id is required to edit a report category.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'report_category_name'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif trim(form.report_category_name) EQ ''>
		<cfset errorMsg = "Please enter the Category.">
    <cfelse>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_report_categories (report_category_name)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_category_name#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_report_categories SET
                report_category_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_category_name#">
				WHERE report_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_category_id#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=tools/reports" addtoken="no">
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
		FROM smg_report_categories
		WHERE report_category_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.report_category_id#">
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
	<td background="pics/header_background.gif"><h2>Report Category</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=tools/report_category_form" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="report_category_id" value="#form.report_category_id#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Category: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="report_category_name" value="#form.report_category_name#" size="65" maxlength="100" required="yes" validate="noblanks" message="Please enter the Category."></td>
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