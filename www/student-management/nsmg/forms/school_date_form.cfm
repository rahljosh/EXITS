<cfparam name="url.schooldateid" default="">
<cfif url.schooldateid EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(url.schooldateid)>
        a numeric schooldateid is required to edit a school date.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfif new>
	<cfparam name="url.schoolid" default="">
	<cfif not isNumeric(url.schoolid)>
        a numeric schoolid is required to add a new school date.
        <cfabort>
	</cfif>
</cfif>

<cfset field_list = 'seasonid,enrollment,year_begins,semester_ends,semester_begins,year_ends,orientation_required'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfif trim(form.seasonid) EQ ''>
		<cfset errorMsg = "Please select the Season.">
	<!--- <cfelseif trim(form.enrollment) NEQ '' and not isDate(trim(form.enrollment)) and not ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
		<cfset errorMsg = "Please enter a valid Enrollment/Orientation.">  --->
	<cfelseif trim(form.year_begins) NEQ '' and not isDate(trim(form.year_begins))>
		<cfset errorMsg = "Please enter a valid Year Begins.">
	<cfelseif trim(form.semester_ends) NEQ '' and not isDate(trim(form.semester_ends))>
		<cfset errorMsg = "Please enter a valid 1st Semester Ends.">
	<cfelseif trim(form.semester_begins) NEQ '' and not isDate(trim(form.semester_begins))>
		<cfset errorMsg = "Please enter a valid 2nd Semester Begins.">
	<cfelseif trim(form.year_ends) NEQ '' and not isDate(trim(form.year_ends))>
		<cfset errorMsg = "Please enter a valid Year Ends.">
	<cfelseif not ((trim(form.year_begins) NEQ '' and trim(form.year_ends) NEQ '') or (trim(form.year_begins) NEQ '' and trim(form.semester_ends) NEQ '') or (trim(form.semester_begins) NEQ '' and trim(form.year_ends) NEQ ''))>
		<cfset errorMsg = "Please enter one of the the date combinations.">
	</cfif>
    <cfif errorMsg EQ ''>
        <cfquery name="check_date" datasource="#application.dsn#">
            SELECT schooldateid
            FROM smg_school_dates 
            WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">
            AND seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.seasonid#">
            <cfif not new>
                AND schooldateid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schooldateid#">
            </cfif>
        </cfquery>
		<cfif check_date.recordcount NEQ 0>
            <cfset errorMsg = "Sorry, a date with this season has already been entered for this school.">
        </cfif>
	</cfif>
    <cfif errorMsg EQ ''>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_school_dates (schoolid, seasonid, enrollment, year_begins, semester_ends, semester_begins, year_ends, orientation_required)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.seasonid#">,
                <cfif not ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.enrollment#" null="#yesNoFormat(trim(form.enrollment) EQ '')#">,
                <cfelse> <cfqueryparam cfsqltype="cf_sql_date" value="" >, 
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.year_begins#" null="#yesNoFormat(trim(form.year_begins) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.semester_ends#" null="#yesNoFormat(trim(form.semester_ends) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.semester_begins#" null="#yesNoFormat(trim(form.semester_begins) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.year_ends#" null="#yesNoFormat(trim(form.year_ends) EQ '')#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(form.orientation_requ)#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_school_dates SET
                seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.seasonid#">,
                <cfif not ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
                	enrollment = <cfqueryparam cfsqltype="cf_sql_date" value="#form.enrollment#" null="#yesNoFormat(trim(form.enrollment) EQ '')#">,
                <cfelse>
                	enrollment = <cfqueryparam cfsqltype="cf_sql_date" value="" >,
                </cfif> 
                year_begins = <cfqueryparam cfsqltype="cf_sql_date" value="#form.year_begins#" null="#yesNoFormat(trim(form.year_begins) EQ '')#">,
                semester_ends = <cfqueryparam cfsqltype="cf_sql_date" value="#form.semester_ends#" null="#yesNoFormat(trim(form.semester_ends) EQ '')#">,
                semester_begins = <cfqueryparam cfsqltype="cf_sql_date" value="#form.semester_begins#" null="#yesNoFormat(trim(form.semester_begins) EQ '')#">,
                year_ends = <cfqueryparam cfsqltype="cf_sql_date" value="#form.year_ends#" null="#yesNoFormat(trim(form.year_ends) EQ '')#">,
                orientation_required = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(form.orientation_requ)#">
				WHERE schooldateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schooldateid#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=school_info&schoolid=#url.schoolid#" addtoken="No">
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
		FROM smg_school_dates
		WHERE schooldateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schooldateid#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- schoolid is passed in the url for a new date, but set it for edit. --->
    <cfset url.schoolid = get_record.schoolid>

</cfif>

<cfif errorMsg NEQ ''>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<script type="text/javascript">
function checkForm() {
	if (document.my_form.seasonid.value.length == 0) {alert("Please select the Season."); return false; }
	if (!((document.my_form.year_begins.value.length != 0 && document.my_form.year_ends.value.length != 0) || (document.my_form.year_begins.value.length != 0 && document.my_form.semester_ends.value.length != 0) || (document.my_form.semester_begins.value.length != 0 && document.my_form.year_ends.value.length != 0))) {alert("Please enter one of the the date combinations."); return false; }
    return true;
}
</script>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>School Date</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=forms/school_date_form&schooldateid=#url.schooldateid#&schoolid=#url.schoolid#" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Season: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_seasons" datasource="#application.dsn#">
                SELECT seasonid, season
                FROM smg_seasons
                WHERE active = 1
                ORDER BY season
            </cfquery>
			<cfselect NAME="seasonid" query="get_seasons" value="seasonid" display="season" selected="#form.seasonid#" queryPosition="below">
				<option value="">Select a Season</option>
			</cfselect>        
        </td>
    </tr>
    <cfif not ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
    <tr>
    	<td class="label">Enrollment/Orientation:</td>
        <td><cfinput type="text" name="enrollment" value="#dateFormat(form.enrollment, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Enrollment/Orientation."> mm/dd/yyyy</td>
    </tr>
    <tr>
        <td class="label">Orientation Required:</td>
        <td>
            <input type="radio" name="orientation_requ" value="1" <cfif VAL(FORM.orientation_required) EQ 1>checked</cfif> /> Yes &nbsp;
            <input type="radio" name="orientation_requ" value="0" <cfif VAL(FORM.orientation_required) EQ 0>checked</cfif> /> No
        </td>
    </tr>
    </cfif>
    <tr>
    
        <td colspan="2">
            At least one of the following combination of dates is required: <span class="redtext">*</span><br />
            &nbsp;&nbsp;&nbsp; 1. Year Begins - Year Ends<br />
            &nbsp;&nbsp;&nbsp; 2. Year Begins - 1st Semester Ends<br />
            &nbsp;&nbsp;&nbsp; 3. 2nd Semester Begins - Year Ends
        </td>
    </tr>
    <tr>
    	<td class="label">Year Begins:</td>
        <td><cfinput type="text" name="year_begins" value="#dateFormat(form.year_begins, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Year Begins."> mm/dd/yyyy</td>
    </tr>
    <tr>
    	<td class="label">1st Semester Ends:</td>
        <td><cfinput type="text" name="semester_ends" value="#dateFormat(form.semester_ends, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid 1st Semester Ends."> mm/dd/yyyy</td>
    </tr>
    <tr>
    	<td class="label">2nd Semester Begins:</td>
        <td><cfinput type="text" name="semester_begins" value="#dateFormat(form.semester_begins, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid 2nd Semester Begins."> mm/dd/yyyy</td>
    </tr>
    <tr>
    	<td class="label">Year Ends:</td>
        <td><cfinput type="text" name="year_ends" value="#dateFormat(form.year_ends, 'mm/dd/yyyy')#" class="datePicker" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Year Ends."> mm/dd/yyyy</td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
    	<cfif not new>
			<td><a href="index.cfm?curdoc=school_info&delete_date=<cfoutput>#url.schooldateid#&schoolid=#url.schoolid#</cfoutput>" onClick="return confirm('Are you sure you want to delete this School Date?')"><img src="pics/delete.gif" border="0"></a></td>
        </cfif>
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
