<cfparam name="url.schoolid" default="">
<cfif url.schoolid EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(url.schoolid)>
        a numeric schoolid is required.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'schoolname,address,address2,city,state,zip,principal,email,phone,phone_ext,fax,url'>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

	<cfquery name="check_school" datasource="#application.dsn#">
		SELECT schoolid
		FROM smg_schools 
		WHERE schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.schoolname)#">
		AND city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.city)#">
        AND state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.state)#">
        <cfif not new>
        	AND schoolid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">
        </cfif>
	</cfquery>
			 
	<cfif form.lookup_success NEQ 1>
		<cfset errorMsg = 'Please lookup the address.'>
	<cfelseif trim(form.schoolname) EQ ''>
		<cfset errorMsg = "Please enter the School Name.">
	<cfelseif application.address_lookup NEQ 2 and trim(form.address) EQ ''>
		<cfset errorMsg = "Please enter the Address.">
	<cfelseif application.address_lookup NEQ 2 and trim(form.city) EQ ''>
		<cfset errorMsg = "Please enter the City.">
	<cfelseif application.address_lookup NEQ 2 and trim(form.state) EQ ''>
		<cfset errorMsg = "Please select the State.">
	<cfelseif application.address_lookup NEQ 2 and not isValid("zipcode", trim(form.zip))>
		<cfset errorMsg = "Please enter a valid Zip.">
	<cfelseif check_school.recordcount NEQ 0>
		<cfset errorMsg = "Sorry, school ID: #check_school.schoolid# with this School Name, City and State has already been entered in the database.">
	<cfelseif trim(form.principal) EQ "">
		<cfset errorMsg = "Please enter the Contact.">
	<cfelseif trim(form.email) NEQ '' and not isValid("email", trim(form.email))>
		<cfset errorMsg = "Please enter a valid Contact Email.">
	<cfelseif not isValid("telephone", trim(form.phone))>
		<cfset errorMsg = "Please enter a valid Phone.">
	<cfelseif trim(form.fax) NEQ '' and not isValid("telephone", trim(form.fax))>
		<cfset errorMsg = "Please enter a valid Fax.">
	<cfelseif trim(form.url) NEQ '' and not isValid("url", trim(form.url))>
		<cfset errorMsg = "Please enter a valid Web Site starting with http://">
	<cfelse>
		<cfif new>
        	<cflock timeout="30">
                <cfquery datasource="#application.dsn#">
                    INSERT INTO smg_schools (schoolname, address, address2, city, state, zip, principal, email, phone, phone_ext, fax, url)
                    VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.schoolname#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.principal#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" null="#yesNoFormat(trim(form.email) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone_ext#" null="#yesNoFormat(trim(form.phone_ext) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#" null="#yesNoFormat(trim(form.fax) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.url#" null="#yesNoFormat(trim(form.url) EQ '')#">
                    )  
                </cfquery>
                <cfquery name="get_id" datasource="#application.dsn#">
                    SELECT MAX(schoolid) AS schoolid
                    FROM smg_schools
                </cfquery>
            </cflock>
            <cflocation url="index.cfm?curdoc=school_info&schoolid=#get_id.schoolid#" addtoken="No">
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_schools SET
                schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.schoolname#">,
                address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                principal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.principal#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" null="#yesNoFormat(trim(form.email) EQ '')#">,
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                phone_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone_ext#" null="#yesNoFormat(trim(form.phone_ext) EQ '')#">,
                fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#" null="#yesNoFormat(trim(form.fax) EQ '')#">,
                url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.url#" null="#yesNoFormat(trim(form.url) EQ '')#">
				WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">
			</cfquery>
            <cflocation url="index.cfm?curdoc=school_info&schoolid=#url.schoolid#" addtoken="No">
		</cfif>
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = "">
	</cfloop>

	<!--- lookup_success must be 0 to require lookup on add. --->
	<cfset form.lookup_success = 0>
    <cfset form.lookup_address = ''>
        
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM smg_schools
		WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.schoolid#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>

	<!--- lookup_success may be set to 1 to not require lookup on edit. --->
	<cfset form.lookup_success = 0>
    <cfset form.lookup_address = '#get_record.address##chr(13)##chr(10)##get_record.city# #get_record.state# #get_record.zip#'>

</cfif>

<cfif isDefined("errorMsg")>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>

<!--- address lookup turned on. --->
<cfif application.address_lookup>
	<cfinclude template="../includes/address_lookup_#application.address_lookup#.cfm">
<!--- address lookup turned off. --->
<cfelse>
	<!--- set to true so lookup is not required. --->
	<cfset form.lookup_success = 1>
</cfif>

<script type="text/javascript">
function checkForm() {
	<cfif application.address_lookup NEQ 2>
		if (document.my_form.state.value.length == 0) {alert("Please select the State."); return false; }
	</cfif>
	if (document.my_form.lookup_success.value != 1) {alert("Please lookup the address."); return false; }
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
	<td background="pics/header_background.gif"><h2>School Information</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/school_form&schoolid=#url.schoolid#" method="post" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">
<!--- this gets set to 1 by the javascript lookup function on success. --->
<cfinput type="hidden" name="lookup_success" value="#form.lookup_success#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields</span>
<table border=0 cellpadding=4 cellspacing=0>
    <tr>
    	<td class="label">School Name: <span class="redtext">*</span></td>
        <td colspan="3"><cfinput type="text" name="schoolname" value="#form.schoolname#" size="40" maxlength="200" required="yes" validate="noblanks" message="Please enter the School Name."></td>
    </tr>

<!--- address lookup - auto version. --->
<cfif application.address_lookup EQ 2>
    <tr>
        <td class="label">Lookup Address: <span class="redtext">*</span></td>
        <td colspan=3>
            Enter at least the street address and zip code and click "Lookup".<br />
            Address, City, State, and Zip will be automatically filled in.<br />
            Address line 2 should be manually entered if needed.<br />
            <cftextarea name="lookup_address" rows="2" cols="30" value="#form.lookup_address#" /><br />
            <input type="button" value="Lookup" onClick="showLocation();" />
        </td>
    </tr>
    <tr>
    	<td class="label">Address:</td>
        <td colspan="3"><cfinput type="text" name="address" value="#form.address#" size="40" maxlength="200" readonly="readonly"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="3"><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="200"></td>
    </tr>
    <tr>
    	<td class="label">City:</td>
        <td colspan="3"><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="200" readonly="readonly"></td>
    </tr> 
    <tr>
        <td class="label">State:</td>
        <td><cfinput type="text" name="state" value="#form.state#" size="2" maxlength="2" readonly="readonly"></td>
        <td class="zip">Zip:</td>
        <td><cfinput type="text" name="zip" value="#form.zip#" size="5" maxlength="5" readonly="readonly"></td>
    </tr>
<cfelse>
    <tr>
    	<td class="label">Address: <span class="redtext">*</span></td>
        <td colspan="3">
        	<cfinput type="text" name="address" value="#form.address#" size="40" maxlength="200" required="yes" validate="noblanks" message="Please enter the Address.">
            <font size="1">NO PO BOXES</font>
        </td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="3"><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="200"></td>
    </tr>
    <tr>
    	<td class="label">City: <span class="redtext">*</span></td>
        <td colspan="3"><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="200" required="yes" validate="noblanks" message="Please enter the City."></td>
    </tr> 
    <tr>
        <td class="label">State: <span class="redtext">*</span></td>
        <td>
            <cfquery name="get_states" datasource="#application.dsn#">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#form.state#" queryPosition="below">
				<option></option>
			</cfselect>
        </td>
        <td class="zip">Zip: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="zip" value="#form.zip#" size="5" maxlength="5" required="yes" validate="zipcode" message="Please enter a valid Zip."></td>
    </tr>
	<!--- address lookup - simple version. --->
    <cfif application.address_lookup EQ 1>
        <tr>
            <td class="label">Lookup Address: <span class="redtext">*</span></td>
            <td colspan=3><font size="1">
	            Enter Address, City, State, and Zip and click "Lookup".<br />
                Verify the address displayed below, and make any corrections on the form if necessary.<br />
                Address line 2 will not be included below.<br />
                If you have trouble submitting an address, <a href="mailto:<cfoutput>#application.support_email#</cfoutput>?subject=Address Lookup">send it to us</a>.<br />
                <input type="button" value="Lookup" onClick="showLocation();" /><br />
		        <textarea name="lookup_address" readonly="readonly" rows="2" cols="30">Lookup address will be displayed here.</textarea>
            </font></td>
        </tr>
    </cfif>
</cfif>

    <tr>
    	<td class="label">Contact: <span class="redtext">*</span></td>
        <td colspan="3"><cfinput type="text" name="principal" value="#form.principal#" size="30" maxlength="200" required="yes" validate="noblanks" message="Please enter the Contact."></td>
    </tr>
    <tr>
    	<td class="label">Contact Email:</td>
        <td colspan="3"><cfinput type="text" name="email" value="#form.email#" size="30" maxlength="200" validate="email" message="Please enter a valid Contact Email."></td>
    </tr>
<cfif not new>
    <tr>
        <td colspan="4"><font size="1">
        	Masks were recently added to the Phone and Fax fields with (999) 999-9999 format.<br>
            Existing values with 999-999-9999 format might be displayed incorrectly and you will not be able to submit the form.<br>
            Please verify the existing values displayed next to the form field and re-enter if necessary.
        </font></td>
    </tr>
</cfif>
    <tr>
    	<td class="label">Phone: <span class="redtext">*</span></td>
        <td><cfinput type="text" name="phone" value="#form.phone#" size="14" maxlength="14" required="yes" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Phone."> <cfoutput>#form.phone#</cfoutput></td>
        <td class="zip">Ext:</td>
        <td><cfinput type="text" name="phone_ext" value="#form.phone_ext#" size="5" maxlength="20"></td>
    </tr>
    <tr>
    	<td class="label">Fax:</td>
        <td colspan="3"><cfinput type="text" name="fax" value="#form.fax#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Fax."> <cfoutput>#form.fax#</cfoutput></td>
    </tr>
    <tr>
    	<td class="label">Web Site:</td>
        <td colspan="3"><cfinput type="text" name="url" value="#form.url#" size="40" maxlength="200" validate="url" message="Please enter a valid Web Site starting with http://"></td>
    </tr>
</table>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
    	<cfif not new and client.usertype LTE '4'>
			<td><a href="?curdoc=querys/delete_school&schoolid=<cfoutput>#url.schoolid#</cfoutput>" onClick="return confirm('You are about to delete this School. You will not be able to recover this information. Click OK to continue.')"><img src="pics/delete.gif" border="0"></a></td>
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