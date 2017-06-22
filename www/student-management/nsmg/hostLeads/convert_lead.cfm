	<!--- Kill extra output --->



	<cfparam name="unify" default="">
    <!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Ajax Call to the Component --->
	
	
    <!--- Param URL Variables --->
    <cfparam name="URL.hostID" default="">
    <cfparam name="URL.leadID" default="">
    <cfparam name="URL.skip" default="0">
    <cfparam name="URL.skip" default="0">

	<script type="text/javascript" src="/nsmg/assets/js/jquery.maskedinput.js"></script>
	<script>
	jQuery(function($){
	  
	   $("#father_cell").mask("(999) 999-9999");
	  
	});	
	
	</script>
	
	<!--- Param FORM Variables --->
	<cfparam name="FORM.submitted" default="0">
	<cfparam name="FORM.hostID" default="0">    
    <cfparam name="FORM.fatherLastName" default="">
    <cfparam name="FORM.fatherFirstName" default="">
    <cfparam name="FORM.fatherMiddleName" default="">
    <cfparam name="FORM.fatherBirth" default="0">
    <cfparam name="FORM.fatherGender" default="0">
    <cfparam name="FORM.fatherDOB" default="">
    <cfparam name="FORM.fatherSSN" default="">
    <cfparam name="FORM.verify_fatherSSN" default="">
    <cfparam name="FORM.fatherWorkType" default="">
    <cfparam name="FORM.father_cell" default="">
    <cfparam name="FORM.motherFirstName" default="">
    <cfparam name="FORM.motherLastName" default="">
    <cfparam name="FORM.motherMiddleName" default="">
    <cfparam name="FORM.motherBirth" default="0">
    <cfparam name="FORM.motherDOB" default="">
    <cfparam name="FORM.motherSSN" default="">
    <cfparam name="FORM.verify_motherSSN" default="">
    <cfparam name="FORM.motherGender" default="0">
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
    <cfparam name="FORM.password" default="">
    <cfparam name="FORM.companyID" default="">
    <cfparam name="FORM.regionid" default="">
    <cfparam name="FORM.arearepid" default="">
    <cfparam name="FORM.subAction" default="">
	<cfparam name="FORM.sourceCode" default="">
    <cfparam name="FORM.sourceType" default="">
    <cfparam name="FORM.sourceOther" default="">
	<cfparam name="FORM.leadID" default="#url.leadID#">
	<cfparam name="FORM.skip" default="0">
	<cfif val(FORM.skip)>
		<cfset URL.skip =1>	
    </cfif>


		<cfscript>
		// Set Regions or users or user type that can start host app
		//allowedUsers = '1,16718,8747,17972,17791,8731,12431,17438,17767,15045,10133,6617,16552,16718,10631,9974,510';	
		allowedUsers = "13538,7729,13185,7858,7203,14488,16975,6200,13731,17919,18602,24206";
		allowedRegions = "1474,1389,1020,1435,1463,1093,22,1403,1401,1405,1535";
		
		// Check if we have a valid URL.hostID
		if ( VAL(URL.hostID) AND NOT VAL(FORM.hostID) ) {
			FORM.hostID = URL.hostID;
		}
		
		//Random Password for account, if needed
		strPassword = APPLICATION.CFC.UDF.randomPassword(length=8);
		FORM.password = strPassword;
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
		
		//Converting lead to Host
		// Get the given host family lead record
		if ( val(url.leadID) and NOT VAL(form.submitted)) {
			qGetHostLead = APPLICATION.CFC.HOST.getHostLeadByID(ID=FORM.leadID);
		
		
				FORM.familyLastName = qGetHostLead.lastname;
				FORM.fatherLastName = qGetHostLead.lastname;
				FORM.fatherFirstName = qGetHostLead.firstname;
				FORM.father_cell = qGetHostLead.phone;
				FORM.address = qGetHostLead.address;
				FORM.address2 = qGetHostLead.address2;
				FORM.city = qGetHostLead.city;
				FORM.state = qGetHostLead.state;
				FORM.zip = qGetHostLead.zipCode;
				FORM.phone = qGetHostLead.phone;
				FORM.email = qGetHostLead.email;
				
				FORM.regionID = qGetHostLead.regionid;
				FORM.sourceCode = qGetHostLead.hearAboutUs;
				FORM.sourceOther = qGetHostLead.hearAboutUsDetail;
				FORM.areaRepID = qGetHostLead.areaRepID;
				FORM.followUpID = qGetHostLead.followUpID;
		
		}
			
	</cfscript>
   <cfif URL.skip eq 1>

   <cfelse>

	   <cfquery name="checkHostAppExist" datasource="#application.dsn#">
		select *,
		CAST( 
				CONCAT(                      
					IFNULL(h.fatherFirstName, ''),  
					IF(h.fatherLastName != h.motherLastName, ' ', ''), 
					IF(h.fatherLastName != h.motherLastName, h.fatherlastname, ''),
					IF(h.fatherFirstName != '', IF (h.motherFirstName != '', ' and ', ''), ''),
					IFNULL(h.motherFirstName, ''), 
					' ',
					h.familyLastName
					) 
			AS CHAR) AS displayName
		from smg_hosts h
		where email =<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">
		</cfquery>

		<cfif checkHostAppExist.recordcount gt 0>
			<cfquery name="getHashID" datasource="#application.dsn#">
				SELECT hashID
				FROM smg_host_lead
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.leadID#"> 
			</cfquery>
			<cflocation url="_app_sent.cfm?id=#FORM.leadID#&key=#getHashID.hashID#" addtoken="No">
		</cfif>
	</cfif>
    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>      	
    		<cfif (FORM.fatherLastname eq FORM.motherLastName) OR (LEN(FORM.motherLastName) eq 0) >
               		<cfset FORM.familyLastName = #TRIM(FORM.fatherLastName)#>
               	<cfelseif len(FORM.fatherLastName) AND len(motherLastName)>
               		<cfset  FORM.familyLastName = #TRIM(FORM.fatherLastName)# & '-' & #TRIM(FORM.motherLastName)#>
               	<cfelse>
               		<cfset  FORM.familyLastName = #TRIM(FORM.fatherLastName)#>
               	</cfif>
		<cfscript>
		SESSION.FormErrors.clear();
			// Data Validation - Check required Fields
		
			if ( NOT LEN(FORM.father_cell) ) {
				SESSION.formErrors.Add("father_cell");
			}    
			

			if ( LEN(FORM.email) AND NOT isValid("email", Trim(FORM.email)) ) {
				SESSION.formErrors.Add("email");
			}    
			
			if (  NOT LEN(FORM.fatherFirstName)  ) {
				SESSION.formErrors.Add("fatherFirstName");
			}
			
			if (  NOT LEN(FORM.fatherLastName)  ) {
				SESSION.formErrors.Add("fatherLastName");
			}

			if (NOT VAL(FORM.regionid) ) {
				SESSION.formErrors.Add("regionID");
			}
			
			if ( NOT LEN(FORM.sourceCode) ) {
				SESSION.formErrors.Add("source");
			}
			
			// Check for email address. 
			if ( NOT LEN(TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("email");
			}
			
			// Check for email address. 
			if ( LEN(TRIM(FORM.email)) AND NOT isValid("email", TRIM(FORM.email)) ) {
				//Get all the missing items in a list
				SESSION.formErrors.Add("email");
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
                    SESSION.formErrors.Add("There is already an account using the #FORM.email# email address, please refer to host family ID ###qCheckEmail.hostID#");
                }
            </cfscript>

        </cfif>
        
        <!--- // Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
            
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
                     
                        <!--- Father SSN --->
                        fatherGender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherGender#">,
                        father_cell = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
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
                        fatherGender, 
                        father_cell,
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
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherLastName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherLastName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherFirstName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.fatherMiddleName)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fatherGender#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.father_cell#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#strPassword#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.arearepID)#">,
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
				<Cfquery name="addHostIDToLead" datasource="#APPLICATION.DSN#">
           		update smg_host_lead
           			set hostid =  <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#FORM.hostID#">
           				where id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#FORM.leadID#">
				</cfquery>
            </cfif> <!--- val(FORM.hostID) --->
            	<!--- Creating Host Family Application - Send Out Welcome Email --->
            <cfscript>
               
                    // Email Host Family - Welcome Email
                    stSubmitApplication = APPLICATION.CFC.HOST.submitApplication(hostID=FORM.hostID,action="newApplication");
                
                    // Error Found
                    if ( LEN(stSubmitApplication.formErrors) ) {
                        SESSION.formErrors.Add(stSubmitApplication.formErrors);
                    } else {
                        // Set Page Message
                        SESSION.pageMessages.Add(stSubmitApplication.pageMessages);
                    }
                
               
				// Update / Add History Host Lead
				APPLICATION.CFC.HOST.updateHostLead(
					ID=FORM.leadID,					
					followUpID=FORM.followUpID,
					regionID=FORM.regionID,
					areaRepID=FORM.areaRepID,
					statusID='14',
					enteredByID=CLIENT.userID,
					comments='Host Family created and Application sent.'					
				);
				
   				
 				 
 				 // Create Online Appliation
				
				APPLICATION.CFC.HOST.setHostSeasonStatus(hostID=FORM.hostID);	
			
 			


            </cfscript>
            
             <script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 100);
            </script>
		</cfif>
        
	<!--- FORM NOT SUBMITTED --->
    <cfelse>
		<cfif val(form.hostID)>
			<cfscript>
				FORM.familyLastName = qGetHostFamilyInfo.familyLastName;
				FORM.fatherLastName = qGetHostFamilyInfo.fatherLastName;
				FORM.fatherFirstName = qGetHostFamilyInfo.fatherFirstName;
				FORM.fatherMiddleName = qGetHostFamilyInfo.fatherMiddleName;
				FORM.fatherGender = qGetHostFamilyInfo.fatherGender;
				FORM.fatherWorkType = qGetHostFamilyInfo.fatherWorkType;
				FORM.father_cell = qGetHostFamilyInfo.father_cell;
				FORM.address = qGetHostFamilyInfo.address;
				FORM.address2 = qGetHostFamilyInfo.address2;
				FORM.city = qGetHostFamilyInfo.city;
				FORM.state = qGetHostFamilyInfo.state;
				FORM.zip = qGetHostFamilyInfo.zip;
				FORM.phone = qGetHostFamilyInfo.phone;
				FORM.email = qGetHostFamilyInfo.email;				
				FORM.password = qGetHostFamilyInfo.password;
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

			
			</cfscript>
			
			<Cfif val(#URL.skip#)>
				<Cfset FORM.email = ''>
			</Cfif>
		</cfif>
    </cfif> <!--- FORM Submitted --->
   
 
	<div class="wrapper">
		<!--=== Breadcrumbs ===-->
		
		<div class="tab-v2 margin-bottom-40">
							
	
	<div class="row">

		
	</div>	
		<!--=== End Breadcrumbs ===-->

		<!--=== Content Part ===-->
		<div class="">
			<div class="row">
				<cfoutput>
	

				<!-- Begin Content --> 
				<div class="col-md-12 tab-pane fade in active">
					
					<!-- Checkout-Form -->
					<form name="hostFamilyInfo" id="hostFamilyInfo" action="#CGI.SCRIPT_NAME#?curdoc=forms/host_fam_form_lead&leadID=#form.leadID#" method="post" id="sky-form" class="sky-form">
					<Cfif val(#URL.skip#)>
					<input type="hidden" name="skip" value="1">
					</Cfif>
					<input type="hidden" name="submitted" value="1">
					<input type="hidden" name="leadID" value="#FORM.leadID#">
					<input type="hidden" name="followUpID" value="#FORM.followUpID#">
					<input type="hidden" name="areaRepID" value="#FORM.areaRepID#">
		
						<header>Primary Host Parent Information</header>

						<fieldset>
							<div class="row">
								<section class="col col-4">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherFirstName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="fatherFirstName" placeholder="First name" value="#FORM.fatherFirstName#">
									</label>
									<div class="note">Legal first name
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherFirstName" )#>
										is required
									</cfif>
									</div>
								</section>
									<section class="col col-4">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherMiddleName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="fatherMiddleName" placeholder="Middle name" value="#FORM.fathermiddleName#">
									</label>
									<div class="note">Legal middle name</div>
								</section>
								<section class="col col-4">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherLastName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="fatherLastName" placeholder="Last name"value="#FORM.fatherLastName#">
									</label>
									<div class="note">Legal last name
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherLastName" )#>
										is required
									</cfif>
									</div>
								</section>
							</div>
							<div class="row">
							
							<section class="col col-6">
								
								<label class="select <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "gender" )#> state-error</cfif>">
								
									<select name="fatherGender">
										<option value="Neither" selected>Gender</option>
										<option value="Male" <cfif FORM.fatherGender eq 'Male'>selected</cfif>>Male</option>
										<option value="Female" <cfif FORM.fatherGender eq 'Female'>selected</cfif>>Female</option>
									</select>
								
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherGender" )#>
								<div class="note note-error">Gender is required</div>
								</cfif>
							</section>
<!--
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "fatherDOB" )#> state-error</cfif>">
									<i class="icon-prepend fa fa-birthday-cake"></i>
									<input type="text" name="fatherDOB" id="date" placeholder="Birthday" value="#FORM.fatherDOB#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "birthday" )#>
								<div class="note note-error">Birthday is required</div>
								</cfif>
							</section>
-->
								<section class="col col-6">
							<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "father_cell" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-mobile-phone"></i>
								<input type="text" name="father_cell" id="father_cell" placeholder="Phone" value="#FORM.father_cell#">
							</label>
							<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "father_cell" )#>
								<div class="note note-error">Enter a valid phone number</div>
							</cfif>
							</section>
						</div>
						
						</fieldset>
						<Cfif NOT val(FORM.leadID)>
						<header>Secondary Host Parent Information</header>
						<fieldset>
							<div class="row">
								<section class="col col-4">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "motherFirstName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="motherFirstName" placeholder="First name" value="#FORM.motherFirstName#">
									</label>
									<div class="note">Legal first name
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "motherFirstName" )#>
										is required
									</cfif>
									</div>
								</section>
									<section class="col col-4">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "motherMiddleName" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="motherMiddleName" placeholder="Middle name" value="#FORM.motherMiddleName#">
									</label>
									<div class="note">Legal middle name</div>
								</section>
								<section class="col col-4">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "lastname" )#> state-error</cfif>">
										<i class="icon-prepend fa fa-user"></i>
										<input type="text" name="motherLastName" placeholder="Last name"value="#FORM.motherLastName#">
									</label>
									<div class="note">Legal last name
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "motherLastName" )#>
										is required
									</cfif>
									</div>
								</section>
							</div>
						<div class="row">
							
							<section class="col col-6">
								
								<label class="select <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "gender" )#> state-error</cfif>">
								
									<select name="motherGender">
										<option value="Neither" selected>Gender</option>
										<option value="Male" <cfif FORM.motherGender eq 'Male'>selected</cfif>>Male</option>
										<option value="Female" <cfif FORM.motherGender eq 'Female'>selected</cfif>>Female</option>
									</select>
								
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "motherGender" )#>
								<div class="note note-error">Gender is required</div>
								</cfif>
							</section>

							<section class="col col-6">
							<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "social" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-mobile-phone"></i>
								<input type="text" name="mother_cell" id="mother_cell" placeholder="Mobile Phone" value="#FORM.mother_cell# ">
							</label>
							<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "social" )#>
								<div class="note note-error">Enter a valid phone number</div>
							</cfif>
							</section>
						</div>
						<div class="row">

							
						</div>	
						</fieldset>
						</Cfif>
						
						
						<header>Address</header>
						<fieldset>
						<div class="row">
							<section class="col col-10">
									<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address" )#> state-error</cfif>">
									<i class="icon-prepend fa fa-map-marker"></i>
										<input type="text" id="address" name="address" placeholder="Address" value="#FORM.address#">
									</label>
									<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "address" )#>
									<div class="note note-error">Address is required</div>
									</cfif>
							</section>
						</div>
						<div class="row">
							<section class="col col-10">
									<label for="file" class="input">
									<i class="icon-prepend fa fa-map-marker"></i>
										<input type="text" id="address2" name="address2" placeholder="Additional Address Information" value="#FORM.address2#">
									</label>
										
							</section>
						</div>
						<div class="row">
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "city" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-location-arrow"></i>
									<input type="text" name="city" id="city" placeholder="City" value="#FORM.city#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "city" )#>
								<div class="note note-error">City is required</div>
								</cfif>
							</section>
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "state" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-location-arrow"></i>
									<input type="text" name="state" id="state" placeholder="State" value="#FORM.state#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "state" )#>
								<div class="note note-error">State is required</div>
								</cfif>
							</section>
							<section class="col col-4">
								<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "zip" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-location-arrow"></i>
									<input type="text" name="zip" id="zip" placeholder="Zip/Postal Code" value="#FORM.zip#">
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "birthday" )#>
								<div class="note note-error">Zip is required</div>
								</cfif>
							</section>
						</div>
						</fieldset>
					
						<header>Email & Account Login</header>
						<fieldset>
						<div class="row">
							<section class="col col-6">
							<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-envelope"></i>
								<input type="text" name="email" id="email" placeholder="Email" value="#FORM.email#">
							</label>
							<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "email" )#>
								<div class="note note-error">Enter a valid email</div>
							</cfif>
							</section>
							<section class="col col-6">
							<label class="input <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "password" )#> state-error</cfif>">
								<i class="icon-prepend fa fa-key"></i>
								<input type="text" name="password" id="password" placeholder="Password" value="#FORM.password#" <cfif val(#FORM.leadID#)>disabled="disabled"</cfif>>
							</label>
							<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "password" )#>
								<div class="note note-error">Enter a valid password</div>
							</cfif>
							</section>
						</div>
						</fieldset>
						
						<header>Source & Region</header>
						<fieldset>
							<div class="row">
							
							<section class="col col-6">
								
								<label class="select <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "source" )#> state-error</cfif>">
								
									<select name="sourceCode">
										 <option value="">Select Source</option>
										 <option value="Church Group" <cfif FORM.sourceCode EQ "Church Group">selected</cfif>>Church Group</option>
										 <option value="Friend / Acquaintance" <cfif FORM.sourceCode EQ "Friend / Acquaintance">selected</cfif>>Friend / Acquaintance</option>
										 <option value="Facebook" <cfif FORM.sourceCode EQ "Facebook">selected</cfif>>Facebook</option>
										 <option value="Fair / Trade Show" <cfif FORM.sourceCode EQ "Fair / Trade Show">selected</cfif>>Fair / Trade Show</option> 
										 <option value="Google Search" <cfif FORM.sourceCode EQ "Google Search">selected</cfif>>Google Search</option>
										 <option value="Newspaper Ad" <cfif FORM.sourceCode EQ "Newspaper Ad">selected</cfif>>Newspaper Ad</option>
										 <option value="Past Host Family" <cfif FORM.sourceCode EQ "Past Host Family">selected</cfif>>Past Host Family</option>
										 <option value="Phone-A-Thon" <cfif FORM.sourceCode EQ "Phone-A-Thon">selected</cfif>>Phone-A-Thon</option>
										 <option value="Printed Material" <cfif FORM.sourceCode EQ "Printed Material">selected</cfif>>Printed Material</option>
										 <option value="Representative" <cfif FORM.sourceCode EQ "Representative" >selected</cfif>>Representative</option> 
										 <option value="Yahoo Search" <cfif FORM.sourceCode EQ "Yahoo Search">selected</cfif>>Yahoo Search</option> 
										 <option value="Other" <cfif FORM.sourceCode EQ "Other">selected</cfif>>Other</option> 
									</select>
								
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "source" )#>
								<div class="note note-error">Source is required</div>
								</cfif>
							</section>

							<section class="col col-6">
								
								<label class="select <cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "regionID" )#> state-error</cfif>">
								
									<select name="regionid">
										 <cfif APPLICATION.CFC.USER.isOfficeUser()>
											<option value="">Select Region</option>
										</cfif>
										<cfloop query="qGetRegionList">
											<option value="#qGetRegionList.regionid#" <cfif FORM.regionid EQ qGetRegionList.regionid>selected</cfif>>#qGetRegionList.regionname#</option>
										</cfloop>
									</select>
								
								</label>
								<cfif #arrayFind( #SESSION.formErrors.GetCollection()#, "regionid" )#>
								<div class="note note-error">Region is required</div>
								</cfif>
							</section>
						</div>
						</fieldset>	
					
						<fieldset>
							<section>
								<label class="textarea">
									<textarea rows="3" name="info" placeholder="Additional info"></textarea>
								</label>
							</section>
						</fieldset>
						<footer>
							<input type="submit" class="btn-u" value="Send Host Application"></input>
						
						</footer>
					</form>
					<!-- End Checkout-Form -->
</cfoutput>
					<div class="margin-bottom-40"></div>

					
				</div>
				<!-- End Content -->
			</div>
		</div><!--/container-->
		<!--=== End Content Part ===-->
</div>

		<!--Smarty Streets-->
	
		
		<script> var liveaddress = jQuery.LiveAddress({
					key: '19728119051131453',
					autocomplete: 5,
				
					addresses: [{
						address1: '#address',
						address2: '#address2',	// Not all these fields are required
						locality: '#city',
						administrative_area: '#state',
						postal_code: '#zip'
					}]
				});
		
	</script>

	<style>
	.smarty-ui {
		z-index: 999999999 !important;
	}
	</style>


	
	<!----clear errors so they don't show up if closed---->
	<cfscript>
		SESSION.FormErrors.clear();
	</cfscript>
	
</body>
</html>
