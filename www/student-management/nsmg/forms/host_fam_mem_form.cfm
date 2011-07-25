<cfparam name="url.childid" default="">
<cfif url.childid EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(url.childid)>
        a numeric childid is required to edit a family member.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfif new>
	<cfparam name="url.hostid" default="">
	<cfif not isNumeric(url.hostid)>
        a numeric hostid is required to add a new school date.
        <cfabort>
	</cfif>
</cfif>

<cfset field_list = 'name,sex,birthdate,membertype,liveathome'>
<cfset errorMsg = ''>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<!--- not defined if not selected. --->
    <cfparam name="form.sex" default="">
    <cfparam name="form.liveathome" default="">
    
	<cfif trim(form.name) EQ ''>
		<cfset errorMsg = "Please enter the Name.">
	<cfelseif trim(form.sex) EQ ''>
		<cfset errorMsg = "Please select the Sex.">
	<cfelseif not isDate(trim(form.birthdate))>
		<cfset errorMsg = "Please enter a valid Date of Birth.">
	<cfelseif trim(form.membertype) EQ ''>
		<cfset errorMsg = "Please enter the Relation.">
	<cfelseif trim(form.liveathome) EQ ''>
		<cfset errorMsg = "Please select Living at Home.">
	<cfelse>
		<cfif new>
            <cfquery datasource="#application.dsn#">
                INSERT INTO smg_host_children (hostid, name, sex, birthdate, membertype, liveathome)
                VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.birthdate#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertype#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathome#">
                )  
            </cfquery>
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_host_children SET
                name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sex#">,
                birthdate = <cfqueryparam cfsqltype="cf_sql_date" value="#form.birthdate#">,
                membertype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.membertype#">,
                liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.liveathome#">
				WHERE childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.childid#">
			</cfquery>
		</cfif>
        <cflocation url="index.cfm?curdoc=host_fam_info&hostid=#url.hostid#" addtoken="No">
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
		FROM smg_host_children
		WHERE childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.childid#">
        AND isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- hostid is passed in the url for a new date, but set it for edit. --->
    <cfset url.hostid = get_record.hostid>

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
	<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
	<td background="pics/header_background.gif"><h2>&nbsp;&nbsp;Other Family Member</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="?curdoc=forms/host_fam_mem_form&childid=#url.childid#&hostid=#url.hostid#" method="post">
<input type="hidden" name="submitted" value="1">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">Name: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="name" value="#form.name#" size="20" maxlength="50" required="yes" validate="noblanks" message="Please enter the Name."></td>
    </tr>
    <tr>
    	<td class="label">Sex: <span class="redtext">*</span></td>
        <td>
        	<cfinput type="radio" name="sex" value="Male" checked="#yesNoFormat(form.sex EQ 'Male')#" required="yes" message="Please select the Sex.">Male
            <cfinput type="radio" name="sex" value="Female" checked="#yesNoFormat(form.sex EQ 'Female')#">Female
        </td>
    </tr>
    <tr>
    	<td class="label">Date of Birth: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="birthdate" value="#dateFormat(form.birthdate, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" required="yes" validate="date" message="Please enter a valid Date of Birth."> mm/dd/yyyy</td>
    </tr>
    <tr>
    	<td class="label">Relation: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="membertype" value="#form.membertype#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the Relation."></td>
    </tr>
    <tr>
    	<td class="label">Living at Home: <span class="redtext">*</span></td>
        <td>
        	<cfinput type="radio" name="liveathome" value="Yes" checked="#yesNoFormat(form.liveathome EQ 'Yes')#" required="yes" message="Please select Living at Home.">Yes
            <cfinput type="radio" name="liveathome" value="No" checked="#yesNoFormat(form.liveathome EQ 'No')#">No
        </td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
    	<cfif not new>
			<td><a href="index.cfm?curdoc=host_fam_info&delete_child=<cfoutput>#url.childid#&hostid=#url.hostid#</cfoutput>" onClick="return confirm('Are you sure you want to delete this Family Member?')"><img src="pics/delete.gif" border="0"></a></td>
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
