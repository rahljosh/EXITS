<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Start Host App</title>




<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
function ShowHide(){
$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
}
//]]>
</script>
<!----Copy Fields---->
<script type="text/javascript" language="JavaScript">
<!--
function FillFields(box) 
{
if(box.checked == false) { return; }
document.my_form.mailing_address.value  = document.my_form.address.value ;
document.my_form.mailing_address2.value = document.my_form.address2.value;
document.my_form.mailing_city.value = document.my_form.city.value;
document.my_form.mailing_state.value = document.my_form.state.value;
document.my_form.mailing_zip.value = document.my_form.zip.value;
}
//-->
</script>
</head>



<!--- need to use url.hostid since there's a client.hostid but phase client.hostid out. --->



	
	<cfset new = false>

<cfparam name="form.fatherfullpart" default='null'>
<cfparam name="form.motherfullpart" default='null'>

<cfset field_list = 'familylastname,address,address2,city,state,zip,phone,email,fatherlastname,fatherfirstname,fathermiddlename,fatherdob,fatherssn,fatherworktype,father_cell,motherlastname,motherfirstname,mothermiddlename,motherdob,motherssn,motherworktype,mother_cell,regionid,fatherfullpart,motherfullpart,mailing_address,mailing_address2,mailing_city,mailing_state,mailing_zip,homeIsFunctBusiness,homeBusinessDesc'>

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
   cfelseif not isDefined('form.fatherfullpart')>
		<cfset form.fatherfullpart = 3>
    <cfelseif not isDefined('form.motherfullpart')>
		<cfset form.motherfullpart = 3> 
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
	<!----<cfelseif isDefined("form.fatherssn") and trim(form.fatherssn) NEQ '' and not isValid("social_security_number", trim(form.fatherssn))>
		<cfset errorMsg = "Please enter a valid Father's SSN.">---->
	<cfelseif trim(form.father_cell) NEQ '' and not isValid("telephone", trim(form.father_cell))>
		<cfset errorMsg = "Please enter a valid Father's Cell Phone.">
	<cfelseif trim(form.motherdob) NEQ '' and not isValid("date", trim(form.motherdob))>
		<cfset errorMsg = "Please enter a valid Mother's Date of Birth.">
	<!----<cfelseif isDefined("form.motherssn") and trim(form.motherssn) NEQ '' and not isValid("social_security_number", trim(form.motherssn))>
		<cfset errorMsg = "Please enter a valid Mother's SSN.">---->
	<cfelseif trim(form.mother_cell) NEQ '' and not isValid("telephone", trim(form.mother_cell))>
		<cfset errorMsg = "Please enter a valid Mother's Cell Phone.">
	<!----<cfelseif new and form.regionid EQ ''>
		<cfset errorMsg = "Please select the Region.">---->
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
<!----
		<cfif new>
        	<cflock timeout="30">
                <cfquery datasource="mysql">
                    INSERT INTO smg_hosts (familylastname, fatherlastname, fatherfirstname, fathermiddlename, fatherbirth, fatherdob, <!----fatherssn,----> fatherworktype, father_cell,
                        motherfirstname, motherlastname, mothermiddlename, motherbirth, motherdob, <!----motherssn,----> motherworktype, mother_cell,
                        address, address2, city, state, zip, phone, email, homeIsFunctBusiness, homeBusinessDesc, companyid, <!----regionid, arearepid,----> date_record_entered, fatherfullpart, motherfullpart, mailing_address, mailing_address2, mailing_city, mailing_state, mailing_zip)
                    VALUES (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.familylastname#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherlastname#" null="#yesNoFormat(trim(form.fatherlastname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherfirstname#" null="#yesNoFormat(trim(form.fatherfirstname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fathermiddlename#" null="#yesNoFormat(trim(form.fathermiddlename) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#fatherbirth#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.fatherdob#" null="#yesNoFormat(trim(form.fatherdob) EQ '')#">,
                    <!----<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherssn#" null="#yesNoFormat(trim(form.fatherssn) EQ '')#">,---->
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherfullpart#" null="#yesNoFormat(trim(form.fatherfullpart) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.father_cell#" null="#yesNoFormat(trim(form.father_cell) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherfirstname#" null="#yesNoFormat(trim(form.motherfirstname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherlastname#" null="#yesNoFormat(trim(form.motherlastname) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mothermiddlename#" null="#yesNoFormat(trim(form.mothermiddlename) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#motherbirth#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#form.motherdob#" null="#yesNoFormat(trim(form.motherdob) EQ '')#">,
                    <!----<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherssn#" null="#yesNoFormat(trim(form.motherssn) EQ '')#">,---->
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherfullpart#" null="#yesNoFormat(trim(form.motherfullpart) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mother_cell#" null="#yesNoFormat(trim(form.mother_cell) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address2#" null="#yesNoFormat(trim(form.address2) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#" null="#yesNoFormat(trim(form.phone) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" null="#yesNoFormat(trim(form.email) EQ '')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.homeIsFunctBusiness#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.homeBusinessDesc#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">,
                    
                   <!----<cfqueryparam cfsqltype="cf_sql_integer" value="#form.regionid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,---->
                    #now()#,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fatherfullpart#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.motherfullpart#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_address#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_address2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_city#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_state#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_zip#">
                    )  
                </cfquery>
                <cfquery name="get_id" datasource="mysql">
                    SELECT MAX(hostid) AS hostid

                    FROM smg_hosts
                </cfquery>
            </cflock>
            <!--- the client variable should be phased out after host_fam_mem_form, etc. are modified to use url.hostid --->
			<cfset client.hostid = get_id.hostid>
            <cflocation url="index.cfm?page=familyMembers" addtoken="No">
		<!--- edit --->
	<!--- edit --->
		<cfelse>
        ---->
			<cfquery datasource="mysql">
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
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" null="#yesNoFormat(trim(form.email) EQ '')#">,
                mailing_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_address#">,
                mailing_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_address2#" null="#yesNoFormat(trim(form.mailing_address2) EQ '')#">,
                mailing_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_city#">,
                mailing_state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_state#">,
                mailing_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mailing_zip#">,
			    homeIsFunctBusiness = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.homeIsFunctBusiness#">,
                homeBusinessDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.homeBusinessDesc#">,
                
				motherfullpart = #form.motherfullpart#,
				fatherfullpart = #form.fatherfullpart#,
                lead = 0
				WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
			</cfquery>
            <cflocation url="index.cfm?page=familyMembers" addtoken="No">
            <!----
		</cfif>
		---->
		
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
	<cfset form.allow_fatherssn = 0>
	<cfset form.allow_motherssn = 0>
    
<!--- edit --->
<cfelseif not new>

	<cfquery name="get_record" datasource="mysql">
		SELECT *
		FROM smg_hosts
		WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
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
<!----
    <cfquery name="user_compliance" datasource="mysql">
        SELECT compliance
        FROM smg_users
        WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
    </cfquery>
	---->
	<cfset form.allow_fatherssn = 0>
	<cfset form.allow_motherssn = 0>
    <!----
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
	---->
</cfif>

<cfif isDefined("errorMsg")>
	<script language="JavaScript">
        alert('<cfoutput>#errorMsg#</cfoutput>');
    </script>
</cfif>
<!----
<!--- address lookup turned on. --->
<cfif application.address_lookup>
	<cfinclude template="includes/address_lookup_#application.address_lookup#.cfm">
<!--- address lookup turned off. --->
<cfelse>
	<!--- set to true so lookup is not required. --->
	<cfset form.lookup_success = 1>
    <Cfset application.address_lookup = 0>
</cfif>
---->
	<cfset form.lookup_success = 1>
    <Cfset application.address_lookup = 0>
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



<cfquery name="hostInfo" datasource="mysql">
SELECT  *
FROM smg_hosts shl
LEFT JOIN smg_states on smg_states.state = shl.state
where hostid = #client.hostid#
</cfquery>

<cfoutput>
          <h1 class="enter">#lcase(hostInfo.familylastname)# Family Application</h1>
          <p>Completing the host family application will take between 15 and 30 minutes.  You do not have to complete it all at once, feel free to come back and complete it.
          </p>
          <p>Use the menu on the left to navigate to any section of the application.</p>


<!----
onSubmit="return checkForm();"
---->
<body onload="document.my_form.familylastname.focus()">
<cfform method="post" action="index.cfm?page=startHostApp" name="my_form"  onsubmit="return validate(this)">
<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="allow_fatherssn" value="#form.allow_fatherssn#">
<cfinput type="hidden" name="allow_motherssn" value="#form.allow_motherssn#">
<!--- this gets set to 1 by the javascript lookup function on success. --->
<cfinput type="hidden" name="lookup_success" value="#form.lookup_success#">


<div align="center">
  <span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + One phone field is required</span>
</div>
  
  <h2>Home Address, Phone & Email</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
        <td class="label"><h3>Family Name<span class="redtext">*</span></h3> </td>
        <td colspan=3>
            <!--- automatically fill in last names on new form only. --->
            <cfif new>
                <cfset blurValue = 'javascript:lastname(this.form);'>
            <cfelse>
                <cfset blurValue = ''>
            </cfif>
            <input type="text" name="familylastname" value="#hostInfo.familylastname#" size="20" maxlength="150" onBlur="#blurValue#">
        </td>
    </tr>

<!--- address lookup - auto version. --->
<cfif application.address_lookup EQ 2>
    <tr bgcolor="##deeaf3">
        <td class="label">Lookup Address <span class="redtext">*</span></td>
        <td colspan=3>
            Enter at least the street address and zip code and click "Lookup".<br />
            Address, City, State, and Zip will be automatically filled in.<br />
            Address line 2 should be manually entered if needed.<br />
            <cftextarea name="lookup_address" rows="2" cols="30" value="#form.lookup_address#" /><br />
            <input type="button" value="Lookup" onClick="showLocation();" />
        </td>
    </tr>
    <tr>
        <td class="label"><h3>Address</h3></td>
        <td colspan=3><cfinput type="text" name="address" value="#hostInfo.address#" size="40" maxlength="150" readonly="readonly"></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><cfinput type="text" name="address2" value="#hostInfo.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label"><h3>City</h3></td>
        <td colspan=3><cfinput type="text" name="city" value="#hostInfo.city#" size="20" maxlength="150" readonly="readonly"></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>State</h3></td>
        <td><cfinput type="text" name="state" value="#hostInfo.state#" size="2" maxlength="2" readonly="readonly"></td>
        <td class="zip"><h3>Zip</h3></td>
        <td><cfinput type="text" name="zip" value="#hostInfo.zip#" size="5" maxlength="5" readonly="readonly"></td>
    </tr>
<cfelse>
    <tr bgcolor="##deeaf3">
        <td class="label">
        
        <h3>Address <span class="redtext">*</span></h3></td>
        <td colspan=2>
        	<cfinput type="text" name="address" value="#hostInfo.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address.">
            <font size="1">NO PO BOXES 
        </td>
        <td rowspan=2> <p><font size=-1><em>physical address where<Br /> 
          student will be living.<br />Mailing address can be<br />
           added below, if different.</em></font></p></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><cfinput type="text" name="address2" value="#hostInfo.address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label"><h3>City <span class="redtext">*</span></h3></td>
        <td colspan=3><cfinput type="text" name="city" value="#hostInfo.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>State <span class="redtext">*</span></h3></td>
        <td>
            <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="state" query="get_states" value="state" display="statename" selected="#hostInfo.state#" queryPosition="below">
				<option></option>
			</cfselect>
        </td>
        <td class="zip"><h3>Zip<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="zip" value="#hostInfo.zip#" size="5" maxlength="5" required="yes" validate="zipcode" message="Please enter a valid Zip."></td>
    </tr>
	<!--- address lookup - simple version. --->
    <cfif application.address_lookup EQ 1>
        <tr>
            <td class="label"><h3>Lookup Address<span class="redtext">*</span></h3> </td>
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

    <tr >
        <td ><h3>Phone <span class="redtext">+</span></h3></td>
        <td colspan=3><cfinput type="text" name="phone" value="#hostInfo.phone#" size="16" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Phone."></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td ><h3>Email</h3></td>
        <td colspan=3><cfinput type="text" name="email" value="#hostInfo.email#" size="30" maxlength="200" validate="email" message="Please enter a valid Email."></td>
    </tr>
  </table>
 <h2>Home Based Business</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr bgcolor="##deeaf3">
        <td class="label" colspan=3><h3>Is the residence the site of a functioning business?(e.g. daycare, farm)</h3> </td>
        <td>
            <label>
            <cfinput type="radio" name="homeIsFunctBusiness" value="1"
            checked="#hostInfo.homeIsFunctBusiness eq 1#" onclick="document.getElementById('describeBusiness').style.display='table-row';" 
            required="yes" message="Please answer: Is the residence the site of a functioning business?" />
            Yes
            </label>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <label>
            <cfinput type="radio" name="homeIsFunctBusiness" value="0"
           checked="#hostInfo.homeIsFunctBusiness eq 0#" onclick="document.getElementById('describeBusiness').style.display='none';" 
           required="yes" message="Please answer: Is the residence the site of a functioning business?" />
            No
            </label>
		 </td>
	</tr>
  
     <Tr>
	     <td align="left" colspan=4 id="describeBusiness" <cfif hostInfo.homeBusinessDesc is ''>  style="display: none;"</cfif>><Br /><strong>Please Describe</strong><br><textarea cols="50" rows="4" name="homeBusinessDesc" wrap="VIRTUAL"><Cfoutput>#hostInfo.homeBusinessDesc#</cfoutput></textarea></td>
	</tr>   
</table>
<br />
<!----
<a onclick="ShowHide(); return false;" href="##">+/- Need to add a mailing address that is different from the home address above?</a>
<div id="slidingDiv" display:"none">
---->
<h3>Mailing Address <font size=-1><input name="ShipSame" type="checkbox" class="formCheckbox" onclick="FillFields(this)" value="Same"<cfif IsDefined('FORM.ShipSame')> checked</cfif>>Same as Home</font></h3>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
   <tr bgcolor="##deeaf3">
        <td class="label"><h3>Address <span class="redtext">*</span></h3></td>
        <td colspan=3>
        	<cfinput type="text" name="mailing_address" value="#hostInfo.mailing_address#" size="40" maxlength="150" ></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td></td>
        <td colspan=3><cfinput type="text" name="mailing_address2" value="#hostInfo.mailing_address2#" size="40" maxlength="150"></td>
    </tr>
    <tr>			 
        <td class="label"><h3>City <span class="redtext">*</span></h3></td>
        <td colspan=3><cfinput type="text" name="mailing_city" value="#hostInfo.mailing_city#" size="20" maxlength="150"  validate="noblanks" message="Please enter the City."></td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>State <span class="redtext">*</span></h3></td>
        <td>
            <cfquery name="get_states" datasource="mysql">
                SELECT state, statename
                FROM smg_states
                ORDER BY id
            </cfquery>
			<cfselect NAME="mailing_state" query="get_states" value="state" display="statename" selected="#hostInfo.mailing_state#" queryPosition="below">
				<option></option>
			</cfselect>
        </td>
        <td class="zip"><h3>Zip<span class="redtext">*</span></h3> </td>
        <td><cfinput type="text" name="mailing_zip" value="#hostInfo.mailing_zip#" size="5" maxlength="5" validate="zipcode" message="Please enter a valid Zip."></td>
    </tr>
  </table>
  <!----
  </div>
  ---->
<br />
  <h2>Father's Information</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
    	<td class="label"><h3>Last Name</h3></td>
        <td><cfinput type="text" name="fatherlastname" value="#hostInfo.fatherlastname#" size="20" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td class="label"><h3>First Name</h3></td>
        <td><cfinput type="text" name="fatherfirstname" value="#hostInfo.fatherfirstname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label"><h3>Middle Name</h3></td>
        <td><cfinput type="text" name="fathermiddlename" value="#hostInfo.fathermiddlename#" size="20" maxlength="150"></td>
    </tr>
    <tr bgcolor="##deeaf3">
    	<td class="label"><h3>Date of Birth</h3></td>
        <td><cfinput type="text" name="fatherdob" value="#dateFormat(hostInfo.fatherdob, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Father's Date of Birth."> mm/dd/yyyy</td>
    </tr>

    <tr >
    	<td class="label"><h3>Occupation</h3></td>
        <td><cfinput type="text" name="fatherworktype" value="#hostInfo.fatherworktype#" size="50" maxlength="200"> 
        <cfinput name="fatherfullpart" type="radio" value="1" checked="#hostInfo.fatherfullpart is 1#"> Full Time  
        <cfinput name="fatherfullpart" type="radio" value="0" checked="#hostInfo.fatherfullpart is 0#"> Part Time </td>
    </tr>
    <tr bgcolor="##deeaf3">
        <td class="label"><h3>Cell Phone <span class="redtext">+</span></h3></td>
        <td colspan=3><cfinput type="text" name="father_cell" value="#hostInfo.father_cell#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Father's Cell Phone."></td>
    </tr>
        <cfif form.allow_fatherssn eq 1>
        <tr>
        	<td class="label"><h3>SSN</h3></td>
            <td><cfinput type="text" name="fatherssn" value="#form.fatherssn#" size="11" maxlength="11" mask="999-99-9999" validate="social_security_number" message="Please enter a valid Father's SSN."> <em>We use this durring the background check.</em></td>
        </tr>	
    </cfif>
</table>

<br />
  <h2>Mother's Information</h2>
  <table width=100% cellspacing=0 cellpadding=2 class="border">
    <tr>
    	<td class="label"><h3>Last Name</h3></td>
        <td><cfinput type="text" name="motherlastname" value="#hostInfo.motherlastname#" size="20" maxlength="150"></td>
    </tr>
    <tr  bgcolor="##deeaf3">
    	<td class="label"><h3>First Name</h3></td>
        <td><cfinput type="text" name="motherfirstname" value="#hostInfo.motherfirstname#" size="20" maxlength="150"></td>
    </tr>
    <tr>
    	<td class="label"><h3>Middle Name</h3></td>
        <td><cfinput type="text" name="mothermiddlename" value="#hostInfo.mothermiddlename#" size="20" maxlength="150"></td>
    </tr>			
    <tr  bgcolor="##deeaf3">
    	<td class="label"><h3>Date of Birth</h3></td>
        <td><cfinput type="text" name="motherdob" value="#dateFormat(hostInfo.motherdob, 'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Mother's Date of Birth."> mm/dd/yyyy</td>
    </tr>

    <tr>
    	<td class="label"><h3>Occupation</h3></td>
        <td><cfinput type="text" name="motherworktype" value="#hostInfo.motherworktype#" size="50" maxlength="200">  
        <cfinput name="motherfullpart" checked="#hostInfo.motherfullpart is 1#" type="radio" value="1"> Full Time  
        <cfinput name="motherfullpart" checked="#hostInfo.motherfullpart is 0#" type="radio" value="0"> Part Time </td>
    </tr>
    <tr   bgcolor="##deeaf3">
        <td class="label"><h3>Cell Phone <span class="redtext">+</span></h3></td>
        <td colspan=3><cfinput type="text" name="mother_cell" value="#hostInfo.mother_cell#" size="14" maxlength="14" mask="(999) 999-9999" validate="telephone" message="Please enter a valid Mother's Cell Phone."></td>
    </tr>
        <cfif form.allow_motherssn eq 1>
        <tr>
        	<td class="label"><h3>SSN</h3></td>
            <td><cfinput type="text" name="motherssn" value="#form.motherssn#" size="11" maxlength="11" mask="999-99-9999" validate="social_security_number" message="Please enter a valid Mother's SSN."> <em>We use this durring the background check.</em></td>
        </tr>		
    </cfif>
</table> 		

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
    <tr>
       
        <td align="right"><input name="Submit" type="image" src="../images/buttons/Next.png" border=0></td>
    </tr>
</table>
    
</cfform>
</cfoutput>
