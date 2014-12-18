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

    <!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.udf" jsclassname="UDFComponent">

    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="">

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
    <cfparam name="FORM.subAction" default="">
	<cfparam name="FORM.sourceCode" default="">
    <cfparam name="FORM.sourceType" default="">
    <cfparam name="FORM.sourceOther" default="">
    
	<cfscript>
		// Set Regions or users or user type that can start host app
		//allowedUsers = '1,12313,8747,17972,17791,8731,12431,17438,17767,15045,10133,6617,16552,16718,10631,9974,510';	
		allowedUsers = "13538,7729,13185,7858,7203,14488,16975,6200,13731,17919,18602";
		allowedRegions = "1474,1389,1020,1435,1463,1093,22,1403,1401,1405,1535";
		
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		//Random Password for account, if needed
		strPassword = APPLICATION.CFC.UDF.randomPassword(length=8);
		
		// Get Host Family Info
		qGetHostFamilyInfo = APPLICATION.CFC.HOST.getHosts(hostID=FORM.hostID);
		
		// Get Host Family Application Info
		qGetApplicationInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=FORM.hostID);
		if (CLIENT.companyid eq 13){
			// Get Province List
			qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState(country='CA');
		}else{
			// Get State List
			qGetStateList = APPLICATION.CFC.LOOKUPTABLES.getState();
		}
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=CLIENT.usertype);
		
		// Get Current User Information
		qGetUserComplianceInfo = APPLICATION.CFC.USER.getUserByID(userID=CLIENT.userID);
		
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
    
	<!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>      	
    
		<cfscript>
			// Data Validation - Check required Fields
			if ( NOT LEN(FORM.familyLastName) ) {
				SESSION.formErrors.Add("Please enter the Family Name.");
			}
			
			if ( NOT LEN(FORM.address) ) {
				SESSION.formErrors.Add("Please enter an Address.");
			}
			
			if ( NOT LEN(FORM.city) ) {
				SESSION.formErrors.Add("Please enter a City.");
			}
			
			if ( NOT LEN(FORM.state) ) {
				if (client.companyid neq 13) {
				SESSION.formErrors.Add("Please select a State.");
				}else{
				SESSION.formErrors.Add("Please select a Province.");	
				}
			}
			
			if (client.companyid neq 13) {
				if ( NOT isValid("zipcode", Trim(FORM.zip)) ) {
					SESSION.formErrors.Add("Please enter a valid Zip.");     
				}
			}else{
				if ( NOT len(Trim(FORM.zip)) ) {
					SESSION.formErrors.Add("Please enter a valid Zip.");     
				}
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
			
			if ( NOT LEN(FORM.sourceCode) ) {
				SESSION.formErrors.Add("Please select a Source Code.");
			}
			if ( FORM.sourceCode EQ 'Other' AND NOT LEN(TRIM(FORM.sourceOther)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("Please provide Other description for source.");
			}
			// Check for email address. 
			if ( FORM.subAction EQ 'eHost' AND NOT LEN(TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("Please enter an email address.");
			}
			
			// Check for email address. 
			if ( FORM.subAction EQ 'eHost' AND LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("Please enter a valid email address.");
			}
        </cfscript>
		
        <!--- Check for duplicate accounts --->
		<cfif isValid("email", FORM.email)>
        
        	<cfscript>
				if (VAL(FORM.hostID)) {
					qCheckEmail = APPLICATION.CFC.host.checkHostEmail(hostID=FORM.hostID,email=FORM.email,companyID=CLIENT.companyID);
				} else {
					qCheckEmail = APPLICATION.CFC.host.checkHostEmail(email=FORM.email,companyID=CLIENT.companyID);
				}
                // Check for email address. 
                if ( qCheckEmail.recordCount ) {
                    //Get all the missing items in a list
                    SESSION.formErrors.Add("There is already an account using the same email address, please refer to host family ID ###qCheckEmail.hostID#");
                }
            </cfscript>

        </cfif>

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
            <cfif VAL(FORM.hostID)>

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
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                        dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
            			updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        sourceCode =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sourceCode#">,
                        sourceOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sourceOther#">,
                        sourceType = 'Direct'
                    WHERE 
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.hostID)#">
                </cfquery>	
                
                <cfscript>
					// Create Online Application
					// Create Online Appliation
					if (FORM.subAction EQ 'eHost') {
						APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=FORM.hostID);	
					}
				
					// Set Page Message
					SESSION.pageMessages.Add("Host Family information sucessfully updated");
				</cfscript>
            
            <!--- Insert --->
            <cfelse>

				<!--- Insert Host Family --->                  
                <cfquery result="newRecord" datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                        smg_hosts 
                    (
                        uniqueID,
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
                        arearepid,
                        dateCreated,
                        createdBy,
                        updatedBy,
                        sourceCode, 
                        sourceType,
                        sourceOther
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
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
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sourceCode#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="Direct">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sourceOther#">
                    )  
                </cfquery>

                <cfscript>
                    // Set new host company ID
                    FORM.hostID = newRecord.GENERATED_KEY;
					
					// Create Online Appliation
					if (FORM.subAction EQ 'eHost') {
						APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=FORM.hostID);	
					}
					
					// Set Page Message
					SESSION.pageMessages.Add("Host Family sucessfully created");
                </cfscript>

            </cfif> <!--- val(FORM.hostID) --->

			<!--- Creating Host Family Application - Send Out Welcome Email --->
            <cfscript>
                if ( FORM.subAction EQ 'eHost' ) {
                
                    // Email Host Family - Welcome Email
                    stSubmitApplication = APPLICATION.CFC.HOST.submitApplication(hostID=FORM.hostID,action="newApplication");
                
                    // Error Found
                    if ( LEN(stSubmitApplication.formErrors) ) {
                        SESSION.formErrors.Add(stSubmitApplication.formErrors);
                    } else {
                        // Set Page Message
                        SESSION.pageMessages.Add(stSubmitApplication.pageMessages);
                    }
                
                }
				
				// Reload page with updated information
				location("#CGI.SCRIPT_NAME#?curdoc=host_fam_info&hostID=#FORM.hostID#", "no");
            </cfscript>
            
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
			FORM.sourceCode = qGetHostFamilyInfo.sourceCode;
			FORM.sourceType = qGetHostFamilyInfo.sourceType;
			FORM.sourceOther = qGetHostFamilyInfo.sourceOther;
            
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
	//show and hide "Other"
	$(document).ready(function(){
    $('#sourceCode').on('change', function() {
      if ( this.value == 'Other')
      {
        $("#sourceOther").show();
      }
      else
      {
        $("#sourceOther").hide();
      }
    });
	});
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

	<cfif VAL(qGetHostFamilyInfo.recordCount)>
		<!--- Table Header --->    
        <gui:tableHeader
            imageName="family.gif"
            tableTitle="Host Family Infomation"
            width="95%"
            tableRightTitle='<span class="edit_link">[ <a href="?curdoc=host_fam_info&hostID=#FORM.hostID#">overview</a> ]</span>'
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

        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr>
            	<td colspan="2">
  					<span class="required" style="padding-right:30px;">* Required fields &nbsp; &nbsp;</span>
                </td>
			</tr>
            <tr>
                <td class="label">Family Name: <span class="required">*</span></td>
                <td>
                    <input type="text" name="familyLastName" id="familyLastName" value="#FORM.familyLastName#" size="20" class="largeField">
                </td>
            </tr>
            <tr>
                <td class="label">Address: <span class="required">*</span></td>
                <td>
                    <input type="text" name="address" id="address" value="#FORM.address#" size="40" class="largeField">
                    <font size="1">NO PO BOXES</font>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><input type="text" name="address2" id="address2" value="#FORM.address2#" size="40" class="largeField"></td>
            </tr>
            <cfif client.companyid neq 13>
            <tr id="zipLookupRow">
                <td class="zip">Zip Lookup: </td>
                
                <td><input type="text" name="zipLookup" id="zipLookup" value="#FORM.zipLookup#" class="smallField" maxlength="5" onblur="getLocationByZip()"></td>
            </tr>
            </cfif>
            <tr>			 
                <td class="label">City <span class="required">*</span></td>
                <td><input type="text" name="city" id="city" value="#FORM.city#" size="20" class="largeField"></td>
            </tr>
            <tr>
                <td class="label"><cfif client.companyid eq 13>Province:<cfelse>State:</cfif> <span class="required">*</span></td>
                <td>
                    <select name="state" id="state" class="largeField">
                        <option value=""></option>
                        <cfloop query="qGetStateList">
                            <option value="#qGetStateList.state#" <cfif FORM.state EQ qGetStateList.state> selected="selected" </cfif> >#qGetStateList.stateName#</option>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="zip"><cfif client.companyid eq 13>Postal Code<cfelse>Zip</cfif>: <span class="required">*</span></td>
                <td><input type="text" name="zip" id="zip" value="#FORM.zip#" class="smallField" maxlength="10"></td>
            </tr>
        <tr>
                <td class="label">Phone:</td>
                <td><input type="text" name="phone" id="phone" value="#FORM.phone#" class="largeField" maxlength="14"></td>
            </tr>
            <tr>
                <td class="label">Email:</td>
                <td>
                	<input type="text" name="email" value="#FORM.email#" class="xLargeField" maxlength="200">
					<cfif VAL(qGetApplicationInfo.applicationStatusID)>
						<br /><span class="required">eHost - Online Application</span>
                    </cfif>
                </td>
            </tr>
        </table>

		<!--- Primary Host Parent's Information --->
        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr bgcolor="##e2efc7">
            	
                <th align="left">Primary Host Parent's Information</th>
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
                <td class="label">Cell Phone:</td>
                <td><input type="text" name="mother_cell" id="mother_cell" value="#FORM.mother_cell#" class="largeField" maxlength="14"></td>
            </tr>
		</table> 
        
        <!--- Other Host Parent's Information --->
        <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
            <tr bgcolor="##e2efc7">
                
                <th align="left">Other Host Parent's Information</th>
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
                <td class="label">Cell Phone:</td>
                <td><input type="text" name="father_cell" id="father_cell" value="#FORM.father_cell#" class="largeField" maxlength="14"></td>
            </tr>
        </table>		
	<table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr bgcolor="##e2efc7">
                    <th align="left">Source of Host Family</th>
                     <td>&nbsp;</td>
                </tr>                
                <tr>
                    <td class="label">Source: <span class="required">*</span></td>
                    <td> 
                        <select name="sourceCode" class="largeField" id="sourceCode">
	                        <option value="">Select Source</option>
                            <option value="Church Group" <cfif FORM.sourceCode EQ "Church Group">selected</cfif>>Church Group</option>
                         	<option value="Friend / Acquaintance" <cfif FORM.sourceCode EQ "Friend / Acquaintance">selected</cfif>>Friend / Acquaintance</option>
                            <option value="Facebook" <cfif FORM.sourceCode EQ "Facebook">selected</cfif>>Facebook</option>
                            <option value="Fair / Trade Show" <cfif FORM.sourceCode EQ "Fair / Trade Show">selected</cfif>>Fair / Trade Show</option> 
                            <option value="Google Search" <cfif FORM.sourceCode EQ "Google Search">selected</cfif>>Google Search</option>
                            <option value="Past Host Family" <cfif FORM.sourceCode EQ "Past Host Family">selected</cfif>>Past Host Family</option>
                            <option value="Newspaper Ad" <cfif FORM.sourceCode EQ "Newspaper Ad">selected</cfif>>Newspaper Ad</option>
                            <option value="Printed Material" <cfif FORM.sourceCode EQ "Printed Material">selected</cfif>>Printed Material</option>
                            <option value="Yahoo Search" <cfif FORM.sourceCode EQ "Yahoo Search">selected</cfif>>Yahoo Search</option> 
                            <option value="Other" <cfif FORM.sourceCode EQ "Other">selected</cfif>>Other</option> 
                        </select>
                    </td>
                </tr>
           </table>
            <cfif FORM.sourceCode NEQ "Other"> <div style='display:none;' id='sourceOther'></cfif>
           <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
              
                <tr>
                	<td class="label">Other: <span class="required">*</span></td><td><input type="text" size=25 name="sourceOther" value="#FORM.sourceOther#" placeholder="Other Description" /></td>
                </tr>
               
            </table> 
            <cfif FORM.sourceCode NEQ "Other">  </div></cfif>
		<!--- Region Information | New Host Family Only --->
        <cfif NOT qGetHostFamilyInfo.recordCount>
            <table width="95%" align="center" class="section" border="0" cellpadding="4" cellspacing="0">
                <tr bgcolor="##e2efc7">
                    <th align="left">Region Information</th>
                     <td>&nbsp;</td>
                </tr>                
                <tr>
                    <td class="label">Region: <span class="required">*</span></td>
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
				<cfif APPLICATION.CFC.USER.isOfficeUser() AND qGetHostFamilyInfo.recordCount>
                    <td valign="top" width="10%">
                        <a href="" onClick="return confirm('You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue.')" style="float:left;">
                            <img src="pics/delete.gif" border="0">
                        </a>
                     </td>
               	</cfif>
                    <td valing="top" align="center">
                    <cfif client.companyid neq 13>
                        <input name="subAction" id="submiteHost" type="submit" value="eHost"  alt="Start E-App" border="0" class="buttonBlue" onclick="verifyAddress('submiteHost'); return false;" />
                        <cfelse>
                         <input name="subAction" id="submiteHost" type="submit" value="eHost"  alt="Start E-App" border="0" class="buttonBlue" />
                        </cfif>
                         <br />
                        <cfif VAL(FORM.hostID)>
                            (Convert this family to an eHost - Host Family fills out application)
                        <cfelse>
                            (Create an eHost - Host Family fills out application)
                        </cfif>
                    </td>
                <cfif VAL(FORM.hostID)>
                    <td align="Center">  
                    <cfif client.companyid neq 13> 
                        <input name="subAction" id="submitUpdate" type="submit" value="Update"  alt="Update Information" border="0" class="buttonGreen" onclick="verifyAddress('submitUpdate'); return false;" />
                        <cfelse>
                         <input name="subAction" id="submitUpdate" type="submit" value="Update"  alt="Update Information" border="0" class="buttonGreen"/>
                        </cfif>
                        <br />
                        (Just Update Info)
                    </td>
                <cfelse>
                    <td align="Center">   
                    <cfif client.companyid neq 13> 
                        <input name="subAction" id="submitStandard" type="submit" value="Submit"  alt="Submit Paper Application" border="0" class="buttonRed" onclick="verifyAddress('submitStandard'); return false;" />
                    <cfelse>
                    <input name="subAction" id="submitStandard" type="submit" value="Submit"  alt="Submit Paper Application" border="0" class="buttonRed" />
                    </cfif>
                        
                        <br />
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
