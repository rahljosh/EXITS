<!----Create Temp Login---->

 <cfset CLIENT.company_submitting = "www.student-management.com">
        <cfset APPLICATION.company_short = "SMG">
        <cfset CLIENT.app_menu_comp = 5>
        <cfset CLIENT.exits_url = "www.student-management.com">
        




<!--- need to use url.hostid since there's a client.hostid but phase client.hostid out. --->
<cfparam name="url.hostid" default="">
<cfif url.hostid EQ "">
	<cfset new = true>
<cfelse>
	<cfif not isNumeric(url.hostid)>
        a numeric hostid is required.
        <cfabort>
	</cfif>
	<cfset new = false>
</cfif>

<cfset field_list = 'familylastname,address,address2,city,state,zip,phone,email,fatherlastname,fatherfirstname,fathermiddlename,fatherdob,fatherssn,fatherworktype,father_cell,motherlastname,motherfirstname,mothermiddlename,motherdob,motherssn,motherworktype,mother_cell,regionid'>

<!--- the key for encrypting and decrypting the ssn. --->
<cfset ssn_key = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>
    
	<cfif form.lookup_success NEQ "1">
		<cfset errorMsg = 'Please lookup the address.'>
	<cfelseif trim(form.familylastname) EQ "">
		<cfset errorMsg = "Please enter the Family Name.">
	<cfelseif application.address_lookup NEQ 2 and trim(form.address) EQ ''>
		<cfset errorMsg = "Please enter the Address.">
	<cfelseif application.address_lookup NEQ 2 and trim(form.city) EQ ''>
		<cfset errorMsg = "Please enter the City.">
	<cfelseif application.address_lookup NEQ 2 and trim(form.state) EQ ''>
		<cfset errorMsg = "Please select the State.">
	<cfelseif application.address_lookup NEQ 2 and not isValid("zipcode", trim(form.zip))>
		<cfset errorMsg = "Please enter a valid Zip.">        
	<cfelseif trim(form.phone) EQ '' and trim(form.father_cell) EQ '' and trim(form.mother_cell) EQ ''>
		<cfset errorMsg = "Please enter one of the Phone fields.">
	<cfelseif trim(form.phone) NEQ '' and not isValid("telephone", trim(form.phone))>
		<cfset errorMsg = "Please enter a valid Phone.">
	<cfelseif trim(form.email) NEQ '' and not isValid("email", trim(form.email))>
		<cfset errorMsg = "Please enter a valid Email.">
	<cfelseif trim(form.fatherdob) NEQ '' and not isValid("date", trim(form.fatherdob))>
		<cfset errorMsg = "Please enter a valid Father's Date of Birth.">
	<cfelseif isDefined("form.fatherssn") and trim(form.fatherssn) NEQ '' and not isValid("social_security_number", trim(form.fatherssn))>
		<cfset errorMsg = "Please enter a valid Father's SSN.">
	<cfelseif trim(form.father_cell) NEQ '' and not isValid("telephone", trim(form.father_cell))>
		<cfset errorMsg = "Please enter a valid Father's Cell Phone.">
	<cfelseif trim(form.motherdob) NEQ '' and not isValid("date", trim(form.motherdob))>
		<cfset errorMsg = "Please enter a valid Mother's Date of Birth.">
	<cfelseif isDefined("form.motherssn") and trim(form.motherssn) NEQ '' and not isValid("social_security_number", trim(form.motherssn))>
		<cfset errorMsg = "Please enter a valid Mother's SSN.">
	<cfelseif trim(form.mother_cell) NEQ '' and not isValid("telephone", trim(form.mother_cell))>
		<cfset errorMsg = "Please enter a valid Mother's Cell Phone.">
	<cfelseif new and form.regionid EQ ''>
		<cfset errorMsg = "Please select the Region.">
	<cfelse>
    	<!--- encrypt the SSN. --->
		<cfif isDefined("form.fatherssn") and trim(form.fatherssn) NEQ ''>
            <cfset form.fatherssn = encrypt("#trim(form.fatherssn)#", "#ssn_key#", "desede", "hex")>
        </cfif>
		<cfif isDefined("form.motherssn") and trim(form.motherssn) NEQ ''>
            <cfset form.motherssn = encrypt("#trim(form.motherssn)#", "#ssn_key#", "desede", "hex")>
        </cfif>
        <!--- set the birth year field from the birth date field. --->
        <cfif trim(form.fatherdob) NEQ ''>
        	<cfset fatherbirth = year(trim(form.fatherdob))>
        <cfelse>
        	<cfset fatherbirth = 0>
        </cfif>
        <cfif trim(form.motherdob) NEQ ''>
        	<cfset motherbirth = year(trim(form.motherdob))>
        <cfelse>
        	<cfset motherbirth = 0>
        </cfif>
		<cfif new>
        	<cflock timeout="30">
                <cfquery datasource="#application.dsn#">
                    INSERT INTO smg_hosts (familylastname, fatherlastname, fatherfirstname, fathermiddlename, fatherbirth, fatherdob, fatherssn, fatherworktype, father_cell,
                        motherfirstname, motherlastname, mothermiddlename, motherbirth, motherdob, motherssn, motherworktype, mother_cell,
                        address, address2, city, state, zip, phone, email, companyid, regionid, arearepid)
                    VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.familylastname#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherlastname#" null="#yesNoFormat(trim(form.fatherlastname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherfirstname#" null="#yesNoFormat(trim(form.fatherfirstname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fathermiddlename#" null="#yesNoFormat(trim(form.fathermiddlename) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#fatherbirth#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.fatherdob#" null="#yesNoFormat(trim(form.fatherdob) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherssn#" null="#yesNoFormat(trim(form.fatherssn) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherworktype#" null="#yesNoFormat(trim(form.fatherworktype) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.father_cell#" null="#yesNoFormat(trim(form.father_cell) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherfirstname#" null="#yesNoFormat(trim(form.motherfirstname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherlastname#" null="#yesNoFormat(trim(form.motherlastname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mothermiddlename#" null="#yesNoFormat(trim(form.mothermiddlename) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#motherbirth#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.motherdob#" null="#yesNoFormat(trim(form.motherdob) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherssn#" null="#yesNoFormat(trim(form.motherssn) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherworktype#" null="#yesNoFormat(trim(form.motherworktype) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mother_cell#" null="#yesNoFormat(trim(form.mother_cell) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#" null="#yesNoFormat(trim(form.phone) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" null="#yesNoFormat(trim(form.email) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                    )  
                </cfquery>
                <cfquery name="get_id" datasource="#application.dsn#">
                    SELECT MAX(hostid) AS hostid
                    FROM smg_hosts
                </cfquery>
            </cflock>
            <!--- the client variable should be phased out after host_fam_pis_2, etc. are modified to use url.hostid --->
			<cfset client.hostid = get_id.hostid>
            <cflocation url="index.cfm?curdoc=host_fam_info&hostid=#get_id.hostid#" addtoken="No">
		<!--- edit --->
		<cfelse>
			<cfquery datasource="#application.dsn#">
				UPDATE smg_hosts SET
                familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.familylastname#">,
                fatherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherlastname#" null="#yesNoFormat(trim(form.fatherlastname) EQ '')#">,
                fatherfirstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherfirstname#" null="#yesNoFormat(trim(form.fatherfirstname) EQ '')#">,
                fathermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fathermiddlename#" null="#yesNoFormat(trim(form.fathermiddlename) EQ '')#">,
                fatherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#fatherbirth#">,
                fatherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#form.fatherdob#" null="#yesNoFormat(trim(form.fatherdob) EQ '')#">,
                <cfif isDefined("form.fatherssn")>
                	fatherssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherssn#" null="#yesNoFormat(trim(form.fatherssn) EQ '')#">,
                </cfif>
                fatherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherworktype#" null="#yesNoFormat(trim(form.fatherworktype) EQ '')#">,
                father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.father_cell#" null="#yesNoFormat(trim(form.father_cell) EQ '')#">,
                motherfirstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherfirstname#" null="#yesNoFormat(trim(form.motherfirstname) EQ '')#">,
                motherlastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherlastname#" null="#yesNoFormat(trim(form.motherlastname) EQ '')#">,
                mothermiddlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mothermiddlename#" null="#yesNoFormat(trim(form.mothermiddlename) EQ '')#">,
                motherbirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#motherbirth#">,
                motherdob = <cfqueryparam cfsqltype="cf_sql_date" value="#form.motherdob#" null="#yesNoFormat(trim(form.motherdob) EQ '')#">,
                <cfif isDefined("form.motherssn")>
                	motherssn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherssn#" null="#yesNoFormat(trim(form.motherssn) EQ '')#">,
                </cfif>
                motherworktype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherworktype#" null="#yesNoFormat(trim(form.motherworktype) EQ '')#">,
                mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mother_cell#" null="#yesNoFormat(trim(form.mother_cell) EQ '')#">,
                address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#" null="#yesNoFormat(trim(form.phone) EQ '')#">,
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" null="#yesNoFormat(trim(form.email) EQ '')#">
				WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">
			</cfquery>
            <cflocation url="index.cfm?curdoc=host_fam_info&hostid=#url.hostid#" addtoken="No">
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
    
    <!--- allow SSN --->
	<cfset form.allow_fatherssn = 1>
	<cfset form.allow_motherssn = 1>
    
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="#application.dsn#">
		SELECT *
		FROM smg_hosts
		WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.hostid#">
	</cfquery>
	<cfloop list="#field_list#" index="counter">
    	<cfset "form.#counter#" = evaluate("get_record.#counter#")>
	</cfloop>
    
    <!--- the default values in the database for these used to be "na", so remove any. --->
    <cfif form.father_cell EQ 'na'>
    	<cfset form.father_cell = ''>
    </cfif>
    <cfif form.mother_cell EQ 'na'>
    	<cfset form.mother_cell = ''>
    </cfif>

	<!--- lookup_success may be set to 1 to not require lookup on edit. --->
	<cfset form.lookup_success = 0>
    <cfset form.lookup_address = '#get_record.address##chr(13)##chr(10)##get_record.city# #get_record.state# #get_record.zip#'>

    <cfquery name="user_compliance" datasource="#application.dsn#">
        SELECT compliance
        FROM smg_users
        WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
    </cfquery>
	<cfset form.allow_fatherssn = 0>
	<cfset form.allow_motherssn = 0>
	<!--- SSN: allow if null, or if not null and the user has access. --->
	<cfif get_record.fatherssn EQ '' or user_compliance.compliance EQ 1>
		<cfset form.allow_fatherssn = 1>
        <cfif get_record.fatherssn NEQ ''>
			<cfset form.fatherssn = decrypt(get_record.fatherssn, "#ssn_key#", "desede", "hex")>
        </cfif>
	</cfif>
	<cfif get_record.motherssn EQ '' or user_compliance.compliance EQ 1>
		<cfset form.allow_motherssn = 1>
        <cfif get_record.motherssn NEQ ''>
			<cfset form.motherssn = decrypt(get_record.motherssn, "#ssn_key#", "desede", "hex")>
        </cfif>
	</cfif>

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
	if (document.my_form.phone.value.length == 0 && document.my_form.father_cell.value.length == 0 && document.my_form.mother_cell.value.length == 0) {alert("Please enter one of the Phone fields."); return false; }
	<cfif new>
		if (document.my_form.regionid.value.length == 0) {alert("Please select the Region."); return false; }
	</cfif>
	return true;
}
function lastname(form) {
	form.fatherlastname.value = form.familylastname.value;
	form.motherlastname.value = form.familylastname.value;
}
</script>

<!--- this table is so the form is not 100% width. --->
<table align="center">
  <tr>
    <td>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Host Family Infomation</h2></td>
		<td align="right" background="pics/header_background.gif">
        	<cfif not new>
            	<span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=<cfoutput>#url.hostid#</cfoutput>">overview</a> ]</span>
            </cfif>
        </td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform method="post" action="index.cfm?curdoc=forms/host_fam_form&hostid=#url.hostid#" name="my_form" onSubmit="return checkForm();">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="allow_fatherssn" value="#form.allow_fatherssn#">
<cfinput type="hidden" name="allow_motherssn" value="#form.allow_motherssn#">
<!--- this gets set to 1 by the javascript lookup function on success. --->
<cfinput type="hidden" name="lookup_success" value="#form.lookup_success#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<div class="row">
  <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + One phone field is required</span>
  <table border=0>
    <tr>
        <td class="label">Family Name: <span class="redtext">*</span></td>
        <td colspan=3>
            <!--- automatically fill in last names on new form only. --->
            <cfif new>
                <cfset blurValue = 'javascript:lastname(this.form);'>
            <cfelse>
                <cfset blurValue = ''>
            </cfif>
            <cfinput type="text" name="familylastname" value="#form.familylastname#" size="20" maxlength="150" onBlur="#blurValue#" required="yes" validate="noblanks" message="Please enter the Family Name.">
        </td>
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
        <td colspan=3><cfinput type="text" name="address" value="#form.address#" size="40" maxlength="150" readonly="readonly"></td>
    </tr>
    <tr>
        <td></td>
        <td colspan=3><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label">City</td>
        <td colspan=3><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="150" readonly="readonly"></td>
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
        <td colspan=3>
        	<cfinput type="text" name="address" value="#form.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address.">
            <font size="1">NO PO BOXES</font>
        </td>
    </tr>
    <tr>
        <td></td>
        <td colspan=3><cfinput type="text" name="address2" value="#form.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label">City <span class="redtext">*</span></td>
        <td colspan=3><cfinput type="text" name="city" value="#form.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."></td>
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
        <td class="label">Phone: <span class="redtext">+</span></td>
        <td colspan=3><cfinput type="text" name="phone" value="#form.phone#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Phone."></td>
    </tr>
    <tr>
        <td class="label">Email:</td>
        <td colspan=3><cfinput type="text" name="email" value="#form.email#" size="30" maxlength="200" validate="email" message="Please enter a valid Email."></td>
    </tr>
</table>
</div>

<div class="row1">
<table>
    <tr>
    	<td>&nbsp;</td>
        <th align="left">Father's Information</th>
    </tr>
    <tr>
    	<td class="label">Last Name:</td>
        <td><cfinput type="text" name="fatherlastname" value="#form.fatherlastname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label">First Name:</td>
        <td><cfinput type="text" name="fatherfirstname" value="#form.fatherfirstname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label">Middle Name:</td>
        <td><cfinput type="text" name="fathermiddlename" value="#form.fathermiddlename#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label">Date of Birth:</td>
        <td><cfinput type="text" name="fatherdob" value="#dateFormat(form.fatherdob, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Father's Date of Birth."> mm/dd/yyyy</td>
    </tr>
    <cfif form.allow_fatherssn>
        <tr>
        	<td class="label">SSN:</td>
            <td><cfinput type="text" name="fatherssn" value="#form.fatherssn#" size="11" maxlength="11" mask="999-99-9999" validate="social_security_number" message="Please enter a valid Father's SSN."></td>
        </tr>	
    </cfif>
    <tr>
    	<td class="label">Occupation:</td>
        <td><cfinput type="text" name="fatherworktype" value="#form.fatherworktype#" size="50" maxlength="200"></td>
    </tr>
    <tr>
        <td class="label">Cell Phone: <span class="redtext">+</span></td>
        <td colspan=3><cfinput type="text" name="father_cell" value="#form.father_cell#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Father's Cell Phone."></td>
    </tr>
</table>
</div>

<div class="row">
<table>
    <tr><td>&nbsp;</td><th align="left">Mother's Information</th></tr>
    <tr>
    	<td class="label">Last Name:</td>
        <td><cfinput type="text" name="motherlastname" value="#form.motherlastname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label">First Name:</td>
        <td><cfinput type="text" name="motherfirstname" value="#form.motherfirstname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label">Middle Name:</td>
        <td><cfinput type="text" name="mothermiddlename" value="#form.mothermiddlename#" size="20" maxlength="150"></td>
    </tr>			
    <tr>
    	<td class="label">Date of Birth:</td>
        <td><cfinput type="text" name="motherdob" value="#dateFormat(form.motherdob, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Mother's Date of Birth."> mm/dd/yyyy</td>
    </tr>
    <cfif form.allow_motherssn>
        <tr>
        	<td class="label">SSN:</td>
            <td><cfinput type="text" name="motherssn" value="#form.motherssn#" size="11" maxlength="11" mask="999-99-9999" validate="social_security_number" message="Please enter a valid Mother's SSN."></td>
        </tr>		
    </cfif>
    <tr>
    	<td class="label">Occupation:</td>
        <td><cfinput type="text" name="motherworktype" value="#form.motherworktype#" size="50" maxlength="200"></td>
    </tr>
    <tr>
        <td class="label">Cell Phone: <span class="redtext">+</span></td>
        <td colspan=3><cfinput type="text" name="mother_cell" value="#form.mother_cell#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Mother's Cell Phone."></td>
    </tr>
</table> 		
</div>

<!--- add only.  on edit this is in the "communtify info" section. --->
<cfif new>
    <div class="row1">
    <table>
        <tr>
            <td class="label">Region: <span class="redtext">*</span></td><td> 
            <select name="regionid">
            <cfif client.usertype LTE '4'>
                <!--- all regions --->
                <cfquery name="regions" datasource="#application.dsn#">
                    SELECT regionid, regionname
                    FROM smg_regions 
                    WHERE company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                    AND subofregion = '0'
                    ORDER BY regionname
                </cfquery>
                <option value="">Select Region</option>
            <cfelse>
                <cfquery name="regions" datasource="#application.dsn#">
                    SELECT smg_regions.regionid, smg_regions.regionname 
                    FROM smg_users
                    INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid
                    INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
                    WHERE user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                    AND user_access_rights.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
                </cfquery>
            </cfif>
            <cfoutput query="regions">
                <option value="#regions.regionid#" <cfif form.regionid EQ regions.regionid>selected</cfif>>#regions.regionname#</option>
            </cfoutput>
            </select>
            </td>
        </tr>
    </table> 		
    </div>
</cfif>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
        <cfif not new and client.usertype LTE '4'>
            <td><a href="?curdoc=querys/delete_host&hostid=<cfoutput>#url.hostid#</cfoutput>" onClick="return confirm('You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue.')"><img src="pics/delete.gif" border="0" align="middle"></a></td>
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