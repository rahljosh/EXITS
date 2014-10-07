<!--- ------------------------------------------------------------------------- ----
	
	File:		user_form.cfm
	Author:		Marcus Melo
	Date:		April 11, 2012
	Desc:		User Information

	Updated:	04/11/2012 - Keeping log of active/inactive
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfparam name="URL.userID" default="">
    
	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.udf" jsclassname="UDFComponent">

	<!--- checkboxes, radio buttons aren't defined if not checked. --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.SSN" default="">
    <cfparam name="FORM.sex" default="">
    <cfparam name="FORM.changepass" default="1">
    <cfparam name="FORM.bypass_checklist" default="0">
    <cfparam name="FORM.invoice_access" default="0">
    <cfparam name="FORM.active" default="0">
    <cfparam name="FORM.usebilling" default="0">
    <!--- these fields aren't always displayed. --->
    <cfparam name="FORM.comments" default="">
    <!--- default to USA for non-international users. --->
    <cfparam name="FORM.country" default="USA">
    <cfparam name="FORM.date_2nd_visit_contract_received" default="">
    <cfparam name="FORM.zipLookup" default="">
	
    <cfscript>
		field_list = 'firstname,middlename,lastname,occupation,businessname,address,address2,city,state,zip,country,drivers_license,dob,sex,phone,phone_ext,work_phone,work_ext,cell_phone,emergency_phone,fax,email,email2,skype_id,username,changepass,invoice_access,bypass_checklist,date_contract_received,date_2nd_visit_contract_received,active,dateCancelled,datecreated,usebilling,billing_company,billing_contact,billing_address,billing_address2,billing_city,billing_country,billing_zip,billing_phone,billing_fax,billing_email,comments';

		// Set new default value
		if ( LEN(URL.userID) ) {
			new = false;			
		} else {
			new = true;
			FORM.active = 1;
		}
		
		// Set Display SSN - Sets to 1 if user has access to compliance
		vDisplaySSN = APPLICATION.CFC.USER.hasLoggedInUserComplianceAccess(userID=CLIENT.userID);

		// Set Display SSN
		vDisplaySSN = 0;
	
		// This will set if SSN needs to be updated
		vUpdateSSN = 0;
	
		// Get Current User Information
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=VAL(URL.userID));
		
		// Get Current User Information
		vHasUserComplianceAccess = APPLICATION.CFC.USER.hasLoggedInUserComplianceAccess();
	
		// allow SSN Field - If null or user has access.
		if ( NOT LEN(qGetUserInfo.SSN) OR VAL(vHasUserComplianceAccess) ) {
			vDisplaySSN = 1;
			
			if ( NOT VAL(FORM.submitted) ) {
				// Display SSN
				FORM.SSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUserInfo.SSN, displayType='user');	
			}
			
		}
	</cfscript>
    
</cfsilent>

<cfif LEN(URL.userID)>

	<cfif NOT isNumeric(URL.userID)>
        a numeric userID is required.
        <cfabort>
	</cfif>

	<!--- CHECK RIGHTS --->
    <cfinclude template="../check_rights.cfm">

</cfif>

<!--- Process Form Submission --->
<cfif VAL(FORM.submitted)>

	<!------------------------------------------------------
		ADDRESS CHANGE - SEND EMAIL NOTIFICATION 
	------------------------------------------------------->
	<cfif qGetUserInfo.recordCount AND CLIENT.companyid NEQ 14
		AND 
			(
			 	FORM.address NEQ qGetUserInfo.address 
			OR 
				FORM.address2 NEQ qGetUserInfo.address2 
			OR 
				FORM.city NEQ qGetUserInfo.city 
			OR 
				FORM.state NEQ qGetUserInfo.state 
			OR 
				FORM.zip NEQ qGetUserInfo.zip 
		)>
        
        <cfscript>
			// Used to notify all regional managers responsible for this user
			vRMEmailList = '';
			
			// Stores headquarters email
			vEmailToList = '';
		</cfscript>
        
        <cfquery name="qGetRegionalManagerEmail" datasource="#APPLICATION.DSN#">
            SELECT 
                u.firstName,
                u.lastName,
                u.email
            FROM 
                smg_users u
            LEFT OUTER JOIN
                user_access_rights uar on uar.userID = u.userID
            WHERE 
                uar.regionid IN ( 
                                  SELECT 
                                      regionID 
                                  FROM 
                                      user_access_rights 
                                  WHERE (userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#"> 
                                  AND usertype !=<cfqueryparam cfsqltype="cf_sql_integer" value="9">) ) 
            AND
                uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5"> 
            AND 
                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>
        
        <cfloop query="qGetRegionalManagerEmail">
        
			<cfif IsValid("email",qGetRegionalManagerEmail.email)>
                <cfset vRMEmailList = ListAppend(vRMEmailList, qGetRegionalManagerEmail.email)>
            </cfif>
		
        </cfloop>
                
		<cfswitch expression="#CLIENT.companyID#">
        
        	<cfcase value="1,2,3,4,5,12,13,14">
            	<cfset vEmailToList = 'thea@iseusa.org;eric@iseusa.org;#CLIENT.programmanager_email#;#vRMEmailList#'>
            </cfcase>
			
        	<cfcase value="6">
            	<cfset vEmailToList = 'luke@phpusa.com;eric@iseusa.org'>
            </cfcase>

        	<cfcase value="7">
            	<cfset vEmailToList = 'ryan@iseusa.com;eric@iseusa.org'>
            </cfcase>

        	<cfcase value="8">
            	<cfset vEmailToList = 'anca@csb-usa.com;eric@iseusa.org'>
            </cfcase>
            
        	<cfcase value="10">
            	<cfset vEmailToList = 'stacy@case-usa.org;eric@iseusa.org'>
            </cfcase>
            
		</cfswitch>        

        <cfsavecontent variable="vEmailMessage">
			<cfoutput>
           		<p>NOTICE OF ADDRESS CHANGE</p>
                
	            <p><strong>#FORM.firstname# #FORM.lastname# (###qGetUserInfo.userID#)</strong> has made a change to their address.</p>
                
				<p><strong>NEW ADDRESSS</strong></p>
           		#FORM.address#<br />
          		<cfif LEN(FORM.address2)>#FORM.address2#<br /></cfif>
           		#FORM.city# #FORM.state# #FORM.zip#<br /><br />
           
           		<p><strong>PREVIOUS ADDRESS</strong></p>
	            #qGetUserInfo.address#<br />
          		<cfif LEN(qGetUserInfo.address2)> #qGetUserInfo.address2#<br /></cfif>
           		#qGetUserInfo.city# #qGetUserInfo.state# #qGetUserInfo.zip#<br /><br />
           
           		<p>This is the only notification of this change that you will receive.</p>
                
                <p>Please update any records that do NOT pull information from EXITS.</p>
           		
                <p>The following were notified:<p>
           
		   		#vEmailToList#
			</cfoutput>
		</cfsavecontent>
			
		<!--- send email --->
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            <cfinvokeargument name="email_to" value="#vEmailToList#">
            <cfinvokeargument name="email_subject" value="Notice of Address Change">
            <cfinvokeargument name="email_message" value="#vEmailMessage#">            
        </cfinvoke>
            
	</cfif>
	<!------------------------------------------------------
		END OF ADDRESS CHANGE - SEND EMAIL NOTIFICATION 
	------------------------------------------------------->

	<cfif isDefined("FORM.username")>
    
        <cfquery name="check_username" datasource="#APPLICATION.DSN#">
            SELECT 
            	userID
            FROM 
            	smg_users 
            WHERE 
            	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FORM.username)#">
           <cfif not new>
                AND 
                	userID != <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
           </cfif>
            and active = 1
        </cfquery>
        
    </cfif>
    
    <cfif isDefined("FORM.email")>
    
        <cfquery name="check_email" datasource="#APPLICATION.DSN#">
            SELECT 
            	userID, lastname, firstname
            FROM 
            	smg_users 
            WHERE 
            	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FORM.email)#">
            <cfif not new>
                AND 
                	userID != <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
            </cfif>
          and active = 1
        </cfquery>
        
    </cfif>
	<cfif FORM.lookup_success NEQ 1>
		<cfset errorMsg = 'Please lookup the address.'>
	<cfelseif trim(FORM.firstname) EQ ''>
		<cfset errorMsg = "Please enter the First Name.">
	<cfelseif trim(FORM.lastname) EQ ''>
		<cfset errorMsg = "Please enter the Last Name.">
	<cfelseif (FORM.usertype EQ 8 OR CLIENT.companyid NEQ 13) and trim(FORM.address) EQ ''>
		<cfset errorMsg = "Please enter the Address.">
	<cfelseif (FORM.usertype EQ 8 OR CLIENT.companyid NEQ 13)  and trim(FORM.city) EQ ''>
		<cfset errorMsg = "Please enter the City.">
	<cfelseif (FORM.usertype EQ 8 OR CLIENT.companyid EQ 13)  and trim(FORM.country) EQ ''>
		<cfset errorMsg = "Please select the Country.">
	<cfelseif (FORM.usertype EQ 8 OR CLIENT.companyid NEQ 13)  and application.address_lookup NEQ 2 and trim(FORM.address) EQ ''>
		<cfset errorMsg = "Please enter the Address.">
	<cfelseif (FORM.usertype EQ 8 OR CLIENT.companyid NEQ 13)  and application.address_lookup NEQ 2 and trim(FORM.city) EQ ''>
		<cfset errorMsg = "Please enter the City.">
	<cfelseif (FORM.usertype NEQ 8 AND CLIENT.companyid NEQ 13)  and application.address_lookup NEQ 2 and trim(FORM.state) EQ ''>
		<cfset errorMsg = "Please select the State.">
	<cfelseif (FORM.usertype NEQ 8 AND CLIENT.companyid NEQ 13) and application.address_lookup NEQ 2 and not isValid("zipcode", trim(FORM.zip))>
		<cfset errorMsg = "Please enter a valid Zip.">
	<cfelseif trim(FORM.dob) NEQ '' and not isValid("date", trim(FORM.dob))>
		<cfset errorMsg = "Please enter a valid Birthdate.">
	<cfelseif LEN(FORM.SSN) AND Left(FORM.SSN, 3) NEQ 'XXX' AND NOT isValid("social_security_number", Trim(FORM.SSN))>
		<cfset errorMsg = "Please enter a valid SSN.">
	<cfelseif trim(FORM.phone) EQ '' and trim(FORM.work_phone) EQ '' and trim(FORM.cell_phone) EQ ''>
		<cfset errorMsg = "Please enter one of the Phone fields.">
    <cfelseif FORM.usertype EQ 8 and trim(FORM.emergency_phone) EQ ''>
		<cfset errorMsg = "Please enter an emergency phone.">
    <!---    
	<cfelseif FORM.usertype NEQ 8 and trim(FORM.phone) NEQ '' and not isValid("telephone", trim(FORM.phone))> 
		<cfset errorMsg = "Please enter a valid Home Phone.">
	<cfelseif FORM.usertype NEQ 8 and trim(FORM.work_phone) NEQ '' and not isValid("telephone", trim(FORM.work_phone))> 
		<cfset errorMsg = "Please enter a valid Work Phone.">
	<cfelseif FORM.usertype NEQ 8 and trim(FORM.cell_phone) NEQ '' and not isValid("telephone", trim(FORM.cell_phone))> 
		<cfset errorMsg = "Please enter a valid Cell Phone.">
	<cfelseif FORM.usertype NEQ 8 and trim(FORM.fax) NEQ '' and not isValid("telephone", trim(FORM.faX)) >
		<cfset errorMsg = "Please enter a valid Fax.">
	--->		
	<cfelseif not isValid("email", trim(FORM.email))>
		<cfset errorMsg = "Please enter a valid Email.">
	<cfelseif trim(FORM.email2) NEQ '' and not isValid("email", trim(FORM.email2))>
		<cfset errorMsg = "Please enter a valid Alt. Email.">
	<cfelseif isDefined("FORM.username") and trim(FORM.username) EQ ''>
		<cfset errorMsg = "Please enter the Username.">
	<cfelseif isDefined("FORM.username") and check_username.recordcount NEQ 0>
		<cfset errorMsg = "Sorry, this Username has already been entered in the database.">
    <cfelseif isDefined("FORM.email") and check_email.recordcount NEQ 0>
		<cfset errorMsg = "Sorry, this email address has already been entered in the database for user #check_email.firstname# #check_email.lastname# (#check_email.userid#) ">
	<cfelseif new and trim(FORM.password) EQ ''>
		<cfset errorMsg = "Please enter the Password.">
	<cfelseif new and trim(FORM.confirm_password) EQ ''>
		<cfset errorMsg = "Please confirm the Password.">
	<cfelseif new and trim(FORM.password) NEQ trim(FORM.confirm_password)>
		<cfset errorMsg = "Password and Confirm Password do not match.">
	<cfelseif trim(FORM.date_contract_received) NEQ '' and not isValid("date", trim(FORM.date_contract_received))>
		<cfset errorMsg = "Please enter a valid Contract Received.">
	<cfelseif trim(FORM.date_2nd_visit_contract_received) NEQ '' and not isValid("date", trim(FORM.date_2nd_visit_contract_received))>
		<cfset errorMsg = "Please enter a valid 2nd Visit Contract Received.">
	<cfelseif trim(FORM.dateCancelled) NEQ '' and not isValid("date", trim(FORM.dateCancelled))>
		<cfset errorMsg = "Please enter a valid Date Cancelled.">
	<cfelseif isDefined("FORM.billing_email") and trim(FORM.billing_email) NEQ '' and not isValid("email", trim(FORM.billing_email))>
		<cfset errorMsg = "Please enter a valid Billing Info Email.">
	<cfelse>
    	
		<!--- encrypt the SSN. --->
		<cfscript>
			// SSN - Will update if it's blank or there is a new number
            if ( VAL(vDisplaySSN) AND isValid("social_security_number", Trim(FORM.SSN)) ) {
                // Encrypt Social
                FORM.SSN = APPLICATION.CFC.UDF.encryptVariable(FORM.SSN);
                // Update
                vUpdateSSN = 1;
            } else if ( VAL(vDisplaySSN) AND NOT LEN(FORM.SSN) ) {
                // Update - Erase SSN
                // vUpdateSSN = 1;
            }
        </cfscript>
        
		<cfif new>
            
        	<cflock timeout="30">
                
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                    	smg_users 
                    (
                    	<cfif client.companyid eq 13>
                        accountCreationVerified,
                        dateAccountVerified,
                        last_verification,
                        </cfif>
                    	uniqueid, 
                        datecreated, 
                        trainingDeadlineDate,
                        firstname,
                        middlename, 
                        lastname, 
                        occupation, 
                        businessname,
                    	address, 
                        address2, 
                        city, 
                        state, 
                        zip, 
                        country,
                    	drivers_license, 
                        dob, 
                        sex, 
                        <!--- SSN --->
                    	<cfif VAL(vUpdateSSN)>
                            ssn,
						</cfif>
                        phone, 
                        phone_ext, 
                        work_phone, 
                        work_ext, 
                        cell_phone, 
                        
                        fax, 
                        email, 
                        email2, 
                        skype_id,
                        username, 
                        password, 
                        changepass, 
                        bypass_checklist, 
                        invoice_access, 
                        date_contract_received,
                        date_2nd_visit_contract_received,
                        active, 
                        dateCancelled,
                        
						<cfif FORM.usertype EQ 8>
                        
							usertype, 
                            usebilling, 
                            billing_company, 
                            billing_contact, 
                            billing_address, 
                            billing_address2, 
                            billing_city, 
                            billing_country, 
                            billing_zip, 
                            billing_phone, 
                            billing_fax, 
                            billing_email,
                            emergency_phone,
                        </cfif>
                        comments, 
                        whocreated 
                    )
                    VALUES 
                    (
                    	<cfif client.companyid eq 13>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#" null="#yesNoFormat(trim(FORM.middlename) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.occupation#" null="#yesNoFormat(trim(FORM.occupation) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessname#" null="#yesNoFormat(trim(FORM.businessname) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#" null="#yesNoFormat(trim(FORM.address) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#" null="#yesNoFormat(trim(FORM.address2) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#" null="#yesNoFormat(trim(FORM.city) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#" null="#yesNoFormat(trim(FORM.state) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#" null="#yesNoFormat(trim(FORM.zip) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.country#" null="#yesNoFormat(trim(FORM.country) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.drivers_license#" null="#yesNoFormat(trim(FORM.drivers_license) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#yesNoFormat(trim(FORM.dob) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#" null="#yesNoFormat(trim(FORM.sex) EQ '')#">,
						<!--- SSN --->
                        <cfif VAL(vUpdateSSN)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SSN#">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#" null="#yesNoFormat(trim(FORM.phone) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone_ext#" null="#yesNoFormat(trim(FORM.phone_ext) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.work_phone#" null="#yesNoFormat(trim(FORM.work_phone) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.work_ext#" null="#yesNoFormat(trim(FORM.work_ext) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cell_phone#" null="#yesNoFormat(trim(FORM.cell_phone) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#" null="#yesNoFormat(trim(FORM.fax) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email2#" null="#yesNoFormat(trim(FORM.email2) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.skype_id#" null="#yesNoFormat(trim(FORM.skype_id) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.password#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.changepass#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.bypass_checklist#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.invoice_access#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date_contract_received#" null="#yesNoFormat(trim(FORM.date_contract_received) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date_2nd_visit_contract_received#" null="#yesNoFormat(trim(FORM.date_2nd_visit_contract_received) EQ '')#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.active#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateCancelled#" null="#yesNoFormat(trim(FORM.dateCancelled) EQ '')#">,
                        
						<cfif FORM.usertype EQ 8>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.usertype#">,
                            <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.usebilling#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_company#" null="#yesNoFormat(trim(FORM.billing_company) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_contact#" null="#yesNoFormat(trim(FORM.billing_contact) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address#" null="#yesNoFormat(trim(FORM.billing_address) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address2#" null="#yesNoFormat(trim(FORM.billing_address2) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_city#" null="#yesNoFormat(trim(FORM.billing_city) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_country#" null="#yesNoFormat(trim(FORM.billing_country) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_zip#" null="#yesNoFormat(trim(FORM.billing_zip) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_phone#" null="#yesNoFormat(trim(FORM.billing_phone) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_fax#" null="#yesNoFormat(trim(FORM.billing_fax) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_email#" null="#yesNoFormat(trim(FORM.billing_email) EQ '')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#" null="#yesNoFormat(trim(FORM.emergency_phone) EQ '')#">,
                        </cfif>
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.comments#" null="#yesNoFormat(trim(FORM.comments) EQ '')#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    )  
                </cfquery>
                
                <cfquery name="get_id" datasource="#APPLICATION.DSN#">
                    SELECT 
                    	MAX(userID) AS userID
                    FROM 
                    	smg_users 
                </cfquery>
                
            </cflock>
           
            <cfif FORM.usertype EQ 8>

				<!--- add company & regional access record only for usertype 8. --->
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                    	user_access_rights 
                    (
                    	userID, 
                        companyid, 
                        usertype, 
                        default_access
                    )
                    VALUES 
                    (
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.userID#">,
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="5">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="8">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    )  
                </cfquery>
                
				<cfoutput>
                    <cfsavecontent variable="email_message">
                        This email is to notify you that a new agent profile has been created by #CLIENT.name#. This email is a reminder for the following:<br /><br />
                        <strong>Lois</strong> - Please send out a contract to that Agent<br />
                        <strong>Bryan</strong> - Please make sure you have a price, insurance, and SEVIS option.<br />
                        <strong>Brian</strong> - Make sure this agent has been issued an allocation<br /><br />
                        Agent Info: <a href="#exits_url#/nsmg/index.cfm?curdoc=user_info&userID=">#FORM.businessname#</a>
                    </cfsavecontent>
                </cfoutput>
			
				<!--- send email --->
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="lois@iseusa.org,bmccready@iseusa.org,bhause@iseusa.org">
                    <cfinvokeargument name="email_subject" value="New Agent Profile">
                    <cfinvokeargument name="email_message" value="#email_message#">
                    <cfinvokeargument name="email_from" value="#CLIENT.emailfrom#">
                </cfinvoke>
            </cfif>
            
			<!--- send email --->
            <cfif FORM.usertype NEQ 8 AND NOT ListFind("5,6", CLIENT.userType)> <!--- Do Not Send Email / Account Needs to be activated --->
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
					<cfinvokeargument name="email_replyto" value="#CLIENT.email#">
                    <cfinvokeargument name="email_subject" value="New Account Created / Login Information">
                    <cfinvokeargument name="include_content" value="accountActive">
                    <cfinvokeargument name="userID" value="#get_id.userID#">
                </cfinvoke>
            </cfif>
            
			<!--- send email for initial paperwork --->
            <cfif FORM.usertype EQ 7> <!--- Do Not Send Email / Account Needs to be activated --->
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                    <cfinvokeargument name="email_to" value="#FORM.email#">
					<cfinvokeargument name="email_replyto" value="#CLIENT.email#">
                    <cfinvokeargument name="email_subject" value="Account Created - more info needed">
                    <cfinvokeargument name="include_content" value="newUserMoreInfo">
                    <cfinvokeargument name="userID" value="#get_id.userID#">
                </cfinvoke>
            </cfif>
            
            <!--- company & regional access record was added above for usertype 8, so go to user info page. --->
            <cfif FORM.usertype EQ 8>
            	<cflocation url="index.cfm?curdoc=user_info&userID=#get_id.userID#" addtoken="No">
            <!--- go to company & regional access page.
			usertype is passed because that was selected on add_user.cfm, so we need to disable it on the access rights FORM. --->
            <cfelse>
            	<cflocation url="index.cfm?curdoc=forms/access_rights_form&userID=#get_id.userID#&usertype=#FORM.usertype#&new_user=1" addtoken="No">
            </cfif>
            
		<!--- edit --->
		<cfelse>
        
            <cfscript>
				// Check if we are inactivating an user, if Yes set date // VAL(qGetUserInfo.active) AND 
				if ( NOT VAL(FORM.active) AND NOT isDate(FORM.dateCancelled) ) {
					FORM.dateCancelled = now();
				} else if ( VAL(FORM.active) AND isDate(FORM.dateCancelled) ) {
					FORM.dateCancelled = "";					
				}
				
				/*-----------------------------------------------------------
					SETTING RECORD AS ACTIVE/INACTIVE - KEEP HISTORY 
				-----------------------------------------------------------*/
				
				// Reset Fully Enabled Date 
				vResetDateAccountVerified = 0;
				
				// Inactivating User
				if ( VAL(qGetUserInfo.active) AND NOT VAL(FORM.active) ) {

					// Set Action Message
					vActions = "<strong>Representative set as Inactive</strong> <br /> #CHR(13)#";

					APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
						applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
						foreignTable='smg_users',
						foreignID=URL.userID,
						enteredByID=CLIENT.userID,
						actions=vActions
					);	
				
				// Activating User - Reset fully enabled date
				} else if ( NOT VAL(qGetUserInfo.active) AND VAL(FORM.active) ) {

					// Set Action Message
					vActions = "<strong>Representative set as Active</strong> <br /> #CHR(13)#";

					//Reset fully enabled date - if user has been enabled before
					if ( isDate(qGetUserInfo.dateAccountVerified) ) {
						vResetDateAccountVerified = 1;
						// vActions = vActions & "Previous fully enabled date: #DateFormat(qGetUserInfo.dateAccountVerified, 'mm/dd/yyyy')# <br /> #CHR(13)#";
					}

					APPLICATION.CFC.LOOKUPTABLES.insertApplicationHistory(
						applicationID=APPLICATION.CONSTANTS.TYPE.EXITS,
						foreignTable='smg_users',
						foreignID=URL.userID,
						enteredByID=CLIENT.userID,
						actions=vActions
					);	

				}
				/*-----------------------------------------------------------
					END OF SETTING RECORD AS ACTIVE/INACTIVE - KEEP HISTORY 
				-----------------------------------------------------------*/
			</cfscript>
            
			<cfquery datasource="#APPLICATION.DSN#">
				UPDATE 
                	smg_users 
                SET
                    lastchange = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">,
                    middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#" null="#yesNoFormat(trim(FORM.middlename) EQ '')#">,
                    lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.lastname#">,
                    occupation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.occupation#" null="#yesNoFormat(trim(FORM.occupation) EQ '')#">,
                    businessname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.businessname#" null="#yesNoFormat(trim(FORM.businessname) EQ '')#">,
                    address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#" null="#yesNoFormat(trim(FORM.address) EQ '')#">,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#" null="#yesNoFormat(trim(FORM.address2) EQ '')#">,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#" null="#yesNoFormat(trim(FORM.city) EQ '')#">,
                    state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.state#" null="#yesNoFormat(trim(FORM.state) EQ '')#">,
                    zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#" null="#yesNoFormat(trim(FORM.zip) EQ '')#">,
                    drivers_license = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.drivers_license#" null="#yesNoFormat(trim(FORM.drivers_license) EQ '')#">,
                    dob = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dob#" null="#yesNoFormat(trim(FORM.dob) EQ '')#">,
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#" null="#yesNoFormat(trim(FORM.sex) EQ '')#">,
					<!--- SSN --->
                    <cfif VAL(vUpdateSSN)>
                        SSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SSN#">,
                    </cfif>
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#" null="#yesNoFormat(trim(FORM.phone) EQ '')#">,
                    phone_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone_ext#" null="#yesNoFormat(trim(FORM.phone_ext) EQ '')#">,
                    work_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.work_phone#" null="#yesNoFormat(trim(FORM.work_phone) EQ '')#">,
                    work_ext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.work_ext#" null="#yesNoFormat(trim(FORM.work_ext) EQ '')#">,
                    cell_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cell_phone#" null="#yesNoFormat(trim(FORM.cell_phone) EQ '')#">,
                    fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#" null="#yesNoFormat(trim(FORM.fax) EQ '')#">,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
                    email2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email2#" null="#yesNoFormat(trim(FORM.email2) EQ '')#">,
                    
					<cfif isDefined("FORM.username")>
                        username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.username#">,
                    </cfif>
                    
                    <cfif listFind("1,2,3,4", CLIENT.userType)>
                        changepass = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.changepass#">,
                        bypass_checklist = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.bypass_checklist#">,
                    </cfif>
                    
                    <cfif CLIENT.usertype EQ 1>
                        invoice_access = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.invoice_access#">,
                    </cfif>
                    
                    <cfif listFind("1,2,3,4", CLIENT.userType)>
                        date_contract_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date_contract_received#" null="#NOT isDate(FORM.date_contract_received)#">,
                        active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.active#">,
                        dateCancelled = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateCancelled#" null="#NOT isDate(FORM.dateCancelled)#">,
                    </cfif>
                    
                    <cfif FORM.usertype EQ 8>
                        country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.country#" null="#yesNoFormat(trim(FORM.country) EQ '')#">,
                        usebilling = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.usebilling#">,
                        billing_company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_company#" null="#yesNoFormat(trim(FORM.billing_company) EQ '')#">,
                        billing_contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_contact#" null="#yesNoFormat(trim(FORM.billing_contact) EQ '')#">,
                        billing_address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address#" null="#yesNoFormat(trim(FORM.billing_address) EQ '')#">,
                        billing_address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_address2#" null="#yesNoFormat(trim(FORM.billing_address2) EQ '')#">,
                        billing_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_city#" null="#yesNoFormat(trim(FORM.billing_city) EQ '')#">,
                        billing_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_country#" null="#yesNoFormat(trim(FORM.billing_country) EQ '')#">,
                        billing_zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_zip#" null="#yesNoFormat(trim(FORM.billing_zip) EQ '')#">,
                        billing_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_phone#" null="#yesNoFormat(trim(FORM.billing_phone) EQ '')#">,
                        billing_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_fax#" null="#yesNoFormat(trim(FORM.billing_fax) EQ '')#">,
                        billing_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.billing_email#" null="#yesNoFormat(trim(FORM.billing_email) EQ '')#">,
                        emergency_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.emergency_phone#" null="#yesNoFormat(trim(FORM.emergency_phone) EQ '')#">,
                    </cfif>
                    
                    <cfif isDefined("FORM.comments")>
                        comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.comments#" null="#yesNoFormat(trim(FORM.comments) EQ '')#">,
                    </cfif>
                    
                    <!--- Reset Date Account Verified --->
                    <cfif VAL(vResetDateAccountVerified)>
                    	dateAccountVerified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                    
                    skype_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.skype_id#" null="#yesNoFormat(trim(FORM.skype_id) EQ '')#">
                    
                    WHERE 
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
			</cfquery>
            
            <cflocation url="index.cfm?curdoc=user_info&userID=#URL.userID#" addtoken="No">
            
		</cfif>
        
	</cfif>

<!--- add --->
<cfelseif new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "FORM.#counter#" = "">
	</cfloop>
    
    <!--- we're coming from add_user.cfm --->
    <cfset FORM.usertype = URL.usertype>
    <cfscript>
    //Random Password for account, if needed
		temp_password = APPLICATION.CFC.UDF.randomPassword(length=8);
    </cfscript>
    <cfset FORM.password = temp_password>
    <cfset FORM.confirm_password = temp_password>
    <cfset FORM.changepass = 1>
    <cfset FORM.datecreated = now()>
    <!----If Regional Manager/Advisor is creating account, set active to NO.  Once approved, account will be set to active.---->
	<cfset FORM.active = 1>
    <!--- International users don't have the lookup. --->
    <cfif FORM.usertype EQ 8 or CLIENT.companyid eq 13>
		<cfset FORM.lookup_success = 1>
	<cfelse>
		<!--- lookup_success must be 0 to require lookup on add. --->
		<cfset FORM.lookup_success = 0>
        <cfset FORM.lookup_address = ''>
    </cfif>
   
<!--- edit --->
<cfelseif not new>

	<cfloop list="#field_list#" index="counter">
    	<cfset "FORM.#counter#" = evaluate("qGetUserInfo.#counter#")>
	</cfloop>
    
	<!--- get the access level of the user viewed.
	If null, then user viewing won't have access to username, etc. --->
    <cfinvoke component="nsmg.cfc.user" method="get_access_level" returnvariable="FORM.usertype">
        <cfinvokeargument name="userID" value="#URL.userID#">
    </cfinvoke>

    <!--- International users don't have the lookup. --->
    <cfif FORM.usertype EQ 8 or CLIENT.companyid eq 13>
		<cfset FORM.lookup_success = 1>
	<cfelse>
		<!--- lookup_success may be set to 1 to not require lookup on edit. --->
		<cfset FORM.lookup_success = 0>
        <cfset FORM.lookup_address = '#qGetUserInfo.address##chr(13)##chr(10)##qGetUserInfo.city# #qGetUserInfo.state# #qGetUserInfo.zip#'>
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
	<cfset FORM.lookup_success = 1>
</cfif>

<script type="text/javascript">

	function CopyContact() {
		if (document.my_FORM.copycontact.checked) {
			document.my_FORM.billing_company.value = document.my_FORM.businessname.value;
			document.my_FORM.billing_contact.value = document.my_FORM.firstname.value+' '+document.my_FORM.lastname.value;
			document.my_FORM.billing_address.value = document.my_FORM.address.value;
			document.my_FORM.billing_address2.value = document.my_FORM.address2.value;
			document.my_FORM.billing_city.value = document.my_FORM.city.value;      
			document.my_FORM.billing_country.value = document.my_FORM.country.value;
			document.my_FORM.billing_zip.value =  document.my_FORM.zip.value;
			document.my_FORM.billing_phone.value =  document.my_FORM.phone.value;
			document.my_FORM.billing_fax.value = document.my_FORM.fax.value;
			document.my_FORM.billing_email.value = document.my_FORM.email.value;
		}
		else {
			document.my_FORM.billing_company.value = '';
			document.my_FORM.billing_contact.value = '';
			document.my_FORM.billing_address.value =  '';
			document.my_FORM.billing_address2.value = '';
			document.my_FORM.billing_city.value = '';      
			document.my_FORM.billing_country.value = '';
			document.my_FORM.billing_zip.value =  ''; 
			document.my_FORM.billing_phone.value =  '';
			document.my_FORM.billing_fax.value = '';
			document.my_FORM.billing_email.value = '';
	   }
	}
	
	function CopyEmail() {
		document.my_FORM.username.value = document.my_FORM.email.value;
	}

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

	// Use an asynchronous call to get the student details. The function is called when the user selects a student. 
	var verifyAddress = function() {
		
		// Check required Fields
		var errorMessage = "";
		if ($("#firstname").val() == "") {
			errorMessage += 'Please enter a first name. \n';
		}
		if ($("#lastname").val() == "") {
			errorMessage += 'Please enter a last name. \n';
		}
		if ($("#address").val() == "") {
			errorMessage += 'Please enter an address. \n';
		}
		if ($("#city").val() == "") {
			errorMessage += 'Please enter a city. \n';
		}
		<cfif FORM.usertype NEQ 8 AND CLIENT.companyid NEQ 13>
			if ($("#state").val() == "") {
				errorMessage += 'Please select a state. \n';
			}
			if ($("#zip").val() == "") {
				errorMessage += 'Please enter a zip. \n';
			}	
		</cfif>	
		<cfif FORM.usertype EQ 8>
			if ($("#country").val() == "") {
				errorMessage += 'Please select a country. \n';
			}
		</cfif>
		if ($("#phone").val() == "" && $("#work_phone").val() == "" && $("#cell_phone").val() == "") {
			errorMessage += 'Please enter one of the Phone fields. \n';
		}
		if ($("#email").val() == "") {
			errorMessage += 'Please enter an email address. \n';
		}
		if ($("#username").val() == "") {
			errorMessage += 'Please enter a username. \n';
		}
		if ($("#password").val() != $("#confirm_password").val()) {
			errorMessage += 'Password and Confirm Password do not match. \n';
		}

		if (errorMessage != "") {
			alert(errorMessage);
		} else {
			<cfif FORM.usertype NEQ 8>
				// FORM Variables
				var address = $("#address").val();
				var city = $("#city").val();
				var state = $("#state").val();
				var zip = $("#zip").val();
		
				// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
				udf.setCallbackHandler(checkAddress); 
				udf.setErrorHandler(myErrorHandler); 
				udf.addressLookup(address,city,state,zip,"232");
			<cfelse>
				$("#my_form").submit();
			</cfif>
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
				$("#my_form").submit();
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
								$("#my_form").submit();
							},
							"Use input": function() {
								$( this ).dialog( "close" );
								$("#my_form").submit();
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
							$("#my_form").submit();
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
</script>

<cfoutput>

	<!--- Approve Address - Modal Dialog Box --->
    <div id="dialog-approveAddress-confirm" title="Which address would you like to use?" class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p> 
    </div>
    <!--- Can Not Verify Address - Modal Dialog Box --->
    <div id="dialog-canNotVerify-confirm" title="We could not verify this address." class="displayNone"> 
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span></p> 
    </div>

<!----Header Format Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign="middle" height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>User Information</td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/user_form&userID=#URL.userID#" method="post" name="my_form">
<input type="hidden" name="submitted" value="1">
<input type="hidden" name="usertype" value="#FORM.usertype#">
<input type="hidden" name="lookup_success" value="#FORM.lookup_success#"> <!--- this gets set to 1 by the javascript lookup function on success. --->

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<span class="redtext">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Required fields &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + One phone field is required</span>
<table width="100%">
	<tr valign="top">
		<td>
        
			<table>
            <tr>
                <td colspan=2 bgcolor="CCCCCC"><u>Personal Information</u></td>
            </tr>
            <tr>
            	<td align="right">First Name: <span class="redtext">*</span></td>
                <td><input type="text" name="firstname" id="firstname" value="#FORM.firstname#" size="20" maxlength="100" /></td>
            </tr>
            <tr>
            	<td align="right">Middle Name:</td>
                <td><cfinput type="text" name="middlename" id="middleName" value="#FORM.middlename#" size="20" maxlength="50"></td>
            </tr>
            <tr>
            	<td align="right">Last Name: <span class="redtext">*</span></td>
                <td><input type="text" name="lastname" id="lastname" value="#FORM.lastname#" size="20" maxlength="100" /></td>
            </tr>
            <tr>
                <td align="right">Occupation:</td>
                <td><cfinput type="text" name="occupation" id="occupation" value="#occupation#" size="40" maxlength="150"></td>
            </tr>
            <tr>
                <td align="right">Company Name:</td>
                <td><cfinput type="text" name="businessname" id="businessname" value="#FORM.businessname#" size="40" maxlength="150"></td>
            </tr>

		<!---- Int. Reps ---->
        <cfif FORM.usertype EQ 8 OR CLIENT.companyid eq 13>

            <cfquery name="country_list" datasource="#APPLICATION.DSN#">
                select countryname, countryid
                from smg_countrylist
                ORDER BY countryname
            </cfquery>

            <tr>
            	<td align="right"> Address: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="address" id="address" value="#FORM.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address."></td>
            </tr>
            <tr>
            	<td align="right"></td>
                <td><cfinput type="text" name="address2" id="address2" value="#FORM.address2#" size="40" maxlength="150"></td>
            </tr>
            <tr>
            	<td align="right">City: <span class="redtext">*</span></td>
                <td><cfinput type="text" name="city" id="city" value="#FORM.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."></td>
            </tr>
            <tr>
                <td align="right">State:</td>
                <td><cfinput type="text" name="state" id="state" value="#FORM.state#" size="20" maxlength="20"></td>
            </tr>
            <tr>
            	<td align="right">Postal Code (Zip):</td>
                <td><cfinput type="text" name="zip" id="zip" value="#FORM.zip#" size="10" maxlength="10"></td>
            </tr>
            <tr>
                <td align="right">Country: <span class="redtext">*</span></td>
                <td>
                    <cfselect NAME="country" id="country" query="country_list" value="countryid" display="countryname" selected="#FORM.country#" queryPosition="below">
                        <option value=""></option>
                    </cfselect>
                </td>
            </tr>

		<cfelse>

			<!--- address lookup - auto version. --->
            <cfif application.address_lookup EQ 2>
                <tr>
                    <td align="right">Lookup Address: <span class="redtext">*</span></td>
                    <td>
                        Enter at least the street address and zip code and click "Lookup".<br />
                        Address, City, State, and Zip will be automatically filled in.<br />
                        Address line 2 should be manually entered if needed.<br />
                        <cftextarea name="lookup_address" rows="2" cols="30" value="#FORM.lookup_address#" /><br />
                        <input type="button" value="Lookup" onClick="showLocation();" />                
                    </td>
                </tr>
                <tr>
                    <td align="right">Address:</td>
                    <td><cfinput type="text" name="address" id="address" value="#FORM.address#" size="40" maxlength="150" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"></td>
                    <td><cfinput type="text" name="address2" value="#FORM.address2#" size="40" maxlength="150"></td>
                </tr>
                <tr>
                    <td align="right">City:</td>
                    <td><cfinput type="text" name="city" id="city" value="#FORM.city#" size="20" maxlength="150" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right">State:</td>
                    <td><cfinput type="text" name="state" id="state" value="#FORM.state#" size="2" maxlength="2" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right">Zip: <span class="redtext">*</span></td>
                    <td><cfinput type="text" name="zip" value="#FORM.zip#" size="10" maxlength="10" readonly="readonly"></td>
                </tr>
            <cfelse>
            	<tr id="zipLookupRow">
                	<td align="right">Zip Lookup: <span class="redtext">*</span> </td>
                    <td><input type="text" name="zipLookup" id="zipLookup" value="#FORM.zipLookup#" size="5" maxlength="5" onblur="getLocationByZip();" />
                </tr>                
                <tr>
                    <td align="right">Address: <span class="redtext">*</span></td>
                    <td>
                    	<cfinput type="text" name="address" id="address" value="#FORM.address#" size="40" maxlength="150" required="yes" validate="noblanks" message="Please enter the Address.">
			            <font size="1">NO PO BOXES</font>
                    </td>
                </tr>
                <tr>
                    <td align="right"></td>
                    <td><cfinput type="text" name="address2" value="#FORM.address2#" size="40" maxlength="150"></td>
                </tr>
                <tr>
                    <td align="right">City: <span class="redtext">*</span></td>
                    <td><cfinput type="text" name="city" id="city" value="#FORM.city#" size="20" maxlength="150" required="yes" validate="noblanks" message="Please enter the City."></td>
                </tr>
          		<tr>
                    <td class="label">State: <span class="redtext">*</span></td>
                    <td>
                    	<cfquery name="get_states" datasource="#APPLICATION.DSN#">
                            SELECT state, statename
                            FROM smg_states
                            ORDER BY id
                        </cfquery>
                        <select id="state" name="state" class="largeField">
                            <option value="0"></option>
                            <cfloop query="get_states">
                                <option value="#get_states.state#" <cfif FORM.state EQ get_states.state> selected="selected" </cfif> >#get_states.stateName#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right">Zip: <span class="redtext">*</span></td>
                    <td><input type="text" name="zip" id="zip" value="#FORM.zip#" size="5" maxlength="5" /></td>
                </tr>
				<!--- address lookup - simple version. --->
                <cfif application.address_lookup EQ 1>
                    <tr>
                        <td align="right">Lookup Address: <span class="redtext">*</span></td>
                        <td><font size="1">
                            Enter Address, City, State, and Zip and click "Lookup".<br />
                            Verify the address displayed below, and make any corrections on the form if necessary.<br />
                            Address line 2 will not be included below.<br />
                            If you have trouble submitting an address, <a href="mailto:#APPLICATION.CFC.UDF.getSessionEmail(emailType='support')#?subject=Address Lookup">send it to us</a>.<br />
                            <input type="button" value="Lookup" onClick="showLocation();" /><br />
                            <textarea name="lookup_address" readonly="readonly" rows="2" cols="30">Lookup address will be displayed here.</textarea>
                        </font></td>
                    </tr>
                </cfif>
            </cfif>

        </cfif>
                    
            <tr>
                <td align="right">Drivers License:</td>
                <td><cfinput type="text" name="drivers_license" value="#FORM.drivers_license#" size="20" maxlength="50"></td>
            </tr>
            <tr>
                <td align="right">Birthdate:</td>
                <td><cfinput type="text" name="dob" value="#DateFormat(FORM.dob,'mm/dd/yyyy')#" size="10" maxlength="10" mask="99/99/9999" validate="date" message="Please enter a valid Birthdate."> mm/dd/yyyy</td>
            </tr>
            <tr>
                <td align="right">Sex:</td>
                <td>
                	<cfinput type="radio" name="sex" value="Male" checked="#yesNoFormat(FORM.sex EQ 'Male')#">Male
                    <cfinput type="radio" name="sex" value="Female" checked="#yesNoFormat(FORM.sex EQ 'Female')#">Female
                </td>
            </tr>
			<cfif vDisplaySSN>
                <tr>
                	<td class="label">SSN:</td>
                    <td><cfinput type="text" name="ssn" value="#FORM.ssn#" size="11" maxlength="11" mask="???-??-9999"></td>
                </tr>	
            </cfif>
			</table>
            
		</td>
		<td>
       
			<table border="0" width="100%">
				<tr>
                	<td colspan=2 bgcolor="CCCCCC"><u>Contact Information</u></td>
                </tr>
				<cfif not new and FORM.usertype NEQ 8>
                    <tr>
                        <td colspan="2"><font size="1">
                            Masks were recently added to the Phone and Fax fields with (999) 999-9999 format.<br>
                            Existing values with 999-999-9999 format might be displayed incorrectly<br />
							and you will not be able to submit the FORM.<br>
                            Please verify the existing values displayed next to the form field and re-enter if necessary.
                        </font></td>
                    </tr>
                </cfif>
			  	<tr>
					<td align="right">Home Phone: <span class="redtext">+</span></td>
					<td>
						<!---- Int. Reps ---->
                        <cfif FORM.usertype EQ 8 or CLIENT.companyid eq 13>
                    		<cfinput type="text" name="phone" id="phone" value="#FORM.phone#" size="20" maxlength="25">
                    	<cfelse>
							<cfinput type="text" name="phone" id="phone" value="#FORM.phone#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Home Phone." --->
                        </cfif>
                        &nbsp; Ext. <cfinput type="text" name="phone_ext" value="#FORM.phone_ext#" size="5" maxlength="11">
                    </td>
				</tr>
				  	<tr>
					<td align="right">Work Phone: <span class="redtext">+</span></td>
					<td>
						<!---- Int. Reps ---->
                        <cfif FORM.usertype EQ 8>
                    		<cfinput type="text" name="work_phone" id="work_phone" value="#FORM.work_phone#" size="20" maxlength="25">
                    	<cfelse>
							<cfinput type="text" name="work_phone" id="work_phone" value="#FORM.work_phone#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Home Phone." --->
                        </cfif>
                        &nbsp; Ext. <input type="text" name="work_ext" value="#FORM.work_ext#" size="5" maxlength="11">
                    </td>
				</tr>
				  	<tr>
					<td align="right">Cell Phone: <span class="redtext">+</span></td>
					<td>
						<!---- Int. Reps ---->
                        <cfif FORM.usertype EQ 8>
                            <cfinput type="text" name="cell_phone" id="cell_phone" value="#FORM.cell_phone#" size="20" maxlength="25">
                    	<cfelse>
							<cfinput type="text" name="cell_phone" id="cell_phone" value="#FORM.cell_phone#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Cell Phone." --->
                        </cfif>
                    </td>
				</tr>
                <cfif FORM.usertype EQ 8>
                <tr>
					<td align="right">Emergency Phone: <span class="redtext">*</span></td>
					<td>
						<!---- Int. Reps ---->
                        
                            <cfinput type="text" name="emergency_phone" id="cell_phone" value="#FORM.emergency_phone#" size="20" maxlength="25">
                    
                    </td>
				</tr>
                </cfif>
				<tr>
					<td align="right">Fax:</td>
					<td>
						<!---- Int. Reps ---->
                        <cfif FORM.usertype EQ 8>
                            <cfinput type="text" name="fax" value="#FORM.fax#" size="20" maxlength="20">
                    	<cfelse>
							<cfinput type="text" name="fax" value="#FORM.fax#" size="14" maxlength="14" mask="(999) 999-9999"> <!--- validate="telephone" message="Please enter a valid Fax." ---> 
							#FORM.fax#
                        </cfif>
                    </td>
				</tr>
				<tr>
					<td align="right">Email: <span class="redtext">*</span></td>
					<td>
                    	<cfif new>
                        	Login information will be sent on creation of account.<br>
							Leave email address blank for no email address,<br />
							no email / error will be generated .<br />
                        	<cfinput type="text" name="email" id="email" value="#FORM.email#" size="30" maxlength="150" required="yes" validate="email" message="Please enter a valid Email." onchange="javascript:CopyEmail()">
                        <cfelse>
                        	<cfinput type="text" name="email" id="email" value="#FORM.email#" size="30" maxlength="150" required="yes" validate="email" message="Please enter a valid Email.">
                        </cfif>
                    </td>
				</tr>
				<tr>
					<td align="right">Alt. Email:</td>
					<td><cfinput type="text" name="email2" value="#FORM.email2#" size="30" maxlength="150" validate="email" message="Please enter a valid Alt. Email."></td>
				</tr>
				<tr>
					<td align="right">Skype ID:</td>
					<td><cfinput type="text" name="skype_id" value="#FORM.skype_id#" size="30" maxlength="100"></td>
				</tr>
				<tr>
                	<td colspan=2>&nbsp;</td>
                </tr>
				<tr>
                	<td colspan=2 bgcolor="CCCCCC"><u>Login Information</u></td>
                </tr>
                
				<cfif new or listFind("1,2,3,4", CLIENT.userType) or CLIENT.usertype lt FORM.usertype or CLIENT.userID eq URL.userID>


                    <tr>
                        <td align="right">Username: <span class="redtext">*</span></td>
                        <td>
							<cfif new>
                                Username defaults to email address, change if desired.<br />
                            </cfif>
                            <cfinput type="text" name="username" id="username" value="#FORM.username#" size="30" maxlength="100" required="yes" validate="noblanks" message="Please enter the Username.">
                        </td>
                    </tr>
                </cfif>
                <!--- allow them to change password if needed on new user, or use default random password. --->
				<cfif new>
                    <tr>
                        <td align="right">Password: <span class="redtext">*</span></td>
                        <td><cfinput type="password" name="password" id="password" value="#FORM.password#" size="20" maxlength="15" required="yes" validate="noblanks" message="Please enter the Password."></td>
                    </tr>
                    <tr>
                        <td align="right">Confirm Password: <span class="redtext">*</span></td>
                        <td><cfinput type="password" name="confirm_password" id="confirm_password" value="#FORM.confirm_password#" size="20" maxlength="15" required="yes" validate="noblanks" message="Please confirm the Password."></td>
                    </tr>
                </cfif>
                    
				<cfif listFind("1,2,3,4", CLIENT.userType)>
                    <tr><td colspan=2><cfinput type="checkbox" name="changepass" value="1" checked="#yesNoFormat(FORM.changepass EQ 1)#"> Force user to change password on next login.</td></tr>
                    <tr><td colspan=2><cfinput type="checkbox" name="bypass_checklist" value="1" checked="#yesNoFormat(FORM.bypass_checklist EQ 1)#"> This agents students apps do not need to pass the checklist when processed.</td></tr>
                </cfif>
				<cfif CLIENT.usertype EQ 1>
                    <tr><td colspan=2><cfinput type="checkbox" name="invoice_access" value="1" checked="#yesNoFormat(FORM.invoice_access EQ 1)#"> User has invoice access.</td></tr>
                </cfif>
				<tr>
                	<td colspan=2>&nbsp;</td>
                </tr>
				<tr>
                	<td colspan=2 bgcolor="CCCCCC"><u>Contract Information</u></td>
                </tr>
              <tr>
                <td align="right">User Entered:</td>
                <td>
					#DateFormat(FORM.datecreated, 'mm/dd/yyyy')#
                    <input type="hidden" name="datecreated" value="#FORM.datecreated#">
                </td>
              </tr>
             
              <tr>
                <td align="right">Contract Received:</td>
                <td>
                    <cfif listFind("1,2,3,4", CLIENT.userType)>
                        <cfinput type="text" name="date_contract_received" value="#dateFormat(FORM.date_contract_received,'mm/dd/yyyy')#" class="datePicker" maxlength="10" validate="date" message="Please enter a valid Contract Received."> mm/dd/yyyy
                    <cfelse>
                        #dateFormat(FORM.date_contract_received, 'mm/dd/yyyy')#
	                    <input type="hidden" name="date_contract_received" value="#FORM.date_contract_received#">
                    </cfif>
                </td>
              </tr>
              <tr>
                <td align="right">Active:</td>
                <td>
                    <cfif listFind("1,2,3,4", CLIENT.userType)>
                        <cfinput type="checkbox" name="active" value="1" checked="#yesNoFormat(FORM.active EQ 1)#">
                    <cfelse>
                        #yesNoFormat(FORM.active)#
	                    <input type="hidden" name="active" value="#FORM.active#">
                    </cfif>
                </td>
              </tr> 
              <tr>
                <td align="right">Date Cancelled:</td>
                <td>
                    <cfif listFind("1,2,3,4", CLIENT.userType)>
                        <cfinput type="text" name="dateCancelled" value="#dateFormat(FORM.dateCancelled,'mm/dd/yyyy')#" maxlength="10" class="datePicker" validate="date" message="Please enter a valid Date Cancelled."> mm/dd/yyyy
                    <cfelse>
						#dateFormat(FORM.dateCancelled, 'mm/dd/yyyy')#
                        <input type="hidden" name="dateCancelled" value="#FORM.dateCancelled#">
                    </cfif>
                </td>
              </tr>
			</table>
            
		</td>
	</tr>
</table>
    
<!---- Int. Reps ---->
<cfif FORM.usertype EQ 8>

    <table border="0" width="100%">
        <tr bgcolor="CCCCCC">
            <td colspan="2"><u>Billing Info</u> <input type="checkbox" name="copycontact" OnClick="CopyContact();">Copy personal information:</td>
        </tr>
        <tr>
        	<td>&nbsp;</td>
            <td><cfinput type="checkbox" name="usebilling" value="1" checked="#yesNoFormat(FORM.usebilling EQ 1)#">Use billing address on invoice</td>
        </tr>
      <tr>
        <td align="right">Company Name:</td>
        <td><cfinput type="text" name="billing_company" value="#billing_company#" size="40" maxlength="50"></td>
      </tr>
        <tr>
        <td align="right">Contact:</td>
        <td><cfinput type="text" name="billing_contact" value="#billing_contact#" size="40" maxlength="100"></td>
      </tr>
      <tr>
        <td align="right">Address:</td>
        <td><cfinput type="text" name="billing_address" value="#billing_address#" size="40" maxlength="100"></td>
      </tr>
      <tr>
        <td align="right"></td>
        <td><cfinput type="text" name="billing_address2" value="#billing_address2#" size="40" maxlength="100"></td>
      </tr>
      <tr>
        <td align="right">City:</td>
        <td><cfinput type="text" name="billing_city" value="#billing_city#" size="20" maxlength="100"></td>
      </tr>
      <tr>				  
        <td align="right">Country:</td>
        <td>
            <cfselect NAME="billing_country" query="country_list" value="countryid" display="countryname" selected="#FORM.billing_country#" queryPosition="below">
                <option value=""></option>
            </cfselect>
        </td>
        </tr>
      <tr>
        <td align="right">Postal Code (Zip):</td>
        <td><cfinput type="text" name="billing_zip" value="#billing_zip#" size="10" maxlength="20"></td>
      </tr>
      <tr>
        <td align="right">Phone:</td>
        <td><cfinput type="text" name="billing_phone" value="#billing_phone#" size="20" maxlength="20"></td>
      </tr>
      <tr>
        <td align="right">Fax:</td>
        <td><cfinput type="text" name="billing_fax" value="#billing_fax#" size="20" maxlength="20"></td>
      </tr>
      <tr>
        <td align="right">Email:</td>
        <td><cfinput type="text" name="billing_email" value="#billing_email#" size="30" maxlength="100" validate="email" message="Please enter a valid Billing Info Email."></td>
      </tr>
    </table>

</cfif>

<cfif listFind("1,2,3,4", CLIENT.userType) or CLIENT.usertype lt FORM.usertype>

    <br>
    <table width=100%>
        <tr bgcolor="CCCCCC">
            <td><u>Notes / Misc Info</u></td>
        </tr>
        <tr align="center">
            <td><cftextarea cols="100" rows="7" name="comments" value="#FORM.comments#" /></td>
        </tr>
    </table>

</cfif>

	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><img src="pics/submit.gif" style="cursor:pointer" onclick="verifyAddress();" /></td>
	</tr>
</table>

</cfform>

<cfinclude template="../table_footer.cfm">

</cfoutput>