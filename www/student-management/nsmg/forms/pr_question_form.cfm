<cfset field_list = 'fk_prquestion,x_pr_question_response'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

    <cfquery datasource="#application.dsn#">
        UPDATE x_pr_questions SET
        x_pr_question_response = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.x_pr_question_response#" null="#yesNoFormat(trim(form.x_pr_question_response) EQ '')#">
        WHERE x_pr_question_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.x_pr_question_id#">
    </cfquery>
    <form action="index.cfm?curdoc=progress_report_info" method="post" name="theForm" id="theForm">
    <input type="hidden" name="pr_id" value="<cfoutput>#form.pr_id#</cfoutput>">
    </form>
    <script>
    document.theForm.submit();
    </script>

<!--- edit --->
<cfelse>

	<cfparam name="form.x_pr_question_id" default="">
	<cfif not isNumeric(form.x_pr_question_id)>
        a numeric x_pr_question_id is required to add a new progress report date.
        <cfabort>
	</cfif>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM x_pr_questions
		WHERE x_pr_question_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.x_pr_question_id#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>

    <cfset form.pr_id = get_record.fk_progress_report>
   
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
	<td background="pics/header_background.gif"><h2>Question</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/pr_question_form" method="post">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="x_pr_question_id" value="#form.x_pr_question_id#">
<cfinput type="hidden" name="fk_prquestion" value="#form.fk_prquestion#">
<cfinput type="hidden" name="pr_id" value="#form.pr_id#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<table border=0 cellpadding=4 cellspacing=0>
    <tr>
        <th align="left">
            <cfquery name="get_question" datasource="#application.dsn#">
                SELECT text
                FROM smg_prquestions
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_prquestion#">
            </cfquery>
			<cfoutput>#get_question.text#</cfoutput>
        </th>
    </tr>
    <tr>
        <td><cftextarea name="x_pr_question_response" value="#form.x_pr_question_response#" cols="65" rows="15" /></td>
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
