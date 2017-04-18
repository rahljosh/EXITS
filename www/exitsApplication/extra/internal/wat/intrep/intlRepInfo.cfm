<!--- ------------------------------------------------------------------------- ----
	
	File:		intlRepInfo.cfm
	Author:		Marcus Melo
	Date:		June 1, 2010
	Desc:		Inlt Rep Information

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->


	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param variables --->
    <cfparam name="URL.uniqueID" default="">
	<!--- FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.uniqueID" default="">
    <cfparam name="FORM.active" default="1">
    <cfparam name="FORM.cancellationReason" default="">
	<cfparam name="FORM.businessName" default="">
	<cfparam name="FORM.address" default="">
	<cfparam name="FORM.address2" default="">
	<cfparam name="FORM.city" default="">
	<cfparam name="FORM.country" default="">
	<cfparam name="FORM.zip" default="">
	<cfparam name="FORM.phone" default="">
	<cfparam name="FORM.fax" default="">
	<cfparam name="FORM.firstname" default="">
	<cfparam name="FORM.middlename" default="">
	<cfparam name="FORM.lastname" default="">
	<cfparam name="FORM.dob" default="">
	<cfparam name="FORM.sex" default="">
	<cfparam name="FORM.email" default="">
	<cfparam name="FORM.email2" default="">
    <cfparam name="FORM.website" default="">
    <!--- WAT Information --->
	<cfparam name="FORM.wat_contact" default="">
	<cfparam name="FORM.wat_email" default="">
    <!--- Billing --->
    <cfparam name="FORM.useBilling" default="0">
	<cfparam name="FORM.billing_company" default="">
	<cfparam name="FORM.billing_contact" default="">
	<cfparam name="FORM.billing_email" default="">
	<cfparam name="FORM.billing_address" default="">
	<cfparam name="FORM.billing_address2" default="">
	<cfparam name="FORM.billing_city" default="">
	<cfparam name="FORM.billing_country" default="">
	<cfparam name="FORM.billing_zip" default="">
	<cfparam name="FORM.billing_phone" default="">
	<cfparam name="FORM.billing_fax" default="">
	<!--- Login Information --->
    <cfparam name="FORM.username" default="">
	<cfparam name="FORM.password" default="">
    <!--- Documents Control --->
	<cfparam name="FORM.watDocBusinessLicense" default="0">
    <cfparam name="FORM.watDocBusinessLicenseExpiration" default="">
	<cfparam name="FORM.watDocEnglishBusinessLicense" default="0">
    <cfparam name="FORM.watDocEnglishBusinessLicenseExpiration" default="">
    <cfparam name="FORM.watDocNotarizedFinancialStatementExpiration" default="">
    <cfparam name="FORM.watDocNotarizedFinancialStatementExpirationCB" default="FALSE">
    <cfparam name="FORM.watDocBankruptcyDisclosureExpiration" default="">
    <cfparam name="FORM.watDocBankruptcyDisclosureExpirationCB" default="FALSE">
	<cfparam name="FORM.watDocWrittenReference1" default="0">
    <cfparam name="FORM.watDocWrittenReference1Expiration" default="">
	<cfparam name="FORM.watDocWrittenReference2" default="0">
    <cfparam name="FORM.watDocWrittenReference2Expiration" default="">
	<cfparam name="FORM.watDocWrittenReference3" default="0">
	<cfparam name="FORM.watDocWrittenReference3Expiration" default="">
	<cfparam name="FORM.watDocPreviousExperience" default="0">
    <cfparam name="FORM.watDocPreviousExperienceExpiration" default="">
    <cfparam name="FORM.watDocOriginalCBC" default="0">
    <cfparam name="FORM.watDocEnglishCBC" default="0">
    <cfparam name="FORM.watDocOriginalAdvertisingMaterialExpiration" default="">
    <cfparam name="FORM.watDocOriginalAdvertisingMaterialExpirationCB" default="FALSE">
    <cfparam name="FORM.watDocEnglishAdvertisingMaterialExpiration" default="">
    <cfparam name="FORM.watDocEnglishAdvertisingMaterialExpirationCB" default="FALSE">
    <cfparam name="FORM.watDocOriginalCBCExpiration" default="">
    <cfparam name="FORM.watDocEnglishCBCExpiration" default="">
    <cfparam name="FORM.watDocLetterNotEngageThirdParties" default="0">

    <cfscript>
		// Get Intl. Rep.
		qGetIntlRepInfo = APPLICATION.CFC.USER.getUserByUniqueID(uniqueID=URL.uniqueID);	
				
		// Get Who Created Account
		qGetenteredBy = APPLICATION.CFC.USER.getUserByID(userID=VAL(qGetIntlRepInfo.whoCreated));	
		
		// List of Countries
		qGetCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountry();
		
		// Contact Country
		qGetContactCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry(countryID=VAL(qGetIntlRepInfo.country));
		
		// Billing Country
		qGetBillingCountry = APPLICATION.CFC.LOOKUPTABLES.getCountry(countryID=VAL(qGetIntlRepInfo.billing_country));
		
	</cfscript>
    <cfquery name="documentControl" datasource="MySQL">
        select vfd.documentType, vf.fileName, vf.fk_studentID, vf.expires, vf.isDeleted, vf.filepath, vf.vfid
        from extra_virtualfolderdocuments vfd 
        left outer JOIN extra_virtualfolder vf on  vf.fk_documentType = vfd.id
        where (vf.fk_studentID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #qGetIntlRepInfo.userid#"> or vf.fk_studentid IS NULL)
    </cfquery>
    <!--- FORM Submitted --->
    <cfif FORM.submitted>
    
        <cfquery name="qCheckbusinessName" datasource="MySql">
            SELECT 
                userID,
                uniqueID,
                businessName              
            FROM 
                smg_users
            WHERE
                businessName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessName#">
            AND
            	userType = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
			<cfif LEN(FORM.uniqueID)>
                AND
                    uniqueID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
            </cfif>
        </cfquery>

        <cfquery name="qCheckEmail" datasource="MySql">
            SELECT 
                userID,
                uniqueID,
                businessName              
            FROM 
                smg_users
            WHERE
                email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
            <cfif LEN(FORM.uniqueID)>
                AND
                    uniqueID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
            </cfif>
        </cfquery>

        <cfquery name="qCheckUsername" datasource="MySql">
            SELECT 
                userID,
                uniqueID,
                businessName              
            FROM 
                smg_users
            WHERE
                username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">
            <cfif LEN(FORM.uniqueID)>
                AND
                    uniqueID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
            </cfif>
        </cfquery>
    
        <!--- Data Validation --->
		<cfscript>
            // Check required Fields
            if ( LEN(FORM.businessName) AND qCheckbusinessName.recordCount ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('It seems this International Representative has been entered in the database as follow <a href="?curdoc=intrep/intlRepInfo&uniqueID=#qCheckbusinessName.uniqueID#">#qCheckbusinessName.businessName# (###qCheckbusinessName.userID#)</a>');
            }

            if ( LEN(FORM.email) AND qCheckEmail.recordCount ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('This email address is already registered for <a href="?curdoc=intrep/intlRepInfo&uniqueID=#qCheckEmail.uniqueID#">#qCheckEmail.businessName# (###qCheckEmail.userID#)</a>');
            }

            // Check required Fields
            if ( LEN(FORM.username) AND qCheckUsername.recordCount ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('This username is already registered for <a href="?curdoc=intrep/intlRepInfo&uniqueID=#qCheckUsername.uniqueID#">#qCheckUsername.businessName# (###qCheckUsername.userID#)</a>');
            }
			
            if ( NOT LEN(FORM.businessName) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Business name is required');
            }

			if ( NOT LEN(FORM.firstName) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('First Name is required');
            }

			if ( NOT LEN(FORM.lastName) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Last Name is required');
            }

			if ( NOT LEN(FORM.address) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Address is required');
            }

			if ( NOT LEN(FORM.city) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('City is required');
            }

			if ( NOT LEN(FORM.country) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Country is required');
            }

			if ( NOT LEN(FORM.email) OR NOT IsValid("email", FORM.email) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Email is required');
            }

			if ( NOT LEN(FORM.username) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Username is required');
            }

			if ( NOT LEN(FORM.password) OR LEN(FORM.password) LT 6 ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add('Password is required and must have at least 6 characters');
            }
			
			if ( NOT VAL(FORM.active) AND NOT LEN(FORM.cancellationReason) ) {
				SESSION.formErrors.Add('You must enter a cancellation reason');
			}
			
			if ( FORM.watDocNotarizedFinancialStatementExpirationCB IS TRUE AND NOT LEN(FORM.watDocNotarizedFinancialStatementExpiration) ) {
				SESSION.formErrors.Add('You must enter an expiration date for the Notarized Recent Financial Statement field');	
			}
			
			if ( FORM.watDocBankruptcyDisclosureExpirationCB IS TRUE AND NOT LEN(FORM.watDocBankruptcyDisclosureExpiration) ) {
				SESSION.formErrors.Add('You must enter an expiration date for the Disclosure of any previous bankruptcy and of any pending legal actions field');	
			}
			
			if ( FORM.watDocOriginalAdvertisingMaterialExpirationCB IS TRUE AND NOT LEN(FORM.watDocOriginalAdvertisingMaterialExpiration) ) {
				SESSION.formErrors.Add('You must enter an expiration date for the Original spoonsor-approved advertising materials field');	
			}
			
			if ( FORM.watDocEnglishAdvertisingMaterialExpirationCB IS TRUE AND NOT LEN(FORM.watDocEnglishAdvertisingMaterialExpiration) ) {
				SESSION.formErrors.Add('You must enter an expiration date for the English sponsor-approved advertising materials field');	
			}
		</cfscript>
        
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        
			<cfif LEN(FORM.uniqueID)>
                
                <!--- Update --->
                <cfquery datasource="MySql">
                    UPDATE 
                        smg_users 
                    SET 
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.active)#">,
                        <cfif VAL(FORM.active)>
                        	watCancellationReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                        <cfelse>
                        	watCancellationReason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancellationReason#">,
                      	</cfif>
                        businessName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessName#">,
                        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.country#">,
                        zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">,
                        middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">,
                        lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">,
                        dob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">,
						sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        email2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email2#">,
                        website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.website#">,
                        <!--- WAT Information --->
                        wat_contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_contact#">,
                        wat_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_email#">,
                        <!--- Billing --->
                        useBilling = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.useBilling)#">,
                        billing_company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_company#">,
                        billing_contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_contact#">,
                        billing_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_email#">,
                        billing_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address#">,
                        billing_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address2#">,
                        billing_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_city#">,
                        billing_country = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.billing_country#">,
                        billing_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_zip#">,
                        billing_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_phone#">,
                        billing_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_fax#">,
                        <!--- Login Information --->
                        username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">,
                        password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">
                        <!--- Documents Control 
                        watDocBusinessLicense = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocBusinessLicense#">,
                        watDocBusinessLicenseExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocBusinessLicenseExpiration#">,
                        watDocEnglishBusinessLicense = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocEnglishBusinessLicense#">,
                        watDocEnglishBusinessLicenseExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocEnglishBusinessLicenseExpiration#">,
                        watDocNotarizedFinancialStatementExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocNotarizedFinancialStatementExpiration#">,
                        watDocBankruptcyDisclosureExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocBankruptcyDisclosureExpiration#">,
                        watDocOriginalCBCExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocOriginalCBCExpiration#">,
                        watDocEnglishCBCExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocEnglishCBCExpiration#">,
                        watDocWrittenReference1 = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocWrittenReference1#">,
                        watDocWrittenReference1Expiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocWrittenReference1Expiration#">,
                        watDocWrittenReference2 = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocWrittenReference2#">,
                        watDocWrittenReference2Expiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocWrittenReference2Expiration#">,
                        watDocWrittenReference3 = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocWrittenReference3#">,
                        watDocWrittenReference3Expiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocWrittenReference3Expiration#">,
                        watDocPreviousExperience = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocPreviousExperience#">,
                        watDocPreviousExperienceExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocPreviousExperienceExpiration#">,
                        watDocOriginalCBC = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocOriginalCBC#">,
                        watDocEnglishCBC = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocEnglishCBC#">,
                        watDocOriginalAdvertisingMaterialExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocOriginalAdvertisingMaterialExpiration#">,
                        watDocEnglishAdvertisingMaterialExpiration = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocEnglishAdvertisingMaterialExpiration#">,
                        watDocLetterNotEngageThirdParties = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocLetterNotEngageThirdParties#">
						--->
                    WHERE
                        uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
                </cfquery>
             
                   <cfloop query="documentControl">
                	<cfif isDeleted eq 0>
					<cfif val(fk_studentID)>
						<cfif len(#Evaluate("FORM." & vfid)#)>
                        
                                <cfquery datasource="MySQL">
                                    update extra_virtualfolder
                                    set expires = <cfqueryparam cfsqltype="cf_sql_date" value="#Evaluate("FORM." & vfid)#">,
                                        approvedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                                    where vfid = <cfqueryparam cfsqltype="cf_sql_integer" value="#vfid#">
                                </cfquery>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
            
            <cfelse>
				
                <cfscript>
					// Set new host company ID
					FORM.uniqueID = CreateUUID();
				</cfscript>
                
             
                
				<!--- Insert Intl. Rep. --->                  
                <cfquery result="newRecord" datasource="MySql">
                    INSERT INTO 
                        smg_users 
                    (
                        uniqueID,
                        companyID,
                        userType,
                        active,
                        watCancellationReason,
                        businessName,
                        address,
                        address2,
                        city,
                        country,
                        zip,
                        phone,
                        fax,
                        firstname,
                        middlename,
                        lastname,
                        dob,
						sex,
                        email,
                        email2,
                        website,
                        <!--- WAT Information --->
                        wat_contact,
                        wat_email,
                        <!--- Billing --->
                        useBilling,
                        billing_company,
                        billing_contact,
                        billing_email,
                        billing_address,
                        billing_address2,
                        billing_city,
                        billing_country,
                        billing_zip,
                        billing_phone,
                        billing_fax,
                        <!--- Login Information --->
                        username,
                        password,
                        <!--- Documents Control
                        watDocBusinessLicense,
                        watDocBusinessLicenseExpiration,
                        watDocEnglishBusinessLicense,
                        watDocEnglishBusinessLicenseExpiration,
                        watDocNotarizedFinancialStatementExpiration,
                        watDocBankruptcyDisclosureExpiration,
                        watDocWrittenReference1,
                        watDocWrittenReference1Expiration,
                        watDocWrittenReference2,
                        watDocWrittenReference2Expiration,
                        watDocWrittenReference3,
                        watDocWrittenReference3Expiration,
                        watDocPreviousExperience,
                        watDocPreviousExperienceExpiration,
                        watDocOriginalCBC,
                        watDocEnglishCBC,
                        watDocOriginalCBCExpiration,
                        watDocEnglishCBCExpiration,
                        watDocOriginalAdvertisingMaterialExpiration,
                        watDocEnglishAdvertisingMaterialExpiration,
                        watDocLetterNotEngageThirdParties,
						 --->
                        whoCreated,
                        datecreated
                    )                
                    VALUES 
                    (
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="8">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.active)#">,
                        <cfif VAL(FORM.active)>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cancellationReason#">,
                      	</cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessName#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.country#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#NOT IsDate(FORM.dob)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.website#">,
                        <!--- WAT Information --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_contact#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.wat_email#">,
                        <!--- Billing --->
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.useBilling)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_company#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_contact#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_city#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.billing_country#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_phone#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_fax#">,
                        <!--- Login Information --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">,
                        <!--- Documents Control 
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocBusinessLicense#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocBusinessLicenseExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocEnglishBusinessLicense#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocEnglishBusinessLicenseExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocNotarizedFinancialStatementExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocBankruptcyDisclosureExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocWrittenReference1#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocWrittenReference1Expiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocWrittenReference2#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocWrittenReference2Expiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocWrittenReference3#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocWrittenReference3Expiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocPreviousExperience#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocPreviousExperienceExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocOriginalCBC#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocEnglishCBC#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocOriginalCBCExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocEnglishCBCExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocOriginalAdvertisingMaterialExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.watDocEnglishAdvertisingMaterialExpiration#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.watDocLetterNotEngageThirdParties#">,
						--->
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
                </cfquery>
                
            </cfif> <!--- uniqueID --->
            
            <!--- update companyID: w&t companyID is 8 --->
            <cfquery name="qCompID" datasource="MySQL">
            SELECT companyID
            FROM smg_users
            WHERE uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
            </cfquery>
            
            <!--- if companyID 8 is not included in companyID, include it --->
			<cfif LISTFIND(qCompID.companyID, 8) EQ 0>
            	<cfset qCompID.companyID = LISTAPPEND(qCompID.companyID,8)>
                <cfset qCompID.companyID = LISTSORT(qCompID.companyID, "numeric")>
				<cfquery name="qUpdateCompID" datasource="MySQL">
                UPDATE smg_users
                SET companyID = "#qCompID.companyID#"
                WHERE uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.uniqueID#">
                </cfquery>
            </cfif>

			<cfscript>
                // Set Page Message
                SESSION.pageMessages.Add("Form successfully submitted.");
                
                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?curdoc=intRep/intlRepInfo&uniqueID=#FORM.uniqueID#", "no");
            </cfscript>
    
    	</cfif> <!--- errors --->
        
    <cfelse>
    
 		<cfscript>
			if ( qGetIntlRepInfo.recordCount) {
			
				// Set FORM Values			
				FORM.userID = qGetIntlRepInfo.userID;
				FORM.uniqueID = qGetIntlRepInfo.uniqueID;
				// Escape Double Quotes
				FORM.businessName = APPLICATION.CFC.UDF.escapeQuotes(qGetIntlRepInfo.businessName);
				FORM.active = qGetIntlRepInfo.active;
				FORM.cancellationReason = qGetIntlRepInfo.watCancellationReason;
				FORM.address = qGetIntlRepInfo.address;
				FORM.address2 = qGetIntlRepInfo.address2;
				FORM.city = qGetIntlRepInfo.city;
				FORM.country = qGetIntlRepInfo.country;
				FORM.zip = qGetIntlRepInfo.zip;
				FORM.phone = qGetIntlRepInfo.phone;
				FORM.fax = qGetIntlRepInfo.fax;
				FORM.firstname = qGetIntlRepInfo.firstname;
				FORM.middlename = qGetIntlRepInfo.middlename;
				FORM.lastname = qGetIntlRepInfo.lastname;
				FORM.dob = qGetIntlRepInfo.dob;
				FORM.sex = qGetIntlRepInfo.sex;
				FORM.email = qGetIntlRepInfo.email;
				FORM.email2 = qGetIntlRepInfo.email2;
				FORM.website = qGetIntlRepInfo.website;
				// WAT Information
				FORM.wat_contact = qGetIntlRepInfo.wat_contact;
				FORM.wat_email = qGetIntlRepInfo.wat_email;
				// Billing Information
				FORM.useBilling = qGetIntlRepInfo.useBilling;
				FORM.billing_company = qGetIntlRepInfo.billing_company;
				FORM.billing_contact = qGetIntlRepInfo.billing_contact;
				FORM.billing_email = qGetIntlRepInfo.billing_email;
				FORM.billing_address = qGetIntlRepInfo.billing_address;
				FORM.billing_address2 = qGetIntlRepInfo.billing_address2;
				FORM.billing_city = qGetIntlRepInfo.billing_city;
				FORM.billing_country = qGetIntlRepInfo.billing_country;
				FORM.billing_zip = qGetIntlRepInfo.billing_zip;
				FORM.billing_phone = qGetIntlRepInfo.billing_phone;
				FORM.billing_fax = qGetIntlRepInfo.billing_fax;
				// Login Information
				FORM.username = qGetIntlRepInfo.username;
				FORM.password = qGetIntlRepInfo.password;
				// Documents Control
				FORM.watDocBusinessLicense = qGetIntlRepInfo.watDocBusinessLicense;
				FORM.watDocBusinessLicenseExpiration = qGetIntlRepInfo.watDocBusinessLicenseExpiration;
				FORM.watDocEnglishBusinessLicense = qGetIntlRepInfo.watDocEnglishBusinessLicense;
				FORM.watDocEnglishBusinessLicenseExpiration = qGetIntlRepInfo.watDocEnglishBusinessLicenseExpiration;
				FORM.watDocNotarizedFinancialStatementExpiration = qGetIntlRepInfo.watDocNotarizedFinancialStatementExpiration;
				FORM.watDocBankruptcyDisclosureExpiration = qGetIntlRepInfo.watDocBankruptcyDisclosureExpiration;
				FORM.watDocWrittenReference1 = qGetIntlRepInfo.watDocWrittenReference1;
				FORM.watDocWrittenReference1Expiration = qGetIntlRepInfo.watDocWrittenReference1Expiration;
				FORM.watDocWrittenReference2 = qGetIntlRepInfo.watDocWrittenReference2;
				FORM.watDocWrittenReference2Expiration = qGetIntlRepInfo.watDocWrittenReference2Expiration;
				FORM.watDocWrittenReference3 = qGetIntlRepInfo.watDocWrittenReference3;
				FORM.watDocWrittenReference3Expiration = qGetIntlRepInfo.watDocWrittenReference3Expiration;
				FORM.watDocPreviousExperience = qGetIntlRepInfo.watDocPreviousExperience;
				FORM.watDocPreviousExperienceExpiration = qGetIntlRepInfo.watDocPreviousExperienceExpiration;
				FORM.watDocOriginalCBC = qGetIntlRepInfo.watDocOriginalCBC;
				FORM.watDocEnglishCBC = qGetIntlRepInfo.watDocEnglishCBC;
				FORM.watDocOriginalCBCExpiration = qGetIntlRepInfo.watDocOriginalCBCExpiration;
				FORM.watDocEnglishCBCExpiration = qGetIntlRepInfo.watDocEnglishCBCExpiration;
				FORM.watDocOriginalAdvertisingMaterialExpiration = qGetIntlRepInfo.watDocOriginalAdvertisingMaterialExpiration;
				FORM.watDocEnglishAdvertisingMaterialExpiration = qGetIntlRepInfo.watDocEnglishAdvertisingMaterialExpiration;
				FORM.watDocLetterNotEngageThirdParties = qGetIntlRepInfo.watDocLetterNotEngageThirdParties;
				
			} else {
				
				// Login Information
				FORM.password = 'temp' & RandRange(100000, 999999);
			
			}
		</cfscript>
    
    </cfif>



<script language="JavaScript"> 
	$(document).ready(function() {
		// $(".formField").attr("disabled","disabled");							   
							   
		// Get Unique ID // If null, we are inserting a new Intl. Rep. // Set page to add/edit mode
		if ( $("#uniqueID").val() == '' ) {
			readOnlyEditPage();
		}
		
		<cfif SESSION.formErrors.length()>
			// There are errors / display edit page
			readOnlyEditPage();
		</cfif>
	});
	
	function removeDate(checkBox, date) {
		if (!checkBox.checked) {
			$("#" + date).val("");	
		}
	}
	
	// This function will remove the expiration date if the field is unchecked and store the value in a hidden field. It will then restore it if it is checked again.
	var changeEnglishBusinessLicenseExpirationDate = function () {
		if ( !$("#watDocEnglishBusinessLicense").is(":checked") ) {
				$("#hiddenEnglishBusinessLicenseExpiration").val($("#watDocEnglishBusinessLicenseExpiration").val());
				$("#watDocEnglishBusinessLicenseExpiration").val("");
		} else {
			// This ensures that the field is not replaced with an old value.
			if ($("#watDocEnglishBusinessLicenseExpiration").val() == "")
				$("#watDocEnglishBusinessLicenseExpiration").val($("#hiddenEnglishBusinessLicenseExpiration").val());
		}
	}
	
	var jsCopyContactInformation = function () {
		isChecked = $("#copyContactInformation").attr('checked');
		if ( isChecked ) {
			$("#billing_company").val( $("#businessName").val() );
			$("#billing_contact").val( $("#firstName").val() + ' ' + $("#lastName").val() );
			$("#billing_email").val( $("#email").val() );
			$("#billing_address").val( $("#address").val() );
			$("#billing_address2").val( $("#address2").val() );
			$("#billing_city").val( $("#city").val() );
			$("#billing_country").val( $("#country").val() );
			$("#billing_zip").val( $("#zip").val() );
			$("#billing_phone").val( $("#phone").val() );
			$("#billing_fax").val( $("#fax").val() );
		} else {
			$("#billing_company").val("");
			$("#billing_contact").val("");
			$("#billing_email").val("");
			$("#billing_address").val("");
			$("#billing_address2").val("");
			$("#billing_city").val("");
			$("#billing_country").val("");
			$("#billing_zip").val("");
			$("#billing_phone").val("");
			$("#billing_fax").val("");
		}
	}
	
	function isActive() {
		$("#cancellationTR").attr('style', 'visibility:hidden;');
	}
	
	function notActive() {
		$("#cancellationTR").removeAttr('style');
	}
	
</script>

<cfoutput>

    <Cfif CLIENT.userType EQ 28>
    <cfoutput>
    <table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##F4F4F4">
        <tr>
            <td bordercolor="##FFFFFF">
                You do not have access to view this page.<br /><br />
                If you feel this is incorrect, please contact <a href="mailto:#APPLICATION.EMAIL.support#">#APPLICATION.EMAIL.support#</a>
            </td>
        </tr>
    </table>
    </cfoutput>
    <cfabort>
</Cfif>

<!--- TABLE HOLDER --->
<table width="100%" align="center" cellpadding="0" cellspacing="0" bgcolor="##F4F4F4" style="border:1px solid ##CCC;">
    <tr>
        <td>

			<!--- TABLE HEADER --->
            <table class="tablePageTitle" cellpadding="0" cellspacing="0" border="0" align="center">
                <tr>
                    <td>International Representative Information</td>
                </tr>
            </table>

			<br />
            
            <table width="1000px" align="center" cellpadding="0" cellspacing="0">	
                <tr>
                    <td valign="top">

						<!--- Page Messages --->
                        <gui:displayPageMessages 
                            pageMessages="#SESSION.pageMessages.GetCollection()#"
                            messageType="section"
                            />
                        
                        <!--- Form Errors --->
                        <gui:displayFormErrors 
                            formErrors="#SESSION.formErrors.GetCollection()#"
                            messageType="section"
                            />
                            
					</td>
				</tr>
			</table>
                                                
            <form name="intlRepForm" id="intlRepForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="uniqueID" id="uniqueID" value="#FORM.uniqueID#">
            
            <!--- TOP SECTION --->
            <table width="1000px" border="1" align="center" cellpadding="4" cellspacing="4" bordercolor="##C7CFDC" bgcolor="##ffffff">	
                <tr>
                    <td valign="top">

                        <!--- INTL. REP. INFO - READ ONLY --->
                        <table width="100%" align="center" cellpadding="2" class="readOnly">
                            <tr>
                                <td align="center" colspan="2" class="title1">#FORM.businessName# (###FORM.userID#)</td>
                            </tr>
                            <tr>
                                <td width="40%" class="fieldTitle">Status:</td>
                                <td class="style1">
                                    <cfif VAL(FORM.active)>
                                    	Active
                                    <cfelse>
                                    	Inactive - #FORM.cancellationReason#
                                    </cfif>    
                                </td>
                            </tr>																																																																															
                            <tr>
                                <td class="fieldTitle">Date of Entry:</td>
                                <td class="style1">#DateFormat(qGetIntlRepInfo.dateCreated, "mm/dd/yyyy")#</td>
                            </tr>
                            <tr>
                                <td class="fieldTitle">Entered by:</td>
                                <td class="style1">#qGetenteredBy.firstname# #qGetenteredBy.lastname# (###qGetenteredBy.userID#)</td>
                            </tr>
                        </table>

                        <!--- INTL. REP. INFO - EDIT PAGE --->
                        <table width="100%" align="center" cellpadding="2" class="editPage">
                            <tr>
                                <td width="40%" align="right" class="style1"><strong>Company Name:</strong> </td>
                                <td><input type="text" name="businessName" id="businessName" value="#FORM.businessName#" class="style1 xLargeField" maxlength="250"></td>
                            </tr>
                            <tr>
                                <td class="fieldTitle">Status:</td>
                                <td class="style1">
                                    <input type="radio" name="active" id="active1" value="1" class="formField" disabled <cfif VAL(FORM.active)> checked </cfif> onClick="isActive();"> 
                                    <label for="active1">Active</label>
                                    
                                    <input type="radio" name="active" id="active0" value="0" class="formField" disabled <cfif NOT VAL(FORM.active)> checked </cfif> onClick="notActive();">
                                    <label for="active0">Inactive</label>
                                </td>
                            </tr>
                            <tr id="cancellationTR" <cfif VAL(FORM.active)>style="visibility:hidden;"</cfif>>
                            	<td class="fieldTitle">Reason For Cancellation:</td>
                                <td class="style1"><input type="text" name="cancellationReason" id="cancellationReason" value="#FORM.cancellationReason#" class="style1 xLargeField" maxlength="250" /></td>
                            </tr>																																																																														
                        </table>

                    </td>
                </tr>													
            </table>
            <!--- END OF TOP SECTION --->
            
            <br />                                    

			<!--- INFORMATION SECTION --->
            <table width="1000px" border="0" cellpadding="0" cellspacing="0" align="center">	
                <tr>
                    <!--- LEFT SECTION --->
                    <td width="49%" valign="top">
                        
                        <!--- COMPANY INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Company Information</td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="fieldTitle">Address:</td>
                                            <td width="70%" class="style1">
                                            	<span class="readOnly">#FORM.address#</span>
                                                <input type="text" name="address" id="address" value="#FORM.address#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>                                        
                                        <tr>
                                            <td class="fieldTitle">Address 2:</td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM.address2#</span>
                                                <input type="text" name="address2" id="address2" value="#FORM.address2#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">City</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.city#</span>
                                                <input type="text" name="city" id="city" value="#FORM.city#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="fieldTitle">Country:</td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetContactCountry.countryName#</span>
                                                <select name="country" id="country" class="style1 editPage xLargeField">
                                                    <option value="0">Country...</option>
                                                    <cfloop query="qGetCountryList">
                                                    	<option value="#qGetCountryList.countryID#" <cfif qGetCountryList.countryID EQ FORM.country>selected</cfif>>#qGetCountryList.countryname#</option>
                                                    </cfloop>
                                                </select>	
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Postal Code:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.zip#</span>
                                                <input type="text" name="zip" id="zip" value="#FORM.zip#" class="style1 editPage xLargeField" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Phone:</td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM.phone#</span>
                                                <input type="text" name="phone" id="phone" value="#FORM.phone#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Fax:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.fax#</span>
                                                <input type="text" name="fax" id="fax" value="#FORM.fax#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Website:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.website#</span>
                                                <input type="text" name="website" id="website" value="#FORM.website#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>		
                                    </table>
                                    
                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- CONTACT INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Contact Information</td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="fieldTitle">First Name:</td>
                                            <td width="70%" class="style1">
                                            	<span class="readOnly">#FORM.firstName#</span>
                                                <input type="text" name="firstName" id="firstName" value="#FORM.firstName#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Middle Name:</td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM.middleName#</span>
                                                <input type="text" name="middleName" id="middleName" value="#FORM.middleName#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Last Name:</td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM.lastName#</span>
                                                <input type="text" name="lastName" id="lastName" value="#FORM.lastName#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Date of Birth:</td>                                            
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(FORM.dob, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="dob" id="dob" value="#DateFormat(FORM.dob, 'mm/dd/yyyy')#" class="style1 editPage datePicker" maxlength="10"> mm/dd/yyyy
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Gender:</td>                                            
                                            <td class="style1">
                                            	<span class="readOnly">
                                                	<cfif LEN(FORM.sex)>
                                                    	#FORM.sex#
                                                    <cfelse>
                                                    	n/a
                                                    </cfif>
                                                </span>
                                                <input type="radio" name="sex" id="sexM" value="Male" class="style1 editPage" <cfif FORM.sex EQ 'Male'>checked</cfif> > <label for="sexM" class="editPage">Male</label>
                                                <input type="radio" name="sex" id="sexF" value="Female" class="style1 editPage" <cfif FORM.sex EQ 'Female'>checked</cfif> > <label for="sexF" class="editPage">Female</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Email:</td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM.email#</span>
                                                <input type="text" name="email" id="email" value="#FORM.email#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Alt. Email:</td>
                                            <td class="style1">
                                            	<span class="readOnly">#FORM.email2#</span>
                                                <input type="text" name="email2" id="email2" value="#FORM.email2#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>
                            </tr>
                        </table> 

                        <br />

                        <!--- DOCUMENTS CONTROL --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Documents Control</td>
                                            
                                        </tr>
                                        
                                       <cfloop query="documentControl">
                                       <cfif isDeleted neq 1>
                                       <tr>
                                       		 <td class="style1" colspan=2>
                                               
													<cfif fileName is not '' and isDeleted eq 0>
                                                   <strong> <A href="../#filePath#/#fileName#" target="_new">#documentType#</A></strong>
                                                    <cfelse>
                                                    #documentType#
                                                    </cfif>
                                                    <br />
                                             
                                                &nbsp;&nbsp;Expiration Date: 
													<Cfif fileName is not '' >
                                                     <span class="readOnly">
                                                        <cfif isDate(expires)>
                                                          #DateFormat(expires, 'mm/dd/yyyy')#
                                                        <cfelse>
                                                         <font color=##ccc>Waiting for Review</font>
                                                        </cfif> 
                                                        
                                                    </span>
                                                     <input 
                                                        type="text" 
                                                        name="#vfid#" 
                                                        id="#vfid#" 
                                                        value="#DateFormat(expires, 'mm/dd/yyyy')#" 
                                                        class="datePicker style1 editPage" />

                                                    <cfelse>
                                                    	Missing Document
                                                    </Cfif>
                                               
                                                
                                             
                                            </td>
                                       </tr>
                                        </cfif>
                                       </cfloop>
                                       
                                       <!----
                                        <tr>
                                        	<td class="fieldTitle">
                                            	<input 
                                                	type="checkbox" 
                                                    name="watDocEnglishAdvertisingMaterialExpirationCB" 
                                                    id="watDocEnglishAdvertisingMaterialExpirationCB" 
                                                    value="1" 
                                                    class="formField" 
                                                    onChange="removeDate(this,'watDocEnglishAdvertisingMaterialExpiration');" 
                                                    disabled 
													<cfif isDate(FORM.watDocEnglishAdvertisingMaterialExpiration)>
														<cfif DateCompare(FORM.watDocEnglishAdvertisingMaterialExpiration, NOW(), "d") NEQ -1> checked </cfif>
                                                  	</cfif> >
                                            </td>
                                            <td class="style1">
                                                <label for="watDocEnglishAdvertisingMaterialExpiration">English sponsor-approved advertising materials </label><br />
                                                &nbsp;&nbsp;Expiration Date: 
                                                <span class="readOnly"
                                                	<cfif isDate(FORM.watDocEnglishAdvertisingMaterialExpiration)>
														<cfif DateCompare(FORM.watDocEnglishAdvertisingMaterialExpiration, NOW(), "d") EQ -1>
                                                        	style="color:red;"
														</cfif>
                                                  	</cfif> >
                                                    #DateFormat(watDocEnglishAdvertisingMaterialExpiration,"mm/dd/yyyy")#
                                                </span>
                                                <input 
                                                	type="text" 
                                                    name="watDocEnglishAdvertisingMaterialExpiration" 
                                                    id="watDocEnglishAdvertisingMaterialExpiration" 
                                                    value="#DateFormat(FORM.watDocOriginalAdvertisingMaterialExpiration, 'mm/dd/yyyy')#" 
                                                    class="datePicker style1 editPage" />
                                            </td>
                                        </tr>
										---->
                                        <tr>
                                        	<td colspan="2" style="font-size:9px;"><i>These documents will expire at the end of the recruitment year. They must be renewed and maintained annually (IFR 2012).</i></td>
                                        </tr>	
                                        <tr>
                                        	<td colspan="2"><a href="?curdoc=virtualfolder/view&uniqueID=#URL.uniqueID#">Manage Documents</a></td>
                                    </table>
                                    
                                </td>
                            </tr>
                        </table> 

                        <br />

                	</td>        
					<!--- END OF LEFT SECTION --->
				
					<!--- DIVIDER --->
                    <td width="2%" valign="top">&nbsp;</td>
                	
                    <!--- RIGHT SECTION --->	    
                    <td width="49%" valign="top">

                        <!--- BILLING INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Billing Information</td>
                                        </tr>
                                        <tr class="editPage">
                                        	<td width="30%" class="fieldTitle">
                                            	<input type="checkbox" name="copyContactInformation" id="copyContactInformation" onClick="jsCopyContactInformation()" class="style1">
                                            </td>
                                            <td width="70%" class="style1">
                                                <label for="copyContactInformation">Same as Contact Information</label> 
                                            </td>
                                        </tr>					
                                        <tr>
                                        	<td class="fieldTitle">
                                            	<input type="checkbox" name="useBilling" id="useBilling" value="1" class="formField" disabled <cfif VAL(FORM.useBilling)> checked </cfif> >
                                            </td>
                                            <td class="style1">
                                                <label for="useBilling">Use billing address on invoice</label>
                                            </td>
                                        </tr>	
                                        <tr>
                                            <td class="fieldTitle">Company Name:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_company#</span>
                                                <input type="text" name="billing_company" id="billing_company" value="#FORM.billing_company#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Contact:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_contact#</span>
                                                <input type="text" name="billing_contact" id="billing_contact" value="#FORM.billing_contact#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Email:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_email#</span>
                                                <input type="text" name="billing_email" id="billing_email" value="#FORM.billing_email#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Address:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_address#</span>
                                                <input type="text" name="billing_address" id="billing_address" value="#FORM.billing_address#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Address 2:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_address2#</span>
                                                <input type="text" name="billing_address2" id="billing_address2" value="#FORM.billing_address2#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">City:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_city#</span>
                                                <input type="text" name="billing_city" id="billing_city" value="#FORM.billing_city#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Country:</td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetBillingCountry.countryName#</span>
                                                <select name="billing_country" id="billing_country" class="style1 editPage xLargeField">
                                                    <option value="0">Country...</option>
                                                    <cfloop query="qGetCountryList">
                                                    	<option value="#qGetCountryList.countryID#" <cfif qGetCountryList.countryID EQ FORM.billing_country>selected</cfif>>#qGetCountryList.countryname#</option>
                                                    </cfloop>
                                                </select>	
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Postal Code:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_zip#</span>
                                                <input type="text" name="billing_zip" id="billing_zip" value="#FORM.billing_zip#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Phone:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_phone#</span>
                                                <input type="text" name="billing_phone" id="billing_phone" value="#FORM.billing_phone#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Fax:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.billing_fax#</span>
                                                <input type="text" name="billing_fax" id="billing_fax" value="#FORM.billing_fax#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
						</table>

                        <br />

                        <!--- WAT INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: WAT Information</td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="fieldTitle">Contact:</td>
                                            <td width="70%" class="style1">
                                                <span class="readOnly">#FORM.wat_contact#</span>
                                                <input type="text" name="wat_contact" id="wat_contact" value="#FORM.wat_contact#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fieldTitle">Email:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.wat_email#</span>
                                                <input type="text" name="wat_email" id="wat_email" value="#FORM.wat_email#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- LOGIN INFORMATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td>

                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Login Information</td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="fieldTitle">Username:</td>
                                            <td width="70%" class="style1">
                                                <span class="readOnly">#FORM.username#</span>
                                                <input type="text" name="username" id="username" value="#FORM.username#" class="style1 editPage xLargeField" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td>&nbsp;</td>
                                            <td><font size="-2">* Defaults to email address, change if desire.</font></td>
                                        </tr>	
                                        <tr>
                                            <td class="fieldTitle">Password:</td>
                                            <td class="style1">
                                                <span class="readOnly">#FORM.password#</span>
                                                <input type="text" name="password" id="password" value="#FORM.password#" class="style1 editPage xLargeField" maxlength="50">
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />
                                                
    				</td>
				</tr>
			</table>                                    
            <!--- END OF INFORMATION SECTION ---> 
            
            <br/>

			<!---- EDIT/UPDATE BUTTONS ---->
            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                <table width="1000px" border="0" cellpadding="0" cellspacing="0" align="center">	
                    <tr>
                        <td align="center">
                            
                            <!---- EDIT BUTTON ---->
                            <div class="readOnly">                            
                                <img src="../pics/edit.gif" onClick="readOnlyEditPage();">
                            </div>
                            
                            <!---- UPDATE BUTTON ----> 
                            <div class="editPage">                            
                                
                                <cfif VAL(qGetIntlRepInfo.userID)>
	                                <input name="Submit" type="image" src="../pics/update.gif" alt="Update Host Company" border="0">
								<cfelse>
	                                <input name="Submit" type="image" src="../pics/save.gif" alt="Save Host Company" border="0">
                                </cfif>                                    
                            </div>
                            
                        </td>
                    </tr>
                </table>
                <br />
            </cfif>
			
            </form>
            
		</td>		
	</tr>
</table>
<!--- END OF TABLE HOLDER --->

</cfoutput>
