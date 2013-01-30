<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam_FORM.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Host Family Information
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="">
    
    <!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.udf" jsclassname="UDFComponent">

	<!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.hostID" default="0">    
    <cfparam name="FORM.familyLastName" default="">
    <cfparam name="FORM.fatherLastName" default="">
    <cfparam name="FORM.fatherFirstName" default="">
    <cfparam name="FORM.fatherMiddleName" default="">
    <cfparam name="FORM.fatherBirth" default="0">
    <cfparam name="FORM.fatherDOB" default="">
    <cfparam name="FORM.fatherSSN" default="">
    <cfparam name="FORM.fatherWorkType" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherLastName" default="">
    <cfparam name="FORM.motherMiddleName" default="">
    <cfparam name="FORM.motherBirth" default="0">
    <cfparam name="FORM.motherDOB" default="">
    <cfparam name="FORM.motherSSN" default="">
    <cfparam name="FORM.motherWorkType" default="">
    <cfparam name="FORM.mother_cell" default="">
    <cfparam name="FORM.address" default="">
    <cfparam name="FORM.address2" default="">
    <cfparam name="FORM.city" default="">
    <cfparam name="FORM.state" default="">
    <cfparam name="FORM.zip" default="">
    <cfparam name="FORM.zipLookup" default="">
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.companyID" default="">
    <cfparam name="FORM.regionid" default="">
    <cfparam name="FORM.arearepid" default="">
    <cfparam name="FORM.submit_Start" default="">
    <cfparam name="currentHost" default="0">

	<cfscript>
		// Set Regions or users or user type that can start host app
		allowedUsers = '1,12313,8747,17972,17791,8731,12431,17438,17767,15045,10133,6617,16552,16718,10631,9974,510';	
		
    	if ( VAL (URL.hostID) ) {
			FORM.hostID = URL.hostID;	
		}
		
		//Random Password for account, if needed
		strPassword = APPLICATION.CFC.UDF.randomPassword(length=8);
		
		// Get Host Family Info
		qGetHostFamilyInfo = APPLICATION.CFC.HOST.getHosts(hostID=FORM.hostID);
		
		// Get State List
		qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();

		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
		
		// Get Current User Information
		qGetUserComplianceInfo = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
		
		if ( NOT VAL(APPLICATION.address_lookup) ) {
			// set to true so lookup is not required
			FORM.lookup_success = 1;
		}

		// New Record
		if ( NOT VAL(qGetHostFamilyInfo.recordCount) ) {

			// lookup_success must be 0 to require lookup on add
			FORM.lookup_success = 1;
			// FORM.lookup_success = 0;
			FORM.lookup_address = '';
		
		// Edit Record
		} else {
			
			// lookup_success may be set to 1 to not require lookup on edit. 
			FORM.lookup_success = 1;
			FORM.lookup_address = '#qGetHostFamilyInfo.address##chr(13)##chr(10)##qGetHostFamilyInfo.city# #qGetHostFamilyInfo.state# #qGetHostFamilyInfo.zip#';
			
		}

		// Set Display SSN
		vDisplayFatherSSN = 0;
		vDisplayMotherSSN = 0;
		
		// These will set if SSN needs to be updated
		vUpdateFatherSSN = 0;
		vUpdateMotherSSN = 0;

		// allow SSN Field - If null or user has access.
		// Father
		if ( NOT LEN(qGetHostFamilyInfo.fatherSSN) OR qGetUserComplianceInfo.compliance EQ 1 ) {
			vDisplayFatherSSN = 1;
		}
		// Mother
		if ( NOT LEN(qGetHostFamilyInfo.motherSSN) OR qGetUserComplianceInfo.compliance EQ 1 ) {
			vDisplayMotherSSN = 1;
		}
	</cfscript>
    
	<cfif FORM.submit_start is ''>

		<cfscript>
			FORM.familyLastName = qGetHostFamilyInfo.familyLastName;
			FORM.fatherLastName = qGetHostFamilyInfo.fatherLastName;
			FORM.fatherFirstName = qGetHostFamilyInfo.fatherFirstName;
			FORM.fatherMiddleName = qGetHostFamilyInfo.fatherMiddleName;
			FORM.fatherDOB = qGetHostFamilyInfo.fatherDOB;
			FORM.fatherSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyInfo.fatherSSN, displayType='hostFamily');
			FORM.fatherWorkType = qGetHostFamilyInfo.fatherWorkType;
			FORM.father_cell = qGetHostFamilyInfo.father_cell;
			FORM.motherFirstName = qGetHostFamilyInfo.motherFirstName;
			FORM.motherLastName = qGetHostFamilyInfo.motherLastName;
			FORM.motherMiddleName = qGetHostFamilyInfo.motherMiddleName;
			FORM.motherDOB = qGetHostFamilyInfo.motherDOB;
			FORM.motherSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyInfo.motherSSN, displayType='hostFamily');
			FORM.motherWorkType = qGetHostFamilyInfo.motherWorkType;
			FORM.mother_cell = qGetHostFamilyInfo.mother_cell;
			FORM.address = qGetHostFamilyInfo.address;
			FORM.address2 = qGetHostFamilyInfo.address2;
			FORM.city = qGetHostFamilyInfo.city;
			FORM.state = qGetHostFamilyInfo.state;
			FORM.zip = qGetHostFamilyInfo.zip;
			FORM.phone = qGetHostFamilyInfo.phone;
			FORM.email = qGetHostFamilyInfo.email;
			FORM.companyID = qGetHostFamilyInfo.companyID;
			FORM.regionid = qGetHostFamilyInfo.regionid;
			FORM.arearepid = qGetHostFamilyInfo.arearepid;
			
			// the default values in the database for these used to be "na", so remove any.
			if ( FORM.father_cell EQ 'na' ) {
				FORM.father_cell = '';
			}
			
			if ( FORM.mother_cell EQ 'na') {
				FORM.mother_cell = '';
			}
        </cfscript>

	</cfif>

	<!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
    
		<cfscript>
			// Data Validation - Check required Fields
			if ( FORM.lookup_success NEQ 1 ) {
				SESSION.formErrors.Add("Please lookup the address.");
			} 
			
			if ( NOT LEN(FORM.familyLastName) ) {
				SESSION.formErrors.Add("Please enter the Family Name.");
			}
			
			if ( APPLICATION.address_lookup NEQ 2 AND NOT LEN(FORM.address) ) {
				SESSION.formErrors.Add("Please enter an Address.");
			}
			
			if ( APPLICATION.address_lookup NEQ 2 AND NOT LEN(FORM.city) ) {
				SESSION.formErrors.Add("Please enter a City.");
			}
			
			if ( APPLICATION.address_lookup NEQ 2 AND FORM.state EQ 0 ) {
				SESSION.formErrors.Add("Please select a State.");
			}
			
			if ( APPLICATION.address_lookup NEQ 2 AND NOT isValid("zipcode", Trim(FORM.zip)) ) {
				SESSION.formErrors.Add("Please enter a valid Zip.");     
			}
			
			if ( NOT LEN(FORM.phone) AND NOT LEN(FORM.father_cell) AND NOT LEN(FORM.mother_cell) ) {
				SESSION.formErrors.Add("Please enter one of the Phone fields.");
			}    
			
			if ( LEN(FORM.phone) AND NOT isValid("telephone", Trim(FORM.phone)) ) {
				SESSION.formErrors.Add("Please enter a valid Phone.");
			}    
			
			if ( LEN(FORM.email) AND NOT isValid("email", Trim(FORM.email)) ) {
				SESSION.formErrors.Add("Please enter a valid Email.");
			}    
			
			if ( NOT LEN(FORM.fatherFirstName) AND NOT LEN(FORM.motherFirstName) OR NOT LEN(FORM.fatherLastName) AND NOT LEN(FORM.motherLastName) ) {
				SESSION.formErrors.Add("Please enter at least one of the parents information.");
			}
			
			if ( LEN(FORM.fatherDOB) AND NOT IsDate(FORM.fatherDOB) ) {
				FORM.fatherDOB = '';
				SESSION.formErrors.Add("Please enter a valid Father's Date of Birth.");				
			}    
			
			if ( LEN(FORM.fatherSSN) AND Left(FORM.fatherSSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.fatherSSN)) ) {
				SESSION.formErrors.Add("Please enter a valid Father's SSN.");
			}    
			
			if ( LEN(FORM.father_cell) AND NOT isValid("telephone", Trim(FORM.father_cell)) ) {
				SESSION.formErrors.Add("Please enter a valid Father's Cell Phone.");
			}    
			
			if ( LEN(FORM.motherDOB) AND NOT IsDate(FORM.motherDOB) ) {
				FORM.motherDOB = '';
				SESSION.formErrors.Add("Please enter a valid Mother's Date of Birth.");				
			}
			
			if ( LEN(FORM.motherSSN) AND Left(FORM.motherSSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.motherSSN)) ) {
				SESSION.formErrors.Add("Please enter a valid Mother's SSN.");
			}
			
			if ( LEN(FORM.mother_cell) AND NOT isValid("telephone", Trim(FORM.mother_cell)) ) {
				SESSION.formErrors.Add("Please enter a valid Mother's Cell Phone.");
			}
			
			if ( NOT VAL(qGetHostFamilyInfo.recordCount) AND NOT VAL(FORM.regionid) ) {
				SESSION.formErrors.Add("Please select a Region.");
			}
			
			// Check for email address. 
			if ( FORM.submit_Start EQ 'eHost' AND NOT LEN(TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("Please enter an email address.");
			}
        </cfscript>

		<cfif FORM.submit_start is 'ehost' or FORM.submit_start is 'submit'>  

			<cfif isValid("email", FORM.email)>
            
                <cfquery name="qCheckEmail" datasource="#APPLICATION.DSN#">
                    SELECT 
                        hostID, 
                        familylastname,
                        password
                    FROM 
                        smg_hosts
                    WHERE
					<cfif VAL(FORM.hostID)>
                        hostID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.hostID#">
                    <cfelse>
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
                    </cfif>
                </cfquery>
                
				<cfif qCheckEmail.recordcount eq 1>
					<cfset currentHost = qCheckEmail.hostID>
                    
					<cfif qCheckEmail.password is not ''>
						<Cfset strPassword = qCheckEmail.password>
					</cfif>
                    
                <Cfelse>
                
					<cfset qCheckEmail.recordcount = 0>
                </cfif>

				<cfscript>
					// Data Validation - Check required Fields
					if ( NOT LEN(FORM.email) and (submit_start EQ 'eHost') ) {
						SESSION.formErrors.Add("An email is required for the eHost option.");
					}
					
					if ( LEN(FORM.email) AND NOT isValid("email", Trim(FORM.email)) ) {
						SESSION.formErrors.Add("Please enter a valid Email.");
					} 
                </cfscript>
                
			</cfif> <!--- <cfif FORM.email is not ''> --->

			<!--- // Check if there are no errors --->
            <cfif NOT SESSION.formErrors.length()>

				<cfscript>
                    // Father SSN - Will update if it's blank or there is a new number
                    if ( VAL(vDisplayFatherSSN) AND isValid("social_security_number", Trim(FORM.fatherSSN)) ) {
                        // Encrypt Social
                        FORM.fatherSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.fatherSSN);
                        // Update
                        vUpdateFatherSSN = 1;
                    } else if ( NOT LEN(FORM.fatherSSN) ) {
                        // Update - Erase SSN
                        // vUpdateFatherSSN = 0;
                    }
                    
                    // Mother SSN - Will update if it's blank or there is a new number
                    if ( VAL(vDisplayMotherSSN) AND isValid("social_security_number", Trim(FORM.motherSSN)) ) {
                        // Encrypt Social
                        FORM.motherSSN = APPLICATION.CFC.UDF.encryptVariable(FORM.motherSSN);
                        // Update
                        vUpdateMotherSSN = 1;
                    } else if ( NOT LEN(FORM.motherSSN) ) {
                        // Update - Erase SSN
                        // vUpdateMotherSSN = 0;
                    }
                    
                    // set the birth year field from the birth date field
                    if ( IsDate(FORM.fatherDOB) ) {
                        FORM.fatherBirth = Year(FORM.fatherDOB);
                    }
                    
                    if ( IsDate(FORM.motherDOB) ) {
                        FORM.motherBirth = Year(FORM.motherDOB);
                    }				
                </cfscript>

				<!--- Update --->
				<cfif VAL(currentHost) OR val(FORM.hostID)>

                    <cfquery datasource="#APPLICATION.DSN#">
                        UPDATE 
                            smg_hosts 
                        SET
                            familyLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.familyLastName)#">,
                            fatherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherLastName)#">,
                            fatherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherFirstName)#">,
                            fatherMiddleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherMiddleName)#">,
                            fatherBirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.fatherBirth)#">,
                            fatherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherDOB#" null="#NOT IsDate(FORM.fatherDOB)#">,
                            <!--- Father SSN --->
                            <cfif VAL(vUpdateFatherSSN)>
                            fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherSSN#">,
                            </cfif>
                            fatherWorkType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherWorkType#">,
                            father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                            motherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherFirstName)#">,
                            motherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherLastName)#">,
                            motherMiddleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherMiddleName)#">,
                            motherBirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.motherBirth)#">,
                            motherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherDOB#" null="#NOT IsDate(FORM.motherDOB)#">,
                            <!--- Mother SSN ---->
                            <cfif VAL(vUpdateMotherSSN)>
                            motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherSSN#">,
                            </cfif>
                            motherWorkType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherWorkType#">,
                            mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#">,
                            address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                            address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                            city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                            state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                            zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                            phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                            <!----
                            <Cfif isDefined('FORM.regionid')>
                            regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                            </Cfif>
                            ---->
                            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                            <cfif FORM.submit_Start neq 'update'>
                            HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                            arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
                            </cfif>
                            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        WHERE 
                            hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
                    </cfquery>			
				
                <!--- Insert --->
				<cfelse>

					<!--- Insert Host Family --->                  
                    <cfquery result="newRecord" datasource="#APPLICATION.DSN#">
                        INSERT INTO 
                            smg_hosts 
                        (
                            familyLastName, 
                            fatherLastName, 
                            fatherFirstName, 
                            fatherMiddleName, 
                            fatherBirth, 
                            fatherDOB, 
                            <!--- Father SSN --->
                            <cfif VAL(vUpdateFatherSSN)>
                            fatherSSN, 
                            </cfif>
                            fatherWorkType, 
                            father_cell,
                            motherFirstName, 
                            motherLastName, 
                            motherMiddleName, 
                            motherBirth, 
                            motherDOB, 
                            <!--- Mother SSN --->
                            <cfif VAL(vUpdateMotherSSN)>
                            motherSSN,
                            </cfif>                     
                            motherWorkType, 
                            mother_cell,
                            address, 
                            address2, 
                            city, 
                            state, 
                            zip, 
                            phone, 
                            email, 
                            password,
                            companyID, 
                            regionid, 
                            <cfif FORM.submit_Start is 'eHost'>
                            HostAppStatus,
                            </cfif>
                            applicationStarted,
                            arearepid
                        )
                        VALUES 
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.familyLastName)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherLastName)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherFirstName)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherMiddleName)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.fatherBirth)#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherDOB#" null="#NOT IsDate(FORM.fatherDOB)#">,
                            <!--- Father SSN --->
                            <cfif VAL(vUpdateFatherSSN)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherSSN#">,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherWorkType#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherFirstName)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherLastName)#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherMiddleName)#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.motherBirth)#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherDOB#" null="#NOT IsDate(FORM.motherDOB)#">,
                            <!--- Mother SSN --->
                            <cfif VAL(vUpdateMotherSSN)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherSSN#">,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherWorkType#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                            <cfif FORM.submit_Start is 'eHost'>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        )  
                    </cfquery>

					<cfscript>
						// Set new host company ID
						FORM.hostID = newRecord.GENERATED_KEY;
                    </cfscript>

				</cfif> <!--- VAL(currentHost) OR val(FORM.hostID) --->

				<!--- Creating Host Family Application - Send Out Welcome Email --->
                <cfscript>
					if ( FORM.submit_Start is 'eHost' ) {
					
						// Email Host Family - Welcome Email
						stSubmitApplication = APPLICATION.CFC.HOST.submitApplication(hostID=FORM.hostID,action="newApplication");
					
						// Error Found
						if ( LEN(stSubmitApplication.formErrors) ) {
							SESSION.formErrors.Add(stSubmitApplication.formErrors);
						} else {
							// Set Page Message
							SESSION.pageMessages.Add(stSubmitApplication.pageMessages);
						}
					
						// Reload page with updated information
						location("#CGI.SCRIPT_NAME#?curdoc=host_fam_info&hostID=#FORM.hostID#", "no");
					
					}
                </cfscript>
		
	        </cfif>
        
		<cfelseif FORM.submit_start is 'update'>

			<!--- Update --->
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                    smg_hosts 
                SET
                    familyLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.familyLastName)#">,
                    fatherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherLastName)#">,
                    fatherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherFirstName)#">,
                    fatherMiddleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherMiddleName)#">,
                    fatherBirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.fatherBirth)#">,
                    fatherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.fatherDOB#" null="#NOT IsDate(FORM.fatherDOB)#">,
                    <!--- Father SSN --->
                    <cfif VAL(vUpdateFatherSSN)>
                    fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherSSN#">,
                    </cfif>
                    fatherWorkType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherWorkType#">,
                    father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                    motherFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherFirstName)#">,
                    motherLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherLastName)#">,
                    motherMiddleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.motherMiddleName)#">,
                    motherBirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.motherBirth)#">,
                    motherDOB = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.motherDOB#" null="#NOT IsDate(FORM.motherDOB)#">,
                    <!--- Mother SSN ---->
                    <cfif VAL(vUpdateMotherSSN)>
                    motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherSSN#">,
                    </cfif>
                    motherWorkType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.motherWorkType#">,
                    mother_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mother_cell#">,
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
                    companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                    <cfif FORM.submit_Start neq 'update'>
                    HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                    arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">,
                    </cfif>
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                    active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                WHERE 
	                hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">
            </cfquery>	
            		
			<Cflocation url="index.cfm?curdoc=host_fam_info&hostID=#FORM.hostID#">
		
        </cfif>
        
	<!--- FORM NOT SUBMITTED --->
    <cfelse>

        <cfscript>
            FORM.familyLastName = qGetHostFamilyInfo.familyLastName;
            FORM.fatherLastName = qGetHostFamilyInfo.fatherLastName;
            FORM.fatherFirstName = qGetHostFamilyInfo.fatherFirstName;
            FORM.fatherMiddleName = qGetHostFamilyInfo.fatherMiddleName;
            FORM.fatherDOB = qGetHostFamilyInfo.fatherDOB;
            FORM.fatherSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyInfo.fatherSSN, displayType='hostFamily');
            FORM.fatherWorkType = qGetHostFamilyInfo.fatherWorkType;
            FORM.father_cell = qGetHostFamilyInfo.father_cell;
            FORM.motherFirstName = qGetHostFamilyInfo.motherFirstName;
            FORM.motherLastName = qGetHostFamilyInfo.motherLastName;
            FORM.motherMiddleName = qGetHostFamilyInfo.motherMiddleName;
            FORM.motherDOB = qGetHostFamilyInfo.motherDOB;
            FORM.motherSSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetHostFamilyInfo.motherSSN, displayType='hostFamily');
            FORM.motherWorkType = qGetHostFamilyInfo.motherWorkType;
            FORM.mother_cell = qGetHostFamilyInfo.mother_cell;
            FORM.address = qGetHostFamilyInfo.address;
            FORM.address2 = qGetHostFamilyInfo.address2;
            FORM.city = qGetHostFamilyInfo.city;
            FORM.state = qGetHostFamilyInfo.state;
            FORM.zip = qGetHostFamilyInfo.zip;
            FORM.phone = qGetHostFamilyInfo.phone;
            FORM.email = qGetHostFamilyInfo.email;
            FORM.companyID = qGetHostFamilyInfo.companyID;
            FORM.regionid = qGetHostFamilyInfo.regionid;
            FORM.arearepid = qGetHostFamilyInfo.arearepid;
            
            // the default values in the database for these used to be "na", so remove any.
            if ( FORM.father_cell EQ 'na' ) {
                FORM.father_cell = '';
            }
            
            if ( FORM.mother_cell EQ 'na') {
                FORM.mother_cell = '';
            }
        </cfscript>

    </cfif> <!--- FORM Submitted --->
   
</cfsilent>

<link rel="stylesheet" href="linked/css/buttons.css" type="text/css">

<script type="text/JavaScript">
	<!--
	// Set cursor to Family Name field	
	$(document).ready(function() {
		$("#familyLastName").focus();
	});

	var copyFamilyLastName = function() { 
		$("#fatherLastName").val( $("#familyLastName").val() );
		$("#motherLastName").val( $("#familyLastName").val() );
	}

	// Jquery Masks 
	jQuery(function($){
	   	// Phone Number
	   	$("#phone").mask("(999) 999-9999");
	   	$("#father_cell").mask("(999) 999-9999");
	   	$("#mother_cell").mask("(999) 999-9999");
	   	// DOB
	   	$("#fatherDOB").mask("99/99/9999");
	   	$("#motherDOB").mask("99/99/9999");
		// SSN
	   	$("#fatherSSN").mask("***-**-9999");
	   	$("#motherSSN").mask("***-**-9999");
	});
	
	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	} 

	// Create an instance of the proxy. 
	var udf = new UDFComponent();
	
	// Get the submit type
	var submitType = "";

	// Use an asynchronous call to get the student details. The function is called when the user selects a student. 
	function verifyAddress(selectedSubmitType) { 
		// Check required Fields
		submitType = selectedSubmitType;
		var errorMessage = "";
		if($("#address").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Address. \n')
		}
		if($("#city").val() == ''){
			errorMessage = (errorMessage + 'Please enter the City. \n')
		}
		if($("#state").val() == ''){
			errorMessage = (errorMessage + 'Please select the State. \n')
		}
		if($("#zip").val() == ''){
			errorMessage = (errorMessage + 'Please enter the Zip. \n')
		}
		if (errorMessage == "") {
			// FORM Variables
			var address = $("#address").val();
			var city = $("#city").val();
			var state = $("#state").val();
			var zip = $("#zip").val();
			
			// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous.
			udf.setCallbackHandler(checkAddress);
			udf.setErrorHandler(myErrorHandler); 
			udf.addressLookup(address,city,state,zip,"232");
		}
	} 

	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkAddress = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;
		var inputState = googleResponse.INPUTSTATE;

		if ( isAddressVerified == 1 ) {

			// Get Data Back	
			var streetAddress = googleResponse.ADDRESS;
			var city = googleResponse.CITY;
			var state = googleResponse.STATE;
			var zip = googleResponse.ZIP;
			zip = zip.substring('zip='.length);
			var verifiedStateID = googleResponse.VERIFIEDSTATEID;
			
			if ((streetAddress == $("#address").val()) && (city == $("#city").val()) && (state == $("#state").val()) && (zip == $("#zip").val()))
			{
				$("#" + submitType).removeAttr("onClick");
				$("#" + submitType).click();
			} else {
				$(function() {
					$( "#dialog:ui-dialog" ).dialog( "destroy" );
					$( "#dialog-approveAddress-confirm" ).empty();
					$( "#dialog-approveAddress-confirm" ).append(
						"<table width='100%'>" +
							"<tr width='100%'><td width='50%'>Verified Address:</td><td width='50%'>Input Address:</td></tr>" +
							"<tr><td>" + streetAddress + "</td><td>" + $("#address").val() + "</td></tr>" +
							"<tr><td>" + city + ", " + state + " " + zip + "</td><td>" + $("#city").val() + ", " + $("#state").val() + " " + $("#zip").val() + "</td></tr>" +
						"</table>");
					$( "#dialog-approveAddress-confirm").dialog({
						resizable: false,
						height:230,
						width:400,
						modal: true,
						buttons: {
							"Use verified": function() {
								$( this ).dialog( "close" );
								$("#address").val(streetAddress);
								$("#city").val(city);
								$("#state").val(state);
								$("#zip").val(zip);
								$("#" + submitType).removeAttr("onClick");
								$("#" + submitType).click();
							},
							"Use input": function() {
								$( this ).dialog( "close" );
								$("#" + submitType).removeAttr("onClick");
								$("#" + submitType).click();
							},
							"Go back": function() {
								$( this ).dialog( "close" );
							}
						}
					});
				});
			}
		} else {
			$(function() {
				$( "#dialog:ui-dialog" ).dialog( "destroy" );
				$( "#dialog-canNotVerify-confirm" ).empty();
				$( "#dialog-canNotVerify-confirm" ).append("We could not verify the following address:<br />" + $("#address").val() + "<br />" + $("#city").val() + ", " + $("#state").val() + " " + $("#zip").val());
				$( "#dialog-canNotVerify-confirm").dialog({
					resizable: false,
					height:230,
					width:400,
					modal: true,
					buttons: {
						"Use anyway": function() {
							$( this ).dialog( "close" );
							$("#" + submitType).removeAttr("onClick");
							$("#" + submitType).click();
						},
						"Go back": function() {
							$( this ).dialog( "close" );
						}
					}
				});
			});
		}	
	}
	
	var getLocationByZip = function() {
		
		var zip = $("#zipLookup").val();

		if (zip.length == 5) {
			udf.setCallbackHandler(checkZip); 
			udf.setErrorHandler(myErrorHandler); 
			udf.zipCodeLookUp(zip);
		} else {
			alert("Please verify your zip code");
		}
	} 

	// Callback function to handle the results returned by the getHostLeadList function and populate the table. 
	var checkZip = function(googleResponse) { 

		var isAddressVerified = googleResponse.ISVERIFIED;

		if ( isAddressVerified == 1 ) {	
			var city = googleResponse.CITY;
			var state = googleResponse.STATE;
			
			$("#city").val(city);
			$("#state").val(state);
			$("#zip").val($("#zipLookup").val());
			$("#zipLookupRow").html("");
		} else {
			alert("Please verify your zip code");
		}

	}

	// Error handler for the asynchronous functions. 
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	}
	//-->
</script>

<cfoutput>

	<!--- Modal Dialogs --->
        
    <!--- Approve Address - Modal Dialog Box --->
    <div id="dialog-approveAddress-confirm" title="Which address would you like to use?" class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p>  
    </div>
    
    <!--- Can Not Verify Address - Modal Dialog Box --->
    <div id="dialog-canNotVerify-confirm" title="We could not verify this address." class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p> 
    </div>

	<!--- address lookup turned on. --->
    <cfif VAL(APPLICATION.address_lookup)>
        <cfinclude template="../includes/address_lookup_#APPLICATION.address_lookup#.cfm">
    </cfif>

	<cfif VAL(qGetHostFamilyInfo.recordCount)>
		<!--- Table Header --->    
        <gui:tableHeader
            imageName="family.gif"
            tableTitle="Host Family Infomation"
            width="95%"
            tableRightTitle='<span class="edit_link">[ <a href="?curdoc=host_fam_info&hostID=#URL.hostID#">overview</a> ]</span>'
        />
	<cfelse>
		<!--- Table Header --->    
        <gui:tableHeader
            imageName="family.gif"
            tableTitle="Host Family Infomation"
            width="95%"
        />
    </cfif>
    
	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="95%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="95%"
        />

    <form name="hostFamilyInfo" id="hostFamilyInfo" action="#CGI.SCRIPT_NAME#?curdoc=forms/host_fam_form" method="post">
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="hostID" value="#FORM.hostID#">
        <input type="hidden" name="lookup_success" value="#FORM.lookup_success#"> <!--- this gets set to 1 by the javascript lookup function on success. --->

        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr>
            	<td colspan="2">
  					<span class="redtext" style="padding-right:30px;">* Required fields &nbsp; &nbsp; + One phone field is required</span>
                </td>
			</tr>
            <tr>
                <td class="label">Family Name: <span class="redtext">*</span></td>
                <td>
                    <input type="text" name="familyLastName" id="familyLastName" value="#FORM.familyLastName#" size="20" class="largeField" <cfif NOT VAL(qGetHostFamilyInfo.recordCount)>onblur="copyFamilyLastName();"</cfif> >
                </td>
            </tr>
			
			<!--- address lookup - auto version. --->
            <cfif APPLICATION.address_lookup EQ 2>
                <tr>
                    <td class="label">Lookup Address: <span class="redtext">*</span></td>
                    <td>
                        Enter at least the street address and zip code and click "Lookup".<br />
                        Address, City, State, and Zip will be automatically filled in.<br />
                        Address line 2 should be manually entered if needed.<br />
                        <textarea name="lookup_address" rows="2" cols="30" value="#FORM.lookup_address#" /><br />
                        <input type="button" value="Lookup" onClick="showLocation();" />
                    </td>
                </tr>
                <tr>
                    <td class="label">Address:</td>
                    <td><input type="text" name="address" value="#FORM.address#" size="40" class="largeField" readonly></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="text" name="address2" value="#FORM.address2#" size="40" class="largeField"></td>
                </tr>
                <tr>			 
                    <td class="label">City</td>
                    <td><input type="text" name="city" value="#FORM.city#" size="20" class="largeField" readonly></td>
                </tr>
                <tr>
                    <td class="label">State:</td>
                    <td><input type="text" name="state" value="#FORM.state#" size="2" maxlength="2" readonly></td>
                </tr>
                <tr>
                    <td class="zip">Zip:</td>
                    <td><input type="text" name="zip" value="#FORM.zip#" class="smallField" maxlength="5" readonly></td>
                </tr>
            
			<!--- Regular Address --->
			<cfelse>
                <tr>
                    <td class="label">Address: <span class="redtext">*</span></td>
                    <td>
                        <input type="text" name="address" id="address" value="#FORM.address#" size="40" class="largeField">
                        <font size="1">NO PO BOXES</font>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="text" name="address2" id="address2" value="#FORM.address2#" size="40" class="largeField"></td>
                </tr>
                <tr id="zipLookupRow">
                    <td class="zip">Zip Lookup: </td>
                    <td><input type="text" name="zipLookup" id="zipLookup" value="#FORM.zipLookup#" class="smallField" maxlength="5" onblur="getLocationByZip()"></td>
                </tr>
                <tr>			 
                    <td class="label">City <span class="redtext">*</span></td>
                    <td><input type="text" name="city" id="city" value="#FORM.city#" size="20" class="largeField"></td>
                </tr>
                <tr>
                    <td class="label">State: <span class="redtext">*</span></td>
                    <td>
                        <select name="state" id="state" class="largeField">
                            <option value="0"></option>
                            <cfloop query="qGetStateList">
                            	<option value="#qGetStateList.state#" <cfif FORM.state EQ qGetStateList.state> selected="selected" </cfif> >#qGetStateList.stateName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="zip">Zip: <span class="redtext">*</span></td>
                    <td><input type="text" name="zip" id="zip" value="#FORM.zip#" class="smallField" maxlength="10"></td>
                </tr>
                
                <!--- address lookup - simple version. --->
                <cfif APPLICATION.address_lookup EQ 1>
                    <tr>
                        <td class="label">Lookup Address: <span class="redtext">*</span></td>
                        <td>
                        	<font size="1">
                                Enter Address, City, State, and Zip and click "Lookup".<br />
                                Verify the address displayed below, and make any corrections on the form if necessary.<br />
                                Address line 2 will not be included below.<br />
                                If you have trouble submitting an address, <a href="mailto:#APPLICATION.CFC.UDF.getSessionEmail(emailType='support')#?subject=Address Lookup">send it to us</a>.<br />
                                <input type="button" value="Lookup" onClick="showLocation();" /><br />
                                <textarea name="lookup_address" readonly rows="2" cols="30">Lookup address will be displayed here.</textarea>
                        	</font>
                    	</td>
                    </tr>
                </cfif>
                
            </cfif>
            
            <tr>
                <td class="label">Phone: <span class="redtext">+</span></td>
                <td><input type="text" name="phone" id="phone" value="#FORM.phone#" class="largeField" maxlength="14"></td>
            </tr>
            <tr>
                <td class="label">Email:</td>
                <td><input type="text" name="email" value="#FORM.email#" class="xLargeField" maxlength="200"></td>
            </tr>
        </table>
		
        <!--- Father Information --->
        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr bgcolor="##e2efc7">
                
                <th align="left">Father's Information</th>
                 <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="label">Last Name:</td>
                <td><input type="text" name="fatherLastName" id="fatherLastName" value="#FORM.fatherLastName#" size="20" class="largeField"></td>
            </tr>
            <tr>
                <td class="label">First Name:</td>
                <td><input type="text" name="fatherFirstName" value="#FORM.fatherFirstName#" size="20" class="largeField"></td>
            </tr>
            <tr>
                <td class="label">Middle Name:</td>
                <td><input type="text" name="fatherMiddleName" value="#FORM.fatherMiddleName#" size="20" class="largeField"></td>
            </tr>
            <tr>
                <td class="label">Date of Birth:</td>
                <td><input type="text" name="fatherDOB" id="fatherDOB" value="#dateFormat(FORM.fatherDOB, 'mm/dd/yyyy')#" class="mediumField" maxlength="10"> mm/dd/yyyy</td>
            </tr>
			<cfif vDisplayFatherSSN>
                <tr>
                    <td class="label">SSN:</td>
                    <td><input type="text" name="fatherSSN" id="fatherSSN" value="#FORM.fatherSSN#" class="mediumField" maxlength="11"></td>
                </tr>	
            </cfif>
            <tr>
                <td class="label">Occupation:</td>
                <td><input type="text" name="fatherWorkType" value="#FORM.fatherWorkType#" class="largeField" maxlength="200"></td>
            </tr>
            <tr>
                <td class="label">Cell Phone: <span class="redtext">+</span></td>
                <td><input type="text" name="father_cell" id="father_cell" value="#FORM.father_cell#" class="largeField" maxlength="14"></td>
            </tr>
        </table>

		<!--- Mother Information --->
        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr bgcolor="##e2efc7">
            	
                <th align="left">Mother's Information</th>
                  <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="label">Last Name:</td>
                <td><input type="text" name="motherLastName" id="motherLastName" value="#FORM.motherLastName#" size="20" class="largeField"></td>
            </tr>
            <tr>
                <td class="label">First Name:</td>
                <td><input type="text" name="motherFirstName" value="#FORM.motherFirstName#" size="20" class="largeField"></td>
            </tr>
            <tr>
                <td class="label">Middle Name:</td>
                <td><input type="text" name="motherMiddleName" value="#FORM.motherMiddleName#" size="20" class="largeField"></td>
            </tr>			
            <tr>
                <td class="label">Date of Birth:</td>
                <td><input type="text" name="motherDOB" id="motherDOB" value="#dateFormat(FORM.motherDOB, 'mm/dd/yyyy')#" class="mediumField" maxlength="10"> mm/dd/yyyy</td>
            </tr>
            <cfif vDisplayMotherSSN>
                <tr>
                    <td class="label">SSN:</td>
                    <td><input type="text" name="motherSSN" id="motherSSN" value="#FORM.motherSSN#" class="mediumField" maxlength="11"></td>
                </tr>		
            </cfif>
            <tr>
                <td class="label">Occupation:</td>
                <td><input type="text" name="motherWorkType" value="#FORM.motherWorkType#" class="largeField" maxlength="200"></td>
            </tr>
            <tr>
                <td class="label">Cell Phone: <span class="redtext">+</span></td>
                <td><input type="text" name="mother_cell" id="mother_cell" value="#FORM.mother_cell#" class="largeField" maxlength="14"></td>
            </tr>
		</table> 		

		<!--- Region Information | New Host Family Only --->
        <cfif NOT qGetHostFamilyInfo.recordCount>
            <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr bgcolor="##e2efc7">
                    <th align="left">Region Information</th>
                     <td>&nbsp;</td>
                </tr>                
                <tr>
                    <td class="label">Region: <span class="redtext">*</span></td>
                    <td> 
                        <select name="regionid" class="largeField">
                            <cfif APPLICATION.CFC.USER.isOfficeUser()>
	                            <option value="">Select Region</option>
                            </cfif>
                            <cfloop query="qGetRegionList">
                                <option value="#qGetRegionList.regionid#" <cfif FORM.regionid EQ qGetRegionList.regionid>selected</cfif>>#qGetRegionList.regionname#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
            </table> 		
        </cfif>


        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr>
				<cfif qGetHostFamilyInfo.recordCount AND ListFind("1,2,3,4", CLIENT.usertype)>
                    <td valign="top">
                        
                            <a href="" onClick="return confirm('You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue.')" style="float:left;">
                                <img src="pics/delete.gif" border="0">
                            </a>
                     </td>
               </cfif>
           	
            	<cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <td valing="top" align="center">
                        <input name="Submit_start" id="submitEHost" type="submit" value="eHost"  alt="Start E-App" border="0" class="buttonBlue" onclick="verifyAddress('submitEHost'); return false;" /> <br />
                        (Host Fam Fills Out App)
                    </td>
                </cfif>
                
                <cfif VAL(FORM.hostID)>
                    <td align="Center">   
                        <input name="Submit_start" id="submitUpdate" type="submit" value="Update"  alt="Update Information" border="0" class="buttonGreen" onclick="verifyAddress('submitUpdate'); return false;" /><br />
                        (Just Update Info)
                    </td>
                <cfelse>
                    <td align="Center">   
                        <input name="Submit_start" id="submitStandard" type="submit" value="Submit"  alt="Submit Paper Application" border="0" class="buttonRed" onclick="verifyAddress('submitStandard'); return false;" /><br />
                        <!--- (Office User Fills Out App) --->
                    </td>
                </cfif>
            </tr>
        </table>
    
    </form>

	<!--- Table Footer --->
    <gui:tableFooter 
        width="95%"
        imagePath=""
    />

</cfoutput>