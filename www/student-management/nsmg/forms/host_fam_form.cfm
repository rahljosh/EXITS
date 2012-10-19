<!--- ------------------------------------------------------------------------- ----
	
	File:		host_fam_form.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Host Family Information
				
----- ------------------------------------------------------------------------- --->
<link rel="stylesheet" href="linked/css/buttons.css" type="text/css">
<!--- Kill extra output --->
<cfsilent>
	
	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

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
    <cfparam name="FORM.phone" default="">
    <cfparam name="FORM.email" default="">
    <cfparam name="FORM.companyid" default="">
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
    <cfif form.submit_start is ''>
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
			FORM.companyid = qGetHostFamilyInfo.companyid;
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

    <cfif val(FORM.submitted)>
		
		
        	
	
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
		</cfscript>
        
 <cfif FORM.submit_start is 'ehost' or FORM.submit_start is 'submit'>   
    <cfif form.email is not ''>
                <cfquery name="qCheckEmail" datasource="#application.dsn#">
                    SELECT 
                        hostid, 
                        familylastname,
                        password
                    FROM 
                        smg_hosts
                        
                    WHERE
                        <cfif VAL(FORM.hostID)>
                            hostid != <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hostid#">
                        <cfelse>
                            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
                        </cfif>
                </cfquery>
				<cfif qCheckEmail.recordcount eq 1>
                <cfset currentHost = #qCheckEmail.hostid#>
                    <cfif qCheckEmail.password is not ''>
                    <Cfset strPassword = '#qCheckEmail.password#'>
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
		</cfif>
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
        	
			<cfscript>
                // Check for email address. 
                if ( form.submit_Start EQ 'eHost' AND NOT LEN(TRIM(FORM.email)) ) {
                    //Get all the missing items in a list
                    SESSION.formErrors.Add("Please enter an email address.");
                }

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

			<cfif VAL(currentHost) OR val(form.hostid)>
          
                <!--- Update --->
                <cfquery datasource="MySql" result="test">
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
						<Cfif isDefined('form.regionid')>
                        regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        </Cfif>
						---->
                        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfif form.submit_Start neq 'update'>
                        HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                        arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                        </cfif>
                        password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        
                    WHERE 
                    	
                        	hostID = #form.hostid#
                       
                </cfquery>			
             
            <cfelse>
				
				<!--- Insert Host Family --->                  
                <cfquery result="newRecord" datasource="MySql">
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
                        companyid, 
                        regionid, 
                        <cfif form.submit_Start is 'eHost'>
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
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        <cfif form.submit_Start is 'eHost'>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                       
                    )  
                </cfquery>
	
                <cfscript>
					// Set new host company ID
					FORM.hostID = newRecord.GENERATED_KEY;
				</cfscript>
                <cfset currentHost = #FORM.hostID#>
        </cfif>
            	<cfif form.submit_Start is 'eHost'>
        
                    <cfsavecontent variable="hostWelcome">
                    
						<style type="text/css">
                         .rdholder {
                            height:auto;
                            width:auto;
                            margin-bottom:25px;
                            margin-top: 15px;
                         } 
                        
                        
                         .rdholder .rdbox {
                            border-left:1px solid #c6c6c6;
                            border-right:1px solid #c6c6c6;
                            padding:2px 15px;
                            margin:0;
                            display: block;
                            min-height: 137px;
                         } 
                        
                         .rdtop {
                            width:auto;
                            height:20px;
                            /* -webkit for Safari and Google Chrome */
                        
                          -webkit-border-top-left-radius:12px;
                            -webkit-border-top-right-radius:12px;
                            /* -moz for Firefox, Flock and SeaMonkey  */
                        
                          -moz-border-radius-topright:12px;
                            -moz-border-radius-topleft:12px;
                            background-color: #FFF;
                            color: #006699;
                            border-top-width: 1px;
                            border-right-width: 1px;
                            border-bottom-width: 0px;
                            border-left-width: 1px;
                            border-top-style: solid;
                            border-right-style: solid;
                            border-bottom-style: solid;
                            border-left-style: solid;
                            border-top-color: #c6c6c6;
                            border-right-color: #c6c6c6;
                            border-bottom-color: #c6c6c6;
                            border-left-color: #c6c6c6;
                         } 
                        
                         .rdtop .rdtitle {
                            margin:0;
                            line-height:30px;
                            font-family:Arial, Geneva, sans-serif;
                            font-size:20px;
                            padding-top: 5px;
                            padding-right: 10px;
                            padding-bottom: 0px;
                            padding-left: 10px;
                            color: #006699;
                         }
                        
                         .rdbottom {
                        
                          width:auto;
                          height:10px;
                          border-bottom: 1px solid #c6c6c6;
                          border-left:1px solid #c6c6c6;
                          border-right:1px solid #c6c6c6;
                           /* -webkit for Safari and Google Chrome */
                        
                          -webkit-border-bottom-left-radius:12px;
                          -webkit-border-bottom-right-radius:12px;
                        
                        
                         /* -moz for Firefox, Flock and SeaMonkey  */
                        
                          -moz-border-radius-bottomright:12px;
                          -moz-border-radius-bottomleft:12px; 
                         
                         }
                        
                        .clearfix {
                            display: block;
                            height: 5px;
                            width: 500px;
                            clear: both;
                        }
                        .rdholder .rdbox p, li, td {
                            font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
                            font-size: .80em;
                            padding-top: 0px;
                            padding-right: 20px;
                            padding-bottom: 0px;
                            padding-left: 20px;
                        }
                        
                        </style>
                        
        
                        <div class="rdholder" style="width: 595px;"> 
                                        <div class="rdtop"> </div> <!-- end top --> 
                                     <div class="rdbox">
                        <cfoutput>
                        
                           <p><strong> <cfif form.fatherfirstname is not ''>#fatherfirstname#</cfif><Cfif form.fatherfirstname is not '' and form.motherfirstname is not ''> and</Cfif> <cfif form.motherfirstname is not ''>#form.motherfirstname#</cfif>-</strong></p>
                            <cfif val(currentHost)>
                            <p>I am so excited that you have decided to host a student!</p>
                            
                            <p>Everytime you host a student, we require host families to update the information, if needed, that we have on file</p>
                            
                            <p>We are required by the Department of State to collect the following information:</p>
                            <ul>
                            <li>a background check on any person who is 17 years of age or older and who is living in the home. 
                            <li>pictures of certain areas of your home and property to reflect where the student will be living.  
                            <li>basic financial and financial aid information on your family
                            </ul>
                            At the end of this email, you will find login information that will allow you to update any information that has changed and to provide new information that may be required since you last hosted. 
                           <cfelse> 
                           
                           <p>I am so excited that you have decided to host a student!</p>
                            
                            <p>To get started in the process of placing a student with you, I need you to fill out a host application.   The application has a number of questions that will help in finding a student who is suited to living with you.  Please fill out the application as completely as possible.</p>
                            
                            <p>We are required by the Department of State to collect the following information:</p>
                            <ul>
                            <li>a background check on any person who is 17 years of age or older and who is living in the home. 
                            <li>pictures of certain areas of your home and property to reflect where the student will be living.  
                            <li>basic finacial and finacial aid information on your family
                            </ul>
                        </cfif>
                           <p>The application process can take any where from 15-60 minutes to complete depending on the information needed and number of pictures you submit.</p> 
                            
                            <p>You can always come back to the  application at a later time to complete it or change any information  that you want.  Please keep in mind though, that once the application is  submitted, you will no longer be able to change any information on the  application. </p>
          <p><em> We have just launched this electronic  host family application, and you are one of the first families to use  this new tool.  Please bear with  us as we work out the final bugs. Should you get any errors or feel  that something is confusing, please feel free to let us know how we can  improve the process.  There is a live chat and email support available  through the application if you need immediate assistance while filling  out the application.  Any and all feedback would be greatly appreciated.</em></p>
                            
                              <div style="display: block; float: left; width: 250px;  padding: 10px;  font-family:Arial, Helvetica, sans-serif; font-size: .80em"> <strong><em>To start filling out your application, please click on the following link:</em></strong><br /><br />
         <Cfif client.companyid eq 10><a href="http://www.case-usa.org/hostApp/" target="_blank"><cfelse><a href="https://www.iseusa.com/hostApp/" target="_blank"></cfif><img src="#client.exits_url#/nsmg/pics/hostAppEmail.jpg" width="200" height="56" border="0"></a> <br /></div>
         <div style="display: block; float: right; width: 270px; padding: 10px; font-family:Arial, Helvetica, sans-serif; font-size: .80em; border: thin solid ##CCC;"><div><strong><em>Please use the following login information:</em></strong></div><br /><br />
<div style="width: 50px; float: left;"><img src="#client.exits_url#/nsmg/pics/lock.png" width="39" height="56"></div>
   <div> <strong>Username / Email:</strong><br /> <a href="mailto:#form.email#" target="_blank">#form.email#</a><br />
  <strong>Password:<br /></strong>#strPassword#</div>

</div>

                        
                        </cfoutput>
                    </cfsavecontent>
             
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#form.email#">
                        <cfinvokeargument name="email_subject" value="Host Family Application">
                        <cfinvokeargument name="email_message" value="#hostWelcome#">
                        <cfinvokeargument name="email_from" value="#CLIENT.email#">
                    </cfinvoke>
                    
                </cfif>
		
			<!--- VAL(FORM.hostID) --->
			<CFIF VAL(FORM.HOSTID)>
            <cfscript>
                // Set Page Message
                // SESSION.pageMessages.Add("Form successfully submitted.");
                
                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?curdoc=host_fam_info&hostID=#FORM.HOSTID#", "no");
            </cfscript>
            <CFELSE>
			<cfscript>
                // Set Page Message
                // SESSION.pageMessages.Add("Form successfully submitted.");
                
                // Reload page with updated information
                location("#CGI.SCRIPT_NAME#?curdoc=host_fam_info&hostID=#currentHost#", "no");
            </cfscript>
      		</CFIF>
    	</cfif> <!---  NOT SESSION.formErrors.length() --->
    
	<cfelseif form.submit_start is 'update'>
      <Cfif cgi.REMOTE_ADDR is '184.155.138.170'>
  
      <cfdump var="#form#">
  
      </Cfif>
   	 <!--- Update --->
                <cfquery datasource="#application.dsn#">
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
                       
                        companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">,
                        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfif form.submit_Start neq 'update'>
                        HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="9">,
                        arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                        </cfif>
                        password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                        active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        
                    WHERE 
                    	
                        	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.hostid#">
                        
                </cfquery>			
    		<Cflocation url="index.cfm?curdoc=host_fam_info&hostid=#form.hostid#">
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
			FORM.companyid = qGetHostFamilyInfo.companyid;
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
    <!--- Update --->
    </cfif>    
   
</cfsilent>





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
	//-->
</script>

<cfoutput>

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

    <form name="hostFamilyInfo" action="#CGI.SCRIPT_NAME#?curdoc=forms/host_fam_form" method="post">
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
                        <input type="text" name="address" value="#FORM.address#" size="40" class="largeField">
                        <font size="1">NO PO BOXES</font>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="text" name="address2" value="#FORM.address2#" size="40" class="largeField"></td>
                </tr>
                <tr>			 
                    <td class="label">City <span class="redtext">*</span></td>
                    <td><input type="text" name="city" value="#FORM.city#" size="20" class="largeField"></td>
                </tr>
                <tr>
                    <td class="label">State: <span class="redtext">*</span></td>
                    <td>
                        <select name="state" class="largeField">
                            <option value="0"></option>
                            <cfloop query="qGetStateList">
                            	<option value="#qGetStateList.state#" <cfif FORM.state EQ qGetStateList.state> selected="selected" </cfif> >#qGetStateList.stateName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="zip">Zip: <span class="redtext">*</span></td>
                    <td><input type="text" name="zip" value="#FORM.zip#" class="smallField" maxlength="10"></td>
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
           
          		<td valing="top" align="center">
				
                
                   <input name="Submit_start" type="submit" value="eHost"  alt="Start E-App" border="0" class="buttonBlue" /> <br />
               (Host Fam Fills Out App)
                </td>
                
                <td align="Center">   
                
                   <input name="Submit_start" type="submit" value="Submit"  alt="Submit Paper Application" border="0" class="buttonRed" /><br />
                   (Office User Fills Out App)
                </td>
                 
                <td align="Center">   
                
                   <input name="Submit_start" type="submit" value="Update"  alt="Update Information" border="0" class="buttonGreen" /><br />
                   (Just Update Info)
                </td>
            </tr>
        </table>
    
    </form>

	<!--- Table Footer --->
    <gui:tableFooter 
        width="95%"
        imagePath=""
    />

</cfoutput>