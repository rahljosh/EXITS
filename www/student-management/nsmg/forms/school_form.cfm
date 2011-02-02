<!--- ------------------------------------------------------------------------- ----
	
	File:		school_form.cfm
	Author:		Marcus Melo
	Date:		Feb 2, 2011
	Desc:		Add/Edit School Information

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.schoolID" default="0">
	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.schoolID" default="0">
    <cfparam name="FORM.schoolName" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.principal" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.phone_ext" default="">
    <cfparam name="FORM.fax" default="">
    <cfparam name="FORM.url" default="">
	<!--- Error Handling --->
	<cfparam name="FORM.errorMsg" default="">
	<cfparam name="FORM.lookup_success" default="0">
	<cfparam name="FORM.lookup_address" default="">

    <cfscript>
		// Get School Information
		qGetSchoolInfo = APPLICATION.CFC.SCHOOL.getSchoolByID(schoolID=URL.schoolID);
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
		
		if ( qGetSchoolInfo.recordCount ) {
			// Edit
			// lookup_success may be set to 1 to not require lookup on edit.
			FORM.lookup_success = 0;
			FORM.lookup_address = '#qGetSchoolInfo.address##chr(13)##chr(10)##qGetSchoolInfo.city# #qGetSchoolInfo.state# #qGetSchoolInfo.zip#';
			
		} else {
			// Add	
			// lookup_success must be 0 to require lookup on add.
			FORM.lookup_success = 0;
			FORM.lookup_address = '';
		}
		
		if ( NOT APPLICATION.address_lookup ) {
			// address lookup turned off.
			// set to true so lookup is not required.
			FORM.lookup_success = 1;
		}
	</cfscript>
	
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
        
        <cfquery name="qCheckForDuplicates" datasource="#APPLICATION.dsn#">
            SELECT 
            	schoolid
            FROM 
            	smg_schools 
            WHERE 
            	schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.schoolname)#">
            AND 
            	city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.city)#">
            AND 
            	state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.state)#">
			<cfif VAL(FORM.schoolID)>
                AND
                    schoolID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolID#">
            </cfif>
        </cfquery>

        <!--- Data Validation --->
		<cfscript>
            // Check required Fields
			if ( qCheckForDuplicates.recordcount ) {
				FORM.errorMsg = FORM.errorMsg & "Sorry, school ID: #qCheckForDuplicates.schoolid# with this School Name, City and State has already been entered in the database. \n";
            }

			if ( FORM.lookup_success NEQ 1 ) {
				FORM.errorMsg = FORM.errorMsg & 'Please lookup the address. \n';
			}
            
			if ( NOT LEN(TRIM(FORM.schoolname)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter the School Name. \n";
            }

			if ( APPLICATION.address_lookup NEQ 2 AND NOT LEN(TRIM(FORM.address)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter the Address. \n";
            }

			if ( APPLICATION.address_lookup NEQ 2 AND NOT LEN(TRIM(FORM.city)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter the City. \n";
            }
			
			if ( APPLICATION.address_lookup NEQ 2 AND NOT LEN(TRIM(FORM.state)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please select the State. \n";
            }

			if ( APPLICATION.address_lookup NEQ 2 AND NOT isValid("zipcode", TRIM(FORM.zip)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter a valid Zip. \n";
            }

			if ( NOT LEN(TRIM(FORM.principal)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter the Contact. \n";
            }

			if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter a valid Contact Email. \n";
            }

			if ( NOT isValid("telephone", TRIM(FORM.phone)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter a valid Phone. \n";
            }

			if ( LEN(TRIM(FORM.fax)) AND NOT isValid("telephone", TRIM(FORM.fax)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter a valid Fax. \n";
            }

			if ( LEN(FORM.url) AND NOT isValid("url", TRIM(FORM.url)) ) {
				FORM.errorMsg = FORM.errorMsg & "Please enter a valid Web Site starting with http:// \n";
            }
		</cfscript>
        
        <!--- // Check if there are no errors --->
        <cfif NOT LEN(FORM.errorMsg)>
        
			<cfif VAL(FORM.schoolID)>
                
                <!--- Update --->
                <cfquery datasource="MySql">
                    UPDATE 
                    	smg_schools 
                    SET
                        schoolname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolname#">,
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#" null="#yesNoFormat(TRIM(FORM.address2) EQ '')#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        principal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.principal#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#" null="#yesNoFormat(TRIM(FORM.email) EQ '')#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        phone_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone_ext#" null="#yesNoFormat(TRIM(FORM.phone_ext) EQ '')#">,
                        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#" null="#yesNoFormat(TRIM(FORM.fax) EQ '')#">,
                        url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.url#" null="#yesNoFormat(TRIM(FORM.url) EQ '')#">
                    WHERE 
                    	schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolID#">
        		</cfquery>
                
			<cfelse>

				<!--- Insert School --->                  
                <cfquery result="newRecord" datasource="MySql">
                    INSERT INTO 
                    	smg_schools 
                    (	
                    	companyID,
                        schoolname, 
                        address, 
                        address2, 
                        city, 
                        state, 
                        zip, 
                        principal, 
                        email, 
                        phone, 
                        phone_ext, 
                        fax, 
                        url
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.schoolname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#" null="#yesNoFormat(TRIM(FORM.address2) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.principal#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#" null="#yesNoFormat(TRIM(FORM.email) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone_ext#" null="#yesNoFormat(TRIM(FORM.phone_ext) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#" null="#yesNoFormat(TRIM(FORM.fax) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.url#" null="#yesNoFormat(TRIM(FORM.url) EQ '')#">
                    )  
				</cfquery>
                
                <cfscript>
					// Set new host company ID
					FORM.schoolID = newRecord.GENERATED_KEY;
				</cfscript>
                				
            </cfif>                	        
    
            <!--- Redirect to School Information Page --->
            <cflocation url="index.cfm?curdoc=school_info&schoolID=#FORM.schoolID#" addtoken="No">
        
        </cfif>
        
    <cfelse>
    
 		<cfscript>
			// Set FORM Values
			FORM.schoolname = qGetSchoolInfo.schoolname;
			FORM.address = qGetSchoolInfo.address;
			FORM.address2 = qGetSchoolInfo.address2;
			FORM.city = qGetSchoolInfo.city;
			FORM.state = qGetSchoolInfo.state;
			FORM.zip = qGetSchoolInfo.zip;
			FORM.principal = qGetSchoolInfo.principal;
			FORM.email = qGetSchoolInfo.email;
			FORM.phone = qGetSchoolInfo.phone;
			FORM.phone_ext = qGetSchoolInfo.phone_ext;
			FORM.fax = qGetSchoolInfo.fax;
			FORM.url = qGetSchoolInfo.url;
		</cfscript>
    
    </cfif>
	
</cfsilent>

<cfoutput>

<script language="javascript">
	function checkForm() {
		<cfif APPLICATION.address_lookup NEQ 2>
			if (document.schoolForm.state.value.length == 0) {alert("Please select the State."); return false; }
		</cfif>
		if (document.schoolForm.lookup_success.value != 1) {alert("Please lookup the address."); return false; }
		return true;
	}
	
	// Fomat Phone/Fax Numbers
	jQuery(function($){
	   $("##phone").mask("(999) 999-9999");
	   $("##fax").mask("(999) 999-9999");
	});		
	
	// Error Message
	<cfif LEN(FORM.errorMsg)>
		alert('#FORM.errorMsg#');
	</cfif>
</script>


<!--- address lookup turned on. / Include Google API --->
<cfif APPLICATION.address_lookup>
	<cfinclude template="../includes/address_lookup_#APPLICATION.address_lookup#.cfm">
</cfif>


<!--- Table Header --->
<gui:tableHeader
	width="500px"
	imageName="school.gif"
	tableTitle="School Information"
/>

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING# " method="post" name="schoolForm" onSubmit="return checkForm();">
    <input type="hidden" name="submitted" value="1">
    <input type="hidden" name="schoolID" id="schoolID" value="#VAL(qGetSchoolInfo.schoolID)#">    
    <!--- this gets set to 1 by the javascript lookup function on success. --->
    <input type="hidden" name="lookup_success" value="#FORM.lookup_success#">

    <table width="500px" class="section" align="center" border="0" cellpadding="4" cellspacing="0">
		<tr>
            <td class="label">School Name: <span class="redtext">*</span></td>
            <td colspan="3"><cfinput type="text" name="schoolname" value="#FORM.schoolName#" size="40" maxlength="200" required="yes" validate="noblanks" message="Please enter the School Name."></td>
		</tr>

		<!--- address lookup - auto version. --->
		<cfif APPLICATION.address_lookup EQ 2>
            <tr>
                <td class="label">Lookup Address: <span class="redtext">*</span></td>
                <td colspan=3>
                    Enter at least the street address and zip code and click "Lookup".<br />
                    Address, City, State, and Zip will be automatically filled in.<br />
                    Address line 2 should be manually entered if needed.<br />
                    <textarea name="lookup_address" rows="2" cols="30" value="#FORM.lookup_address#" />
                    <br />
                    <input type="button" value="Lookup" onClick="showLocation();" />
                </td>
            </tr>
            <tr>
                <td class="label">Address:</td>
                <td colspan="3"><input type="text" name="address" value="#FORM.address#" size="40" maxlength="200" readonly="readonly"></td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3"><input type="text" name="address2" value="#FORM.address2#" size="40" maxlength="200"></td>
            </tr>
            <tr>
                <td class="label">City:</td>
                <td colspan="3"><input type="text" name="city" value="#FORM.city#" size="20" maxlength="200" readonly="readonly"></td>
            </tr> 
            <tr>
                <td class="label">State:</td>
                <td><input type="text" name="state" value="#FORM.state#" size="2" maxlength="2" readonly="readonly"></td>
                <td class="zip">Zip:</td>
                <td><input type="text" name="zip" value="#FORM.zip#" size="5" maxlength="5" readonly="readonly"></td>
            </tr>
		<cfelse>
            <tr>
                <td class="label">Address: <span class="redtext">*</span></td>
                <td colspan="3">
                	<cfinput type="text" name="address" value="#FORM.address#" size="40" maxlength="200" required="yes" validate="noblanks" message="Please enter the Address.">
                	<br /> <font size="1">NO PO BOXES</font>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td colspan="3"><cfinput type="text" name="address2" value="#FORM.address2#" size="40" maxlength="200"></td>
            </tr>
            <tr>
                <td class="label">City: <span class="redtext">*</span></td>
                <td colspan="3"><cfinput type="text" name="city" value="#FORM.city#" size="20" maxlength="200" required="yes" validate="noblanks" message="Please enter the City."></td>
            </tr> 
            <tr>
                <td class="label">State: <span class="redtext">*</span></td>
                <td>
                    <cfselect name="state" query="qGetStateList" value="state" display="statename" selected="#FORM.state#" queryPosition="below">
                   		<option value="0">Select a State</option>
                    </cfselect>
                </td>
                <td class="zip">Zip: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="zip" value="#FORM.zip#" size="5" maxlength="5" required="yes" validate="zipcode" message="Please enter a valid Zip."></td>
            </tr>
            
			<!--- address lookup - simple version. --->
            <cfif APPLICATION.address_lookup EQ 1>
                <tr>
                    <td class="label">Lookup Address: <span class="redtext">*</span></td>
                	<td colspan=3>
                    	<font size="1">
                            Enter Address, City, State, and Zip and click "Lookup".<br />
                            Verify the address displayed below, and make any corrections on the form if necessary.<br />
                            Address line 2 will not be included below.<br />
                            If you have trouble submitting an address, <a href="mailto:#APPLICATION.support_email#?subject=Address Lookup">send it to us</a>.<br />
                            <input type="button" value="Lookup" onClick="showLocation();" /><br />
                            <textarea name="lookup_address" readonly="readonly" rows="2" cols="30">Lookup address will be displayed here.</textarea>
                		</font>
                	</td>
                </tr>
            </cfif>
		</cfif>

        <tr>
            <td class="label">Contact: <span class="redtext">*</span></td>
            <td colspan="3"><cfinput type="text" name="principal" value="#FORM.principal#" size="30" maxlength="200" required="yes" validate="noblanks" message="Please enter the Contact."></td>
        </tr>
        <tr>
            <td class="label">Contact Email:</td>
            <td colspan="3"><cfinput type="text" name="email" value="#FORM.email#" size="30" maxlength="200" validate="email" message="Please enter a valid Contact Email."></td>
        </tr>
        
        <!--- Editing School --->
		<cfif qGetSchoolInfo.recordCount>
            <tr>
                <td colspan="4">
                	<font size="1">
                        Masks were recently added to the Phone and Fax fields with (999) 999-9999 format.<br>
                        Existing values with 999-999-9999 format might be displayed incorrectly and you will not be able to submit the FORM.<br>
                        Please verify the existing values displayed next to the form field and re-enter if necessary.
                	</font>
                </td>
            </tr>
        </cfif>
        
        <tr>
            <td class="label">Phone: <span class="redtext">*</span></td>
            <td><cfinput type="text" name="phone" id="phone" value="#FORM.phone#" size="14" maxlength="14" required="yes" validate="telephone" message="Please enter a valid Phone."></td>
            <td class="zip">Ext:</td>
            <td><cfinput type="text" name="phone_ext" value="#FORM.phone_ext#" size="5" maxlength="20"></td>
        </tr>
        <tr>
            <td class="label">Fax:</td>
            <td colspan="3"><cfinput type="text" name="fax" id="fax" value="#FORM.fax#" size="14" maxlength="14" validate="telephone" message="Please enter a valid Fax."></td>
        </tr>
        <tr>
            <td class="label">Web Site:</td>
            <td colspan="3"><cfinput type="text" name="url" value="#FORM.url#" size="40" maxlength="200" validate="url" message="Please enter a valid Web Site starting with http://"></td>
        </tr>
    	<tr>
        	<td class="label">
				<span class="redtext" style="font-size:10px">* Required fields</span>
			</td>
		</tr>
    </table>

    <table width="500px" class="section" align="center" border="0" cellpadding="4" cellspacing="0">
        <tr>
			<cfif VAL(qGetSchoolInfo.recordCount) AND ListFind("1,2,3,4", CLIENT.userType)>
                <td><a href="?curdoc=querys/delete_school&schoolid=#schoolID#" onClick="return confirm('You are about to delete this School. You will not be able to recover this information. Click OK to continue.')"><img src="pics/delete.gif" border="0"></a></td>
            </cfif>
            <td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
        </tr>
    </table>

</cfform>

</cfoutput>

<!--- Table Footer --->
<gui:tableFooter
	width="500px"
/>